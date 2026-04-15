-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableFluid.hs — Component 7 (Fluid)

  Fluid dynamics, wave scattering, scaling laws.
  ALL dimensionless (Shift = 0). No corrections.

  Compile: ghc -O2 -main-is ObservableFluid ObservableFluid.hs && ./ObservableFluid
-}

module ObservableFluid (allFluid, main) where

import CrystalAtoms hiding (main)
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE
-- =====================================================================

-- =====================================================================
-- TURBULENCE (Kolmogorov)
-- =====================================================================

obsKolmogorov :: Obs
obsKolmogorov = mk "Kolmo -5/3 exp" "(Nc+Nw)/Nc = 5/3"
  (\_ -> (nC_d + nW_d) / nC_d) (5.0/3.0) ExactRational

obsKolmoMicro :: Obs
obsKolmoMicro = mk "Kolmo micro 1/4" "1/N_w^2 = 1/4"
  (\_ -> 1.0 / (nW_d * nW_d)) 0.25 ExactRational

obsVonKarman :: Obs
obsVonKarman = mk "Von Karman" "Nw/(Nc+Nw) = 2/5"
  (\_ -> nW_d / (nC_d + nW_d)) 0.40 ExactRational

-- =====================================================================
-- PIPE FLOW
-- =====================================================================

obsReynolds :: Obs
obsReynolds = mk "Re_c (pipe)" "D*(D+gauss) = 42*55"
  (\_ -> towerD_d * (towerD_d + gauss_d)) 2300.0 ExactRational

obsPrandtl :: Obs
obsPrandtl = mk "Prandtl (air)" "b0/(g-Nc) + Nw/(g^2-Nw)"
  (\_ -> beta0_d / (gauss_d - nC_d)
       + nW_d / (gauss_d * gauss_d - nW_d))
  0.713 ExactRational

-- =====================================================================
-- SCALING LAWS
-- =====================================================================

obsBlasius :: Obs
obsBlasius = mk "Blasius exp" "1/(Nc+1) = 1/4"
  (\_ -> 1.0 / (nC_d + 1.0)) 0.25 ExactRational

obsKleiber :: Obs
obsKleiber = mk "Kleiber exp" "Nc/(Nc+1) = 3/4"
  (\_ -> nC_d / (nC_d + 1.0)) 0.75 ExactRational

obsBenford :: Obs
obsBenford = mk "Benford P(1)" "log10(Nw) = log10(2)"
  (\_ -> log nW_d / log 10.0) 0.30103 KappaOrLn

-- =====================================================================
-- WAVE SCATTERING (Rayleigh + Planck)
-- =====================================================================

obsPlanckExp :: Obs
obsPlanckExp = mk "Planck lam exp" "chi-1 = 5"
  (\_ -> chi_d - 1.0) 5.0 ExactInteger

obsRayleighSize :: Obs
obsRayleighSize = mk "Rayleigh size" "chi = 6"
  (\_ -> chi_d) 6.0 ExactInteger

obsRayleighLam :: Obs
obsRayleighLam = mk "Rayleigh lam" "N_w^2 = 4"
  (\_ -> nW_d * nW_d) 4.0 ExactInteger

-- =====================================================================
-- ALL
-- =====================================================================

allFluid :: [Obs]
allFluid =
  [ obsKolmogorov, obsKolmoMicro, obsVonKarman
  , obsReynolds, obsPrandtl
  , obsBlasius, obsKleiber, obsBenford
  , obsPlanckExp, obsRayleighSize, obsRayleighLam
  ]

-- =====================================================================
-- OUTPUT
-- =====================================================================


main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableFluid.hs -- Component 7 (Fluid)"
  putStrLn " Turbulence, pipe flow, scaling, scattering. All dimensionless."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 30 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 122 '-'

  putStrLn "  --- Turbulence ---"
  mapM_ row (take 3 allFluid)
  putStrLn "  --- Pipe Flow ---"
  mapM_ row (take 2 (drop 3 allFluid))
  putStrLn "  --- Scaling Laws ---"
  mapM_ row (take 3 (drop 5 allFluid))
  putStrLn "  --- Wave Scattering ---"
  mapM_ row (drop 8 allFluid)
  putStrLn ""

  check "All Shift = 0" (all (\o -> shiftPct o < 1e-10) allFluid)
  check "Kolmo = 5/3" (abs (oCry obsKolmogorov - 5.0/3.0) < 1e-14)
  check "Re_c = 2310" (abs (oCry obsReynolds - 2310.0) < 1e-10)
  check "Blasius + Kleiber = 1" (abs (oCry obsBlasius + oCry obsKleiber - 1.0) < 1e-14)
  putStrLn ""

  let gs = map gapPct allFluid
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 3) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum gs) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) gs))
           ++ "/" ++ show (length gs)
  putStrLn "=================================================================="
