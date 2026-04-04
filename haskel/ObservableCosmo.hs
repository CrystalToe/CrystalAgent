-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableCosmo.hs — Component 7 (Cosmo): Dark energy, CMB, neutrinos

  Uses CrystalImplosion for Omega_DM (corrected with -1/130 channel).
  Neutrino masses are dimensionful (use VEV, Shift~0.43%).
  Everything else is dimensionless (Shift=0).

  Compile: ghc -O2 -main-is ObservableCosmo ObservableCosmo.hs && ./ObservableCosmo
-}

module ObservableCosmo (allCosmo, main) where

import CrystalAtoms hiding (main)
import CrystalImplosion (omegaDMImplosion, impResult)
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE (same pattern)
-- =====================================================================

-- =====================================================================
-- DARK ENERGY + COSMOLOGICAL PARAMETERS (dimensionless)
-- =====================================================================

-- | Omega_Lambda = gauss/(gauss+chi) = 13/19
obsOmegaL :: Obs
obsOmegaL = mk "Omega_L" "gauss/(gauss+chi) = 13/19"
  (\_ -> gauss_d / (gauss_d + chi_d))
  0.6847 ExactRational

-- | Omega_m = chi/(gauss+chi) = 6/19
obsOmegaM :: Obs
obsOmegaM = mk "Omega_m" "chi/(gauss+chi) = 6/19"
  (\_ -> chi_d / (gauss_d + chi_d))
  0.3153 ExactRational

-- | Omega_b = Omega_m * beta0/(beta0+12pi)
obsOmegaB :: Obs
obsOmegaB = mk "Omega_b" "Om*b0/(b0+12pi)"
  (\_ -> chi_d / (gauss_d + chi_d) * beta0_d / (beta0_d + 12.0 * pi))
  0.0493 SinglePi

-- | Omega_DM (corrected with implosion: -1/130 channel)
-- Base: Omega_m - Omega_b = 6/19 - 3/61 = 309/1159
-- Correction: -1/(gauss*(gauss-N_c)) = -1/130
obsOmegaDM :: Obs
obsOmegaDM = mk "Omega_DM (corr)" "Om-Ob-1/130 (imp)"
  (\_ -> impResult omegaDMImplosion)
  0.2589 Implosion

-- | Omega_Lambda/Omega_m = gauss/chi = 13/6
obsOmRatio :: Obs
obsOmRatio = mk "Om_L/Om_m" "gauss/chi = 13/6"
  (\_ -> gauss_d / chi_d)
  2.175 ExactRational

-- | Omega_DM/Omega_b = (N_w^2*N_c/beta0)*pi = 12pi/7
obsDMBaryonRatio :: Obs
obsDMBaryonRatio = mk "Om_DM/Om_b" "(Nw^2*Nc/b0)*pi = 12pi/7"
  (\_ -> nW_d * nW_d * nC_d / beta0_d * pi)
  5.36 SinglePi

-- | w (dark energy EoS) = -1 exactly (Landauer)
obsDE_EoS :: Obs
obsDE_EoS = mk "w (DE EoS)" "Landauer: w = -1"
  (\_ -> -1.0)
  (-1.0) ExactRational

-- =====================================================================
-- CMB PARAMETERS (dimensionless)
-- =====================================================================

-- | 100*theta* = 100/(N_w*(D+chi)) = 100/96
obs100Theta :: Obs
obs100Theta = mk "100*theta*" "100/(Nw*(D+chi)) = 100/96"
  (\_ -> 100.0 / (nW_d * (towerD_d + chi_d)))
  1.0411 ExactRational

-- | n_s = 1 - kappa/D
obsNs :: Obs
obsNs = mk "n_s" "1-kap/D"
  (\_ -> 1.0 - kappa / towerD_d)
  0.9649 KappaOrLn

-- | ln(10^10 A_s) = ln(N_c * beta0) = ln(21)
obsLnAs :: Obs
obsLnAs = mk "ln(10^10 A_s)" "ln(Nc*b0) = ln(21)"
  (\_ -> log (nC_d * beta0_d))
  3.044 KappaOrLn

-- | T_CMB = (gauss+chi)/beta0 = 19/7
obsTCMB :: Obs
obsTCMB = mk "T_CMB (K)" "(gauss+chi)/b0 = 19/7"
  (\_ -> (gauss_d + chi_d) / beta0_d)
  2.7255 ExactRational

-- | Age of universe = gauss + chi/beta0 = 97/7
obsAge :: Obs
obsAge = mk "Age (Gyr)" "gauss+chi/b0 = 97/7"
  (\_ -> gauss_d + chi_d / beta0_d)
  13.797 ExactRational

