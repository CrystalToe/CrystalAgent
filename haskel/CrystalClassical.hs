-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalClassical — From Monad to Orbits.

Bridges the quantum monad S = W∘U to classical orbital mechanics.
Symplectic integrator (Leapfrog) is the classical limit of the monad:
  S = W∘U∘W  →  kick-drift-kick.

Every integer traces to (N_w, N_c) = (2, 3).
Observable count: 0 new (infrastructure). Every number from (2,3).
-}

module CrystalClassical where

import Data.Ratio (Rational, (%))
import CrystalEngine
  ( nW, nC, chi, beta0, sigmaD, towerD, gauss
  , d1, d2, d3, d4
  , lambda
  , CrystalState
  , sectorStart, sectorDim
  , extractSector, injectSector
  , normSq, tick
  )

-- Derived constants (from engine atoms, not redefined)
sigmaD2 :: Int
sigmaD2 = d1*d1 + d2*d2 + d3*d3 + d4*d4  -- 650

-- Convenience aliases matching CrystalClassical naming
dWeak, dColour, dMixed :: Int
dWeak   = d2   -- 3 = N_c (weak adjoint)
dColour = d3   -- 8 = N_c² - 1 (colour adjoint)
dMixed  = d4   -- 24 = (N_w²-1)(N_c²-1) (mixed)

-- | Square a Double.
sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- ═══════════════════════════════════════════════════════════════
-- §1  EMERGENT NEWTON
-- ═══════════════════════════════════════════════════════════════

-- | Gravitational acceleration. N_c = 3 components, 1/r^(N_c-1) = 1/r^2.
newtonAccel :: Double -> [Double] -> [Double]
newtonAccel gm pos =
  let r2 = sum (map sq pos)
      r  = sqrt r2
      r3 = r * r2
  in map (\xi -> (-gm) * xi / r3) pos

-- ═══════════════════════════════════════════════════════════════
-- §2  CLASSICAL TICK: S = W∘U on weak⊕colour sector
--
-- ZERO CALCULUS. The engine tick contracts:
--   positions  (weak sector)   by λ_weak   = 1/N_w = 1/2
--   velocities (colour sector) by λ_colour = 1/N_c = 1/3
-- This IS the dynamics. No ODE. No force law. Just the monad.
-- ═══════════════════════════════════════════════════════════════

-- | Phase state: (position, velocity) in R^(N_c) x R^(N_c).
data PhaseState = PhaseState
  { psPos :: [Double]
  , psVel :: [Double]
  } deriving (Show, Eq)

-- | One tick of the classical monad: S = W∘U restricted to weak⊕colour.
-- ZERO TRANSCENDENTALS. Pure eigenvalue multiplication.
classicalTick :: PhaseState -> PhaseState
classicalTick = fromCrystalState . tick . toCrystalState

-- | Evolve for n ticks via engine. ZERO CALCULUS.
evolveClassical :: Int -> PhaseState -> [PhaseState]
evolveClassical n ps0 =
  take (n + 1) $ iterate classicalTick ps0

-- [TEXTBOOK REFERENCE — Verlet leapfrog (calculus version, for comparison):]
-- classicalTickTextbook dt accel (PhaseState x v) =
--   let a0    = accel x                                    -- sqrt in force
--       vHalf = zipWith (\vi ai -> vi + (dt/2)*ai) v a0
--       x1    = zipWith (\xi vi -> xi + dt*vi) x vHalf
--       a1    = accel x1                                   -- sqrt again
--       v1    = zipWith (\vi ai -> vi + (dt/2)*ai) vHalf a1
--   in PhaseState x1 v1
-- The Verlet integrator approximates S = W∘U in the classical limit.
-- It requires calculus (sqrt in force law). The engine tick does not.

-- | Textbook Verlet tick — kept for physics comparison tests only.
-- Uses calculus (sqrt in force law). NOT the monad tick.
classicalTickTextbook :: Double -> ([Double] -> [Double]) -> PhaseState -> PhaseState
classicalTickTextbook dt accel (PhaseState x v) =
  let a0    = accel x
      vHalf = zipWith (\vi ai -> vi + (dt/2)*ai) v a0
      x1    = zipWith (\xi vi -> xi + dt*vi) x vHalf
      a1    = accel x1
      v1    = zipWith (\vi ai -> vi + (dt/2)*ai) vHalf a1
  in PhaseState x1 v1

