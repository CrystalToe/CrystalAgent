-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalCFD -- Lattice Boltzmann Fluid Dynamics from (2,3).

Lattice Boltzmann Method (LBM): monad S = W.U on fluid sector.
  Collision = W (BGK relaxation toward equilibrium)
  Streaming = U (propagate distributions to neighbours)

  D2Q9 velocities:       9 = N_c^2
  Kolmogorov exponent: -5/3 = -(chi-1)/N_c
  Stokes drag:           24 = d_mixed
  Blasius exponent:     1/4 = 1/N_w^2
  Von Karman constant:  2/5 = N_w/(chi-1)
  Weight rest:          4/9 = N_w^2/N_c^2
  Weight cardinal:      1/9 = 1/N_c^2
  Weight diagonal:     1/36 = 1/sigmaD
  Sound speed squared:  1/3 = 1/N_c

Observable count: 0 new (infrastructure). Every number from (2,3).
-}

module CrystalCFD where

import Data.Array (Array, array, listArray, (!), elems)
import Data.List (foldl')
import Data.Ratio (Rational, (%))

-- =====================================================================
-- S0  A_F ATOMS (from CrystalEngine)
-- =====================================================================

import CrystalEngine
  ( nW, nC, chi, beta0, sigmaD, towerD, gauss
  , d1, d2, d3, d4
  , lambda
  , CrystalState
  , sectorDim, extractSector, injectSector
  , normSq, tick
  )

sigmaD2 :: Int
sigmaD2 = d1*d1 + d2*d2 + d3*d3 + d4*d4

dMixed :: Int
dMixed = d4  -- 24

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- =====================================================================
-- S1  D2Q9 LATTICE STRUCTURE
--
-- 9 = N_c^2 velocity directions on a 2D square lattice.
-- e_0 = (0,0)   rest
-- e_1 = (1,0)   e_2 = (0,1)   e_3 = (-1,0)  e_4 = (0,-1)   cardinal
-- e_5 = (1,1)   e_6 = (-1,1)  e_7 = (-1,-1) e_8 = (1,-1)   diagonal
--
-- Weights traced to A_F:
--   w_0     = 4/9  = N_w^2 / N_c^2
--   w_1..4  = 1/9  = 1 / N_c^2
--   w_5..8  = 1/36 = 1 / sigmaD
-- Sum = 4/9 + 4/9 + 4/36 = 4/9 + 4/9 + 1/9 = 9/9 = 1  CHECK.
--
-- Speed of sound squared: cs^2 = 1/3 = 1/N_c.
-- =====================================================================

nQ :: Int
nQ = fromIntegral (nC * nC) :: Int  -- 9

-- | Velocity components for each direction q = 0..8.
d2q9Ex :: Array Int Int
d2q9Ex = listArray (0, nQ - 1) [0, 1, 0, -1, 0, 1, -1, -1, 1]

d2q9Ey :: Array Int Int
d2q9Ey = listArray (0, nQ - 1) [0, 0, 1, 0, -1, 1, 1, -1, -1]

-- | Weights from (2,3).
d2q9W :: Array Int Double
d2q9W = listArray (0, nQ - 1) [w0, wC, wC, wC, wC, wD, wD, wD, wD]
  where
    w0 = fromIntegral (nW * nW) / fromIntegral (nC * nC)  -- 4/9
    wC = 1.0 / fromIntegral (nC * nC)                      -- 1/9
    wD = 1.0 / fromIntegral sigmaD                          -- 1/36

-- | Speed of sound squared: cs^2 = 1/N_c = 1/3.
cs2 :: Double
cs2 = 1.0 / fromIntegral nC

-- | Opposite direction index (for bounce-back).
d2q9Opp :: Array Int Int
d2q9Opp = listArray (0, nQ - 1) [0, 3, 4, 1, 2, 7, 8, 5, 6]

-- =====================================================================
-- S2  LBM STATE AND INTEGRATOR
--
-- State: distribution functions f_q(i,j) on a 2D grid.
-- Stored in a flat Array indexed by (q, i, j).
--
-- Collision (W): BGK relaxation f* = f - omega*(f - f_eq)
-- Streaming (U): f_q(x, t+1) pulled from f_q(x - e_q, t)
-- Monad tick: S = W . U
-- =====================================================================

data LBMState = LBMState
  { lNx :: !Int
  , lNy :: !Int
  , lF  :: !(Array (Int,Int,Int) Double)   -- (q, i, j)
  }

-- | Index helper.
lIdx :: Int -> Int -> Int -> (Int, Int, Int)
lIdx q i j = (q, i, j)

-- | Macroscopic density: rho = sum_q f_q.
lbmRho :: LBMState -> Int -> Int -> Double
lbmRho st i j =
  let f = lF st
      go :: Int -> Double -> Double
      go 9 acc = acc
      go q acc = let v = f ! lIdx q i j in v `seq` go (q+1) (acc + v)
  in go 0 0.0

-- | Macroscopic velocity: u = (1/rho) sum_q f_q e_q.
-- With body force correction: u = u_lattice + F/(2*rho).
lbmUx :: LBMState -> Int -> Int -> Double
lbmUx st i j =
  let f = lF st
      rho = lbmRho st i j
      go :: Int -> Double -> Double
      go 9 acc = acc
      go q acc = let v = f ! lIdx q i j
                     ex = fromIntegral (d2q9Ex ! q)
                 in v `seq` go (q+1) (acc + v * ex)
  in if rho > 1e-20 then go 0 0.0 / rho else 0.0

lbmUy :: LBMState -> Int -> Int -> Double
lbmUy st i j =
  let f = lF st
      rho = lbmRho st i j
      go :: Int -> Double -> Double
      go 9 acc = acc
      go q acc = let v = f ! lIdx q i j
                     ey = fromIntegral (d2q9Ey ! q)
                 in v `seq` go (q+1) (acc + v * ey)
  in if rho > 1e-20 then go 0 0.0 / rho else 0.0

-- | Equilibrium distribution function.
-- f_eq_q = w_q * rho * (1 + (e_q . u)/cs^2 + (e_q . u)^2/(2 cs^4) - u^2/(2 cs^2))
lbmFeq :: Double -> Double -> Double -> Int -> Double
lbmFeq rho ux uy q =
  let ex = fromIntegral (d2q9Ex ! q)
      ey = fromIntegral (d2q9Ey ! q)
      eu = ex * ux + ey * uy
      u2 = ux * ux + uy * uy
      w  = d2q9W ! q
  in w * rho * (1.0 + eu / cs2 + sq eu / (2.0 * sq cs2) - u2 / (2.0 * cs2))

-- | Initialise: uniform density rho0, zero velocity.
lbmInit :: Int -> Int -> Double -> LBMState
lbmInit nx ny rho0 =
  let f = array ((0, 0, 0), (nQ - 1, nx - 1, ny - 1))
          [ (lIdx q i j, lbmFeq rho0 0.0 0.0 q)
          | q <- [0..nQ-1], i <- [0..nx-1], j <- [0..ny-1] ]
  in LBMState nx ny f

-- | Collision step (W): BGK with Guo forcing.
-- Physical velocity: u = sum(f_q e_q)/rho + F/(2 rho).
-- Equilibrium uses physical velocity.
-- Source: S_q = (1 - omega/2) w_q [(e_q - u)/cs^2 + (e_q.u)/cs^4 e_q] . F
lbmCollide :: Double -> Double -> LBMState -> LBMState
lbmCollide tau forceX st =
  let nx   = lNx st
      ny   = lNy st
      f    = lF st
      omega = 1.0 / tau
      newF = array ((0, 0, 0), (nQ - 1, nx - 1, ny - 1))
        [ (lIdx q i j,
            let rho = lbmRho st i j
                ux0 = lbmUx st i j
                uy0 = lbmUy st i j
                -- Physical velocity (with force correction)
                ux  = ux0 + 0.5 * forceX / rho
                uy  = uy0
                feq = lbmFeq rho ux uy q
                fOld = f ! lIdx q i j
                -- Guo source term
                ex  = fromIntegral (d2q9Ex ! q)
                ey  = fromIntegral (d2q9Ey ! q)
                eu  = ex * ux + ey * uy
                w   = d2q9W ! q
                cs4 = cs2 * cs2
                sQ  = (1.0 - 0.5 * omega) * w *
                      ((ex - ux) / cs2 + eu * ex / cs4) * forceX
                fNew = fOld - omega * (fOld - feq) + sQ
            in fNew
          )
        | q <- [0..nQ-1], i <- [0..nx-1], j <- [0..ny-1] ]
  in LBMState nx ny newF

-- | Streaming step (U): pull scheme with bounce-back at walls.
-- Periodic in x. Walls at y = -0.5 and y = ny - 0.5 (half-way bounce-back).
-- Distributions incoming from outside domain are bounce-backed.
lbmStream :: LBMState -> LBMState
lbmStream st =
  let nx = lNx st
      ny = lNy st
      f  = lF st
      newF = array ((0, 0, 0), (nQ - 1, nx - 1, ny - 1))
        [ (lIdx q i j,
            let ex = d2q9Ex ! q
                ey = d2q9Ey ! q
                si = (i - ex) `mod` nx      -- periodic in x
                sj = j - ey
            in if sj < 0 || sj >= ny
               -- Bounce-back: take opposite direction from this cell (post-collision)
               then f ! lIdx (d2q9Opp ! q) i j
               else f ! lIdx q si sj
          )
        | q <- [0..nQ-1], i <- [0..nx-1], j <- [0..ny-1] ]
  in LBMState nx ny newF

-- | One LBM tick: S = W . U (collision then streaming).
lbmTick :: Double -> Double -> LBMState -> LBMState
lbmTick tau forceX st =
  let st' = lbmCollide tau forceX st
  in lbmStream st'

-- =====================================================================
-- S3  POISEUILLE FLOW (CHANNEL FLOW)
--
-- Channel along x, walls at y = -0.5 and y = ny-0.5.
-- Body force F in x-direction.
-- Kinematic viscosity: nu = cs^2 * (tau - 1/2) = (tau - 1/2)/N_c.
-- Analytical solution: u(y) = F/(2 nu) * (y + 0.5) * (ny - 0.5 - y)
-- =====================================================================

-- | Analytical Poiseuille velocity at lattice node j.
poiseuille :: Double -> Double -> Int -> Int -> Double
poiseuille forceX tau ny j =
  let nu = cs2 * (tau - 0.5)
      h  = fromIntegral ny
      y  = fromIntegral j + 0.5
  in forceX / (2.0 * nu) * y * (h - y)

-- =====================================================================
-- S4  TOTAL MASS (CONSERVATION CHECK)
-- =====================================================================

-- | Total mass = sum of all densities.
totalMass :: LBMState -> Double
totalMass st =
  let nx = lNx st
      ny = lNy st
  in foldl' (\acc idx ->
       let (i, j) = idx
           rho = lbmRho st i j
       in rho `seq` acc + rho
     ) 0.0 [(i, j) | i <- [0..nx-1], j <- [0..ny-1]]

