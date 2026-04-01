-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- | CrystalFullTest.hs
-- Four-column regression test for the full observable catalogue.
--
-- THE FOUR-COLUMN TABLE:
--   Crystal    = Toe()          → formula(standardRuler)  → crystal VEV 245.17
--   CrystalPdg = Toe(vev="pdg") → formula(pdgRuler)      → PDG VEV 246.22
--   Expt       = experimental value
--   PWI        = |Expt − CrystalPdg| / Expt   (scheme noise REMOVED)
--
-- Two calls.  Same formulas.  Different VEV.
-- The PWI tests formula accuracy, not scheme choice.
--
-- Compile:  ghc -O2 -main-is CrystalFullTest CrystalFullTest.hs -o full_test
-- Run:      ./full_test

module CrystalFullTest where

import System.IO (hSetEncoding, stdout, utf8)
import Text.Printf (printf)
import Data.List (sortBy)
import Data.Ord (comparing, Down(..))

-- Original 92: same imports as Main.hs
import CrystalAxiom
import CrystalGauge
import CrystalMixing
import CrystalCosmo
import CrystalQCD
import CrystalGravity
import CrystalCrossDomain

-- Extended scan: 103 observables (qualified to avoid name collisions)
import qualified CrystalWACAScan as WS

-- S4+S5: corrected alpha_inv, m_p/m_e, sin2theta_W
import qualified CrystalAlphaProton as AP

-- S6: proton charge radius
import qualified CrystalProtonRadius as PR

-- ══════════════════════════════════════════════════════════════════
-- §1  THE TWO RULERS — Toe() vs Toe(vev="pdg")
-- ══════════════════════════════════════════════════════════════════

-- | pdgRuler: M_Pl scaled so proveVEV c pdgRuler = 246.22 GeV.
--
--   proveVEV computes: v = M_Pl × 35/(43×36×2⁵⁰)
--   standardRuler:     v = 1.220890e19 × ... = 245.17368 GeV   (Toe())
--   pdgRuler:          v = M_Pl_scaled × ... = 246.22000 GeV   (Toe(vev="pdg"))
--
--   Same formula.  Different input.  Two actual calls.
pdgRuler :: Ruler
pdgRuler = MkRuler mpl_scaled (rulerMZ standardRuler)
  where
    v_crystal  = 245.17368   -- GeV, output of proveVEV c standardRuler
    v_pdg      = 246.22      -- GeV, PDG experimental extraction
    mpl_scaled = rulerMPl standardRuler * (v_pdg / v_crystal)

-- ══════════════════════════════════════════════════════════════════
-- §2  FOUR-COLUMN TEST ENTRY
-- ══════════════════════════════════════════════════════════════════

data TestEntry = TestEntry
  { teName       :: String     -- observable name
  , teCrystal    :: Double     -- Toe(): crystal VEV (245.17)
  , teCrystalPdg :: Double     -- Toe(vev="pdg"): same formula, PDG VEV (246.22)
  , teExpt       :: Double     -- experimental / PDG value
  , tePWI        :: Double     -- PWI = |Expt − CrystalPdg| / Expt (scheme noise removed)
  , teRawPWI     :: Double     -- raw = |Expt − Crystal| / Expt (includes scheme noise)
  , teRating     :: String     -- rating symbol (on PWI, not raw)
  , teFormula    :: String     -- crystal formula
  , teSource     :: String     -- which module group
  } deriving (Show)

-- | Build TestEntry from two Derived: Toe() and Toe(vev="pdg").
--   Two actual calls to the same prove function.
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

-- | Build TestEntry from WACAScan Observable (already uses PDG VEV internally).
fromObservable :: String -> (String, Double, Double, Double, String, String, String) -> TestEntry
fromObservable src (name, crystal, pdgVal, _pwi, _rating, formula, _domain) = TestEntry
  { teName       = name
  , teCrystal    = crystal          -- NOTE: WACAScan uses v_mev=246220 (PDG)
  , teCrystalPdg = crystal          -- same — already PDG VEV
  , teExpt       = pdgVal
  , tePWI        = pwi
  , teRawPWI     = pwi
  , teRating     = pwiRating pwi
  , teFormula    = formula
  , teSource     = src
  }
  where pwi = abs (crystal - pdgVal) / abs pdgVal * 100.0

-- | Build TestEntry from raw values (S4-S6).
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

