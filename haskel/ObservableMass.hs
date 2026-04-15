-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableMass.hs — Component 7 (Mass): Ratios + Masses

  Mass ratios (dimensionless, Shift=0) and absolute masses
  (dimensionful, Shift~0.43%). Uses CrystalImplosion for corrected
  hadron masses (m_Upsilon, m_D, m_rho, m_phi, m_eta, m_mu, dm_dec).

  Lambda_h = v / F3 = v / 257 (hadron scale, Fermat prime).
  All masses in MeV (v_mev = v_gev * 1000).

  Compile: ghc -O2 -main-is ObservableMass ObservableMass.hs && ./ObservableMass
-}

module ObservableMass (allMass, main) where

import CrystalAtoms hiding (main)
import CrystalImplosion
  ( upsilonImplosion, dMesonImplosion, rhoMesonImplosion
  , phiMesonImplosion, etaMesonImplosion, muonImplosion
  , decupletImplosion, omegaMesonImplosion
  , impResult, implosionFactor )
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE (same as ObservableGauge)
-- =====================================================================

-- Helpers (all in MeV unless noted)
lamH :: Double -> Double
lamH v = v * 1000.0 / fermat3_d            -- Lambda_h = v/F3 in MeV

mPion :: Double -> Double
mPion v = let lam = lamH v
              fpi = lam * sqrt nC_d / (fromIntegral (nC + nW) * sqrt gauss_d)
          in fpi * sqrt (gauss_d / chi_d)   -- m_pi = f_pi * sqrt(gauss/chi)

mProton :: Double -> Double
mProton v = v * 1000.0 / 256.0 * 53.0 / 54.0  -- v/2^8 * 53/54 in MeV

-- =====================================================================
-- DIMENSIONLESS MASS RATIOS (Shift = 0)
-- =====================================================================

obsRatio_s_ud :: Obs
obsRatio_s_ud = mk "m_s/m_ud" "N_c^3 = 27"
  (\_ -> nC_d ^ (3::Int))
  27.23 ExactRational

obsRatio_c_s :: Obs
obsRatio_c_s = mk "m_c/m_s" "N_w^2*N_c*53/54 = 106/9"
  (\_ -> nW_d * nW_d * nC_d * 53.0 / 54.0)
  11.783 ExactRational

obsRatio_b_s :: Obs
obsRatio_b_s = mk "m_b/m_s" "N_c^3*N_w = 54"
  (\_ -> nC_d ^ (3::Int) * nW_d)
  53.94 ExactRational

obsRatio_b_c :: Obs
obsRatio_b_c = mk "m_b/m_c" "N_c^5/(N_c^3*N_w-1) = 243/53"
  (\_ -> nC_d ^ (5::Int) / (nC_d ^ (3::Int) * nW_d - 1.0))
  4.578 ExactRational

obsRatio_u_d :: Obs
obsRatio_u_d = mk "m_u/m_d" "(chi-1)/(2chi-1) = 5/11"
  (\_ -> (chi_d - 1.0) / (2.0 * chi_d - 1.0))
  0.455 ExactRational

obsRatio_t_b :: Obs
obsRatio_t_b = mk "m_t/m_b" "D*53/54 = 371/9"
  (\_ -> towerD_d * 53.0 / 54.0)
  41.26 ExactRational

obsRatio_mu_e :: Obs
obsRatio_mu_e = mk "m_mu/m_e" "chi^3-d_col = 208"
  (\_ -> chi_d ^ (3::Int) - d3_d)
  206.768 ExactRational

-- | m_p/m_e = 2*(D^2+Sd)/d3 + gauss^Nc/kappa + kappa/(Nw*chi*Sd2*D)
-- SINDy base + a4 correction. PPM precision. Dimensionless.
obsRatio_p_e :: Obs
obsRatio_p_e = mk "m_p/m_e" "SINDy+a4 corr"
  (\_ -> let base = 2.0 * (towerD_d * towerD_d + sigmaD_d) / d3_d
                  + gauss_d ** nC_d / kappa
             corr = kappa / (nW_d * chi_d * sigmaD2_d * towerD_d)
         in base + corr)
  1836.15267 Composite

