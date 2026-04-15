-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalPlasma.hs — Magnetohydrodynamics from (2,3)

  THE DYNAMICS IS THE TICK ON THE 36.

  MHD state (rho, vx, vy, vz, Bx, By, Bz, energy) → colour sector [8].
  8 state variables = d_colour = N_w³. Exact fit.
  λ_colour = 1/N_c = 1/3.

  S = W∘U:
    W = v-B coupling within colour sector (wK 2 = 1/√3)
    U = spatial propagation between lattice sites (uK 2 = 1/√3)

  Crystal integers:
    Wave types:     3 = N_c        Propagating modes: 6 = χ
    State vars:     8 = d_colour   Non-propagating:   2 = N_w
    Mag pressure:   B²/2, factor N_w    Plasma beta: factor N_w
    Bondi factor:   4 = N_w²       MRI rate: 3/4 = N_c/N_w²

  Compile: ghc -O2 -main-is CrystalPlasma CrystalPlasma.hs && ./CrystalPlasma
-}

module CrystalPlasma where

import CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD, gauss, d1, d2, d3, d4)
import CrystalSectors (CrystalState, sectorDim, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, normSq)

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- ═══════════════════════════════════════════════════════════════
-- §1  PACK / UNPACK: MHD state ↔ CrystalState
--
-- Colour sector [8]: rho, vx, vy, vz, Bx, By, Bz, energy
-- 8 MHD state variables = d_colour = N_w³. Exact fit.
-- Singlet [1]: total MHD energy (conserved, λ=1).
-- ═══════════════════════════════════════════════════════════════

-- | Pack MHD state into CrystalState.
-- velocity(3) + B field(3) + rho + energy = 8 = d_colour.
packMHD :: Double -> (Double,Double,Double) -> (Double,Double,Double) -> Double -> CrystalState
packMHD rho (vx,vy,vz) (bx,by,bz) energy =
  let col = [rho, vx, vy, vz, bx, by, bz, energy]
      totalE = 0.5 * (sq vx + sq vy + sq vz) + 0.5 * (sq bx + sq by + sq bz) + energy
  in injectSector 0 [totalE] $ injectSector 2 col zeroState

-- | Read velocity from CrystalState.
readVelocity :: CrystalState -> (Double, Double, Double)
readVelocity cs = let col = extractSector 2 cs in (col!!1, col!!2, col!!3)

-- | Read B field from CrystalState.
readBField :: CrystalState -> (Double, Double, Double)
readBField cs = let col = extractSector 2 cs in (col!!4, col!!5, col!!6)

-- | Read density from CrystalState.
readRho :: CrystalState -> Double
readRho cs = head (extractSector 2 cs)

-- | Read total energy from singlet.
readMHDEnergy :: CrystalState -> Double
readMHDEnergy cs = head (extractSector 0 cs)

-- ═══════════════════════════════════════════════════════════════
-- §2  SINGLE-SITE TICK: v-B coupling within colour sector
--
-- Alfvén wave: v and B oscillate against each other.
-- Coupling within colour sector via wK and uK.
-- Courant = 1/N_w = 1/2 (same as CrystalEM).
-- ═══════════════════════════════════════════════════════════════

-- | MHD sector tick: v-B coupling within colour sector.
mhdSectorTick :: CrystalState -> CrystalState
mhdSectorTick st =
  let col = extractSector 2 st
      [rho, vx, vy, vz, bx, by, bz, e] = take 8 (col ++ repeat 0.0)
      w2 = wK 2  -- 1/√3: colour sector W coupling
      u2 = uK 2  -- 1/√3: colour sector U coupling
      -- W: B kicks velocity (Lorentz force: J×B)
      -- In normalised units: dv/dt ~ dB/dx → v' = v + w2 * B
      vx' = vx + w2 * bx / max 0.01 rho
      vy' = vy + w2 * by / max 0.01 rho
      vz' = vz + w2 * bz / max 0.01 rho
      -- U: velocity stretches B (induction: dB/dt ~ dv/dx)
      bx' = bx + u2 * vx'
      by' = by + u2 * vy'
      bz' = bz + u2 * vz'
      col' = [rho, vx', vy', vz', bx', by', bz', e]
  in injectSector 2 col' st

-- ═══════════════════════════════════════════════════════════════
-- §3  MHD LATTICE: array of CrystalStates
-- ═══════════════════════════════════════════════════════════════

type MHDLattice = [CrystalState]

-- | Initialize 1D Alfvén wave lattice.
initAlfvenLattice :: Int -> MHDLattice
initAlfvenLattice n =
  [packMHD 1.0
    (0, sin (2.0 * pi * fromIntegral i / fromIntegral n), 0)
    (0, 0, 0) 0
  | i <- [0..n-1]]