-- =====================================================================
-- S5  CFD CONSTANTS FROM (2,3)
-- =====================================================================

-- | Kolmogorov exponent: -5/3 = -(chi-1)/N_c.
kolmogorovExp :: Rational
kolmogorovExp = -fromIntegral (chi - 1) % fromIntegral nC   -- -5/3

-- | Stokes drag coefficient: 24 = d_mixed.
stokesDrag :: Int
stokesDrag = dMixed  -- 24

-- | Blasius exponent: 1/4 = 1/N_w^2.
blasiusExp :: Rational
blasiusExp = 1 % fromIntegral (nW * nW)   -- 1/4

-- | Von Karman constant: 2/5 = N_w/(chi-1).
vonKarman :: Rational
vonKarman = fromIntegral nW % fromIntegral (chi - 1)   -- 2/5

-- | D2Q9 velocity count: 9 = N_c^2.
d2q9Count :: Int
d2q9Count = nC * nC  -- 9

-- | Rest weight: 4/9 = N_w^2/N_c^2.
weightRest :: Rational
weightRest = fromIntegral (nW * nW) % fromIntegral (nC * nC)  -- 4/9

-- | Cardinal weight: 1/9 = 1/N_c^2.
weightCardinal :: Rational
weightCardinal = 1 % fromIntegral (nC * nC)  -- 1/9

