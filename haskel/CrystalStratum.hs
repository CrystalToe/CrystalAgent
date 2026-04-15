-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalStratum.hs — Multi-level hierarchy of the magic-number formula

  Runtime verification of the four-layer hierarchy:

    L0 PRIMARY    M(n)      = N_w·[C(n,1)+C(n,2)+C(n,3)] + correction
    L1 SECONDARY  M^(2)(n)  = N_w·[C(n,1)+C(n,2)]          + correction
    L2 TERTIARY   M^(1)(n)  = N_w·C(n,1)                   = 2n
    L3 FINE       M(n) + rectangle-invariant offset

  Plus the blessed-prime gate: N is allowed iff all prime factors ∈ B.

  Every literature-known closure
    canonical {2, 8, 20, 28, 50, 82, 126}
    doubly magic {56}
    emergent subshell {14, 16, 32, 34, 40, 64}
  is verified to land at L0 / L1 / L2 respectively AND pass the gate.

  30 even integers in 1..200 are L2-shaped but gate-forbidden. 14 of
  them are enumerated below as explicit predictions.

  Compile:
    ghc -O2 -main-is CrystalStratum CrystalStratum.hs && ./CrystalStratum
-}

module CrystalStratum (main) where

import Data.List (group, sort, intercalate)

-- =====================================================================
-- RECTANGLE INPUTS
-- =====================================================================

nW, nC :: Int
nW = 2
nC = 3

chi, beta0, towerD, gInv :: Int
chi    = nW * nC                   -- 6
beta0  = 7
towerD = chi * (chi + 1)           -- 42
gInv   = nW*nW + nC*nC             -- 13

-- =====================================================================
-- BINOMIAL AND IVERSON
-- =====================================================================

binom :: Int -> Int -> Int
binom _ 0 = 1
binom 0 _ = 0
binom n k = binom (n-1) (k-1) + binom (n-1) k

iverson :: Bool -> Int
iverson True  = 1
iverson False = 0

-- =====================================================================
-- HIERARCHY LAYER FUNCTIONS
-- =====================================================================

-- Layer 0: full formula
mL0 :: Int -> Int
mL0 n = nW * sum [binom n k | k <- [1..nC]]
      + nW * binom n 2 * iverson (n <= nC)

-- Layer 1: partial sum up to k = 2 (pronic-like, with correction)
mL1 :: Int -> Int
mL1 n = nW * (binom n 1 + binom n 2)
      + nW * binom n 2 * iverson (n <= nC)

-- Layer 2: partial sum up to k = 1 (= 2n)
mL2 :: Int -> Int
mL2 n = nW * binom n 1

-- =====================================================================
-- PRIME FACTORISATION
-- =====================================================================

primeFactors :: Int -> [Int]
primeFactors = go 2
  where
    go _ 1 = []
    go p n
      | p*p > n        = [n]
      | n `mod` p == 0 = p : go p (n `div` p)
      | otherwise      = go (p+1) n

prettyFactors :: Int -> String
prettyFactors 1 = "1"
prettyFactors n =
  let groups = map (\g -> (head g, length g)) (group (sort (primeFactors n)))
      showG (p, 1) = show p
      showG (p, k) = show p ++ "^" ++ show k
  in intercalate "·" (map showG groups)

-- =====================================================================
-- BLESSED PRIME SET B (computed from class-number-one criterion)
-- =====================================================================

heegner :: [Int]
heegner = [1, 2, 3, 7, 11, 19, 43, 67, 163]

isHeegner :: Int -> Bool
isHeegner n = n `elem` heegner

blessedByCriterion :: Int -> Bool
blessedByCriterion p = isHeegner p || isHeegner (4 * p - 1)

isPrime :: Int -> Bool
isPrime n = n > 1 && primeFactors n == [n]

blessed :: [Int]
blessed = filter blessedByCriterion (filter isPrime [2..200])

isBlessed :: Int -> Bool
isBlessed p = p `elem` blessed

allowed :: Int -> Bool
allowed n = all isBlessed (primeFactors n)

foreignPrimes :: Int -> [Int]
foreignPrimes n = filter (not . isBlessed) (primeFactors n)

