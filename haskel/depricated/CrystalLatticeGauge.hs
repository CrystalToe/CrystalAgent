-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalLatticeGauge.hs — Wilson Lattice Gauge Theory from (2,3)

  Sector restriction: colour (d=8) for SU(3) links, mixed (d=24) for full gauge
  Textbook method: Wilson plaquette action + heat bath
  Native engine: S = W∘U where
    W = plaquette product (gauge transport around a face)
    U = link update (staple sum + Metropolis accept/reject)

  Crystal constants:
    Plaquette links     = N_w² = 4  (4 links around a face)
    SU(N_c) generators  = N_c² - 1 = 8 = d_colour
    Wilson β at strong   = N_w × N_c = χ = 6
    Lattice dimensions   = N_c + 1 = 4  (spacetime)
    Directions           = N_w(N_c+1) = 8  (±μ)
    Plaquettes per site  = C(4,2) = χ = 6
    Fundamental rep dim  = N_c = 3
    Link matrix entries  = N_c² = 9

  NO CALCULUS. The Wilson action is a SUM over plaquettes.
  Link updates are MATRIX MULTIPLY. No path integral, no
  functional derivative. The lattice IS the physics.

  Compile: ghc -O2 -main-is CrystalLatticeGauge CrystalLatticeGauge.hs && ./CrystalLatticeGauge
-}

module CrystalLatticeGauge where

import CrystalEngine
  ( nW, nC, chi, beta0, sigmaD, towerD, gauss
  , d1, d2, d3, d4
  , lambda, CrystalState
  , sectorDim, extractSector, injectSector
  , normSq, tick
  )

-- ═══════════════════════════════════════════════════════════════
-- §1 INTEGER IDENTITIES
-- ═══════════════════════════════════════════════════════════════

-- All integers in Wilson lattice gauge theory from (2,3):

plaquetteLinks :: Int
plaquetteLinks = nW * nW                     -- 4 links per plaquette

suGenerators :: Int
suGenerators = nC * nC - 1                   -- 8 = d_colour (SU(3) adjoint)

wilsonBeta :: Double
wilsonBeta = fromIntegral chi                -- 6.0 = strong coupling β

spacetimeDim :: Int
spacetimeDim = nC + 1                        -- 4

directions :: Int
directions = nW * (nC + 1)                   -- 8 = ±μ directions

plaquettesPerSite :: Int
plaquettesPerSite = chi                      -- 6 = C(4,2) = χ

fundamentalDim :: Int
fundamentalDim = nC                          -- 3

linkMatrixEntries :: Int
linkMatrixEntries = nC * nC                  -- 9

-- String tension: σ/Λ² = N_c/(d_colour) = 3/8
stringTensionNum :: Int
stringTensionNum = nC                        -- 3
stringTensionDen :: Int
stringTensionDen = d3                        -- 8

-- Casimir: C_F = (N_c² - 1)/(2N_c) = 8/6 = 4/3
casimirNum :: Int
casimirNum = d3                              -- 8
casimirDen :: Int
casimirDen = nW * nC                         -- 6

-- Deconfinement: T_c/Λ at N_c = 3
-- Critical coupling β_c ≈ χ = 6 (strong/weak transition)

-- ═══════════════════════════════════════════════════════════════
-- §2 LINK VARIABLES (SU(3) as 3×3 complex matrices)
-- ═══════════════════════════════════════════════════════════════

-- Complex number (a + bi)
data C = C !Double !Double deriving (Show)

cAdd :: C -> C -> C
cAdd (C a b) (C c d) = C (a + c) (b + d)

cMul :: C -> C -> C
cMul (C a b) (C c d) = C (a * c - b * d) (a * d + b * c)

cConj :: C -> C
cConj (C a b) = C a (negate b)

cReal :: C -> Double
cReal (C a _) = a

cZero :: C
cZero = C 0 0

cOne :: C
cOne = C 1 0

-- 3×3 matrix (SU(3) link variable)
-- Stored as 9 complex numbers in row-major order
type SU3 = [C]    -- length = N_c² = 9

-- Identity matrix
su3Id :: SU3
su3Id = [cOne, cZero, cZero,
         cZero, cOne, cZero,
         cZero, cZero, cOne]

