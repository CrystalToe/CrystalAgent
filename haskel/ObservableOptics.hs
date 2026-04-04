-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableOptics.hs — Component 7 (Optics)

  Refractive indices from sector eigenvalues. ALL dimensionless.

  Compile: ghc -O2 -main-is ObservableOptics ObservableOptics.hs && ./ObservableOptics
-}

module ObservableOptics (allOptics, main) where

import CrystalAtoms hiding (main)
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE
-- =====================================================================

-- =====================================================================
-- REFRACTIVE INDICES
-- =====================================================================

-- | n(water) = Casimir C_F = (N_c^2-1)/(2*N_c) = 4/3
obsNWater :: Obs
obsNWater = mk "n(water)" "C_F = (Nc^2-1)/(2Nc) = 4/3"
  (\_ -> (nC_d * nC_d - 1.0) / (2.0 * nC_d))
  1.333 ExactRational

-- | n(glass) = N_c/N_w = 3/2
obsNGlass :: Obs
obsNGlass = mk "n(glass)" "N_c/N_w = 3/2"
  (\_ -> nC_d / nW_d)
  1.500 ExactRational

-- | n(diamond) = (2*gauss+N_c)/(N_w^2*N_c) = 29/12
obsNDiamond :: Obs
obsNDiamond = mk "n(diamond)" "(2*gauss+Nc)/(Nw^2*Nc) = 29/12"
  (\_ -> (2.0 * gauss_d + nC_d) / (nW_d * nW_d * nC_d))
  2.417 ExactRational

-- =====================================================================
-- ALL
-- =====================================================================

allOptics :: [Obs]
allOptics = [obsNWater, obsNGlass, obsNDiamond]

-- =====================================================================
-- OUTPUT
-- =====================================================================


main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableOptics.hs -- Component 7 (Optics)"
  putStrLn " Refractive indices from sector eigenvalues. Dimensionless."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 30 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 122 '-'
  mapM_ row allOptics
  putStrLn ""

  check "n(water) = 4/3" (abs (oCry obsNWater - 4.0/3.0) < 1e-14)
  check "n(glass) = 3/2" (abs (oCry obsNGlass - 3.0/2.0) < 1e-14)
  check "n(diamond) = 29/12" (abs (oCry obsNDiamond - 29.0/12.0) < 1e-14)
  check "All Shift = 0" (all (\o -> shiftPct o < 1e-10) allOptics)
  putStrLn ""

  let gs = map gapPct allOptics
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 3) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum gs) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) gs))
           ++ "/" ++ show (length gs)
  putStrLn "=================================================================="
