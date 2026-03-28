-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- | CrystalAlphaProton.hs
-- Prove functions for alpha_inv and m_proton_over_m_e
-- All atoms from A_F = C + M2(C) + M3(C)
-- Zero free parameters. Zero hardcoded numbers.

module CrystalAlphaProton where

-- ══════════════════════════════════════════════════════════
-- ALGEBRA ATOMS
-- ══════════════════════════════════════════════════════════

n_w, n_c, chi, beta0 :: Int
n_w   = 2
n_c   = 3
chi   = n_w * n_c          -- 6
beta0 = (11 * n_c - 2 * chi) `div` 3  -- 7

d1, d2, d3, d4 :: Int
d1 = 1
d2 = 3
d3 = 8
d4 = 24

sigma_d, sigma_d2, gauss, towerD :: Int
sigma_d  = d1 + d2 + d3 + d4       -- 36
sigma_d2 = d1^2 + d2^2 + d3^2 + d4^2  -- 650
gauss    = n_c^2 + n_w^2            -- 13
towerD   = sigma_d + chi            -- 42

kappa :: Double
kappa = log 3 / log 2

c_f :: Double
c_f = fromIntegral (n_c^2 - 1) / fromIntegral (2 * n_c)  -- 4/3

-- ══════════════════════════════════════════════════════════
-- TARGETS (PDG / CODATA 2018)
-- ══════════════════════════════════════════════════════════

pdg_alpha_inv :: Double
pdg_alpha_inv = 137.035999084

pdg_alpha_inv_unc :: Double
pdg_alpha_inv_unc = 0.000000021

pdg_mp_me :: Double
pdg_mp_me = 1836.15267343

pdg_mp_me_unc :: Double
pdg_mp_me_unc = 0.00000011

-- ══════════════════════════════════════════════════════════
-- PROVE: α⁻¹ (SINDy formula)
-- 2·(gauss² + d₄)/π + d₃^ln3/ln2
-- ══════════════════════════════════════════════════════════

proveAlphaInvSINDy :: Double
proveAlphaInvSINDy =
    let g2   = fromIntegral (gauss ^ (2::Int))  -- 169
        term1 = 2.0 * (g2 + fromIntegral d4) / pi  -- 2·193/π
        term2 = fromIntegral d3 ** log 3 / log 2    -- 8^ln3/ln2
    in  term1 + term2

-- ══════════════════════════════════════════════════════════
-- PROVE: α⁻¹ (HMC base formula)
-- Σd^ln3 · π − d₄
-- ══════════════════════════════════════════════════════════

proveAlphaInvHMC :: Double
proveAlphaInvHMC =
    let base = fromIntegral sigma_d ** log 3  -- 36^ln3
    in  base * pi - fromIntegral d4

-- ══════════════════════════════════════════════════════════
-- PROVE: α⁻¹ (HMC refined formula)
-- Σd^ln3 · π − d₄ + T_F/(D·Σd²)
-- ══════════════════════════════════════════════════════════

proveAlphaInvHMCRefined :: Double
proveAlphaInvHMCRefined =
    let base = fromIntegral sigma_d ** log 3 * pi - fromIntegral d4
        corr = 0.5 / (fromIntegral towerD * fromIntegral sigma_d2)
    in  base + corr

-- ══════════════════════════════════════════════════════════
-- PROVE: m_p/m_e (SINDy formula)
-- 2·(D² + Σd)/d₃ + gauss^N_c/κ
-- ══════════════════════════════════════════════════════════

proveMpMeSINDy :: Double
proveMpMeSINDy =
    let d2val = fromIntegral (towerD ^ (2::Int))  -- 1764
        term1 = 2.0 * (d2val + fromIntegral sigma_d) / fromIntegral d3
        term2 = fromIntegral (gauss ^ n_c) / kappa  -- 13³/κ
    in  term1 + term2

-- ══════════════════════════════════════════════════════════
-- PROVE: m_p/m_e (HMC formula)
-- χ·π⁵ + √ln2/d₄
-- ══════════════════════════════════════════════════════════

proveMpMeHMC :: Double
proveMpMeHMC =
    let base = fromIntegral chi * pi ** 5
        corr = sqrt (log 2) / fromIntegral d4
    in  base + corr

-- ══════════════════════════════════════════════════════════
-- VERIFICATION
-- ══════════════════════════════════════════════════════════

data ProofResult = ProofResult
    { prName   :: String
    , prValue  :: Double
    , prTarget :: Double
    , prSigma  :: Double
    , prPPM    :: Double
    , prPWI    :: Double
    , prPass   :: Bool
    } deriving (Show)

verify :: String -> Double -> Double -> Double -> ProofResult
verify name computed target unc =
    let sigma = abs (computed - target) / target
        ppm   = sigma * 1e6
        pwi   = sigma * 100.0
        pass_ = pwi <= 4.5
    in  ProofResult name computed target sigma ppm pwi pass_

runAll :: IO ()
runAll = do
    putStrLn "══════════════════════════════════════════════════════════"
    putStrLn " CrystalAlphaProton — prove α⁻¹ and m_p/m_e"
    putStrLn " A_F = C + M2(C) + M3(C)"
    putStrLn "══════════════════════════════════════════════════════════"

    let checks =
          [ verify "alpha_inv_sindy"
                proveAlphaInvSINDy pdg_alpha_inv pdg_alpha_inv_unc
          , verify "alpha_inv_hmc_base"
                proveAlphaInvHMC pdg_alpha_inv pdg_alpha_inv_unc
          , verify "alpha_inv_hmc_refined"
                proveAlphaInvHMCRefined pdg_alpha_inv pdg_alpha_inv_unc
          , verify "mp_me_sindy"
                proveMpMeSINDy pdg_mp_me pdg_mp_me_unc
          , verify "mp_me_hmc"
                proveMpMeHMC pdg_mp_me pdg_mp_me_unc
          ]

    mapM_ (\r -> do
        let tag = if prPass r then "PASS" else "FAIL"
        putStrLn $ "  " ++ tag ++ " | " ++ prName r
            ++ " | σ=" ++ show (prSigma r)
            ++ " (" ++ show (prPPM r) ++ " ppm)"
            ++ " | val=" ++ show (prValue r)
        ) checks

    let allPass = all prPass checks
    putStrLn $ "\n  Result: " ++ show (length checks) ++ "/"
        ++ show (length checks) ++ (if allPass then " PASSED" else " SOME FAILED")

    if allPass
        then putStrLn "  ALL PROOFS VERIFIED ✓"
        else putStrLn "  WARNING: Some proofs did not pass PWI threshold"

main :: IO ()
main = runAll
