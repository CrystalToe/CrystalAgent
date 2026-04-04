-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableType.hs — Shared types for all Observable modules.

  Defines Obs, Formula, VEV constants, gap/shift, formatting, rating.
  Imported by every Observable*.hs. One definition, zero copy-paste.
-}

module ObservableType
  ( -- Types
    Formula, Obs(..)
    -- CLevel re-export
  , CLevel(..)
    -- VEV constants
  , vCry, vPdg
    -- Metrics
  , shiftPct, gapPct
    -- Constructor
  , mk
    -- Output helpers
  , row, header, check, pr, pl, fv, fp, rat
  ) where

import CrystalAtoms (sigmaD, towerD, d3, sigmaD_d)
import CrystalCorrections (CLevel(..))
import Numeric (showFFloat, showGFloat)

-- =====================================================================
-- TYPES
-- =====================================================================

type Formula = Double -> Double

data Obs = Obs
  { oName    :: String
  , oForm    :: String
  , oCry     :: Double    -- f(v_crystal)
  , oCryPdg  :: Double    -- f(v_pdg)
  , oExpt    :: Double
  , oLvl     :: CLevel
  }

-- =====================================================================
-- VEV CONSTANTS
-- =====================================================================

vCry :: Double
vCry = 1.220890e19 * fromIntegral (sigmaD - 1)
     / fromIntegral (towerD + 1) / sigmaD_d
     / (2.0 ** fromIntegral (towerD + d3))

vPdg :: Double
vPdg = 246.22

-- =====================================================================
-- METRICS
-- =====================================================================

-- | Shift = |CrystalPdg - Crystal| / Crystal (VEV scheme noise)
shiftPct :: Obs -> Double
shiftPct o
  | abs (oCry o) < 1e-20 = 0.0
  | otherwise = abs (oCryPdg o - oCry o) / abs (oCry o) * 100.0

-- | Gap = |Expt - CrystalPdg| / Expt (formula accuracy, Status follows)
gapPct :: Obs -> Double
gapPct o = abs (oExpt o - oCryPdg o) / abs (oExpt o) * 100.0

-- =====================================================================
-- CONSTRUCTOR
-- =====================================================================

mk :: String -> String -> Formula -> Double -> CLevel -> Obs
mk nm fm f ex lv = Obs nm fm (f vCry) (f vPdg) ex lv

-- =====================================================================
-- OUTPUT HELPERS
-- =====================================================================

check :: String -> Bool -> IO ()
check nm True  = putStrLn $ "  PASS  " ++ nm
check nm False = putStrLn $ "  FAIL  " ++ nm

pr :: Int -> String -> String
pr w s = s ++ replicate (max 0 (w - length s)) ' '

pl :: Int -> String -> String
pl w s = replicate (max 0 (w - length s)) ' ' ++ s

fv :: Int -> Double -> String
fv w x = pr w (showGFloat (Just 5) x "")

fp :: Double -> String
fp x = showFFloat (Just 3) x "%"

rat :: Double -> String
rat p | p < 0.001 = "EXACT" | p < 0.5 = "TIGHT"
      | p < 1.0 = "GOOD"   | p < 4.5 = "LOOSE" | otherwise = "OVER"

row :: Obs -> IO ()
row o = putStrLn $
  "  " ++ pr 20 (oName o)
       ++ pr 30 (oForm o)
       ++ fv 14 (oCry o)
       ++ fv 14 (oCryPdg o)
       ++ fv 14 (oExpt o)
       ++ pl 10 (fp (shiftPct o))
       ++ pl 10 (fp (gapPct o))
       ++ "  " ++ rat (gapPct o)

header :: IO ()
header = do
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 30 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 122 '-'
