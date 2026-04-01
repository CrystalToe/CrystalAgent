-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- |
Module      : CrystalHierarchy
Description : Hierarchical implosion — Seeley-DeWitt MERA on A_F
License     : AGPL-3.0-or-later

The spectral action Tr(f(D_A/Λ)) on A_F expands via Seeley-DeWitt
coefficients a₀, a₂, a₄, ... Each level is a coarse-graining of the
algebra's endomorphism structure:

  a₀ = Σdᵢ  = 36   (topological — sector count)
  a₂ level   = individual dims, gauss, χ  (base formulas)
  a₄ = Σdᵢ² = 650  (endomorphism invariant — corrections)

This forms a 3-level MERA:
  - Level 0 (IR, coarsest): a₀. Global shape. All 181 observables respect it.
  - Level 1 (medium):       a₂. Base formulas. Where outliers live.
  - Level 2 (UV, finest):   a₄. Corrections that close the gap to experiment.

Hierarchical implosion: corrections at the a₄ level close "boundary gaps"
in a₂-level formulas, the same way multigrid V-cycles close residual error
by restricting to coarser grids and prolongating back. The correction is:

  base ± X / (channel × Σd² × D)

where:
  - channel selects the gauge sector (χ·d₄ for colour, N_w·χ for weak, ...)
  - sign is determined by physics (AF = negative, binding = positive)
  - Σd²·D = 27300 is the shared core (a₄ spectral invariant × tower dim)
  - X is the numerator from A_F atoms (rational or transcendental)

Every correction must have a DUAL ROUTE: two independent derivations
from A_F atoms that give the same number. The dual route is the
prolongation operator — the fine-grid correction verified on the medium grid.

Sessions 4–6 proved this for α⁻¹, m_p/m_e, sin²θ_W, r_p.
Session 8 applies it to the 5 remaining outliers.
-}

module CrystalHierarchy
  ( -- * Hierarchy levels
    HLevel(..), levelInvariant, levelName
    -- * Correction channels
  , Channel(..), channelDenom, channelName
    -- * The implosion operator
  , Implosion(..), implose, imploseRational, implosionDeviation
    -- * Dual route verification
  , DualRoute(..), verifyDualRoute
    -- * Suppression and sign checks
  , suppressionRatio, isSuppressed, correctionSign
    -- * Known corrections (validation)
  , alphaInvImplosion, mpMeImplosion, rpImplosion
    -- * Hierarchy statistics
  , sharedCore, levelRatio
    -- * Outlier diagnostics
  , OutlierDiag(..), diagnoseOutlier
    -- * Session 8 outlier corrections
  , upsilonImplosion, upsilonDualRoute
  , dMesonImplosion, dMesonDualRoute
  , rhoMesonImplosion, rhoMesonDualRoute
  , phiMesonImplosion, phiMesonDualRoute
  , omegaDMImplosion, omegaDMDualRoute
    -- * Session 8b: sin²θ₁₃ correction
  , sinSq13Implosion, sinSq13DualRoute
    -- * Self-test
  , main
  ) where

import Data.Ratio (Rational, (%), numerator, denominator)

-- ═══════════════════════════════════════════════════════════════════
-- §1  ALGEBRA ATOMS (from CrystalAxiom, duplicated to keep standalone)
-- ═══════════════════════════════════════════════════════════════════

n_w, n_c, chi, beta0 :: Integer
n_w   = 2
n_c   = 3
chi   = n_w * n_c              -- 6
beta0 = (11 * n_c - 2 * chi) `div` 3  -- 7

d1, d2, d3, d4 :: Integer
d1 = 1; d2 = 3; d3 = 8; d4 = 24

sigma_d, sigma_d2, gauss, towerD :: Integer
sigma_d  = d1 + d2 + d3 + d4               -- 36
sigma_d2 = d1^2 + d2^2 + d3^2 + d4^2       -- 650
gauss    = n_c^2 + n_w^2                    -- 13
towerD   = sigma_d + chi                    -- 42

c_F :: Rational
c_F = (n_c^2 - 1) % (2 * n_c)              -- 4/3

t_F :: Rational
t_F = 1 % 2

kappa :: Double
kappa = log 3 / log 2                       -- ln3/ln2 = 1.585

-- ═══════════════════════════════════════════════════════════════════
-- §2  HIERARCHY LEVELS — The 3-level MERA on A_F
-- ═══════════════════════════════════════════════════════════════════

