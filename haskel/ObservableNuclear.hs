-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableNuclear.hs — Component 7 (Nuclear)

  Magic numbers, binding energies, magnetic moments, SEMF exponents,
  iron peak, neutron lifetime. Uses WACAScan m_e = Lambda_h/1872
  for binding energy formulas (dimensionful observables).

  Rule: corrections apply to the SPECIFIC observable they were derived
  for. Binding energies use the WACAScan m_e formula because the
  deuteron/alpha formulas were designed with that m_e.

  Compile: ghc -O2 -main-is ObservableNuclear ObservableNuclear.hs && ./ObservableNuclear
-}

module ObservableNuclear (allNuclear, main) where

import CrystalAtoms hiding (main)
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE (same pattern)
-- =====================================================================

-- | m_e for nuclear binding formulas (WACAScan formula, NOT muon chain)
-- m_e = Lambda_h / (N_c^2 * N_w^4 * gauss) = v / (F3 * 1872)
-- The deuteron/alpha formulas were designed with THIS m_e.
meNuclear :: Double -> Double
meNuclear v = v * 1000.0 / fermat3_d
            / (nC_d * nC_d * nW_d ** 4 * gauss_d)

-- =====================================================================
-- MAGIC NUMBERS (dimensionless, Level 0)
-- All 7 from (2,3). Zero free parameters.
-- =====================================================================

obsMagic2 :: Obs
obsMagic2 = mk "Magic 2" "N_w = 2"
  (\_ -> nW_d) 2.0 ExactInteger

obsMagic8 :: Obs
obsMagic8 = mk "Magic 8" "d_col = N_c^2-1 = 8"
  (\_ -> d3_d) 8.0 ExactInteger

obsMagic20 :: Obs
obsMagic20 = mk "Magic 20" "gauss+b0 = 13+7 = 20"
  (\_ -> gauss_d + beta0_d) 20.0 ExactInteger

obsMagic28 :: Obs
obsMagic28 = mk "Magic 28" "N_w^2*b0 = 4*7 = 28"
  (\_ -> nW_d * nW_d * beta0_d) 28.0 ExactInteger

obsMagic50 :: Obs
obsMagic50 = mk "Magic 50" "D+d_col = 42+8 = 50"
  (\_ -> towerD_d + d3_d) 50.0 ExactInteger

obsMagic82 :: Obs
obsMagic82 = mk "Magic 82" "N_w*(D-1) = 2*41 = 82"
  (\_ -> nW_d * (towerD_d - 1.0)) 82.0 ExactInteger

obsMagic126 :: Obs
obsMagic126 = mk "Magic 126" "N_w*b0*N_c^2 = 2*7*9"
  (\_ -> nW_d * beta0_d * nC_d * nC_d) 126.0 ExactInteger

-- =====================================================================
-- MAGNETIC MOMENTS (dimensionless)
-- =====================================================================

-- | mu_p/mu_N = N_w * beta0/(chi-1) = 14/5 = 2.800
obsMuP :: Obs
obsMuP = mk "mu_p/mu_N" "Nw*b0/(chi-1) = 14/5"
  (\_ -> nW_d * beta0_d / (chi_d - 1.0))
  2.7928 ExactRational

-- | mu_n/mu_N = N_w - N_w^3/(gauss*beta0) = 174/91
obsMuN :: Obs
obsMuN = mk "mu_n/mu_N" "Nw-Nw^3/(gauss*b0) = 174/91"
  (\_ -> nW_d - nW_d ** 3 / (gauss_d * beta0_d))
  1.9130 ExactRational

-- =====================================================================
-- BINDING ENERGIES (dimensionful, use m_e = Lambda_h/1872)
-- =====================================================================

-- | Deuteron BE = m_e * gauss/N_c = m_e * 13/3
obsDeuteronBE :: Obs
obsDeuteronBE = mk "Deuteron BE (MeV)" "m_e*gauss/Nc = m_e*13/3"
  (\v -> meNuclear v * gauss_d / nC_d)
  2.2246 ExactRational

-- | Alpha BE = m_e * (D + gauss + N_c/beta0)
obsAlphaBE :: Obs
obsAlphaBE = mk "4He BE (MeV)" "m_e*(D+gauss+Nc/b0)"
  (\v -> meNuclear v * (towerD_d + gauss_d + nC_d / beta0_d))
  28.296 ExactRational

-- | R_p proton radius = (N_w^2 + N_w/(gauss*beta0)) * hbar_c / m_proton
-- hbar_c = 197.327 MeV·fm (fixed constant)
-- m_proton = v/2^8 * 53/54 (dimensionful, from VEV)
obsProtonRadius :: Obs
obsProtonRadius = mk "R_p (fm)" "(Nw^2+Nw/(g*b0))*hc/mp"
  (\v -> let hbarc = 197.327
             mp    = v * 1000.0 / 256.0 * 53.0 / 54.0
         in (nW_d * nW_d + nW_d / (gauss_d * beta0_d)) * hbarc / mp)
  0.8409 ExactRational

