-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalLattice.hs — Haskell witness for the Rectangle/Natural-Path theorem.

  Every integer assertion here corresponds to a Lean `native_decide` proof in
  `proofs/CrystalLattice.lean` and an Agda `refl` proof in
  `proofs/CrystalLattice.agda`.

  THE CLAIM (v3).  Distinct (2,3) towers must be linked by channels with
  frequencies coprime to chi = 6. The minimal such channels are the primes
  >= 5. The primes that actually appear in the Crystal Topos framework are
  not arbitrary primes >= 5 — they fall into THREE disjoint structural
  classes:

    CONSTRUCTIBLE (Fermat)    F_n = 2^(2^n) + 1
    BOUNDARY (tower-adjacent) chi^2 +/- 1, D +/- 1, ...
    LINKING  (everything else coprime to 6)

  This module prints the partition and runs the sanity checks.

  Compile: ghc -O2 -main-is CrystalLattice CrystalLattice.hs && ./CrystalLattice
-}

module CrystalLattice where

-- ══════════════════════════════════════════════════════════════════
-- §4b  FERMAT LADDER TERMINATION (v4)
--
-- F_n = 2^(2^n) + 1 has EXPONENT 2^n.  The weak-power chain of primitive
-- sector dimensions in the crystal is
--
--   N_w^0 = 1  (d_singlet)
--   N_w^1 = 2  (N_w)
--   N_w^2 = 4  (End M_2)
--   N_w^3 = 8  (d_colour)      <-- TERMINATOR
--
-- The next primitive dim is 24 = N_w^3 * N_c = d_mixed, which breaks the
-- power-of-N_w chain.  So F_n has a natural home iff 2^n <= d_colour = 8,
-- iff n <= N_c = 3.  The ladder terminates at F_3 = 257.
--
-- The identity d_colour = N_c^2 - 1 = N_w^N_c = 8 is the Mihailescu/Catalan
-- identity 3^2 - 2^3 = 1, which is the same uniqueness condition that
-- selects (2,3) via Theorem 3: (p-1)(q-1) = 2.
-- ══════════════════════════════════════════════════════════════════

-- | Exponent of F_n in the 2^(2^n)+1 form.
fermatExponent :: Int -> Int
fermatExponent n = 2 ^ n

-- | d_colour: the terminator of the weak-power chain.
dColour :: Int
dColour = nW ^ nC            -- 2^3 = 8 = N_c^2 - 1 = 8 (Mihailescu identity)

-- | Does F_n have a crystal home (2^n <= d_colour)?
fermatHasHome :: Int -> Bool
fermatHasHome n = fermatExponent n <= dColour

-- | F_n value.
fermat :: Int -> Int
fermat n = 2 ^ (2 ^ n) + 1

-- | Primality certificate that matches the Lean/Agda proofs.
isFermatPrime :: Int -> Bool
isFermatPrime v = isPrime v

-- | The Mihailescu identity at (N_w, N_c) = (2, 3):  3^2 - 2^3 = 1.
--   This forces d_colour = N_c^2 - 1 to equal N_w^N_c.
mihailescu23 :: Bool
mihailescu23 = (nC ^ (2::Int)) - (nW ^ nC) == 1

-- | Counterfactual check: for other (N_w, N_c), does the same identity hold?
mihailescuFor :: Int -> Int -> Int
mihailescuFor nw nc = (nc ^ (2::Int)) - (nw ^ nc)