-- =====================================================================
-- LEPTON MASSES (dimensionful, use implosion)
-- =====================================================================

-- m_mu corrected: v/2^11 * 8/9 * 87/88 (implosion from CrystalImplosion)
obsMuon :: Obs
obsMuon = mk "m_mu (MeV)" "v/2^11*8/9*87/88 (imp)"
  (\v -> impResult (muonImplosion (v * 1000.0)))
  105.658 Implosion

-- m_e = m_mu_corrected / (chi^3 - d_colour)
obsElectron :: Obs
obsElectron = mk "m_e (MeV)" "m_mu_corr/(chi^3-d_col)"
  (\v -> impResult (muonImplosion (v * 1000.0)) / (chi_d ^ (3::Int) - d3_d))
  0.51100 Implosion

-- m_t = v/sqrt(N_w) in GeV
obsTop :: Obs
obsTop = mk "m_t (GeV)" "v/sqrt(N_w)"
  (\v -> v / sqrt nW_d)
  172.57 ExactRational

-- =====================================================================
-- QCD SCALE AND PROTON
-- =====================================================================

-- Lambda_h = v/F3 = v/257 in MeV
obsLambdaH :: Obs
obsLambdaH = mk "Lam_h (MeV)" "v/F3 = v/257"
  (\v -> lamH v)
  957.78 ExactRational

-- f_pi = Lam*sqrt(N_c)/((N_c+N_w)*sqrt(gauss))
obsFpi :: Obs
obsFpi = mk "f_pi (MeV)" "Lam*sNc/((Nc+Nw)*sgauss)"
  (\v -> lamH v * sqrt nC_d / (fromIntegral (nC + nW) * sqrt gauss_d))
  92.07 ExactRational

-- m_pi = f_pi * sqrt(gauss/chi)
obsPion :: Obs
obsPion = mk "m_pi0 (MeV)" "f_pi*sqrt(gauss/chi)"
  (\v -> mPion v)
  134.977 ExactRational

-- m_p = v/2^8 * 53/54
obsProton :: Obs
obsProton = mk "m_p (MeV)" "v/2^8 * 53/54"
  (\v -> mProton v)
  938.272 ExactRational

-- m_n = same as m_p (isospin symmetry at this level)
obsNeutron :: Obs
obsNeutron = mk "m_n (MeV)" "v/2^8 * 53/54"
  (\v -> mProton v)
  939.565 ExactRational

-- =====================================================================
-- HADRON MASSES WITH IMPLOSION CORRECTIONS
-- =====================================================================

-- m_Upsilon = Lam * 79/8 (implosion: -N_c^3/(chi*Sd) = -1/8)
obsUpsilon :: Obs
obsUpsilon = mk "m_Ups (MeV)" "Lam*79/8 (imp)"
  (\v -> impResult (upsilonImplosion (lamH v)))
  9460.3 Implosion

-- m_D = Lam * 281/144 (implosion: -D/(d4*Sd) = -7/144)
obsDMeson :: Obs
obsDMeson = mk "m_D (MeV)" "Lam*281/144 (imp)"
  (\v -> impResult (dMesonImplosion (lamH v)))
  1869.7 Implosion

-- m_rho = m_pi * 23/4 (implosion: -T_F/chi = -1/12)
obsRho :: Obs
obsRho = mk "m_rho (MeV)" "m_pi*23/4 (imp)"
  (\v -> impResult (rhoMesonImplosion (mPion v)))
  775.3 Implosion

-- m_omega = m_pi * 23/4 (same as rho, inherited correction)
obsOmega :: Obs
obsOmega = mk "m_omega (MeV)" "m_pi*23/4 (imp)"
  (\v -> impResult (omegaMesonImplosion (mPion v)))
  782.7 Implosion

-- m_phi = Lam * 115/108 (implosion: -N_w/(N_c*Sd) = -1/54)
obsPhi :: Obs
obsPhi = mk "m_phi (MeV)" "Lam*115/108 (imp)"
  (\v -> impResult (phiMesonImplosion (lamH v)))
  1019.5 Implosion

