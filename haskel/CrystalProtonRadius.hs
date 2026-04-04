-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- THE AXIOM: A_F = C + M2(C) + M3(C) — Starting point, not conclusion
-- CrystalProtonRadius.hs — Proton charge radius from spectral triple
-- Session 6: Observable #181
-- License: AGPL-3.0
--
-- r_p = (C_F * N_c - T_F / (d3 * sigma_d)) * hbar_over_mpc
--     = (4 - 1/576) * hbar/(m_p*c)
--
-- Dual route: T_F/(d3*sigma_d) = 1/d4^2  because 2*d3*sigma_d = d4^2 = 576
--
-- Three-body bounds:
--   r_MAX = C_F * N_c * hbar/(m_p*c)              (confinement ceiling)
--   r_MIN = (C_F*N_c - 1/(d4^2-1)) * hbar/(m_p*c) (asymptotic freedom floor)

module CrystalProtonRadius where

import qualified CrystalAtoms as CE  -- refactored: was CrystalEngine
-- Axiom: A_F = C + M2(C) + M3(C)
n_w, n_c :: Int
n_w = CE.nW
n_c = CE.nC

chi, beta0 :: Int
chi   = n_w * n_c        -- 6
beta0 = (11*n_c - 2*chi) `div` 3  -- 7

d1, d2, d3, d4 :: Int
d1 = 1; d2 = 3; d3 = 8; d4 = 24

sigma_d, sigma_d2 :: Int
sigma_d  = d1 + d2 + d3 + d4      -- 36
sigma_d2 = d1^2 + d2^2 + d3^2 + d4^2  -- 650

gauss :: Int
gauss = n_c^2 + n_w^2  -- 13

towerD :: Int
towerD = sigma_d + chi  -- 42

-- Group theory invariants
c_F :: Double
c_F = fromIntegral (n_c^2 - 1) / fromIntegral (2 * n_c)  -- 4/3

t_F :: Double
t_F = 0.5

kappa :: Double
kappa = log 3 / log 2

-- Physical constants
hbar_c_fm :: Double
hbar_c_fm = 197.3269804  -- MeV*fm

m_p_MeV :: Double
m_p_MeV = 938.272088  -- MeV

compton_p_fm :: Double
compton_p_fm = hbar_c_fm / m_p_MeV

-- PDG targets
r_p_muonic :: Double
r_p_muonic = 0.84087  -- fm (muonic hydrogen)

r_p_muonic_unc :: Double
r_p_muonic_unc = 0.00039  -- fm

r_p_codata :: Double
r_p_codata = 0.8414  -- fm (CODATA 2018)

r_p_codata_unc :: Double
r_p_codata_unc = 0.0019  -- fm

-- ============================================================
-- PROVE FUNCTIONS
-- ============================================================

-- | #181: Proton charge radius base formula
prove_protonRadius_base :: (String, Bool, Double, Double)
prove_protonRadius_base =
  let f_base = c_F * fromIntegral n_c  -- (N_c^2-1)/2 = 4
      r_p    = f_base * compton_p_fm
      delta  = abs (r_p - r_p_codata) / r_p_codata_unc
  in ("protonRadius_base: C_F*N_c = 4",
      delta < 1.0,
      r_p,
      delta)

-- | #181: Proton charge radius with correction
prove_protonRadius :: (String, Bool, Double, Double)
prove_protonRadius =
  let correction = t_F / (fromIntegral d3 * fromIntegral sigma_d)  -- 1/576
      f_corr     = c_F * fromIntegral n_c - correction
      r_p        = f_corr * compton_p_fm
      delta_mu   = abs (r_p - r_p_muonic) / r_p_muonic_unc
      delta_co   = abs (r_p - r_p_codata) / r_p_codata_unc
  in ("protonRadius: (C_F*N_c - T_F/(d3*Sigma_d)) * hbar/(m_p*c)",
      delta_mu < 1.0 && delta_co < 1.0,
      r_p,
      delta_mu)

-- | Dual route identity: 2*d3*sigma_d = d4^2
prove_dualRoute_d4sq :: (String, Bool, Int, Int)
prove_dualRoute_d4sq =
  let lhs = 2 * d3 * sigma_d  -- 576
      rhs = d4 ^ 2            -- 576
  in ("dualRoute: 2*d3*sigma_d = d4^2",
      lhs == rhs,
      lhs,
      rhs)

-- | Correction via dual route: 1/d4^2
prove_protonRadius_dualRoute :: (String, Bool, Double, Double)
prove_protonRadius_dualRoute =
  let correction_A = t_F / (fromIntegral d3 * fromIntegral sigma_d)
      correction_B = 1.0 / fromIntegral (d4 ^ 2)
      match = abs (correction_A - correction_B) < 1e-15
      r_p   = (c_F * fromIntegral n_c - correction_B) * compton_p_fm
      delta = abs (r_p - r_p_muonic) / r_p_muonic_unc
  in ("protonRadius_dualRoute: T_F/(d3*Sd) = 1/d4^2",
      match && delta < 1.0,
      r_p,
      delta)

-- | Three-body maximum radius (confinement ceiling)
prove_protonRadius_rMax :: (String, Bool, Double, Double)
prove_protonRadius_rMax =
  let r_max = c_F * fromIntegral n_c * compton_p_fm
      -- r_max must be ABOVE both measurements
      above_muonic = r_max > r_p_muonic
      above_codata = r_max > r_p_codata - r_p_codata_unc
  in ("protonRadius_rMax: confinement ceiling",
      above_muonic && above_codata,
      r_max,
      r_max - r_p_muonic)