-- | The original 92 observables, computed with BOTH rulers.
--   This IS calling Toe() and Toe(vev="pdg").
--   Same formulas.  Two calls.  Different VEV.
original92 :: [TestEntry]
original92 =
  let c   = crystalAxiom
      r   = standardRuler     -- Toe()
      rp  = pdgRuler          -- Toe(vev="pdg")
      src = "Original"

      -- ── Call 1: Toe() — crystal VEV ──────────────────────────
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
        , proveEtaPrimeMass c r, proveEtaMass c r, proveKaonMass c r
        , proveDecupletSpacing c r, proveSigmaLambda c r
        , proveGlueball0pp c r, proveGlueball0mp c r, proveGlueball2pp c r
        , proveRhoMassCorrected c r
        , proveMZ c r, proveMW c r, proveLambdaBaryon c r
        , proveEtaB c
        , proveImmirzi c, proveBHEntropy c, CrystalGauge.proveTauMass c r
        , proveGenerations c, proveEntropy c
        , proveAlphaS c, proveMuonElectronRatio c
        , proveMuonMass c r, proveElectronMass c r
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
        , provePhiMesonCorrected c r, proveOmegaMeson c r, proveKStarMeson c r
        , proveSigmaBaryon c r, proveOmegaSSS c r
        ]

      -- ── Call 2: Toe(vev="pdg") — PDG VEV ────────────────────
      --   SAME prove functions.  pdgRuler instead of standardRuler.
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
        , proveEtaPrimeMass c rp, proveEtaMass c rp, proveKaonMass c rp
        , proveDecupletSpacing c rp, proveSigmaLambda c rp
        , proveGlueball0pp c rp, proveGlueball0mp c rp, proveGlueball2pp c rp
        , proveRhoMassCorrected c rp
        , proveMZ c rp, proveMW c rp, proveLambdaBaryon c rp
        , proveEtaB c
        , proveImmirzi c, proveBHEntropy c, CrystalGauge.proveTauMass c rp
        , proveGenerations c, proveEntropy c
        , proveAlphaS c, proveMuonElectronRatio c
        , proveMuonMass c rp, proveElectronMass c rp
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
        , provePhiMesonCorrected c rp, proveOmegaMeson c rp, proveKStarMeson c rp
        , proveSigmaBaryon c rp, proveOmegaSSS c rp
        ]

  in zipWith (fromDerivedPair src) crystalDerived pdgDerived

-- ══════════════════════════════════════════════════════════════════
-- §4  SOURCE 2: EXTENDED SCAN 103
-- ══════════════════════════════════════════════════════════════════

-- NOTE: WACAScan uses v_mev = 246220 (PDG) internally.
-- Values are ALREADY CrystalPdg.  Crystal = CrystalPdg for these
-- until WACAScan is refactored to accept VEVMode.
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
-- §8  MAIN
-- ══════════════════════════════════════════════════════════════════

main :: IO ()
main = do
  hSetEncoding stdout utf8

  putStrLn ""
  putStrLn "════════════════════════════════════════════════════════════════════════════════════"
  putStrLn "  CRYSTAL TOPOS — FULL REGRESSION TEST (FOUR-COLUMN GAP ANALYSIS)"
  putStrLn "  A_F = C + M2(C) + M3(C).  Zero free parameters."
  putStrLn "  Crystal = Toe()  |  CrystalPdg = Toe(vev=\"pdg\")  |  PWI = |Expt − CrystalPdg|/Expt"
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
  mapM_ (\(i, e) -> do
    let pass = tePWI e < 4.5
        tag  = if pass then " " else "!"
    printf "%s%-26s %-35s %12.5g %12.5g %12.5g %7.3f%%  %s\n"
      tag (teName e) (teFormula e)
      (teCrystal e) (teCrystalPdg e) (teExpt e)
      (tePWI e) (teRating e)
    ) indexed
  putStrLn $ "  " ++ replicate 140 '─'
  putStrLn ""

  -- ── Statistics ──
  let allPwi    = map tePWI allTests
      allRawPwi = map teRawPWI allTests
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

  -- ── Final verdict ──
  let allPass = nOver == 0
  putStrLn "════════════════════════════════════════════════════════════════════════════════════"
  if allPass && countOK
    then putStrLn "  RESULT: ALL 198 OBSERVABLES PASS (PWI uses CrystalPdg, scheme noise removed)"
    else do
      if not countOK then putStrLn "  RESULT: COUNT MISMATCH"    else pure ()
      if not allPass then printf "  RESULT: %d ABOVE PRIME WALL\n" nOver else pure ()
  putStrLn "════════════════════════════════════════════════════════════════════════════════════"
  putStrLn ""

-- ══════════════════════════════════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════════════════════════════════

printf_pad :: Int -> String -> String
printf_pad n s = take (max n (length s)) (s ++ repeat ' ')