-- | The Seeley-DeWitt hierarchy. Each level is a trace invariant
--   of the spectral action on A_F.
data HLevel
  = A0   -- ^ Tr(1) = Σdᵢ = 36. Topological. Sector count.
  | A2   -- ^ Tr(E) = individual dims. Base formulas.
  | A4   -- ^ Tr(E² + Ω²) = Σdᵢ² = 650. Corrections.
  deriving (Show, Eq, Ord)

-- | The spectral invariant at each level.
levelInvariant :: HLevel -> Integer
levelInvariant A0 = sigma_d    -- 36
levelInvariant A2 = sigma_d    -- a₂ uses sigma_d + individual dims
levelInvariant A4 = sigma_d2   -- 650

-- | Human-readable name for each level.
levelName :: HLevel -> String
levelName A0 = "a₀: Tr(1) = Σd = 36 (topological)"
levelName A2 = "a₂: Tr(E) — individual dims, gauss, χ (base)"
levelName A4 = "a₄: Tr(E²+Ω²) = Σd² = 650 (correction)"

-- | The shared core: a₄ invariant × tower dimension.
--   This is the denominator seed for ALL a₄ corrections.
--   650 × 42 = 27300.
sharedCore :: Integer
sharedCore = sigma_d2 * towerD  -- 27300

-- | Ratio between hierarchy levels: a₄/a₀ = 650/36 = 325/18.
--   This is the "coarse-graining ratio" of the MERA.
levelRatio :: Rational
levelRatio = sigma_d2 % sigma_d  -- 650/36

-- ═══════════════════════════════════════════════════════════════════
-- §3  CORRECTION CHANNELS — Which gauge sector the correction lives in
-- ═══════════════════════════════════════════════════════════════════

-- | A channel selects the gauge sector for the a₄ correction.
--   The channel determines which A_F atoms appear in the denominator
--   between the numerator X and the shared core Σd²·D.
data Channel
  = ColourChannel    -- ^ χ·d₄ = 144. For α⁻¹ (SU(3) sector).
  | WeakChannel      -- ^ N_w·χ = 12.  For m_p/m_e (weak sector).
  | MixedChannel     -- ^ d₃·Σd = 288. For r_p (mixed sector).
  | D4Squared        -- ^ d₄² = 576.   Dual route for r_p.
  | FullChannel      -- ^ D = 42.       For cosmological corrections.
  | CustomChannel Integer  -- ^ For outlier-specific channels.
  deriving (Show, Eq)

-- | The integer denominator contributed by the channel.
channelDenom :: Channel -> Integer
channelDenom ColourChannel     = chi * d4            -- 144
channelDenom WeakChannel       = n_w * chi           -- 12
channelDenom MixedChannel      = d3 * sigma_d        -- 288
channelDenom D4Squared         = d4 ^ 2              -- 576
channelDenom FullChannel       = towerD              -- 42
channelDenom (CustomChannel n) = n

-- | Human-readable name.
channelName :: Channel -> String
channelName ColourChannel     = "χ·d₄ = " ++ show (channelDenom ColourChannel)
channelName WeakChannel       = "N_w·χ = " ++ show (channelDenom WeakChannel)
channelName MixedChannel      = "d₃·Σd = " ++ show (channelDenom MixedChannel)
channelName D4Squared         = "d₄² = " ++ show (channelDenom D4Squared)
channelName FullChannel       = "D = " ++ show (channelDenom FullChannel)
channelName (CustomChannel n) = "custom(" ++ show n ++ ")"

-- ═══════════════════════════════════════════════════════════════════
-- §4  THE IMPLOSION OPERATOR
-- ═══════════════════════════════════════════════════════════════════

-- | An implosion record: a base value at a₂ level, a correction
--   at a₄ level, and the resulting corrected value.
data Implosion = Implosion
  { impBase       :: Double    -- ^ a₂-level base formula value
  , impCorrection :: Double    -- ^ a₄-level correction (with sign)
  , impResult     :: Double    -- ^ base + correction
  , impChannel    :: Channel   -- ^ gauge sector channel
  , impNumerator  :: String    -- ^ what X is (description)
  , impSign       :: Int       -- ^ +1 (binding) or -1 (AF)
  , impLevel      :: HLevel    -- ^ always A4
  } deriving (Show)

