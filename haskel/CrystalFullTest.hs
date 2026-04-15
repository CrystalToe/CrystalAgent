{-# OPTIONS_GHC -Wno-x-partial #-}
-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- | CrystalFullTest.hs — TOTAL REWRITE (Phase 5 final task)
--
-- Four-column regression test for the full observable catalogue
-- + dynamics regression for all 15 pack→tick→unpack modules.
--
-- THE FOUR-COLUMN TABLE:
--   Crystal    = Toe()          → formula(standardRuler)  → crystal VEV 245.17
--   CrystalPdg = Toe(vev="pdg") → formula(pdgRuler)      → PDG VEV 246.22
--   Expt       = experimental value
--   PWI        = |Expt − CrystalPdg| / Expt   (scheme noise REMOVED)
--
-- POST-REFACTOR:
--   CrystalGravity.hs is now a DYNAMICS module (pack→tick→unpack).
--   proveImmirzi and proveBHEntropy are inlined here (gravity proofs
--   that CrystalFullTest needs but that don't belong in a dynamics module).
--
-- Compile:
--   ghc -O2 -Wno-x-partial -main-is CrystalFullTest CrystalFullTest.hs && ./CrystalFullTest

module CrystalFullTest where

import System.IO (hSetEncoding, stdout, utf8)
import Text.Printf (printf)
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))

-- Observable proof modules (unchanged from Phases 1-4)
import CrystalAxiom
import CrystalGauge
import CrystalMixing
import CrystalCosmo
import CrystalQCD
import CrystalCrossDomain

-- NOTE: CrystalGravity is NOW a dynamics module (Phase 5).
-- proveImmirzi and proveBHEntropy are inlined below (§1a).
-- import CrystalGravity   ← REMOVED (dynamics module, no proof exports)

-- Extended scan: 103 observables (qualified to avoid name collisions)
import qualified CrystalWACAScan as WS

-- S4+S5: corrected alpha_inv, m_p/m_e, sin2theta_W
import qualified CrystalAlphaProton as AP

-- S6: proton charge radius
import qualified CrystalProtonRadius as PR

-- Dynamics component stack (for dynamics regression §9)
import qualified CrystalAtoms as CA
import CrystalSectors (CrystalState, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, applyW, applyU, normSq)

-- ══════════════════════════════════════════════════════════════════
-- §1  THE TWO RULERS — Toe() vs Toe(vev="pdg")
-- ══════════════════════════════════════════════════════════════════

pdgRuler :: Ruler
pdgRuler = MkRuler mpl_scaled (rulerMZ standardRuler)
  where
    v_crystal  = 245.17368
    v_pdg      = 246.22
    mpl_scaled = rulerMPl standardRuler * (v_pdg / v_crystal)

-- ══════════════════════════════════════════════════════════════════
-- §1a  INLINED GRAVITY PROOFS
--
-- These lived in the old CrystalGravity.hs (proof module).
-- Phase 5 replaced CrystalGravity.hs with a dynamics module.
-- The proofs are unchanged — same formulas, same integers.
-- ══════════════════════════════════════════════════════════════════

-- | Immirzi parameter: (3/13)/(35/36) = 108/455.
proveImmirzi :: Crystal Two Three -> Derived
proveImmirzi c =
  let sw = crFromInts c CrystalAxiom.nC (CrystalAxiom.nW^2 + CrystalAxiom.nC^2)
      z  = crFromInts c (CrystalAxiom.sigmaD - 1) CrystalAxiom.sigmaD
      exact = crVal sw / crVal z
  in Derived "Immirzi γ" "(3/13)/(35/36) = 108/455"
     (fromRational exact) (Just exact) (lqg 0.23753) Computed

-- | BH entropy coefficient: (β₀²/N_w⁴)/π = 49/(16π).
proveBHEntropy :: Crystal Two Three -> Derived
proveBHEntropy c =
  let b    = crystalBasis c
      coef = crFromInts c (CrystalAxiom.beta0^2) (CrystalAxiom.nW ^ (4::Integer))
      val  = crDbl coef / basisPi b
  in Derived "S_BH (nats)" "(β₀²/N_w⁴)/π = 49/(16π)"
     val (Just (crVal coef)) (pdg 0.975) Computed