-- =====================================================================
-- NEUTRON LIFETIME (dimensionless formula, result in seconds)
-- =====================================================================

-- | tau_n = D^2/N_w - N_w^2 = 1764/2 - 4 = 878 seconds
obsNeutronLife :: Obs
obsNeutronLife = mk "tau_n (s)" "D^2/Nw - Nw^2 = 878"
  (\_ -> towerD_d * towerD_d / nW_d - nW_d * nW_d)
  878.4 ExactRational

-- =====================================================================
-- IRON PEAK + SEMF EXPONENTS (dimensionless, Level 0-1)
-- =====================================================================

-- | Iron peak: A = 56 = d_colour * beta0 = 8 * 7
obsIronPeak :: Obs
obsIronPeak = mk "Fe-56 (A)" "d_col*b0 = 8*7 = 56"
  (\_ -> d3_d * beta0_d) 56.0 ExactInteger

-- | SEMF surface exponent = N_w/N_c = 2/3
obsSEMFSurface :: Obs
obsSEMFSurface = mk "SEMF surf exp" "N_w/N_c = 2/3"
  (\_ -> nW_d / nC_d) (2.0/3.0) ExactRational

-- | SEMF Coulomb exponent = 1/N_c = 1/3
obsSEMFCoulomb :: Obs
obsSEMFCoulomb = mk "SEMF Coul exp" "1/N_c = 1/3"
  (\_ -> 1.0 / nC_d) (1.0/3.0) ExactRational

-- | SEMF Coulomb prefactor = N_c/(chi-1) = 3/5
obsSEMFCoulPre :: Obs
obsSEMFCoulPre = mk "SEMF Coul pre" "N_c/(chi-1) = 3/5"
  (\_ -> nC_d / (chi_d - 1.0)) (3.0/5.0) ExactRational

-- | SEMF pairing exponent = 1/N_w = 1/2
obsSEMFPairing :: Obs
obsSEMFPairing = mk "SEMF pair exp" "1/N_w = 1/2"
  (\_ -> 1.0 / nW_d) (1.0/2.0) ExactRational

-- =====================================================================
-- SEMF COEFFICIENTS (dimensionful, MeV) -- derived d_52, all five
--
-- Pattern: a_x = m_e_nuclear * (rectangle ratio)
-- All five have empirical match within 0.5%, structural reading clean,
-- mechanically verified in CrystalUnifiedDGP.{hs, lean, agda}.
-- =====================================================================

-- | a_v = m_e * chi*Sigma_d/beta0 = m_e * 6*36/7 = m_e * 216/7
-- Volume coefficient. Bulk binding per nucleon. Predicted: 15.79 MeV (0.05% off).
-- Reading: (rectangle area * sectors) / (running coefficient)
obsSEMFVolume_coeff :: Obs
obsSEMFVolume_coeff = mk "a_v (MeV)" "m_e*chi*Sd/b0 = m_e*216/7"
  (\v -> meNuclear v * chi_d * sigmaD_d / beta0_d)
  15.8 ExactRational

-- | a_s = m_e * 11 * gauss / N_w^2 = m_e * 143/4
-- Surface coefficient. Boundary penalty per surface nucleon. Predicted: 18.30 MeV (0.02% off).
-- 11 in H, gauss = N_w^2 + N_c^2, denominator = squared spin width.
-- Equivalent: gauss * (D+gauss) / (gauss+beta0); denom gauss+b0 = M(3) = 20.
obsSEMFSurface_coeff :: Obs
obsSEMFSurface_coeff = mk "a_s (MeV)" "m_e*11*gauss/Nw^2 = m_e*143/4"
  (\v -> meNuclear v * 11.0 * gauss_d / (nW_d * nW_d))
  18.3 ExactRational

-- | a_c = m_e * beta0/(chi-1) = m_e * 7/5
-- Coulomb coefficient. Per Z(Z-1)/A^(1/3). Predicted: 0.717 MeV (0.35% off).
-- Factored: (N_c/(chi-1)) * (beta0/N_c) = (3/5) * (7/3) = 7/5.
-- The 3/5 prefactor is obsSEMFCoulPre (already proved).
obsSEMFCoulomb_coeff :: Obs
obsSEMFCoulomb_coeff = mk "a_c (MeV)" "m_e*b0/(chi-1) = m_e*7/5"
  (\v -> meNuclear v * beta0_d / (chi_d - 1.0))
  0.714 ExactRational

-- | a_a = m_e * 19 * 43 / (3*chi) = m_e * 817/18
-- Asymmetry coefficient. Penalty for N != Z. Predicted: 23.23 MeV (0.13% off).
-- 19 and 43 are CONSECUTIVE Heegner numbers (6th and 7th in H).
-- 43 also appears in Tc (Z=43); asymmetry and Tc instability share a source.
obsSEMFAsymmetry_coeff :: Obs
obsSEMFAsymmetry_coeff = mk "a_a (MeV)" "m_e*19*43/(3chi) = m_e*817/18"
  (\v -> meNuclear v * 19.0 * 43.0 / (3.0 * chi_d))
  23.2 ExactRational

