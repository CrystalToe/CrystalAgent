-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- |
Module      : CrystalVEV
Description : VEV mode selector — the Haskell equivalent of Toe()
License     : AGPL-3.0-or-later

== Design

@Toe()@           →  @vev Crystal@   =  245174 MeV  (ground truth, derived from M_Pl)
@Toe(vev="pdg")@  →  @vev PDG@       =  246220 MeV  (experimental extraction, for gap analysis)

The crystal-derived VEV is the DEFAULT because it is upstream of experiment.
The PDG value is an experimental extraction at a different renormalisation
scale. You opt INTO PDG for gap analysis, not out of it.

== The four-column gap table

To test formula accuracy with VEV scheme noise removed:

@
crystal     = vev Crystal       -- 245174 MeV
crystal_pdg = vev PDG           -- 246220 MeV

| Name  | Crystal            | CrystalPdg           | PDG        | Gap                |
|       | formula(crystal)   | formula(crystal_pdg)  | experiment | |PDG - CrystalPdg| |
@

Gap = |PDG − CrystalPdg| / PDG.  The REAL residual — formula accuracy
with VEV scheme noise completely removed.

== The conversion factor

The method 'vConversionFactor' derives the one-loop running factor
from N_w=2, N_c=3.  EVERY digit from (2,3).  No hardcoded scales.

@
115 GeV = v · √(N_w/N_c²) = v · √(2/9)     ← DERIVED, not input
91.2 GeV = v · N_c/(N_c²−1) = v · 3/8       ← DERIVED, not input
ratio = √N_w · d₃/N_c² = √2 · 8/9           ← pure algebra
factor = 1 + N_c/(16π²) · ln(ratio) = 1.00435
@

This factor is available for INSPECTION.  It explains WHY the Crystal
and CrystalPdg columns differ by ~0.42% for mass observables.  It is
NEVER applied inside any computation pipeline.  The four-column table
removes scheme noise by calling @vev@ with two different modes, not by
multiplying by this factor.
-}

module CrystalVEV
  ( -- * VEV mode
    VEVMode(..)
  , vev, vevGeV
    -- * Crystal constants (from N_w=2, N_c=3 only)
  , vCrystalMeV, vPdgMeV
  , vRatio
    -- * The conversion factor (explanatory — never applied automatically)
  , vConversionFactor
  , scaleRatio
  , muH, mZ_derived
    -- * Rescaling between modes
  , rescale
  ) where

-- ═══════════════════════════════════════════════════════════════════
-- §1  THE TWO PRIMES
-- ═══════════════════════════════════════════════════════════════════

-- | N_w = 2 (weak generations, dim M₂(ℂ) factor)
nW :: Int
nW = 2

-- | N_c = 3 (colours, dim M₃(ℂ) factor)
nC :: Int
nC = 3

-- | d₃ = N_c² − 1 = 8 (colour adjoint dimension)
d3 :: Int
d3 = nC^2 - 1

-- | Σd = 1 + N_c + (N_c²−1) + N_w³·N_c = 36 (total channel count)
sigmaD :: Int
sigmaD = 1 + nC + (nC^2 - 1) + nW^3 * nC

-- | D = Σd + χ = 36 + 6 = 42 (tower depth / MERA layers)
dTotal :: Int
dTotal = sigmaD + nW * nC

-- ═══════════════════════════════════════════════════════════════════
-- §2  VEV MODE
-- ═══════════════════════════════════════════════════════════════════

-- | Two modes.  No third mode.
--
--   'Crystal' = Toe().          Ground truth.  Derived from M_Pl.
--   'PDG'     = Toe(vev="pdg"). For gap analysis ONLY.
data VEVMode = Crystal | PDG
  deriving (Eq, Ord, Show, Read, Enum, Bounded)

-- | The ONE measured number: Planck mass in MeV.
mPlMeV :: Double
mPlMeV = 1.220890e22

-- | Crystal VEV derived from M_Pl.  Ground truth.
--
--   v(crystal) = M_Pl × (Σd−1) / ((D+1) · Σd · 2^(D+d₃))
--              = M_Pl × 35 / (43 × 36 × 2⁵⁰)
--              = 245174 MeV
vCrystalMeV :: Double
vCrystalMeV = mPlMeV
            * fromIntegral (sigmaD - 1)                              -- 35
            / fromIntegral (dTotal + 1)                              -- 43
            / fromIntegral sigmaD                                    -- 36
            / fromIntegral ((2 :: Integer) ^ (dTotal + nC^2 - 1))    -- 2⁵⁰

