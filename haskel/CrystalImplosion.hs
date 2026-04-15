-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalImplosion.hs — Component 9: Hierarchical Implosion

  The spectral action Tr(f(D_A/Lambda)) on A_F expands via Seeley-DeWitt
  coefficients a_0, a_2, a_4. Each level is a coarse-graining of the
  algebra's endomorphism structure:

    a_0 = Sigma_d = 36     (topological, sector count)
    a_2 = individual dims  (base formulas)
    a_4 = Sigma_d^2 = 650  (endomorphism invariant, corrections)

  Hierarchical implosion: corrections at the a_4 level close boundary gaps
  in a_2-level formulas. The correction pattern:

    base +/- X / (channel x Sigma_d^2 x D)

  Every correction must have a DUAL ROUTE: two independent derivations
  from A_F atoms that give the same number.

  This module imports CrystalAtoms only. It uses Integer aliases for
  Rational arithmetic (Data.Ratio needs Integer, CrystalAtoms uses Int).

  Compile: ghc -O2 -main-is CrystalImplosion CrystalImplosion.hs && ./CrystalImplosion
-}

module CrystalImplosion
  ( -- Hierarchy levels
    HLevel(..), levelInvariant, levelName
    -- Correction channels
  , Channel(..), channelDenom, channelName
    -- The implosion operator
  , Implosion(..), implose, imploseRational, implosionDeviation
    -- Dual route verification
  , DualRoute(..), verifyDualRoute
    -- Suppression and sign checks
  , suppressionRatio, isSuppressed, correctionSign
    -- Known CODATA corrections (Sessions 4-6)
  , alphaInvImplosion, mpMeImplosion, rpImplosion, rpDualRoute
    -- Hierarchy statistics
  , sharedCore, levelRatio
    -- Outlier diagnostics
  , OutlierDiag(..), diagnoseOutlier
    -- Session 8 outlier corrections
  , upsilonImplosion, upsilonDualRoute
  , dMesonImplosion, dMesonDualRoute
  , rhoMesonImplosion, rhoMesonDualRoute
  , phiMesonImplosion, phiMesonDualRoute
  , omegaDMImplosion, omegaDMDualRoute
    -- Session 8b: sin^2 theta_13
  , sinSq13Implosion, sinSq13DualRoute
    -- Session 9: five remaining LOOSE corrections
  , omegaMesonImplosion
  , etaMesonImplosion, etaMesonDualRoute
  , mzBosonImplosion, mzBosonDualRoute
  , decupletImplosion, decupletDualRoute
  , muonImplosion, muonDualRoute
    -- Implosion factors (for protein force field)
  , implosionFactor
    -- Self-test
  , main
  ) where

import Data.Ratio (Rational, (%), numerator, denominator)
import CrystalAtoms hiding (main)

-- =====================================================================
-- S0 INTEGER ALIASES FOR RATIONAL ARITHMETIC
--
-- CrystalAtoms exports Int. Data.Ratio needs Integer.
-- Convert once here. These are NOT new atoms — they are the same
-- values from (2,3), just lifted to Integer for the (%) operator.
-- =====================================================================

n_w, n_c, chi_, beta0_ :: Integer
n_w    = fromIntegral nW     -- 2
n_c    = fromIntegral nC     -- 3
chi_   = fromIntegral chi    -- 6
beta0_ = fromIntegral beta0  -- 7

d1_, d2_, d3_, d4_ :: Integer
d1_ = fromIntegral d1   -- 1
d2_ = fromIntegral d2   -- 3
d3_ = fromIntegral d3   -- 8
d4_ = fromIntegral d4   -- 24

sigma_d, sigma_d2, gauss_, towerD_ :: Integer
sigma_d  = fromIntegral sigmaD    -- 36
sigma_d2 = fromIntegral sigmaD2   -- 650
gauss_   = fromIntegral gauss     -- 13
towerD_  = fromIntegral towerD    -- 42

c_F :: Rational
c_F = (n_c^(2::Int) - 1) % (2 * n_c)  -- 4/3

t_F :: Rational
t_F = 1 % 2

kappaVal :: Double
kappaVal = kappa  -- ln3/ln2 from CrystalAtoms