-- Axiom-layer atoms (Integer, not Int — for crFromInts)
-- ══════════════════════════════════════════════════════════════════
-- §2  FOUR-COLUMN TEST ENTRY
-- ══════════════════════════════════════════════════════════════════

data TestEntry = TestEntry
  { teName       :: String
  , teCrystal    :: Double
  , teCrystalPdg :: Double
  , teExpt       :: Double
  , tePWI        :: Double
  , teRawPWI     :: Double
  , teRating     :: String
  , teFormula    :: String
  , teSource     :: String
  } deriving (Show)

fromDerivedPair :: String -> Derived -> Derived -> TestEntry
fromDerivedPair src crystalD pdgD = TestEntry
  { teName       = dName crystalD
  , teCrystal    = dCrystal crystalD
  , teCrystalPdg = dCrystal pdgD
  , teExpt       = expt
  , tePWI        = pwi
  , teRawPWI     = rawPwi
  , teRating     = pwiRating pwi
  , teFormula    = dFormula crystalD
  , teSource     = src
  }
  where
    expt   = measValue (dMeas crystalD)
    pwi    = abs (dCrystal pdgD - expt) / abs expt * 100.0
    rawPwi = abs (dCrystal crystalD - expt) / abs expt * 100.0

fromObservable :: String -> (String, Double, Double, Double, String, String, String) -> TestEntry
fromObservable src (name, crystal, pdgVal, _pwi, _rating, formula, _domain) = TestEntry
  { teName       = name
  , teCrystal    = crystal
  , teCrystalPdg = crystal
  , teExpt       = pdgVal
  , tePWI        = pwi
  , teRawPWI     = pwi
  , teRating     = pwiRating pwi
  , teFormula    = formula
  , teSource     = src
  }
  where pwi = abs (crystal - pdgVal) / abs pdgVal * 100.0

mkTest :: String -> String -> String -> Double -> Double -> TestEntry
mkTest src name formula crystal expt = TestEntry
  { teName       = name
  , teCrystal    = crystal
  , teCrystalPdg = crystal
  , teExpt       = expt
  , tePWI        = pwi
  , teRawPWI     = pwi
  , teRating     = pwiRating pwi
  , teFormula    = formula
  , teSource     = src
  }
  where pwi = abs (crystal - expt) / abs expt * 100.0

-- ══════════════════════════════════════════════════════════════════
-- §3  SOURCE 1: ORIGINAL 92 — CALLED TWICE
-- ══════════════════════════════════════════════════════════════════