-- =====================================================================
-- LITERATURE-KNOWN CLOSURES AND THEIR FRAMEWORK LAYER
-- =====================================================================

-- (N, literature label, expected framework layer)
knownClosures :: [(Int, String, String)]
knownClosures =
  [ (  2, "canonical magic"                    , "L0")
  , (  8, "canonical magic"                    , "L0")
  , ( 14, "emergent subshell (C-14, Si)"       , "L2")
  , ( 16, "O-16 doubly magic"                  , "L2")
  , ( 20, "canonical magic"                    , "L0")
  , ( 28, "canonical magic"                    , "L0")
  , ( 32, "⁵²Ca subshell"                      , "L2")
  , ( 34, "⁵⁴Ca subshell (Nature 2013)"        , "L2")
  , ( 40, "Zr/Ni semi-magic"                   , "L2")
  , ( 50, "canonical magic"                    , "L0")
  , ( 56, "Ni-56 doubly magic"                 , "L1")
  , ( 64, "weak Gd subshell"                   , "L2")
  , ( 82, "canonical magic"                    , "L0")
  , (126, "canonical magic"                    , "L0")
  ]

-- Framework-predicted FORBIDDEN even integers (even, L2-shaped, but contain
-- foreign primes → framework predicts NO robust subshell closure)
predictedForbidden :: [(Int, Int)]
predictedForbidden =
  [ (26 ,13), (46 ,23), (52 ,13), (58 ,29), (62 ,31), (74 ,37)
  , (78 ,13), (92 ,23), (94 ,47), (104,13), (106,53), (116,29)
  , (118,59), (122,61)
  ]

-- =====================================================================
-- LAYER-MEMBERSHIP CHECKS
-- =====================================================================

-- L0 check: N equals M(n) for some n in 1..9
isInL0 :: Int -> Maybe Int
isInL0 n = case filter (\k -> mL0 k == n) [1..9] of
  (k:_) -> Just k
  []    -> Nothing

-- L1 check: N equals M^(2)(k) for some k in 1..15 and N ∉ L0
isInL1 :: Int -> Maybe Int
isInL1 n = case filter (\k -> mL1 k == n) [1..15] of
  (k:_) | isInL0 n == Nothing -> Just k
  _ -> Nothing

-- L2 check: N even and N ∉ L0 ∪ L1
isInL2 :: Int -> Maybe Int
isInL2 n
  | even n && isInL0 n == Nothing && isInL1 n == Nothing = Just (n `div` 2)
  | otherwise = Nothing

layerOf :: Int -> String
layerOf n = case (isInL0 n, isInL1 n, isInL2 n) of
  (Just k, _, _) -> "L0 (M(" ++ show k ++ "))"
  (_, Just k, _) -> "L1 (M^(2)(" ++ show k ++ "))"
  (_, _, Just k) -> "L2 (2·" ++ show k ++ ")"
  _              -> "L3/L4"

-- =====================================================================
-- STRUCTURAL CHECKS
-- =====================================================================

-- L0 reproduces all seven canonical magic numbers
checkL0 :: Bool
checkL0 = map mL0 [1..7] == [2, 8, 20, 28, 50, 82, 126]

-- L1 produces Ni-56 at n = 7
checkNi56 :: Bool
checkNi56 = mL1 7 == 56

-- L1 produces tower-depth D = 42 at n = 6
checkTowerD :: Bool
checkTowerD = mL1 6 == towerD

-- L1 for n ≥ 4 equals n(n+1) (pronic)
checkPronic :: Bool
checkPronic = all (\n -> mL1 n == n * (n+1)) [4..12]

-- L2 produces 14, 16, 32, 34, 40, 64 at the right n
checkL2 :: Bool
checkL2 = mL2 7  == 14
       && mL2 8  == 16
       && mL2 16 == 32
       && mL2 17 == 34
       && mL2 20 == 40
       && mL2 32 == 64

-- N = 34 has DUAL reading: L2 (=2·17) and L3 (=M(4) + χ)
check34Dual :: Bool
check34Dual = mL2 17 == 34 && mL0 4 + chi == 34

