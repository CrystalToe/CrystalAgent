{-# LANGUAGE BangPatterns #-}
-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalDiscover.hs — Formula Space Explorer

  Enumerates algebraic expressions over the 15 building blocks
  from A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ) and compares each against a
  database of known physical constants (PDG, CODATA, NIST).

  Reports matches within a configurable tolerance.
  Filters out already-known Crystal observables.

  This is a SEARCH TOOL, not a dynamics module.
  No engine tick. Pure enumeration.

  ghc -O2 -main-is CrystalDiscover CrystalDiscover.hs && ./CrystalDiscover
-}

module CrystalDiscover where

import Data.List (sortBy, nubBy, intercalate, foldl')
import Data.Ord (comparing)

-- ═══════════════════════════════════════════════════════════════
-- §0 THE 15 BUILDING BLOCKS (all from N_w=2, N_c=3)
-- ═══════════════════════════════════════════════════════════════

nW, nC, chi, beta0 :: Int
nW = 2; nC = 3; chi = nW * nC; beta0 = (11*nC - 2*chi) `div` 3

d1, d2, d3, d4, sigmaD, sigmaD2 :: Int
d1 = 1; d2 = nC; d3 = nC*nC - 1; d4 = (nC*nC-1)*nC
sigmaD = d1+d2+d3+d4; sigmaD2 = d1*d1+d2*d2+d3*d3+d4*d4

gaussN, towerD, fermat3 :: Int
gaussN = nC*nC + nW*nW; towerD = sigmaD + chi; fermat3 = 2^(2^nC) + 1

cF, tF, kappa :: Double
cF = fromIntegral (nC*nC - 1) / fromIntegral (2*nC)  -- 4/3
tF = 1.0 / fromIntegral nW                            -- 1/2
kappa = log 3 / log 2                                  -- ln3/ln2

-- Named building blocks with their values
data Atom = Atom { atomName :: !String, atomVal :: !Double }
  deriving (Show)

atoms :: [Atom]
atoms =
  [ Atom "1"      1,       Atom "N_w"    2,       Atom "N_c"    3
  , Atom "N_w²"   4,       Atom "χ−1"    5,       Atom "χ"      6
  , Atom "β₀"     7,       Atom "d₃"     8,       Atom "N_c²"   9
  , Atom "gauss"  13,      Atom "d₄"     24,      Atom "Σd"     36
  , Atom "D"      42,      Atom "F₃"     257,     Atom "Σd²"    650
  , Atom "C_F"    cF,      Atom "T_F"    tF,      Atom "κ"      kappa
  ]

-- ═══════════════════════════════════════════════════════════════
-- §1 FORMULA REPRESENTATION
-- ═══════════════════════════════════════════════════════════════

data Formula = Formula
  { fNum    :: ![String]   -- numerator atom names
  , fDen    :: ![String]   -- denominator atom names
  , fPiPow  :: !Int        -- power of π (0, ±1, ±2)
  , fValue  :: !Double     -- computed value
  } deriving (Show)

formulaStr :: Formula -> String
formulaStr f =
  let num = if null (fNum f) then "1" else intercalate "·" (fNum f)
      den = if null (fDen f) then "" else "/" ++ intercalate "·" (fDen f)
      pp  = case fPiPow f of
              0 -> ""
              1 -> "·π"
              (-1) -> "/π"
              n -> "·π^" ++ show n
  in num ++ den ++ pp

-- ═══════════════════════════════════════════════════════════════
-- §2 FORMULA ENUMERATION
--
-- Generate all expressions: (a₁·a₂) / (b₁·b₂) [× π^p]
-- where a_i, b_i are from the atom set.
-- Depth 1: single atom / single atom
-- Depth 2: product of 2 / product of up to 2
-- Plus optional π factor.
-- ═══════════════════════════════════════════════════════════════

-- | All ratios a/b for single atoms
depth1 :: [Formula]
depth1 =
  [ Formula [atomName a] [atomName b] pp (atomVal a / atomVal b * piFactor pp)
  | a <- atoms, b <- atoms
  , atomVal a /= atomVal b  -- skip trivial 1
  , pp <- [0, 1, -1]
  ]

-- | All ratios (a₁·a₂)/b and a/(b₁·b₂) for two-atom products
depth2 :: [Formula]
depth2 =
  -- numerator pair / single denominator
  [ Formula [atomName a1, atomName a2] [atomName b] pp
            (atomVal a1 * atomVal a2 / atomVal b * piFactor pp)
  | a1 <- atoms, a2 <- atoms, b <- atoms
  , atomVal a1 <= atomVal a2  -- avoid duplicates
  , pp <- [0, 1, -1]
  ] ++
  -- single numerator / denominator pair
  [ Formula [atomName a] [atomName b1, atomName b2] pp
            (atomVal a / (atomVal b1 * atomVal b2) * piFactor pp)
  | a <- atoms, b1 <- atoms, b2 <- atoms
  , atomVal b1 <= atomVal b2
  , pp <- [0, 1, -1]
  ] ++
  -- pair / pair
  [ Formula [atomName a1, atomName a2] [atomName b1, atomName b2] pp
            (atomVal a1 * atomVal a2 / (atomVal b1 * atomVal b2) * piFactor pp)
  | a1 <- atoms, a2 <- atoms, b1 <- atoms, b2 <- atoms
  , atomVal a1 <= atomVal a2
  , atomVal b1 <= atomVal b2
  , pp <- [0]  -- skip π for pair/pair (too many combos)
  ]

-- | Additive formulas: a + b, a − b (for things like α⁻¹)
additive :: [Formula]
additive =
  [ Formula [atomName a ++ "+" ++ atomName b] [] pp
            ((atomVal a + atomVal b) * piFactor pp)
  | a <- atoms, b <- atoms
  , atomVal a >= atomVal b
  , pp <- [0, 1, -1]
  ] ++
  [ Formula [atomName a ++ "−" ++ atomName b] [] 0
            (atomVal a - atomVal b)
  | a <- atoms, b <- atoms
  , atomVal a > atomVal b
  ]

-- | Power formulas: a^b for small exponents
powers :: [Formula]
powers =
  [ Formula [atomName a ++ "^" ++ atomName b] [] 0
            (atomVal a ** atomVal b)
  | a <- atoms, b <- atoms
  , atomVal a > 1, atomVal a < 100
  , atomVal b > 0, atomVal b < 5
  , atomVal a ** atomVal b < 1e12  -- stay reasonable
  , atomVal a ** atomVal b > 1e-12
  ]

piFactor :: Int -> Double
piFactor 0 = 1.0
piFactor 1 = pi
piFactor (-1) = 1.0 / pi
piFactor n = pi ** fromIntegral n

-- | All candidate formulas
allFormulas :: [Formula]
allFormulas = depth1 ++ depth2 ++ additive ++ powers

-- ═══════════════════════════════════════════════════════════════
-- §3 PHYSICAL CONSTANTS DATABASE
--
-- Known constants from PDG, CODATA, NIST, structural biology.
-- Each entry: (name, value, unit, domain, known_crystal)
-- known_crystal = True if already in the 198 observables
-- ═══════════════════════════════════════════════════════════════

data PhysConst = PhysConst
  { pcName    :: !String
  , pcValue   :: !Double
  , pcUnit    :: !String
  , pcDomain  :: !String
  , pcKnown   :: !Bool     -- already in Crystal catalogue?
  } deriving (Show)

-- DIMENSIONLESS or ratio constants (these are what formulas can match)
knownConstants :: [PhysConst]
knownConstants =
  -- === Particle physics (dimensionless ratios) ===
  [ PhysConst "α⁻¹ (fine structure)"          137.036    "" "particle" True
  , PhysConst "sin²θ_W (Weinberg)"             0.23122    "" "particle" True
  , PhysConst "m_p/m_e (proton/electron)"      1836.153   "" "particle" True
  , PhysConst "m_μ/m_e (muon/electron)"        206.768    "" "particle" True
  , PhysConst "m_τ/m_e (tau/electron)"         3477.23    "" "particle" True
  , PhysConst "m_τ/m_μ (tau/muon)"             16.817     "" "particle" False
  , PhysConst "m_W/m_Z (W/Z ratio)"            0.8815     "" "particle" False
  , PhysConst "m_H/m_W (Higgs/W)"              1.558      "" "particle" False
  , PhysConst "m_H/m_Z (Higgs/Z)"              1.374      "" "particle" False
  , PhysConst "m_t/m_H (top/Higgs)"            1.380      "" "particle" False
  , PhysConst "m_t/m_W (top/W)"                2.149      "" "particle" False
  , PhysConst "m_b/m_τ (bottom/tau)"           2.356      "" "particle" False
  , PhysConst "m_c/m_s (charm/strange)"        11.76      "" "particle" False
  , PhysConst "m_s/m_d (strange/down)"         17.0       "" "particle" False
  , PhysConst "m_u/m_d (up/down)"              0.47       "" "particle" False
  , PhysConst "α_s(M_Z)"                       0.1179     "" "particle" True
  , PhysConst "G_F·v² (Fermi×VEV²)"           0.7071     "" "particle" True
  , PhysConst "V_us (CKM)"                     0.2243     "" "particle" True
  , PhysConst "V_cb (CKM)"                     0.0422     "" "particle" False
  , PhysConst "V_ub (CKM)"                     0.00394    "" "particle" False
  , PhysConst "V_us/V_cb ratio"                5.314      "" "particle" False
  , PhysConst "V_cb/V_ub ratio"                10.71      "" "particle" False

  -- === Nuclear ===
  , PhysConst "Fe-56 (most stable)"            56.0       "" "nuclear" True
  , PhysConst "deuteron BE (MeV)"              2.2245     "MeV" "nuclear" True
  , PhysConst "alpha BE/nucleon"               7.074      "MeV" "nuclear" False
  , PhysConst "neutron lifetime (s)"           878.4      "s" "nuclear" True
  , PhysConst "μ_p/μ_N (proton moment)"        2.7928     "" "nuclear" True
  , PhysConst "μ_n/μ_N (neutron moment)"       1.9130     "" "nuclear" True
  , PhysConst "μ_p/μ_n ratio"                  1.460      "" "nuclear" False
  , PhysConst "quadrupole moment ratio D"      0.2860     "fm²" "nuclear" False

  -- === Cosmology ===
  , PhysConst "Ω_Λ (dark energy)"              0.6847     "" "cosmo" True
  , PhysConst "Ω_m (matter)"                   0.3153     "" "cosmo" True
  , PhysConst "Ω_b (baryons)"                  0.0493     "" "cosmo" True
  , PhysConst "Ω_Λ/Ω_m ratio"                 2.172      "" "cosmo" False
  , PhysConst "Ω_m/Ω_b ratio"                 6.396      "" "cosmo" False
  , PhysConst "H₀ (km/s/Mpc)"                 67.4       "" "cosmo" True
  , PhysConst "T_CMB (K)"                      2.7255     "K" "cosmo" True
  , PhysConst "age/Hubble time"                0.964      "" "cosmo" False
  , PhysConst "σ₈"                             0.811      "" "cosmo" False
  , PhysConst "n_s (spectral index)"           0.9649     "" "cosmo" False

  -- === Chemistry ===
  , PhysConst "water angle (deg)"              104.48     "°" "chem" True
  , PhysConst "sp3 angle (deg)"                109.47     "°" "chem" True
  , PhysConst "sp2 angle (deg)"                120.0      "°" "chem" False
  , PhysConst "n_water (refractive)"           1.333      "" "optics" True
  , PhysConst "n_glass"                        1.5        "" "optics" True
  , PhysConst "n_diamond"                      2.417      "" "optics" False
  , PhysConst "pH neutral"                     7.0        "" "chem" True
  , PhysConst "Avogadro/1e23"                  6.022      "" "chem" False

  -- === Biology ===
  , PhysConst "amino acids"                    20.0       "" "bio" True
  , PhysConst "codons"                         64.0       "" "bio" True
  , PhysConst "helix residues/turn"            3.6        "" "bio" True
  , PhysConst "Flory exponent"                 0.4        "" "bio" True
  , PhysConst "β-sheet spacing (Å)"            3.5        "" "bio" True
  , PhysConst "Kleiber exponent"               0.75       "" "bio" True
  , PhysConst "bp per turn DNA"                10.4       "" "bio" True
  , PhysConst "Ramachandran allowed"           0.5625     "" "bio" True
  , PhysConst "GC content (avg genome)"        0.41       "" "bio" False
  , PhysConst "codon adaptation index"         0.5        "" "bio" False

  -- === Condensed matter ===
  , PhysConst "Ising z (square)"               4.0        "" "cond" True
  , PhysConst "Ising z (cubic)"                6.0        "" "cond" True
  , PhysConst "Ising T_c/J (2D square)"        2.269      "" "cond" False
  , PhysConst "BCS 2Δ/kT_c"                   3.528      "" "cond" True
  , PhysConst "Grüneisen parameter (metals)"   2.0        "" "cond" False
  , PhysConst "Lindemann ratio"                0.1        "" "cond" False
  , PhysConst "percolation p_c (square)"       0.5927     "" "cond" False
  , PhysConst "percolation p_c (triangular)"   0.5        "" "cond" False

  -- === Fluid dynamics ===
  , PhysConst "Kolmogorov exponent"            1.667      "" "fluid" True
  , PhysConst "von Kármán constant"            0.41       "" "fluid" False
  , PhysConst "Stokes drag factor"             24.0       "" "fluid" True
  , PhysConst "Re_crit (pipe)"                 2300.0     "" "fluid" False
  , PhysConst "Prandtl (air)"                  0.71       "" "fluid" False
  , PhysConst "Prandtl (water)"                7.0        "" "fluid" False

  -- === Astrophysics ===
  , PhysConst "Chandrasekhar exponent"         1.5        "" "astro" True
  , PhysConst "Eddington luminosity exp"       1.0        "" "astro" False
  , PhysConst "Salpeter IMF slope"             2.35       "" "astro" False
  , PhysConst "Jeans mass exponent"            1.5        "" "astro" False
  , PhysConst "Stefan-Boltzmann T exp"         4.0        "" "astro" True

  -- === Math constants (as ratios) ===
  , PhysConst "e (Euler)"                      2.71828    "" "math" False
  , PhysConst "φ (golden ratio)"               1.61803    "" "math" False
  , PhysConst "√2"                             1.41421    "" "math" False
  , PhysConst "√3"                             1.73205    "" "math" False
  , PhysConst "ln2"                            0.69315    "" "math" False
  , PhysConst "ln10"                           2.30259    "" "math" False
  , PhysConst "π/e"                            1.15573    "" "math" False
  , PhysConst "e/π"                            0.86525    "" "math" False
  , PhysConst "π²/6 (Basel)"                   1.64493    "" "math" False
  , PhysConst "Catalan constant"               0.91597    "" "math" False
  , PhysConst "Apéry ζ(3)"                     1.20206    "" "math" False
  ]

-- ═══════════════════════════════════════════════════════════════
-- §4 MATCHING ENGINE
-- ═══════════════════════════════════════════════════════════════

data Match = Match
  { matchFormula  :: !Formula
  , matchConst    :: !PhysConst
  , matchError    :: !Double    -- fractional error |formula - const| / const
  } deriving (Show)

-- | Find all matches within tolerance
findMatches :: Double -> [Formula] -> [PhysConst] -> [Match]
findMatches tol formulas consts =
  [ Match f c err
  | f <- formulas
  , let !v = fValue f
  , v > 0, not (isNaN v), not (isInfinite v)
  , c <- consts
  , let !cv = pcValue c
  , cv > 0
  , let !err = abs (v - cv) / cv
  , err < tol
  ]

-- | Remove duplicate matches (same constant, keep best formula)
dedup :: [Match] -> [Match]
dedup = nubBy (\a b -> pcName (matchConst a) == pcName (matchConst b))
      . sortBy (comparing matchError)

-- ═══════════════════════════════════════════════════════════════
-- §5 MAIN: RUN THE SEARCH
-- ═══════════════════════════════════════════════════════════════

main :: IO ()
main = do
  putStrLn "╔══════════════════════════════════════════════════════════════╗"
  putStrLn "║  CrystalDiscover — Formula Space Explorer                  ║"
  putStrLn "║  Searching algebraic expressions over A_F building blocks  ║"
  putStrLn "║  for matches against known physical constants              ║"
  putStrLn "╚══════════════════════════════════════════════════════════════╝"
  putStrLn ""

  let !formulas = allFormulas
  putStrLn $ "Building blocks: " ++ show (length atoms)
  putStrLn $ "Candidate formulas: " ++ show (length formulas)
  putStrLn $ "Physical constants: " ++ show (length knownConstants)
  putStrLn ""

  -- === DISCOVERY: Unknown constants matched by crystal formulas ===
  putStrLn "═══════════════════════════════════════════════════════════════"
  putStrLn " DISCOVERIES — Unknown constants matched by A_F expressions"
  putStrLn " (These are NOT in the existing 198 catalogue)"
  putStrLn "═══════════════════════════════════════════════════════════════"
  putStrLn ""

  let unknowns = filter (not . pcKnown) knownConstants
      !discoveries = dedup $ findMatches 0.01 formulas unknowns
  if null discoveries
    then putStrLn "  No new matches at 1% tolerance."
    else mapM_ printMatch discoveries
  putStrLn ""

  -- === VERIFICATION: Known constants re-derived ===
  putStrLn "═══════════════════════════════════════════════════════════════"
  putStrLn " VERIFICATION — Known Crystal observables re-derived"
  putStrLn "═══════════════════════════════════════════════════════════════"
  putStrLn ""

  let knowns = filter pcKnown knownConstants
      !verified = dedup $ findMatches 0.02 formulas knowns
  mapM_ printMatch verified
  putStrLn ""

  -- === NEAR MISSES: 1-5% matches (might be real with correction) ===
  putStrLn "═══════════════════════════════════════════════════════════════"
  putStrLn " NEAR MISSES — 1-5% matches (candidates for refinement)"
  putStrLn "═══════════════════════════════════════════════════════════════"
  putStrLn ""

  let !nearMisses = dedup $ findMatches 0.05 formulas unknowns
      !newNear = filter (\m -> matchError m >= 0.01) nearMisses
  if null newNear
    then putStrLn "  No near misses at 1-5%."
    else mapM_ printMatch (take 30 newNear)

  putStrLn ""
  putStrLn "═══════════════════════════════════════════════════════════════"
  let nDisc = length discoveries
      nVer  = length verified
      nNear = length newNear
  putStrLn $ "  Discoveries: " ++ show nDisc
          ++ "  Verified: " ++ show nVer
          ++ "  Near misses: " ++ show nNear
  putStrLn "═══════════════════════════════════════════════════════════════"

printMatch :: Match -> IO ()
printMatch m = do
  let f = matchFormula m
      c = matchConst m
      err = matchError m * 100
      star = if pcKnown c then "  ✓" else "  ★"
      rating | err < 0.1  = "■"
             | err < 0.5  = "●"
             | err < 1.0  = "◐"
             | otherwise  = "○"
  putStrLn $ "  " ++ rating ++ " " ++ pcName c
  putStrLn $ "    Crystal: " ++ formulaStr f ++ " = " ++ show (fValue f)
  putStrLn $ "    Known:   " ++ show (pcValue c)
          ++ (if null (pcUnit c) then "" else " " ++ pcUnit c)
  putStrLn $ "    Error:   " ++ show (round' err) ++ "%" ++ star
  putStrLn $ "    Domain:  " ++ pcDomain c
  putStrLn ""

round' :: Double -> Double
round' x = fromIntegral (round (x * 100) :: Int) / 100