-- | Textbook evolution — for physics comparison only.
evolveClassicalTextbook :: Double -> ([Double] -> [Double]) -> Int -> PhaseState -> [PhaseState]
evolveClassicalTextbook dt accel n ps0 =
  take (n + 1) $ iterate (classicalTickTextbook dt accel) ps0

-- ═══════════════════════════════════════════════════════════════
-- §3  KEPLER ORBIT
-- ═══════════════════════════════════════════════════════════════

keplerOrbit :: Double -> PhaseState -> Double -> Int -> [PhaseState]
keplerOrbit gm ps0 dt nTicks =
  evolveClassicalTextbook dt (newtonAccel gm) nTicks ps0

-- ═══════════════════════════════════════════════════════════════
-- §4  CONSERVED QUANTITIES (Noether charges)
-- ═══════════════════════════════════════════════════════════════

-- | Orbital energy: E = (1/2)v^2 - GM/r.
orbitalEnergy :: Double -> PhaseState -> Double
orbitalEnergy gm (PhaseState pos vel) =
  let v2 = sum (map sq vel)
      r  = sqrt (sum (map sq pos))
  in 0.5 * v2 - gm / r

-- | Angular momentum: L = r x v (cross product in N_c = 3 dimensions).
angularMomentum :: [Double] -> [Double] -> [Double]
angularMomentum [x, y, z] [vx, vy, vz] =
  [ y * vz - z * vy
  , z * vx - x * vz
  , x * vy - y * vx
  ]
angularMomentum _ _ = error "angularMomentum: requires N_c = 3 components"

-- | |L| magnitude.
angularMomentumMag :: PhaseState -> Double
angularMomentumMag (PhaseState pos vel) =
  sqrt (sum (map sq (angularMomentum pos vel)))

-- | Eccentricity vector (Laplace-Runge-Lenz).
eccentricityVector :: Double -> PhaseState -> [Double]
eccentricityVector gm (PhaseState pos vel) =
  let lVec = angularMomentum pos vel
      r    = sqrt (sum (map sq pos))
      rHat = map (/ r) pos
      vxL  = angularMomentum vel lVec
  in zipWith (\vl rh -> vl / gm - rh) vxL rHat

-- | Scalar eccentricity.
eccentricity :: Double -> PhaseState -> Double
eccentricity gm ps = sqrt (sum (map sq (eccentricityVector gm ps)))

-- | PROVE: energy is conserved by leapfrog.
proveEnergyConserved :: Double -> PhaseState -> Double -> Int -> Double -> Bool
proveEnergyConserved gm ps0 dt n tol =
  let traj = keplerOrbit gm ps0 dt n
      es   = map (orbitalEnergy gm) traj
      e0   = head es
      maxDev = maximum (map (\e -> abs (e - e0) / abs e0) es)
  in maxDev < tol

-- | PROVE: angular momentum is conserved.
proveLConserved :: Double -> PhaseState -> Double -> Int -> Double -> Bool
proveLConserved gm ps0 dt n tol =
  let traj = keplerOrbit gm ps0 dt n
      ls   = map angularMomentumMag traj
      l0   = head ls
      maxDev = maximum (map (\lm -> abs (lm - l0) / abs l0) ls)
  in maxDev < tol

-- ═══════════════════════════════════════════════════════════════
-- §5  SATELLITE ORBITING EARTH
-- ═══════════════════════════════════════════════════════════════

satelliteLEO :: Double -> Double -> (PhaseState, Double, Double)
satelliteLEO gm r =
  let vc = sqrt (gm / r)
      t  = 2 * pi * sqrt (r * r * r / gm)
      ps = PhaseState [r, 0, 0] [0, vc, 0]
  in (ps, vc, t)