-- | a_p = m_e * N_c^2 * gauss / (chi-1) = m_e * 117/5
-- Pairing magnitude. Sign rule already in obsSEMFPairing. Predicted: 11.98 MeV (0.20% off).
-- N_c^2 = 9, gauss = 13 (also in a_s), chi-1 = 5 (also in a_c).
-- Equivalent: gauss*Sigma_d/(gauss+beta0) = 468/20 -> 117/5;
-- denom gauss+b0 = M(3) = 20 (same as a_s).
obsSEMFPairing_coeff :: Obs
obsSEMFPairing_coeff = mk "a_p (MeV)" "m_e*Nc^2*gauss/(chi-1) = m_e*117/5"
  (\v -> meNuclear v * (nC_d * nC_d) * gauss_d / (chi_d - 1.0))
  12.0 ExactRational

-- =====================================================================
-- ALL
-- =====================================================================

allNuclear :: [Obs]
allNuclear =
  -- Magic numbers
  [ obsMagic2, obsMagic8, obsMagic20, obsMagic28
  , obsMagic50, obsMagic82, obsMagic126
  -- Magnetic moments
  , obsMuP, obsMuN
  -- Binding energies + proton radius
  , obsDeuteronBE, obsAlphaBE, obsProtonRadius
  -- Neutron lifetime
  , obsNeutronLife
  -- Iron + SEMF exponents/prefactors
  , obsIronPeak
  , obsSEMFSurface, obsSEMFCoulomb, obsSEMFCoulPre, obsSEMFPairing
  -- SEMF coefficients (NEW d_52 -- all five derived from rectangle)
  , obsSEMFVolume_coeff
  , obsSEMFSurface_coeff
  , obsSEMFCoulomb_coeff
  , obsSEMFAsymmetry_coeff
  , obsSEMFPairing_coeff
  ]

-- =====================================================================
-- OUTPUT
-- =====================================================================


main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableNuclear.hs -- Component 7 (Nuclear)"
  putStrLn " Magic numbers, binding, moments, SEMF. f(VEV) x2."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  v_crystal = " ++ show vCry ++ " GeV"
  putStrLn $ "  v_pdg     = " ++ show vPdg ++ " GeV"
  putStrLn $ "  m_e(pdg)  = " ++ show (meNuclear vPdg) ++ " MeV"
  putStrLn ""
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 30 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 122 '-'

  putStrLn "  --- Magic Numbers ---"
  mapM_ row (take 7 allNuclear)
  putStrLn "  --- Magnetic Moments ---"
  mapM_ row (take 2 (drop 7 allNuclear))
  putStrLn "  --- Binding Energies + Proton Radius ---"
  mapM_ row (take 3 (drop 9 allNuclear))
  putStrLn "  --- Neutron Lifetime ---"
  mapM_ row (take 1 (drop 12 allNuclear))
  putStrLn "  --- Iron Peak + SEMF Exponents ---"
  mapM_ row (take 5 (drop 13 allNuclear))
  putStrLn "  --- SEMF Coefficients (NEW d_52, all five rectangle-derived) ---"
  mapM_ row (drop 18 allNuclear)
  putStrLn ""

  check "All 7 magic numbers EXACT"
    (all (\o -> gapPct o < 0.001)  (take 7 allNuclear))
  check "mu_p = 14/5" (abs (oCry obsMuP - 14.0/5.0) < 1e-14)
  check "mu_n = 174/91" (abs (oCry obsMuN - 174.0/91.0) < 1e-10)
  check "Fe-56 = d3*b0 = 56" (abs (oCry obsIronPeak - 56.0) < 1e-10)
  check "tau_n = 878" (abs (oCry obsNeutronLife - 878.0) < 1e-10)
  check "SEMF surf = 2/3" (abs (oCry obsSEMFSurface - 2.0/3.0) < 1e-14)
  -- New checks: all five SEMF coefficients within 0.5% of empirical
  check "a_v within 0.5%" (gapPct obsSEMFVolume_coeff    < 0.5)
  check "a_s within 0.5%" (gapPct obsSEMFSurface_coeff   < 0.5)
  check "a_c within 0.5%" (gapPct obsSEMFCoulomb_coeff   < 0.5)
  check "a_a within 0.5%" (gapPct obsSEMFAsymmetry_coeff < 0.5)
  check "a_p within 0.5%" (gapPct obsSEMFPairing_coeff   < 0.5)
  putStrLn ""

  let gs = map gapPct allNuclear
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 3) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum gs) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) gs))
           ++ "/" ++ show (length gs)
  putStrLn "=================================================================="