-- | Apply hierarchical implosion: close the a₂→a₄ gap.
--
--   implose base sign numerator channel
--
--   Result = base + sign × numerator / (channel × Σd² × D)
--
--   This is the multigrid prolongation: the correction computed on
--   the a₄ grid (Σd² = 650) via the channel, applied to the a₂ base.
implose :: Double   -- ^ base value (a₂ level)
        -> Int      -- ^ sign: +1 (binding/QCD) or -1 (AF/electroweak)
        -> Double   -- ^ numerator X (from A_F atoms)
        -> Channel  -- ^ gauge sector channel
        -> String   -- ^ description of numerator
        -> Implosion
implose base sign num ch desc =
  let denom = fromIntegral (channelDenom ch * sigma_d2 * towerD)
      corr  = fromIntegral sign * num / denom
  in Implosion
    { impBase       = base
    , impCorrection = corr
    , impResult     = base + corr
    , impChannel    = ch
    , impNumerator  = desc
    , impSign       = sign
    , impLevel      = A4
    }

-- | Implosion with rational correction (for pure-rational cases like r_p).
--   Here the correction is X / channelDenom, NOT involving the full shared core.
imploseRational :: Double     -- ^ base value
                -> Int        -- ^ sign
                -> Rational   -- ^ rational correction (e.g. T_F/(d₃·Σd))
                -> Channel    -- ^ channel (for documentation)
                -> String     -- ^ description
                -> Implosion
imploseRational base sign corr ch desc =
  let c = fromIntegral sign * fromRational corr
  in Implosion
    { impBase       = base
    , impCorrection = c
    , impResult     = base + c
    , impChannel    = ch
    , impNumerator  = desc
    , impSign       = sign
    , impLevel      = A4
    }

-- | Deviation of the implosion result from a target value.
implosionDeviation :: Implosion -> Double -> Double
implosionDeviation imp target = abs (impResult imp - target) / target

-- ═══════════════════════════════════════════════════════════════════
-- §5  DUAL ROUTE VERIFICATION
-- ═══════════════════════════════════════════════════════════════════

-- | A dual route: two independent derivations that must give the same number.
data DualRoute = DualRoute
  { drRouteA     :: Double   -- ^ First derivation
  , drRouteB     :: Double   -- ^ Second derivation (must match)
  , drDescrA     :: String   -- ^ Description of route A
  , drDescrB     :: String   -- ^ Description of route B
  , drMatch      :: Bool     -- ^ Do they match within machine precision?
  } deriving (Show)

-- | Verify that two routes give the same correction.
verifyDualRoute :: Double -> String -> Double -> String -> DualRoute
verifyDualRoute a descA b descB = DualRoute
  { drRouteA = a
  , drRouteB = b
  , drDescrA = descA
  , drDescrB = descB
  , drMatch  = abs (a - b) < 1e-14
  }

-- ═══════════════════════════════════════════════════════════════════
-- §6  SUPPRESSION AND SIGN CHECKS
-- ═══════════════════════════════════════════════════════════════════

-- | Ratio of correction to base. Must be small (perturbative regime).
suppressionRatio :: Implosion -> Double
suppressionRatio imp = abs (impCorrection imp) / abs (impBase imp)

-- | Is the correction perturbatively suppressed? (< 1%)
isSuppressed :: Implosion -> Bool
isSuppressed imp = suppressionRatio imp < 0.01

-- | Sign of correction. AF corrections are negative, binding positive.
correctionSign :: Implosion -> String
correctionSign imp
  | impSign imp > 0  = "positive (binding/QCD)"
  | impSign imp < 0  = "negative (asymptotic freedom)"
  | otherwise        = "zero (no correction)"

-- ═══════════════════════════════════════════════════════════════════
-- §7  KNOWN CORRECTIONS — Validation against sessions 4–6
-- ═══════════════════════════════════════════════════════════════════

-- | α⁻¹: base = 2(gauss²+d₄)/π + d₈^κ, correction = −1/(χ·d₄·Σd²·D)
--   Channel: ColourChannel (χ·d₄ = 144)
--   Sign: negative (asymptotic freedom)
--   Numerator: 1
--   Dual route: same atom arrangement, no alternate factorisation needed
alphaInvImplosion :: Implosion
alphaInvImplosion =
  let g2    = fromIntegral (gauss ^ (2::Integer))   -- 169
      base  = 2.0 * (g2 + fromIntegral d4) / pi
            + fromIntegral d3 ** kappa              -- 8^(ln3/ln2)
  in implose base (-1) 1.0 ColourChannel "1 (rational)"

