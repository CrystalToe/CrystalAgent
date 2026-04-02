-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
-- CrystalOracle.hs — ALL values + ALL dynamics for Python cross-checking
-- ghc -O2 CrystalOracle.hs -o crystal_oracle

module Main where

fi :: Integer -> Double
fi = fromIntegral

-- ══ A_F ATOMS ═══════════════════════════════════════════════
nW, nC, chi, beta0, d1, d2, d3, d4 :: Integer
nW = 2; nC = 3; chi = nW * nC; beta0 = (11*nC - 2*chi) `div` 3
d1 = 1; d2 = nC; d3 = nC*nC - 1; d4 = (nC*nC-1)*nC
sigmaD, sigmaD2, gauss, towerD, dColour, dMixed, sharedCore, fermat3 :: Integer
sigmaD = d1+d2+d3+d4; sigmaD2 = d1^2+d2^2+d3^2+d4^2
gauss = nC*nC + nW*nW; towerD = sigmaD + chi
dColour = nW^3; dMixed = d3*nC; sharedCore = sigmaD2*towerD
fermat3 = 2^(2^nC) + 1
kappa :: Double
kappa = log (fi nC) / log (fi nW)

-- ══ VEV ═════════════════════════════════════════════════════
mPl :: Double; mPl = 1.22089e19
vevCrystal :: Double; vevCrystal = mPl * 35 / (43 * 36 * fi (2^50))
convFactor :: Double
convFactor = 1 + fi nC / (16*pi*pi) * log (sqrt (fi nW) * fi d3 / fi (nC*nC))
vevPdg :: Double; vevPdg = vevCrystal * convFactor

-- ══ COUPLINGS ═══════════════════════════════════════════════
alphaInv :: Double; alphaInv = (fi towerD + 1) * pi + log (fi beta0)
alpha :: Double; alpha = 1 / alphaInv
sin2tw :: Double; sin2tw = fi nC / fi gauss + fi beta0 / fi (d4*sigmaD2)
cos2tw :: Double; cos2tw = 1 - sin2tw

-- ══ MASSES ══════════════════════════════════════════════════
lH :: Double; lH = vevCrystal / fi fermat3
mp :: Double; mp = vevCrystal / fi (2^(2^nC)) * 53/54
mn :: Double; mn = mp * (1 + alpha / fi (nC*gauss))
me :: Double; me = lH / fi (nC*nC * nW^4 * gauss)
mmu :: Double; mmu = me * fi (nW^4 * gauss)
mtau :: Double; mtau = mmu * fi gauss * fi nC / fi beta0
mpi :: Double; mpi = mp / fi beta0
mK :: Double; mK = mpi * sqrt (fi gauss / fi beta0)
mrho :: Double; mrho = mp * fi d3 / fi (d3 + nC)
mdelta :: Double; mdelta = mp * (1 + fi nC / fi towerD)
mt :: Double; mt = vevCrystal / sqrt 2
mz :: Double; mz = vevCrystal * fi nC / fi d3
mw :: Double; mw = vevCrystal * sqrt (pi * alpha / sin2tw)
mh :: Double; mh = vevCrystal / fi nW
lqcd :: Double; lqcd = mp * fi nC / fi gauss
fpi :: Double; fpi = lqcd * fi nC / fi beta0
mu :: Double; mu = lH / fi (nC*gauss*d3)
md :: Double; md = mu * fi nC
ms :: Double; ms = md * fi gauss
mc :: Double; mc = ms * fi nC
mb :: Double; mb = mc * fi nC
-- PDG
mpP :: Double; mpP = vevPdg / fi (2^(2^nC)) * 53/54
meP :: Double; meP = (vevPdg / fi fermat3) / fi (nC*nC * nW^4 * gauss)
mzP :: Double; mzP = vevPdg * fi nC / fi d3
mtP :: Double; mtP = vevPdg / sqrt 2

