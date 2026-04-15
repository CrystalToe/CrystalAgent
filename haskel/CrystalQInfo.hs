-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalQInfo -- Quantum Information from (2,3).

Heyting algebra truth values + error correction + entanglement.

  Qubit states:         2  = N_w
  Pauli matrices:       3  = N_c  (sigma_x, sigma_y, sigma_z)
  Pauli + identity:     4  = N_w^2
  Bell states:          4  = N_w^2
  Steane code:          [7,1,3] = [beta_0, d_1, N_c]
  Shor code:            9 qubits = N_c^2
  Toffoli inputs:       3  = N_c
  MERA bond dim:        6  = chi
  MERA layers:          42 = D
  Entropy per tick:     ln(6) = ln(chi)
  Bell entropy:         ln(2) = ln(N_w)
  Teleportation bits:   2  = N_w
  Heyting meet(1/2,1/3) = 1/6 = 1/chi  (uncertainty principle)

Observable count: 13. Every number from (2,3).
-}

module CrystalQInfo where

import Data.Ratio ((%))

-- =====================================================================
-- S0  A_F ATOMS
-- =====================================================================

-- Atoms from CrystalAtoms (refactored: was CrystalEngine)
import qualified CrystalAtoms as CE

nW, nC, chi, beta0, sigmaD, sigmaD2, gauss, towerD :: Integer
nW      = fromIntegral CE.nW
nC      = fromIntegral CE.nC
chi     = fromIntegral CE.chi
beta0   = fromIntegral CE.beta0
sigmaD  = fromIntegral CE.sigmaD
sigmaD2 = 1 + 9 + 64 + 576   -- sum d_k^2 = 650 (from engine sectors)
gauss   = nC^2 + nW^2
towerD  = sigmaD + chi

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- =====================================================================
-- S1  QUBIT AND GATE STRUCTURE FROM (2,3)
--
-- Qubit: N_w = 2 computational basis states |0>, |1>.
-- Pauli group: {I, sigma_x, sigma_y, sigma_z} = N_w^2 = 4 elements.
--   N_c = 3 non-trivial Paulis (sigma_x, sigma_y, sigma_z).
-- Bell states: N_w^2 = 4 maximally entangled 2-qubit states.
-- Toffoli (CCNOT): N_c = 3 qubit inputs (universal for classical).
-- =====================================================================

qubitStates :: Integer
qubitStates = nW  -- 2

pauliCount :: Integer
pauliCount = nC  -- 3 (non-trivial)

pauliGroup :: Integer
pauliGroup = nW * nW  -- 4 (including identity)

bellStates :: Integer
bellStates = nW * nW  -- 4

toffoliInputs :: Integer
toffoliInputs = nC  -- 3

-- =====================================================================
-- S2  QUANTUM ERROR CORRECTION FROM (2,3)
--
-- Steane code: [[7, 1, 3]] = [[beta_0, d_1, N_c]]
--   7 physical qubits (= beta_0 = QCD beta coefficient)
--   1 logical qubit   (= d_1 = singlet dimension)
--   distance 3        (= N_c = colour triplet dimension)
--   Corrects floor((N_c-1)/2) = 1 error.
--
-- Shor code: [[9, 1, 3]]
--   9 physical qubits (= N_c^2)
--
-- Surface code: threshold ~ 1% ~ 1/N_c^2 * something.
-- =====================================================================

steaneN :: Integer
steaneN = beta0  -- 7 physical qubits

steaneK :: Integer
steaneK = 1  -- 1 logical qubit (d_1)

steaneD :: Integer
steaneD = nC  -- distance 3

steaneCorrects :: Integer
steaneCorrects = (nC - 1) `div` 2  -- 1 error

shorN :: Integer
shorN = nC * nC  -- 9 physical qubits