fermatChecks :: [Check]
fermatChecks =
  [ Check "Mihailescu at (2,3): N_c^2 - N_w^N_c = 1" mihailescu23
  , Check "d_colour = N_c^2 - 1 = 8"              (nC*nC - 1 == 8)
  , Check "d_colour = N_w^N_c = 8"                (nW^nC == 8)
  , Check "Two expressions for d_colour agree"    (nC*nC - 1 == nW^nC)
  , Check "F_0 has crystal home (2^0 = 1 <= 8)"   (fermatHasHome 0)
  , Check "F_1 has crystal home (2^1 = 2 <= 8)"   (fermatHasHome 1)
  , Check "F_2 has crystal home (2^2 = 4 <= 8)"   (fermatHasHome 2)
  , Check "F_3 has crystal home (2^3 = 8 <= 8)"   (fermatHasHome 3)
  , Check "F_4 has NO crystal home (2^4 = 16 > 8)" (not (fermatHasHome 4))
  , Check "F_4 IS prime (but still excluded)"      (isFermatPrime 65537)
  , Check "F_5 is composite: 2^32+1 = 641 * 6700417"
          ((2 ^ (32::Int) + 1 :: Int) == 641 * 6700417)
  , Check "Counterfactual (2,4): 4^2 - 2^4 = 0"    (mihailescuFor 2 4 == 0)
  , Check "Counterfactual (2,5): 5^2 - 2^5 negative (32-25=7)"
          (mihailescuFor 2 5 < 0 && (nW^5 - nC2sq 5) == 7)
  , Check "4 sectors <-> 4 Fermat primes F_0..F_3"
          (length frameworkFermat == 4)
  ]
  where
    nC2sq k = k * k

-- ═══════════════════════════════════════════════════════════════════
-- §0  ATOMS (mirrors CrystalAtoms; kept local to avoid coupling)
-- ═══════════════════════════════════════════════════════════════════

nW, nC, chi, beta0, towerD, sigmaD, sigmaD2, gauss :: Int
nW       = 2
nC       = 3
chi      = nW * nC                      -- 6
beta0    = (11 * nC - 2 * chi) `div` 3  -- 7
towerD   = chi * beta0                  -- 42
sigmaD   = 1 + nC + (nC*nC - 1) + (nW*nW*nW * nC)                    -- 36
sigmaD2  = 1 + nC*nC + (nC*nC-1)^(2::Int) + (nW*nW*nW*nC)^(2::Int)   -- 650
gauss    = nW*nW + nC*nC                -- 13

-- ═══════════════════════════════════════════════════════════════════
-- §1  THE ORTHOGONALITY THEOREM (Theorems 1-3 of the paper)
-- ═══════════════════════════════════════════════════════════════════

-- | gcd on Int (trivial wrapper so the semantics match the Lean proof).
mygcd :: Int -> Int -> Int
mygcd a 0 = abs a
mygcd a b = mygcd b (a `mod` b)

-- | Coprime-to-chi: f is a legal linking frequency iff gcd(f,6) = 1.
coprimeToSix :: Int -> Bool
coprimeToSix n = mygcd n chi == 1

-- | The orthogonality predicate, stated exactly as in the paper.
legalLink :: Int -> Bool
legalLink = coprimeToSix

-- | Primality (trial division; sufficient for the integers we care about).
isPrime :: Int -> Bool
isPrime n | n < 2     = False
          | n < 4     = True
          | even n    = False
          | otherwise = all (\d -> n `mod` d /= 0) [3,5..isqrt n]
  where isqrt = floor . sqrt . (fromIntegral :: Int -> Double)

-- | The (2,3) uniqueness identity: (p-1)(q-1) = 2 has unique solution (2,3).
catalanIdentity :: (Int,Int) -> Bool
catalanIdentity (p,q) = (p-1) * (q-1) == 2

-- ═══════════════════════════════════════════════════════════════════
-- §2  THE THREE PRIME CLASSES
--
--   CONSTRUCTIBLE : Fermat primes F_n = 2^(2^n) + 1.
--                   The primes for which regular p-gons are constructible
--                   with compass and straightedge (Gauss 1796).
--   BOUNDARY      : primes adjacent to structural integers chi^2, D, ...
--                   Twin-prime flanks of the tower boundary.
--   LINKING       : everything else coprime to 6.
-- ═══════════════════════════════════════════════════════════════════