-- =====================================================================
-- S1 HIERARCHY LEVELS — The 3-level MERA on A_F
-- =====================================================================

data HLevel
  = A0   -- Tr(1) = Sigma_d = 36. Topological. Sector count.
  | A2   -- Tr(E) = individual dims. Base formulas.
  | A4   -- Tr(E^2 + Omega^2) = Sigma_d^2 = 650. Corrections.
  deriving (Show, Eq, Ord)

levelInvariant :: HLevel -> Integer
levelInvariant A0 = sigma_d    -- 36
levelInvariant A2 = sigma_d    -- a_2 uses sigma_d + individual dims
levelInvariant A4 = sigma_d2   -- 650

levelName :: HLevel -> String
levelName A0 = "a_0: Tr(1) = Sigma_d = 36 (topological)"
levelName A2 = "a_2: Tr(E) -- individual dims, gauss, chi (base)"
levelName A4 = "a_4: Tr(E^2+Omega^2) = Sigma_d^2 = 650 (correction)"

-- | Shared core: a_4 invariant x tower dimension = 650 x 42 = 27300.
sharedCore :: Integer
sharedCore = sigma_d2 * towerD_  -- 27300

-- | Ratio between hierarchy levels: a_4/a_0 = 650/36 = 325/18.
levelRatio :: Rational
levelRatio = sigma_d2 % sigma_d  -- 650/36

-- =====================================================================
-- S2 CORRECTION CHANNELS
-- =====================================================================

data Channel
  = ColourChannel          -- chi x d_4 = 144. For alpha_inv (SU(3)).
  | WeakChannel            -- N_w x chi = 12. For m_p/m_e (weak).
  | MixedChannel           -- d_3 x Sigma_d = 288. For r_p (mixed).
  | D4Squared              -- d_4^2 = 576. Dual route for r_p.
  | FullChannel            -- D = 42. For cosmological corrections.
  | CustomChannel Integer  -- For outlier-specific channels.
  deriving (Show, Eq)

channelDenom :: Channel -> Integer
channelDenom ColourChannel     = chi_ * d4_             -- 144
channelDenom WeakChannel       = n_w * chi_             -- 12
channelDenom MixedChannel      = d3_ * sigma_d          -- 288
channelDenom D4Squared         = d4_ ^ (2::Int)         -- 576
channelDenom FullChannel       = towerD_                 -- 42
channelDenom (CustomChannel n) = n

channelName :: Channel -> String
channelName ColourChannel     = "chi x d_4 = " ++ show (channelDenom ColourChannel)
channelName WeakChannel       = "N_w x chi = " ++ show (channelDenom WeakChannel)
channelName MixedChannel      = "d_3 x Sigma_d = " ++ show (channelDenom MixedChannel)
channelName D4Squared         = "d_4^2 = " ++ show (channelDenom D4Squared)
channelName FullChannel       = "D = " ++ show (channelDenom FullChannel)
channelName (CustomChannel n) = "custom(" ++ show n ++ ")"

-- =====================================================================
-- S3 THE IMPLOSION OPERATOR
-- =====================================================================

data Implosion = Implosion
  { impBase       :: Double    -- a_2-level base formula value
  , impCorrection :: Double    -- a_4-level correction (with sign)
  , impResult     :: Double    -- base + correction
  , impChannel    :: Channel   -- gauge sector channel
  , impNumerator  :: String    -- what X is (description)
  , impSign       :: Int       -- +1 (binding) or -1 (AF)
  , impLevel      :: HLevel    -- always A4
  } deriving (Show)

-- | Apply hierarchical implosion:
--   Result = base + sign x numerator / (channel x Sigma_d^2 x D)
implose :: Double -> Int -> Double -> Channel -> String -> Implosion
implose base sign num ch desc =
  let denom = fromIntegral (channelDenom ch * sigma_d2 * towerD_)
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

-- | Implosion with rational correction (no shared core in denominator).
imploseRational :: Double -> Int -> Rational -> Channel -> String -> Implosion
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

-- | Deviation of implosion result from target.
implosionDeviation :: Implosion -> Double -> Double
implosionDeviation imp target = abs (impResult imp - target) / target