-- | PDG VEV.  Experimental extraction from G_F (muon lifetime).
--   Used for gap analysis ONLY.
vPdgMeV :: Double
vPdgMeV = 246220.0

-- | Get VEV in MeV for a given mode.
vev :: VEVMode -> Double
vev Crystal = vCrystalMeV
vev PDG     = vPdgMeV

-- | Get VEV in GeV for a given mode.
vevGeV :: VEVMode -> Double
vevGeV mode = vev mode / 1000.0

-- | Ratio v(PDG) / v(crystal).  Used internally for rescaling.
vRatio :: Double
vRatio = vPdgMeV / vCrystalMeV

-- ═══════════════════════════════════════════════════════════════════
-- §3  THE CONVERSION FACTOR (explanatory — never applied automatically)
-- ═══════════════════════════════════════════════════════════════════

-- | Scale ratio: μ_H / M_Z = √N_w · d₃ / N_c² = √2 · 8/9
--
--   NOT ln(115/91.2).  Those numbers are outputs, not inputs.
--
--   μ_H = v · √(N_w/N_c²) = v · √(2/9) → 115.6 GeV
--   M_Z = v · N_c/(N_c²−1) = v · 3/8    → 91.9 GeV
--
--   The ratio cancels v entirely.  Pure algebra from (2,3).
scaleRatio :: Double
scaleRatio = sqrt (fromIntegral nW)          -- √2
           * fromIntegral d3                 -- 8
           / fromIntegral (nC^2)             -- 9

-- | μ_H = v · √(N_w/N_c²).  DERIVED from v, N_w, N_c.
--   Returns GeV given v in GeV.
muH :: Double -> Double
muH v_gev = v_gev * sqrt (fromIntegral nW / fromIntegral (nC^2))

-- | M_Z = v · N_c/(N_c²−1).  DERIVED from v, N_c.
--   Returns GeV given v in GeV.
mZ_derived :: Double -> Double
mZ_derived v_gev = v_gev * fromIntegral nC / fromIntegral (nC^2 - 1)

-- | The one-loop running factor.  Derives everything from N_w=2, N_c=3.
--   No hardcoded scales.  Available for INSPECTION only.
--
-- @
--   N_w = 2                          ← from the algebra
--   N_c = 3                          ← from the algebra
--   d₃  = N_c² − 1 = 8              ← colour adjoint dimension
--   y_t = 1                          ← conformal fixed point at D = 0
--
--   scale_ratio = √N_w · d₃/N_c²    = √2 · 8/9 = 1.2571
--   factor = 1 + N_c/(16π²) · ln(scale_ratio)
--          = 1 + 3/157.91 · ln(1.2571)
--          = 1 + 0.01900 · 0.2289
--          = 1.00435
-- @
--
--   This factor explains WHY Crystal and CrystalPdg columns differ
--   by ~0.42% for mass observables.  It is never called inside any
--   computation pipeline.
vConversionFactor :: Double
vConversionFactor =
  let y_t = 1.0  -- conformal fixed point at D = 0
  in  1.0 + fromIntegral nC * y_t^(2::Int)    -- N_c · y_t²
          / (16.0 * pi * pi)                   -- / 16π²
          * log scaleRatio                     -- · ln(√N_w · d₃/N_c²)

-- ═══════════════════════════════════════════════════════════════════
-- §4  RESCALING BETWEEN MODES
-- ═══════════════════════════════════════════════════════════════════

-- | Rescale a value from one VEV mode to another.
--
--   Given a value computed at @from@ mode with v-dependence @vPower@,
--   return the same formula evaluated at @to@ mode.
--
--   v-power rules:
--     0  = dimensionless (α, sin²θ, Koide, CKM, ratios, constants)
--     1  = proportional to v (masses in GeV or MeV)
--     2  = proportional to v² (string tension, energies²)
--    -1  = proportional to 1/v (charge radius, hierarchy M_Pl/v)
--    -2  = proportional to 1/v² (Fermi constant G_F)
--
--   Examples:
--     rescale Crystal PDG 1  245.17   → 246.22  (mass, scale up)
--     rescale PDG Crystal 1  246.22   → 245.17  (mass, scale down)
--     rescale Crystal PDG 0  0.22222  → 0.22222 (dimensionless, unchanged)
--     rescale Crystal PDG (-2) gf     → gf / vRatio² (Fermi constant)
rescale :: VEVMode -> VEVMode -> Int -> Double -> Double
rescale from to vPower val
  | from == to = val
  | otherwise  = val * (vev to / vev from) ^^ vPower