-- | The known Fermat primes. (No F_n prime is known for n >= 5.)
fermatPrimes :: [(Int,Int)]
fermatPrimes = [ (0, 2^(2^(0::Int)) + 1)    -- 3
               , (1, 2^(2^(1::Int)) + 1)    -- 5
               , (2, 2^(2^(2::Int)) + 1)    -- 17
               , (3, 2^(2^(3::Int)) + 1)    -- 257
               , (4, 2^(2^(4::Int)) + 1)    -- 65537
               ]

-- | The Fermat ladder actually wired into the framework: F0..F3.
--   F0 = N_c. F1 = chi-1. F2 in alpha_s(M_Z) = 2/17. F3 = Lambda_h/v = 1/257.
--   F4 = 65537 is beyond the tower depth and does NOT appear.
frameworkFermat :: [(Int,Int,String)]
frameworkFermat =
  [ (0, 3,   "N_c = 3 (colour dim)")
  , (1, 5,   "chi - 1 = 5 (Planck exp, Chandra 3/5, Flory 2/5)")
  , (2, 17,  "N_c^2 + d_colour = 9 + 8 (in alpha_s = 2/17)")
  , (3, 257, "2^(2^N_c) + 1 (in Lambda_h = v/257)")
  ]

-- | Boundary primes: immediate prime neighbours of tower-structural ints.
--   D = 42 -> (41, 43). chi^2 = 36 -> (37) above only (35 = 5*7 composite).
boundaryPrimes :: [(Int,String)]
boundaryPrimes =
  [ (41,  "D - 1 (in Magic 82 = N_w * (D-1))")
  , (43,  "D + 1 (Heegner, in alpha^-1 = 43*pi + ln 7)")
  , (37,  "chi^2 + 1 (not yet used; candidate for layer D=36+1)")
  ]

-- | Linking primes present in the framework's observable catalogue.
--   These are primes >=5 that are neither Fermat nor tower-boundary.
--   They sit on the "coprime-to-6" sub-lattice the paper identifies.
frameworkLinking :: [(Int,String)]
frameworkLinking =
  [ (7,   "beta0 = D/chi (in alpha^-1, iron peak 56 = 8*7)")
  , (11,  "in (11 N_c - 2 chi)/3 = beta0, PMNS sin^2 th23 = 6/11")
  , (13,  "gauss = N_w^2 + N_c^2 (in sin^2 th_W = 3/13)")
  , (19,  "gauss + chi (in Omega_L = 13/19, T_CMB = 19/7)")
  , (53,  "chi*N_c^2 - 1 (in proton mass m_p = v/2^8 * 53/54)")
  , (61,  "in Omega_DM denominator 1159 = 19*61")
  , (97,  "in Age of universe = 97/7 Gyr")
  , (103, "in Omega_DM numerator 309 = 3*103")
  ]

-- ═══════════════════════════════════════════════════════════════════
-- §3  THE TWIN-PRIME SANDWICH THEOREM
--
--   D = 42 is composite (42 = 2*3*7).  The integers immediately
--   flanking D are BOTH prime and form a twin pair.
--   41 (D-1) is wired via Magic 82 = N_w * (D-1).
--   43 (D+1) is wired via alpha^-1 = 43*pi + ln 7.
--   The tower boundary has a two-sided prime membrane.
-- ═══════════════════════════════════════════════════════════════════

twinSandwich :: (Int,Int,Int)
twinSandwich = (towerD - 1, towerD, towerD + 1)  -- (41, 42, 43)

twinSandwichOK :: Bool
twinSandwichOK =
  let (a,_,b) = twinSandwich
  in isPrime a && isPrime b
     && coprimeToSix a && coprimeToSix b
     && b - a == 2