-- m_eta = Lam/sqrt(3) * 74/75 (implosion: -1/(N_c*(chi-1)^2) = -1/75)
obsEta :: Obs
obsEta = mk "m_eta (MeV)" "Lam/s3*74/75 (imp)"
  (\v -> impResult (etaMesonImplosion (lamH v)))
  547.86 Implosion

-- dm_dec = m_s(2GeV) * kappa * 167/169
-- m_s comes from the MASS CHAIN: m_t → m_b → m_c → m_s → m_s(2GeV)
-- NOT from Lambda_h/10. The chain uses exact ratios.
obsDecuplet :: Obs
obsDecuplet = mk "dm_dec (MeV)" "ms*kap*167/169 (imp)"
  (\v -> let ms2gev = msChain v
         in impResult (decupletImplosion (ms2gev * kappa)))
  147.0 Implosion

-- =====================================================================
-- OTHER HADRONS (no implosion, tree-level)
-- =====================================================================

-- m_J/psi = Lam * gauss/N_w^2 = Lam * 13/4
obsJpsi :: Obs
obsJpsi = mk "m_J/psi (MeV)" "Lam*gauss/Nw^2 = Lam*13/4"
  (\v -> lamH v * gauss_d / (nW_d * nW_d))
  3096.9 ExactRational

-- m_B = Lam * (chi-1/2) = Lam * 11/2
obsBMeson :: Obs
obsBMeson = mk "m_B (MeV)" "Lam*(chi-1/2) = Lam*11/2"
  (\v -> lamH v * (chi_d - 0.5))
  5279.7 ExactRational

-- m_K = m_pi * sqrt(14*35/36)
obsKaon :: Obs
obsKaon = mk "m_K (MeV)" "m_pi*sqrt(14*35/36)"
  (\v -> mPion v * sqrt (14.0 * 35.0 / 36.0))
  497.611 ExactRational

-- m_Lambda = m_p * gauss/(gauss-2) = m_p * 13/11
obsLambda :: Obs
obsLambda = mk "m_Lam (MeV)" "m_p*gauss/(gauss-2) = mp*13/11"
  (\v -> mProton v * gauss_d / (gauss_d - 2.0))
  1115.683 ExactRational

-- m_Omega_baryon = Lam * beta0/N_w^2 = Lam * 7/4
obsOmegaBaryon :: Obs
obsOmegaBaryon = mk "m_Omega (MeV)" "Lam*b0/Nw^2 = Lam*7/4"
  (\v -> lamH v * beta0_d / (nW_d * nW_d))
  1672.5 ExactRational

-- =====================================================================
-- QUARK MASSES via CHAIN (dimensionful)
-- The chain: m_t → m_b → m_c → m_s → m_ud → m_u, m_d
-- Each step uses an exact ratio from (2,3).
-- =====================================================================

-- | The full mass chain from m_t down to m_s(2GeV)
msChain :: Double -> Double
msChain v =
  let mt  = v * 1000.0 / sqrt nW_d               -- m_t in MeV
      mb  = mt * 9.0 / 371.0                      -- m_b = m_t * 9/371
      mc  = mb * 53.0 / 243.0                     -- m_c = m_b * 53/243
      ms  = mc * 9.0 / 106.0                      -- m_s = m_c * 9/106
      run = chi_d / (chi_d - 1.0)                 -- 6/5 running factor
  in ms * run                                     -- m_s(2GeV)

obsMsBar :: Obs
obsMsBar = mk "m_s(2GeV) MeV" "chain*chi/(chi-1)"
  (\v -> msChain v)
  93.4 Running

obsMuBar :: Obs
obsMuBar = mk "m_u(2GeV) MeV" "chain*5/8*6/5"
  (\v -> let mt  = v * 1000.0 / sqrt nW_d
             mb  = mt * 9.0 / 371.0
             mc  = mb * 53.0 / 243.0
             ms  = mc * 9.0 / 106.0
             mud = ms / 27.0
             mu  = mud * 5.0 / 8.0
             run = chi_d / (chi_d - 1.0)
         in mu * run)
  2.16 Running