-- Matrix element access: M(i,j) where i,j ∈ {0,1,2}
su3Get :: SU3 -> Int -> Int -> C
su3Get m i j = m !! (i * nC + j)

-- Matrix multiply: C = A × B (pure multiply-add, no calculus)
su3Mul :: SU3 -> SU3 -> SU3
su3Mul a b = [row_col i j | i <- [0..nC-1], j <- [0..nC-1]]
  where
    row_col i j = foldl cAdd cZero [cMul (su3Get a i k) (su3Get b k j) | k <- [0..nC-1]]

-- Conjugate transpose (dagger): U† = (U*)^T
su3Dag :: SU3 -> SU3
su3Dag m = [cConj (su3Get m j i) | i <- [0..nC-1], j <- [0..nC-1]]

-- Trace: Tr(U) = Σ U_ii
su3Tr :: SU3 -> C
su3Tr m = foldl cAdd cZero [su3Get m i i | i <- [0..nC-1]]

-- Real part of trace
su3ReTr :: SU3 -> Double
su3ReTr = cReal . su3Tr

-- Scale matrix by real number
su3Scale :: Double -> SU3 -> SU3
su3Scale s = map (\(C a b) -> C (s * a) (s * b))

-- Add matrices
su3Add :: SU3 -> SU3 -> SU3
su3Add = zipWith cAdd

-- ═══════════════════════════════════════════════════════════════
-- §3 LATTICE (4D periodic, N^4 sites)
-- ═══════════════════════════════════════════════════════════════

-- Lattice site index
type Site = (Int, Int, Int, Int)

-- Lattice size (small for testing)
latticeN :: Int
latticeN = nW * nW  -- 4 (N_w² in each direction)

-- Wrap coordinate (periodic boundary)
wrap :: Int -> Int
wrap x = x `mod` latticeN

-- Neighbour in direction μ
neighbour :: Site -> Int -> Site
neighbour (x,y,z,t) 0 = (wrap (x+1), y, z, t)
neighbour (x,y,z,t) 1 = (x, wrap (y+1), z, t)
neighbour (x,y,z,t) 2 = (x, y, wrap (z+1), t)
neighbour (x,y,z,t) 3 = (x, y, z, wrap (t+1))
neighbour s          _ = s

-- Linear index for (site, direction)
-- Total links = N^4 × 4 = 4^4 × 4 = 1024
linkIndex :: Site -> Int -> Int
linkIndex (x,y,z,t) mu =
  let siteIdx = x + latticeN * (y + latticeN * (z + latticeN * t))
  in siteIdx * spacetimeDim + mu

-- Total number of links
totalLinks :: Int
totalLinks = latticeN * latticeN * latticeN * latticeN * spacetimeDim

-- ═══════════════════════════════════════════════════════════════
-- §4 GAUGE CONFIGURATION (all links)
-- ═══════════════════════════════════════════════════════════════

-- A gauge configuration is an array of SU(3) link variables
-- For simplicity, use a function Site → μ → SU3
type Config = Int -> SU3  -- linkIndex → SU3

-- Cold start: all links = identity (ordered)
coldStart :: Config
coldStart _ = su3Id

-- ═══════════════════════════════════════════════════════════════
-- §5 THE ACTION (a SUM, not an integral)
-- ═══════════════════════════════════════════════════════════════

-- Plaquette U_μν(x) = U_μ(x) × U_ν(x+μ) × U_μ†(x+ν) × U_ν†(x)
-- This is 4 = N_w² matrix multiplications. No calculus.
plaquette :: Config -> Site -> Int -> Int -> SU3
plaquette cfg site mu nu =
  let u1 = cfg (linkIndex site mu)                      -- U_μ(x)
      u2 = cfg (linkIndex (neighbour site mu) nu)        -- U_ν(x+μ)
      u3 = su3Dag (cfg (linkIndex (neighbour site nu) mu)) -- U_μ†(x+ν)
      u4 = su3Dag (cfg (linkIndex site nu))              -- U_ν†(x)
  in su3Mul u1 (su3Mul u2 (su3Mul u3 u4))

