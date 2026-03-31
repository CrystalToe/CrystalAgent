-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- | CrystalFullTest.hs
-- One-command regression test for the full 198-observable catalogue.
-- Imports from all source modules, normalises into a single test list,
-- computes combined CV, prints PASS/FAIL for each observable.
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

-- S8: CrystalHierarchy (imported for documentation; corrections in QCD/WACAScan)

-- ══════════════════════════════════════════════════════════════════
-- UNIFIED TEST ENTRY
-- ══════════════════════════════════════════════════════════════════

data TestEntry = TestEntry
  { teName     :: String     -- observable name
  , teCrystal  :: Double     -- crystal prediction
  , teExpt     :: Double     -- experimental / PDG value
  , tePWI      :: Double     -- prime wobble index (%)
  , teRating   :: String     -- rating symbol
  , teFormula  :: String     -- crystal formula
  , teSource   :: String     -- which module group (Original/Extended/S4-S6)
  } deriving (Show)

-- | Convert a Derived (from Main modules) into a TestEntry.
fromDerived :: String -> Derived -> TestEntry
fromDerived src d = TestEntry
  { teName    = dName d
  , teCrystal = dCrystal d
  , teExpt    = measValue (dMeas d)
  , tePWI     = gap d
  , teRating  = pwiRating (gap d)
  , teFormula = dFormula d
  , teSource  = src
  }

-- | Convert a WACAScan Observable (7-tuple) into a TestEntry.
fromObservable :: String -> (String, Double, Double, Double, String, String, String) -> TestEntry
fromObservable src (name, crystal, pdgVal, pwi, rating, formula, _domain) = TestEntry
  { teName    = name
  , teCrystal = crystal
  , teExpt    = pdgVal
  , tePWI     = pwi
  , teRating  = rating
  , teFormula = formula
  , teSource  = src
  }

-- | Build a TestEntry from raw values.
mkTest :: String -> String -> String -> Double -> Double -> TestEntry
mkTest src name formula crystal expt = TestEntry
  { teName    = name
  , teCrystal = crystal
  , teExpt    = expt
  , tePWI     = pwi
  , teRating  = pwiRating pwi
  , teFormula = formula
  , teSource  = src
  }
  where pwi = abs (crystal - expt) / abs expt * 100.0

-- ══════════════════════════════════════════════════════════════════
-- SOURCE 1: ORIGINAL 92 (from Main.hs modules)
-- ══════════════════════════════════════════════════════════════════

original92 :: [TestEntry]
original92 =
  let c = crystalAxiom
      r = standardRuler
      src = "Original"
      derived =
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
        -- Heavy hadrons
        , proveJPsi c r, proveUpsilonCorrected c r, proveDMesonCorrected c r, proveBMeson c r
        , provePhiMesonCorrected c r, proveOmegaMeson c r, proveKStarMeson c r
        , proveSigmaBaryon c r, proveOmegaSSS c r
        ]
  in map (fromDerived src) derived

-- ══════════════════════════════════════════════════════════════════
-- SOURCE 2: EXTENDED SCAN 103 (from CrystalWACAScan)
-- ══════════════════════════════════════════════════════════════════

extended86 :: [TestEntry]
extended86 =
  -- Swap uncorrected Ω_DM for corrected version (session 8)
  let swap obs@(name, _, _, _, _, _, _)
        | name == "Ω_DM (dark matter)" = WS.proveOmegaDMCorrected
        | otherwise                    = obs
  in map (fromObservable "Extended" . swap) WS.wacaScanResults

-- ══════════════════════════════════════════════════════════════════
-- SOURCE 3: S4-S6 CORRECTED CONSTANTS (3 new observables)
-- ══════════════════════════════════════════════════════════════════