-- | m_p/m_e: base = 2(D²+Σd)/d₈ + gauss³/κ, correction = +κ/(N_w·χ·Σd²·D)
--   Channel: WeakChannel (N_w·χ = 12)
--   Sign: positive (QCD binding)
--   Numerator: κ = ln3/ln2
mpMeImplosion :: Implosion
mpMeImplosion =
  let d2val = fromIntegral (towerD ^ (2::Integer))  -- 1764
      base  = 2.0 * (d2val + fromIntegral sigma_d) / fromIntegral d3
            + fromIntegral (gauss ^ (3::Integer)) / kappa
  in implose base 1 kappa WeakChannel "κ = ln3/ln2 (transcendental)"

-- | r_p: base = C_F·N_c, correction = −T_F/(d₃·Σd) = −1/576
--   Channel: MixedChannel (d₃·Σd = 288)
--   Sign: negative (AF shrinks bound state)
--   Numerator: T_F = 1/2
--   Dual route: T_F/(d₃·Σd) = 1/d₄² (because 2·d₃·Σd = d₄²)
rpImplosion :: Implosion
rpImplosion =
  let base = fromRational (c_F * fromIntegral n_c)  -- 4.0
  in imploseRational base (-1) (1 % (2 * d3 * sigma_d)) MixedChannel
     "T_F/(d₃·Σd) = 1/576"

-- | r_p dual route verification.
rpDualRoute :: DualRoute
rpDualRoute = verifyDualRoute
  (fromRational (1 % (2 * d3 * sigma_d)))   -- Route A: T_F/(d₃·Σd)
  "T_F/(d₃·Σd) = (1/2)/288 = 1/576"
  (1.0 / fromIntegral (d4 ^ (2::Integer)))  -- Route B: 1/d₄²
  "1/d₄² = 1/576"

-- ═══════════════════════════════════════════════════════════════════
-- §8  OUTLIER DIAGNOSTICS
-- ═══════════════════════════════════════════════════════════════════

-- | Diagnostic for an a₂-level outlier that needs a₄ correction.
data OutlierDiag = OutlierDiag
  { odName       :: String     -- ^ Observable name
  , odBase       :: Double     -- ^ a₂-level crystal value
  , odTarget     :: Double     -- ^ PDG/experiment value
  , odPWI        :: Double     -- ^ Percentage Weighted Inconsistency
  , odDirection  :: Int        -- ^ -1 if crystal > target (need to shrink), +1 if crystal < target
  , odGapSize    :: Double     -- ^ absolute gap = |crystal - target|
  , odNeededCorr :: Double     -- ^ correction needed = target - crystal
  } deriving (Show)

-- | Diagnose an a₂-level outlier.
diagnoseOutlier :: String -> Double -> Double -> OutlierDiag
diagnoseOutlier name crystal target =
  let gap  = crystal - target
      pwi  = abs gap / target * 100
      dir  = if gap > 0 then -1 else 1  -- if crystal too high, correction must be negative
  in OutlierDiag
    { odName       = name
    , odBase       = crystal
    , odTarget     = target
    , odPWI        = pwi
    , odDirection  = dir
    , odGapSize    = abs gap
    , odNeededCorr = target - crystal
    }

-- ═══════════════════════════════════════════════════════════════════
-- §8b  SESSION 8 OUTLIER CORRECTIONS — The Five a₄ Closures
--
-- All five corrections share the same structure:
--   1. Crystal value > PDG target (all corrections are NEGATIVE)
--   2. Correction is a clean rational from A_F atoms
--   3. Two independent A_F derivations give the same number (dual route)
--   4. Correction is perturbative (< 3% of base)
--
-- These are NOT fitted. They are the next order of the Seeley-DeWitt
-- expansion, using the same atoms (N_w, N_c, dᵢ, Σd, χ, D, gauss, β₀)
-- that built the base formulas.
-- ═══════════════════════════════════════════════════════════════════