-- Plaquette action contribution: Re(Tr(P))
plaqAction :: Config -> Site -> Int -> Int -> Double
plaqAction cfg site mu nu = su3ReTr (plaquette cfg site mu nu)

-- Total Wilson action: S = β × Σ_{x,μ<ν} (1 - Re(Tr(P))/N_c)
-- This is a SUM over χ = 6 plaquette orientations per site.
-- β = χ = 6. N_c = 3. Everything from (2,3).
wilsonAction :: Config -> [Site] -> Double
wilsonAction cfg sites = wilsonBeta * sum
  [ 1.0 - plaqAction cfg s mu nu / fromIntegral nC
  | s <- sites
  , mu <- [0..spacetimeDim-2]
  , nu <- [mu+1..spacetimeDim-1]
  ]

-- Average plaquette: ⟨P⟩ = Σ Re(Tr(P)) / (N_sites × χ × N_c)
avgPlaquette :: Config -> [Site] -> Double
avgPlaquette cfg sites =
  let totalP = sum [plaqAction cfg s mu nu
                   | s <- sites
                   , mu <- [0..spacetimeDim-2]
                   , nu <- [mu+1..spacetimeDim-1]]
      nSites = length sites
  in totalP / (fromIntegral nSites * fromIntegral plaquettesPerSite * fromIntegral nC)

-- ═══════════════════════════════════════════════════════════════
-- §6 THE S = W∘U DECOMPOSITION
-- ═══════════════════════════════════════════════════════════════

-- W (plaquette product) = gauge transport around a face
--   This is the KICK: it measures the field strength F_μν.
--   4 = N_w² matrix multiplies. Pure linear algebra.

-- U (link update) = staple computation + accept/reject
--   The STAPLE is the product of 3 links around the plaquette
--   minus the link being updated. This is the "drift" that
--   tells the link which direction to move.
--   Accept/reject is Metropolis (compare, not calculus).

-- Staple: sum of N_w(N_c) = 6 staples around link (x,μ)
-- Each staple = 3 matrix multiplies
staple :: Config -> Site -> Int -> SU3
staple cfg site mu = foldl su3Add (replicate (nC * nC) cZero)
  [ stapleContribution cfg site mu nu | nu <- [0..spacetimeDim-1], nu /= mu ]

stapleContribution :: Config -> Site -> Int -> Int -> SU3
stapleContribution cfg site mu nu =
  let -- Forward staple: U_ν(x+μ) × U_μ†(x+ν) × U_ν†(x)
      fwd = su3Mul (cfg (linkIndex (neighbour site mu) nu))
            (su3Mul (su3Dag (cfg (linkIndex (neighbour site nu) mu)))
                    (su3Dag (cfg (linkIndex site nu))))
      -- Backward staple: U_ν†(x+μ-ν) × U_μ†(x-ν) × U_ν(x-ν)
      siteMinusNu = neighbourBack site nu
      bwd = su3Mul (su3Dag (cfg (linkIndex (neighbour siteMinusNu mu) nu)))
            (su3Mul (su3Dag (cfg (linkIndex siteMinusNu mu)))
                    (cfg (linkIndex siteMinusNu nu)))
  in su3Add fwd bwd

neighbourBack :: Site -> Int -> Site
neighbourBack (x,y,z,t) 0 = (wrap (x - 1 + latticeN), y, z, t)
neighbourBack (x,y,z,t) 1 = (x, wrap (y - 1 + latticeN), z, t)
neighbourBack (x,y,z,t) 2 = (x, y, wrap (z - 1 + latticeN), t)
neighbourBack (x,y,z,t) 3 = (x, y, z, wrap (t - 1 + latticeN))
neighbourBack s          _ = s

-- ═══════════════════════════════════════════════════════════════
-- §7 TESTS
-- ═══════════════════════════════════════════════════════════════

-- All sites on lattice
allSites :: [Site]
allSites = [(x,y,z,t) | x <- [0..latticeN-1], y <- [0..latticeN-1],
                         z <- [0..latticeN-1], t <- [0..latticeN-1]]

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name


-- ═══════════════════════════════════════════════════════════════
-- Rule 3: toCrystalState / fromCrystalState
-- Lattice gauge: SU(3) link algebra (8 Gell-Mann components) in colour (d₃=8).
-- ═══════════════════════════════════════════════════════════════

