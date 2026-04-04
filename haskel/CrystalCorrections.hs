-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalCorrections.hs — Component 8: The Seven Correction Levels

  When you compute an observable from the 15 building blocks, some come
  out as exact integers. Some need pi. Some need a loop correction.
  Some need hierarchical implosion factors from higher tower layers.

  This module classifies WHICH treatment an observable needs:

    Level 0 — Exact Integer      counting representations, quantum numbers
    Level 1 — Exact Rational     ratios of integers, algebraic structure
    Level 2 — Single pi          complex geometry of A_F
    Level 3 — Single kappa/ln    renormalization group flow
    Level 4 — One-loop           virtual particle corrections, 1/(16pi^2)
    Level 5 — Running            energy-scale dependence, beta-function
    Level 6 — Implosion          tower layer corrections, hierarchy
    Level 7 — Compositeness      sums of pieces from multiple layers

  Each level adds one layer of mathematical structure. Lower levels are
  exact. Higher levels are perturbative corrections on top of lower levels.

  This module imports CrystalAtoms only. It does NOT compute implosion
  corrections (that is CrystalImplosion, Component 9). It classifies.

  Compile: ghc -O2 -main-is CrystalCorrections CrystalCorrections.hs && ./CrystalCorrections
-}

module CrystalCorrections
  ( -- Correction levels
    CLevel(..)
  , levelNumber
  , levelName
  , levelDescription
  , levelPWIRange

    -- Decision tree
  , classifyHint
  , ClassHint(..)

    -- One-loop factor
  , oneLoopFactor
  , oneLoopAlpha

    -- Beta function coefficients
  , beta1
  , beta2

    -- Level distribution (estimated counts)
  , levelCount

    -- Observable classification helpers
  , isExactLevel
  , isPerturbativeLevel
  , needsPi
  , needsKappa
  , needsLoop

    -- Self-test
  , main
  ) where

import CrystalAtoms hiding (main)

-- =====================================================================
-- S1 THE SEVEN CORRECTION LEVELS
-- =====================================================================

-- | The seven correction levels, plus unclassified.
data CLevel
  = ExactInteger       -- Level 0: counting reps, quantum numbers
  | ExactRational      -- Level 1: ratios of building blocks
  | SinglePi           -- Level 2: complex geometry of A_F
  | KappaOrLn          -- Level 3: renormalization group flow
  | OneLoop            -- Level 4: virtual particle corrections
  | Running            -- Level 5: energy-scale dependence
  | Implosion          -- Level 6: tower layer corrections
  | Composite          -- Level 7: sums from multiple layers
  | Unclassified       -- Not yet assigned
  deriving (Show, Eq, Ord, Enum)

-- | Numeric level.
levelNumber :: CLevel -> Int
levelNumber ExactInteger  = 0
levelNumber ExactRational = 1
levelNumber SinglePi      = 2
levelNumber KappaOrLn     = 3
levelNumber OneLoop       = 4
levelNumber Running       = 5
levelNumber Implosion     = 6
levelNumber Composite     = 7
levelNumber Unclassified  = -1

-- | Human-readable name.
levelName :: CLevel -> String
levelName ExactInteger  = "Level 0: Exact Integer"
levelName ExactRational = "Level 1: Exact Rational"
levelName SinglePi      = "Level 2: Single pi"
levelName KappaOrLn     = "Level 3: kappa or ln"
levelName OneLoop       = "Level 4: One-loop"
levelName Running       = "Level 5: Running"
levelName Implosion     = "Level 6: Implosion"
levelName Composite     = "Level 7: Compositeness"
levelName Unclassified  = "Unclassified"

-- | What this level means physically.
levelDescription :: CLevel -> String
levelDescription ExactInteger  = "Counting representations, quantum numbers, dimensions"
levelDescription ExactRational = "Ratios of building-block products, algebraic structure"
levelDescription SinglePi      = "Complex geometry of A_F: angular integrals, Fourier, rotations"
levelDescription KappaOrLn     = "RG flow: kappa = ln3/ln2 sector scaling, dimensional transmutation"
levelDescription OneLoop       = "Virtual particle corrections, ~alpha/(4pi) = ~0.06%"
levelDescription Running       = "Energy-scale dependence via beta-function coefficients"
levelDescription Implosion     = "Tower layer corrections: base x (1 +/- rational factor)"
levelDescription Composite     = "Sums of pieces from different tower layers (hadrons, nuclei)"
levelDescription Unclassified  = "Not yet classified"