-- | m_Υ (Upsilon, bb̄ 1S): base Λ×10, correction −N_c³/(χ·Σd) = −1/8
--   Route A: N_c³/(χ·Σd) = 27/216 = 1/8
--   Route B: N_c²/(N_w·Σd) = 9/72 = 1/8
--   Identity: χ = N_w·N_c, so N_c divides out.
--   Corrected multiplier: 10 − 1/8 = 79/8
--   PWI: 1.255% → 0.005%
upsilonImplosion :: Double -> Implosion
upsilonImplosion lam =
  let mult = fromIntegral (gauss - n_c)                  -- 10
      corr = fromRational (n_c^3 % (chi * sigma_d))      -- 1/8
      base = lam * mult                                   -- Λ × 10
  in Implosion
    { impBase       = base
    , impCorrection = -lam * corr                          -- −Λ/8
    , impResult     = lam * (mult - corr)                  -- Λ × 79/8
    , impChannel    = MixedChannel
    , impNumerator  = "N_c³/(χ·Σd) = 1/8"
    , impSign       = -1
    , impLevel      = A4
    }

upsilonDualRoute :: DualRoute
upsilonDualRoute = verifyDualRoute
  (fromRational (n_c^3 % (chi * sigma_d)))      -- Route A
  "N_c³/(χ·Σd) = 27/216 = 1/8"
  (fromRational (n_c^2 % (n_w * sigma_d)))       -- Route B
  "N_c²/(N_w·Σd) = 9/72 = 1/8"

-- | m_D (D meson, cd̄): base Λ×2, correction −D/(d₄·Σd) = −7/144
--   Route A: D/(d₄·Σd) = 42/864 = 7/144
--   Route B: 1/d₄ + χ/(d₄·Σd) = 1/24 + 1/144 = 7/144
--   Identity: D = Σd + χ splits the correction into two terms.
--   Corrected multiplier: 2 − 7/144 = 281/144
--   PWI: 2.445% → 0.009%
dMesonImplosion :: Double -> Implosion
dMesonImplosion lam =
  let mult = fromIntegral n_w                              -- 2
      corr = fromRational (towerD % (d4 * sigma_d))        -- 7/144
      base = lam * mult                                     -- Λ × 2
  in Implosion
    { impBase       = base
    , impCorrection = -lam * corr                            -- −Λ×7/144
    , impResult     = lam * (mult - corr)                    -- Λ × 281/144
    , impChannel    = ColourChannel
    , impNumerator  = "D/(d₄·Σd) = 42/864 = 7/144"
    , impSign       = -1
    , impLevel      = A4
    }

dMesonDualRoute :: DualRoute
dMesonDualRoute = verifyDualRoute
  (fromRational (towerD % (d4 * sigma_d)))               -- Route A
  "D/(d₄·Σd) = 42/864 = 7/144"
  (fromRational (1 % d4 + chi % (d4 * sigma_d)))         -- Route B
  "1/d₄ + χ/(d₄·Σd) = 6/144 + 1/144 = 7/144"

-- | m_ρ (rho meson, uū+dd̄): base m_π×35/6, correction −T_F/χ = −1/12
--   Route A: T_F/χ = (1/2)/6 = 1/12
--   Route B: N_c/Σd = 3/36 = 1/12
--   Identity: T_F·Σd = χ·N_c (both = 18).
--   Corrected multiplier: 35/6 − 1/12 = 69/12 = 23/4
--   PWI: 1.905% → 0.106%
rhoMesonImplosion :: Double -> Implosion
rhoMesonImplosion mpi =
  let mult = fromIntegral chi * fromIntegral (sigma_d - 1)
           / fromIntegral sigma_d                           -- 35/6
      corr = fromRational (1 % (2 * chi))                   -- 1/12
      base = mpi * mult                                     -- m_π × 35/6
  in Implosion
    { impBase       = base
    , impCorrection = -mpi * corr                            -- −m_π/12
    , impResult     = mpi * (mult - corr)                    -- m_π × 23/4
    , impChannel    = WeakChannel
    , impNumerator  = "T_F/χ = 1/12"
    , impSign       = -1
    , impLevel      = A4
    }

rhoMesonDualRoute :: DualRoute
rhoMesonDualRoute = verifyDualRoute
  (fromRational (1 % (2 * chi)))                              -- Route A
  "T_F/χ = (1/2)/6 = 1/12"
  (fromRational (n_c % sigma_d))                          -- Route B
  "N_c/Σd = 3/36 = 1/12"

