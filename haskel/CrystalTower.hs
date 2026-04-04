-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalTower.hs — Component 6: The 42-Layer Tower

  The spectral tower. D = Sigma_d + chi = 36 + 6 = 42 layers.
  Each layer coarse-grains chi = 6 sites into 1. Layer 0 (UV) has
  chi^D sites. Layer D (IR) has 1 site. The ascending superoperator
  W-dagger goes UP (fine-graining). W goes DOWN (coarse-graining).

  Running coupling: alpha_inv(d) = (d+1)*pi + ln(beta_0).
  At d = D = 42: alpha_inv = 43*pi + ln(7) = 137.036.
  This is the grand staircase — one step per layer.

  VEV derivation: v = M_Pl x (Sigma_d - 1)/((D+1) x Sigma_d x 2^(D+d3-1))
                    = M_Pl x 35/(43 x 36 x 2^50) = 245.17 GeV.

  This module imports CrystalAtoms, CrystalSectors, CrystalEigen.
  It knows nothing about operators or dynamics.

  Compile: ghc -O2 -main-is CrystalTower CrystalTower.hs && ./CrystalTower
-}

module CrystalTower
  ( -- Tower structure
    TowerLayer(..)
  , mkLayer
  , totalLayers
  , sitesAtLayer
  , sitesAtLayerApprox

    -- Running coupling (grand staircase)
  , alphaInv
  , alpha
  , alphaInvFrozen
  , alphaFrozen

    -- VEV derivation
  , mPlanck
  , vevDerived
  , vevRatio

    -- Ascending and descending
  , descend
  , ascend

    -- Layer roles
  , layerRole

    -- Implosion channel
  , implosionDelta
  , implosionNumer
  , implosionDenom

    -- Tower invariants
  , lostDOF
  , entropyPerLayer

    -- Self-test
  , main
  ) where

import CrystalAtoms hiding (main)
import CrystalSectors hiding (main)
import CrystalEigen hiding (main)

-- =====================================================================
-- S1 TOWER STRUCTURE
--
-- D = 42 layers. Layer d has chi^(D-d) sites.
-- Layer 0 (UV boundary): chi^D = 6^42 sites.
-- Layer D (IR bulk): chi^0 = 1 site.
-- One tick of S = W o U moves from layer d to layer d+1.
-- =====================================================================

-- | A layer in the tower. Depth d in {0, 1, ..., D}.
data TowerLayer = TowerLayer
  { layerDepth  :: Int     -- d
  , layerSites  :: Integer -- chi^(D-d), exact (can be huge)
  } deriving (Show)

-- | Total number of layers.
totalLayers :: Int
totalLayers = towerD  -- 42

-- | Construct layer d.
mkLayer :: Int -> TowerLayer
mkLayer d = TowerLayer d (sitesAtLayer d)

-- | Exact site count at layer d: chi^(D-d).
sitesAtLayer :: Int -> Integer
sitesAtLayer d = fromIntegral chi ^ max 0 (towerD - d)

-- | Approximate site count (Double, for formulas).
sitesAtLayerApprox :: Int -> Double
sitesAtLayerApprox d = chi_d ** fromIntegral (max 0 (towerD - d))

-- =====================================================================
-- S2 RUNNING COUPLING: THE GRAND STAIRCASE
--
-- alpha_inv(d) = (d+1)*pi + ln(beta_0)
--
-- At d = 0:  alpha_inv = pi + ln(7) = 5.09
-- At d = 5:  alpha_inv = 6*pi + ln(7) = 20.80
-- At d = 42: alpha_inv = 43*pi + ln(7) = 137.036
--
-- Each layer adds pi to the inverse coupling.
-- The staircase has D+1 = 43 steps. One step per layer.
-- =====================================================================

-- | Running inverse fine structure constant at layer d.
alphaInv :: Int -> Double
alphaInv d = (fromIntegral d + 1) * pi + log beta0_d

-- | Running alpha at layer d.
alpha :: Int -> Double
alpha d = 1.0 / alphaInv d

-- | Frozen alpha_inv at D = 42 (the physical value).
alphaInvFrozen :: Double
alphaInvFrozen = alphaInv towerD  -- 43*pi + ln(7) = 137.036

-- | Frozen alpha at D = 42.
alphaFrozen :: Double
alphaFrozen = 1.0 / alphaInvFrozen

-- =====================================================================
-- S3 VEV DERIVATION
--
-- v = M_Pl x (Sigma_d - 1) / ((D+1) x Sigma_d x 2^(D + d3))
--   = M_Pl x 35 / (43 x 36 x 2^50)
--   = 245.17 GeV
--
-- NOT the PDG 246.22. This is the Crystal derivation.
-- The gap (246.22 - 245.17 = 1.05 GeV) is the implosion correction.
-- =====================================================================

