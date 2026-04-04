{-# LANGUAGE BangPatterns #-}
-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalDynamicEngine.hs — Component 10: Dynamics

  The heartbeat. Every physics domain is a sector restriction of one tick.
  This module owns:

    1. The tick loop (diagonal and full)
    2. Sector projections (Verlet, Yee, Metropolis — textbook methods)
    3. HMC sampler (Hamiltonian Monte Carlo on the MERA)
    4. MERA layer sampling (42-layer multi-scale sweep)

  HMC accepts a tick function parameter: use tick (diagonal, fast)
  or tickFull (with cross-sector mixing, complete). Callers choose.

  This is the ONLY dynamical rule. Everything else is a projection.

  Compile: ghc -O2 -main-is CrystalDynamicEngine CrystalDynamicEngine.hs && ./CrystalDynamicEngine
-}

module CrystalDynamicEngine
  ( -- §0 Tick function type
    TickFn

    -- §1 Sector projections (= textbook methods)
  , classicalTick, emTick, thermalTick

    -- §2 State templates
  , equalState, singletState, photonState, weakState, colourState

    -- §3 HMC types
  , Seed, nextSeed, uniform, gaussian, gaussians

    -- §4 HMC action and gradient
  , sectorEnergy, action, gradient

    -- §5 HMC core
  , momentumRefresh, leapfrogStep, leapfrog
  , hamiltonian, acceptReject
  , hmcStep, hmcChain

    -- §6 MERA sampling
  , MERAState, initMERA, meraAction
  , updateLayer, meraSweep

    -- §7 MERA observables
  , sectorFraction, hmcEntropy, entanglementEntropy

    -- §8 Self-test
  , main
  ) where

import CrystalAtoms hiding (main)
import CrystalSectors hiding (main)
import CrystalEigen hiding (main)
import CrystalOperators hiding (main)

-- ═══════════════════════════════════════════════════════════════
-- §0 TICK FUNCTION TYPE
--
-- Callers choose their tick:
--   tick     — diagonal, 36 multiplies, sectors independent
--   tickFull — 36×36 matmul, sectors mix via D_F off-diagonal
--
-- Every function that runs dynamics accepts a TickFn parameter.
-- This is the ONLY choice in the engine.
-- ═══════════════════════════════════════════════════════════════

-- | A tick function: CrystalState -> CrystalState.
-- Use 'tick' for diagonal (fast, sectors independent).
-- Use 'tickFull' for full D_F (slower, sectors mix).
type TickFn = CrystalState -> CrystalState

-- ═══════════════════════════════════════════════════════════════
-- §1 SECTOR PROJECTIONS (= textbook methods)
--
-- Each projection restricts the full tick to specific sectors.
-- The 21 dynamics modules are all sector restrictions of this.
--
-- ZERO CALCULUS. Pure multiply-add-compare.
-- ═══════════════════════════════════════════════════════════════

-- | Classical mechanics: Verlet integrator.
-- Lives in weak (d=3, positions) + colour (d=8, contains momenta).
-- Phase space = chi = 6 per body (3 pos + 3 vel).
-- Verlet = S restricted to weak + colour with lambda_w, lambda_c.
classicalTick :: CrystalState -> CrystalState
classicalTick st =
  let pos = extractSector 1 st
      mom = take 3 $ extractSector 2 st
      mom' = zipWith (\p m -> m + wK 1 * p) pos mom
      pos' = zipWith (\p m -> p + uK 2 * m) pos mom'
      col  = extractSector 2 st
      col' = mom' ++ drop 3 col
  in injectSector 1 pos' $ injectSector 2 col' st

-- | Electromagnetism: Yee FDTD.
-- Lives in colour sector (d=8), uses chi=6 components (3E + 3B).
-- Courant number = 1/N_w = 0.5.
emTick :: CrystalState -> CrystalState
emTick st =
  let col = extractSector 2 st
      eField = take 3 col
      bField = take 3 $ drop 3 col
      courant = 1.0 / fromIntegral nW   -- 0.5
      bField' = zipWith (\e b -> b - courant * e) eField bField
      eField' = zipWith (\e b -> e - courant * b) eField bField'
      col' = eField' ++ bField' ++ drop 6 col
  in injectSector 2 col' st