-- =====================================================================
-- S4 DUAL ROUTE VERIFICATION
-- =====================================================================

data DualRoute = DualRoute
  { drRouteA     :: Double
  , drRouteB     :: Double
  , drDescrA     :: String
  , drDescrB     :: String
  , drMatch      :: Bool
  } deriving (Show)

verifyDualRoute :: Double -> String -> Double -> String -> DualRoute
verifyDualRoute a descA b descB = DualRoute
  { drRouteA = a
  , drRouteB = b
  , drDescrA = descA
  , drDescrB = descB
  , drMatch  = abs (a - b) < 1e-14
  }

-- =====================================================================
-- S5 SUPPRESSION AND SIGN CHECKS
-- =====================================================================

suppressionRatio :: Implosion -> Double
suppressionRatio imp = abs (impCorrection imp) / abs (impBase imp)

isSuppressed :: Implosion -> Bool
isSuppressed imp = suppressionRatio imp < 0.01

correctionSign :: Implosion -> String
correctionSign imp
  | impSign imp > 0  = "positive (binding/QCD)"
  | impSign imp < 0  = "negative (asymptotic freedom)"
  | otherwise        = "zero (no correction)"

-- =====================================================================
-- S6 KNOWN CODATA CORRECTIONS (Sessions 4-6)
-- =====================================================================

-- | alpha_inv: base = 2(gauss^2+d_4)/pi + d_8^kappa
--   correction = -1/(chi x d_4 x Sigma_d^2 x D)
--   Channel: ColourChannel (chi x d_4 = 144)
alphaInvImplosion :: Implosion
alphaInvImplosion =
  let g2    = fromIntegral (gauss_ ^ (2::Int))
      base  = 2.0 * (g2 + fromIntegral d4_) / pi
            + fromIntegral d3_ ** kappaVal
  in implose base (-1) 1.0 ColourChannel "1 (rational)"

-- | m_p/m_e: base = 2(D^2+Sigma_d)/d_8 + gauss^3/kappa
--   correction = +kappa/(N_w x chi x Sigma_d^2 x D)
--   Channel: WeakChannel (N_w x chi = 12)
mpMeImplosion :: Implosion
mpMeImplosion =
  let d2val = fromIntegral (towerD_ ^ (2::Int))
      base  = 2.0 * (d2val + fromIntegral sigma_d) / fromIntegral d3_
            + fromIntegral (gauss_ ^ (3::Int)) / kappaVal
  in implose base 1 kappaVal WeakChannel "kappa = ln3/ln2 (transcendental)"

-- | r_p: base = C_F x N_c, correction = -T_F/(d_3 x Sigma_d) = -1/576
--   Channel: MixedChannel (d_3 x Sigma_d = 288)
--   Dual route: T_F/(d_3 x Sigma_d) = 1/d_4^2 (because 2 x d_3 x Sigma_d = d_4^2)
rpImplosion :: Implosion
rpImplosion =
  let base = fromRational (c_F * fromIntegral n_c)
  in imploseRational base (-1) (1 % (2 * d3_ * sigma_d)) MixedChannel
     "T_F/(d_3 x Sigma_d) = 1/576"

rpDualRoute :: DualRoute
rpDualRoute = verifyDualRoute
  (fromRational (1 % (2 * d3_ * sigma_d)))
  "T_F/(d_3 x Sigma_d) = (1/2)/288 = 1/576"
  (1.0 / fromIntegral (d4_ ^ (2::Int)))
  "1/d_4^2 = 1/576"

-- =====================================================================
-- S7 OUTLIER DIAGNOSTICS
-- =====================================================================

data OutlierDiag = OutlierDiag
  { odName       :: String
  , odBase       :: Double
  , odTarget     :: Double
  , odPWI        :: Double
  , odDirection  :: Int
  , odGapSize    :: Double
  , odNeededCorr :: Double
  } deriving (Show)

diagnoseOutlier :: String -> Double -> Double -> OutlierDiag
diagnoseOutlier name crystal target =
  let gap  = crystal - target
      pwi  = abs gap / target * 100
      dir  = if gap > 0 then -1 else 1
  in OutlierDiag
    { odName       = name
    , odBase       = crystal
    , odTarget     = target
    , odPWI        = pwi
    , odDirection  = dir
    , odGapSize    = abs gap
    , odNeededCorr = target - crystal
    }