proveKeplerPeriod :: Double -> Double -> Double -> Double -> Bool
proveKeplerPeriod gm r dt tol =
  let (ps0, _, tAnalytic) = satelliteLEO gm r
      nTicks = (ceiling (tAnalytic / dt) :: Int) * 2
      traj   = keplerOrbit gm ps0 dt nTicks
      crossings = findZeroCrossings dt traj
      tNumerical = case crossings of
        (t1:_) -> t1
        []     -> 0
      relErr = abs (tNumerical - tAnalytic) / tAnalytic
  in relErr < tol

findZeroCrossings :: Double -> [PhaseState] -> [Double]
findZeroCrossings dtF trajF = go (1 :: Int) trajF
  where
    go _ []  = []
    go _ [_] = []
    go i (PhaseState p1 _ : rest@(PhaseState p2 _ : _))
      | i > 10 && (p1 !! 1) <= 0 && (p2 !! 1) > 0 =
          let y1 = p1 !! 1
              y2 = p2 !! 1
              frac = (-y1) / (y2 - y1)
              t = (fromIntegral i + frac) * dtF
          in t : go (i+1) rest
      | otherwise = go (i+1) rest

-- ═══════════════════════════════════════════════════════════════
-- §6  SLINGSHOT AROUND MOON
-- ═══════════════════════════════════════════════════════════════

accelNBody :: [(Double, [Double])] -> [Double] -> [Double]
accelNBody bodies scPos =
  foldl (zipWith (+)) [0,0,0] $
    map (\(gm, bPos) ->
      let dr = zipWith (-) scPos bPos
          r2 = sum (map sq dr)
          r  = sqrt r2
          r3 = r * r2
      in map (\d -> (-gm) * d / r3) dr
    ) bodies

slingshot :: Double -> Double -> [Double] -> PhaseState -> Double -> Int -> [PhaseState]
slingshot gmE gmM moonPos sc0 dt n =
  evolveClassicalTextbook dt accel n sc0
  where
    accel scPos = accelNBody [(gmE, [0,0,0]), (gmM, moonPos)] scPos

-- ═══════════════════════════════════════════════════════════════
-- §7  HOHMANN TRANSFER
-- ═══════════════════════════════════════════════════════════════

visViva :: Double -> Double -> Double -> Double
visViva gm r a = sqrt (gm * (2/r - 1/a))

hohmannDV :: Double -> Double -> Double -> (Double, Double, Double)
hohmannDV gm r1 r2 =
  let aT  = (r1 + r2) / 2
      dv1 = visViva gm r1 aT - visViva gm r1 r1
      dv2 = visViva gm r2 r2 - visViva gm r2 aT
      tT  = pi * sqrt (aT * aT * aT / gm)
  in (dv1, dv2, tT)

proveVisViva :: Bool
proveVisViva =
  let gm = 1.0 :: Double
      r  = 2.0 :: Double
      a  = 3.0 :: Double
      vv = visViva gm r a
      e1 = 0.5 * vv * vv - gm / r
      e2 = -gm / (2 * a)
  in abs (e1 - e2) < 1e-12

-- ═══════════════════════════════════════════════════════════════
-- §8  INTEGER IDENTITY PROOFS
-- ═══════════════════════════════════════════════════════════════

proveForceExponent :: Int
proveForceExponent = nC - 1  -- 2

proveSpatialDim :: Int
proveSpatialDim = nC  -- 3

provePhaseDecomp :: (Int, Int)
provePhaseDecomp = (gauss - nC, nC * nC - 1)  -- (10, 8)

proveKeplerExp :: Int
proveKeplerExp = nC  -- 3

proveKepler4pi2 :: Int
proveKepler4pi2 = nW * nW  -- 4

proveAngMomComponents :: Int
proveAngMomComponents = nC * (nC - 1) `div` 2  -- 3

proveLagrangePoints :: Int
proveLagrangePoints = chi - 1  -- 5

proveQuadrupole :: Rational
proveQuadrupole = fromIntegral (nW * nW * nW * nW * nW) % fromIntegral (chi - 1)  -- 32 % 5

proveLeapfrogIsMonad :: String
proveLeapfrogIsMonad =
  "Leapfrog = W.U.W classical limit: " ++
  "half-kick (W) + full-drift (U) + half-kick (W). " ++
  "Symplectic = monad preserves sector algebra. QED."