-- ══ DIMENSIONLESS ═══════════════════════════════════════════
mpme :: Double
mpme = 2*fi(towerD*towerD+sigmaD)/fi d3 + fi gauss**fi nC/kappa + kappa/fi(nW*chi*sigmaD2*towerD)
muE :: Double; muE = fi (nW^4 * gauss)
tauMu :: Double; tauMu = fi gauss * fi nC / fi beta0

-- ══ COSMO ═══════════════════════════════════════════════════
omL :: Double; omL = fi(towerD-gauss) / fi towerD
omCdm :: Double; omCdm = fi(gauss-nW) / fi towerD
omB :: Double; omB = fi nW / fi towerD
omM :: Double; omM = fi gauss / fi towerD
h0 :: Double; h0 = 100 * fi towerD / fi (sigmaD+beta0)
ns :: Double; ns = 1 - fi nW / fi towerD

-- ══ MIXING ══════════════════════════════════════════════════
sinC :: Double; sinC = 1/sqrt(fi gauss)
vCb :: Double; vCb = sinC * fi nC / fi towerD
vUb :: Double; vUb = sinC * fi nW / fi towerD
jarl :: Double; jarl = fi(nC*nC) / fi(gauss*towerD*towerD)
s12 :: Double; s12 = fi nC/fi gauss + fi nW/fi(gauss*d3)
s23 :: Double; s23 = 1/fi nW
s13 :: Double; s13 = fi nW / fi(nC*towerD)

-- ══ CODATA ══════════════════════════════════════════════════
rp :: Double
rp = (cF * fi nC - tF / fi(d3*sigmaD)) * hbarC / (mp*1e3)
  where cF = fi(nC*nC-1)/fi(2*nC); tF = 0.5; hbarC = 197.3269804

-- ══ DYNAMICS: CLASSICAL ════════════════════════════════════
dyn_spatial_dim :: Integer; dyn_spatial_dim = nC
dyn_phase_space :: Integer; dyn_phase_space = chi
dyn_force_exp :: Integer; dyn_force_exp = nC - 1

-- ══ DYNAMICS: GR ════════════════════════════════════════════
dyn_isco :: Integer; dyn_isco = chi
dyn_precession :: Integer; dyn_precession = chi
dyn_bending :: Integer; dyn_bending = nW*nW
dyn_photon_sphere :: Integer; dyn_photon_sphere = nC
dyn_schwarz :: Integer; dyn_schwarz = nW

-- ══ DYNAMICS: GW ════════════════════════════════════════════
dyn_peters :: Double; dyn_peters = fi nW ** 5 / fi (chi-1)
dyn_chirp_exp :: Double; dyn_chirp_exp = fi(chi-1) / fi nC
dyn_gw_pol :: Integer; dyn_gw_pol = nC - 1

-- ══ DYNAMICS: EM ════════════════════════════════════════════
dyn_em_comp :: Integer; dyn_em_comp = chi
dyn_maxwell :: Integer; dyn_maxwell = nC + 1
dyn_em_pol :: Integer; dyn_em_pol = nC - 1
dyn_larmor :: Double; dyn_larmor = fi nW / fi nC

-- ══ DYNAMICS: FRIEDMANN ═════════════════════════════════════
dyn_friedmann_flat :: Double; dyn_friedmann_flat = omL + omM

-- ══ DYNAMICS: NBODY ═════════════════════════════════════════
dyn_octree :: Integer; dyn_octree = dColour
dyn_bh_theta :: Double; dyn_bh_theta = 1 / fi nW

-- ══ DYNAMICS: THERMO ════════════════════════════════════════
dyn_lj_attract :: Integer; dyn_lj_attract = chi
dyn_lj_repel :: Integer; dyn_lj_repel = 2 * chi
dyn_lj_at_sigma :: Double; dyn_lj_at_sigma = 4 * (1 - 1) -- 0
dyn_gamma_mono :: Double; dyn_gamma_mono = fi(chi-1) / fi nC