-- | Typical PWI (Percentage Weighted Inconsistency) range at each level.
levelPWIRange :: CLevel -> (Double, Double)
levelPWIRange ExactInteger  = (0.00, 0.00)
levelPWIRange ExactRational = (0.00, 0.00)
levelPWIRange SinglePi      = (0.00, 0.10)
levelPWIRange KappaOrLn     = (0.01, 0.10)
levelPWIRange OneLoop       = (0.10, 1.00)
levelPWIRange Running       = (0.10, 0.50)
levelPWIRange Implosion     = (0.01, 0.10)
levelPWIRange Composite     = (0.10, 4.00)
levelPWIRange Unclassified  = (0.00, 100.0)

-- =====================================================================
-- S2 DECISION TREE
--
-- Given a measured value and a candidate crystal formula, classify the
-- observable by its correction level.
--
-- The decision tree mirrors README_CorrectionLevels.md:
--   1. Is the value an integer? -> Level 0
--   2. Is value x {1, pi, pi^2, 1/pi} a clean ratio? -> Level 1 or 2
--   3. Is value x {kappa, 1/kappa} a clean ratio? -> Level 3
--   4. Does Level 0-3 formula give 99-100%? -> Level 4
--   5. Does PDG quote at specific scale? -> Level 5
--   6. Is base x small rational correction? -> Level 6
--   7. Is it a sum of terms from different scales? -> Level 7
-- =====================================================================

-- | Hint for classification. This is metadata, not a full classifier.
-- Full classification requires physical knowledge (what charges does
-- the particle carry, what scale is it measured at, etc.)
data ClassHint = ClassHint
  { chLevel     :: CLevel
  , chReason    :: String
  , chConfidence :: Double  -- 0 to 1
  } deriving (Show)

-- | Classify by the gap between crystal formula and measured value.
-- This is a heuristic — it catches the easy cases.
classifyHint :: Double    -- ^ crystal formula value
             -> Double    -- ^ measured/target value
             -> ClassHint
classifyHint crystal target
  | gap < 1e-12  = ClassHint ExactInteger  "Exact match (integer or rational)" 1.0
  | gap < 1e-8   = ClassHint ExactRational "Match to rational precision" 0.95
  | gap < 1e-4   = ClassHint SinglePi      "Match to pi-level precision" 0.7
  | gap < 1e-2   = ClassHint OneLoop       "Gap ~0.1-1%, likely one-loop" 0.5
  | gap < 5e-2   = ClassHint Implosion     "Gap ~1-5%, likely implosion" 0.4
  | otherwise     = ClassHint Composite    "Large gap, likely composite" 0.3
  where gap = abs (crystal - target) / abs target

-- =====================================================================
-- S3 ONE-LOOP FACTOR
--
-- The canonical one-loop correction from A_F:
--   factor = 1 + N_c/(16pi^2) x ln(sqrt(N_w) x d_3/N_c^2)
--          = 1 + 3/(16pi^2) x ln(sqrt(2) x 8/9)
--          = 1.004
--
-- This is the VEV gap: v_crystal = 245.17, v_PDG = 246.22.
-- Ratio = 246.22/245.17 = 1.004 = the one-loop factor.
-- Every integer from (2,3).
-- =====================================================================

-- | The one-loop correction factor.
-- factor = 1 + N_c/(16 pi^2) x ln(sqrt(N_w) x d_3/N_c^2)
oneLoopFactor :: Double
oneLoopFactor = 1.0 + nC_d / (16.0 * pi * pi)
              * log (sqrt nW_d * d3_d / (nC_d * nC_d))