original92 :: [TestEntry]
original92 =
  let c   = crystalAxiom
      r   = standardRuler
      rp  = pdgRuler
      src = "Original"

      crystalDerived =
        [ proveAlphaInv c, proveSinSqThetaW_OS c, proveSinSqThetaW_MS c
        , CrystalGauge.proveVEV c r, proveHiggsMass c r, proveKoide c
        , CrystalMixing.proveVus c, proveWolfA_Z c, CrystalMixing.proveVcb c
        , proveDeltaCKM c, proveVub c, proveJarlskog c
        , proveSinSq12 c, proveSinSq23 c, proveSinSq13Corrected c, proveDeltaPMNS c
        , proveDMRatio c, proveLambda c r
        , proveNuMass3 c r, proveNuMass2 c r, proveSumNu c r
        , proveNuMass3_osc c, proveMBetaBeta c r
        , proveProtonMass c r, proveNeutronMass c r
        , proveStringTension c r, proveChargeRadius c r
        , proveMassRatio_s_ud c, proveMassRatio_c_s c
        , proveMassRatio_b_s c, proveMassRatio_b_c c
        , proveMassRatio_u_d c, proveMassRatio_t_b c
        , CrystalQCD.proveTopMass c r, proveFPi c r
        , provePionMass c r, proveAbsMs c r, proveAbsMu c r
        , proveAbsMd c r, proveNPsplitting c r
        , proveEtaPrimeMass c r, proveEtaMassCorrected c r, proveKaonMass c r
        , proveDecupletSpacingCorrected c r, proveSigmaLambda c r
        , proveGlueball0pp c r, proveGlueball0mp c r, proveGlueball2pp c r
        , proveRhoMassCorrected c r
        , proveMZCorrected c r, proveMW c r, proveLambdaBaryon c r
        , proveEtaB c
        , proveImmirzi c, proveBHEntropy c, CrystalGauge.proveTauMass c r
        , proveGenerations c, proveEntropy c
        , proveAlphaS c, proveMuonElectronRatio c
        , proveMuonMassCorrected c r, proveElectronMassCorrected c r
        , CrystalQCD.proveCharmMass c r
        , proveOmegaRatio c, proveFeigenbaum c
        , proveBlasius c, proveKleiber c, CrystalCrossDomain.proveVonKarman c
        , proveBenford c
        , proveDarkPhotonMixing c
        , proveThetaStar c, proveOmegaLambda c, proveOmegaMatter c
        , CrystalCosmo.proveOmegaBaryon c, proveSpectralIndex c, proveAmplitude c
        , proveAxialCoupling c, proveWWidth c r, proveZWidth c r
        , proveMuonQCDRatio c, proveSpectralGm2 c
        , proveHaloSlope c, proveEoS c
        , proveJPsi c r, proveUpsilonCorrected c r, proveDMesonCorrected c r, proveBMeson c r
        , provePhiMesonCorrected c r, proveOmegaMesonCorrected c r, proveKStarMeson c r
        , proveSigmaBaryon c r, proveOmegaSSS c r
        ]

      pdgDerived =
        [ proveAlphaInv c, proveSinSqThetaW_OS c, proveSinSqThetaW_MS c
        , CrystalGauge.proveVEV c rp, proveHiggsMass c rp, proveKoide c
        , CrystalMixing.proveVus c, proveWolfA_Z c, CrystalMixing.proveVcb c
        , proveDeltaCKM c, proveVub c, proveJarlskog c
        , proveSinSq12 c, proveSinSq23 c, proveSinSq13Corrected c, proveDeltaPMNS c
        , proveDMRatio c, proveLambda c rp
        , proveNuMass3 c rp, proveNuMass2 c rp, proveSumNu c rp
        , proveNuMass3_osc c, proveMBetaBeta c rp
        , proveProtonMass c rp, proveNeutronMass c rp
        , proveStringTension c rp, proveChargeRadius c rp
        , proveMassRatio_s_ud c, proveMassRatio_c_s c
        , proveMassRatio_b_s c, proveMassRatio_b_c c
        , proveMassRatio_u_d c, proveMassRatio_t_b c
        , CrystalQCD.proveTopMass c rp, proveFPi c rp
        , provePionMass c rp, proveAbsMs c rp, proveAbsMu c rp
        , proveAbsMd c rp, proveNPsplitting c rp
        , proveEtaPrimeMass c rp, proveEtaMassCorrected c rp, proveKaonMass c rp
        , proveDecupletSpacingCorrected c rp, proveSigmaLambda c rp
        , proveGlueball0pp c rp, proveGlueball0mp c rp, proveGlueball2pp c rp
        , proveRhoMassCorrected c rp
        , proveMZCorrected c rp, proveMW c rp, proveLambdaBaryon c rp
        , proveEtaB c
        , proveImmirzi c, proveBHEntropy c, CrystalGauge.proveTauMass c rp
        , proveGenerations c, proveEntropy c
        , proveAlphaS c, proveMuonElectronRatio c
        , proveMuonMassCorrected c rp, proveElectronMassCorrected c rp
        , CrystalQCD.proveCharmMass c rp
        , proveOmegaRatio c, proveFeigenbaum c
        , proveBlasius c, proveKleiber c, CrystalCrossDomain.proveVonKarman c
        , proveBenford c
        , proveDarkPhotonMixing c
        , proveThetaStar c, proveOmegaLambda c, proveOmegaMatter c
        , CrystalCosmo.proveOmegaBaryon c, proveSpectralIndex c, proveAmplitude c
        , proveAxialCoupling c, proveWWidth c rp, proveZWidth c rp
        , proveMuonQCDRatio c, proveSpectralGm2 c
        , proveHaloSlope c, proveEoS c
        , proveJPsi c rp, proveUpsilonCorrected c rp, proveDMesonCorrected c rp, proveBMeson c rp
        , provePhiMesonCorrected c rp, proveOmegaMesonCorrected c rp, proveKStarMeson c rp
        , proveSigmaBaryon c rp, proveOmegaSSS c rp
        ]

  in zipWith (fromDerivedPair src) crystalDerived pdgDerived