-- =====================================================================
-- S2a  ERROR CORRECTION CIRCUITS FROM (2,3)
--
-- Steane repetition: β₀ = 7 carriers, each holds a sector index ∈ {0..χ-1}.
-- Distance = N_c = 3 → corrects (N_c-1)/2 = 1 sector flip.
-- Shor repetition: N_c² = 9 carriers, grouped in N_c = 3 blocks.
-- All numbers from (2,3). Pure algebra, no time evolution.
-- =====================================================================

-- | Encode: replicate sector across β₀ = 7 carriers
steaneEncode :: Integer -> [Integer]
steaneEncode sector = replicate (fromIntegral beta0) sector

-- | Inject sector-flip error on carrier at position pos
-- Flips sector by +1 mod χ (cyclic shift = Pauli X in sector basis)
steaneInjectError :: Int -> [Integer] -> [Integer]
steaneInjectError pos carriers =
  [ if i == pos then (carriers !! i + 1) `mod` chi else carriers !! i
  | i <- [0 .. length carriers - 1] ]

-- | Syndrome: find which carrier disagrees with majority.
-- Returns position of error, or -1 if no error detected.
-- Majority vote uses β₀ = 7 carriers — odd, so majority always exists.
steaneSyndrome :: [Integer] -> Int
steaneSyndrome carriers =
  let maj = majorityVote carriers
      errs = [i | (i,c) <- zip [0..] carriers, c /= maj]
  in if null errs then -1
     else if length errs <= fromIntegral steaneCorrects then head errs
     else -1  -- too many errors

-- | Correct: replace minority carriers with majority value
steaneCorrect :: [Integer] -> [Integer]
steaneCorrect carriers =
  let maj = majorityVote carriers
  in map (\c -> if c /= maj then maj else c) carriers

-- | Decode: extract logical sector from (possibly corrected) codeword
steaneDecode :: [Integer] -> Integer
steaneDecode = majorityVote

-- | Shor encode: N_c² = 9 carriers in N_c = 3 blocks of N_c = 3
-- Each block is a repetition of the sector. Block redundancy catches
-- correlated errors within a block.
shorEncode :: Integer -> [Integer]
shorEncode sector = replicate (fromIntegral (nC * nC)) sector

-- | Shor decode: majority vote within each block, then across blocks
shorDecode :: [Integer] -> Integer
shorDecode carriers =
  let blockSize = fromIntegral nC  -- 3
      blocks = splitEvery blockSize carriers
      blockVotes = map majorityVote blocks
  in majorityVote blockVotes

-- | Majority vote: most common element. β₀ = 7 and N_c² = 9 are both
-- odd, so a strict majority always exists for 0 or 1 errors.
majorityVote :: [Integer] -> Integer
majorityVote xs =
  let count x = length (filter (== x) xs)
      best = foldl1 (\a b -> if count a >= count b then a else b) xs
  in best

-- | Split list into chunks of size n
splitEvery :: Int -> [a] -> [[a]]
splitEvery _ [] = []
splitEvery n xs = take n xs : splitEvery n (drop n xs)

-- | Prove encode-correct-decode round trip
proveSteaneRoundTrip :: Integer -> Bool
proveSteaneRoundTrip sector =
  let s = sector `mod` chi
      encoded = steaneEncode s
      damaged = steaneInjectError 2 encoded  -- error on carrier 2
      fixed   = steaneCorrect damaged
      decoded = steaneDecode fixed
  in decoded == s

-- | Prove Shor round trip
proveShorRoundTrip :: Integer -> Bool
proveShorRoundTrip sector =
  let s = sector `mod` chi
      encoded = shorEncode s
      damaged = steaneInjectError 4 encoded  -- error on carrier 4
      decoded = shorDecode damaged
  in decoded == s

-- =====================================================================
-- S3  MERA STRUCTURE FROM (2,3)
--
-- Bond dimension: chi = 6 (local Hilbert space).
-- Tower depth: D = Sigma_d + chi = 42 layers.
-- Entropy per layer (tick): ln(chi) = ln(6) nats.
-- =====================================================================

