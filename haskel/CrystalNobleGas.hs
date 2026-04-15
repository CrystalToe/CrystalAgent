-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
--
-- CrystalNobleGas.hs
-- Executable verification: blessed-prime gate holds for noble gas electron counts
-- Supports: "Same Song, Second Verse" paper (forthcoming)

module CrystalNobleGas where

import Data.List (intercalate)

-- ============================================================
-- § 0: Rectangle constants
-- ============================================================

nW, nC, chi :: Int
nW  = 2
nC  = 3
chi = nW * nC  -- 6

heegnerH :: [Int]
heegnerH = [1, 2, 3, 7, 11, 19, 43, 67, 163]

-- ============================================================
-- § 1: Blessed / foreign / forbidden
-- ============================================================

isBlessed :: Int -> Bool
isBlessed p = p `elem` heegnerH || (4*p - 1) `elem` heegnerH

isForeign :: Int -> Bool
isForeign = not . isBlessed

primeFactors :: Int -> [Int]
primeFactors n
  | n <= 1    = []
  | otherwise = go n 2
  where
    go 1 _ = []
    go m d
      | d * d > m = [m]
      | m `mod` d == 0 = d : go (m `div` d) d
      | otherwise = go m (d + 1)

allFactorsBlessed :: Int -> Bool
allFactorsBlessed n = all isBlessed (primeFactors n)

isForbidden :: Int -> Bool
isForbidden = not . allFactorsBlessed

-- ============================================================
-- § 2: Noble gas Z values
-- ============================================================

nobleGases :: [(String, Int)]
nobleGases =
  [ ("He",  2)
  , ("Ne", 10)
  , ("Ar", 18)
  , ("Kr", 36)
  , ("Xe", 54)
  , ("Rn", 86)
  ]

oganesson :: (String, Int)
oganesson = ("Og", 118)

-- ============================================================
-- § 3: Electron shell capacity
-- ============================================================

electronShellCap :: Int -> Int
electronShellCap n = nW * n * n  -- 2n²

-- Shell filling: capacities 2, 8, 8, 18, 18, 32, 32, ...
shellFilling :: [Int]
shellFilling = 2 : concatMap (\n -> [electronShellCap n, electronShellCap n]) [2..7]

-- Cumulative noble gas Z from shell filling
cumulativeZ :: [Int]
cumulativeZ = scanl1 (+) shellFilling

-- ============================================================
-- § 4: Bilinear parent
-- ============================================================

pronic :: Int -> Int
pronic n = n * (n + 1)

square :: Int -> Int
square n = n * n

bilinearGap :: Int -> Int
bilinearGap n = pronic n - square n  -- should equal n

-- ============================================================
-- § 5: Verification
-- ============================================================