-- ══════════════════════════════════════════════════════════════════
-- §4  SOURCE 2: EXTENDED SCAN 103
-- ══════════════════════════════════════════════════════════════════

extended86 :: [TestEntry]
extended86 =
  let swap obs@(name, _, _, _, _, _, _)
        | name == "Ω_DM (dark matter)" = WS.proveOmegaDMCorrected
        | otherwise                    = obs
  in map (fromObservable "Extended" . swap) WS.wacaScanResults

-- ══════════════════════════════════════════════════════════════════
-- §5  SOURCE 3: S4-S6 CORRECTED CONSTANTS
-- ══════════════════════════════════════════════════════════════════

s4s6entries :: [TestEntry]
s4s6entries =
  let src = "S4-S6"
      alphaCorr = mkTest src
        "alpha_inv (a4 corrected)"
        "2(gauss²+d₄)/π+d₃^κ−1/(χ·d₄·Σd²·D)"
        AP.proveAlphaInvCorrected
        AP.pdg_alpha_inv
      mpmeCorr = mkTest src
        "m_p/m_e (a4 corrected)"
        "2(D²+Σd)/d₃+gauss^Nc/κ+κ/(N_w·χ·Σd²·D)"
        AP.proveMpMeCorrected
        AP.pdg_mp_me
      (_, _, rpVal, _) = PR.prove_protonRadius
      rpEntry = mkTest src
        "r_p (proton radius)"
        "(C_F·N_c−T_F/(d₃·Σd))×ℏ/(m_p·c)"
        rpVal
        PR.r_p_muonic
  in [alphaCorr, mpmeCorr, rpEntry]

-- ══════════════════════════════════════════════════════════════════
-- §6  COMBINED CATALOGUE
-- ══════════════════════════════════════════════════════════════════

allTests :: [TestEntry]
allTests = original92 ++ extended86 ++ s4s6entries

-- ══════════════════════════════════════════════════════════════════
-- §7  STATISTICS
-- ══════════════════════════════════════════════════════════════════

computeCV :: [TestEntry] -> Double
computeCV entries =
  let nonzero = [tePWI e | e <- entries, tePWI e > 1e-6]
      n   = fromIntegral (length nonzero)
      mu  = sum nonzero / n
      var = sum [(x - mu)^(2::Int) | x <- nonzero] / (n - 1)
      std = sqrt var
  in  std / mu

computeMean :: [TestEntry] -> Double
computeMean entries =
  let nonzero = [tePWI e | e <- entries, tePWI e > 1e-6]
  in  sum nonzero / fromIntegral (length nonzero)

-- ══════════════════════════════════════════════════════════════════
-- §8  DYNAMICS REGRESSION (Phase 5)
--
-- Tests the component stack and the tick on the 36.
-- Every dynamics module uses the same engine:
--   pack → tick → unpack. 36 multiplies. O(1) per site.
--
-- Tests:
--   1. Component stack atoms (nW=2, nC=3, chi=6, etc.)
--   2. Eigenvalues (lambda 0..3 = {1, 1/2, 1/3, 1/6})
--   3. W.U factorisation (applyW . applyU = tick)
--   4. Singlet conservation (lambda 0 = 1)
--   5. Norm contraction (normSq(tick s) < normSq(s))
--   6. Sector isolation (tick preserves sector boundaries)
--   7. Pack/unpack round-trip (inject then extract = identity)
-- ══════════════════════════════════════════════════════════════════

