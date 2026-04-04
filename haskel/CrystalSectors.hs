-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalSectors.hs — Component 3: The Four Sectors

  The algebra A_F = C + M_2(C) + M_3(C) decomposes into four
  irreducible representations (Wedderburn). Their dimensions are
  d_1=1, d_2=3, d_3=8, d_4=24. Total: Sigma_d = 36.

  This module defines WHAT EXISTS: the state space and its partition.
  It imports CrystalAtoms only. It knows nothing about eigenvalues
  or operators.

  Compile: ghc -O2 -main-is CrystalSectors CrystalSectors.hs && ./CrystalSectors
-}

module CrystalSectors
  ( -- The state
    CrystalState
  , zeroState

    -- Sector structure
  , sectorOf
  , sectorStart
  , sectorDim
  , extractSector
  , injectSector

    -- Self-test
  , main
  ) where

import CrystalAtoms hiding (main)

-- ═══════════════════════════════════════════════════════════════
-- THE STATE
--
-- 36 components partitioned as [1] + [3] + [8] + [24].
-- Each component belongs to exactly one sector.
-- ═══════════════════════════════════════════════════════════════

-- | Full state: 36 components = d_1 + d_2 + d_3 + d_4
type CrystalState = [Double]

-- | Zero state
zeroState :: CrystalState
zeroState = replicate sigmaD 0.0

-- | Which sector does component i belong to?
sectorOf :: Int -> Int
sectorOf i
  | i < d1             = 0  -- singlet
  | i < d1 + d2        = 1  -- weak
  | i < d1 + d2 + d3   = 2  -- colour
  | otherwise           = 3  -- mixed

-- | Sector start indices
sectorStart :: Int -> Int
sectorStart 0 = 0
sectorStart 1 = d1
sectorStart 2 = d1 + d2
sectorStart 3 = d1 + d2 + d3
sectorStart _ = sigmaD

-- | Sector dimension
sectorDim :: Int -> Int
sectorDim 0 = d1
sectorDim 1 = d2
sectorDim 2 = d3
sectorDim 3 = d4
sectorDim _ = 0

-- | Extract sector k from state
extractSector :: Int -> CrystalState -> [Double]
extractSector k st = take (sectorDim k) $ drop (sectorStart k) st

-- | Inject values into sector k of a state
injectSector :: Int -> [Double] -> CrystalState -> CrystalState
injectSector k vals st =
  let s = sectorStart k
      d = sectorDim k
      before = take s st
      after  = drop (s + d) st
  in before ++ take d vals ++ after

-- ═══════════════════════════════════════════════════════════════
-- SELF-TEST
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalSectors.hs — Component 3: The Four Sectors"
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "Dimensions:"
  check "d_1 = 1 (singlet)" (d1 == 1)
  check "d_2 = 3 (weak)" (d2 == 3)
  check "d_3 = 8 (colour)" (d3 == 8)
  check "d_4 = 24 (mixed)" (d4 == 24)
  check "Sigma_d = 36" (sigmaD == 36)
  check "d_4 = d_2 x d_3 (mixed = weak x colour)" (d4 == d2 * d3)
  putStrLn ""

  putStrLn "State space:"
  check "zeroState has 36 components" (length zeroState == 36)
  check "all zeros" (all (== 0.0) zeroState)
  putStrLn ""

  putStrLn "Sector mapping:"
  check "component 0 -> sector 0 (singlet)" (sectorOf 0 == 0)
  check "component 1 -> sector 1 (weak)" (sectorOf 1 == 1)
  check "component 3 -> sector 1 (weak)" (sectorOf 3 == 1)
  check "component 4 -> sector 2 (colour)" (sectorOf 4 == 2)
  check "component 11 -> sector 2 (colour)" (sectorOf 11 == 2)
  check "component 12 -> sector 3 (mixed)" (sectorOf 12 == 3)
  check "component 35 -> sector 3 (mixed)" (sectorOf 35 == 3)
  putStrLn ""

  putStrLn "Boundaries:"
  check "sector 0 starts at 0" (sectorStart 0 == 0)
  check "sector 1 starts at 1" (sectorStart 1 == 1)
  check "sector 2 starts at 4" (sectorStart 2 == 4)
  check "sector 3 starts at 12" (sectorStart 3 == 12)
  putStrLn ""

  putStrLn "Extract/inject round-trip:"
  let st = [fromIntegral i | i <- [1..sigmaD :: Int]]
  check "extract sector 0 = [1]" (extractSector 0 st == [1])
  check "extract sector 1 = [2,3,4]" (extractSector 1 st == [2,3,4])
  check "extract sector 2 length = 8" (length (extractSector 2 st) == 8)
  check "extract sector 3 length = 24" (length (extractSector 3 st) == 24)
  let reinjected = injectSector 1 [2,3,4] st
  check "inject round-trip preserves state" (reinjected == st)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " Four sectors. Sigma_d = 36 = 1 + 3 + 8 + 24. From (2,3)."
  putStrLn "================================================================"
