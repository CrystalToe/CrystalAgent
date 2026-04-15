-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableCondensed.hs — Component 7 (Condensed)

  BCS superconductivity, Ising model, thermodynamics, chaos,
  mathematical constants. ALL dimensionless (Shift = 0).
  No corrections, no implosion.

  Compile: ghc -O2 -main-is ObservableCondensed ObservableCondensed.hs && ./ObservableCondensed
-}

module ObservableCondensed (allCondensed, main) where

import CrystalAtoms hiding (main)
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE (same pattern)
-- =====================================================================

-- =====================================================================
-- SUPERCONDUCTIVITY / BCS
-- =====================================================================

-- | BCS gap ratio = 2pi/e^gamma where gamma = 7/12 - 1/167
obsBCS :: Obs
obsBCS = mk "BCS 2D/(kBTc)" "2pi/e^gamma"
  (\_ -> let gamma = beta0_d / (gauss_d - 1.0)
                   - 1.0 / (gauss_d * gauss_d - nW_d)
         in 2.0 * pi / exp gamma)
  3.528 SinglePi

-- | Euler-Mascheroni gamma = 7/12 - 1/167
obsEuler :: Obs
obsEuler = mk "gamma (E-M)" "b0/(gauss-1) - 1/(gauss^2-Nw)"
  (\_ -> beta0_d / (gauss_d - 1.0)
       - 1.0 / (gauss_d * gauss_d - nW_d))
  0.5772 KappaOrLn

-- =====================================================================
-- ISING MODEL
-- =====================================================================

-- | Ising spin states = N_w = 2
obsIsingSpin :: Obs
obsIsingSpin = mk "Ising states" "N_w = 2"
  (\_ -> nW_d) 2.0 ExactInteger

-- | 2D Ising critical exponent beta = 1/N_w^3 = 1/8
obsIsingBeta :: Obs
obsIsingBeta = mk "Ising crit beta" "1/N_w^3 = 1/8"
  (\_ -> 1.0 / (nW_d ** 3)) 0.125 ExactRational

-- | Cubic coordination z = chi = 6
obsCubicZ :: Obs
obsCubicZ = mk "Cubic z" "chi = 6"
  (\_ -> chi_d) 6.0 ExactInteger

-- =====================================================================
-- THERMODYNAMICS
-- =====================================================================

-- | Carnot efficiency = (chi-1)/chi = 5/6
obsCarnot :: Obs
obsCarnot = mk "Carnot eff" "(chi-1)/chi = 5/6"
  (\_ -> (chi_d - 1.0) / chi_d) (5.0/6.0) ExactRational

-- | Stefan-Boltzmann = N_w * N_c * (gauss + beta0) = 120
obsStefan :: Obs
obsStefan = mk "Stefan-Boltzmann" "Nw*Nc*(gauss+b0) = 120"
  (\_ -> nW_d * nC_d * (gauss_d + beta0_d)) 120.0 ExactInteger

-- | Thermal conductivity k = chi*(chi-1)*chi / Sd = 5
obsThermal :: Obs
obsThermal = mk "Thermal k" "chi^2*(chi-1)/Sd = 5"
  (\_ -> chi_d * chi_d * (chi_d - 1.0) / sigmaD_d) 5.0 ExactRational

-- | Chandrasekhar mass = (gauss+chi)/gauss = 19/13
obsChandrasekhar :: Obs
obsChandrasekhar = mk "Chandrasekhar M" "(gauss+chi)/gauss = 19/13"
  (\_ -> (gauss_d + chi_d) / gauss_d) 1.46 ExactRational

-- =====================================================================
-- CHAOS / CROSS-DOMAIN
-- =====================================================================

-- | Feigenbaum delta = D/N_c^2 = 42/9 = 14/3
obsFeigenbaum :: Obs
obsFeigenbaum = mk "Feigenbaum d" "D/N_c^2 = 14/3"
  (\_ -> towerD_d / (nC_d * nC_d)) 4.6692 ExactRational