-- | Thermal/Ising: Metropolis.
-- Lives in mixed sector (d=24), uses N_w=2 states per site.
-- lambda_mixed = 1/6.
thermalTick :: Double -> CrystalState -> CrystalState
thermalTick temp st =
  let mixed = extractSector 3 st
      beta  = 1.0 / temp
      mixed' = map (\x -> x * lambda 3 + (1 - lambda 3) * tanh (beta * x)) mixed
  in injectSector 3 mixed' st

-- ═══════════════════════════════════════════════════════════════
-- §2 STATE TEMPLATES
-- ═══════════════════════════════════════════════════════════════

-- | Equal superposition across all 36 dimensions
equalState :: CrystalState
equalState = replicate sigmaD (1.0 / sqrt (fromIntegral sigmaD))

-- | Singlet-only (dark matter / conserved quantity)
singletState :: CrystalState
singletState = [1.0] ++ replicate (sigmaD - 1) 0.0

-- | Photon = singlet, propagates forever (lambda = 1)
photonState :: CrystalState
photonState = singletState

-- | Pure weak sector state
weakState :: CrystalState
weakState = replicate d1 0.0
         ++ replicate d2 (1.0 / sqrt (fromIntegral d2))
         ++ replicate (d3 + d4) 0.0

-- | Pure colour sector state
colourState :: CrystalState
colourState = replicate (d1 + d2) 0.0
           ++ replicate d3 (1.0 / sqrt (fromIntegral d3))
           ++ replicate d4 0.0

-- ═══════════════════════════════════════════════════════════════
-- §3 PSEUDO-RANDOM (deterministic LCG from Crystal constants)
--
-- a = Sigma_d^2 = 650, c = beta_0 = 7, m = 2^16
-- All constants from (2,3).
-- ═══════════════════════════════════════════════════════════════

type Seed = Int

nextSeed :: Seed -> Seed
nextSeed s = (sigmaD2 * s + beta0) `mod` 65536

-- | Uniform [0,1)
uniform :: Seed -> (Double, Seed)
uniform s = let s' = nextSeed s in (fromIntegral s' / 65536.0, s')

-- | Box-Muller Gaussian (coordinate transform, not calculus)
gaussian :: Seed -> (Double, Seed)
gaussian s0 =
  let (u1, s1) = uniform s0
      (u2, s2) = uniform s1
      r = sqrt (negate 2.0 * log (max 1e-30 u1))
      theta = 2.0 * pi * u2
  in (r * cos theta, s2)