-- | Halo slope = -ln(chi)/ln(N_w) = -(1+kappa)
obsHalo :: Obs
obsHalo = mk "halo slope" "-ln(chi)/ln(Nw) = -(1+kap)"
  (\_ -> -(log chi_d / log nW_d))
  (-2.585) KappaOrLn

-- =====================================================================
-- NEUTRINO MASSES (dimensionful, Shift~0.43%)
-- =====================================================================

-- | m_nu3 = v/2^42 * 10/11 (meV)
obsNu3 :: Obs
obsNu3 = mk "m_nu3 (meV)" "v/2^42 * 10/11"
  (\v -> let pow = 2.0 ** towerD_d  -- 2^42
             tree = v / pow * 1e12  -- meV
         in tree * 10.0 / 11.0)
  50.7 ExactRational

-- | m_nu2 = (v/(2^42*chi)) * 12/13 (meV)
obsNu2 :: Obs
obsNu2 = mk "m_nu2 (meV)" "(v/(2^42*chi))*12/13"
  (\v -> let pow = 2.0 ** towerD_d
             tree = v / pow / chi_d * 1e12
         in tree * 12.0 / 13.0)
  8.6 ExactRational

-- | Sum m_nu (eV) = (m3 + m2 + m1)/1000 where m1 = m3/chi^2
obsSumNu :: Obs
obsSumNu = mk "Sum m_nu (eV)" "Sum corrected"
  (\v -> let pow = 2.0 ** towerD_d
             m3 = v / pow * 1e12 * 10.0 / 11.0
             m2 = v / pow / chi_d * 1e12 * 12.0 / 13.0
             m1 = m3 / (chi_d * chi_d)
         in (m3 + m2 + m1) / 1000.0)
  0.0608 Composite

-- | rho_Lambda^(1/4) = m_nu1_tree/ln(N_w) (meV)
-- Uses TREE m_nu1 = v/(2^42 * chi^2), NOT the 10/11 corrected one.
obsRhoLambda :: Obs
obsRhoLambda = mk "rho_L^1/4 (meV)" "m_nu1_tree/ln(Nw)"
  (\v -> let pow = 2.0 ** towerD_d
             mNu1 = v / pow / (chi_d * chi_d) * 1e12  -- tree, in meV
         in mNu1 / log nW_d)
  2.25 KappaOrLn

-- =====================================================================
-- ALL
-- =====================================================================

allCosmo :: [Obs]
allCosmo =
  -- Dark energy + cosmological
  [ obsOmegaL, obsOmegaM, obsOmegaB, obsOmegaDM, obsOmRatio
  , obsDMBaryonRatio, obsDE_EoS
  -- CMB
  , obs100Theta, obsNs, obsLnAs, obsTCMB, obsAge, obsHalo
  -- Neutrinos
  , obsNu3, obsNu2, obsSumNu, obsRhoLambda
  ]

-- =====================================================================
-- OUTPUT
-- =====================================================================


main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableCosmo.hs -- Component 7 (Cosmo)"
  putStrLn " Dark energy, CMB, neutrinos. Implosion for Omega_DM."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  v_crystal = " ++ show vCry ++ " GeV"
  putStrLn $ "  v_pdg     = " ++ show vPdg ++ " GeV"
  putStrLn ""
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 30 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 122 '-'

  putStrLn "  --- Dark Energy + Density ---"
  mapM_ row (take 7 allCosmo)
  putStrLn "  --- CMB Parameters ---"
  mapM_ row (take 6 (drop 7 allCosmo))
  putStrLn "  --- Neutrino Masses ---"
  mapM_ row (drop 13 allCosmo)
  putStrLn ""

  check "Omega_L = 13/19" (abs (oCry obsOmegaL - 13.0/19.0) < 1e-14)
  check "Omega_m = 6/19" (abs (oCry obsOmegaM - 6.0/19.0) < 1e-14)
  check "Omega_L + Omega_m = 1" (abs (oCry obsOmegaL + oCry obsOmegaM - 1.0) < 1e-14)
  check "w = -1 exactly" (oCry obsDE_EoS == -1.0)
  check "T_CMB = 19/7" (abs (oCry obsTCMB - 19.0/7.0) < 1e-14)
  check "Age = 97/7" (abs (oCry obsAge - 97.0/7.0) < 1e-14)
  check "100theta = 100/96" (abs (oCry obs100Theta - 100.0/96.0) < 1e-14)
  check "ln(10^10 A_s) = ln(21)" (abs (oCry obsLnAs - log 21.0) < 1e-14)
  check "Omega_DM uses implosion" (abs (oCry obsOmegaDM - 0.2589) < 0.001)
  putStrLn ""

  let gs = map gapPct allCosmo
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 3) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum gs) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) gs))
           ++ "/" ++ show (length gs)
  putStrLn "=================================================================="
