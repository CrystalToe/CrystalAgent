-- Copyright (c) 2026 Daland Montgomery -- SPDX-License-Identifier: AGPL-3.0-or-later
-- CrystalThirdGate.hs
--
-- Haskell verifier: arithmetic invariants of the third gate.
-- Companion to "The Third Gate" paper.
--
-- Build: ghc -O2 -main-is CrystalThirdGate CrystalThirdGate.hs && ./CrystalThirdGate

module CrystalThirdGate (main) where

import Data.List (foldl', sort, nub)
import System.Exit (exitFailure, exitSuccess)

-- ── HEEGNER NUMBERS ───────────────────────────────────────────

heegnerH :: [Int]
heegnerH = [1, 2, 3, 7, 11, 19, 43, 67, 163]

isInHeegner :: Int -> Bool
isInHeegner n = n `elem` heegnerH

-- 4p − 1 lift criterion
isBlessedPrime :: Int -> Bool
isBlessedPrime p = p `elem` heegnerH || (4 * p - 1) `elem` heegnerH

-- ── PRIME FACTORIZATION ───────────────────────────────────────

primeFactors :: Int -> [Int]
primeFactors n
  | n <= 1    = []
  | otherwise = go n 2
  where
    go m d
      | d * d > m   = [m]
      | m `mod` d == 0 = d : go (m `div` d) d
      | otherwise   = go m (d + 1)

allBlessed :: Int -> Bool
allBlessed n = all isBlessedPrime (nub (primeFactors n))

foreignFactors :: Int -> [Int]
foreignFactors n = filter (not . isBlessedPrime) (nub (primeFactors n))

-- ── DUAL-GATE FAILURE ─────────────────────────────────────────

dualGateFails :: Int -> Int -> Bool
dualGateFails z a =
  let n = a - z
  in not (allBlessed z) && not (allBlessed n)

-- ── THE FOUR STUBBORN ELEMENTS ────────────────────────────────

stubbornFour :: [(String, Int, Int)]
stubbornFour =
  [ ("I",  53, 127)
  , ("Tb", 65, 159)
  , ("Lu", 71, 175)
  , ("Au", 79, 197)
  ]

-- ── SHELL CLOSURE TARGETS ─────────────────────────────────────

magicNumbers :: [Int]
magicNumbers = [2, 8, 20, 28, 50, 82, 126]

nobleGases :: [Int]
nobleGases = [2, 10, 18, 36, 54, 86]

-- ── THIRD-TIER VACUITY CHECK ──────────────────────────────────

thirdTierShift :: Int -> Int
thirdTierShift p = 16 * p - 4

-- ── THEOREMS (each returns Bool; main reports & exits) ────────

t1_StubbornAllDualFail :: Bool
t1_StubbornAllDualFail = all (\(_, z, a) -> dualGateFails z a) stubbornFour

t2_HeegnerSize :: Bool
t2_HeegnerSize = length heegnerH == 9

t3_BlessedSet :: Bool
t3_BlessedSet =
  all isBlessedPrime [2, 3, 5, 7, 11, 17, 19, 41, 43, 67, 163]

t4_ForeignSet :: Bool
t4_ForeignSet =
  all (not . isBlessedPrime) [13, 23, 29, 31, 37, 47, 53, 59, 71, 79]

t5_ThirdTierVacuous :: Bool
t5_ThirdTierVacuous =
  all (not . isInHeegner . thirdTierShift) [2, 3, 5, 7, 11]

t6_MagicAllBlessed :: Bool
t6_MagicAllBlessed = all allBlessed magicNumbers

t7_NobleAllBlessed :: Bool
t7_NobleAllBlessed = all allBlessed nobleGases

t8_OganessonForeign :: Bool
t8_OganessonForeign = not (allBlessed 118)

t9_PbLiftsTo163 :: Bool
t9_PbLiftsTo163 = (4 * 41 - 1) == 163

t10_MaxHeegnerIs163 :: Bool
t10_MaxHeegnerIs163 = maximum heegnerH == 163

-- Tier 2 dual-gate accuracy (sanity): Pm Z=61 is foreign.
t11_PmForeign :: Bool
t11_PmForeign = not (allBlessed 61)

-- Each stubborn element has BOTH Z and N foreign (explicit factorization).
t12_StubbornFactorizations :: Bool
t12_StubbornFactorizations =
  foreignFactors 53  == [53] &&
  foreignFactors 74  == [37] && -- N for I-127
  foreignFactors 65  == [13] &&
  foreignFactors 94  == [47] && -- N for Tb-159
  foreignFactors 71  == [71] &&
  foreignFactors 104 == [13] && -- N for Lu-175
  foreignFactors 79  == [79] &&
  foreignFactors 118 == [59]    -- N for Au-197 (and Z for Og!)

-- ── REPORTING ─────────────────────────────────────────────────

allTheorems :: [(String, Bool)]
allTheorems =
  [ ("T1  Stubborn four all dual-fail",         t1_StubbornAllDualFail)
  , ("T2  Heegner set size is 9",                t2_HeegnerSize)
  , ("T3  Blessed primes (11) verified",         t3_BlessedSet)
  , ("T4  Foreign primes (10) verified",         t4_ForeignSet)
  , ("T5  Third-tier 16p-4 vacuous",             t5_ThirdTierVacuous)
  , ("T6  Magic numbers all blessed",            t6_MagicAllBlessed)
  , ("T7  Noble gases all blessed",              t7_NobleAllBlessed)
  , ("T8  Oganesson (Z=118) is foreign",         t8_OganessonForeign)
  , ("T9  Pb's 41 lifts to 163",                 t9_PbLiftsTo163)
  , ("T10 Max Heegner is 163",                   t10_MaxHeegnerIs163)
  , ("T11 Pm (Z=61) is foreign",                 t11_PmForeign)
  , ("T12 Stubborn factorizations correct",      t12_StubbornFactorizations)
  ]

main :: IO ()
main = do
  putStrLn "=========================================================="
  putStrLn "  Crystal Topos -- Third Gate Proof Verifier (Haskell)"
  putStrLn "  WACA Programme, April 2026"
  putStrLn "=========================================================="
  putStrLn ""
  let runOne (name, ok) = do
        let mark = if ok then "PASS" else "FAIL"
        putStrLn ("  [" ++ mark ++ "]  " ++ name)
        return ok
  results <- mapM runOne allTheorems
  putStrLn ""
  putStrLn "----------------------------------------------------------"
  putStrLn ""
  putStrLn "  STUBBORN FOUR -- detailed factorization audit:"
  putStrLn ""
  mapM_ printStubborn stubbornFour
  putStrLn ""
  if and results
    then do
      putStrLn "  ALL PROOFS PASS."
      putStrLn ""
      exitSuccess
    else do
      putStrLn "  SOME PROOF FAILED."
      putStrLn ""
      exitFailure

printStubborn :: (String, Int, Int) -> IO ()
printStubborn (sym, z, a) = do
  let n = a - z
  let zfs = primeFactors z
  let nfs = primeFactors n
  let zfor = foreignFactors z
  let nfor = foreignFactors n
  putStrLn $ "    " ++ sym ++ " (Z=" ++ show z ++ ", A=" ++ show a ++ ", N=" ++ show n ++ "):"
  putStrLn $ "       Z factors: " ++ show zfs ++
             "  foreign: " ++ show zfor
  putStrLn $ "       N factors: " ++ show nfs ++
             "  foreign: " ++ show nfor
  putStrLn $ "       dualGateFails: " ++ show (dualGateFails z a)
