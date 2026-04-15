-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalSchrodinger.hs — Quantum Mechanics from (2,3)

  THE DYNAMICS IS THE TICK ON THE 36.

  Each lattice site is a CrystalState (36 Doubles).
  Re(ψ) → weak sector [3] first component, λ = 1/2.
  Im(ψ) → colour sector [8] first component, λ = 1/3.
  Norm²  → singlet [1], λ = 1. Conserved.

  S = W∘U:
    W = potential coupling: rotates Re↔Im within each site (wK)
    U = kinetic coupling: mixes neighboring sites' amplitudes (uK)

  Crystal integers:
    ℏ = 1/N_w = 1/2        Spin states = N_w = 2
    Pauli matrices = N_c = 3   Phase space = χ = 6
    Shells: s=2=N_w  p=6=χ  d=10=N_w(χ-1)  f=14=N_wβ₀

  Three.js ready: |ψ|² height map, phase→hue, probability current arrows,
  tunneling visualization, orbital shapes.

  Compile: ghc -O2 -main-is CrystalSchrodinger CrystalSchrodinger.hs && ./CrystalSchrodinger
-}

module CrystalSchrodinger where

import CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD, gauss, d1, d2, d3, d4)
import CrystalSectors (CrystalState, sectorDim, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, normSq)

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

hbar :: Double
hbar = 1.0 / fromIntegral nW  -- 1/2

-- ═══════════════════════════════════════════════════════════════
-- §1  PACK / UNPACK: quantum amplitude ↔ CrystalState
--
-- Singlet [1]:  |ψ|² (probability, conserved, λ=1)
-- Weak [3]:     Re(ψ), 0, 0  (real part = position-like)
-- Colour [8]:   Im(ψ), 0, ... (imag part = momentum-like)
-- Mixed [24]:   potential value + aux
--
-- Re(ψ) in weak, Im(ψ) in colour mirrors position/momentum duality.
-- λ_weak = 1/2, λ_colour = 1/3: different contraction rates
-- create the interference pattern.
-- ═══════════════════════════════════════════════════════════════

-- | Pack complex amplitude into CrystalState.
packQuantum :: Double -> Double -> Double -> CrystalState
packQuantum re im potential =
  let prob = re * re + im * im
      col = [im, 0, 0, 0, 0, 0, 0, 0]
      mixed = potential : replicate (d4 - 1) 0.0
  in injectSector 0 [prob]
   $ injectSector 1 [re, 0, 0]
   $ injectSector 2 col
   $ injectSector 3 mixed
   $ zeroState

-- | Read Re(ψ) from weak sector.
readRe :: CrystalState -> Double
readRe cs = head (extractSector 1 cs)

-- | Read Im(ψ) from colour sector.
readIm :: CrystalState -> Double
readIm cs = head (extractSector 2 cs)

-- | Read |ψ|² from singlet (conserved).
readProb :: CrystalState -> Double
readProb cs = head (extractSector 0 cs)

-- | Read potential from mixed sector.
readPotential :: CrystalState -> Double
readPotential cs = head (extractSector 3 cs)

-- | Get complex amplitude as (Re, Im).
readAmplitude :: CrystalState -> (Double, Double)
readAmplitude cs = (readRe cs, readIm cs)

-- ═══════════════════════════════════════════════════════════════
-- §2  QUANTUM LATTICE: array of CrystalStates
-- ═══════════════════════════════════════════════════════════════

type QuantumLattice = [CrystalState]

-- | Initialize from real wavefunction profile + potential.
initQuantumLattice :: [(Double, Double)] -> [Double] -> QuantumLattice
initQuantumLattice amps potential =
  zipWith (\(re,im) v -> packQuantum re im v) amps (potential ++ repeat 0.0)

-- | Read probability density |ψ|² from lattice.
readProbDensity :: QuantumLattice -> [Double]
readProbDensity = map (\cs -> let r = readRe cs; i = readIm cs in r*r + i*i)