-- | One-loop alpha: alpha/(4pi) = 1/(4pi x alpha_inv).
-- alpha_inv = (D+1)pi + ln(beta_0) = 43pi + ln(7) = 137.036.
oneLoopAlpha :: Double
oneLoopAlpha = 1.0 / (4.0 * pi * alphaInvFull)
  where alphaInvFull = (fromIntegral towerD + 1.0) * pi + log beta0_d

-- =====================================================================
-- S4 BETA FUNCTION COEFFICIENTS
--
-- beta_0 = (11 N_c - 2 chi) / 3 = 7        (from CrystalAtoms)
-- beta_1 = (34 N_c^2 - 10 N_c chi + 3 chi) / 3
-- beta_2 = (from 3-loop, all integers from (2,3))
--
-- These control how couplings run with energy scale (Level 5).
-- =====================================================================

-- | Two-loop beta function coefficient.
-- beta_1 = (34 N_c^2 - 10 N_c chi + 3 chi) / 3
beta1 :: Int
beta1 = (34 * nC * nC - 10 * nC * chi + 3 * chi) `div` 3

-- | Three-loop beta function coefficient (leading term).
-- beta_2 = (2857 N_c^3) / (2 x 3^4) - (5033/18) N_c^2 chi + ...
-- Simplified integer part for the dominant N_c^3 term:
-- 2857 = a derived integer; full 3-loop is very long.
-- Here we provide the integer skeleton only.
beta2 :: Int
beta2 = (2857 * nC * nC * nC) `div` (2 * 81)
      - (5033 * nC * nC * chi) `div` 18
      + (325 * chi * chi) `div` (2 * 3)

-- =====================================================================
-- S5 LEVEL DISTRIBUTION (estimated counts)
-- =====================================================================

-- | Estimated number of observables at each level.
levelCount :: CLevel -> Int
levelCount ExactInteger  = 60
levelCount ExactRational = 45
levelCount SinglePi      = 35
levelCount KappaOrLn     = 20
levelCount OneLoop       = 15
levelCount Running       = 10
levelCount Implosion     = 8
levelCount Composite     = 55
levelCount Unclassified  = 0

-- =====================================================================
-- S6 CLASSIFICATION HELPERS
-- =====================================================================

-- | Is this an exact level (no perturbative corrections needed)?
isExactLevel :: CLevel -> Bool
isExactLevel ExactInteger  = True
isExactLevel ExactRational = True
isExactLevel _             = False

-- | Is this a perturbative level (corrections on top of a base)?
isPerturbativeLevel :: CLevel -> Bool
isPerturbativeLevel OneLoop   = True
isPerturbativeLevel Running   = True
isPerturbativeLevel Implosion = True
isPerturbativeLevel Composite = True
isPerturbativeLevel _         = False

-- | Does this level need pi in the formula?
needsPi :: CLevel -> Bool
needsPi SinglePi = True
needsPi OneLoop  = True  -- one-loop has 1/(16 pi^2)
needsPi _        = False

-- | Does this level need kappa = ln3/ln2?
needsKappa :: CLevel -> Bool
needsKappa KappaOrLn = True
needsKappa _         = False

-- | Does this level need loop corrections?
needsLoop :: CLevel -> Bool
needsLoop OneLoop = True
needsLoop Running = True
needsLoop _       = False