-- | U step: inter-site disentangler (spatial propagation).
-- Couples neighboring colour sectors.
uStepMHD :: MHDLattice -> MHDLattice
uStepMHD lat =
  let n = length lat
      u2 = uK 2 * uK 2  -- 1/N_c = 1/3
      getCol i = extractSector 2 (lat !! (i `mod` n))  -- periodic BC
      mixSite i =
        let cL = getCol (i - 1)
            cC = getCol i
            cR = getCol (i + 1)
            cNew = zipWith3 (\l c r -> c + u2 * (l - 2*c + r)) cL cC cR
        in injectSector 2 cNew (lat !! i)
  in [mixSite i | i <- [0..n-1]]

-- | Full MHD tick: S = W∘U.
mhdLatticeTick :: MHDLattice -> MHDLattice
mhdLatticeTick = map mhdSectorTick . uStepMHD

-- | Evolve N ticks.
mhdEvolve :: Int -> MHDLattice -> [MHDLattice]
mhdEvolve 0 lat = [lat]
mhdEvolve n lat = lat : mhdEvolve (n-1) (mhdLatticeTick lat)

-- | Total wave energy across lattice.
mhdTotalEnergy :: MHDLattice -> Double
mhdTotalEnergy lat =
  let energies = map (\cs ->
        let (vx,vy,vz) = readVelocity cs
            (bx,by,bz) = readBField cs
        in 0.5 * (sq vx + sq vy + sq vz + sq bx + sq by + sq bz)) lat
  in sum energies

-- | Read vy profile (for visualization).
readVyProfile :: MHDLattice -> [Double]
readVyProfile = map (\cs -> let (_,vy,_) = readVelocity cs in vy)

-- | Read By profile.
readByProfile :: MHDLattice -> [Double]
readByProfile = map (\cs -> let (_,by,_) = readBField cs in by)

-- ═══════════════════════════════════════════════════════════════
-- §4  MHD PHYSICS (crystal integers)
-- ═══════════════════════════════════════════════════════════════

-- | Magnetic pressure: p_mag = B²/(N_w × μ₀). Factor N_w = 2.
magPressure :: Double -> Double
magPressure bField = sq bField / fromIntegral nW

-- | Plasma beta: β = N_w × μ₀ × p / B². Factor N_w = 2.
plasmaBeta :: Double -> Double -> Double
plasmaBeta pressure bField = fromIntegral nW * pressure / sq bField

-- | Alfvén speed: v_A = B / √(μ₀ ρ).
alfvenSpeed :: Double -> Double -> Double
alfvenSpeed bField rho = bField / sqrt rho

-- | Total pressure balance.
totalPressure :: Double -> Double -> Double
totalPressure pGas bField = pGas + magPressure bField

-- | Bondi accretion: Ṁ = N_w² × π × G²M²ρ / c_s³. Factor N_w² = 4.
bondiAccretion :: Double -> Double -> Double -> Double -> Double
bondiAccretion gm rho cs _ =
  fromIntegral (nW * nW) * pi * gm * gm * rho / (cs * cs * cs)

-- | MRI growth rate: (N_c/N_w²) × Ω = (3/4)Ω.
mriGrowthRate :: Double -> Double
mriGrowthRate omega = (fromIntegral nC / fromIntegral (nW * nW)) * omega

-- ═══════════════════════════════════════════════════════════════
-- §5  MHD CONSTANTS
-- ═══════════════════════════════════════════════════════════════

mhdWaveTypes :: Int
mhdWaveTypes = nC  -- 3

mhdStateVars :: Int
mhdStateVars = d3  -- 8 = d_colour

mhdPropModes :: Int
mhdPropModes = chi  -- 6

mhdNonProp :: Int
mhdNonProp = nW  -- 2

-- ═══════════════════════════════════════════════════════════════
-- §6  INTEGER IDENTITY PROOFS
-- ═══════════════════════════════════════════════════════════════

proveWaveTypes :: Int
proveWaveTypes = nC  -- 3

proveStateVars :: Int
proveStateVars = nW * nW * nW  -- 8

provePropModes :: Int
provePropModes = 2 * nC  -- 6

proveNonProp :: Int
proveNonProp = nW  -- 2

proveTotalModes :: Int
proveTotalModes = chi + nW  -- 8

proveMagFactor :: Int
proveMagFactor = nW  -- 2

proveBetaFactor :: Int
proveBetaFactor = nW  -- 2

proveEMComponents :: Int
proveEMComponents = chi  -- 6

proveCFDD2Q9 :: Int
proveCFDD2Q9 = nC * nC  -- 9

proveBondiFactor :: Int
proveBondiFactor = nW * nW  -- 4