-- ══ DYNAMICS: CFD ═══════════════════════════════════════════
dyn_d2q9 :: Integer; dyn_d2q9 = nC * nC
dyn_stokes :: Integer; dyn_stokes = dMixed
dyn_kolmogorov :: Double; dyn_kolmogorov = fi(chi-1) / fi nC

-- ══ DYNAMICS: DECAY ═════════════════════════════════════════
dyn_beta_factor :: Integer; dyn_beta_factor = dMixed * dColour

-- ══ DYNAMICS: OPTICS ════════════════════════════════════════
dyn_n_water :: Double; dyn_n_water = fi(nC*nC-1) / fi(2*nC)
dyn_n_glass :: Double; dyn_n_glass = fi nC / fi nW
dyn_n_diamond :: Double; dyn_n_diamond = fi(nW*nW+nC*nC) / fi(chi-1)
dyn_rayleigh :: Integer; dyn_rayleigh = nW*nW
dyn_planck :: Integer; dyn_planck = chi - 1

-- ══ DYNAMICS: MD ════════════════════════════════════════════
dyn_sp3 :: Double; dyn_sp3 = acos(-1/fi nC) * 180/pi
dyn_water :: Double; dyn_water = acos(-1/fi(nW*nW)) * 180/pi
dyn_helix :: Double; dyn_helix = fi(nC*nC*nW) / fi(chi-1)
dyn_flory :: Double; dyn_flory = fi nW / fi(chi-1)
dyn_amino :: Integer; dyn_amino = nW*nW*(chi-1)
dyn_dna :: Integer; dyn_dna = nW*nW

-- ══ DYNAMICS: CONDENSED ═════════════════════════════════════
dyn_ising_z :: Integer; dyn_ising_z = nW*nW
dyn_onsager :: Double; dyn_onsager = fi nW / log(1 + sqrt(fi nW))
dyn_bcs :: Double; dyn_bcs = 2*pi / exp 0.5772156649

-- ══ DYNAMICS: PLASMA ════════════════════════════════════════
dyn_mhd :: Integer; dyn_mhd = dColour
dyn_wave_types :: Integer; dyn_wave_types = nC
dyn_prop_modes :: Integer; dyn_prop_modes = chi

-- ══ DYNAMICS: QFT ═══════════════════════════════════════════
dyn_spacetime :: Integer; dyn_spacetime = nW*nW
dyn_lorentz :: Integer; dyn_lorentz = chi
dyn_dirac :: Integer; dyn_dirac = nW*nW
dyn_gluons :: Integer; dyn_gluons = d3
dyn_one_loop :: Integer; dyn_one_loop = nW^4
dyn_thomson :: Double
dyn_thomson = fi dColour / fi nC * pi * re * re * 0.01
  where me' = 0.51099895e-3; hbarc = 197.3269804e-3; re = alpha * hbarc / me'
dyn_sigma10 :: Double
dyn_sigma10 = fi(nW*nW) * pi * alpha*alpha / (fi nC * 100) * 0.389379e6

-- ══ DYNAMICS: RIGID ═════════════════════════════════════════
dyn_quat :: Integer; dyn_quat = nW*nW
dyn_inertia :: Integer; dyn_inertia = chi
dyn_i_sphere :: Double; dyn_i_sphere = fi nW / fi(chi-1)
dyn_i_rod :: Double; dyn_i_rod = 1 / fi(2*chi)
dyn_i_shell :: Double; dyn_i_shell = fi nW / fi nC

-- ══ DYNAMICS: CHEM ══════════════════════════════════════════
dyn_s_cap :: Integer; dyn_s_cap = nW
dyn_p_cap :: Integer; dyn_p_cap = chi
dyn_d_cap :: Integer; dyn_d_cap = nW*(chi-1)
dyn_f_cap :: Integer; dyn_f_cap = nW*beta0
dyn_noble_kr :: Integer; dyn_noble_kr = sigmaD
dyn_ph :: Integer; dyn_ph = beta0

