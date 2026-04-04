-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableAlphaProton.hs — Component 7 (AlphaProton)

  MULTIPLE INDEPENDENT ROUTES to alpha^-1, m_p/m_e, sin^2 theta_W.
  Three derivation methods (SINDy, HMC, corrected a4) all converge.
  This is the source of pride: independent paths → same answers.

  All dimensionless (Shift = 0). No VEV dependence.
  a4 corrections use Sigma_d^2 = 650 (Seeley-DeWitt a4 coefficient).

  Compile: ghc -O2 -main-is ObservableAlphaProton ObservableAlphaProton.hs && ./ObservableAlphaProton
-}

module ObservableAlphaProton (allAlphaProton, main) where

import CrystalAtoms hiding (main)
import CrystalCorrections (CLevel(..))
import Numeric (showFFloat, showGFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE
-- =====================================================================

type Formula = Double -> Double

data Obs = Obs
  { oName :: String, oForm :: String
  , oCry :: Double, oCryPdg :: Double, oExpt :: Double
  , oLvl :: CLevel }

shiftPct :: Obs -> Double
shiftPct o
  | abs (oCry o) < 1e-20 = 0.0
  | otherwise = abs (oCryPdg o - oCry o) / abs (oCry o) * 100.0

gapPct :: Obs -> Double
gapPct o = abs (oExpt o - oCryPdg o) / abs (oExpt o) * 100.0

mk :: String -> String -> Formula -> Double -> CLevel -> Obs
mk nm fm f ex lv = Obs nm fm (f vCry) (f vPdg) ex lv

vCry :: Double
vCry = 1.220890e19 * fromIntegral (sigmaD - 1)
     / fromIntegral (towerD + 1) / sigmaD_d
     / (2.0 ** fromIntegral (towerD + d3))

vPdg :: Double
vPdg = 246.22

-- Seeley-DeWitt a4 invariant: sigmaD2_d from CrystalAtoms = 650
-- (d1^2 + d2^2 + d3^2 + d4^2 = 1 + 9 + 64 + 576 = 650)

-- =====================================================================
-- alpha^-1: THREE ROUTES
-- =====================================================================

-- | Route 1 (Tower): (D+1)*pi + ln(beta0) = 43*pi + ln(7)
obsAlphaInvTower :: Obs
obsAlphaInvTower = mk "a^-1 (Tower)" "(D+1)*pi+ln(b0)"
  (\_ -> fromIntegral (towerD + 1) * pi + log beta0_d)
  137.035999084 SinglePi

-- | Route 2 (SINDy): 2*(gauss^2+d4)/pi + (d3^ln3)/ln2
obsAlphaInvSINDy :: Obs
obsAlphaInvSINDy = mk "a^-1 (SINDy)" "2(g^2+d4)/pi+(d3^ln3)/ln2"
  (\_ -> 2.0 * (gauss_d * gauss_d + d4_d) / pi
       + d3_d ** log 3.0 / log 2.0)
  137.035999084 KappaOrLn

-- | Route 3 (HMC base): Sd^ln3 * pi - d4
obsAlphaInvHMC :: Obs
obsAlphaInvHMC = mk "a^-1 (HMC)" "Sd^ln3*pi - d4"
  (\_ -> sigmaD_d ** log 3.0 * pi - d4_d)
  137.035999084 KappaOrLn

-- | Route 4 (SINDy + a4 correction): - 1/(chi*d4*Sd2*D)
obsAlphaInvCorr :: Obs
obsAlphaInvCorr = mk "a^-1 (a4 corr)" "SINDy-1/(chi*d4*Sd2*D)"
  (\_ -> let base = 2.0 * (gauss_d * gauss_d + d4_d) / pi
                  + d3_d ** log 3.0 / log 2.0
             corr = 1.0 / (chi_d * d4_d * sigmaD2_d * towerD_d)
         in base - corr)
  137.035999084 Composite

-- =====================================================================
-- m_p/m_e: THREE ROUTES
-- =====================================================================

-- | Route 1 (SINDy): 2*(D^2+Sd)/d3 + gauss^Nc/kappa
obsMpMeSINDy :: Obs
obsMpMeSINDy = mk "mp/me (SINDy)" "2(D^2+Sd)/d3+g^Nc/kap"
  (\_ -> 2.0 * (towerD_d * towerD_d + sigmaD_d) / d3_d
       + gauss_d ** nC_d / kappa)
  1836.15267343 KappaOrLn

-- | Route 2 (HMC): chi*pi^5 + sqrt(ln2)/d4
obsMpMeHMC :: Obs
obsMpMeHMC = mk "mp/me (HMC)" "chi*pi^5+sln2/d4"
  (\_ -> chi_d * pi ** 5 + sqrt (log 2.0) / d4_d)
  1836.15267343 KappaOrLn

-- | Route 3 (SINDy + a4 correction): + kappa/(Nw*chi*Sd2*D)
obsMpMeCorr :: Obs
obsMpMeCorr = mk "mp/me (a4 corr)" "SINDy+kap/(Nw*chi*Sd2*D)"
  (\_ -> let base = 2.0 * (towerD_d * towerD_d + sigmaD_d) / d3_d
                  + gauss_d ** nC_d / kappa
             corr = kappa / (nW_d * chi_d * sigmaD2_d * towerD_d)
         in base + corr)
  1836.15267343 Composite

-- =====================================================================
-- sin^2 theta_W: BASE + CORRECTED
-- =====================================================================

-- | Base: N_c/gauss = 3/13
obsSin2twBase :: Obs
obsSin2twBase = mk "sin2tw (base)" "Nc/gauss = 3/13"
  (\_ -> nC_d / gauss_d)
  0.23122 ExactRational

-- | Corrected: 3/13 + 7/15600 (a4 level)
obsSin2twCorr :: Obs
obsSin2twCorr = mk "sin2tw (a4 corr)" "3/13+b0/(d4*Sd2)"
  (\_ -> nC_d / gauss_d + beta0_d / (d4_d * sigmaD2_d))
  0.23122 Composite

-- =====================================================================
-- ALL
-- =====================================================================

allAlphaProton :: [Obs]
allAlphaProton =
  -- alpha^-1 (4 routes)
  [ obsAlphaInvTower, obsAlphaInvSINDy, obsAlphaInvHMC, obsAlphaInvCorr
  -- m_p/m_e (3 routes)
  , obsMpMeSINDy, obsMpMeHMC, obsMpMeCorr
  -- sin^2 theta_W (2 routes)
  , obsSin2twBase, obsSin2twCorr
  ]

-- =====================================================================
-- OUTPUT
-- =====================================================================

check :: String -> Bool -> IO ()
check nm True  = putStrLn $ "  PASS  " ++ nm
check nm False = putStrLn $ "  FAIL  " ++ nm

pr :: Int -> String -> String
pr w s = s ++ replicate (max 0 (w - length s)) ' '

pl :: Int -> String -> String
pl w s = replicate (max 0 (w - length s)) ' ' ++ s

fv :: Int -> Double -> String
fv w x = pr w (showGFloat (Just 8) x "")

fp :: Double -> String
fp x = showFFloat (Just 6) x "%"

rat :: Double -> String
rat p | p < 0.0001 = "EXACT" | p < 0.001 = "SUB-PPM"
      | p < 0.01  = "PPM"    | p < 0.5   = "TIGHT"
      | p < 1.0   = "GOOD"   | otherwise  = "LOOSE"

row :: Obs -> IO ()
row o = putStrLn $
  "  " ++ pr 20 (oName o)
       ++ pr 26 (oForm o)
       ++ fv 16 (oCry o)
       ++ fv 16 (oCryPdg o)
       ++ fv 16 (oExpt o)
       ++ pl 12 (fp (shiftPct o))
       ++ pl 14 (fp (gapPct o))
       ++ "  " ++ rat (gapPct o)

ppm :: Double -> Double -> String
ppm got ref = showFFloat (Just 2) (abs (got - ref) / abs ref * 1e6) " ppm"

main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableAlphaProton.hs -- Component 7 (AlphaProton)"
  putStrLn " Multiple routes to alpha^-1, m_p/m_e, sin^2 theta_W."
  putStrLn " a4 correction = Seeley-DeWitt Sigma_d^2 = 650."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 26 "Formula"
           ++ pr 16 "Crystal" ++ pr 16 "CrystalPdg" ++ pr 16 "Expt"
           ++ pl 12 "Shift" ++ pl 14 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 130 '-'

  putStrLn "  --- alpha^-1 (4 independent routes) ---"
  mapM_ row (take 4 allAlphaProton)
  putStrLn "  --- m_p/m_e (3 independent routes) ---"
  mapM_ row (take 3 (drop 4 allAlphaProton))
  putStrLn "  --- sin^2 theta_W (base + corrected) ---"
  mapM_ row (drop 7 allAlphaProton)
  putStrLn ""

  -- PPM-level comparison
  putStrLn "  High-precision comparison (ppm):"
  putStrLn $ "    a^-1 Tower:    " ++ ppm (oCry obsAlphaInvTower)  137.035999084
  putStrLn $ "    a^-1 SINDy:    " ++ ppm (oCry obsAlphaInvSINDy) 137.035999084
  putStrLn $ "    a^-1 HMC:      " ++ ppm (oCry obsAlphaInvHMC)   137.035999084
  putStrLn $ "    a^-1 a4-corr:  " ++ ppm (oCry obsAlphaInvCorr)  137.035999084
  putStrLn $ "    mp/me SINDy:   " ++ ppm (oCry obsMpMeSINDy)     1836.15267343
  putStrLn $ "    mp/me HMC:     " ++ ppm (oCry obsMpMeHMC)       1836.15267343
  putStrLn $ "    mp/me a4-corr: " ++ ppm (oCry obsMpMeCorr)      1836.15267343
  putStrLn ""

  -- Integer identities
  putStrLn "  Seeley-DeWitt integers:"
  putStrLn $ "    Sigma_d^2 = " ++ show (round sigmaD2_d :: Int) ++ " (a4 invariant)"
  let alphaCorr = round (chi_d * d4_d * sigmaD2_d * towerD_d) :: Int
  let mpmeCorr  = round (nW_d * chi_d * sigmaD2_d * towerD_d) :: Int
  putStrLn $ "    alpha corr denom = " ++ show alphaCorr ++ " = chi*d4*Sd2*D"
  putStrLn $ "    mp/me corr denom = " ++ show mpmeCorr ++ " = Nw*chi*Sd2*D"
  putStrLn $ "    ratio = " ++ show (alphaCorr `div` mpmeCorr) ++ " = d4/Nw"
  putStrLn ""

  check "All Shift = 0" (all (\o -> shiftPct o < 1e-10) allAlphaProton)
  check "All Gap < 1%" (all (\o -> gapPct o < 1.0) allAlphaProton)
  check "Sd2 = 650" (round sigmaD2_d == (650 :: Int))
  check "alpha corr = 3931200" (alphaCorr == 3931200)
  check "mp/me corr = 327600" (mpmeCorr == 327600)
  putStrLn ""

  let gs = map gapPct allAlphaProton
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 6) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 6) (maximum gs) "%"
  putStrLn "=================================================================="