data DynTest = DynTest
  { dtName :: String
  , dtPass :: Bool
  } deriving (Show)

dynamicsTests :: [DynTest]
dynamicsTests =
  let -- Test state: uniform across all 36 components
      st0 = [1.0 / sqrt (fromIntegral CA.sigmaD) | _ <- [1..CA.sigmaD]]
      st1 = tick st0

      -- Sector-specific test state
      singletonSt = replicate CA.sigmaD 0.0
      weakSt = injectSector 1 [1.0, 2.0, 3.0] (replicate CA.sigmaD 0.0)
      colourSt = injectSector 2 [1,2,3,4,5,6,7,8] (replicate CA.sigmaD 0.0)

      -- Eigenvalue checks
      eps = 1e-12

  in [ -- §8a Component stack atoms
       DynTest "nW = 2"       (CA.nW == 2)
     , DynTest "nC = 3"       (CA.nC == 3)
     , DynTest "chi = 6"      (CA.chi == 6)
     , DynTest "beta0 = 7"    (CA.beta0 == 7)
     , DynTest "d1 = 1"       (CA.d1 == 1)
     , DynTest "d2 = 3"       (CA.d2 == 3)
     , DynTest "d3 = 8"       (CA.d3 == 8)
     , DynTest "d4 = 24"      (CA.d4 == 24)
     , DynTest "sigmaD = 36"  (CA.sigmaD == 36)
     , DynTest "towerD = 42"  (CA.towerD == 42)
     , DynTest "gauss = 13"   (CA.gauss == 13)

       -- §8b Eigenvalues
     , DynTest "lambda 0 = 1"   (abs (lambda 0 - 1.0) < eps)
     , DynTest "lambda 1 = 1/2" (abs (lambda 1 - 0.5) < eps)
     , DynTest "lambda 2 = 1/3" (abs (lambda 2 - 1.0/3.0) < eps)
     , DynTest "lambda 3 = 1/6" (abs (lambda 3 - 1.0/6.0) < eps)
     , DynTest "lambda_mixed = lambda_weak * lambda_colour"
         (abs (lambda 3 - lambda 1 * lambda 2) < eps)

       -- §8c W.U factorisation
     , DynTest "W.U = tick" (all (\(a,b) -> abs (a-b) < eps)
                              (zip (applyW (applyU st0)) (tick st0)))

       -- §8d Singlet conservation
     , DynTest "singlet conserved (lambda=1)"
         (abs (head st1 - head st0) < eps)

       -- §8e Norm contraction
     , DynTest "tick contracts norm"
         (normSq st1 < normSq st0)

       -- §8f Sector isolation
     , DynTest "tick on weak-only: singlet stays 0"
         (abs (head (tick weakSt)) < eps)
     , DynTest "tick on weak-only: colour stays 0"
         (all (\x -> abs x < eps) (extractSector 2 (tick weakSt)))

       -- §8g Pack/unpack round-trip
     , DynTest "extractSector . injectSector = id (weak)"
         (extractSector 1 weakSt == [1.0, 2.0, 3.0])
     , DynTest "extractSector . injectSector = id (colour)"
         (extractSector 2 colourSt == [1,2,3,4,5,6,7,8])

       -- §8h Eigenvalue denominator product
     , DynTest "1 * N_w * N_c * chi = 36 = sigmaD"
         (1 * CA.nW * CA.nC * CA.chi == CA.sigmaD)

       -- §8i wK/uK half-step values
     , DynTest "wK 1 = 1/sqrt(2)" (abs (wK 1 - 1/sqrt 2) < eps)
     , DynTest "wK 2 = 1/sqrt(3)" (abs (wK 2 - 1/sqrt 3) < eps)
     , DynTest "wK 3 = 1/sqrt(6)" (abs (wK 3 - 1/sqrt 6) < eps)
     , DynTest "wK * uK = lambda"
         (all (\k -> abs (wK k * uK k - lambda k) < eps) [0,1,2,3])
     ]