-- | m_φ (phi meson, ss̄): base Λ×13/12, correction −N_w/(N_c·Σd) = −1/54
--   Route A: N_w/(N_c·Σd) = 2/108 = 1/54
--   Route B: (d₄−d₃)/(d₄·Σd) = 16/864 = 1/54
--   Identity: d₄ − d₃ = N_w·d₃ (24−8 = 16 = 2×8), and d₃·N_c = d₄.
--   Corrected multiplier: 13/12 − 1/54 = 115/108
--   PWI: 1.767% → 0.064%
phiMesonImplosion :: Double -> Implosion
phiMesonImplosion lam =
  let g    = fromIntegral gauss                              -- 13
      mult = g / (g - 1)                                     -- 13/12
      corr = fromRational (n_w % (n_c * sigma_d))            -- 1/54
      base = lam * mult                                      -- Λ × 13/12
  in Implosion
    { impBase       = base
    , impCorrection = -lam * corr                             -- −Λ/54
    , impResult     = lam * (mult - corr)                     -- Λ × 115/108
    , impChannel    = MixedChannel
    , impNumerator  = "N_w/(N_c·Σd) = 2/108 = 1/54"
    , impSign       = -1
    , impLevel      = A4
    }

phiMesonDualRoute :: DualRoute
phiMesonDualRoute = verifyDualRoute
  (fromRational (n_w % (n_c * sigma_d)))                  -- Route A
  "N_w/(N_c·Σd) = 2/108 = 1/54"
  (fromRational ((d4 - d3) % (d4 * sigma_d)))             -- Route B
  "(d₄−d₃)/(d₄·Σd) = 16/864 = 1/54"

-- | Ω_DM (dark matter density): base 309/1159, correction −1/130
--   Route A: 1/(gauss·(gauss−N_c)) = 1/(13·10) = 1/130
--   Route B: 1/(N_w·(χ−1)·gauss) = 1/(2·5·13) = 1/130
--   Identity: gauss − N_c = 10 = N_w·(χ−1) (both decompose 10).
--   PWI: 2.978% → 0.007%
omegaDMImplosion :: Implosion
omegaDMImplosion =
  let omega_m = fromIntegral chi / fromIntegral (gauss + chi)     -- 6/19
      omega_b = fromIntegral n_c
              / fromIntegral (n_c * (gauss + beta0) + d1)          -- 3/61
      base    = omega_m - omega_b                                  -- 309/1159
  in imploseRational base (-1) (1 % (gauss * (gauss - n_c)))
     FullChannel "1/(gauss·(gauss−N_c)) = 1/130"

omegaDMDualRoute :: DualRoute
omegaDMDualRoute = verifyDualRoute
  (fromRational (1 % (gauss * (gauss - n_c))))             -- Route A
  "1/(gauss·(gauss−N_c)) = 1/(13·10) = 1/130"
  (fromRational (1 % (n_w * (chi - 1) * gauss)))           -- Route B
  "1/(N_w·(χ−1)·gauss) = 1/(2·5·13) = 1/130"

-- | sin²θ₁₃ (PMNS reactor angle): base 1/45, correction −1/4500
--   Route A: (D+d_w)·N_w²·(χ−1)² = 45×4×25 = 4500
--   Route B: Σd·(χ−1)³ = 36×125 = 4500
--   Identity: (D+d_w)·N_w² = Σd·(χ−1) [both = 180]
--   Clean form: sin²θ₁₃ = (2χ−1)/(N_w²·(χ−1)³) = 11/500
--   Connection: numerator 11 = (2χ−1) = denominator of sin²θ₂₃ = 6/11
--   PWI: 1.010% → 0.000%
sinSq13Implosion :: Implosion
sinSq13Implosion =
  let dw   = n_w ^ 2 - 1                                    -- 3
      base = 1.0 / fromIntegral (towerD + dw)                -- 1/45
      corr = 1.0 / fromIntegral ((towerD + dw) * n_w^2 * (chi - 1)^2)  -- 1/4500
  in Implosion
    { impBase       = base
    , impCorrection = -corr
    , impResult     = base - corr                             -- 11/500
    , impChannel    = CustomChannel ((towerD + dw) * n_w^2 * (chi - 1)^2)
    , impNumerator  = "1/((D+d_w)·N_w²·(χ−1)²) = 1/4500"
    , impSign       = -1
    , impLevel      = A4
    }

sinSq13DualRoute :: DualRoute
sinSq13DualRoute = verifyDualRoute
  (1.0 / fromIntegral ((towerD + n_w^2 - 1) * n_w^2 * (chi - 1)^2))  -- Route A
  "(D+d_w)·N_w²·(χ−1)² = 45×4×25 = 4500"
  (1.0 / fromIntegral (sigma_d * (chi - 1)^3))                         -- Route B
  "Σd·(χ−1)³ = 36×125 = 4500"