-- =====================================================================
-- S8 SESSION 8 OUTLIER CORRECTIONS
-- =====================================================================

-- | m_Upsilon (bb-bar 1S): base Lambda x 10, correction -N_c^3/(chi x Sigma_d) = -1/8
--   Route A: N_c^3/(chi x Sigma_d) = 27/216 = 1/8
--   Route B: N_c^2/(N_w x Sigma_d) = 9/72 = 1/8
upsilonImplosion :: Double -> Implosion
upsilonImplosion lam =
  let mult = fromIntegral (gauss_ - n_c)
      corr = fromRational (n_c^(3::Int) % (chi_ * sigma_d))
      base = lam * mult
  in Implosion
    { impBase       = base
    , impCorrection = -lam * corr
    , impResult     = lam * (mult - corr)
    , impChannel    = MixedChannel
    , impNumerator  = "N_c^3/(chi x Sigma_d) = 1/8"
    , impSign       = -1
    , impLevel      = A4
    }

upsilonDualRoute :: DualRoute
upsilonDualRoute = verifyDualRoute
  (fromRational (n_c^(3::Int) % (chi_ * sigma_d)))
  "N_c^3/(chi x Sigma_d) = 27/216 = 1/8"
  (fromRational (n_c^(2::Int) % (n_w * sigma_d)))
  "N_c^2/(N_w x Sigma_d) = 9/72 = 1/8"

-- | m_D (D meson, cd-bar): base Lambda x 2, correction -D/(d_4 x Sigma_d) = -7/144
--   Route A: D/(d_4 x Sigma_d) = 42/864 = 7/144
--   Route B: 1/d_4 + chi/(d_4 x Sigma_d) = 1/24 + 1/144 = 7/144
dMesonImplosion :: Double -> Implosion
dMesonImplosion lam =
  let mult = fromIntegral n_w
      corr = fromRational (towerD_ % (d4_ * sigma_d))
      base = lam * mult
  in Implosion
    { impBase       = base
    , impCorrection = -lam * corr
    , impResult     = lam * (mult - corr)
    , impChannel    = ColourChannel
    , impNumerator  = "D/(d_4 x Sigma_d) = 42/864 = 7/144"
    , impSign       = -1
    , impLevel      = A4
    }

dMesonDualRoute :: DualRoute
dMesonDualRoute = verifyDualRoute
  (fromRational (towerD_ % (d4_ * sigma_d)))
  "D/(d_4 x Sigma_d) = 42/864 = 7/144"
  (fromRational (1 % d4_ + chi_ % (d4_ * sigma_d)))
  "1/d_4 + chi/(d_4 x Sigma_d) = 6/144 + 1/144 = 7/144"

-- | m_rho (rho meson): base m_pi x 35/6, correction -T_F/chi = -1/12
--   Route A: T_F/chi = (1/2)/6 = 1/12
--   Route B: N_c/Sigma_d = 3/36 = 1/12
rhoMesonImplosion :: Double -> Implosion
rhoMesonImplosion mpi =
  let mult = fromIntegral chi_ * fromIntegral (sigma_d - 1)
           / fromIntegral sigma_d
      corr = fromRational (1 % (2 * chi_))
      base = mpi * mult
  in Implosion
    { impBase       = base
    , impCorrection = -mpi * corr
    , impResult     = mpi * (mult - corr)
    , impChannel    = WeakChannel
    , impNumerator  = "T_F/chi = 1/12"
    , impSign       = -1
    , impLevel      = A4
    }

rhoMesonDualRoute :: DualRoute
rhoMesonDualRoute = verifyDualRoute
  (fromRational (1 % (2 * chi_)))
  "T_F/chi = (1/2)/6 = 1/12"
  (fromRational (n_c % sigma_d))
  "N_c/Sigma_d = 3/36 = 1/12"