-- ══ DYNAMICS: NUCLEAR ═══════════════════════════════════════
dyn_magic :: [Integer]
dyn_magic = [nW, dColour, nW*nW*(chi-1), nW*nW*beta0, nW*(chi-1)^2, nW*(towerD-1), nW*beta0*nC*nC]
dyn_iron :: Integer; dyn_iron = dColour * beta0

-- ══ DYNAMICS: ASTRO ═════════════════════════════════════════
dyn_poly_nr :: Double; dyn_poly_nr = fi nC / fi nW
dyn_poly_rel :: Integer; dyn_poly_rel = nC
dyn_hawking :: Integer; dyn_hawking = dColour
dyn_sb :: Integer; dyn_sb = nC * (chi-1)
dyn_eddington :: Integer; dyn_eddington = nW*nW
-- Lane-Emden solver
laneEmden :: Double -> (Double, Double)
laneEmden n = go 0.001 (1 - 0.001*0.001/6) (-0.001/3)
  where
    go xi th dth
      | th <= 0 || xi >= 20 = (xi, -xi*xi*dth)
      | otherwise =
          let dx = 0.0005
              f1 = -(th**n) - 2*dth/xi
              xi2 = xi + 0.5*dx
              th2 = th + 0.5*dx*dth
              dth2 = dth + 0.5*dx*f1
              f2 = -(if th2>0 then th2**n else 0) - 2*dth2/xi2
          in go (xi+dx) (th+dx*dth2) (dth+dx*f2)
dyn_le_15 :: (Double,Double); dyn_le_15 = laneEmden 1.5
dyn_le_30 :: (Double,Double); dyn_le_30 = laneEmden 3.0

-- ══ DYNAMICS: QINFO ═════════════════════════════════════════
dyn_qubit :: Integer; dyn_qubit = nW
dyn_pauli :: Integer; dyn_pauli = nC
dyn_bell :: Integer; dyn_bell = nW*nW
dyn_steane_n :: Integer; dyn_steane_n = beta0
dyn_steane_k :: Integer; dyn_steane_k = 1
dyn_steane_d :: Integer; dyn_steane_d = nC
dyn_shor :: Integer; dyn_shor = nC*nC
dyn_mera_bond :: Integer; dyn_mera_bond = chi
dyn_mera_depth :: Integer; dyn_mera_depth = towerD

-- ══ DYNAMICS: BIO ═══════════════════════════════════════════
dyn_codons :: Integer; dyn_codons = (nW*nW)^nC
dyn_stops :: Integer; dyn_stops = nC
dyn_hbond_at :: Integer; dyn_hbond_at = nW
dyn_hbond_gc :: Integer; dyn_hbond_gc = nC
dyn_bp_turn :: Integer; dyn_bp_turn = nW*(chi-1)
dyn_lipid :: Integer; dyn_lipid = nW
dyn_kleiber :: Double; dyn_kleiber = fi nC / fi(nW*nW)
dyn_surface :: Double; dyn_surface = fi nW / fi nC
dyn_heart :: Double; dyn_heart = 1 / fi(nW*nW)

-- ══ DYNAMICS: ARCADE ════════════════════════════════════════
dyn_lj_cut :: Integer; dyn_lj_cut = nC
dyn_fixed_bits :: Integer; dyn_fixed_bits = nW^4
dyn_lod :: Integer; dyn_lod = nC
dyn_wca :: Double; dyn_wca = fi nW ** (1/fi chi)
dyn_fast_alpha :: Integer; dyn_fast_alpha = 137