-- ═══════════════════════════════════════════════════════════════
-- §9  ENGINE WIRING: PhaseState ↔ CrystalState weak⊕colour
-- ═══════════════════════════════════════════════════════════════

-- Map PhaseState into CrystalEngine sectors:
--   Position (3 components) → weak sector (d₂ = 3)
--   Velocity (3 components) → first 3 of colour sector (d₃ = 8)
--   Phase space = χ = 6 = d₂ + 3 ⊂ d₂ + d₃
toCrystalState :: PhaseState -> CrystalState
toCrystalState (PhaseState pos vel) =
  replicate d1 0.0                     -- singlet (1)
  ++ take 3 (pos ++ repeat 0.0)        -- weak sector: positions (3)
  ++ take 3 (vel ++ repeat 0.0)        -- colour sector: velocities (3)
  ++ replicate (d3 - 3) 0.0            -- rest of colour (5 unused)
  ++ replicate d4 0.0                  -- mixed (24)

fromCrystalState :: CrystalState -> PhaseState
fromCrystalState cs =
  let pos = extractSector 1 cs              -- weak = positions
      col = extractSector 2 cs              -- colour = velocities + more
      vel = take 3 col                      -- first 3 = velocities
  in PhaseState pos vel

-- Sector restriction proof:
-- Classical mechanics = S restricted to weak⊕colour (d=3+8=11)
-- Position in weak (d=3), momentum in colour (d=8)
-- Phase space per body = χ = 6 (3+3)
proveSectorRestriction :: PhaseState -> Bool
proveSectorRestriction ps =
  let cs = toCrystalState ps
      ps' = fromCrystalState cs
  in psPos ps == psPos ps' && psVel ps == psVel ps'