-- | Routh critical ratio = 1/(gauss+b0+chi) = 1/26
obsRouth :: Obs
obsRouth = mk "Routh ratio" "1/(gauss+b0+chi) = 1/26"
  (\_ -> 1.0 / (gauss_d + beta0_d + chi_d)) 0.0385 ExactRational

-- =====================================================================
-- MATHEMATICAL CONSTANTS
-- =====================================================================

-- | Golden ratio phi = gauss/N_w^3 - 1/(gauss*N_w*b0) = 13/8 - 1/182
obsPhi :: Obs
obsPhi = mk "phi (golden)" "13/8 - 1/182"
  (\_ -> gauss_d / (nW_d ** 3)
       - 1.0 / (gauss_d * nW_d * beta0_d))
  1.6180 KappaOrLn

-- | Apery zeta(3) = chi/(chi-1) = 6/5
obsZeta3 :: Obs
obsZeta3 = mk "zeta(3) Apery" "chi/(chi-1) = 6/5"
  (\_ -> chi_d / (chi_d - 1.0)) 1.2021 ExactRational

-- | Catalan G = 1 - N_w^2/(D+chi) = 1 - 4/48 = 11/12
obsCatalan :: Obs
obsCatalan = mk "Catalan G" "1 - Nw^2/(D+chi) = 11/12"
  (\_ -> 1.0 - nW_d * nW_d / (towerD_d + chi_d)) 0.9160 ExactRational

-- =====================================================================
-- QED
-- =====================================================================

-- | Electron g-2: a_e = alpha/(2pi)
obsElectronG2 :: Obs
obsElectronG2 = mk "a_e (g-2)" "alpha/(2pi)"
  (\_ -> let alphaInv = fromIntegral (towerD + 1) * pi + log beta0_d
         in 1.0 / alphaInv / (2.0 * pi))
  0.00115966 SinglePi

-- =====================================================================
-- ALL
-- =====================================================================

allCondensed :: [Obs]
allCondensed =
  -- Superconductivity
  [ obsBCS, obsEuler
  -- Ising
  , obsIsingSpin, obsIsingBeta, obsCubicZ
  -- Thermodynamics
  , obsCarnot, obsStefan, obsThermal, obsChandrasekhar
  -- Chaos
  , obsFeigenbaum, obsRouth
  -- Math constants
  , obsPhi, obsZeta3, obsCatalan
  -- QED
  , obsElectronG2
  ]

-- =====================================================================
-- OUTPUT
-- =====================================================================


main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableCondensed.hs -- Component 7 (Condensed)"
  putStrLn " BCS, Ising, thermo, chaos, math. All dimensionless."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 30 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 122 '-'

  putStrLn "  --- Superconductivity ---"
  mapM_ row (take 2 allCondensed)
  putStrLn "  --- Ising Model ---"
  mapM_ row (take 3 (drop 2 allCondensed))
  putStrLn "  --- Thermodynamics ---"
  mapM_ row (take 4 (drop 5 allCondensed))
  putStrLn "  --- Chaos / Cross-domain ---"
  mapM_ row (take 2 (drop 9 allCondensed))
  putStrLn "  --- Math Constants ---"
  mapM_ row (take 3 (drop 11 allCondensed))
  putStrLn "  --- QED ---"
  mapM_ row (drop 14 allCondensed)
  putStrLn ""

  check "All Shift = 0" (all (\o -> shiftPct o < 1e-10) allCondensed)
  check "BCS ~ 3.527" (abs (oCry obsBCS - 3.527) < 0.01)
  check "Ising beta = 1/8" (abs (oCry obsIsingBeta - 0.125) < 1e-14)
  check "Carnot = 5/6" (abs (oCry obsCarnot - 5.0/6.0) < 1e-14)
  check "Stefan = 120" (abs (oCry obsStefan - 120.0) < 1e-10)
  check "Feigenbaum = 14/3" (abs (oCry obsFeigenbaum - 14.0/3.0) < 1e-14)
  check "zeta(3) = 6/5" (abs (oCry obsZeta3 - 6.0/5.0) < 1e-14)
  putStrLn ""

  let gs = map gapPct allCondensed
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 3) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum gs) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) gs))
           ++ "/" ++ show (length gs)
  putStrLn "=================================================================="