-- =====================================================================
-- SELF-TEST
-- =====================================================================

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalCorrections.hs -- Component 8: The Seven Levels"
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "S1 Level numbering:"
  check "Level 0 = ExactInteger" (levelNumber ExactInteger == 0)
  check "Level 1 = ExactRational" (levelNumber ExactRational == 1)
  check "Level 2 = SinglePi" (levelNumber SinglePi == 2)
  check "Level 3 = KappaOrLn" (levelNumber KappaOrLn == 3)
  check "Level 4 = OneLoop" (levelNumber OneLoop == 4)
  check "Level 5 = Running" (levelNumber Running == 5)
  check "Level 6 = Implosion" (levelNumber Implosion == 6)
  check "Level 7 = Composite" (levelNumber Composite == 7)
  check "8 levels total" (length [ExactInteger .. Composite] == 8)
  putStrLn ""

  putStrLn "S2 Level classification:"
  check "Levels 0-1 are exact" (isExactLevel ExactInteger && isExactLevel ExactRational)
  check "Level 2 is not exact" (not (isExactLevel SinglePi))
  check "Levels 4-7 are perturbative"
    (all isPerturbativeLevel [OneLoop, Running, Implosion, Composite])
  check "Levels 0-3 are not perturbative"
    (not (any isPerturbativeLevel [ExactInteger, ExactRational, SinglePi, KappaOrLn]))
  check "Level 2 needs pi" (needsPi SinglePi)
  check "Level 3 needs kappa" (needsKappa KappaOrLn)
  check "Level 4 needs loop" (needsLoop OneLoop)
  check "Level 5 needs loop" (needsLoop Running)
  putStrLn ""

  putStrLn "S3 One-loop factor:"
  check "one-loop factor ~ 1.004" (abs (oneLoopFactor - 1.004) < 0.002)
  check "one-loop factor > 1" (oneLoopFactor > 1.0)
  check "one-loop factor < 1.01" (oneLoopFactor < 1.01)
  putStrLn $ "  value = " ++ show oneLoopFactor
  putStrLn ""

  putStrLn "S4 VEV gap is the one-loop factor:"
  let vCrystal = 245.17
      vPDG     = 246.22
      vRatio   = vPDG / vCrystal
  check "v_PDG/v_crystal ~ one-loop factor"
    (abs (vRatio - oneLoopFactor) < 0.003)
  putStrLn $ "  v_PDG/v_crystal = " ++ show vRatio
  putStrLn ""

  putStrLn "S5 Beta function coefficients (all from 2 and 3):"
  check "beta_0 = 7" (beta0 == 7)
  check "beta_1 = (34x9 - 10x3x6 + 3x6)/3 = (306-180+18)/3 = 48"
    (beta1 == 48)
  putStrLn $ "  beta_0 = " ++ show beta0
  putStrLn $ "  beta_1 = " ++ show beta1
  putStrLn $ "  beta_2 = " ++ show beta2 ++ " (3-loop leading)"
  putStrLn ""

  putStrLn "S6 One-loop alpha:"
  check "alpha/(4pi) ~ 5.8e-4" (abs (oneLoopAlpha - 5.8e-4) < 1e-4)
  putStrLn $ "  alpha/(4pi) = " ++ show oneLoopAlpha
  putStrLn ""

  putStrLn "S7 Decision tree heuristic:"
  let hint1 = classifyHint 8.0 8.0
  check "exact integer match -> Level 0" (chLevel hint1 == ExactInteger)
  let hint2 = classifyHint 137.036 137.036
  check "exact match -> Level 0" (chLevel hint2 == ExactInteger)
  let hint3 = classifyHint 245.17 246.22
  check "0.4% gap -> Level 4 (one-loop)" (chLevel hint3 == OneLoop)
  let hint4 = classifyHint 9575.0 9460.3
  check "1.2% gap -> Level 6 (implosion)" (chLevel hint4 == Implosion)
  putStrLn ""

  putStrLn "S8 Level distribution (estimated 248 total):"
  let total = sum (map levelCount [ExactInteger .. Composite])
  putStrLn $ "  total estimated observables = " ++ show total
  check "~248 observables" (total == 248)
  putStrLn ""

  putStrLn "S9 Integer identities (all from 2 and 3):"
  check "16 = N_w^4 (one-loop denominator)" (nW ^ (4::Int) == 16)
  check "16 pi^2 ~ 157.9 (loop suppression)" (abs (16 * pi * pi - 157.91) < 0.01)
  check "beta_0 x beta_1 = 336" (beta0 * beta1 == 336)
  check "beta_0^2 = 49" (beta0 * beta0 == 49)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " 7 levels + Unclassified. Decision tree. One-loop factor."
  putStrLn " beta_0 = 7, beta_1 = 48. All from (2,3). Zero free params."
  putStrLn "================================================================"