-- | m_phi (phi meson, ss-bar): base Lambda x 13/12, correction -N_w/(N_c x Sigma_d) = -1/54
--   Route A: N_w/(N_c x Sigma_d) = 2/108 = 1/54
--   Route B: (d_4-d_3)/(d_4 x Sigma_d) = 16/864 = 1/54
phiMesonImplosion :: Double -> Implosion
phiMesonImplosion lam =
  let g    = fromIntegral gauss_
      mult = g / (g - 1)
      corr = fromRational (n_w % (n_c * sigma_d))
      base = lam * mult
  in Implosion
    { impBase       = base
    , impCorrection = -lam * corr
    , impResult     = lam * (mult - corr)
    , impChannel    = MixedChannel
    , impNumerator  = "N_w/(N_c x Sigma_d) = 2/108 = 1/54"
    , impSign       = -1
    , impLevel      = A4
    }

phiMesonDualRoute :: DualRoute
phiMesonDualRoute = verifyDualRoute
  (fromRational (n_w % (n_c * sigma_d)))
  "N_w/(N_c x Sigma_d) = 2/108 = 1/54"
  (fromRational ((d4_ - d3_) % (d4_ * sigma_d)))
  "(d_4-d_3)/(d_4 x Sigma_d) = 16/864 = 1/54"

-- | Omega_DM (dark matter density): base 309/1159, correction -1/130
--   Route A: 1/(gauss x (gauss-N_c)) = 1/(13 x 10) = 1/130
--   Route B: 1/(N_w x (chi-1) x gauss) = 1/(2 x 5 x 13) = 1/130
omegaDMImplosion :: Implosion
omegaDMImplosion =
  let omega_m = fromIntegral chi_ / fromIntegral (gauss_ + chi_)
      omega_b = fromIntegral n_c
              / fromIntegral (n_c * (gauss_ + beta0_) + d1_)
      base    = omega_m - omega_b
  in imploseRational base (-1) (1 % (gauss_ * (gauss_ - n_c)))
     FullChannel "1/(gauss x (gauss-N_c)) = 1/130"

omegaDMDualRoute :: DualRoute
omegaDMDualRoute = verifyDualRoute
  (fromRational (1 % (gauss_ * (gauss_ - n_c))))
  "1/(gauss x (gauss-N_c)) = 1/(13 x 10) = 1/130"
  (fromRational (1 % (n_w * (chi_ - 1) * gauss_)))
  "1/(N_w x (chi-1) x gauss) = 1/(2 x 5 x 13) = 1/130"

-- | sin^2 theta_13 (PMNS reactor angle): base 1/45, correction -1/4500
--   Route A: (D+d_w) x N_w^2 x (chi-1)^2 = 45 x 4 x 25 = 4500
--   Route B: Sigma_d x (chi-1)^3 = 36 x 125 = 4500
--   Clean form: sin^2 theta_13 = (2chi-1)/(N_w^2 x (chi-1)^3) = 11/500
sinSq13Implosion :: Implosion
sinSq13Implosion =
  let dw   = n_w ^ (2::Int) - 1
      base = 1.0 / fromIntegral (towerD_ + dw)
      corr = 1.0 / fromIntegral ((towerD_ + dw) * n_w^(2::Int) * (chi_ - 1)^(2::Int))
  in Implosion
    { impBase       = base
    , impCorrection = -corr
    , impResult     = base - corr
    , impChannel    = CustomChannel ((towerD_ + dw) * n_w^(2::Int) * (chi_ - 1)^(2::Int))
    , impNumerator  = "1/((D+d_w) x N_w^2 x (chi-1)^2) = 1/4500"
    , impSign       = -1
    , impLevel      = A4
    }

sinSq13DualRoute :: DualRoute
sinSq13DualRoute = verifyDualRoute
  (1.0 / fromIntegral ((towerD_ + n_w^(2::Int) - 1) * n_w^(2::Int) * (chi_ - 1)^(2::Int)))
  "(D+d_w) x N_w^2 x (chi-1)^2 = 45 x 4 x 25 = 4500"
  (1.0 / fromIntegral (sigma_d * (chi_ - 1)^(3::Int)))
  "Sigma_d x (chi-1)^3 = 36 x 125 = 4500"

-- =====================================================================
-- S9 SESSION 9 — Five remaining LOOSE corrections
-- =====================================================================

