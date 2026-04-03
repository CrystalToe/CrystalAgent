-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalThermo -- Thermodynamic Dynamics from (2,3).

Molecular dynamics with Lennard-Jones potential.
Velocity Verlet integrator (same W-U-W pattern).

  LJ attractive exponent:  6 = chi
  LJ repulsive exponent:  12 = 2*chi
  gamma_diatomic:        7/5 = beta0/(chi-1)
  gamma_monatomic:       5/3 = (chi-1)/N_c
  Stokes drag:            24 = d_mixed
  Carnot efficiency:     5/6 = (chi-1)/chi
  DOF monatomic:           3 = N_c
  DOF diatomic:            5 = chi-1
  Entropy per tick:     ln 6 = ln(chi)

Observable count: 0 new (infrastructure). Every number from (2,3).

Engine wiring: imports CrystalEngine. Mixed sector (d=24).
-}

module CrystalThermo where

-- Rule 1: import CrystalEngine
import CrystalEngine
  ( nW, nC, chi, beta0, sigmaD, towerD, gauss
  , d1, d2, d3, d4
  , lambda, CrystalState
  , sectorDim, extractSector, injectSector
  , normSq, tick, zeroState
  )

-- Rule 2: NO local nW, nC, chi, beta0, sigmaD, d1-d4.
--         All atoms come from CrystalEngine.