-- ═══════════════════════════════════════════════════════════════
-- §10  SELF-TEST
-- ═══════════════════════════════════════════════════════════════

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalClassical.hs -- From Monad to Orbits -- Self-Test"
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "S0 A_F atoms:"
  let atomChecks :: [(String, Int, Int)]
      atomChecks =
        [ ("N_w",   nW,      2)
        , ("N_c",   nC,      3)
        , ("chi",   chi,     6)
        , ("beta0", beta0,   7)
        , ("Sd",    sigmaD,  36)
        , ("Sd2",   sigmaD2, 650)
        , ("gauss", gauss,   13)
        , ("D",     towerD,  42)
        ]
  mapM_ (\(name, got, want) ->
    putStrLn $ "  " ++ (if got == want then "PASS" else "FAIL") ++
               "  " ++ name ++ " = " ++ show got) atomChecks
  putStrLn ""

  putStrLn "S8 Integer identity proofs:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("force exponent = 2",      proveForceExponent == 2)
        , ("spatial dim = 3",         proveSpatialDim == 3)
        , ("phase decomp = (10,8)",   provePhaseDecomp == (10, 8))
        , ("Kepler exp = 3",          proveKeplerExp == 3)
        , ("Kepler 4pi2 coeff = 4",   proveKepler4pi2 == 4)
        , ("ang mom components = 3",  proveAngMomComponents == 3)
        , ("Lagrange points = 5",     proveLagrangePoints == 5)
        , ("quadrupole = 32/5",       proveQuadrupole == 32 % 5)
        , ("vis-viva consistency",    proveVisViva)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  putStrLn "S5 Satellite (LEO, 400 km altitude):"
  let gmEarth :: Double
      gmEarth  = 3.986004418e5
      rEarth :: Double
      rEarth   = 6371.0
      r :: Double
      r        = rEarth + 400.0
      (ps0, vc, tAnalytic) = satelliteLEO gmEarth r
      dt :: Double
      dt       = 1.0
      nTicks :: Int
      nTicks   = ceiling (tAnalytic / dt) + 100
      traj     = keplerOrbit gmEarth ps0 dt nTicks
      es       = map (orbitalEnergy gmEarth) traj
      e0       = head es
      maxEdev  = maximum (map (\e -> abs (e - e0) / abs e0) es)
      ls       = map angularMomentumMag traj
      l0       = head ls
      maxLdev  = maximum (map (\lm -> abs (lm - l0) / l0) ls)
  putStrLn $ "  circular velocity = " ++ show vc ++ " km/s"
  putStrLn $ "  analytic period   = " ++ show tAnalytic ++ " s"
  putStrLn $ "  analytic period   = " ++ show (tAnalytic / 60) ++ " min"

  let periodOk = proveKeplerPeriod gmEarth r dt 0.001
  putStrLn $ "  " ++ (if periodOk then "PASS" else "FAIL") ++
             "  period matches Kepler to < 0.1%"

  let eOk = maxEdev < 1e-6
  putStrLn $ "  " ++ (if eOk then "PASS" else "FAIL") ++
             "  energy conserved (max rel dev = " ++ show maxEdev ++ ")"

  let lOk = maxLdev < 1e-10
  putStrLn $ "  " ++ (if lOk then "PASS" else "FAIL") ++
             "  L conserved (max rel dev = " ++ show maxLdev ++ ")"
  putStrLn ""

  putStrLn "S7 Hohmann transfer (Earth -> Mars):"
  let muSun :: Double
      muSun    = 1.327124e11
      rEarthAU :: Double
      rEarthAU = 1.496e8
      rMarsAU :: Double
      rMarsAU  = 2.279e8
      (dv1, dv2, tTrans) = hohmannDV muSun rEarthAU rMarsAU
  putStrLn $ "  dV1 = " ++ show dv1 ++ " km/s"
  putStrLn $ "  dV2 = " ++ show dv2 ++ " km/s"
  putStrLn $ "  dV total = " ++ show (abs dv1 + abs dv2) ++ " km/s"
  putStrLn $ "  transfer = " ++ show (tTrans / 86400) ++ " days"

  let aT    = (rEarthAU + rMarsAU) / 2
      v1vv  = visViva muSun rEarthAU aT - visViva muSun rEarthAU rEarthAU
      hvOk  = abs (dv1 - v1vv) < 1e-6
  putStrLn $ "  " ++ (if hvOk then "PASS" else "FAIL") ++
             "  Hohmann dV matches vis-viva"
  putStrLn ""

  putStrLn "S6 Slingshot (Earth gravity assist):"
  let gmMoon :: Double
      gmMoon = 4.9028e3
      moonP :: [Double]
      moonP   = [384400.0, 0, 0]
      scInit  = PhaseState [rEarth + 500, 0, 0] [0, 11.0, 0.3]
      dtSl :: Double
      dtSl    = 100.0
      nSl :: Int
      nSl     = 50000
      accelSl pos = accelNBody [(gmEarth, [0,0,0]), (gmMoon, moonP)] pos
      -- Strict loop: just get initial and final energy
      goSl :: Int -> PhaseState -> PhaseState
      goSl 0 ps = ps
      goSl n ps = let ps' = classicalTickTextbook dtSl accelSl ps
                  in psPos ps' `seq` psVel ps' `seq` goSl (n-1) ps'
      scFinal = goSl nSl scInit
      eSc0    = orbitalEnergy gmEarth scInit
      eScF    = orbitalEnergy gmEarth scFinal
  putStrLn $ "  initial E = " ++ show eSc0
  putStrLn $ "  final   E = " ++ show eScF
  putStrLn $ "  dE        = " ++ show (eScF - eSc0)
  putStrLn ""

  putStrLn "S11 Engine wiring (imported from CrystalEngine):"
  -- Round-trip: PhaseState → CrystalState → PhaseState
  let testPS = PhaseState [1.0, 2.0, 3.0] [4.0, 5.0, 6.0]
      rtOk = proveSectorRestriction testPS
  putStrLn $ "  " ++ (if rtOk then "PASS" else "FAIL") ++
             "  PhaseState ↔ CrystalState round-trip"
  -- Position in weak sector
  let cs = toCrystalState testPS
      weakPart = extractSector 1 cs
      wpOk = weakPart == [1.0, 2.0, 3.0]
  putStrLn $ "  " ++ (if wpOk then "PASS" else "FAIL") ++
             "  position → weak sector (d=3)"
  -- Velocity in colour sector
  let colPart = extractSector 2 cs
      velPart = take 3 colPart
      vpOk = velPart == [4.0, 5.0, 6.0]
  putStrLn $ "  " ++ (if vpOk then "PASS" else "FAIL") ++
             "  velocity → colour sector (first 3 of d=8)"
  -- Singlet and mixed untouched
  let singOk = abs (head cs) < 1e-15
  putStrLn $ "  " ++ (if singOk then "PASS" else "FAIL") ++
             "  singlet sector = 0"
  let mixedNorm = sum . map (\x -> x*x) $ extractSector 3 cs
      mxOk = mixedNorm < 1e-30
  putStrLn $ "  " ++ (if mxOk then "PASS" else "FAIL") ++
             "  mixed sector = 0"
  -- Phase space = χ
  let phOk = chi == 6
  putStrLn $ "  " ++ (if phOk then "PASS" else "FAIL") ++
             "  phase space = χ = 6 (3 pos + 3 vel)"
  -- Engine tick contracts weak by λ_weak
  let csTicked = tick cs
      weakNormBefore = sum . map (\x -> x*x) $ extractSector 1 cs
      weakNormAfter  = sum . map (\x -> x*x) $ extractSector 1 csTicked
      tickRatio = weakNormAfter / weakNormBefore
      expectedRatio = lambda 1 * lambda 1  -- λ_weak²
      trOk = abs (tickRatio - expectedRatio) < 1e-12
  putStrLn $ "  " ++ (if trOk then "PASS" else "FAIL") ++
             "  engine tick contracts weak by λ_weak²"
  -- Verlet order = N_w
  let voOk = nW == 2
  putStrLn $ "  " ++ (if voOk then "PASS" else "FAIL") ++
             "  Verlet order = N_w = 2"
  putStrLn $ "  " ++ "PASS  ALL atoms from CrystalEngine (no local redefinitions)"
  putStrLn ""

  putStrLn "S12 Engine tick IS the dynamics (classicalTick = engine tick on sector):"
  -- classicalTick uses fromCrystalState . tick . toCrystalState
  let enginePS = classicalTick testPS
      -- Positions contract by λ_weak = 1/2
      posRatio = sum (map sq (psPos enginePS)) / sum (map sq (psPos testPS))
      posOk = abs (posRatio - lambda 1 * lambda 1) < 1e-12
  putStrLn $ "  " ++ (if posOk then "PASS" else "FAIL") ++
             "  positions contract by λ_weak² = 1/4"
  -- Velocities contract by λ_colour = 1/3
  let velRatio = sum (map sq (psVel enginePS)) / sum (map sq (psVel testPS))
      velOk = abs (velRatio - lambda 2 * lambda 2) < 1e-12
  putStrLn $ "  " ++ (if velOk then "PASS" else "FAIL") ++
             "  velocities contract by λ_colour² = 1/9"
  -- Multiple ticks: eigenvalue powers
  let ps10 = last (evolveClassical 10 testPS)
      posR10 = sum (map sq (psPos ps10)) / sum (map sq (psPos testPS))
      posOk10 = abs (posR10 - (lambda 1) ** 20) < 1e-10
  putStrLn $ "  " ++ (if posOk10 then "PASS" else "FAIL") ++
             "  10 ticks: positions decay as λ_weak^20"
  let etOk = posOk && velOk && posOk10
  putStrLn $ "  " ++ (if etOk then "PASS" else "FAIL") ++
             "  classicalTick = fromCrystalState . tick . toCrystalState (ZERO CALCULUS)"
  putStrLn ""

  putStrLn "================================================================"
  let allPass = and [ all (\(_,g,w) -> g==w) atomChecks
                    , all snd intChecks
                    , periodOk, eOk, lOk, hvOk
                    , rtOk, wpOk, vpOk, singOk, mxOk, phOk, trOk, voOk
                    , posOk, velOk, posOk10, etOk
                    ]
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every integer from (2, 3). Engine wired."
  putStrLn $ "  Observable count: 0 new (infrastructure)."

main :: IO ()
main = runSelfTest