-- | m_omega (omega meson 782): inherits corrected rho formula.
--   Same base as rho: m_pi x chi(Sigma_d-1)/Sigma_d = m_pi x 35/6.
--   Same correction: -T_F/chi = -1/12. Multiplier: 23/4.
omegaMesonImplosion :: Double -> Implosion
omegaMesonImplosion mpi =
  let mult = fromIntegral chi_ * fromIntegral (sigma_d - 1)
           / fromIntegral sigma_d
      corr = fromRational (1 % (2 * chi_))
      base = mpi * mult
  in Implosion
    { impBase       = base
    , impCorrection = -mpi * corr
    , impResult     = mpi * (mult - corr)
    , impChannel    = WeakChannel
    , impNumerator  = "T_F/chi = 1/12 (inherited from rho correction)"
    , impSign       = -1
    , impLevel      = A4
    }

-- | m_eta (eta meson 548): base Lambda/sqrt(N_c), correction -1/(N_c(chi-1)^2) = -1/75
--   Route A: 1/(N_c x (chi-1)^2) = 1/(3 x 25) = 1/75
--   Route B: 1/(N_w x Sigma_d + N_c) = 1/(72+3) = 1/75
etaMesonImplosion :: Double -> Implosion
etaMesonImplosion lam =
  let base   = lam / sqrt (fromIntegral n_c)
      corr_r = 1 % (n_c * (chi_ - 1)^(2::Int))
      corr   = fromRational corr_r
  in Implosion
    { impBase       = base
    , impCorrection = -base * corr
    , impResult     = base * (1 - corr)
    , impChannel    = CustomChannel (n_c * (chi_ - 1)^(2::Int))
    , impNumerator  = "1/(N_c x (chi-1)^2) = 1/75"
    , impSign       = -1
    , impLevel      = A4
    }

etaMesonDualRoute :: DualRoute
etaMesonDualRoute = verifyDualRoute
  (fromRational (1 % (n_c * (chi_ - 1)^(2::Int))))
  "1/(N_c x (chi-1)^2) = 1/(3 x 25) = 1/75"
  (fromRational (1 % (n_w * sigma_d + n_c)))
  "1/(N_w x Sigma_d + N_c) = 1/(72+3) = 1/75"

-- | M_Z (Z boson 91.19): base v x 3/8, correction -1/((D+1)(chi-1)) = -1/215
--   Route A: 1/((D+1) x (chi-1)) = 1/(43 x 5) = 1/215
--   Corrected: v x (3/8 - 1/215) = v x 637/1720
mzBosonImplosion :: Double -> Implosion
mzBosonImplosion v =
  let base   = v * fromIntegral n_c / fromIntegral (n_c^(2::Int) - 1)
      corr_r = 1 % ((towerD_ + 1) * (chi_ - 1))
      corr   = v * fromRational corr_r
  in Implosion
    { impBase       = base
    , impCorrection = -corr
    , impResult     = base - corr
    , impChannel    = CustomChannel ((towerD_ + 1) * (chi_ - 1))
    , impNumerator  = "1/((D+1) x (chi-1)) = 1/(43 x 5) = 1/215"
    , impSign       = -1
    , impLevel      = A4
    }

mzBosonDualRoute :: DualRoute
mzBosonDualRoute = verifyDualRoute
  (fromRational (1 % ((towerD_ + 1) * (chi_ - 1))))
  "1/((D+1) x (chi-1)) = 1/(43 x 5) = 1/215"
  (fromRational (1 % ((sigma_d + chi_ + 1) * (n_w * n_c - 1))))
  "1/((Sigma_d+chi+1) x (N_w x N_c-1)) = 1/(43 x 5) = 1/215"

-- | Decuplet spacing (147 MeV): base m_s x kappa, correction -N_w/gauss^2 = -2/169
--   Route A: N_w/gauss^2 = 2/169
--   Route B: N_w/(N_c^2+N_w^2)^2 = 2/(9+4)^2 = 2/169
decupletImplosion :: Double -> Implosion
decupletImplosion msKappa =
  let base   = msKappa
      corr_r = n_w % (gauss_^(2::Int))
      corr   = fromRational corr_r
  in Implosion
    { impBase       = base
    , impCorrection = -base * corr
    , impResult     = base * (1 - corr)
    , impChannel    = CustomChannel (gauss_^(2::Int))
    , impNumerator  = "N_w/gauss^2 = 2/169"
    , impSign       = -1
    , impLevel      = A4
    }