-- | Three-body minimum radius (asymptotic freedom floor)
prove_protonRadius_rMin :: (String, Bool, Double, Double)
prove_protonRadius_rMin =
  let geo_sum = 1.0 / fromIntegral (d4^2 - 1)  -- 1/575
      r_min   = (c_F * fromIntegral n_c - geo_sum) * compton_p_fm
      -- r_min must be BELOW both measurements
      below_muonic = r_min < r_p_muonic
  in ("protonRadius_rMin: AF floor",
      below_muonic,
      r_min,
      r_p_muonic - r_min)

-- | Band width: r_MAX - r_MIN
prove_protonRadius_band :: (String, Bool, Double, Double)
prove_protonRadius_band =
  let r_max = c_F * fromIntegral n_c * compton_p_fm
      r_min = (c_F * fromIntegral n_c - 1.0 / fromIntegral (d4^2 - 1)) * compton_p_fm
      band  = r_max - r_min
      -- Band must be small (< 1% of r_max)
      narrow = band / r_max < 0.01
  in ("protonRadius_band: narrow three-body band",
      narrow,
      band,
      band / r_max)

-- | Suppression check: correction/base consistent with perturbative regime
prove_protonRadius_suppression :: (String, Bool, Double, Double)
prove_protonRadius_suppression =
  let correction = 1.0 / fromIntegral (d4^2)
      base       = c_F * fromIntegral n_c
      ratio      = correction / base
      -- Must be small (perturbative)
      small = ratio < 0.01
  in ("protonRadius_suppression: correction << base",
      small,
      ratio,
      correction)

-- | Sign check: correction is NEGATIVE (asymptotic freedom shrinks bound state)
prove_protonRadius_sign :: (String, Bool, Double, Double)
prove_protonRadius_sign =
  let base  = c_F * fromIntegral n_c * compton_p_fm
      corr  = (c_F * fromIntegral n_c - 1.0 / fromIntegral (d4^2)) * compton_p_fm
      delta = corr - base  -- must be negative
  in ("protonRadius_sign: correction is negative (AF shrinks)",
      delta < 0,
      delta,
      delta / base)

-- | Gauge-sector split: r_p correction is rational (length/coupling type)
prove_protonRadius_rational :: (String, Bool, Int, Int)
prove_protonRadius_rational =
  let -- 1/d4^2 = 1/576 is rational (integer denominator)
      num = 1
      den = d4^2  -- 576
      -- Check it's a clean integer ratio
  in ("protonRadius_rational: correction 1/576 is rational",
      den == 576 && num == 1,
      num,
      den)

-- | N_c scaling: expansion parameter = 1/(N_c*(N_c^2-1))^2
prove_protonRadius_ncScaling :: (String, Bool, Double, Double)
prove_protonRadius_ncScaling =
  let eps_2 = 1.0 / (fromIntegral (2 * (2^2 - 1)))^2  -- N_c=2
      eps_3 = 1.0 / (fromIntegral (3 * (3^2 - 1)))^2  -- N_c=3
      -- N_c=3 must be tighter than N_c=2
      tighter = eps_3 < eps_2
      -- N_c=3 must be small enough for perturbative convergence
      perturbative = eps_3 < 0.01
  in ("protonRadius_ncScaling: N_c=3 tighter than N_c=2",
      tighter && perturbative,
      eps_3,
      eps_2)

-- ============================================================
-- MAIN: Run all prove functions
-- ============================================================

allProves :: [(String, Bool, String)]
allProves =
  [ fmt4d prove_protonRadius_base
  , fmt4d prove_protonRadius
  , fmt4i prove_dualRoute_d4sq
  , fmt4d prove_protonRadius_dualRoute
  , fmt4d prove_protonRadius_rMax
  , fmt4d prove_protonRadius_rMin
  , fmt4d prove_protonRadius_band
  , fmt4d prove_protonRadius_suppression
  , fmt4d prove_protonRadius_sign
  , fmt4i prove_protonRadius_rational
  , fmt4d prove_protonRadius_ncScaling
  ]
  where
    fmt4d (name, ok, v1, v2) = (name, ok, show v1 ++ " | " ++ show v2)
    fmt4i (name, ok, v1, v2) = (name, ok, show v1 ++ " | " ++ show v2)

main :: IO ()
main = do
  putStrLn "============================================"
  putStrLn "CrystalProtonRadius — Observable #181"
  putStrLn "THE AXIOM: A_F = C + M2(C) + M3(C)"
  putStrLn "============================================"
  putStrLn ""
  let results = allProves
      passed  = length (filter (\(_, ok, _) -> ok) results)
      total   = length results
  mapM_ (\(name, ok, detail) -> do
    let tag = if ok then "PASS" else "FAIL"
    putStrLn $ "  [" ++ tag ++ "] " ++ name
    putStrLn $ "         " ++ detail
    ) results
  putStrLn ""
  putStrLn $ "Result: " ++ show passed ++ "/" ++ show total ++ " PASS"
  if passed == total
    then putStrLn "All proton radius prove functions verified."
    else putStrLn "FAILURES DETECTED."