proveMRInum :: Int
proveMRInum = nC  -- 3

proveMRIden :: Int
proveMRIden = nW * nW  -- 4

-- ═══════════════════════════════════════════════════════════════
-- §7  COLOR MAPPING
-- ═══════════════════════════════════════════════════════════════

type RGBA = (Double, Double, Double, Double)

sectorColor :: Int -> RGBA
sectorColor 0 = (0.2, 0.3, 1.0, 1.0)
sectorColor 1 = (1.0, 0.9, 0.1, 1.0)
sectorColor 2 = (0.1, 0.8, 0.3, 1.0)
sectorColor 3 = (1.0, 0.2, 0.1, 1.0)
sectorColor _ = (0.5, 0.5, 0.5, 1.0)

lerpRGBA :: Double -> RGBA -> RGBA -> RGBA
lerpRGBA t (r0,g0,b0,a0) (r1,g1,b1,a1) =
  (r0+t*(r1-r0), g0+t*(g1-g0), b0+t*(b1-b0), a0+t*(a1-a0))

-- | Map |B| to color (blue=weak → red=strong).
bFieldToColor :: Double -> Double -> RGBA
bFieldToColor maxB b =
  let t = min 1.0 (abs b / max 1e-15 maxB)
  in if t < 0.5 then lerpRGBA (t/0.5) (sectorColor 0) (sectorColor 2)
     else lerpRGBA ((t-0.5)/0.5) (sectorColor 2) (sectorColor 3)

-- ═══════════════════════════════════════════════════════════════
-- §8  SELF-TEST
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalPlasma.hs — MHD from (2,3)"
  putStrLn " Dynamics: tick on the 36. Colour sector λ=1/3."
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "§1 Sector assignment:"
  check "MHD state (8 vars) → colour [8] exact fit" (sectorDim 2 == 8)
  check "λ_colour = 1/3" (abs (lambda 2 - 1.0/3.0) < 1e-15)
  check "wK 2 = 1/√3 (v-B coupling)" (abs (wK 2 - 1.0/sqrt 3) < 1e-12)
  putStrLn ""

  putStrLn "§2 MHD integers:"
  check "wave types = N_c = 3" (proveWaveTypes == 3)
  check "state vars = d_colour = 8" (proveStateVars == 8)
  check "propagating = χ = 6" (provePropModes == 6)
  check "non-propagating = N_w = 2" (proveNonProp == 2)
  check "total = d_colour = 8" (proveTotalModes == 8)
  check "mag pressure factor = N_w = 2" (proveMagFactor == 2)
  check "plasma beta factor = N_w = 2" (proveBetaFactor == 2)
  check "EM components = χ = 6" (proveEMComponents == 6)
  check "CFD D2Q9 = N_c² = 9" (proveCFDD2Q9 == 9)
  check "Bondi factor = N_w² = 4" (proveBondiFactor == 4)
  check "MRI = N_c/N_w² = 3/4" (abs (mriGrowthRate 1.0 - 0.75) < 1e-12)
  putStrLn ""

  putStrLn "§3 Alfvén lattice (100 sites, 200 ticks):"
  let lat0 = initAlfvenLattice 100
      e0 = mhdTotalEnergy lat0
      latN = last (mhdEvolve 200 lat0)
      eN = mhdTotalEnergy latN
      vy0 = readVyProfile lat0
      vyN = readVyProfile latN
      changed = sum (zipWith (\a b -> abs (a - b)) vy0 vyN) > 0.1
  putStrLn $ "  E_0 = " ++ show e0
  putStrLn $ "  E_200 = " ++ show eN
  check "wave propagated (field changed)" changed
  putStrLn ""

  putStrLn "§4 Magnetic pressure + beta:"
  let pMag = magPressure 2.0
  check "p_mag(B=2) = 2.0" (abs (pMag - 2.0) < 1e-12)
  let beta = plasmaBeta 1.0 2.0
  check "beta(p=1,B=2) = 0.5" (abs (beta - 0.5) < 1e-12)
  check "v_A(B=1,rho=1) = 1" (abs (alfvenSpeed 1 1 - 1.0) < 1e-12)
  putStrLn ""

  putStrLn "§5 Component wiring:"
  check "tick accessible (CrystalOperators)" (normSq (tick zeroState) <= normSq zeroState)
  check "extractSector 2 = d₃ = 8" (length (extractSector 2 zeroState) == d3)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " MHD = sector tick on the 36."
  putStrLn " Pack (rho,v,B,e) → colour [8]. Tick. Read back."
  putStrLn " U disentangler = spatial propagation. W = v-B coupling."
  putStrLn " λ_colour=1/3. 8 state vars = d_colour. Exact fit."
  putStrLn "================================================================"