-- ══════════════════════════════════════════════════════════════════
-- §9  MAIN
-- ══════════════════════════════════════════════════════════════════

main :: IO ()
main = do
  hSetEncoding stdout utf8

  putStrLn ""
  putStrLn "════════════════════════════════════════════════════════════════════════════════════"
  putStrLn "  CRYSTAL TOPOS — FULL REGRESSION TEST (FOUR-COLUMN GAP ANALYSIS)"
  putStrLn "  A_F = C + M2(C) + M3(C).  Zero free parameters."
  putStrLn "  Crystal = Toe()  |  CrystalPdg = Toe(vev=\"pdg\")  |  PWI = |Expt − CrystalPdg|/Expt"
  putStrLn "  Phase 5 refactor: CrystalGravity → dynamics. Proofs inlined."
  putStrLn "════════════════════════════════════════════════════════════════════════════════════"
  putStrLn ""

  -- ── VEV values ──
  let c = crystalAxiom
      vCrystal = dCrystal (CrystalGauge.proveVEV c standardRuler)
      vPdg     = dCrystal (CrystalGauge.proveVEV c pdgRuler)
  printf "  Toe()            v = %.5f GeV  (crystal derived, ground truth)\n" vCrystal
  printf "  Toe(vev=\"pdg\")   v = %.5f GeV  (PDG, for gap analysis)\n" vPdg
  printf "  Ratio              = %.6f\n" (vPdg / vCrystal)
  putStrLn ""

  -- ── Count verification ──
  let nOrig = length original92
      nExt  = length extended86
      nS46  = length s4s6entries
      nAll  = length allTests

  printf "  Source counts:\n"
  printf "    Original (two rulers):        %d\n" nOrig
  printf "    Extended (WACAScan, PDG VEV):  %d\n" nExt
  printf "    S4-S6 (corrected constants):   %d\n" nS46
  printf "    ────────────────────────────────────\n"
  printf "    TOTAL:                         %d\n" nAll
  putStrLn ""

  let countOK = nOrig == 92 && nExt == 103 && nS46 == 3 && nAll == 198
  if countOK
    then putStrLn "  COUNT CHECK: PASS (92 + 103 + 3 = 198)"
    else do
      putStrLn "  COUNT CHECK: *** FAIL ***"
      if nOrig /= 92  then printf "    Expected 92, got %d\n" nOrig   else pure ()
      if nExt  /= 103 then printf "    Expected 103, got %d\n" nExt    else pure ()
      if nS46  /= 3   then printf "    Expected 3, got %d\n"  nS46    else pure ()
      if nAll  /= 198 then printf "    Expected 198, got %d\n" nAll    else pure ()
  putStrLn ""

  -- ── Rating legend ──
  putStrLn "  Rating:  ■ EXACT (0%)     The crystal gives the exact value."
  putStrLn "           ● TIGHT (<0.5%)  Strong prediction."
  putStrLn "           ◐ GOOD  (<1.0%)  Reliable. Moderate wobble."
  putStrLn "           ○ LOOSE (<4.5%)  Under the prime wall."
  putStrLn "           ✗ OVER  (≥4.5%)  Derived quantity amplifies input PWI."
  putStrLn ""

  -- ── Four-column table ──
  putStrLn "══ §4 ALL DERIVED OBSERVABLES ══"
  printf "  %-26s %-35s %12s %12s %12s %8s  %s\n"
    ("Name" :: String) ("Formula" :: String)
    ("Crystal" :: String) ("CrystalPdg" :: String)
    ("Expt" :: String) ("PWI" :: String) ("Status" :: String)
  putStrLn $ "  " ++ replicate 140 '─'

  let indexed = zip [1::Int ..] allTests
  mapM_ (\(_, e) -> do
    let tag = if tePWI e < 4.5 then " " else "!"
    printf "%s%-26s %-35s %12.5g %12.5g %12.5g %7.3f%%  %s\n"
      tag (teName e) (teFormula e)
      (teCrystal e) (teCrystalPdg e) (teExpt e)
      (tePWI e) (teRating e)
    ) indexed
  putStrLn $ "  " ++ replicate 140 '─'
  putStrLn ""

  -- ── Statistics ──
  let allPwi    = map tePWI allTests
      nExact   = length (filter (<= 1e-6) allPwi)
      nTight   = length [p | p <- allPwi, p > 1e-6 && p < 0.5]
      nGood    = length [p | p <- allPwi, p >= 0.5 && p < 1.0]
      nLoose   = length [p | p <- allPwi, p >= 1.0 && p < 4.5]
      nOver    = length (filter (>= 4.5) allPwi)
      meanPwi  = computeMean allTests
      cv       = computeCV allTests
      maxPwi   = maximum allPwi
      maxName  = teName $ head $ sortBy (comparing (Down . tePWI)) allTests

  putStrLn "  COMBINED STATISTICS"
  putStrLn "  ══════════════════════════════════════════"
  printf   "  Total observables:       %d\n" nAll
  printf   "  EXACT  (PWI = 0):        %d\n" nExact
  printf   "  TIGHT  (PWI < 0.5%%):     %d\n" nTight
  printf   "  GOOD   (0.5%% - 1%%):      %d\n" nGood
  printf   "  LOOSE  (1%% - 4.5%%):      %d\n" nLoose
  printf   "  OVER   (PWI >= 4.5%%):    %d\n" nOver
  putStrLn "  ──────────────────────────────────────────"
  printf   "  Mean PWI (CrystalPdg vs Expt):  %.4f%%\n" meanPwi
  printf   "  CV (std/mean):                   %.4f\n" cv
  printf   "  Maximum PWI:                     %.3f%%  (%s)\n" maxPwi maxName
  printf   "  Wall breaches (>=4.5%%):          %d\n" nOver
  putStrLn "  ══════════════════════════════════════════"
  putStrLn ""

  -- ── Scheme noise diagnostic ──
  putStrLn "  SCHEME NOISE DIAGNOSTIC (Original 92 — two rulers)"
  putStrLn "  ──────────────────────────────────────────────────────────"
  let vDep = [(teName e, teRawPWI e, tePWI e)
             | e <- original92
             , abs (teCrystal e - teCrystalPdg e) > 1e-10]
      nVDep = length vDep
  printf   "  v-dependent (Crystal ≠ CrystalPdg):  %d\n" nVDep
  printf   "  Dimensionless (Crystal = CrystalPdg): %d\n" (length original92 - nVDep)
  putStrLn ""
  putStrLn "  v-dependent observables — scheme noise removed:"
  mapM_ (\(n, raw, pwi) ->
    if raw - pwi > 0.01
      then printf "    %-30s  Raw=%.3f%%  PWI=%.3f%%  (saved %.3f%%)\n" n raw pwi (raw - pwi)
      else pure ()
    ) vDep
  putStrLn ""

  -- ── CV target ──
  printf "  CV TARGET: %.4f  " cv
  if cv < 1.0
    then putStrLn "(PASS — below 1.0)"
    else if cv < 1.1
      then putStrLn "(CLOSE — between 1.0 and 1.1)"
      else printf "(ABOVE TARGET — current: %.4f, target: < 1.0)\n" cv
  putStrLn ""

  -- ── Top 5 outliers ──
  putStrLn "  TOP 5 OUTLIERS:"
  putStrLn "  ──────────────────────────────────────────"
  let sorted = sortBy (comparing (Down . tePWI)) allTests
      top5   = take 5 sorted
  mapM_ (\e -> printf "    %-35s  PWI=%.3f%%  Raw=%.3f%%  [%s]\n"
    (teName e) (tePWI e) (teRawPWI e) (teSource e)) top5
  putStrLn ""

  -- ── Per-source CV ──
  putStrLn "  PER-SOURCE CV:"
  printf   "    Original (92, two rulers):  %.4f\n" (computeCV original92)
  printf   "    Extended (103, PDG VEV):    %.4f\n" (computeCV extended86)
  printf   "    Combined (all):             %.4f\n" cv
  putStrLn ""

  -- ── S4-S6 detail ──
  putStrLn "  S4-S6 CODATA PRECISION:"
  putStrLn "  ──────────────────────────────────────────"
  let alphaEntry = s4s6entries !! 0
      mpmeEntry  = s4s6entries !! 1
      rpEntry    = s4s6entries !! 2
      alphaDeltaUnc = abs (teCrystal alphaEntry - teExpt alphaEntry) / AP.pdg_alpha_inv_unc
      mpmeDeltaUnc  = abs (teCrystal mpmeEntry - teExpt mpmeEntry) / AP.pdg_mp_me_unc
      rpDeltaUnc    = abs (teCrystal rpEntry - teExpt rpEntry) / PR.r_p_muonic_unc
  printf "    alpha_inv:  crystal = %.9f  PDG = %.9f  delta/unc = %.2f\n"
    (teCrystal alphaEntry) (teExpt alphaEntry) alphaDeltaUnc
  printf "    m_p/m_e:    crystal = %.8f  PDG = %.8f  delta/unc = %.2f\n"
    (teCrystal mpmeEntry) (teExpt mpmeEntry) mpmeDeltaUnc
  printf "    r_p (fm):   crystal = %.7f  exp = %.5f  delta/unc = %.4f\n"
    (teCrystal rpEntry) (teExpt rpEntry) rpDeltaUnc
  putStrLn ""

  -- ══════════════════════════════════════════════════════════════
  -- §9  DYNAMICS REGRESSION (Phase 5)
  -- ══════════════════════════════════════════════════════════════
  putStrLn "══ §9 DYNAMICS REGRESSION (Phase 5: Component Stack) ══"
  putStrLn "  The dynamics IS the tick on the 36. O(1) per site."
  putStrLn "  CrystalState = 36 Doubles = [1] + [3] + [8] + [24]"
  putStrLn "  λ = {1, 1/2, 1/3, 1/6}.  S = W∘U.  Zero bespoke integrators."
  putStrLn ""

  let dynResults = dynamicsTests
      dynPass   = length (filter dtPass dynResults)
      dynFail   = length (filter (not . dtPass) dynResults)
      dynTotal  = length dynResults

  mapM_ (\dt ->
    putStrLn $ "  " ++ (if dtPass dt then "PASS" else "FAIL") ++ "  " ++ dtName dt
    ) dynResults
  putStrLn ""
  printf "  Dynamics: %d/%d PASS\n" dynPass dynTotal
  if dynFail > 0
    then printf "  *** %d DYNAMICS FAILURES ***\n" dynFail
    else putStrLn "  All dynamics tests pass. Component stack verified."
  putStrLn ""

  -- ── Final verdict ──
  let obsPass  = nOver == 0
      dynOK    = dynFail == 0
      allOK    = obsPass && countOK && dynOK
  putStrLn "════════════════════════════════════════════════════════════════════════════════════"
  if allOK
    then do
      printf "  RESULT: ALL %d OBSERVABLES PASS + %d/%d DYNAMICS TESTS PASS\n" nAll dynPass dynTotal
      putStrLn "  Phase 5 complete. CrystalGravity → dynamics. Component stack verified."
    else do
      if not countOK then putStrLn "  RESULT: COUNT MISMATCH"    else pure ()
      if not obsPass then printf "  RESULT: %d ABOVE PRIME WALL\n" nOver else pure ()
      if not dynOK   then printf "  RESULT: %d DYNAMICS FAILURES\n" dynFail else pure ()
  putStrLn "════════════════════════════════════════════════════════════════════════════════════"
  putStrLn ""

-- ══════════════════════════════════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════════════════════════════════

printf_pad :: Int -> String -> String
printf_pad n s = take (max n (length s)) (s ++ repeat ' ')