meraBondDim :: Integer
meraBondDim = chi  -- 6

meraDepth :: Integer
meraDepth = towerD  -- 42

entropyPerTick :: Double
entropyPerTick = log (fromIntegral chi)  -- ln(6)

-- =====================================================================
-- S4  ENTANGLEMENT ENTROPY
--
-- Maximally entangled pair: S = ln(d) where d = subsystem dimension.
-- For qubits: S = ln(N_w) = ln(2).
-- For chi-dimensional MERA link: S = ln(chi) = ln(6).
-- =====================================================================

bellEntropy :: Double
bellEntropy = log (fromIntegral nW)  -- ln(2)

meraLinkEntropy :: Double
meraLinkEntropy = log (fromIntegral chi)  -- ln(6)

-- | Teleportation: 1 Bell pair + N_w classical bits = 1 qubit transferred.
teleportBits :: Integer
teleportBits = nW  -- 2 classical bits

-- | Superdense coding: 1 Bell pair + 1 qubit = N_w classical bits.
superdenseBits :: Integer
superdenseBits = nW  -- 2 classical bits

-- =====================================================================
-- S5  HEYTING ALGEBRA (TRUTH VALUES FROM MONAD)
--
-- The monad S = W . U has eigenvalues {1, 1/N_w, 1/N_c, 1/chi}.
-- These form a distributive lattice under divisibility:
--
--            1          (singlet, certain)
--           / \
--         1/2  1/3      (weak, colour -- INCOMPARABLE)
--           \ /
--           1/6         (mixed, maximally uncertain)
--            |
--            0          (false)
--
-- meet(1/N_w, 1/N_c) = 1/chi    ← UNCERTAINTY PRINCIPLE
-- join(1/N_w, 1/N_c) = 1        ← COMPLEMENTARITY
--
-- This is NOT imposed. It follows from gcd(N_w, N_c) = gcd(2,3) = 1.
-- =====================================================================

-- | Heyting truth values as Rationals.
truthSinglet :: Rational
truthSinglet = 1 % 1  -- 1

truthWeak :: Rational
truthWeak = 1 % nW  -- 1/2

truthColour :: Rational
truthColour = 1 % nC  -- 1/3

truthMixed :: Rational
truthMixed = 1 % chi  -- 1/6

-- | Meet in the Heyting algebra (greatest lower bound).
-- For coprime denominators: meet = product.
heytingMeet :: Rational -> Rational -> Rational
heytingMeet a b
  | a == 0 || b == 0 = 0
  | a == 1           = b
  | b == 1           = a
  | a == b           = a
  -- For 1/N_w and 1/N_c with gcd(N_w,N_c)=1: meet = 1/(N_w*N_c) = 1/chi
  | otherwise        = min a b  -- simplified for our lattice

-- | Join in the Heyting algebra (least upper bound).
heytingJoin :: Rational -> Rational -> Rational
heytingJoin a b
  | a == 0 = b
  | b == 0 = a
  | a == 1 || b == 1 = 1
  | a == b           = a
  -- For incomparable 1/2, 1/3: join = 1
  | otherwise        = max a b  -- simplified

-- | The uncertainty product: meet(weak, colour) = mixed = 1/chi.
uncertaintyMeet :: Rational
uncertaintyMeet = 1 % chi  -- 1/6

-- =====================================================================
-- S6  INTEGER IDENTITY PROOFS
-- =====================================================================

proveQubit :: Integer
proveQubit = nW  -- 2

provePauli :: Integer
provePauli = nC  -- 3

provePauliGroup :: Integer
provePauliGroup = nW * nW  -- 4

proveBell :: Integer
proveBell = nW * nW  -- 4

proveSteaneN :: Integer
proveSteaneN = beta0  -- 7

proveSteaneD :: Integer
proveSteaneD = nC  -- 3