-- ═══════════════════════════════════════════════════════════════════
-- §4  COSMOLOGICAL LINKING SIGNATURE
--
--   Observables dominated by inter-tower linking should be pure ratios
--   of primes >= 5.  Three hits found:
--
--     Omega_Lambda     = 13 / 19         (both prime)
--     T_CMB (K)        = 19 / 7          (both prime)
--     Age (Gyr)        = 97 / 7          (both prime)
--     Omega_DM (base)  = (3*103) / (19*61)  — three of four primes are >= 5
-- ═══════════════════════════════════════════════════════════════════

cosmoSignature :: [(String,(Int,Int),Bool)]
cosmoSignature =
  [ ("Omega_L",     (13, 19), isPrime 13 && isPrime 19)
  , ("T_CMB (K)",   (19, 7),  isPrime 19 && isPrime 7)
  , ("Age (Gyr)",   (97, 7),  isPrime 97 && isPrime 7)
  ]

-- ═══════════════════════════════════════════════════════════════════
-- §5  AUDIT — every test the paper names
-- ═══════════════════════════════════════════════════════════════════

data Check = Check { checkName :: String, checkOK :: Bool }

checks :: [Check]
checks =
  [ Check "chi = 6"                              (chi == 6)
  , Check "D  = 42"                              (towerD == 42)
  , Check "Sum of sector dims = 36 = chi^2"      (sigmaD == chi*chi)
  , Check "Schur sum of squares = 650"           (sigmaD2 == 650)
  , Check "gauss = 13 = N_w^2 + N_c^2"           (gauss == 13)
  , Check "VEV numerator = 35 = (chi^2 - 1) = 5*7"
                                                 (chi*chi - 1 == 35 && 35 == 5*7)
  , Check "Linking prime 5 coprime to 6"         (coprimeToSix 5)
  , Check "Linking prime 7 coprime to 6"         (coprimeToSix 7)
  , Check "Interference 4 shares factor with 6"  (not (coprimeToSix 4))
  , Check "Interference 9 shares factor with 6"  (not (coprimeToSix 9))
  , Check "(2,3) satisfies (p-1)(q-1) = 2"       (catalanIdentity (2,3))
  , Check "No other prime pair <=13 works"
        (not (any catalanIdentity
              [(2,5),(3,5),(2,7),(3,7),(5,7),(2,11),(3,11),(5,11),
               (7,11),(2,13),(3,13),(5,13),(7,13),(11,13)]))
  , Check "Fermat ladder F0..F3 all prime"
        (all (isPrime . snd) (take 4 fermatPrimes))
  , Check "F0 = N_c"                             (snd (fermatPrimes!!0) == nC)
  , Check "F1 = chi - 1"                         (snd (fermatPrimes!!1) == chi - 1)
  , Check "F2 = 17 = N_c^2 + d_colour"           (snd (fermatPrimes!!2) == nC*nC + (nC*nC - 1))
  , Check "F3 = 257 = 2^(2^N_c) + 1"             (snd (fermatPrimes!!3) == 2^(2^nC) + 1)
  , Check "Twin-prime sandwich (41, 43) of D=42" twinSandwichOK
  , Check "All framework linking primes are indeed prime"
        (all (isPrime . fst) frameworkLinking)
  , Check "All framework linking primes coprime to 6"
        (all (coprimeToSix . fst) frameworkLinking)
  , Check "Cosmological signature: all ratios are prime/prime"
        (all (\(_,_,ok) -> ok) cosmoSignature)
  ] ++ fermatChecks

-- ═══════════════════════════════════════════════════════════════════
-- §6  MAIN — prints the taxonomy and the audit
-- ═══════════════════════════════════════════════════════════════════