s4s6entries :: [TestEntry]
s4s6entries =
  let src = "S4-S6"
      -- S4: alpha_inv with a4 correction
      alphaCorr = mkTest src
        "alpha_inv (a4 corrected)"
        "2(gauss²+d₄)/π+d₃^κ−1/(χ·d₄·Σd²·D)"
        AP.proveAlphaInvCorrected
        AP.pdg_alpha_inv
      -- S5: m_p/m_e with a4 correction
      mpmeCorr = mkTest src
        "m_p/m_e (a4 corrected)"
        "2(D²+Σd)/d₃+gauss^Nc/κ+κ/(N_w·χ·Σd²·D)"
        AP.proveMpMeCorrected
        AP.pdg_mp_me
      -- S6: proton charge radius
      (_, _, rpVal, _) = PR.prove_protonRadius
      rpEntry = mkTest src
        "r_p (proton radius)"
        "(C_F·N_c−T_F/(d₃·Σd))×ℏ/(m_p·c)"
        rpVal
        PR.r_p_muonic
  in [alphaCorr, mpmeCorr, rpEntry]

-- ══════════════════════════════════════════════════════════════════
-- COMBINED CATALOGUE
-- ══════════════════════════════════════════════════════════════════

allTests :: [TestEntry]
allTests = original92 ++ extended86 ++ s4s6entries

-- ══════════════════════════════════════════════════════════════════
-- STATISTICS
-- ══════════════════════════════════════════════════════════════════

-- | Coefficient of variation: std / mean (on nonzero PWI values)
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
-- MAIN
-- ══════════════════════════════════════════════════════════════════