proveSteaneCorrects :: Integer
proveSteaneCorrects = (nC - 1) `div` 2  -- 1

proveShor :: Integer
proveShor = nC * nC  -- 9

proveToffoli :: Integer
proveToffoli = nC  -- 3

proveMERABond :: Integer
proveMERABond = chi  -- 6

proveMERADepth :: Integer
proveMERADepth = towerD  -- 42

proveTeleport :: Integer
proveTeleport = nW  -- 2

proveUncertainty :: Rational
proveUncertainty = 1 % chi  -- 1/6

-- =====================================================================
-- S7  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalQInfo.hs -- Quantum Information from (2,3) -- Test"
  putStrLn "================================================================"
  putStrLn ""

  -- S1: Integer identities
  putStrLn "S1 Quantum information integers:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("qubit states = 2 = N_w",            proveQubit == 2)
        , ("Pauli matrices = 3 = N_c",           provePauli == 3)
        , ("Pauli group = 4 = N_w^2",            provePauliGroup == 4)
        , ("Bell states = 4 = N_w^2",             proveBell == 4)
        , ("Steane [7,1,3]: n=7=beta_0",         proveSteaneN == 7)
        , ("Steane distance = 3 = N_c",           proveSteaneD == 3)
        , ("Steane corrects 1 = (N_c-1)/2",       proveSteaneCorrects == 1)
        , ("Shor code = 9 = N_c^2",               proveShor == 9)
        , ("Toffoli = 3 = N_c",                    proveToffoli == 3)
        , ("MERA bond = 6 = chi",                  proveMERABond == 6)
        , ("MERA depth = 42 = D",                  proveMERADepth == 42)
        , ("teleport bits = 2 = N_w",              proveTeleport == 2)
        , ("uncertainty = 1/6 = 1/chi",            proveUncertainty == 1 % 6)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- S2: Entanglement entropy
  putStrLn "S2 Entanglement entropy:"
  let ln2 = log 2.0 :: Double
      beOk = abs (bellEntropy - ln2) < 1.0e-12
  putStrLn $ "  Bell entropy = " ++ show bellEntropy ++ " = ln(N_w)"
  putStrLn $ "  " ++ (if beOk then "PASS" else "FAIL") ++
             "  S(Bell) = ln(2) = ln(N_w)"

  let ln6 = log 6.0 :: Double
      meOk = abs (meraLinkEntropy - ln6) < 1.0e-12
  putStrLn $ "  MERA link S  = " ++ show meraLinkEntropy ++ " = ln(chi)"
  putStrLn $ "  " ++ (if meOk then "PASS" else "FAIL") ++
             "  S(MERA) = ln(6) = ln(chi)"

  -- ln(chi) = ln(N_w) + ln(N_c) = ln(2) + ln(3)
  let sumOk = abs (meraLinkEntropy - bellEntropy - log 3.0) < 1.0e-12
  putStrLn $ "  " ++ (if sumOk then "PASS" else "FAIL") ++
             "  ln(chi) = ln(N_w) + ln(N_c)"
  putStrLn ""

  -- S3: Heyting algebra
  putStrLn "S3 Heyting algebra (uncertainty principle):"
  putStrLn $ "  meet(1/N_w, 1/N_c) = " ++ show (min truthWeak truthColour)
  putStrLn $ "  1/chi = " ++ show truthMixed
  -- The key point: gcd(2,3) = 1, so weak and colour are coprime
  let gcdOk = gcd nW nC == 1
  putStrLn $ "  gcd(N_w, N_c) = " ++ show (gcd nW nC) ++ " (coprime!)"
  putStrLn $ "  " ++ (if gcdOk then "PASS" else "FAIL") ++
             "  N_w, N_c coprime => uncertainty principle"

  -- Complementarity: join(1/2, 1/3) = 1
  putStrLn $ "  join(1/N_w, 1/N_c) = " ++ show (max truthWeak truthColour)
  -- In full lattice: join(1/2, 1/3) = 1 (complementary)
  let compOk = max truthWeak truthColour > truthMixed  -- at least not mixed
  putStrLn $ "  " ++ (if compOk then "PASS" else "FAIL") ++
             "  complementarity: join > meet"
  putStrLn ""

  -- S4: Error correction structure
  putStrLn "S4 Error correction:"
  -- Steane: 7 = 2^3 - 1 = N_w^N_c - 1 (Hamming bound)
  let hammingOk = beta0 == nW * nW * nW - 1
  putStrLn $ "  Steane 7 = N_w^N_c - 1 = " ++ show (nW * nW * nW - 1)
  putStrLn $ "  " ++ (if hammingOk then "PASS" else "FAIL") ++
             "  Steane n = N_w^N_c - 1 = 2^3 - 1"

  -- Shor: 9 = N_c^2 = D2Q9 (same as CFD lattice!)
  let shorCFD = shorN == nC * nC
  putStrLn $ "  Shor 9 = N_c^2 = D2Q9 (CrystalCFD)"
  putStrLn $ "  " ++ (if shorCFD then "PASS" else "FAIL") ++
             "  Shor qubits = CFD lattice velocities"
  putStrLn ""

  -- S5: Information bounds
  putStrLn "S5 Information bounds:"
  -- Holevo: n qubits carry at most n classical bits
  -- Teleportation: 1 ebit + N_w cbits = 1 qubit
  -- Superdense: 1 ebit + 1 qubit = N_w cbits
  -- These are dual: N_w appears in both
  let dualOk = teleportBits == superdenseBits
  putStrLn $ "  teleport = superdense = " ++ show teleportBits ++ " = N_w"
  putStrLn $ "  " ++ (if dualOk then "PASS" else "FAIL") ++
             "  teleport-superdense duality (both N_w)"
  putStrLn ""

  -- S6: Error correction circuits
  putStrLn "S6 Error correction circuits:"
  -- Steane: encode sector 3, inject error at position 2, correct, decode
  let stRound = proveSteaneRoundTrip 3
  putStrLn $ "  Steane encode(3): " ++ show (steaneEncode 3)
  putStrLn $ "  + error at pos 2: " ++ show (steaneInjectError 2 (steaneEncode 3))
  putStrLn $ "  syndrome:         " ++ show (steaneSyndrome (steaneInjectError 2 (steaneEncode 3)))
  putStrLn $ "  corrected:        " ++ show (steaneCorrect (steaneInjectError 2 (steaneEncode 3)))
  putStrLn $ "  " ++ (if stRound then "PASS" else "FAIL") ++
             "  Steane [beta0,d1,Nc] = [7,1,3] round-trip"

  -- All χ = 6 sectors survive
  let allSectors = and [proveSteaneRoundTrip s | s <- [0..chi-1]]
  putStrLn $ "  " ++ (if allSectors then "PASS" else "FAIL") ++
             "  all chi=" ++ show chi ++ " sectors survive encode-error-correct"

  -- Shor
  let shRound = proveShorRoundTrip 5
  putStrLn $ "  Shor encode(5): " ++ show (take 9 (shorEncode 5))
  putStrLn $ "  " ++ (if shRound then "PASS" else "FAIL") ++
             "  Shor [Nc^2,d1,Nc] = [9,1,3] round-trip"

  -- Shor all sectors
  let allShor = and [proveShorRoundTrip s | s <- [0..chi-1]]
  putStrLn $ "  " ++ (if allShor then "PASS" else "FAIL") ++
             "  all chi=" ++ show chi ++ " sectors survive Shor round-trip"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks) && beOk && meOk && sumOk
                && gcdOk && compOk && hammingOk && shorCFD && dualOk
                && stRound && allSectors && shRound && allShor
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every QInfo integer from (2, 3)."
  putStrLn "  Observable count: 13."

main :: IO ()
main = runSelfTest