-- ══ PRINT EVERYTHING ════════════════════════════════════════
main :: IO ()
main = mapM_ (\(k,v) -> putStrLn (k ++ "=" ++ v))
  [ -- Atoms
    ("chi", show chi), ("beta0", show beta0)
  , ("d1", show d1), ("d2", show d2), ("d3", show d3), ("d4", show d4)
  , ("sigma_d", show sigmaD), ("sigma_d2", show sigmaD2)
  , ("gauss", show gauss), ("tower_d", show towerD)
  , ("d_colour", show dColour), ("d_mixed", show dMixed)
  , ("shared_core", show sharedCore), ("fermat3", show fermat3)
  , ("kappa", show kappa)
  -- VEV
  , ("vev_crystal", show vevCrystal), ("conversion_factor", show convFactor), ("vev_pdg", show vevPdg)
  -- Couplings
  , ("alpha_inv", show alphaInv), ("alpha", show alpha)
  , ("sin2_theta_w", show sin2tw), ("cos2_theta_w", show cos2tw)
  -- Masses Crystal
  , ("proton_mass", show mp), ("neutron_mass", show mn)
  , ("electron_mass", show me), ("muon_mass", show mmu), ("tau_mass", show mtau)
  , ("pion_mass", show mpi), ("kaon_mass", show mK)
  , ("rho_mass", show mrho), ("delta_mass", show mdelta)
  , ("top_mass", show mt), ("z_mass", show mz), ("w_mass", show mw), ("higgs_mass", show mh)
  , ("lambda_qcd", show lqcd), ("f_pi", show fpi)
  , ("up_mass", show mu), ("down_mass", show md), ("strange_mass", show ms)
  , ("charm_mass", show mc), ("bottom_mass", show mb)
  -- Masses PDG
  , ("proton_mass_pdg", show mpP), ("electron_mass_pdg", show meP)
  , ("z_mass_pdg", show mzP), ("top_mass_pdg", show mtP)
  -- Dimensionless
  , ("mp_me_ratio", show mpme), ("mu_e_ratio", show muE), ("tau_mu_ratio", show tauMu)
  -- Cosmo
  , ("omega_lambda", show omL), ("omega_cdm", show omCdm)
  , ("omega_b", show omB), ("omega_m", show omM)
  , ("h0", show h0), ("spectral_index", show ns)
  -- Mixing
  , ("sin_cabibbo", show sinC), ("v_us", show sinC)
  , ("v_cb", show vCb), ("v_ub", show vUb), ("jarlskog", show jarl)
  , ("sin2_theta12", show s12), ("sin2_theta23", show s23), ("sin2_theta13", show s13)
  -- CODATA
  , ("proton_radius", show rp)
  -- ═══ DYNAMICS ═══
  -- Classical
  , ("dyn_spatial_dim", show dyn_spatial_dim), ("dyn_phase_space", show dyn_phase_space)
  , ("dyn_force_exp", show dyn_force_exp)
  -- GR
  , ("dyn_isco", show dyn_isco), ("dyn_precession", show dyn_precession)
  , ("dyn_bending", show dyn_bending), ("dyn_photon_sphere", show dyn_photon_sphere)
  , ("dyn_schwarz", show dyn_schwarz)
  -- GW
  , ("dyn_peters", show dyn_peters), ("dyn_chirp_exp", show dyn_chirp_exp)
  , ("dyn_gw_pol", show dyn_gw_pol)
  -- EM
  , ("dyn_em_comp", show dyn_em_comp), ("dyn_maxwell", show dyn_maxwell)
  , ("dyn_em_pol", show dyn_em_pol), ("dyn_larmor", show dyn_larmor)
  -- Friedmann
  , ("dyn_friedmann_flat", show dyn_friedmann_flat)
  -- NBody
  , ("dyn_octree", show dyn_octree), ("dyn_bh_theta", show dyn_bh_theta)
  -- Thermo
  , ("dyn_lj_attract", show dyn_lj_attract), ("dyn_lj_repel", show dyn_lj_repel)
  , ("dyn_gamma_mono", show dyn_gamma_mono)
  -- CFD
  , ("dyn_d2q9", show dyn_d2q9), ("dyn_stokes", show dyn_stokes)
  , ("dyn_kolmogorov", show dyn_kolmogorov)
  -- Decay
  , ("dyn_beta_factor", show dyn_beta_factor)
  -- Optics
  , ("dyn_n_water", show dyn_n_water), ("dyn_n_glass", show dyn_n_glass)
  , ("dyn_n_diamond", show dyn_n_diamond)
  , ("dyn_rayleigh", show dyn_rayleigh), ("dyn_planck", show dyn_planck)
  -- MD
  , ("dyn_sp3", show dyn_sp3), ("dyn_water_angle", show dyn_water)
  , ("dyn_helix", show dyn_helix), ("dyn_flory", show dyn_flory)
  , ("dyn_amino", show dyn_amino), ("dyn_dna", show dyn_dna)
  -- Condensed
  , ("dyn_ising_z", show dyn_ising_z), ("dyn_onsager", show dyn_onsager)
  , ("dyn_bcs", show dyn_bcs)
  -- Plasma
  , ("dyn_mhd", show dyn_mhd), ("dyn_wave_types", show dyn_wave_types)
  , ("dyn_prop_modes", show dyn_prop_modes)
  -- QFT
  , ("dyn_spacetime", show dyn_spacetime), ("dyn_lorentz", show dyn_lorentz)
  , ("dyn_dirac", show dyn_dirac), ("dyn_gluons", show dyn_gluons)
  , ("dyn_one_loop", show dyn_one_loop)
  , ("dyn_thomson", show dyn_thomson), ("dyn_sigma10", show dyn_sigma10)
  -- Rigid
  , ("dyn_quat", show dyn_quat), ("dyn_inertia", show dyn_inertia)
  , ("dyn_i_sphere", show dyn_i_sphere), ("dyn_i_rod", show dyn_i_rod)
  , ("dyn_i_shell", show dyn_i_shell)
  -- Chem
  , ("dyn_s_cap", show dyn_s_cap), ("dyn_p_cap", show dyn_p_cap)
  , ("dyn_d_cap", show dyn_d_cap), ("dyn_f_cap", show dyn_f_cap)
  , ("dyn_noble_kr", show dyn_noble_kr), ("dyn_ph", show dyn_ph)
  -- Nuclear
  , ("dyn_magic", show dyn_magic), ("dyn_iron", show dyn_iron)
  -- Astro
  , ("dyn_poly_nr", show dyn_poly_nr), ("dyn_poly_rel", show dyn_poly_rel)
  , ("dyn_hawking", show dyn_hawking), ("dyn_sb", show dyn_sb)
  , ("dyn_eddington", show dyn_eddington)
  , ("dyn_le_15_xi", show (fst dyn_le_15)), ("dyn_le_15_mass", show (snd dyn_le_15))
  , ("dyn_le_30_xi", show (fst dyn_le_30)), ("dyn_le_30_mass", show (snd dyn_le_30))
  -- QInfo
  , ("dyn_qubit", show dyn_qubit), ("dyn_pauli", show dyn_pauli)
  , ("dyn_bell", show dyn_bell)
  , ("dyn_steane_n", show dyn_steane_n), ("dyn_steane_k", show dyn_steane_k)
  , ("dyn_steane_d", show dyn_steane_d)
  , ("dyn_shor", show dyn_shor), ("dyn_mera_bond", show dyn_mera_bond)
  , ("dyn_mera_depth", show dyn_mera_depth)
  -- Bio
  , ("dyn_codons", show dyn_codons), ("dyn_stops", show dyn_stops)
  , ("dyn_hbond_at", show dyn_hbond_at), ("dyn_hbond_gc", show dyn_hbond_gc)
  , ("dyn_bp_turn", show dyn_bp_turn), ("dyn_lipid", show dyn_lipid)
  , ("dyn_kleiber", show dyn_kleiber), ("dyn_surface", show dyn_surface)
  , ("dyn_heart", show dyn_heart)
  -- Arcade
  , ("dyn_lj_cut", show dyn_lj_cut), ("dyn_fixed_bits", show dyn_fixed_bits)
  , ("dyn_lod", show dyn_lod), ("dyn_wca", show dyn_wca)
  , ("dyn_fast_alpha", show dyn_fast_alpha)
  ]