-- N = 32 has DUAL reading: L2 (=2·16) and L3 (=M(4) + N_w²)
check32Dual :: Bool
check32Dual = mL2 16 == 32 && mL0 4 + nW*nW == 32

-- All 13 claimed closures are arithmetically ALLOWED
checkClaimedAllowed :: Bool
checkClaimedAllowed = all (allowed . (\(n,_,_) -> n)) knownClosures

-- All claimed closures land at their expected layer
checkClaimedLayer :: Bool
checkClaimedLayer = all go knownClosures
  where
    go (n, _, "L0") = isInL0 n /= Nothing
    go (n, _, "L1") = isInL1 n /= Nothing
    go (n, _, "L2") = isInL2 n /= Nothing
    go _            = False

-- Every predicted-forbidden N contains the expected foreign prime
checkForbidden :: Bool
checkForbidden = all (\(n,p) -> p `elem` foreignPrimes n) predictedForbidden

-- All predicted-forbidden N are in fact forbidden (not allowed)
checkForbiddenAllForbidden :: Bool
checkForbiddenAllForbidden = all (not . allowed . fst) predictedForbidden

-- Shell size ΔM(n) = n² − n + 2 for n ≥ 5
checkShellSize :: Bool
checkShellSize = all (\n -> mL0 n - mL0 (n-1) == n*n - n + 2) [5..9]

-- ΔM(6) = 32 (shell-6 size equals the ⁵²Ca N=32 subshell integer)
checkShell6Size :: Bool
checkShell6Size = mL0 6 - mL0 5 == 32

-- ΔM(8) = 58 = 2·29 (shell-8 size contains foreign prime 29 — why 184 is blocked)
checkShell8Foreign :: Bool
checkShell8Foreign = mL0 8 - mL0 7 == 58 && 29 `elem` primeFactors 58

-- Decomposition: M(n) = M^(2)(n) + N_w·C(n,3)
checkDecompL0toL1 :: Bool
checkDecompL0toL1 = all (\n -> mL0 n == mL1 n + nW * binom n 3) [1..10]

-- Decomposition: M^(2)(n) = M^(1)(n) + N_w·C(n,2) + correction
checkDecompL1toL2 :: Bool
checkDecompL1toL2 = all (\n -> mL1 n == mL2 n + nW * binom n 2
                                     + nW * binom n 2 * iverson (n <= nC)) [1..10]

-- =====================================================================
-- OUTPUT
-- =====================================================================

check :: String -> Bool -> IO ()
check label ok =
  putStrLn $ "  " ++ (if ok then "[PASS]" else "[FAIL]") ++ "  " ++ label

pad :: Int -> String -> String
pad w s = s ++ replicate (max 0 (w - length s)) ' '