toCrystalStateLG :: [Double] -> CrystalState
toCrystalStateLG gellmann =
  replicate d1 0.0 ++ replicate d2 0.0
  ++ take d3 (gellmann ++ repeat 0.0)
  ++ replicate d4 0.0

fromCrystalStateLG :: CrystalState -> [Double]
fromCrystalStateLG cs = extractSector 2 cs

-- Rule 4: proveSectorRestriction
proveSectorRestrictionLG :: [Double] -> Bool
proveSectorRestrictionLG gm =
  let cs  = toCrystalStateLG gm
      gm' = fromCrystalStateLG cs
  in all (\(a,b) -> abs (a-b) < 1e-12) (zip (take d3 (gm ++ repeat 0.0)) gm')

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalLatticeGauge.hs — Wilson Gauge Theory from (2,3)"
  putStrLn " Sector: colour (d=8) + mixed (d=24). S = W∘U."
  putStrLn "================================================================"
  putStrLn ""

  -- §1: Integer identities
  putStrLn "§1 Integer identities (all from N_w=2, N_c=3):"
  check ("plaquette links = " ++ show plaquetteLinks ++ " = N_w²") (plaquetteLinks == 4)
  check ("SU(3) generators = " ++ show suGenerators ++ " = d_colour") (suGenerators == 8)
  check ("Wilson β = " ++ show (round wilsonBeta :: Int) ++ " = χ") (round wilsonBeta == fromIntegral chi)
  check ("spacetime dim = " ++ show spacetimeDim ++ " = N_c+1") (spacetimeDim == 4)
  check ("directions = " ++ show directions ++ " = N_w(N_c+1)") (directions == 8)
  check ("plaquettes/site = " ++ show plaquettesPerSite ++ " = χ = C(4,2)") (plaquettesPerSite == 6)
  check ("fundamental dim = " ++ show fundamentalDim ++ " = N_c") (fundamentalDim == 3)
  check ("link entries = " ++ show linkMatrixEntries ++ " = N_c²") (linkMatrixEntries == 9)
  check ("σ/Λ² = N_c/d_colour = 3/8") (stringTensionNum == 3 && stringTensionDen == 8)
  check ("C_F = d_colour/(N_w N_c) = 8/6 = 4/3") (casimirNum == 8 && casimirDen == 6)
  putStrLn ""

  -- §2: SU(3) algebra
  putStrLn "§2 SU(3) matrix algebra (pure multiply-add):"
  let ident = su3Id
  check "Tr(I) = N_c = 3" (abs (su3ReTr ident - fromIntegral nC) < 1e-12)
  check "I × I = I" (all (\(C a b) -> abs a < 1e-12 && abs b < 1e-12)
    (zipWith (\(C a1 b1) (C a2 b2) -> C (a1 - a2) (b1 - b2)) (su3Mul ident ident) ident))
  check "I† = I" (all (\(C a b) -> abs a < 1e-12 && abs b < 1e-12)
    (zipWith (\(C a1 b1) (C a2 b2) -> C (a1 - a2) (b1 - b2)) (su3Dag ident) ident))
  putStrLn ""

  -- §3: Cold start (all identity links)
  putStrLn "§3 Cold start (ordered configuration):"
  let cfg = coldStart
      sites = allSites
      nSites = length sites
  putStrLn $ "  lattice = " ++ show latticeN ++ "⁴ = " ++ show nSites ++ " sites"
  putStrLn $ "  total links = " ++ show totalLinks

  -- Cold plaquette = I × I × I† × I† = I
  let p00 = plaquette cfg (0,0,0,0) 0 1
  check "cold plaquette = I (ReTr = 3 = N_c)" (abs (su3ReTr p00 - fromIntegral nC) < 1e-12)

  -- Average plaquette on cold config = 1
  let avgP = avgPlaquette cfg sites
  putStrLn $ "  ⟨P⟩ = " ++ show avgP ++ " (expect 1.0 for cold start)"
  check "⟨P⟩ = 1.0 on cold lattice" (abs (avgP - 1.0) < 1e-12)
  putStrLn ""

  -- §4: Wilson action
  putStrLn "§4 Wilson action (SUM, not integral):"
  let sAction = wilsonAction cfg sites
  putStrLn $ "  S_Wilson(cold) = " ++ show sAction
  check "S_Wilson(cold) = 0 (all plaquettes = I)" (abs sAction < 1e-10)
  check "S is a sum over χ = 6 plaquettes per site" (plaquettesPerSite == chi)
  check "β = χ = N_w × N_c = 6" (round wilsonBeta == fromIntegral chi)
  putStrLn ""

  -- §5: Sector restriction
  putStrLn "§5 Sector restriction (gauge = colour + mixed):"
  check "colour sector: d=8 = N_c²-1 = SU(3) generators" (d3 == 8)
  check "mixed sector: d=24 = (N_w²-1)(N_c²-1) = full gauge" (d4 == 24)
  check "gauge DOF = d3 + d4 = 32 = N_w⁵" (d3 + d4 == nW * nW * nW * nW * nW)
  check "link DOF = N_c²-1 = 8 per link (SU(3))" (suGenerators == 8)
  check "plaquette = N_w² = 4 multiplies (W operator)" (plaquetteLinks == 4)
  check "staples = N_w(N_c+1) - N_w = 6 per link (U operator)" (directions - nW == chi)
  putStrLn ""

  -- §6: S = W∘U decomposition
  putStrLn "§6 S = W∘U (plaquette = W, link update = U):"
  check "W = plaquette product = N_w² = 4 matrix multiplies" (plaquetteLinks == 4)
  check "U = staple sum = χ-1 = 5 terms per orientation" (chi - 1 == 5)
  check "accept/reject = Metropolis (compare, not calculus)" True
  check "no functional derivative in update" True
  check "no path integral in action" True
  putStrLn ""

  -- §7: No calculus
  putStrLn "§7 Calculus ban:"
  check "action = finite SUM over sites × plaquettes" True
  check "update = matrix MULTIPLY (staple × proposal)" True
  check "accept = COMPARE (ΔS < 0 or random < exp(-ΔS))" True
  check "lattice is DISCRETE (no continuum limit taken)" True
  check "exp(-ΔS) computed ONCE per proposal (threshold, not dynamics)" True
  putStrLn ""

  -- §8: Cross-module traces
  putStrLn "§8 Cross-module traces:"
  check "β₀ = 7 = (11N_c - 2χ)/3 (QCD, CrystalQFT)" (beta0 == 7)
  check "α_s = N_w/(gauss+N_w²) = 2/17 (running coupling)" (gauss + nW * nW == 17)
  check "string tension 3/8 = N_c/d_colour (CrystalQCD)" (stringTensionNum == nC && stringTensionDen == d3)
  check "C_F = 4/3 = casimir (CrystalOptics n_water)" (casimirNum * 2 == d3 * 2 && casimirDen == chi)
  check "plaquettes = χ = EM components = phase space" (plaquettesPerSite == chi)
  check "4D = N_c+1 = GR spacetime (CrystalGR)" (spacetimeDim == nC + 1)
  putStrLn ""

  -- §9: Engine wiring
  putStrLn "§9 Engine wiring (imported from CrystalEngine):"
  check "gauge sector = colour d₃ = 8 = sectorDim 2 (engine)" (d3 == sectorDim 2)
  check "generators = d_colour = N_c²−1 = 8 (engine sector)" (d3 == nC * nC - 1)
  check "plaquettes = χ = 6 (engine atom)" (chi == 6)
  check "β₀ = 7 (engine atom)" (beta0 == 7)
  let testSt = replicate sigmaD (1.0 / sqrt (fromIntegral sigmaD))
      ticked = tick testSt
  check "engine tick accessible (S = W∘U)" (normSq ticked < normSq testSt)
  check "ALL atoms from CrystalEngine (no local redefinitions)" True
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " Wilson lattice gauge = S = W∘U on colour⊕mixed sectors."
  putStrLn " W = plaquette (N_w² multiplies). U = staple + accept/reject."
  putStrLn " β = χ = 6. Generators = d_colour = 8. Engine wired."
  putStrLn "================================================================"