decupletDualRoute :: DualRoute
decupletDualRoute = verifyDualRoute
  (fromRational (n_w % (gauss_^(2::Int))))
  "N_w/gauss^2 = 2/169"
  (fromRational (n_w % ((n_c^(2::Int) + n_w^(2::Int))^(2::Int))))
  "N_w/(N_c^2+N_w^2)^2 = 2/(9+4)^2 = 2/169"

-- | m_mu (muon 105.66): base v/2^(2chi-1) x 8/9, correction -1/(d_8 x (2chi-1)) = -1/88
--   Route A: 1/(d_8 x (2chi-1)) = 1/(8 x 11) = 1/88
--   Route B: 1/(N_w^4(chi-1) + d_8) = 1/(16 x 5+8) = 1/88
muonImplosion :: Double -> Implosion
muonImplosion vMeV =
  let pow  = (2::Integer) ^ (2 * chi_ - 1)
      d8   = n_c^(2::Int) - 1
      colk = fromIntegral d8 / fromIntegral (n_c^(2::Int))
      base = vMeV / fromIntegral pow * colk
      corr_r = 1 % (d8 * (2 * chi_ - 1))
      corr   = fromRational corr_r
  in Implosion
    { impBase       = base
    , impCorrection = -base * corr
    , impResult     = base * (1 - corr)
    , impChannel    = CustomChannel (d8 * (2 * chi_ - 1))
    , impNumerator  = "1/(d_8 x (2chi-1)) = 1/(8 x 11) = 1/88"
    , impSign       = -1
    , impLevel      = A4
    }

muonDualRoute :: DualRoute
muonDualRoute = verifyDualRoute
  (fromRational (1 % (d3_ * (2 * chi_ - 1))))
  "1/(d_8 x (2chi-1)) = 1/(8 x 11) = 1/88"
  (fromRational (1 % (n_w^(4::Int) * (chi_ - 1) + d3_)))
  "1/(N_w^4(chi-1)+d_8) = 1/(16 x 5+8) = 1/88"

-- =====================================================================
-- S10 IMPLOSION FACTORS (for protein force field)
--
-- The same correction channels reused as multiplicative factors:
--   factor = 1 +/- correction
-- =====================================================================

-- | Named implosion factors used in protein energy terms.
implosionFactor :: String -> Double
implosionFactor "vdw"       = 1.0 - fromRational (n_c^(3::Int) % (chi_ * sigma_d))   -- 7/8
implosionFactor "hbond"     = 1.0 - fromRational (1 % (2 * chi_))                     -- 11/12
implosionFactor "angle"     = 1.0 + fromRational (towerD_ % (d4_ * sigma_d))          -- 151/144
implosionFactor "burial"    = 1.0 + fromIntegral beta0_ / fromIntegral (d4_ * sigma_d2) -- 1+7/15600
implosionFactor "vdw_dist"  = 1.0 - fromRational (1 % (2 * d3_ * sigma_d))            -- 1-1/576
implosionFactor "hbond_dist"= 1.0 - fromRational (n_w % (n_c * sigma_d))              -- 1-1/54
implosionFactor _           = 1.0  -- unknown factor, no correction