main :: IO ()
main = do
  putStrLn "╔══════════════════════════════════════════════════════╗"
  putStrLn "║  CrystalNobleGas — Blessed-Prime Gate for Electrons ║"
  putStrLn "║  Crystal Topos / WACA Programme · April 2026        ║"
  putStrLn "╚══════════════════════════════════════════════════════╝"
  putStrLn ""

  -- Test 1: all noble gases pass blessed-prime gate
  putStrLn "§ 1  Noble gas Z values — blessed-prime gate"
  putStrLn "─────────────────────────────────────────────"
  allPass <- mapM checkNobleGas nobleGases
  let pass1 = and allPass
  putStrLn ""

  -- Test 2: Oganesson is forbidden
  putStrLn "§ 2  Oganesson (Z = 118) — forbidden test"
  putStrLn "──────────────────────────────────────────"
  let (ogName, ogZ) = oganesson
      ogFactors = primeFactors ogZ
      ogForbid = isForbidden ogZ
      foreignOnes = filter isForeign ogFactors
  putStrLn $ "  " ++ ogName ++ " Z = " ++ show ogZ
    ++ " = " ++ showFactors ogFactors
  putStrLn $ "  Foreign factors: " ++ show foreignOnes
  let pass2 = ogForbid
  putStrLn $ "  isForbidden(118) = " ++ show ogForbid
    ++ "  " ++ verdict pass2
  putStrLn ""

  -- Test 3: Radon stamped by Heegner-43
  putStrLn "§ 3  Radon stamped by Heegner prime 43"
  putStrLn "──────────────────────────────────────"
  let rn43 = 43 `elem` heegnerH
  putStrLn $ "  Rn: Z = 86 = 2 · 43"
  putStrLn $ "  43 ∈ H = " ++ show rn43
  let pass3 = rn43
  putStrLn $ "  " ++ verdict pass3
  putStrLn ""

  -- Test 4: electron shell capacity = 2n²
  putStrLn "§ 4  Electron shell capacity = N_w · n²"
  putStrLn "────────────────────────────────────────"
  let expected = [(1,2),(2,8),(3,18),(4,32),(5,50),(6,72)]
      capResults = map (\(n,e) -> (n, electronShellCap n, electronShellCap n == e)) expected
  mapM_ (\(n,c,ok) -> putStrLn $ "  n = " ++ show n
    ++ "  →  2n² = " ++ show c ++ "  " ++ verdict ok) capResults
  let pass4 = all (\(_,_,ok) -> ok) capResults
  putStrLn ""

  -- Test 5: cumulative shell filling reproduces noble gas Z
  putStrLn "§ 5  Noble gas Z = cumulative shell filling"
  putStrLn "───────────────────────────────────────────"
  let nobleZ = map snd nobleGases
      cumZ = take 6 cumulativeZ
      fillMatch = zip3 (map fst nobleGases) nobleZ cumZ
  mapM_ (\(name, z, cz) -> putStrLn $ "  " ++ name
    ++ ":  Z = " ++ show z ++ "  cumulative = " ++ show cz
    ++ "  " ++ verdict (z == cz)) fillMatch
  let pass5 = nobleZ == cumZ
  putStrLn ""

  -- Test 6: bilinear parent — gap = n
  putStrLn "§ 6  Bilinear parent: pronic(n) - square(n) = n"
  putStrLn "───────────────────────────────────────────────"
  let gapResults = map (\n -> (n, pronic n, square n, bilinearGap n, bilinearGap n == n)) [1..7]
  mapM_ (\(n, p, s, g, ok) -> putStrLn $ "  n = " ++ show n
    ++ "  pronic = " ++ show p ++ "  square = " ++ show s
    ++ "  gap = " ++ show g ++ "  " ++ verdict ok) gapResults
  let pass6 = all (\(_,_,_,_,ok) -> ok) gapResults
  putStrLn ""

  -- Test 7: shell capacity differences = 2(2n+1)
  putStrLn "§ 7  Shell capacity differences = N_w · (2n + 1)"
  putStrLn "────────────────────────────────────────────────"
  let diffResults = map (\n -> let d = electronShellCap (n+1) - electronShellCap n
                                   e = nW * (2*n + 1)
                               in (n, d, e, d == e)) [1..5]
  mapM_ (\(n, d, e, ok) -> putStrLn $ "  n = " ++ show n
    ++ "  Δ(2n²) = " ++ show d ++ "  2(2n+1) = " ++ show e
    ++ "  " ++ verdict ok) diffResults
  let pass7 = all (\(_,_,_,ok) -> ok) diffResults
  putStrLn ""

  -- Summary
  putStrLn "════════════════════════════════════════"
  let allTests = [pass1, pass2, pass3, pass4, pass5, pass6, pass7]
      totalPass = length (filter id allTests)
      total = length allTests
  putStrLn $ "  " ++ show totalPass ++ " / " ++ show total ++ " tests passed"
  if and allTests
    then putStrLn "  ALL PASS ✓"
    else putStrLn "  SOME FAILURES ✗"
  putStrLn "════════════════════════════════════════"

-- ============================================================
-- Helpers
-- ============================================================

checkNobleGas :: (String, Int) -> IO Bool
checkNobleGas (name, z) = do
  let factors = primeFactors z
      blessed = allFactorsBlessed z
      foreignOnes = filter isForeign factors
  putStrLn $ "  " ++ name ++ " Z = " ++ show z
    ++ " = " ++ showFactors factors
    ++ "  all blessed = " ++ show blessed
    ++ (if null foreignOnes then "" else "  FOREIGN: " ++ show foreignOnes)
    ++ "  " ++ verdict blessed
  return blessed

showFactors :: [Int] -> String
showFactors = intercalate " · " . map show

verdict :: Bool -> String
verdict True  = "✓"
verdict False = "✗ FAIL"