main :: IO ()
main = do
  putStrLn "══════════════════════════════════════════════════════════════════"
  putStrLn " CrystalLattice.hs — Prime taxonomy of the Crystal Topos (v3)"
  putStrLn " A_F = C (+) M_2(C) (+) M_3(C).  chi = 6. D = 42."
  putStrLn "══════════════════════════════════════════════════════════════════"
  putStrLn ""

  putStrLn "── CLASS 1: CONSTRUCTIBLE (Fermat) primes F_n = 2^(2^n)+1 ──"
  mapM_ (\(n,p,note) ->
           putStrLn (printRow ("F_" ++ show n) p note))
        frameworkFermat
  putStrLn "  F_4 = 65537 : EXPONENT 2^4 = 16 > d_colour = 8; NO crystal home."
  putStrLn "                (F_4 IS prime, but there is no primitive sector with dim 16.)"
  putStrLn "  F_5 = 2^32+1 = 641 * 6700417 : COMPOSITE (Euler 1732)."
  putStrLn "                A hypothetical (N_w=2, N_c=5) crystal's ladder would break here."
  putStrLn ""

  putStrLn "── FERMAT LADDER TERMINATION (v4) ──"
  putStrLn $ "  Weak-power chain:  N_w^0=1, N_w^1=2, N_w^2=4, N_w^3=" ++ show dColour
          ++ "=d_colour  TERMINATOR"
  putStrLn $ "  Mihailescu at (2,3): N_c^2 - N_w^N_c = " ++ show (nC*nC - nW^nC)
          ++ "  (uniquely forces d_colour = N_c^2-1 = N_w^N_c)"
  putStrLn $ "  Counterfactual (2,4):  4^2 - 2^4 = " ++ show (mihailescuFor 2 4)
          ++ "   (no Mihailescu; but F_4=65537 IS prime)"
  putStrLn $ "  Counterfactual (2,5):  2^5 - 5^2 = " ++ show (nW^(5::Int) - 5*5)
          ++ "   (no Mihailescu; F_5 is composite)"
  putStrLn $ "  Sector-Fermat bijection: 4 sectors {1,3,8,24} ↔ 4 Fermats {3,5,17,257}"
  putStrLn ""

  putStrLn "── CLASS 2: BOUNDARY primes (adjacent to tower invariants) ──"
  mapM_ (\(p,note) -> putStrLn (printRowI p note)) boundaryPrimes
  putStrLn ""

  putStrLn "── CLASS 3: LINKING primes (coprime-to-6 sub-lattice) ──"
  mapM_ (\(p,note) -> putStrLn (printRowI p note)) frameworkLinking
  putStrLn ""

  putStrLn "── TWIN-PRIME SANDWICH of tower depth D = 42 ──"
  let (a,_,b) = twinSandwich
  putStrLn $ "  (" ++ show a ++ ", D, " ++ show b ++ "): "
          ++ (if twinSandwichOK
                then "BOTH flanks prime, twin pair, both coprime to 6. PASS."
                else "FAIL")
  putStrLn ""

  putStrLn "── COSMOLOGICAL LINKING SIGNATURE ──"
  mapM_ (\(nm,(p,q),ok) ->
           putStrLn $ "  " ++ nm ++ " = " ++ show p ++ "/" ++ show q
                   ++ "  primes-ratio: " ++ (if ok then "YES" else "NO"))
        cosmoSignature
  putStrLn ""

  putStrLn "── AUDIT ──"
  mapM_ (\(Check n ok) ->
           putStrLn ("  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ n))
        checks
  let nPass = length (filter checkOK checks)
      nAll  = length checks
  putStrLn ""
  putStrLn $ "  RESULT: " ++ show nPass ++ "/" ++ show nAll
          ++ (if nPass == nAll then "  — all green."
                               else "  — FAILURES present.")
  putStrLn "══════════════════════════════════════════════════════════════════"

  where
    printRow lbl val note =
      "  " ++ lbl ++ " = " ++ pad 6 (show val) ++ "  " ++ note
    printRowI v note =
      "  " ++ pad 4 (show v) ++ "  " ++ note
    pad n s = s ++ replicate (max 0 (n - length s)) ' '