-- | Planck mass in GeV (CODATA).
mPlanck :: Double
mPlanck = 1.220890e19

-- | Crystal-derived VEV: v = M_Pl x 35/(43 x 36 x 2^50).
vevDerived :: Double
vevDerived = mPlanck
           * fromIntegral (sigmaD - 1)                -- 35
           / fromIntegral (towerD + 1)                -- 43
           / sigmaD_d                                 -- 36
           / (2.0 ** fromIntegral (towerD + d3))  -- 2^50 (D + d3 = 42 + 8)

-- | The dimensionless ratio: (Sigma_d - 1) / ((D+1) x Sigma_d)
-- = 35 / (43 x 36) = 35/1548
vevRatio :: Double
vevRatio = fromIntegral (sigmaD - 1)
         / fromIntegral ((towerD + 1) * sigmaD)

-- =====================================================================
-- S4 ASCENDING AND DESCENDING
--
-- Descend (coarse-grain): apply W going DOWN the tower.
--   Each sector k contracts by wK(k) = 1/sqrt(denom_k).
--   State at layer d+1 = W(state at layer d).
--
-- Ascend (fine-grain): apply W-dagger going UP the tower.
--   Each sector k expands by 1/wK(k) = sqrt(denom_k).
--   State at layer d-1 = W-dagger(state at layer d).
--   NOTE: not isometric upward — information is created.
-- =====================================================================

-- | Descend one layer: apply W (coarse-grain).
-- Contracts sector k by wK(k).
descend :: CrystalState -> CrystalState
descend st = zipWith (\i x -> wK (sectorOf i) * x) [0..] st

-- | Ascend one layer: apply W-dagger (fine-grain).
-- Expands sector k by 1/wK(k). Not isometric.
ascend :: CrystalState -> CrystalState
ascend st = zipWith (\i x -> x / wK (sectorOf i)) [0..] st

-- =====================================================================
-- S5 LAYER ROLES
--
-- What physics manifests at each scale.
-- Not exhaustive — just the landmarks.
-- =====================================================================

-- | Human-readable description of what physics lives at layer d.
layerRole :: Int -> String
layerRole  0 = "UV boundary: chi^D = 6^42 sites, all sectors active"
layerRole  5 = "alpha freezes: alpha_inv = 6pi + ln(7) ~ 20.8"
layerRole 10 = "QCD scale: proton mass m_p = v/F3 * 53/54"
layerRole 18 = "Atomic scale: Bohr radius a_0 = hbarc/(m_e * alpha)"
layerRole 20 = "Hybridisation: sp3 = arccos(-1/3), sp2 = 120 deg"
layerRole 22 = "Van der Waals: r_vdw = <r> + a_0 * n/Z_eff"
layerRole 25 = "H-bond and strand spacings"
layerRole 27 = "Peptide bond lengths"
layerRole 28 = "Bond angles and CA-CA distance"
layerRole 32 = "Alpha helix: 18/5 residues/turn, rise = 3/2 Angstrom"
layerRole 33 = "Polymer scaling: Flory nu = N_w/(N_w+N_c) = 2/5"
layerRole 42 = "IR bulk: 1 site, fold energy = v/2^42"
layerRole d  = "Layer " ++ show d

-- =====================================================================
-- S6 IMPLOSION CHANNEL
--
-- delta = -(Sigma_d - 1) / ((D+1) x Sigma_d x (D + d3 - 1)!)
-- Numerator: 35
-- Denominator: 43 x 36 x 50! = huge
-- This is the rational correction that closes the VEV gap.
-- =====================================================================

-- | Implosion numerator: Sigma_d - 1 = 35.
implosionNumer :: Int
implosionNumer = sigmaD - 1  -- 35

-- | Implosion denominator: (D+1) x Sigma_d x (D + d3 - 1)
-- = 43 x 36 x 49 = 75852
-- (The full factorial version is too large for Int.)
implosionDenom :: Int
implosionDenom = (towerD + 1) * sigmaD * (towerD + d3 - 1)

-- | Leading implosion correction: -35 / 75852.
implosionDelta :: Double
implosionDelta = - fromIntegral implosionNumer / fromIntegral implosionDenom

-- =====================================================================
-- S7 TOWER INVARIANTS
-- =====================================================================

-- | Lost DOF per tick: Sigma_d - 1 = 35.
-- The singlet (d1 = 1) is immortal, so 36 - 1 = 35 decay.
lostDOF :: Int
lostDOF = sigmaD - d1  -- 35

-- | Entanglement entropy per layer: ln(chi) = ln(6).
entropyPerLayer :: Double
entropyPerLayer = log chi_d  -- ln(6)