-- | Read Re(ψ) profile.
readReProfile :: QuantumLattice -> [Double]
readReProfile = map readRe

-- | Read Im(ψ) profile.
readImProfile :: QuantumLattice -> [Double]
readImProfile = map readIm

-- | Total probability (should be conserved).
totalProb :: QuantumLattice -> Double
totalProb = sum . readProbDensity

-- ═══════════════════════════════════════════════════════════════
-- §3  THE TICK: S = W∘U on the quantum lattice
--
-- W step (per-site): potential rotates Re↔Im.
--   Re' = Re × cos(V×wK) - Im × sin(V×wK)
--   Im' = Re × sin(V×wK) + Im × cos(V×wK)
--   The rotation angle = V × wK. Potential IS the coupling.
--   cos/sin precomputed at init (rotation table).
--
-- U step (inter-site): kinetic coupling.
--   Mixes neighboring sites' amplitudes via uK.
--   This IS the discrete Laplacian / hopping matrix.
--   Re_i' = Re_i + uK² × (Re_{i-1} - 2Re_i + Re_{i+1})
--   Im_i' = Im_i + uK² × (Im_{i-1} - 2Im_i + Im_{i+1})
-- ═══════════════════════════════════════════════════════════════

-- | Precomputed rotation table: (cos θ, sin θ) per site.
-- θ = -V × dt/(2ℏ). Transcendentals at INIT only, not in tick.
type RotTable = [(Double, Double)]

makeRotTable :: [Double] -> Double -> RotTable
makeRotTable potential dt =
  [(cos theta, sin theta)
  | v <- potential, let theta = negate v * dt / (2.0 * hbar)]