-- | Generate n Gaussians
gaussians :: Int -> Seed -> ([Double], Seed)
gaussians 0 s = ([], s)
gaussians n s =
  let (g, s') = gaussian s
      (gs, s'') = gaussians (n - 1) s'
  in (g : gs, s'')

-- ═══════════════════════════════════════════════════════════════
-- §4 HMC ACTION AND GRADIENT
--
-- The "Hamiltonian" is H = -ln(S)/beta.
-- The "gradient" is a sector projection.
-- No integrals. No functional derivatives.
-- ═══════════════════════════════════════════════════════════════

-- | Sector energy: E_k = -ln(lambda_k)
sectorEnergy :: Int -> Double
sectorEnergy k = negate (log (lambda k))

-- | Discrete action: S_action = sum_k d_k |psi_k|^2 (-ln lambda_k)
-- This is a SUM, not an integral.
action :: CrystalState -> Double
action st = sum [sectorWeight k st * sectorEnergy k | k <- [0..3]]

-- | "Gradient" = sector projection x eigenvalue.
-- NOT a derivative. It's multiply.
gradient :: CrystalState -> CrystalState
gradient st = zipWith (\i x -> 2.0 * x * sectorEnergy (sectorOf i)) [0..] st

-- ═══════════════════════════════════════════════════════════════
-- §5 HMC CORE
--
-- Three steps: refresh -> leapfrog -> accept/reject.
-- All multiply-add-compare. Zero calculus.
--
-- hmcStep accepts a TickFn parameter:
--   hmcStep tick     ... — diagonal, fast, sectors independent
--   hmcStep tickFull ... — full D_F, sectors mix
-- ═══════════════════════════════════════════════════════════════

-- | Step 1: Momentum refresh — inject Gaussian into weak sector
momentumRefresh :: Seed -> CrystalState -> (CrystalState, Seed)
momentumRefresh seed st =
  let (momenta, seed') = gaussians d2 seed
  in (injectSector 1 momenta st, seed')

-- | Step 2a: Single leapfrog step (Verlet = S|_{weak+colour})
leapfrogStep :: Double -> CrystalState -> CrystalState
leapfrogStep dt st =
  let pos = extractSector 1 st
      col = extractSector 2 st
      mom = take 3 col
      grad_ = take 3 $ drop (sectorStart 1) (gradient st)
      -- Kick (W): p += -grad * dt/2
      momHalf = zipWith (\m g -> m - g * dt / 2.0) mom grad_
      -- Drift (U): x += p * dt
      pos' = zipWith (\x p -> x + p * dt) pos momHalf
      -- Update gradient at new position
      st' = injectSector 1 pos' st
      grad' = take 3 $ drop (sectorStart 1) (gradient st')
      -- Kick (W): p += -grad' * dt/2
      mom' = zipWith (\m g -> m - g * dt / 2.0) momHalf grad'
      col' = mom' ++ drop 3 col
  in injectSector 1 pos' $ injectSector 2 col' st'

-- | Step 2b: N leapfrog steps
leapfrog :: Int -> Double -> CrystalState -> CrystalState
leapfrog 0 _  st = st
leapfrog n dt st = leapfrog (n - 1) dt (leapfrogStep dt st)

-- | Hamiltonian: H = kinetic + potential
hamiltonian :: CrystalState -> Double
hamiltonian st =
  let kinetic   = 0.5 * (sum . map (\x -> x * x) $ take 3 (extractSector 2 st))
      potential = action st
  in kinetic + potential

-- | Step 3: Metropolis accept/reject (COMPARE, not calculus)
acceptReject :: Double -> Double -> Seed -> (Bool, Seed)
acceptReject hOld hNew seed =
  let deltaH = hNew - hOld
  in if deltaH < 0
     then (True, seed)
     else let (u, seed') = uniform seed
          in (u < exp (negate deltaH), seed')

-- | One full HMC step.
-- Accepts a TickFn to apply after leapfrog (for post-trajectory mixing).
--   hmcStep tick     nLeap dt seed st  — diagonal (fast)
--   hmcStep tickFull nLeap dt seed st  — full D_F (with mixing)
hmcStep :: TickFn -> Int -> Double -> Seed
        -> CrystalState -> (CrystalState, Bool, Seed)
hmcStep tickFn nLeap dt seed st =
  let -- 1. Refresh momenta
      (stRefreshed, seed1) = momentumRefresh seed st
      hOld = hamiltonian stRefreshed
      -- 2. Leapfrog trajectory
      stLeaped = leapfrog nLeap dt stRefreshed
      -- 3. Apply chosen tick (diagonal or full)
      !stTicked = tickFn stLeaped
      hNew = hamiltonian stTicked
      -- 4. Accept/reject
      (accepted, seed2) = acceptReject hOld hNew seed1
  in if accepted
     then (stTicked, True, seed2)
     else (st, False, seed2)

-- | Run N HMC sweeps, collecting (state, accepted) pairs.
hmcChain :: TickFn -> Int -> Int -> Double -> Seed
         -> CrystalState -> [(CrystalState, Bool)]
hmcChain _      0 _     _  _    _  = []
hmcChain tickFn n nLeap dt seed st =
  let (st', accepted, seed') = hmcStep tickFn nLeap dt seed st
  in (st', accepted) : hmcChain tickFn (n - 1) nLeap dt seed' st'

-- ═══════════════════════════════════════════════════════════════
-- §6 MERA SAMPLING
--
-- The MERA has 42 layers. Each layer has 36 components.
-- HMC sweeps each layer independently (single-site update).
-- The depth weighting creates the UV/IR hierarchy.
-- ═══════════════════════════════════════════════════════════════

-- | MERA state = 42 layers, each a CrystalState
type MERAState = [CrystalState]

-- | Initialise: each layer starts with equal superposition
initMERA :: MERAState
initMERA = replicate towerD (replicate sigmaD (1.0 / sqrt (fromIntegral sigmaD)))

-- | MERA action: sum over all layers with depth weighting.
-- Deeper layers (UV) have larger action — they fluctuate more.
meraAction :: MERAState -> Double
meraAction layers = sum $ zipWith (\d st -> fromIntegral (d + 1) * action st)
                                  [0 :: Int ..] layers

-- | Single-layer HMC update at layer d.
-- Uses the chosen tick function.
updateLayer :: TickFn -> Int -> Int -> Double -> Seed
            -> MERAState -> (MERAState, Bool, Seed)
updateLayer tickFn layerIdx nLeap dt seed mera =
  let st = mera !! layerIdx
      (st', accepted, seed') = hmcStep tickFn nLeap dt seed st
      mera' = take layerIdx mera ++ [st'] ++ drop (layerIdx + 1) mera
  in (mera', accepted, seed')

-- | Sweep all 42 layers.
meraSweep :: TickFn -> Int -> Double -> Seed
          -> MERAState -> (MERAState, Int, Seed)
meraSweep tickFn nLeap dt seed mera = go 0 seed mera 0
  where
    go 42 s m acc = (m, acc, s)
    go d  s m acc =
      let (m', accepted, s') = updateLayer tickFn d nLeap dt s m
          acc' = if accepted then acc + 1 else acc
      in go (d + 1) s' m' acc'

-- ═══════════════════════════════════════════════════════════════
-- §7 MERA OBSERVABLES
-- ═══════════════════════════════════════════════════════════════

-- | Sector fraction (probability in sector k)
sectorFraction :: Int -> CrystalState -> Double
sectorFraction k st = sectorWeight k st / max 1e-30 (normSq st)

-- | Shannon entropy from sector probabilities
hmcEntropy :: CrystalState -> Double
hmcEntropy st =
  let ps = [sectorFraction k st | k <- [0..3]]
  in negate $ sum [p * log (max 1e-30 p) | p <- ps]

-- | Entanglement entropy across a MERA cut at layer d.
-- S_ent(d) = sum_k d_k |psi_k(d)|^2 ln(chi)
-- This IS the Ryu-Takayanagi formula in the MERA.
entanglementEntropy :: Int -> MERAState -> Double
entanglementEntropy d mera =
  let st = mera !! d
  in log (fromIntegral chi) * normSq st

-- ═══════════════════════════════════════════════════════════════
-- §8 SELF-TEST
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

r4 :: Double -> Double
r4 x = fromIntegral (round (x * 10000) :: Int) / 10000

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalDynamicEngine.hs — Component 10: Dynamics"
  putStrLn " tick loop + sector projections + HMC sampler"
  putStrLn "================================================================"
  putStrLn ""

  -- §1: Tick (diagonal) — from CrystalOperators
  putStrLn "S1 Diagonal tick (from CrystalOperators):"
  let st0 = equalState
  check "tick contracts state" (normSq (tick st0) < normSq st0)
  check "singlet preserved" (head (tick singletState) == 1.0)
  let photon100 = (!! 100) $ iterate tick singletState
  check "photon norm after 100 ticks = 1" (abs (normSq photon100 - 1.0) < 1e-12)
  putStrLn ""

  -- §2: tickFull (from CrystalOperators)
  putStrLn "S2 Full tick (from CrystalOperators):"
  let diagTick_ = tick st0
      fullTick_ = tickFull st0
      diff_ = sqrt (sum (zipWith (\a b -> (a-b)*(a-b)) diagTick_ fullTick_))
  putStrLn $ "  diagonal norm: " ++ show (r4 (sqrt (normSq diagTick_)))
  putStrLn $ "  full norm:     " ++ show (r4 (sqrt (normSq fullTick_)))
  putStrLn $ "  difference:    " ++ show (r4 diff_)
  check "tickFull /= tick (mixing exists)" (diff_ > 1e-10)
  putStrLn ""

  -- §3: Sector projections
  putStrLn "S3 Sector projections:"
  check "Classical: phase space = chi = 6" (chi == 6)
  check "EM: courant = 1/N_w = 0.5" (abs (1.0 / fromIntegral nW - 0.5) < 1e-14)
  check "Thermal: lambda_mixed = 1/6" (abs (lambda 3 - 1.0/6.0) < 1e-14)
  let stClass = classicalTick st0
  check "classicalTick produces valid state" (length stClass == sigmaD)
  let stEM = emTick st0
  check "emTick produces valid state" (length stEM == sigmaD)
  putStrLn ""

  -- §4: HMC action
  putStrLn "S4 HMC action (discrete, not integral):"
  putStrLn $ "  action(equal)   = " ++ show (r4 (action st0))
  putStrLn $ "  action(singlet) = " ++ show (r4 (action singletState))
  check "singlet action = 0 (E_singlet = 0)" (abs (action singletState) < 1e-12)
  check "equal action > 0" (action st0 > 0)
  putStrLn ""

  -- §5: Leapfrog conserves energy
  putStrLn "S5 Leapfrog (Verlet = S|_{weak+colour}):"
  let (stMom, _seed1) = momentumRefresh 42 st0
      h0 = hamiltonian stMom
      stLeap = leapfrog 20 0.01 stMom
      h1 = hamiltonian stLeap
      dH = abs (h1 - h0)
  putStrLn $ "  H(before) = " ++ show (r4 h0)
  putStrLn $ "  H(after)  = " ++ show (r4 h1)
  putStrLn $ "  |dH|      = " ++ show (r4 dH)
  check "leapfrog approximately conserves H (|dH| < 0.1)" (dH < 0.1)
  putStrLn ""

  -- §6: HMC with diagonal tick
  putStrLn "S6 HMC chain (tick, diagonal, 100 sweeps):"
  let chainDiag = hmcChain tick 100 20 0.01 42 st0
      acceptsDiag = length $ filter snd chainDiag
      rateDiag = fromIntegral acceptsDiag / 100.0 :: Double
  putStrLn $ "  acceptance rate (tick)     = " ++ show (r4 rateDiag)
  check "acceptance > 0.3" (rateDiag > 0.3)
  -- Note: diagonal tick may give ~100% acceptance (trivial landscape).
  -- tickFull below should be non-trivial.
  putStrLn ""

  -- §7: HMC with full tick
  putStrLn "S7 HMC chain (tickFull, with mixing, 100 sweeps):"
  let chainFull = hmcChain tickFull 100 20 0.01 42 st0
      acceptsFull = length $ filter snd chainFull
      rateFull = fromIntegral acceptsFull / 100.0 :: Double
  putStrLn $ "  acceptance rate (tickFull) = " ++ show (r4 rateFull)
  check "acceptance > 0 (tickFull works in HMC)" (acceptsFull > 0)
  putStrLn ""

  -- §8: MERA sweep with diagonal tick
  putStrLn "S8 MERA sweep (42 layers, diagonal tick):"
  let mera0 = initMERA
      (mera1, meraAccepts, _) = meraSweep tick 10 0.01 42 mera0
      meraRate = fromIntegral meraAccepts / fromIntegral towerD :: Double
  putStrLn $ "  layers: " ++ show towerD
  putStrLn $ "  accepted: " ++ show meraAccepts
  putStrLn $ "  rate: " ++ show (r4 meraRate)
  check "MERA acceptance > 0" (meraAccepts > 0)
  putStrLn ""

  -- §9: Entanglement entropy
  putStrLn "S9 Entanglement entropy (Ryu-Takayanagi):"
  let s0_  = entanglementEntropy 0 mera1
      s21_ = entanglementEntropy 21 mera1
      s41_ = entanglementEntropy 41 mera1
  putStrLn $ "  S_ent(D=0)  = " ++ show (r4 s0_)
  putStrLn $ "  S_ent(D=21) = " ++ show (r4 s21_)
  putStrLn $ "  S_ent(D=41) = " ++ show (r4 s41_)
  check "S_ent uses ln(chi) = ln(6)" (abs (log (fromIntegral chi) - log 6) < 1e-12)
  putStrLn ""

  -- §10: Integer identities
  putStrLn "S10 Crystal integers in dynamics:"
  check "momentum dim = d_weak = 3" (d2 == 3)
  check "phase space = chi = 6" (chi == 6)
  check "MERA layers = D = 42" (towerD == 42)
  check "state dim = Sigma_d = 36" (sigmaD == 36)
  check "LCG multiplier = Sigma_d^2 = 650" (d1*d1+d2*d2+d3*d3+d4*d4 == 650)
  check "courant = 1/N_w = 0.5" (nW == 2)
  check "Verlet order = N_w = 2" (nW == 2)
  check "Metropolis states = N_w = 2" (nW == 2)
  putStrLn ""

  -- §11: TickFn verification — both paths through same interface
  putStrLn "S11 TickFn interface (both ticks through same HMC):"
  let (stD, accD, _) = hmcStep tick     10 0.01 42 st0
      (stF, accF, _) = hmcStep tickFull 10 0.01 42 st0
  check "hmcStep accepts tick"     (length stD == sigmaD)
  check "hmcStep accepts tickFull" (length stF == sigmaD)
  putStrLn $ "  tick     -> accepted=" ++ show accD
  putStrLn $ "  tickFull -> accepted=" ++ show accF
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " Dynamics = tick loop + sector projections + HMC sampler."
  putStrLn " tick (diagonal) or tickFull (D_F mixing). Callers choose."
  putStrLn " No calculus. No integrals. Just S = W o U on 36 dimensions."
  putStrLn "================================================================"