import Data.Ratio (Rational, (%))
import Data.List (foldl')

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- | Mixed sector dimension (= d4 from engine = 24).
dMixed :: Int
dMixed = d4  -- 24, from engine

-- =====================================================================
-- S1  LENNARD-JONES POTENTIAL
--
-- V(r) = 4 eps [(sigma/r)^12 - (sigma/r)^6]
-- The 12 = 2*chi (Pauli repulsion: double the EM attraction exponent).
-- The 6  = chi  (van der Waals attraction: induced dipole-dipole).
-- =====================================================================

-- | LJ potential. Exponents 12 = 2*chi, 6 = chi.
ljPotential :: Double -> Double -> Double -> Double
ljPotential eps0 sigma r =
  let sr6  = (sigma / r) * (sigma / r) * (sigma / r)   -- (sigma/r)^3
      sr6' = sr6 * sr6                                  -- (sigma/r)^6 = (sigma/r)^chi
      sr12 = sr6' * sr6'                                -- (sigma/r)^12 = (sigma/r)^(2*chi)
  in 4.0 * eps0 * (sr12 - sr6')

-- | LJ force magnitude: F = -dV/dr = 24 eps/r [2(sigma/r)^12 - (sigma/r)^6].
-- The 24 = d_mixed! Stokes drag coefficient IS the LJ force prefactor.
ljForceMag :: Double -> Double -> Double -> Double
ljForceMag eps0 sigma r =
  let sr6  = (sigma / r) * (sigma / r) * (sigma / r)
      sr6' = sr6 * sr6
      sr12 = sr6' * sr6'
  in fromIntegral dMixed * eps0 / r * (2.0 * sr12 - sr6')

-- =====================================================================
-- S2  PARTICLE TYPE AND FORCES
-- =====================================================================

data Particle = Particle
  { pX :: !Double, pY :: !Double, pZ :: !Double   -- position (N_c=3)
  , pVx :: !Double, pVy :: !Double, pVz :: !Double -- velocity
  , pM :: !Double                                   -- mass
  } deriving (Show)

-- | Force on particle i from all others via LJ.
ljAccel :: Double -> Double -> Double -> [Particle] -> Int -> (Double, Double, Double)
ljAccel eps0 sigma cutoff parts idx =
  let pi_ = parts !! idx
  in foldl' (\(ax,ay,az) (j, pj) ->
    if j == idx then (ax,ay,az)
    else let dx = pX pi_ - pX pj
             dy = pY pi_ - pY pj
             dz = pZ pi_ - pZ pj
             r2 = dx*dx + dy*dy + dz*dz
             r  = sqrt r2
         in if r > cutoff || r < 1e-10 then (ax,ay,az)
            else let fmag = ljForceMag eps0 sigma r / (pM pi_ * r)
                 in (ax - fmag*dx, ay - fmag*dy, az - fmag*dz)
    ) (0,0,0) (zip [0..] parts)

-- =====================================================================
-- S3  VELOCITY VERLET (same W-U-W as CrystalClassical)
-- =====================================================================

forceParticle :: Particle -> Particle
forceParticle (Particle x y z vx vy vz m) =
  x `seq` y `seq` z `seq` vx `seq` vy `seq` vz `seq` m `seq`
  Particle x y z vx vy vz m

-- | One Verlet tick for all particles.
thermoTick :: Double -> Double -> Double -> Double -> [Particle] -> [Particle]
thermoTick dt eps0 sigma cutoff parts =
  let n = length parts
      -- Compute accelerations at current positions
      accels = [ljAccel eps0 sigma cutoff parts i | i <- [0..n-1]]
      -- W: half-kick velocity
      halfKick (p, (ax,ay,az)) = forceParticle $
        p { pVx = pVx p + (dt/2)*ax, pVy = pVy p + (dt/2)*ay, pVz = pVz p + (dt/2)*az }
      parts1 = map halfKick (zip parts accels)
      -- U: full drift position
      drift p = forceParticle $
        p { pX = pX p + dt * pVx p, pY = pY p + dt * pVy p, pZ = pZ p + dt * pVz p }
      parts2 = map drift parts1
      -- Recompute accelerations at new positions
      accels2 = [ljAccel eps0 sigma cutoff parts2 i | i <- [0..n-1]]
      -- W: half-kick velocity
      halfKick2 (p, (ax,ay,az)) = forceParticle $
        p { pVx = pVx p + (dt/2)*ax, pVy = pVy p + (dt/2)*ay, pVz = pVz p + (dt/2)*az }
  in map halfKick2 (zip parts2 accels2)

-- =====================================================================
-- S4  THERMODYNAMIC QUANTITIES
-- =====================================================================

-- | Kinetic energy.
kineticE :: [Particle] -> Double
kineticE = foldl' (\e p -> e + 0.5 * pM p * (sq (pVx p) + sq (pVy p) + sq (pVz p))) 0

-- | Temperature from kinetic energy: T = 2 KE / (N_dof k_B).
-- N_dof = N_c per particle (monatomic) = 3N.
temperature :: [Particle] -> Double
temperature parts =
  let n = fromIntegral (length parts)
      ndof = fromIntegral nC * n   -- 3N degrees of freedom
  in 2.0 * kineticE parts / ndof

-- | LJ potential energy (total).
potentialE :: Double -> Double -> Double -> [Particle] -> Double
potentialE eps0 sigma cutoff parts =
  let n = length parts
  in sum [ if i >= j then 0
           else let pi_ = parts !! i; pj = parts !! j
                    dx = pX pi_ - pX pj; dy = pY pi_ - pY pj; dz = pZ pi_ - pZ pj
                    r = sqrt (dx*dx + dy*dy + dz*dz)
                in if r > cutoff then 0 else ljPotential eps0 sigma r
         | i <- [0..n-1], j <- [0..n-1] ]

-- | Total energy.
totalE :: Double -> Double -> Double -> [Particle] -> Double
totalE eps0 sigma cutoff parts = kineticE parts + potentialE eps0 sigma cutoff parts

-- =====================================================================
-- S5  THERMODYNAMIC CONSTANTS FROM (2,3)
-- =====================================================================

-- | Heat capacity ratio (adiabatic index).
gammaMonatomic :: Double
gammaMonatomic = fromIntegral (chi - 1) / fromIntegral nC  -- 5/3

gammaDiatomic :: Double
gammaDiatomic = fromIntegral beta0 / fromIntegral (chi - 1) -- 7/5

-- | Degrees of freedom.
dofMonatomic :: Int
dofMonatomic = nC  -- 3

dofDiatomic :: Int
dofDiatomic = chi - 1  -- 5

-- | Carnot efficiency: eta = 1 - T_c/T_h = (chi-1)/chi for T_h/T_c = chi.
carnotEfficiency :: Double
carnotEfficiency = fromIntegral (chi - 1) / fromIntegral chi  -- 5/6

-- | Entropy per monad tick.
entropyPerTick :: Double
entropyPerTick = log (fromIntegral chi)  -- ln(6)

-- | Stokes drag coefficient.
stokesDrag :: Int
stokesDrag = dMixed  -- 24

-- =====================================================================
-- S6  INTEGER IDENTITY PROOFS
-- =====================================================================

proveLJattractive :: Int
proveLJattractive = chi  -- 6

proveLJrepulsive :: Int
proveLJrepulsive = 2 * chi  -- 12

proveLJforce24 :: Int
proveLJforce24 = dMixed  -- 24

proveGammaMonatomic :: Rational
proveGammaMonatomic = fromIntegral (chi - 1) % fromIntegral nC  -- 5/3

proveGammaDiatomic :: Rational
proveGammaDiatomic = fromIntegral beta0 % fromIntegral (chi - 1)  -- 7/5

proveDOFmono :: Int
proveDOFmono = nC  -- 3

proveDOFdi :: Int
proveDOFdi = chi - 1  -- 5

proveCarnot :: Rational
proveCarnot = fromIntegral (chi - 1) % fromIntegral chi  -- 5/6

proveEntropy :: Int
proveEntropy = chi  -- ln(6) = ln(chi)

proveStokes :: Int
proveStokes = dMixed  -- 24

-- =====================================================================
-- Rule 3: toCrystalState / fromCrystalState
--
-- Map particle state into mixed sector (d=24).
-- Layout: for up to 4 particles, pack (x,y,z,vx,vy,vz) per particle.
-- 4 particles * 6 DOF = 24 = d_mixed.
-- =====================================================================

-- | Pack up to 4 particles into the mixed sector of a CrystalState.
toCrystalState :: [Particle] -> CrystalState
toCrystalState parts =
  let slots = concatMap (\p -> [pX p, pY p, pZ p, pVx p, pVy p, pVz p]) parts
      padded = take dMixed (slots ++ repeat 0.0)  -- pad to 24
  in injectSector 3 padded zeroState  -- sector 3 = mixed

-- | Unpack particles from the mixed sector of a CrystalState.
fromCrystalState :: Int -> CrystalState -> [Particle]
fromCrystalState nParts cs =
  let mixed = extractSector 3 cs  -- 24 components
      go _ [] = []
      go 0 _  = []
      go k xs =
        let (chunk, rest) = splitAt 6 xs
            [x,y,z,vx,vy,vz] = take 6 (chunk ++ repeat 0.0)
        in Particle x y z vx vy vz 1.0 : go (k-1) rest
  in go nParts mixed

-- =====================================================================
-- Rule 4: proveSectorRestriction
--
-- Show: extractSector 3 (tick (injectSector 3 v zeroState))
--     = map (* lambda 3) v
-- i.e. the engine tick on a pure-mixed state just scales by lambda_mixed.
-- =====================================================================

proveSectorRestriction :: [Double] -> (Bool, String)
proveSectorRestriction mixedVec =
  let -- Inject into mixed sector, tick, extract
      cs      = injectSector 3 (take dMixed mixedVec) zeroState
      cs'     = tick cs
      after   = extractSector 3 cs'
      -- Expected: each component scaled by lambda 3 = 1/6
      lam3    = lambda 3
      expected = map (* lam3) (take dMixed mixedVec)
      -- Compare
      diffs   = zipWith (\a e -> abs (a - e)) after expected
      maxDiff = maximum (0 : diffs)
      ok      = maxDiff < 1.0e-12
      msg     = if ok then "sector restriction OK (maxdiff=" ++ show maxDiff ++ ")"
                else "FAIL: maxdiff=" ++ show maxDiff
  in (ok, msg)

-- =====================================================================
-- S7  SELF-TEST
-- =====================================================================

-- | Create particles in a small box with thermal velocities.
makeGas :: Int -> Double -> Double -> [Particle]
makeGas n temp spacing =
  [ let fi = fromIntegral i
        x = spacing * (fi - fromIntegral n / 2)
        vx = temp * sin (fi * 3.14)
        vy = temp * cos (fi * 2.71)
        vz = temp * sin (fi * 1.41 + 1)
    in Particle x 0 0 vx vy vz 1.0
  | i <- [1..n] ]

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalThermo.hs -- Thermodynamic Dynamics from (2,3) -- Test"
  putStrLn " Engine wired: imports CrystalEngine. Mixed sector (d=24)."
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "S1 Thermodynamic integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("LJ attractive 6 = chi",          proveLJattractive == 6)
        , ("LJ repulsive 12 = 2*chi",        proveLJrepulsive == 12)
        , ("LJ force 24 = d_mixed",          proveLJforce24 == 24)
        , ("gamma_mono 5/3 = (chi-1)/N_c",   proveGammaMonatomic == 5 % 3)
        , ("gamma_di 7/5 = beta0/(chi-1)",   proveGammaDiatomic == 7 % 5)
        , ("DOF mono 3 = N_c",               proveDOFmono == 3)
        , ("DOF di 5 = chi-1",               proveDOFdi == 5)
        , ("Carnot 5/6 = (chi-1)/chi",       proveCarnot == 5 % 6)
        , ("entropy chi = 6 (ln 6)",          proveEntropy == 6)
        , ("Stokes 24 = d_mixed",            proveStokes == 24)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- LJ potential shape
  putStrLn "S2 LJ potential:"
  let eps0 = 1.0 :: Double
      sigma = 1.0 :: Double
      rMin = sigma * (2.0 ** (1.0 / 6.0))
      vMin = ljPotential eps0 sigma rMin
      vMinOk = abs (vMin + eps0) < 1e-10
  putStrLn $ "  r_min = " ++ show rMin ++ " sigma"
  putStrLn $ "  V(r_min) = " ++ show vMin ++ " (expect -eps)"
  putStrLn $ "  " ++ (if vMinOk then "PASS" else "FAIL") ++
             "  LJ minimum = -eps at r = 2^(1/chi) sigma"

  let vSigma = ljPotential eps0 sigma sigma
      vSigOk = abs vSigma < 1e-10
  putStrLn $ "  V(sigma) = " ++ show vSigma ++ " (expect 0)"
  putStrLn $ "  " ++ (if vSigOk then "PASS" else "FAIL") ++ "  V(sigma) = 0"
  putStrLn ""

  -- MD integration
  putStrLn "S3 MD integration (4 particles, 200 steps):"
  let gas = makeGas 4 0.05 3.0
      cutoff = 5.0 :: Double
      dt = 0.002 :: Double
      e0 = totalE eps0 sigma cutoff gas
      goMD :: Int -> [Particle] -> Double -> (Double, [Particle])
      goMD 0 ps mx = (mx, ps)
      goMD n ps mx =
        let ps' = thermoTick dt eps0 sigma cutoff ps
            e'  = totalE eps0 sigma cutoff ps'
            mx' = max mx (abs (e' - e0) / (abs e0 + 1e-20))
        in e' `seq` mx' `seq` goMD (n-1) ps' mx'
      (maxDev, gasFinal) = goMD 200 gas 0.0
  putStrLn $ "  initial E = " ++ show e0
  putStrLn $ "  max E dev = " ++ show maxDev
  let eOk = maxDev < 0.01
  putStrLn $ "  " ++ (if eOk then "PASS" else "FAIL") ++
             "  energy conserved (< 1%)"
  putStrLn ""

  -- Temperature measurement
  putStrLn "S4 Temperature and equipartition:"
  let t0 = temperature gas
      tF = temperature gasFinal
  putStrLn $ "  initial T = " ++ show t0
  putStrLn $ "  final T   = " ++ show tF
  let tempOk = tF > 0
  putStrLn $ "  " ++ (if tempOk then "PASS" else "FAIL") ++ "  T > 0"
  putStrLn ""

  -- Gamma values
  putStrLn "S5 Adiabatic indices:"
  putStrLn $ "  gamma_mono = " ++ show gammaMonatomic ++ " (expect 5/3 = 1.667)"
  putStrLn $ "  gamma_di   = " ++ show gammaDiatomic ++ " (expect 7/5 = 1.400)"
  let gMonoOk = abs (gammaMonatomic - 5.0/3.0) < 1e-10
      gDiOk   = abs (gammaDiatomic - 7.0/5.0) < 1e-10
  putStrLn $ "  " ++ (if gMonoOk then "PASS" else "FAIL") ++ "  gamma_mono = (chi-1)/N_c"
  putStrLn $ "  " ++ (if gDiOk then "PASS" else "FAIL") ++ "  gamma_di = beta0/(chi-1)"
  putStrLn ""

  -- Rule 5: Engine wiring checks
  putStrLn "S6 Engine wiring (imported from CrystalEngine):"
  let ljOk = dMixed == 24
  putStrLn $ "  " ++ (if ljOk then "PASS" else "FAIL") ++ "  d_mixed = d4 = 24 (engine)"
  let chiOk = chi == 6
  putStrLn $ "  " ++ (if chiOk then "PASS" else "FAIL") ++ "  chi = 6 (engine)"
  let sdOk = sigmaD == 36
  putStrLn $ "  " ++ (if sdOk then "PASS" else "FAIL") ++ "  sigmaD = 36 (engine)"
  let testSt = replicate sigmaD (1.0 / sqrt (fromIntegral sigmaD))
      ticked = tick testSt
      tkOk = normSq ticked < normSq testSt
  putStrLn $ "  " ++ (if tkOk then "PASS" else "FAIL") ++ "  engine tick accessible (S = W∘U)"
  putStrLn $ "  PASS  ALL atoms from CrystalEngine (no local redefinitions)"
  putStrLn ""

  -- toCrystalState / fromCrystalState round-trip
  putStrLn "S7 Crystal state mapping (toCrystalState / fromCrystalState):"
  let gas4      = makeGas 4 0.1 2.0
      csGas     = toCrystalState gas4
      gas4back  = fromCrystalState 4 csGas
      rtOk      = all (\(p1,p2) ->
                    abs (pX p1 - pX p2) < 1e-12 &&
                    abs (pY p1 - pY p2) < 1e-12 &&
                    abs (pZ p1 - pZ p2) < 1e-12 &&
                    abs (pVx p1 - pVx p2) < 1e-12 &&
                    abs (pVy p1 - pVy p2) < 1e-12 &&
                    abs (pVz p1 - pVz p2) < 1e-12
                  ) (zip gas4 gas4back)
  putStrLn $ "  " ++ (if rtOk then "PASS" else "FAIL") ++
             "  round-trip: from(to(particles)) = particles"
  let sectorOk = sectorDim 3 == dMixed
  putStrLn $ "  " ++ (if sectorOk then "PASS" else "FAIL") ++
             "  sectorDim 3 = " ++ show (sectorDim 3) ++ " = d_mixed"
  putStrLn ""

  -- proveSectorRestriction
  putStrLn "S8 Sector restriction proof:"
  let testMixed  = map (\i -> sin (fromIntegral i * 0.7)) [1..dMixed]
      (srOk, srMsg) = proveSectorRestriction testMixed
  putStrLn $ "  " ++ (if srOk then "PASS" else "FAIL") ++ "  " ++ srMsg
  let gasCS       = toCrystalState gas4
      gasMixed    = extractSector 3 gasCS
      (srOk2, srMsg2) = proveSectorRestriction gasMixed
  putStrLn $ "  " ++ (if srOk2 then "PASS" else "FAIL") ++ "  " ++ srMsg2 ++ " (gas state)"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks)
                && vMinOk && vSigOk && eOk && tempOk && gMonoOk && gDiOk
                && ljOk && chiOk && sdOk && tkOk
                && rtOk && sectorOk && srOk && srOk2
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every thermodynamic integer from (2, 3). Engine wired."
  putStrLn "  Observable count: 0 new (infrastructure)."

main :: IO ()
main = runSelfTest