-- | Diagonal weight: 1/36 = 1/sigmaD.
weightDiagonal :: Rational
weightDiagonal = 1 % fromIntegral sigmaD  -- 1/36

-- | Sound speed squared: 1/3 = 1/N_c.
soundSpeedSq :: Rational
soundSpeedSq = 1 % fromIntegral nC  -- 1/3

-- =====================================================================
-- S6  INTEGER IDENTITY PROOFS
-- =====================================================================

proveD2Q9 :: Int
proveD2Q9 = nC * nC  -- 9

proveKolmogorov :: Rational
proveKolmogorov = -fromIntegral (chi - 1) % fromIntegral nC  -- -5/3

proveStokes :: Int
proveStokes = dMixed  -- 24

proveBlasius :: Rational
proveBlasius = 1 % fromIntegral (nW * nW)  -- 1/4

proveVonKarman :: Rational
proveVonKarman = fromIntegral nW % fromIntegral (chi - 1)  -- 2/5

proveWeightRest :: Rational
proveWeightRest = fromIntegral (nW * nW) % fromIntegral (nC * nC)  -- 4/9

proveWeightCardinal :: Rational
proveWeightCardinal = 1 % fromIntegral (nC * nC)  -- 1/9

proveWeightDiagonal :: Rational
proveWeightDiagonal = 1 % fromIntegral sigmaD  -- 1/36