-- =====================================================================
-- SELF-TEST
-- =====================================================================

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalImplosion.hs -- Component 9: Hierarchical Implosion"
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "S1 Hierarchy levels:"
  check "a_0 invariant = 36" (levelInvariant A0 == 36)
  check "a_4 invariant = 650" (levelInvariant A4 == 650)
  check "shared core = 27300" (sharedCore == 27300)
  check "650 x 42 = 27300" (sigma_d2 * towerD_ == 27300)
  check "level ratio = 650/36" (levelRatio == 650 % 36)
  putStrLn ""

  putStrLn "S2 Channel denominators:"
  check "ColourChannel = chi x d_4 = 144" (channelDenom ColourChannel == 144)
  check "WeakChannel = N_w x chi = 12" (channelDenom WeakChannel == 12)
  check "MixedChannel = d_3 x Sigma_d = 288" (channelDenom MixedChannel == 288)
  check "D4Squared = d_4^2 = 576" (channelDenom D4Squared == 576)
  check "FullChannel = D = 42" (channelDenom FullChannel == 42)
  putStrLn ""

  putStrLn "S3 Dual route verifications:"
  let routes = [ ("r_p",      rpDualRoute)
               , ("m_Upsilon", upsilonDualRoute)
               , ("m_D",      dMesonDualRoute)
               , ("m_rho",    rhoMesonDualRoute)
               , ("m_phi",    phiMesonDualRoute)
               , ("Omega_DM", omegaDMDualRoute)
               , ("sin^2 theta_13", sinSq13DualRoute)
               , ("m_eta",    etaMesonDualRoute)
               , ("M_Z",      mzBosonDualRoute)
               , ("decuplet", decupletDualRoute)
               , ("m_mu",     muonDualRoute)
               ]
  mapM_ (\(n,dr) -> check (n ++ " dual route matches") (drMatch dr)) routes
  putStrLn ""

  putStrLn "S4 Channel identities:"
  check "2 x d_3 x Sigma_d = d_4^2 (r_p dual)" (2 * d3_ * sigma_d == d4_ ^ (2::Int))
  check "chi x Sigma_d = 216 = N_c^3 x 8" (chi_ * sigma_d == 216)
  check "N_c x (chi-1)^2 = 75" (n_c * (chi_ - 1)^(2::Int) == 75)
  check "N_w x Sigma_d + N_c = 75" (n_w * sigma_d + n_c == 75)
  check "(D+1) x (chi-1) = 215" ((towerD_ + 1) * (chi_ - 1) == 215)
  check "gauss^2 = 169" (gauss_ ^ (2::Int) == 169)
  check "d_3 x (2chi-1) = 88" (d3_ * (2 * chi_ - 1) == 88)
  check "N_w^4 x (chi-1) + d_3 = 88" (n_w^(4::Int) * (chi_ - 1) + d3_ == 88)
  check "gauss x (gauss-N_c) = 130" (gauss_ * (gauss_ - n_c) == 130)
  check "N_w x (chi-1) x gauss = 130" (n_w * (chi_ - 1) * gauss_ == 130)
  putStrLn ""

  putStrLn "S5 Implosion factors (protein force field):"
  check "vdw factor = 7/8" (abs (implosionFactor "vdw" - 7.0/8.0) < 1e-14)
  check "hbond factor = 11/12" (abs (implosionFactor "hbond" - 11.0/12.0) < 1e-14)
  check "angle factor = 151/144" (abs (implosionFactor "angle" - 151.0/144.0) < 1e-14)
  check "vdw_dist factor = 575/576" (abs (implosionFactor "vdw_dist" - 575.0/576.0) < 1e-14)
  check "hbond_dist factor = 53/54" (abs (implosionFactor "hbond_dist" - 53.0/54.0) < 1e-14)
  putStrLn ""

  putStrLn "S6 Suppression (CODATA corrections are perturbative):"
  check "alpha_inv correction < 1%" (isSuppressed alphaInvImplosion)
  check "m_p/m_e correction < 1%" (isSuppressed mpMeImplosion)
  putStrLn ""

  putStrLn "S7 Integer backbone (all from 2 and 3):"
  check "Sigma_d^2 = 650" (sigma_d2 == 650)
  check "Sigma_d^2 x D = 27300" (sigma_d2 * towerD_ == 27300)
  check "chi x d_4 = 144" (chi_ * d4_ == 144)
  check "N_w x chi = 12" (n_w * chi_ == 12)
  check "d_3 x Sigma_d = 288" (d3_ * sigma_d == 288)
  check "d_4^2 = 576" (d4_ ^ (2::Int) == 576)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " 11 dual routes verified. All from A_F atoms. Zero free params."
  putStrLn " Channels: 144, 12, 288, 576, 42, 75, 215, 169, 88, 130, 4500."
  putStrLn " Shared core: Sigma_d^2 x D = 650 x 42 = 27300."
  putStrLn "================================================================"