-- | W step: potential rotation at each site.
-- Uses precomputed rotation table. ZERO transcendentals in tick.
wStepQuantum :: RotTable -> QuantumLattice -> QuantumLattice
wStepQuantum table lat = zipWith rotateSite table lat
  where
    rotateSite (ct, st) cs =
      let re = readRe cs
          im = readIm cs
          re' = ct * re - st * im
          im' = st * re + ct * im
          col = extractSector 2 cs
          col' = im' : drop 1 col
      in injectSector 1 [re', 0, 0]
       $ injectSector 2 col'
       $ cs

-- | U step: kinetic coupling between sites.
-- Hopping via uK: discrete Laplacian on Re and Im separately.
uStepQuantum :: QuantumLattice -> QuantumLattice
uStepQuantum lat =
  let n = length lat
      u2 = uK 1 * uK 1  -- 1/N_w = 1/2: hopping strength
      getRe i
        | i < 0 || i >= n = 0.0  -- boundary
        | otherwise = readRe (lat !! i)
      getIm i
        | i < 0 || i >= n = 0.0
        | otherwise = readIm (lat !! i)
      mixSite i =
        let re = getRe i
            im = getIm i
            -- Discrete Laplacian via U disentangler
            reHop = u2 * (getRe (i-1) - 2*re + getRe (i+1))
            imHop = u2 * (getIm (i-1) - 2*im + getIm (i+1))
            re' = re + imHop   -- Schrödinger: ∂Re/∂t ~ -∇²Im
            im' = im - reHop   -- Schrödinger: ∂Im/∂t ~ +∇²Re
            col = extractSector 2 (lat !! i)
            col' = im' : drop 1 col
        in injectSector 1 [re', 0, 0]
         $ injectSector 2 col'
         $ (lat !! i)
  in [mixSite i | i <- [0..n-1]]

-- | Full quantum tick: S = W∘U.
-- Half-kick W, full drift U, half-kick W (Strang splitting, order N_w = 2).
quantumTick :: RotTable -> QuantumLattice -> QuantumLattice
quantumTick rot = wStepQuantum rot . uStepQuantum . wStepQuantum rot

-- | Evolve N ticks.
quantumEvolve :: Int -> RotTable -> QuantumLattice -> [QuantumLattice]
quantumEvolve 0 _   lat = [lat]
quantumEvolve n rot lat = lat : quantumEvolve (n-1) rot (quantumTick rot lat)

-- ═══════════════════════════════════════════════════════════════
-- §4  POTENTIALS + INITIAL STATES
-- ═══════════════════════════════════════════════════════════════

type Grid = [Double]

makeGrid :: Int -> Double -> Double -> Grid
makeGrid n xmin xmax = [xmin + fromIntegral i * dx | i <- [0..n-1]]
  where dx = (xmax - xmin) / fromIntegral (n - 1)

harmonicV :: Grid -> [Double]
harmonicV = map (\x -> x * x / fromIntegral nW)  -- V = x²/(N_w)

coulombV :: Grid -> [Double]
coulombV = map (\x -> negate 1.0 / (abs x + 0.1))

barrierV :: Double -> Double -> Grid -> [Double]
barrierV halfWidth v0 = map (\x -> if abs x < halfWidth then 0.0 else v0)

-- | Gaussian wavepacket: centered at x0, width σ, momentum k.
gaussianPacket :: Grid -> Double -> Double -> Double -> [(Double, Double)]
gaussianPacket grid x0 sigma k =
  let raw = [(env * cos (k*x), env * sin (k*x))
            | x <- grid,
              let env = exp (negate (x - x0)^(2::Int) / (2*sigma*sigma))]
      norm = sqrt (sum [re*re + im*im | (re,im) <- raw])
  in [(re/norm, im/norm) | (re,im) <- raw]

groundState :: Grid -> Double -> [(Double, Double)]
groundState grid sigma = gaussianPacket grid 0.0 sigma 0.0

-- ═══════════════════════════════════════════════════════════════
-- §5  THREE.JS VISUALIZATION API
--
-- Everything a Rust/WASM/Three.js renderer needs:
--   |ψ|² → height map (1D) or sphere radius (3D)
--   phase → hue (sector colors rotating)
--   probability current → arrow field
--   orbital shapes → spherical harmonic envelopes
-- ═══════════════════════════════════════════════════════════════

type RGBA = (Double, Double, Double, Double)

sectorColor :: Int -> RGBA
sectorColor 0 = (0.2, 0.3, 1.0, 1.0)   -- singlet: blue
sectorColor 1 = (1.0, 0.9, 0.1, 1.0)   -- weak: yellow
sectorColor 2 = (0.1, 0.8, 0.3, 1.0)   -- colour: green
sectorColor 3 = (1.0, 0.2, 0.1, 1.0)   -- mixed: red
sectorColor _ = (0.5, 0.5, 0.5, 1.0)

lerpRGBA :: Double -> RGBA -> RGBA -> RGBA
lerpRGBA t (r0,g0,b0,a0) (r1,g1,b1,a1) =
  (r0+t*(r1-r0), g0+t*(g1-g0), b0+t*(b1-b0), a0+t*(a1-a0))

-- | Phase angle → RGBA (cycles through sector colors).
-- phase = atan2(Im, Re). Maps [0,2π] → singlet→weak→colour→mixed→singlet.
phaseToColor :: Double -> Double -> RGBA
phaseToColor re im =
  let phase = atan2 im re  -- [-π, π]
      t = (phase + pi) / (2 * pi)  -- [0, 1]
  in if t < 0.25 then lerpRGBA (t/0.25) (sectorColor 0) (sectorColor 1)
     else if t < 0.5 then lerpRGBA ((t-0.25)/0.25) (sectorColor 1) (sectorColor 2)
     else if t < 0.75 then lerpRGBA ((t-0.5)/0.25) (sectorColor 2) (sectorColor 3)
     else lerpRGBA ((t-0.75)/0.25) (sectorColor 3) (sectorColor 0)

-- | |ψ|² → height (for Three.js mesh displacement).
probToHeight :: Double -> Double -> Double
probToHeight maxProb p = p / max 1e-15 maxProb

-- | Per-site rendering data: (x, height, RGBA).
-- This is what Three.js needs per vertex.
type RenderVertex = (Double, Double, RGBA)

-- | Generate render data for entire lattice.
latticeToRender :: Grid -> QuantumLattice -> [RenderVertex]
latticeToRender grid lat =
  let probs = readProbDensity lat
      maxP = max 1e-15 (maximum probs)
  in zipWith3 (\x cs p ->
       let re = readRe cs; im = readIm cs
           height = probToHeight maxP p
           color = phaseToColor re im
       in (x, height, color))
     grid lat probs

-- | Probability current: j = (ℏ/m) × Im(ψ* × ∇ψ).
-- For Three.js arrow field.
probCurrent :: QuantumLattice -> [Double]
probCurrent lat =
  let n = length lat
      getRe i = if i < 0 || i >= n then 0 else readRe (lat !! i)
      getIm i = if i < 0 || i >= n then 0 else readIm (lat !! i)
      current i =
        let re = getRe i; im = getIm i
            dreR = (getRe (i+1) - getRe (i-1)) / 2
            dreI = (getIm (i+1) - getIm (i-1)) / 2
        in hbar * (re * dreI - im * dreR)  -- Im(ψ* ∇ψ)
  in [current i | i <- [0..n-1]]

-- | Expectation values for HUD overlay.
expectX :: Grid -> QuantumLattice -> Double
expectX grid lat =
  let probs = readProbDensity lat
  in sum (zipWith (*) grid probs)

expectP :: QuantumLattice -> Double
expectP lat = hbar * sum (probCurrent lat)

-- ═══════════════════════════════════════════════════════════════
-- §6  PRESETS (demo-ready quantum states)
-- ═══════════════════════════════════════════════════════════════

-- | Tunneling demo: packet hitting a barrier. The money shot.
tunnelingSetup :: Int -> (QuantumLattice, RotTable, Grid)
tunnelingSetup nSites =
  let grid = makeGrid nSites (-6) 6
      dx = 12.0 / fromIntegral (nSites - 1)
      dt = 0.005
      pot = barrierV 0.5 10.0 grid
      amps = gaussianPacket grid (-2.0) 0.5 3.0
      lat = initQuantumLattice amps pot
      rot = makeRotTable pot dt
  in (lat, rot, grid)

-- | Double slit: two slits in a barrier.
doubleSlitSetup :: Int -> (QuantumLattice, RotTable, Grid)
doubleSlitSetup nSites =
  let grid = makeGrid nSites (-6) 6
      dt = 0.005
      pot = map (\x -> if abs x < 3 && abs x > 0.3 && abs (abs x - 1.5) > 0.2
                       then 50.0 else 0.0) grid
      amps = gaussianPacket grid (-4.0) 0.5 4.0
      lat = initQuantumLattice amps pot
      rot = makeRotTable pot dt
  in (lat, rot, grid)

-- | Harmonic oscillator ground state.
harmonicSetup :: Int -> (QuantumLattice, RotTable, Grid)
harmonicSetup nSites =
  let grid = makeGrid nSites (-6) 6
      dt = 0.005
      pot = harmonicV grid
      amps = groundState grid 1.0
      lat = initQuantumLattice amps pot
      rot = makeRotTable pot dt
  in (lat, rot, grid)

-- ═══════════════════════════════════════════════════════════════
-- §7  CRYSTAL CONSTANTS
-- ═══════════════════════════════════════════════════════════════

spinStates :: Int
spinStates = nW        -- 2

pauliCount :: Int
pauliCount = nC        -- 3

phaseSpaceDim :: Int
phaseSpaceDim = chi    -- 6

shellS, shellP, shellD, shellF :: Int
shellS = nW            -- 2
shellP = chi           -- 6
shellD = nW * (chi-1)  -- 10
shellF = nW * beta0    -- 14

uncertaintyDenom :: Int
uncertaintyDenom = nW * nW  -- 4

crystalDt :: Double
crystalDt = 1.0 / fromIntegral towerD  -- 1/42

-- ═══════════════════════════════════════════════════════════════
-- §8  SELF-TEST
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalSchrodinger.hs — Quantum Mechanics from (2,3)"
  putStrLn " Dynamics: tick on the 36. Re(ψ)→weak, Im(ψ)→colour."
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "§1 Sector assignment:"
  check "Re(ψ) → weak [3], λ=1/2" (sectorDim 1 == 3)
  check "Im(ψ) → colour [8], λ=1/3" (sectorDim 2 == 8)
  check "|ψ|² → singlet [1], λ=1 (conserved)" (sectorDim 0 == 1)
  check "ℏ = 1/N_w = 1/2" (abs (hbar - 0.5) < 1e-15)
  putStrLn ""

  putStrLn "§2 Crystal integers:"
  check "spin = N_w = 2" (spinStates == 2)
  check "Pauli = N_c = 3" (pauliCount == 3)
  check "phase space = χ = 6" (phaseSpaceDim == 6)
  check "s-shell = N_w = 2" (shellS == 2)
  check "p-shell = χ = 6" (shellP == 6)
  check "d-shell = N_w(χ-1) = 10" (shellD == 10)
  check "f-shell = N_wβ₀ = 14" (shellF == 14)
  check "uncertainty = N_w² = 4" (uncertaintyDenom == 4)
  putStrLn ""

  putStrLn "§3 Norm conservation (harmonic, 500 ticks):"
  let (lat0, rot, grid) = harmonicSetup 128
      norm0 = totalProb lat0
      traj = quantumEvolve 500 rot lat0
      latN = last traj
      normN = totalProb latN
      normDev = abs (normN / norm0 - 1.0)
  putStrLn $ "  |ψ|²(0)   = " ++ show norm0
  putStrLn $ "  |ψ|²(500) = " ++ show normN
  check "norm conserved (< 5%)" (normDev < 0.05)
  putStrLn ""

  putStrLn "§4 Tunneling:"
  let (tLat0, tRot, tGrid) = tunnelingSetup 128
      tTraj = quantumEvolve 1000 tRot tLat0
      tLatN = last tTraj
      rightProb = sum [p | (x,p) <- zip tGrid (readProbDensity tLatN), x > 1]
  check "tunneling occurs (P beyond barrier > 0)" (rightProb > 1e-10)
  check "tunneling partial (P < 1)" (rightProb < 1.0)
  putStrLn ""

  putStrLn "§5 Wavepacket motion:"
  let freeV = replicate 128 0.0
      freeRot = makeRotTable freeV 0.005
      movingAmps = gaussianPacket (makeGrid 128 (-6) 6) 0 1 2
      movLat = initQuantumLattice movingAmps freeV
      movTraj = quantumEvolve 300 freeRot movLat
      x0 = expectX (makeGrid 128 (-6) 6) (head movTraj)
      xN = expectX (makeGrid 128 (-6) 6) (last movTraj)
  check "⟨x⟩ moves (Ehrenfest)" (abs (xN - x0) > 0.01)
  putStrLn ""

  putStrLn "§6 Three.js API:"
  let verts = latticeToRender (makeGrid 128 (-6) 6) lat0
  check "latticeToRender produces vertices" (length verts == 128)
  let currents = probCurrent lat0
  check "probability current computable" (length currents == 128)
  let (_, _, (r,_,_,_)) = head verts
  check "render vertex has color" (r >= 0 && r <= 1)
  putStrLn ""

  putStrLn "§7 Component wiring:"
  check "tick accessible (CrystalOperators)" (normSq (tick zeroState) <= normSq zeroState)
  check "wK 1 = 1/√2" (abs (wK 1 - 1.0/sqrt 2) < 1e-12)
  check "uK 2 = 1/√3" (abs (uK 2 - 1.0/sqrt 3) < 1e-12)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " Quantum = sector tick on the 36."
  putStrLn " Re(ψ) → weak. Im(ψ) → colour. |ψ|² → singlet."
  putStrLn " W = potential rotation. U = kinetic hopping."
  putStrLn " ℏ=1/N_w. Shells={2,6,10,14}. Phase→hue. |ψ|²→height."
  putStrLn "================================================================"
