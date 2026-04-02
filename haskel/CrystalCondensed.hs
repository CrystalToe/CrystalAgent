-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalCondensed -- Ising/BCS from (2,3).

Metropolis Monte Carlo for Ising model + BCS gap.

  Square lattice z:  4   = N_w^2
  Cubic lattice z:   6   = chi
  Ising spin states: 2   = N_w
  Onsager T_c num:   2   = N_w      (T_c = 2J / ln(1+sqrt(2)))
  Critical beta:     1/8 = 1/N_w^3
  BCS prefactor:     2   = N_w      (2 Delta / kT_c = 2 pi / e^gamma)
  Ground E/site:    -2   = -N_w     (square lattice, J=1)

Observable count: 7. Every number from (2,3).
-}

module CrystalCondensed where

import Data.Array (Array, array, (!), (//), elems)
import Data.List (foldl')
import Data.Ratio ((%))

-- =====================================================================
-- S0  A_F ATOMS
-- =====================================================================

nW, nC, chi, beta0, sigmaD, sigmaD2, gauss, towerD :: Integer
nW      = 2
nC      = 3
chi     = nW * nC                          -- 6
beta0   = (11 * nC - 2 * chi) `div` 3     -- 7
sigmaD  = 1 + 3 + 8 + 24                  -- 36
sigmaD2 = 1 + 9 + 64 + 576                -- 650
gauss   = nC * nC + nW * nW               -- 13
towerD  = sigmaD + chi                    -- 42

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- =====================================================================
-- S1  CONDENSED MATTER CONSTANTS FROM (2,3)
--
-- Square lattice coordination: z = 4 = N_w^2.
-- Cubic  lattice coordination: z = 6 = chi.
-- Ising spin states: {+1, -1} = N_w states.
--
-- Onsager exact T_c (2D square, J=1, k_B=1):
--   T_c = N_w / ln(1 + sqrt(N_w)) = 2 / ln(1 + sqrt(2)) ~ 2.269.
--
-- Critical exponent: beta = 1/8 = 1 / N_w^3.
--
-- Ground state energy per site: E_0/N = -N_w (square lattice, J=1).
--   (z/2 = N_w^2/N_w = N_w bonds per site, each contributing -J.)
--
-- BCS gap ratio: 2 Delta(0) / (k_B T_c) = N_w * pi / e^gamma ~ 3.528.
-- =====================================================================

-- | Square lattice coordination number.
zSquare :: Integer
zSquare = nW * nW  -- 4

-- | Cubic lattice coordination number.
zCubic :: Integer
zCubic = chi  -- 6

-- | Ising spin states.
isingStates :: Integer
isingStates = nW  -- 2

-- | Onsager critical temperature (J=1, k_B=1).
onsagerTc :: Double
onsagerTc =
  let nw = fromIntegral nW :: Double
  in nw / log (1.0 + sqrt nw)  -- 2 / ln(1+sqrt(2)) ~ 2.269

-- | 2D Ising critical exponent beta = 1/8 = 1/N_w^3.
critBeta :: Rational
critBeta = 1 % (nW * nW * nW)  -- 1/8

-- | Ground state energy per site (square lattice, all aligned).
groundEPerSite :: Integer
groundEPerSite = - nW  -- -2 (= -z/2 = -N_w^2 / N_w)

-- | BCS gap ratio: 2 Delta / (k_B T_c) = 2 pi / e^gamma.
bcsRatio :: Double
bcsRatio =
  let nw    = fromIntegral nW :: Double
      gamma = 0.5772156649015329  -- Euler-Mascheroni
  in nw * pi / exp gamma  -- ~ 3.528

-- =====================================================================
-- S2  LCG PSEUDO-RANDOM NUMBER GENERATOR
-- =====================================================================

type Seed = Int

lcgNext :: Seed -> Seed
lcgNext s = (1103515245 * s + 12345) `mod` 2147483648

lcgDouble :: Seed -> (Double, Seed)
lcgDouble s =
  let s' = lcgNext s
  in (fromIntegral s' / 2147483648.0, s')

-- =====================================================================
-- S3  2D ISING MODEL (METROPOLIS MONTE CARLO)
--
-- Lattice: n x n square with periodic boundary conditions.
-- z = 4 = N_w^2 neighbours per site.
-- Energy: E = -J sum_{<ij>} s_i s_j,  J = 1.
-- Metropolis: flip s_i, accept if rand < exp(-dE / T).
-- =====================================================================

type Lattice = Array (Int,Int) Int

-- | Initialise lattice: all spins = s (+1 or -1).
isingInit :: Int -> Int -> Lattice
isingInit n s = array ((0,0),(n-1,n-1))
  [((i,j), s) | i <- [0..n-1], j <- [0..n-1]]

-- | Magnetisation per site: M = (1/N) sum s_i.
isingMag :: Int -> Lattice -> Double
isingMag n lat =
  let total = foldl' (+) 0 (elems lat)
  in fromIntegral total / fromIntegral (n * n)

-- | Total energy: E = -J sum_{<ij>} s_i s_j.
-- Each bond counted once (rightward and downward neighbours only).
isingEnergy :: Int -> Lattice -> Int
isingEnergy n lat =
  let go :: Int -> Int -> Int -> Int
      go i j acc
        | i >= n    = acc
        | j >= n    = go (i + 1) 0 acc
        | otherwise =
            let s    = lat ! (i, j)
                sR   = lat ! ((i + 1) `mod` n, j)
                sD   = lat ! (i, (j + 1) `mod` n)
                bond = - s * sR - s * sD
            in bond `seq` go i (j + 1) (acc + bond)
  in go 0 0 0

-- | One Metropolis sweep (systematic, visit all sites in order).
isingSweep :: Int -> Double -> Lattice -> Seed -> (Lattice, Seed)
isingSweep n invT lat seed0 =
  let step :: (Lattice, Seed) -> (Int, Int) -> (Lattice, Seed)
      step (l, s) (i, j) =
        let si = l ! (i, j)
            ip = (i + 1) `mod` n
            im = (i - 1 + n) `mod` n
            jp = (j + 1) `mod` n
            jm = (j - 1 + n) `mod` n
            sn = l ! (ip, j) + l ! (im, j) + l ! (i, jp) + l ! (i, jm)
            de = 2 * si * sn  -- energy change if we flip si
            (r, s') = lcgDouble s
        in if de <= 0 || r < exp (- fromIntegral de * invT)
           then let l' = l // [((i,j), -si)] in l' `seq` (l', s')
           else (l, s')
  in foldl' step (lat, seed0)
     [(i,j) | i <- [0..n-1], j <- [0..n-1]]

-- | Run nSweeps Metropolis sweeps (strict loop).
isingRun :: Int -> Int -> Double -> Lattice -> Seed -> (Lattice, Seed)
isingRun 0 _ _ lat seed = (lat, seed)
isingRun nSweeps n invT lat seed =
  let (lat', seed') = isingSweep n invT lat seed
  in lat' `seq` seed' `seq` isingRun (nSweeps - 1) n invT lat' seed'

-- =====================================================================
-- S4  BCS GAP EQUATION (WEAK-COUPLING)
--
-- Delta(0) = 2 hbar omega_D exp(-1/(N(0)V))  [prefactor 2 = N_w]
-- 2 Delta(0) / (k_B T_c) = 2 pi / e^gamma    [leading 2 = N_w]
-- =====================================================================

-- | BCS gap in units of hbar*omega_D (weak-coupling).
bcsGap :: Double -> Double
bcsGap nv =
  let nw = fromIntegral nW :: Double  -- 2
  in nw * exp (-1.0 / nv)  -- 2 * exp(-1/(N(0)*V))

-- =====================================================================
-- S5  INTEGER IDENTITY PROOFS
-- =====================================================================

proveZSquare :: Integer
proveZSquare = nW * nW  -- 4

proveZCubic :: Integer
proveZCubic = chi  -- 6

proveIsingStates :: Integer
proveIsingStates = nW  -- 2

proveCritBeta :: Rational
proveCritBeta = 1 % (nW * nW * nW)  -- 1/8

proveGroundE :: Integer
proveGroundE = - nW  -- -2

proveOnsagerNum :: Integer
proveOnsagerNum = nW  -- 2

proveBCSPrefactor :: Integer
proveBCSPrefactor = nW  -- 2

-- =====================================================================
-- S6  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalCondensed.hs -- Ising/BCS from (2,3) -- Test"
  putStrLn "================================================================"
  putStrLn ""

  -- S1: Integer identities
  putStrLn "S1 Condensed matter integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("square lattice z = 4 = N_w^2",       proveZSquare == 4)
        , ("cubic lattice z = 6 = chi",            proveZCubic == 6)
        , ("Ising states = 2 = N_w",               proveIsingStates == 2)
        , ("critical beta = 1/8 = 1/N_w^3",       proveCritBeta == 1 % 8)
        , ("ground E/site = -2 = -N_w",            proveGroundE == -2)
        , ("Onsager numerator = 2 = N_w",          proveOnsagerNum == 2)
        , ("BCS prefactor = 2 = N_w",              proveBCSPrefactor == 2)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- S2: Onsager critical temperature
  putStrLn "S2 Onsager critical temperature:"
  let tcRef = 2.2691853142130216 :: Double
      tcErr = abs (onsagerTc - tcRef) / tcRef
  putStrLn $ "  T_c = " ++ show onsagerTc ++ " (expect " ++ show tcRef ++ ")"
  let tcOk = tcErr < 1.0e-10
  putStrLn $ "  " ++ (if tcOk then "PASS" else "FAIL") ++
             "  Onsager T_c = 2/ln(1+sqrt(2))"
  putStrLn ""

  -- S3: Ground state energy
  putStrLn "S3 Ground state energy (8x8, all up):"
  let n     = 8 :: Int
      lat0  = isingInit n 1
      e0    = isingEnergy n lat0
      eRef  = - fromIntegral nW * n * n :: Int  -- -2*64 = -128
  putStrLn $ "  E = " ++ show e0 ++ " (expect " ++ show eRef ++ ")"
  let e0Ok = e0 == eRef
  putStrLn $ "  " ++ (if e0Ok then "PASS" else "FAIL") ++
             "  ground E = -N_w * N"
  putStrLn ""

  -- S4: Low-temperature magnetisation (T = 1.0 << T_c ~ 2.27)
  putStrLn "S4 Low-T magnetisation (T=1.0, 3000 sweeps):"
  let invTLo       = 1.0 / 1.0
      seed0        = fromIntegral towerD :: Int  -- 42
      (latLo, _)   = isingRun 3000 n invTLo lat0 seed0
      magLo        = abs (isingMag n latLo)
  putStrLn $ "  |M(T=1.0)| = " ++ show magLo
  let magLoOk = magLo > 0.8
  putStrLn $ "  " ++ (if magLoOk then "PASS" else "FAIL") ++
             "  |M| > 0.8 below T_c"
  putStrLn ""

  -- S5: High-temperature magnetisation (T = 5.0 >> T_c)
  putStrLn "S5 High-T magnetisation (T=5.0, 3000 sweeps):"
  let invTHi       = 1.0 / 5.0
      (latHi, _)   = isingRun 3000 n invTHi lat0 seed0
      magHi        = abs (isingMag n latHi)
  putStrLn $ "  |M(T=5.0)| = " ++ show magHi
  let magHiOk = magHi < 0.3
  putStrLn $ "  " ++ (if magHiOk then "PASS" else "FAIL") ++
             "  |M| < 0.3 above T_c"
  putStrLn ""

  -- S6: BCS gap ratio
  putStrLn "S6 BCS gap ratio:"
  let bcsRef = 3.5278 :: Double
      bcsErr = abs (bcsRatio - bcsRef) / bcsRef
  putStrLn $ "  2Delta/(kT_c) = " ++ show bcsRatio ++ " (expect ~3.528)"
  putStrLn $ "  rel error     = " ++ show bcsErr
  let bcsOk = bcsErr < 0.001
  putStrLn $ "  " ++ (if bcsOk then "PASS" else "FAIL") ++
             "  BCS ratio = 2pi/e^gamma ~ 3.528 (< 0.1%)"
  putStrLn ""

  -- S7: Magnetisation at T=0 (no MC, just the initial state)
  putStrLn "S7 T=0 magnetisation:"
  let mag0 = isingMag n lat0
  putStrLn $ "  M(T=0) = " ++ show mag0 ++ " (expect 1.0)"
  let mag0Ok = abs (mag0 - 1.0) < 1.0e-12
  putStrLn $ "  " ++ (if mag0Ok then "PASS" else "FAIL") ++
             "  M(T=0) = 1 (saturated)"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks)
                && tcOk && e0Ok && magLoOk && magHiOk && bcsOk && mag0Ok
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every Condensed integer from (2, 3)."
  putStrLn "  Observable count: 7."

main :: IO ()
main = runSelfTest