obsMdBar :: Obs
obsMdBar = mk "m_d(2GeV) MeV" "chain*11/8*6/5*53/54"
  (\v -> let mt   = v * 1000.0 / sqrt nW_d
             mb   = mt * 9.0 / 371.0
             mc   = mb * 53.0 / 243.0
             ms   = mc * 9.0 / 106.0
             mud  = ms / 27.0
             md   = mud * 11.0 / 8.0
             run  = chi_d / (chi_d - 1.0)
             bind = 53.0 / 54.0
         in md * run * bind)
  4.67 Running

-- =====================================================================
-- ALL
-- =====================================================================

allMass :: [Obs]
allMass =
  -- Dimensionless ratios
  [ obsRatio_s_ud, obsRatio_c_s, obsRatio_b_s, obsRatio_b_c
  , obsRatio_u_d, obsRatio_t_b, obsRatio_mu_e, obsRatio_p_e
  -- Leptons
  , obsMuon, obsElectron, obsTop
  -- QCD scale
  , obsLambdaH, obsFpi, obsPion, obsProton, obsNeutron
  -- Hadrons with implosion
  , obsUpsilon, obsDMeson, obsRho, obsOmega, obsPhi, obsEta, obsDecuplet
  -- Hadrons tree-level
  , obsJpsi, obsBMeson, obsKaon, obsLambda, obsOmegaBaryon
  -- Quark masses
  , obsMsBar, obsMuBar, obsMdBar
  ]

-- =====================================================================
-- OUTPUT (identical format to ObservableGauge)
-- =====================================================================


main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableMass.hs -- Component 7 (Mass)"
  putStrLn " Ratios + hadron/lepton masses. Implosion where needed."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  v_crystal = " ++ show vCry ++ " GeV"
  putStrLn $ "  v_pdg     = " ++ show vPdg ++ " GeV"
  putStrLn $ "  Lam_h(cry)= " ++ show (lamH vCry) ++ " MeV"
  putStrLn $ "  Lam_h(pdg)= " ++ show (lamH vPdg) ++ " MeV"
  putStrLn ""
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 30 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 122 '-'

  putStrLn "  --- Mass Ratios (dimensionless) ---"
  mapM_ row (take 8 allMass)
  putStrLn "  --- Leptons ---"
  mapM_ row (take 3 (drop 8 allMass))
  putStrLn "  --- QCD Scale ---"
  mapM_ row (take 5 (drop 11 allMass))
  putStrLn "  --- Hadrons (implosion corrected) ---"
  mapM_ row (take 7 (drop 16 allMass))
  putStrLn "  --- Hadrons (tree-level) ---"
  mapM_ row (take 5 (drop 23 allMass))
  putStrLn "  --- Quark masses (chain) ---"
  mapM_ row (drop 28 allMass)
  putStrLn ""

  -- Key checks
  check "m_s/m_ud = 27" (abs (oCry obsRatio_s_ud - 27.0) < 1e-10)
  check "m_u/m_d = 5/11" (abs (oCry obsRatio_u_d - 5.0/11.0) < 1e-14)
  check "m_mu/m_e = 208" (abs (oCry obsRatio_mu_e - 208.0) < 1e-10)
  check "m_p/m_e ~ 1836.15" (abs (oCry obsRatio_p_e - 1836.15) < 0.1)
  check "m_c/m_s = 106/9" (abs (oCry obsRatio_c_s - 106.0/9.0) < 1e-10)
  check "m_t/m_b = 371/9" (abs (oCry obsRatio_t_b - 371.0/9.0) < 1e-10)
  check "Lam_h = v/257" (abs (lamH vPdg - vPdg * 1000 / 257) < 0.01)
  check "All ratios Shift=0" (all (\o -> shiftPct o < 1e-10) (take 8 allMass))
  check "All masses Shift~0.43%" (all (\o -> abs (shiftPct o - 0.427) < 0.05)
                                       (drop 8 allMass))
  putStrLn ""

  let gs = map gapPct allMass
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 3) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum gs) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) gs))
           ++ "/" ++ show (length gs)
  putStrLn "=================================================================="