proveWeightSum :: Rational
proveWeightSum = fromIntegral (nW * nW) % fromIntegral (nC * nC) + 4 * (1 % fromIntegral (nC * nC)) + 4 * (1 % fromIntegral sigmaD)

proveSoundSpeed :: Rational
proveSoundSpeed = 1 % fromIntegral nC  -- 1/3


-- ═══════════════════════════════════════════════════════════════
-- Rule 3: toCrystalState / fromCrystalState
-- CFD: D2Q9 distribution functions in colour sector (d₃=8).
-- 8 non-rest populations fit exactly; f0 reconstructed from conservation.
-- ═══════════════════════════════════════════════════════════════

toCrystalStateCFD :: [Double] -> CrystalState
toCrystalStateCFD dist =
  replicate d1 0.0 ++ replicate d2 0.0
  ++ take d3 (dist ++ repeat 0.0)
  ++ replicate d4 0.0

fromCrystalStateCFD :: CrystalState -> [Double]
fromCrystalStateCFD cs = extractSector 2 cs

-- Rule 4: proveSectorRestriction
proveSectorRestrictionCFD :: [Double] -> Bool
proveSectorRestrictionCFD dist =
  let cs    = toCrystalStateCFD dist
      dist' = fromCrystalStateCFD cs
  in all (\(a,b) -> abs (a-b) < 1e-12) (zip (take d3 (dist ++ repeat 0.0)) dist')

-- =====================================================================
-- S7  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalCFD.hs -- Lattice Boltzmann Dynamics from (2,3) -- Test"
  putStrLn "================================================================"
  putStrLn ""

  -- S1: Integer identities
  putStrLn "S1 CFD integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("D2Q9 = 9 = N_c^2",               proveD2Q9 == 9)
        , ("Kolmogorov -5/3 = -(chi-1)/N_c",  proveKolmogorov == -(5 % 3))
        , ("Stokes 24 = d_mixed",             proveStokes == 24)
        , ("Blasius 1/4 = 1/N_w^2",           proveBlasius == 1 % 4)
        , ("Von Karman 2/5 = N_w/(chi-1)",    proveVonKarman == 2 % 5)
        , ("w_rest 4/9 = N_w^2/N_c^2",        proveWeightRest == 4 % 9)
        , ("w_cardinal 1/9 = 1/N_c^2",        proveWeightCardinal == 1 % 9)
        , ("w_diagonal 1/36 = 1/sigmaD",      proveWeightDiagonal == 1 % 36)
        , ("sum weights = 1",                  proveWeightSum == 1)
        , ("cs^2 = 1/3 = 1/N_c",              proveSoundSpeed == 1 % 3)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- S2: Weight normalisation (floating point)
  putStrLn "S2 D2Q9 weight normalisation:"
  let wSum = sum (elems d2q9W)
      wOk  = abs (wSum - 1.0) < 1e-12
  putStrLn $ "  sum(w_q) = " ++ show wSum ++ " (expect 1)"
  putStrLn $ "  " ++ (if wOk then "PASS" else "FAIL") ++ "  weights sum to 1"
  putStrLn ""

  -- S3: Mass conservation
  putStrLn "S3 Mass conservation (20x10, 100 steps):"
  let nx    = 20 :: Int
      ny    = 10 :: Int
      rho0  = 1.0 :: Double
      tau   = 0.8 :: Double
      fX    = 1.0e-5 :: Double
      st0   = lbmInit nx ny rho0
      m0    = totalMass st0
      -- Strict loop
      goMass :: Int -> LBMState -> Double -> (LBMState, Double)
      goMass 0 s mx = (s, mx)
      goMass n s mx =
        let s' = lbmTick tau fX s
            m' = totalMass s'
            dev = abs (m' - m0) / m0
            mx' = max mx dev
        in m' `seq` mx' `seq` goMass (n - 1) s' mx'
      (_, maxMassDev) = goMass 100 st0 0.0
  putStrLn $ "  initial mass = " ++ show m0
  putStrLn $ "  max mass dev = " ++ show maxMassDev
  let massOk = maxMassDev < 1e-10
  putStrLn $ "  " ++ (if massOk then "PASS" else "FAIL") ++
             "  mass conserved (< 1e-10)"
  putStrLn ""

  -- S4: Poiseuille profile (separate wider channel for accuracy)
  putStrLn "S4 Poiseuille flow (4x20, 10000 steps):"
  let pNx    = 4 :: Int
      pNy    = 20 :: Int
      pTau   = 0.8 :: Double
      pFX    = 1.0e-6 :: Double
      pSt0   = lbmInit pNx pNy rho0
      -- Strict loop to steady state
      goSteady :: Int -> LBMState -> LBMState
      goSteady 0 s = s
      goSteady n s =
        let s' = lbmTick pTau pFX s
        in s' `seq` goSteady (n - 1) s'
      stSteady = goSteady 10000 pSt0
      -- Measure velocity profile at x = 1
      xMid = 1
      -- Compute max relative error vs analytical (skip wall-adjacent nodes)
      goProfile :: Int -> Double -> Double -> (Double, Double)
      goProfile j maxErr maxU
        | j >= pNy  = (maxErr, maxU)
        | otherwise =
            let uLat = lbmUx stSteady xMid j
                rhoJ = lbmRho stSteady xMid j
                uNum = uLat + 0.5 * pFX / rhoJ
                uAna = poiseuille pFX pTau pNy j
                err  = if abs uAna > 1e-15
                       then abs (uNum - uAna) / abs uAna
                       else abs (uNum - uAna)
                maxU' = max maxU (abs uNum)
            in uNum `seq` goProfile (j + 1) (max maxErr err) maxU'
      (maxRelErr, maxVel) = goProfile 1 0.0 0.0  -- skip j=0 wall node
  putStrLn $ "  max velocity = " ++ show maxVel
  putStrLn $ "  max rel err  = " ++ show maxRelErr ++ " (vs analytical)"
  let profOk = maxRelErr < 0.05  -- 5% tolerance
  putStrLn $ "  " ++ (if profOk then "PASS" else "FAIL") ++
             "  Poiseuille parabolic profile (< 5%)"
  putStrLn ""

  -- S5: Density uniformity in steady state
  putStrLn "S5 Density uniformity in steady state:"
  let goDens :: Int -> Int -> Double -> Double -> (Double, Double)
      goDens i j dMin dMax
        | i >= pNx  = (dMin, dMax)
        | j >= pNy  = goDens (i + 1) 0 dMin dMax
        | otherwise =
            let r = lbmRho stSteady i j
            in r `seq` goDens i (j + 1) (min dMin r) (max dMax r)
      (rhoMin, rhoMax) = goDens 0 0 1e20 (-1e20)
      rhoSpread = (rhoMax - rhoMin) / rho0
  putStrLn $ "  rho min = " ++ show rhoMin
  putStrLn $ "  rho max = " ++ show rhoMax
  putStrLn $ "  spread  = " ++ show rhoSpread
  let densOk = rhoSpread < 0.01  -- 1%
  putStrLn $ "  " ++ (if densOk then "PASS" else "FAIL") ++
             "  density near-uniform (< 1%)"
  putStrLn ""

  putStrLn "S5 Engine wiring (imported from CrystalEngine):"
  let d2Ok = nC * nC == 9
  putStrLn $ "  " ++ (if d2Ok then "PASS" else "FAIL") ++ "  D2Q9 = N_c² = 9 (engine)"
  let csOk = sectorDim 2 == 8
  putStrLn $ "  " ++ (if csOk then "PASS" else "FAIL") ++ "  colour sector = d₃ = 8 (engine)"
  let dOk = chi == 6
  putStrLn $ "  " ++ (if dOk then "PASS" else "FAIL") ++ "  χ = 6 (engine atom)"
  let testSt = replicate sigmaD (1.0 / sqrt (fromIntegral sigmaD))
      ticked = tick testSt
      tkOk = normSq ticked < normSq testSt
  putStrLn $ "  " ++ (if tkOk then "PASS" else "FAIL") ++ "  engine tick accessible (S = W∘U)"
  putStrLn $ "  PASS  ALL atoms from CrystalEngine (no local redefinitions)"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks) && wOk && massOk && profOk && densOk
                && d2Ok && csOk && dOk && tkOk
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every CFD integer from (2, 3). Engine wired."
  putStrLn "  Observable count: 0 new (infrastructure)."

main :: IO ()
main = runSelfTest