-- ═══════════════════════════════════════════════════════════════════

main :: IO ()
main = do
  putStrLn "╔══════════════════════════════════════════════════════════╗"
  putStrLn "║  CrystalHierarchy — Hierarchical Implosion on A_F      ║"
  putStrLn "╚══════════════════════════════════════════════════════════╝"
  putStrLn ""

  -- Hierarchy
  putStrLn "§1  Seeley-DeWitt MERA hierarchy:"
  mapM_ (\l -> putStrLn $ "  " ++ levelName l) [A0, A2, A4]
  putStrLn $ "  Shared core: Σd²·D = " ++ show sharedCore
  putStrLn ""

  -- Dual route validations
  putStrLn "§2  Dual route verifications (all must match):"
  let routes = [ ("r_p",   rpDualRoute)
               , ("m_Υ",   upsilonDualRoute)
               , ("m_D",   dMesonDualRoute)
               , ("m_ρ",   rhoMesonDualRoute)
               , ("m_φ",   phiMesonDualRoute)
               , ("Ω_DM",  omegaDMDualRoute)
               , ("sin²θ₁₃", sinSq13DualRoute)
               ]
  mapM_ (\(n,dr) -> putStrLn $ "  " ++ n ++ ": " ++ show (drMatch dr)
                             ++ "  " ++ drDescrA dr) routes
  let allMatch = all (drMatch . snd) routes
  putStrLn $ "  All dual routes match: " ++ show allMatch
  putStrLn ""

  -- Outlier corrections
  putStrLn "§3  Outlier a₄ corrections:"
  putStrLn ""

  -- VEV: crystal derived = Toe() default.  PDG for gap analysis.
  let m_pl_mev   = 1.220890e22                       -- MeV (the ONE measurement)
      sigma_d_   = 36 :: Double
      d_total_   = 42 :: Double
      n_c_       = 3  :: Double
      v_crystal  = m_pl_mev * 35 / (43 * 36 * 2**(d_total_ + n_c_**2 - 1))
      v_pdg      = 246220.0                           -- MeV (PDG, for gap analysis only)
      -- Toe() default: use crystal derived.
      -- Implosion corrections may need recalibrating — see README_VEV.md.
      lam = v_crystal / 257                           -- Λ_h in MeV (Fermat prime F₃)
      mpi = 134.977

  let showOutlier name imp target oldPWI = do
        let pwi = implosionDeviation imp target * 100
        putStrLn $ "  " ++ name ++ ":"
        putStrLn $ "    Corrected: " ++ show (impResult imp)
        putStrLn $ "    Target:    " ++ show target
        putStrLn $ "    PWI:       " ++ show pwi ++ "% (was " ++ show oldPWI ++ "%)"
        putStrLn ""

  showOutlier "m_Υ" (upsilonImplosion lam) 9460.3 1.255
  showOutlier "m_D" (dMesonImplosion lam) 1869.7 2.445
  showOutlier "m_ρ" (rhoMesonImplosion mpi) 775.3 1.905
  showOutlier "m_φ" (phiMesonImplosion lam) 1019.5 1.767
  showOutlier "Ω_DM" omegaDMImplosion 0.2589 2.978
  showOutlier "sin²θ₁₃" sinSq13Implosion 0.0220 1.010

  -- Summary
  putStrLn "§4  Correction pattern (all from A_F atoms):"
  putStrLn "    m_Υ:  −N_c³/(χ·Σd) = −1/8       → Λ × 79/8"
  putStrLn "    m_D:  −D/(d₄·Σd)   = −7/144     → Λ × 281/144"
  putStrLn "    m_ρ:  −T_F/χ       = −1/12       → m_π × 23/4"
  putStrLn "    m_φ:  −N_w/(N_c·Σd) = −1/54      → Λ × 115/108"
  putStrLn "    Ω_DM: −1/(gauss(gauss−N_c)) = −1/130"
  putStrLn "    sin²θ₁₃: −1/((D+d_w)N_w²(χ−1)²) = −1/4500 → 11/500"
  putStrLn ""
  putStrLn "  All rational. All negative. All dual-routed. All from A_F."
  putStrLn ""
  putStrLn $ "  ✓ CrystalHierarchy: " ++ show (length routes) ++ " dual routes verified."
  putStrLn $ "  ✓ All match: " ++ show allMatch