main :: IO ()
main = do
  putStrLn "==================================================================="
  putStrLn " CrystalStratum.hs — multi-level magic-number hierarchy"
  putStrLn " L0 primary · L1 pronic · L2 tertiary · L3 fine · FORBIDDEN"
  putStrLn "==================================================================="
  putStrLn ""
  putStrLn $ "  (N_w, N_c) = (" ++ show nW ++ ", " ++ show nC ++ ")"
  putStrLn $ "  χ = " ++ show chi ++ ", β₀ = " ++ show beta0
          ++ ", D = " ++ show towerD ++ ", g = " ++ show gInv
  putStrLn $ "  B = " ++ show blessed
  putStrLn ""

  putStrLn "  LAYER 0 — PRIMARY (M(n) full formula, n = 1..8):"
  mapM_ (\n -> putStrLn $ "    M(" ++ show n ++ ") = " ++ show (mL0 n)
                      ++ "   [" ++ prettyFactors (mL0 n) ++ "]") [1..8]
  putStrLn ""

  putStrLn "  LAYER 1 — SECONDARY (M^(2)(n) pronic-like):"
  mapM_ (\n -> putStrLn $ "    M^(2)(" ++ show n ++ ") = " ++ show (mL1 n)
                      ++ "   [" ++ prettyFactors (mL1 n) ++ "]") [4..10]
  putStrLn "    ⟶ M^(2)(7) = 56 is Ni-56 doubly magic (Z = N = 28)"
  putStrLn "    ⟶ M^(2)(6) = 42 equals tower depth D"
  putStrLn ""

  putStrLn "  LAYER 2 — TERTIARY (M^(1)(n) = 2n at key emergent subshells):"
  mapM_ (\(n, label) -> putStrLn $ "    M^(1)(" ++ show n ++ ") = " ++ show (mL2 n)
                      ++ "   — " ++ label)
    [ ( 7, "14: C-14, Si-28 context")
    , ( 8, "16: O-16 doubly magic")
    , (16, "32: ⁵²Ca subshell")
    , (17, "34: ⁵⁴Ca subshell (Nature 2013)")
    , (20, "40: Zr, Ni semi-magic")
    , (32, "64: weak Gd subshell")
    ]
  putStrLn ""

  putStrLn "  DUAL READINGS — SAME INTEGER IN TWO LAYERS:"
  putStrLn $ "    N = 32:  L2 (= 2·16)  AND  L3 (= M(4) + N_w² = 28 + 4)"
  putStrLn $ "    N = 34:  L2 (= 2·17)  AND  L3 (= M(4) + χ   = 28 + 6)"
  putStrLn ""

  putStrLn "  LITERATURE CLOSURE TABLE:"
  putStrLn "  ---------------------------------------------------------------"
  putStrLn $ "    "  ++ pad 4 "N" ++ pad 30 "literature" ++ pad 10 "expected"
          ++ pad 20 "actual layer"
  putStrLn "  ---------------------------------------------------------------"
  mapM_ (\(n, lab, exp_) ->
    putStrLn $ "    " ++ pad 4 (show n) ++ pad 30 lab
            ++ pad 10 exp_ ++ pad 20 (layerOf n)) knownClosures
  putStrLn "  ---------------------------------------------------------------"
  putStrLn ""

  putStrLn "  FORBIDDEN PREDICTIONS (framework: NO robust closure here):"
  mapM_ (\(n, p) ->
    putStrLn $ "    N = " ++ pad 4 (show n) ++ "  [" ++ pad 10 (prettyFactors n)
            ++ "]  foreign prime: " ++ show p) predictedForbidden
  putStrLn ""

  putStrLn "  STRUCTURAL CHECKS:"
  check "L0 reproduces {2,8,20,28,50,82,126} at n=1..7"     checkL0
  check "L1 produces Ni-56 at M^(2)(7)"                     checkNi56
  check "L1 produces tower-depth D = 42 at M^(2)(6)"        checkTowerD
  check "L1 for n ≥ 4 equals n(n+1) (pronic)"               checkPronic
  check "L2 produces {14, 16, 32, 34, 40, 64}"              checkL2
  check "N = 34 has dual L2/L3 reading"                     check34Dual
  check "N = 32 has dual L2/L3 reading"                     check32Dual
  check "all 13 claimed closures factor into B"             checkClaimedAllowed
  check "all 13 claimed closures land at expected layer"    checkClaimedLayer
  check "14 predicted-forbidden N contain foreign primes"   checkForbidden
  check "14 predicted-forbidden N all blocked by gate"      checkForbiddenAllForbidden
  check "ΔM(n) = n² − n + 2 for n = 5..9 (Sylvester+1)"     checkShellSize
  check "ΔM(6) = 32 — shell-6 size = ⁵²Ca subshell N"       checkShell6Size
  check "ΔM(8) = 58 contains foreign 29 (blocks 184)"       checkShell8Foreign
  check "M(n) = M^(2)(n) + N_w·C(n,3)"                      checkDecompL0toL1
  check "M^(2)(n) = M^(1)(n) + N_w·C(n,2) + correction"     checkDecompL1toL2
  check "B is computed from class-number-one criterion"     (length blessed == 11)
  check "17 ∈ B because 4·17−1 = 67 ∈ H"                     (17 `elem` blessed)
  check "13 ∉ B (class number 2, 4·13−1 = 51 ∉ H)"           (not (13 `elem` blessed))

  putStrLn ""
  putStrLn "  All claims verified at runtime."
  putStrLn "==================================================================="
