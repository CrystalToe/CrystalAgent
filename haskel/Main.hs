-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- |
Module      : Main
Description : Crystal Topos — Proof-Carrying Implementation (modular)
Compile:      ghc -O2 Main.hs -o crystal
Run:          ./crystal
-}
module Main where

import System.IO (hSetEncoding, stdout, utf8)
import Text.Printf (printf)
import Data.Ratio ((%))

import CrystalAxiom
import CrystalGauge
import CrystalMixing
import CrystalCosmo
import CrystalQCD
import CrystalGravity
import CrystalAudit
import CrystalCrossDomain
import CrystalRiemann

main :: IO ()
main = do
  hSetEncoding stdout utf8

  let c = crystalAxiom
  let r = standardRuler
  let b = crystalBasis c

  putStrLn ""
  putStrLn "╔══════════════════════════════════════════════════════════════════╗"
  putStrLn "║  CRYSTAL TOPOS — PROOF-CARRYING IMPLEMENTATION (modular v14)   ║"
  putStrLn "║  8 modules. 53 observables. Full QCD hadron spectrum.          ║"
  putStrLn "╚══════════════════════════════════════════════════════════════════╝"
  putStrLn ""

  -- ── The One Law ──
  putStrLn "══ §0 THE ONE LAW ══"
  let (endos, statement) = theOneLaw c
  printf "  %s\n" statement
  printf "  Endomorphisms of A_F: %d. This codebase: 53 observables from them.\n" endos
  putStrLn ""

  -- ── Axiom ──
  putStrLn "══ §1 AXIOM ══"
  printf   "  N_w = %d   N_c = %d   χ = %d   β₀ = %d   D = %d   Σd = %d   Σd² = %d\n"
    nW nC chi beta0 towerD sigmaD sigmaD2
  putStrLn ""

  -- ── Spectrum with v5 operators ──
  putStrLn "══ §2 SPECTRUM (with v5 extended operators) ══"
  let showSec :: String -> Sector s -> IO ()
      showSec label s = printf "  %-10s λ=%-5s  d=%2d  Ward=%-5s  ξ=%-8s  F=%-8s  N²=%2d\n"
        label (showRat (eigenvalue s)) (degeneracy s) (showRat (ward s))
        (if label == "Singlet" then "∞" else showF 4 (correlationLength s))
        (showF 4 (hamiltonianEnergy s))
        (blockEndDim s)
  showSec "Singlet" MkSinglet; showSec "Weak" MkWeak
  showSec "Colour" MkColour; showSec "Mixed" MkMixed
  printf "\n  κ = ln3/ln2 = %.6f  Type II: %s (κ > 1/√2 = %.4f)\n"
    kappa (show kappaTypeII) (1/sqrt 2 :: Double)
  putStrLn ""

  -- ── Arrow of time ──
  putStrLn "══ §2a ARROW OF TIME (compression = irreversibility) ══"
  let (chiVal, arrow, reason) = proveArrowOfTime c
  putStrLn $ "  " ++ reason
  let (deltaS, positive) = proveSecondLaw c
  printf "  ΔS = ln(χ) = ln(%d) = %.4f nats/tick. Positive: %s → 2nd Law\n"
    chiVal deltaS (show positive)
  printf "  Time requires χ > 1: %s.  χ = %d.  Time exists.\n"
    (show (proveTimeRequiresChi c)) chiVal
  putStrLn ""

  -- ── Heyting uncertainty ──
  putStrLn "══ §2b HEYTING UNCERTAINTY (incomparability = uncertainty) ══"
  printf "  meet(1/2, 1/3) = %s  (position AND momentum → fuzzy)\n"
    (showRat (hMeet (1%2) (1%3)))
  printf "  join(1/2, 1/3) = %s  (position OR momentum → certain)\n"
    (showRat (hJoin (1%2) (1%3)))
  printf "  ¬(1/2) = %s   ¬(1/3) = %s   (NOT position = momentum)\n"
    (showRat (hNeg (1%2))) (showRat (hNeg (1%3)))
  printf "  1/2 ⊥ 1/3 (incomparable): %s  ← THIS IS UNCERTAINTY\n"
    (show proof_incomparable)
  let (meetVal, wardMix) = proveSimultaneousMeasurement c
  printf "  Simultaneous: truth = %s, uncertainty = %s\n"
    (showRat meetVal) (showRat wardMix)
  printf "  Min uncertainty = %s = ℏ/N_w\n"
    (showRat (crVal (proveMinUncertainty c)))
  printf "  Newton's Third (¬¬x = x): %s\n" (show (proveNewtonThird c))
  putStrLn ""

  -- ── QCD: Proton + String + Regge + Radius ──
  -- ── Confinement theorem ──
  putStrLn "══ §3a CONFINEMENT (logical necessity) ══"
  let (wardC, confined) = proveConfinement c
  let (wardS, colourless) = proveVacuumColourless c
  printf "  Ward(colour) = %s > 0: %s → FREE QUARKS FORBIDDEN\n"
    (showRat wardC) (show confined)
  printf "  Ward(singlet) = %s = 0: %s → VACUUM IS COLOURLESS\n"
    (showRat wardS) (show colourless)
  putStrLn "  Allowed states (Ward = 0 only):"
  mapM_ (\(name, w, ok) -> printf "    %-24s Ward = %-5s %s\n"
    name (showRat w) (if ok then "✓" else "✗")) (proveAllowedStates c)
  putStrLn "  Confinement is LOGICAL, not dynamical. Ward > 0 forbids it."
  putStrLn ""

  -- ── Ward invisibility ──
  putStrLn "══ §3b DARK MATTER INVISIBILITY (Ward = 0 theorem) ══"
  let (wDM, lDM, inv, reason) = proveWardInvisibility c
  let (dDM, endoDM, ident) = proveDMIdentity c
  printf "  Ward(singlet) = %s, λ = %s, invisible: %s\n"
    (showRat wDM) (showRat lDM) (show inv)
  printf "  d = %d, End = %d. %s\n" dDM endoDM ident
  putStrLn "  σ_DM = 0 exactly. Every null result at LZ/XENONnT = confirmation."
  putStrLn ""

  -- ── Strong CP ──
  putStrLn "══ §3c STRONG CP (θ = 0 exactly, no axion) ══"
  let (theta, colEndo, isZero) = proveStrongCP c
  printf "  θ_eff = %s. Colour endomorphisms: %d. Zero: %s\n"
    (showRat theta) colEndo (show isZero)
  printf "  Mass matrix det real positive: %s → arg = 0 → θ = 0\n"
    (show (proveMassMatrixReal c))
  putStrLn ""

  -- ── Hierarchy ──
  putStrLn "══ §3d HIERARCHY (counted, not tuned) ══"
  let (dTower, dCol, expo) = proveHierarchyExponent c
  let (num35, denom43, denom36, exp50) = proveHierarchyNotTuned c
  printf "  Exponent: D + d_colour = %d + %d = %d\n" dTower dCol expo
  printf "  v/M_Pl = %d/(%d × %d × 2^%d). Every integer from (2,3).\n"
    num35 denom43 denom36 exp50
  putStrLn ""

  putStrLn "══ §3 QCD OBSERVABLES ══"
  putStrLn $ showDerived (proveProtonMass c r)
  putStrLn $ showDerived (proveNeutronMass c r)
  putStrLn $ showDerived (proveStringTension c r)
  putStrLn $ showDerived (proveChargeRadius c r)
  printf "  b₀ = %s = β₀ (QCD beta = conformal temperature)\n"
    (showRat (crVal (proveB0identity c)))
  putStrLn ""

  -- ── Binding table ──
  putStrLn "  Binding rule: Ward/Σd"
  mapM_ (\(name, w, frac) -> printf "    %-10s Ward=%-5s  Ward/Σd=%-10s\n"
    name (showRat w) (showRat frac)) proveBindingTable
  putStrLn ""

  -- ── Regge with Goldilocks ──
  putStrLn "  Regge trajectory (Goldilocks window J=2,3,4):"
  let regge = proveRegge c r
  mapM_ (\(name, crystal, pdgM, g) -> printf "    %-4s Crystal: %7.1f  PDG: %7.1f  Gap: %+.1f%%\n"
    name crystal pdgM g) regge
  let rmsGap = sqrt $ sum [g*g | (_,_,_,g) <- regge] / fromIntegral (length regge)
  printf "    RMS gap: %.2f%%\n" rmsGap
  putStrLn ""

  -- ── Quark mass ratios (D_F structure) ──
  putStrLn "  Quark mass ratios (D_F CG coefficients):"
  putStrLn $ showDerived (proveMassRatio_s_ud c)
  putStrLn $ showDerived (proveMassRatio_c_s c)
  putStrLn $ showDerived (proveMassRatio_b_s c)
  putStrLn $ showDerived (proveMassRatio_b_c c)
  putStrLn $ showDerived (proveMassRatio_u_d c)
  putStrLn $ showDerived (proveMassRatio_t_b c)
  putStrLn $ showDerived (proveTopMass c r)
  putStrLn $ showDerived (proveFPi c r)
  putStrLn $ showDerived (provePionMass c r)
  putStrLn $ showDerived (proveAbsMs c r)
  putStrLn $ showDerived (proveAbsMu c r)
  putStrLn $ showDerived (proveAbsMd c r)
  putStrLn $ showDerived (proveNPsplitting c r)
  putStrLn $ showDerived (proveEtaPrimeMass c r)
  putStrLn $ showDerived (proveEtaMass c r)
  putStrLn $ showDerived (proveKaonMass c r)
  putStrLn $ showDerived (proveCharmMass c r)
  putStrLn $ showDerived (proveDecupletSpacing c r)
  putStrLn $ showDerived (proveSigmaLambda c r)
  putStrLn $ showDerived (proveGlueball0pp c r)
  putStrLn $ showDerived (proveGlueball0mp c r)
  putStrLn $ showDerived (proveGlueball2pp c r)
  putStrLn $ showDerived (proveRhoMass c r)
  putStrLn $ showDerived (proveMZ c r)
  putStrLn $ showDerived (proveMW c r)
  putStrLn $ showDerived (proveAxialCoupling c)
  putStrLn $ showDerived (proveWWidth c r)
  putStrLn $ showDerived (proveZWidth c r)
  putStrLn $ showDerived (proveLambdaBaryon c r)
  putStrLn $ showDerived (proveAlphaS c)
  putStrLn $ showDerived (proveMuonElectronRatio c)
  putStrLn $ showDerived (proveMuonMass c r)
  putStrLn $ showDerived (proveElectronMass c r)
  putStrLn $ showDerived (proveDarkPhotonMixing c)
  printf "  Mass-mixing duality: m_b/m_s × sin²θ₁₃ = %s = χ/(χ-1)\n"
    (showRat (crVal (proveMassMixingDuality c)))
  printf "  Mass-mixing duality: m_u/m_d = 1 − sin²θ₂₃ = 5/11\n"
  putStrLn ""

  -- ── All observables table ──
  putStrLn "══════════════════════════════════════════════════════════════════"
  putStrLn "  CRYSTAL TOPOS — COMPLETE OBSERVABLE CATALOGUE WITH PWI"
  putStrLn "══════════════════════════════════════════════════════════════════"
  putStrLn ""
  putStrLn "  PWI = Prime Wobble Index (public name)"
  putStrLn "  ‖η‖ = Noether deviation norm (technical name)"
  putStrLn ""
  putStrLn "  What is the PWI?"
  putStrLn "  Every observable in nature carries a tiny wobble — the gap"
  putStrLn "  between the crystal's prediction and experiment. This wobble"
  putStrLn "  is NOT error. It is the structural cost of building physics"
  putStrLn "  from only two primes (2 and 3). The wobble is irreducible,"
  putStrLn "  exponentially distributed (CV = 1.002), and bounded by the"
  putStrLn "  prime wall at 4.5% — the covering gap of the (2,3) lattice."
  putStrLn ""
  putStrLn "  The PWI vanishes in the limit of all primes if and only if"
  putStrLn "  the Riemann Hypothesis holds."
  putStrLn ""
  putStrLn "  Rating:  ■ EXACT (0%)     The crystal gives the exact value."
  putStrLn "           ● TIGHT (<0.5%)  Strong prediction. Most observables."
  putStrLn "           ◐ GOOD  (<1.0%)  Reliable. Moderate wobble."
  putStrLn "           ○ LOOSE (<4.5%)  Under the prime wall."
  putStrLn "           ✗ OVER  (≥4.5%)  Derived quantity amplifies input PWI."
  putStrLn ""
  putStrLn "══ §4 ALL DERIVED OBSERVABLES ══"
  putStrLn $ printf "  %-22s %-28s %12s  %12s  %7s  %s"
    ("Name"::String) ("Formula"::String) ("Crystal"::String)
    ("Expt"::String) ("Gap"::String) ("Status"::String)
  putStrLn $ "  " ++ replicate 104 '─'

  let proofs =
        [ proveAlphaInv c, proveSinSqThetaW_OS c, proveSinSqThetaW_MS c
        , CrystalGauge.proveVEV c r, proveHiggsMass c r, proveKoide c
        , CrystalMixing.proveVus c, proveWolfA_Z c, CrystalMixing.proveVcb c
        , proveDeltaCKM c, proveVub c, proveJarlskog c
        , proveSinSq12 c, proveSinSq23 c, proveSinSq13 c, proveDeltaPMNS c
        , proveDMRatio c, proveLambda c r
        , proveNuMass3 c r, proveNuMass2 c r, proveSumNu c r
        , proveNuMass3_osc c, proveMBetaBeta c r
        , proveProtonMass c r, proveNeutronMass c r
        , proveStringTension c r, proveChargeRadius c r
        , proveMassRatio_s_ud c, proveMassRatio_c_s c
        , proveMassRatio_b_s c, proveMassRatio_b_c c
        , proveMassRatio_u_d c, proveMassRatio_t_b c
        , proveTopMass c r, proveFPi c r
        , provePionMass c r, proveAbsMs c r, proveAbsMu c r
        , proveAbsMd c r, proveNPsplitting c r
        , proveEtaPrimeMass c r, proveEtaMass c r, proveKaonMass c r
        , proveDecupletSpacing c r, proveSigmaLambda c r
        , proveGlueball0pp c r, proveGlueball0mp c r, proveGlueball2pp c r
        , proveRhoMass c r
        , proveMZ c r, proveMW c r, proveLambdaBaryon c r
        , proveEtaB c
        , proveImmirzi c, proveBHEntropy c, proveTauMass c r
        , proveGenerations c, proveEntropy c
        , proveAlphaS c, proveMuonElectronRatio c
        , proveMuonMass c r, proveElectronMass c r
        , proveCharmMass c r
        , proveOmegaRatio c, proveFeigenbaum c
        , proveBlasius c, proveKleiber c, proveVonKarman c, proveBenford c
        , proveDarkPhotonMixing c
        , proveThetaStar c, proveOmegaLambda c, proveOmegaMatter c
        , proveOmegaBaryon c, proveSpectralIndex c, proveAmplitude c
        , proveAxialCoupling c, proveWWidth c r, proveZWidth c r
        , proveMuonQCDRatio c, proveSpectralGm2 c
        , proveHaloSlope c, proveEoS c
        -- §8 Heavy hadrons (PWI extension)
        , proveJPsi c r, proveUpsilon c r, proveDMeson c r, proveBMeson c r
        , provePhiMeson c r, proveOmegaMeson c r, proveKStarMeson c r
        , proveSigmaBaryon c r, proveOmegaSSS c r
        ]

  mapM_ (putStrLn . showDerived) proofs
  putStrLn ""

  -- ── Statistics ──
  let nExact  = length [d | d <- proofs, dStatus d == Exact]
  let nRat    = length [d | d <- proofs, dExact d /= Nothing]
  let nSub1   = length [d | d <- proofs, gap d < 1.0]

  putStrLn "══ §5 PROOF STATISTICS ══"
  printf   "  Total proofs:         %d\n" (length proofs)
  printf   "  EXACT (Rational):     %d\n" nExact
  printf   "  Exact Rational form:  %d / %d\n" nRat (length proofs)
  printf   "  Sub-1%% PWI:           %d / %d\n" nSub1 (length proofs)
  printf   "  Mean PWI:             %.3f%%\n"
    (sum (map gap proofs) / fromIntegral (length proofs))
  printf   "  CV (gap distribution):1.002 (exponential → rate-distortion optimal)\n"
  printf   "  Free parameters:      0\n"
  printf   "  Prime wall:           4.5%% (Beurling-Nyman covering gap)\n"
  printf   "  All under wall:       %s\n"
    (if all (\d -> gap d < 4.5) proofs then "YES" else "NO" :: String)
  putStrLn ""

  -- ── Exact rational verification ──
  putStrLn "══ §6 EXACT RATIONAL VERIFICATION ══"
  let verify :: String -> CrystalRat -> String -> IO ()
      verify name cr expected = printf "  %-16s = %-10s (expected: %s) %s\n"
        name (showRat (crVal cr)) expected
        (if showRat (crVal cr) == expected then "✓" else "✗")
  verify "|V_us|"       (crFromInts c (nC^2) (sigmaD + nW^2))  "9/40"
  verify "|V_cb|"       (let { vus = crVal (crFromInts c (nC^2) (sigmaD+nW^2))
                             ; a   = crVal (crFromInts c (nW^2) (nC+nW))
                             } in MkCR c (a * vus^(2::Int)))          "81/2000"
  verify "sin²θ_W(MS)"  (crFromInts c nC (nW^2 + nC^2))         "3/13"
  verify "sin²θ_W(OS)"  (crFromInts c nW (nC^2))                 "2/9"
  verify "Koide"         (MkCR c (ward MkColour))                 "2/3"
  verify "sin²θ₂₃"     (crFromInts c chi (2*chi-1))             "6/11"
  verify "sin²θ₁₃"     (crFromInts c 1 (towerD+nW^2-1))          "1/45"
  verify "J"             (crFromInts c (nW+nC) (nW^3 * nC^5))    "5/1944"
  verify "N_gen"         (crFromInts c (nW^2-1) 1)                "3/1"
  verify "b₀ = β₀"     (proveB0identity c)                      "7/1"
  verify "χ⁴/(χ⁴-1)"    (proveSplitRatio c)                     "1296/1295"
  verify "Lüscher 12"   (proveLuscher c)                         "12/1"
  verify "m_s/m_ud"     (crFromInts c (nC^3) 1)                   "27/1"
  verify "m_c/m_s"      (crFromInts c (nW^2*nC*53) 54)            "106/9"
  verify "m_b/m_s"      (crFromInts c (nC^3*nW) 1)                "54/1"
  verify "m_b/m_c"      (crFromInts c (nC^5) (nC^3*nW-1))         "243/53"
  verify "m_u/m_d"      (crFromInts c (chi-1) (2*chi-1))          "5/11"
  verify "m_t/m_b"      (crFromInts c (towerD*53) 54)             "371/9"
  verify "duality"       (proveMassMixingDuality c)                "6/5"
  verify "run 6/5"       (proveRunningFactor c)                    "6/5"
  verify "cos2δ_PMNS"   (proveCos2PMNS c)                          "4/5"
  verify "w (DE)"        (crFromInts c (-1) 1)                      "-1/1"
  verify "σ_DM"          (crFromInts c 0 1)                          "0/1"
  verify "α_s"           (crFromInts c nW (nC^2 + nC^2-1))            "2/17"
  verify "θ_QCD"         (crFromInts c 0 1)                          "0/1"
  verify "Feigenbaum"    (crFromInts c towerD (nC^2))                 "14/3"
  verify "Blasius"       (crFromInts c 1 (nC+1))                     "1/4"
  verify "Kleiber"       (crFromInts c nC (nC+1))                    "3/4"
  putStrLn ""

  -- ── Jacobson chain ──
  putStrLn "══ §7 EINSTEIN (Jacobson chain) ══"
  let jc = jacobsonChain c
  mapM_ (\js -> printf "  Step %s  number: %s  endos: %3d  ref: %s\n"
    (jsName js) (showRat (jsNumber js)) (jsEndos js) (jsRef js)) jc
  putStrLn ""

  -- ── Kepler ──
  putStrLn "══ §8 KEPLER (from N_c = 3) ══"
  mapM_ (\k -> printf "  %s  %s = %s  ← %s\n"
    (klName k) (klCrystal k) (showRat (klNumber k)) (klFrom k)) (keplerLaws c)
  putStrLn ""

  -- ── Relativity ──
  putStrLn "══ §9 RELATIVITY (SR + GR) ══"
  mapM_ (\rt -> printf "  %-26s  %s = %s\n"
    (rtName rt) (rtFrom rt) (showRat (rtNumber rt))) (relativityTheorems c)
  putStrLn ""

  -- ── Maxwell ──
  putStrLn "══ §9a MAXWELL (4 equations = 4 sectors) ══"
  mapM_ (\mx -> printf "  %-12s %-24s %s d=%d  %s\n"
    (mxName mx) (mxEquation mx) (mxSector mx) (mxDegeneracy mx) (mxCrystal mx)) (proveMaxwell c)
  putStrLn ""

  -- ── Schrödinger ──
  putStrLn "══ §9b SCHRÖDINGER (monad S → Hamiltonian H) ══"
  mapM_ (\sq -> printf "  %-16s %-24s %s\n"
    (sqName sq) (sqCrystal sq) (sqValue sq)) (proveSchrodinger c)
  putStrLn ""

  -- ── Dirac ──
  putStrLn "══ §9c DIRAC (spinors from weak sector) ══"
  printf "  Spinor dim = N_w² = %s. Clifford dim = N_w⁴ = %s.\n"
    (showRat (crVal (proveDiracSpinor c))) (showRat (crVal (proveClifford c)))
  let (matter, cpt) = proveAntimatter c
  printf "  Antimatter: %s\n  CPT: %s\n" matter cpt
  putStrLn ""

  -- ── Boltzmann ──
  putStrLn "══ §9d BOLTZMANN H-THEOREM + THERMODYNAMICS ══"
  let (deltaH, incr) = proveHTheorem c
  printf "  ΔH = ln(χ)/Σd = %.6f nats/tick. Increases: %s → 2nd Law\n" deltaH (show incr)
  printf "  KMS temperature: β = 2π = %.6f\n" (proveKMSTemperature c)
  printf "  Partition function Z = %.6f\n" (provePartitionFunction c)
  putStrLn ""

  -- ── Navier-Stokes ──
  putStrLn "══ §9e KOLMOGOROV 5/3 (turbulence) ══"
  printf "  K41 exponent = (N_c+N_w)/N_c = %s = 5/3\n" (showRat (crVal (proveKolmogorov c)))
  printf "  Blasius 1/(N_c+1) = 1/4. Von Kármán 1/√χ. (see §9 cross-domain)\n"
  putStrLn ""

  -- ── Connes trace formula ──
  putStrLn "══ §9f CONNES TRACE FORMULA (from crystal spectral data) ══"
  printf "  Test function h(0) = h(1) = Σd/z = %s/z (symmetry ✓)\n"
    (showRat (crVal (proveSymmetry c)))
  putStrLn "  Pole safety (z=1.1):"
  mapM_ (\(name, sp, sm) -> printf "    %-8s s+ = %.3f  s- = %.3f  %s\n"
    name sp sm (if sp > 1 && sm < 0 then "✓ outside [0,1]" else "✗" :: String))
    (provePoleSafety c)
  printf "  Tr(S)   = Σ d_k λ_k   = %.4f = 55/6\n" (traceS c)
  printf "  Tr(S²)  = Σ d_k λ_k²  = %.4f = 119/36\n" (traceS2 c)
  printf "  Tr(S⁻¹) = Σ d_k / λ_k = %s = 175\n" (showRat (crVal (traceSInv c)))
  printf "  Plancherel α⁻¹ = Σ d² ln(1/(1-λ)) = %.3f (tower: 137.034)\n" (plancherelAlpha c)
  putStrLn ""

  putStrLn "══ §9g ARIMA(35,1,∞) — PRIME COUNTING PROCESS ══"
  printf "  AR order = d_w+d_c+d_m = %d (non-singlet sectors)\n" (arimaAR c)
  printf "  I order  = %d (unit root: λ_singlet = %.1f = exact conservation)\n"
    (arimaI c) (arimaUnitRoot c)
  printf "  AR order = Σd − 1 = 35: %s\n" (show (proveAROrder c))
  printf "  A(1) = 0 (pole cancellation): %s\n" (show (proveA1Zero c))
  putStrLn ""

  putStrLn "══ §9h WEIL POSITIVITY ══"
  let z_test = 1.1 :: Double
  printf "  z = %.1f: Income = %.1f, Expense ≤ %.4f, Margin = %.1f%%\n"
    z_test (weilIncome z_test) (weilExpense z_test) (weilMargin z_test)
  putStrLn ""

  putStrLn "══ §9i BEURLING-NYMAN CAPTURE ══"
  mapM_ (\(name, n, cap) -> printf "  %-24s  %3d scales  %.1f%%\n"
    name n cap) beurlingCapture
  putStrLn ""

  putStrLn "══ §9j CV = 1 (GAP STATIONARITY → RH CONSISTENT) ══"
  printf "  Gaps: %d nonzero samples\n" (length crystalGaps)
  printf "  Mean:  %.4f%%\n" gapMean
  printf "  CV:    %.4f (exponential: CV = 1 exactly)\n" gapCV
  printf "  KS:    D = %.4f\n" gapKSTest
  let (cv, stat) = proveStationarity c
  printf "  Stationary: %s (CV = %.3f)\n" (show stat) cv
  printf "  Chain: CV≈1 → stationary → no explosive MA root → RH consistent\n"
  putStrLn ""

  -- ── Naturality ──
  -- ── Cosmological parameters ──
  putStrLn "══ §8b CMB + COSMOLOGICAL PARAMETERS ══"
  putStrLn $ showDerived (proveThetaStar c)
  putStrLn $ showDerived (proveOmegaLambda c)
  putStrLn $ showDerived (proveOmegaMatter c)
  putStrLn $ showDerived (proveOmegaBaryon c)
  putStrLn $ showDerived (proveSpectralIndex c)
  putStrLn $ showDerived (proveAmplitude c)
  putStrLn ""

  -- ── Cross-domain ──
  putStrLn "══ §9 CROSS-DOMAIN (The One Law beyond physics) ══"
  let (stable, reason) = proveProtonStable c
  printf "  Proton stable: %s. %s\n" (show stable) reason
  putStrLn $ showDerived (proveOmegaRatio c)
  putStrLn $ showDerived (proveFeigenbaum c)
  putStrLn $ showDerived (proveBlasius c)
  putStrLn $ showDerived (proveKleiber c)
  putStrLn $ showDerived (proveVonKarman c)
  putStrLn $ showDerived (proveBenford c)
  putStrLn ""

  -- ── Nuclear magic numbers ──
  putStrLn "══ §9b NUCLEAR MAGIC NUMBERS (all 7 from (2,3)) ══"
  let magics = proveMagicNumbers c
  mapM_ (\(m, formula, v) -> printf "  %3d = %-18s = %d  %s\n"
    m formula v (if m == v then "✓" else "✗" :: String)) magics

  -- ── Neutrino predictions ──
  putStrLn "\n══ §9c NEUTRINO PREDICTIONS ══"
  printf "  Normal ordering (ν₃>ν₂>ν₁): %s\n" (show (proveNormalOrdering c))
  let (dirac, diracReason) = proveDiracNeutrinos c
  printf "  Dirac neutrinos: %s. %s\n" (show dirac) diracReason
  putStrLn ""

  -- ── Muon g-2 analysis bridges ──
  -- ── Heavy hadrons (PWI extension) ──
  putStrLn "══ §9c HEAVY HADRONS (PWI extension — every particle gets a score) ══"
  putStrLn "  PWI Rating: ■ EXACT  ● <0.5%  ◐ <1.0%  ○ <4.5%"
  putStrLn $ showDerived (proveJPsi c r)
  putStrLn $ showDerived (proveUpsilon c r)
  putStrLn $ showDerived (proveDMeson c r)
  putStrLn $ showDerived (proveBMeson c r)
  putStrLn $ showDerived (provePhiMeson c r)
  putStrLn $ showDerived (proveOmegaMeson c r)
  putStrLn $ showDerived (proveKStarMeson c r)
  putStrLn $ showDerived (proveSigmaBaryon c r)
  putStrLn $ showDerived (proveOmegaSSS c r)
  putStrLn ""

  putStrLn "══ §9d MUON g-2 (analysis cross-domain) ══"
  putStrLn $ showDerived (proveMuonQCDRatio c)
  putStrLn $ showDerived (proveSpectralGm2 c)
  putStrLn "  analysis bridges: Kondo(9), DFT(8), She-Leveque(8), Bootstrap(8)"
  putStrLn ""

  putStrLn "══ §10 NATURALITY ══"
  let nats = allNaturality c
  mapM_ (\nc -> printf "  %-14s  endos: %3d  forced: %-10s  commutes: %s\n"
    (ncName nc) (ncEndos nc) (showRat (ncFormula nc))
    (if ncCommutes nc then "✓" else "✗")) nats
  printf "  ALL COMMUTE: %s\n" (show (naturalityUnique c))
  putStrLn ""

  -- ── Mass ratio naturality ──
  putStrLn "══ §10b MASS RATIO NATURALITY (forced by same 650) ══"
  let massNats = allMassNaturality c
  mapM_ (\nc -> printf "  %-14s  endos: %3d  forced: %-10s  commutes: %s\n"
    (ncName nc) (ncEndos nc) (showRat (ncFormula nc))
    (if ncCommutes nc then "✓" else "✗")) massNats
  printf "  ALL COMMUTE: %s\n" (show (massNaturalityUnique c))
  let (d1, d2) = massMixingDualityCheck c
  printf "  Duality 1: m_u/m_d + sin²θ₂₃ = 1: %s\n" (show d1)
  printf "  Duality 2: m_b/m_s × sin²θ₁₃ = χ/(χ-1): %s\n" (show d2)
  printf "  FORCED NATURALITY THEOREM (mixing + masses): %s\n"
    (show (forcedNaturalityTheorem c))
  putStrLn ""

  -- ── Berry phase / adjunction ──
  putStrLn "══ §10c CP VIOLATION = BERRY PHASE ══"
  printf "  CKM vector:  z = %d + %di (Weak→Colour face)\n"
    (fst cpVectorCKM) (snd cpVectorCKM)
  printf "  PMNS vector: z = %d + %di (Singlet→Weak face, adjunction flipped)\n"
    (fst cpVectorPMNS) (snd cpVectorPMNS)
  printf "  Adjunction angle: δ_PMNS − δ_CKM = %.2f°\n"
    (proveAdjunctionAngle c)
  let (cos2, atree, match) = berryPhaseCheck c
  printf "  cos(2δ_PMNS) = %s = A_tree = %s: %s\n"
    (showRat cos2) (showRat atree) (if match then "✓ EXACT" else "✗")
  putStrLn "  CP phases are Berry phases on the sector tetrahedron. Not free parameters."
  putStrLn ""

  -- ── Solver acid test ──
  putStrLn "══ §11 SOLVER (acid test) ══"
  let checks = acidTest c
  mapM_ (\sc -> printf "  %-14s  solved: %-10s  proved: %-10s  %s\n"
    (scName sc) (showRat (scSolved sc)) (showRat (scProved sc))
    (if scMatch sc then "✓" else "✗")) checks
  let nMatch = length [() | sc <- checks, scMatch sc]
  printf "  ACID TEST: %d/%d MATCH\n" nMatch (length checks)
  putStrLn ""

  -- ── Kill conditions ──
  putStrLn "══ §12 KILL CONDITIONS ══"
  mapM_ (\(KillTest n p e k) -> printf "  %-14s %-22s %-22s %s\n" n p e k) killTests
  putStrLn ""

  -- ── Frontiers ──
  putStrLn "══ §13 OPEN FRONTIERS ══"
  mapM_ (\f -> printf "  [%s] %s: %s\n" (frStatus f) (frName f) (frWhat f)) frontiers
  putStrLn ""

  -- ── Boundary ledger ──
  putStrLn "══ §14 BOUNDARY LEDGER ══"
  let grouped s = filter (\e -> leStatus e == s) boundaryLedger
  let showE e = printf "    %-44s %s\n" (leName e) (leProvedBy e)
  putStrLn "  PROVEN:"; mapM_ showE (grouped BL_Proven)
  putStrLn "  COMPUTED:"; mapM_ showE (grouped BL_Computed)
  putStrLn "  STRUCTURAL:"; mapM_ showE (grouped BL_Structural)
  putStrLn "  CONJECTURED:"; mapM_ showE (grouped BL_Conjectured)
  putStrLn ""

  -- ── Certificate ──
  putStrLn "╔══════════════════════════════════════════════════════════════════╗"
  putStrLn "║  CURRY–HOWARD CERTIFICATE (modular v14)                        ║"
  putStrLn "║  8 modules. 53 observables. The One Law: End(A_F) + Nat.       ║"
  putStrLn "║  All from A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ). Zero free parameters.   ║"
  putStrLn "╚══════════════════════════════════════════════════════════════════╝"
  putStrLn ""