main :: IO ()
main = do
  hSetEncoding stdout utf8

  putStrLn ""
  putStrLn "=================================================================="
  putStrLn "  CRYSTAL TOPOS — FULL 198-OBSERVABLE REGRESSION TEST"
  putStrLn "  A_F = C + M2(C) + M3(C).  Zero free parameters."
  putStrLn "=================================================================="
  putStrLn ""

  -- ── Count verification ──
  let nOrig = length original92
      nExt  = length extended86
      nS46  = length s4s6entries
      nAll  = length allTests

  printf "  Source counts:\n"
  printf "    Original (Main modules):     %d\n" nOrig
  printf "    Extended (scan):             %d\n" nExt
  printf "    S4-S6 (corrected constants): %d\n" nS46
  printf "    ────────────────────────────────\n"
  printf "    TOTAL:                       %d\n" nAll
  putStrLn ""

  -- Flag count mismatches
  let countOK = nOrig == 92 && nExt == 103 && nS46 == 3 && nAll == 198
  if countOK
    then putStrLn "  COUNT CHECK: PASS (92 + 103 + 3 = 198)"
    else do
      putStrLn "  COUNT CHECK: *** FAIL ***"
      if nOrig /= 92  then printf "    Expected 92 original, got %d\n" nOrig   else pure ()
      if nExt  /= 103 then printf "    Expected 103 extended, got %d\n" nExt    else pure ()
      if nS46  /= 3   then printf "    Expected 3 S4-S6, got %d\n"    nS46    else pure ()
      if nAll  /= 198 then printf "    Expected 198 total, got %d\n"   nAll    else pure ()
  putStrLn ""

  -- ── Full table ──
  putStrLn $ printf_pad 4 "#"
          ++ printf_pad 35 "Observable"
          ++ printf_pad 14 "Crystal"
          ++ printf_pad 14 "PDG/Exp"
          ++ printf_pad 10 "PWI(%)"
          ++ printf_pad 10 "Rating"
          ++ printf_pad 40 "Formula"
          ++ "Source"
  putStrLn $ replicate 135 '-'

  let indexed = zip [1::Int ..] allTests
  mapM_ (\(i, e) -> do
    let pass = tePWI e < 4.5
        tag  = if pass then " " else "!"
    printf "%s%3d  %-33s %13.5g %13.5g %9.3f%%  %-8s  %-38s  %s\n"
      tag i (teName e) (teCrystal e) (teExpt e) (tePWI e) (teRating e) (teFormula e) (teSource e)
    ) indexed
  putStrLn $ replicate 135 '-'
  putStrLn ""

  -- ── Statistics ──
  let allPwi   = map tePWI allTests
      nExact   = length (filter (<= 1e-6) allPwi)
      nTight   = length [p | p <- allPwi, p > 1e-6 && p < 0.5]
      nGood    = length [p | p <- allPwi, p >= 0.5 && p < 1.0]
      nLoose   = length [p | p <- allPwi, p >= 1.0 && p < 4.5]
      nOver    = length (filter (>= 4.5) allPwi)
      meanPwi  = computeMean allTests
      cv       = computeCV allTests
      maxPwi   = maximum allPwi
      maxName  = teName $ head $ sortBy (comparing (Down . tePWI)) allTests

  putStrLn "  COMBINED STATISTICS (all sources)"
  putStrLn "  ══════════════════════════════════════════"
  printf   "  Total observables:       %d\n" nAll
  printf   "  EXACT  (PWI = 0):        %d\n" nExact
  printf   "  TIGHT  (PWI < 0.5%%):     %d\n" nTight
  printf   "  GOOD   (0.5%% - 1%%):      %d\n" nGood
  printf   "  LOOSE  (1%% - 4.5%%):      %d\n" nLoose
  printf   "  OVER   (PWI >= 4.5%%):    %d\n" nOver
  putStrLn "  ──────────────────────────────────────────"
  printf   "  Mean PWI (nonzero):      %.4f%%\n" meanPwi
  printf   "  CV (std/mean):           %.4f\n" cv
  printf   "  Maximum PWI:             %.3f%%  (%s)\n" maxPwi maxName
  printf   "  Wall breaches (>=4.5%%):  %d\n" nOver
  putStrLn "  ══════════════════════════════════════════"
  putStrLn ""

  -- ── CV target check ──
  printf "  CV TARGET: %.4f  " cv
  if cv < 1.0
    then putStrLn "(PASS — below 1.0)"
    else if cv < 1.1
      then putStrLn "(CLOSE — between 1.0 and 1.1)"
      else printf "(ABOVE TARGET — current: %.4f, target: < 1.0)\n" cv
  putStrLn ""

  -- ── The five outliers ──
  putStrLn "  TOP 5 OUTLIERS (targets for a4 correction):"
  putStrLn "  ──────────────────────────────────────────"
  let sorted = sortBy (comparing (Down . tePWI)) allTests
      top5   = take 5 sorted
  mapM_ (\e -> printf "    %-35s  PWI = %.3f%%  [%s]\n"
    (teName e) (tePWI e) (teSource e)) top5
  putStrLn ""

  -- ── Per-source breakdown ──
  let cvOrig = computeCV original92
      cvExt  = computeCV extended86
  putStrLn "  PER-SOURCE CV:"
  printf   "    Original (92):   %.4f\n" cvOrig
  printf   "    Extended (103):  %.4f\n" cvExt
  printf   "    Combined (all):  %.4f\n" cv
  putStrLn ""

  -- ── Duplicate name check ──
  putStrLn "  DUPLICATE NAME CHECK (same name in multiple sources):"
  let origNames = map teName original92
      extNames  = map teName extended86
      dupes = [(n, "Original+Extended") | n <- origNames, n' <- extNames, n == n']
  if null dupes
    then putStrLn "    No duplicate names found."
    else do
      putStrLn $ "    Found " ++ show (length dupes) ++ " duplicate name(s):"
      mapM_ (\(n, w) -> printf "      %-35s  (%s)\n" n w) dupes
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
  putStrLn "=================================================================="
  if allPass && countOK
    then putStrLn "  RESULT: ALL 198 OBSERVABLES PASS (under prime wall)"
    else do
      if not countOK then putStrLn "  RESULT: COUNT MISMATCH — see above"
                     else pure ()
      if not allPass then printf "  RESULT: %d OBSERVABLE(S) ABOVE PRIME WALL\n" nOver
                     else pure ()
  putStrLn "=================================================================="
  putStrLn ""

-- ══════════════════════════════════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════════════════════════════════

printf_pad :: Int -> String -> String
printf_pad n s = take (max n (length s)) (s ++ repeat ' ')