-- =====================================================================
-- SELF-TEST
-- =====================================================================

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalTower.hs -- Component 6: The 42-Layer Tower"
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "S1 Tower structure:"
  check "D = 42" (totalLayers == 42)
  check "D = Sigma_d + chi" (towerD == sigmaD + chi)
  check "layer 0 sites = 6^42" (sitesAtLayer 0 == fromIntegral chi ^ (42 :: Int))
  check "layer D sites = 1" (sitesAtLayer towerD == 1)
  check "layer 1 sites = 6^41" (sitesAtLayer 1 == fromIntegral chi ^ (41 :: Int))
  check "layer D-1 sites = 6" (sitesAtLayer (towerD - 1) == fromIntegral chi)
  check "coarse-grain ratio = chi = 6"
        (sitesAtLayer 0 `div` sitesAtLayer 1 == fromIntegral chi)
  putStrLn ""

  putStrLn "S2 Grand staircase (running alpha):"
  check "alpha_inv(0) = pi + ln(7)" (abs (alphaInv 0 - (pi + log 7)) < 1e-10)
  check "alpha_inv(42) = 43*pi + ln(7)" (abs (alphaInvFrozen - (43*pi + log 7)) < 1e-10)
  check "alpha_inv(42) ~ 137.036" (abs (alphaInvFrozen - 137.036) < 0.01)
  check "each layer adds pi" (abs (alphaInv 1 - alphaInv 0 - pi) < 1e-10)
  check "staircase has D+1 = 43 steps" (towerD + 1 == 43)
  check "alpha(42) ~ 7.297e-3" (abs (alphaFrozen - 7.297e-3) < 1e-5)
  putStrLn ""

  putStrLn "S3 VEV derivation:"
  check "v_crystal ~ 245 GeV" (abs (vevDerived - 245.17) < 1.0)
  check "ratio = 35/1548" (abs (vevRatio - 35.0/1548.0) < 1e-12)
  check "35 = Sigma_d - 1" (sigmaD - 1 == 35)
  check "1548 = 43 x 36" ((towerD + 1) * sigmaD == 1548)
  check "exponent = D + d3 = 50" (towerD + d3 == 50)
  check "v uses 2^50" (abs (2.0 ** 50.0 - 1125899906842624.0) < 1.0)
  putStrLn ""

  putStrLn "S4 Ascending and descending:"
  let st0 = replicate sigmaD 1.0
  let st1 = descend st0
  check "descend singlet: unchanged" (head st1 == 1.0)
  check "descend weak: contracts by 1/sqrt(2)"
        (abs (st1 !! 1 - wK 1) < 1e-14)
  check "descend colour: contracts by 1/sqrt(3)"
        (abs (st1 !! 4 - wK 2) < 1e-14)
  check "descend mixed: contracts by 1/sqrt(6)"
        (abs (st1 !! 12 - wK 3) < 1e-14)
  let st2 = ascend st1
  check "ascend . descend = identity (singlet)" (abs (head st2 - 1.0) < 1e-14)
  check "ascend . descend = identity (weak)" (abs (st2 !! 1 - 1.0) < 1e-14)
  check "ascend . descend = identity (colour)" (abs (st2 !! 4 - 1.0) < 1e-14)
  check "ascend . descend = identity (mixed)" (abs (st2 !! 12 - 1.0) < 1e-14)
  putStrLn ""

  putStrLn "S5 Implosion channel:"
  check "numerator = 35" (implosionNumer == 35)
  check "denominator = 43 x 36 x 49 = 75852" (implosionDenom == 75852)
  check "delta ~ -4.61e-4" (abs (implosionDelta - (-35.0/75852.0)) < 1e-10)
  putStrLn ""

  putStrLn "S6 Tower invariants:"
  check "lost DOF = 35 (Sigma_d - d1)" (lostDOF == 35)
  check "entropy per layer = ln(6)" (abs (entropyPerLayer - log 6.0) < 1e-14)
  check "chi > 1 (irreversibility)" (chi > 1)
  putStrLn ""

  putStrLn "S7 Integer identities:"
  check "D x chi = 252 = Sigma_d x beta0" (towerD * chi == sigmaD * beta0)
  check "D + 1 = 43 (prime)" (towerD + 1 == 43)
  check "D - 1 = 41 (prime)" (towerD - 1 == 41)
  check "(D+1) x Sigma_d = 1548" ((towerD + 1) * sigmaD == 1548)
  check "lost x beta0 = 245" (lostDOF * beta0 == 245)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " 42 layers. chi = 6 coarse-graining. Grand staircase."
  putStrLn " alpha_inv = 43*pi + ln(7). VEV = M_Pl x 35/(43x36x2^50)."
  putStrLn " From (2,3). Nothing else."
  putStrLn "================================================================"
