{-# LANGUAGE BangPatterns #-}
-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalOperators.hs — Component 5: The Five Operators

  Five operators act on the 36-dimensional CrystalState:

    W   — vertical isometry (coarse-grain between MERA layers)
    U   — horizontal disentangler (decouple within a layer)
    D_F — the Dirac operator on A_F (diagonal + off-diagonal)
    J   — real structure (particle <-> antiparticle conjugation)
    gamma — grading (chirality, left <-> right)

  This module is ONLY Component 5. It imports:
    CrystalAtoms   (Component 2: building blocks)
    CrystalSectors (Component 3: state type and sector structure)
    CrystalEigen   (Component 4: eigenvalues and W/U half-steps)

  Compile: ghc -O2 -main-is CrystalOperators CrystalOperators.hs && ./CrystalOperators
-}

module CrystalOperators
  ( -- W and U application (use eigenvalues on state)
    applyW, applyU

    -- Diagonal tick: S = W o U
  , tick, evolve

    -- D_F off-diagonal (the sideways operator)
  , SectorCoupling(..)
  , offDiagonalCouplings
  , dfTick, tickFull
  , Matrix, matVecMul, buildDFTick

    -- J (conjugation)
  , applyJ, colourConj, mixedConj
  , jSquaredIsIdentity

    -- gamma (chirality)
  , chiralityOf, applyGamma
  , projectLeft, projectRight
  , gammaSquaredIsIdentity
  , leftDOF, rightDOF

    -- Combined checks
  , checkAnticommutation, checkCommutator

    -- Mixing observables
  , mixingStrength, totalMixing, mixingSummary

    -- State observables
  , normSq, sectorWeight, entropy, energy

    -- Self-test
  , main
  ) where

import Data.List (foldl')
import CrystalAtoms hiding (main)
import CrystalSectors hiding (main)
import CrystalEigen hiding (main)

-- =====================================================================
-- S1 W AND U APPLICATION
-- =====================================================================

-- | Apply U (horizontal disentangler)
applyU :: CrystalState -> CrystalState
applyU st = zipWith (\i x -> uK (sectorOf i) * x) [0..] st

-- | Apply W (vertical isometry)
applyW :: CrystalState -> CrystalState
applyW st = zipWith (\i x -> wK (sectorOf i) * x) [0..] st

-- =====================================================================
-- S2 DIAGONAL TICK: S = W o U
-- =====================================================================

-- | Diagonal tick: S = W o U. Sectors don't mix.
-- ZERO TRANSCENDENTALS. Pure rational multiply.
tick :: CrystalState -> CrystalState
tick st = zipWith (\i x -> lambda (sectorOf i) * x) [0..] st

-- | Multiple ticks
evolve :: Int -> CrystalState -> [CrystalState]
evolve n st = take (n + 1) $ iterate tick st

-- =====================================================================
-- S3 D_F OFF-DIAGONAL (THE SIDEWAYS OPERATOR)
--
-- 13 couplings. Every entry a rational from (2,3).
-- =====================================================================

-- | Sector-to-sector coupling.
data SectorCoupling = SC
  { scFrom   :: !Int
  , scTo     :: !Int
  , scValue  :: !Double
  , scName   :: !String
  , scFormula:: !String
  } deriving (Show)

-- | All known off-diagonal couplings.
offDiagonalCouplings :: [SectorCoupling]
offDiagonalCouplings =
  [ -- Singlet <-> Weak (Yukawa leptons)
    SC 0 1 (tF / (gauss_d * fermat3_d))
           "Y_e (electron Yukawa)" "T_F/(gauss*F3)"
  , SC 0 1 (tF * gauss_d / (nC_d * fermat3_d))
           "Y_mu (muon Yukawa)" "T_F*gauss/(N_c*F3)"
  , SC 0 1 (tF * fermat3_d / (d4_d * sigmaD_d * pi))
           "Y_tau (tau Yukawa)" "T_F*F3/(d4*Sd*pi)"

    -- Weak <-> Colour (electroweak gauge)
  , SC 1 2 (nC_d / gauss_d)
           "g_W (weak gauge)" "N_c/gauss = 3/13"
  , SC 1 2 (d3_d / (nC_d * gauss_d))
           "g_1 (hypercharge)" "d3/(N_c*gauss) = 8/39"

    -- Colour <-> Mixed (strong gauge)
  , SC 2 3 (nW_d / fromIntegral (gauss + nW*nW))
           "g_s (strong gauge)" "N_w/(gauss+N_w^2) = 2/17"

    -- Weak <-> Mixed (quark Yukawa + CKM)
  , SC 1 3 (nW_d * nW_d / (sigmaD_d * gauss_d))
           "Y_u (up Yukawa)" "N_w^2/(Sd*gauss)"
  , SC 1 3 (cF * cF / (kappa * fromIntegral (chi - 1)))
           "V_us (Cabibbo)" "C_F^2/(kappa*(chi-1))"
  , SC 1 3 (fromIntegral (d3*d4) / fromIntegral (beta0 * sigmaD2))
           "V_cb (charm-bottom)" "d3*d4/(b0*Sd2) = 192/4550"
  , SC 1 3 (tF * cF / fromIntegral (gauss*gauss))
           "V_ub (up-bottom)" "T_F*C_F/gauss^2"

    -- Singlet <-> Mixed (neutrino)
  , SC 0 3 (1.0 / fromIntegral (towerD * fermat3 * sigmaD))
           "nu (neutrino)" "1/(D*F3*Sd)"

    -- Singlet <-> Colour (forbidden)
  , SC 0 2 0.0
           "gamma-g (forbidden)" "0"

    -- Weak self-coupling
  , SC 1 1 (nC_d / (gauss_d * pi))
           "WWZ (weak self)" "N_c/(gauss*pi)"
  ]

-- | Matrix type
type Matrix = [[Double]]

-- | Build the full 36x36 tick matrix.
buildDFTick :: Matrix
buildDFTick =
  let n = sigmaD
      diag = [[if i == j then lambda (sectorOf i) else 0
               | j <- [0..n-1]] | i <- [0..n-1]]
      addMixing mat (SC from to val _ _) =
        if val == 0 then mat
        else let sFrom = sectorStart from
                 dFrom = sectorDim from
                 sTo   = sectorStart to
                 dTo   = sectorDim to
                 perComp = val / sqrt (fromIntegral (dFrom * dTo))
                 addEntry m i j v =
                   let row = m !! i
                       row' = take j row ++ [row !! j + v] ++ drop (j+1) row
                   in take i m ++ [row'] ++ drop (i+1) m
                 addBlock m =
                   foldl' (\m' (fi,ti) ->
                     let m'' = addEntry m' (sFrom+fi) (sTo+ti) perComp
                     in addEntry m'' (sTo+ti) (sFrom+fi) perComp
                   ) m [(fi,ti) | fi <- [0..dFrom-1], ti <- [0..dTo-1]]
             in addBlock mat
  in foldl' addMixing diag offDiagonalCouplings

-- | The 36x36 matrix (computed once at module load)
dfTick :: Matrix
dfTick = buildDFTick

-- | Matrix-vector multiply
matVecMul :: Matrix -> CrystalState -> CrystalState
matVecMul mat st = [sum (zipWith (*) row st) | row <- mat]

-- | Full tick with off-diagonal mixing.
tickFull :: CrystalState -> CrystalState
tickFull = matVecMul dfTick

-- =====================================================================
-- S4 J — REAL STRUCTURE (Conjugation)
-- =====================================================================

-- | Apply J (charge conjugation)
applyJ :: CrystalState -> CrystalState
applyJ st =
  let s = extractSector 0 st
      w = extractSector 1 st
      c = extractSector 2 st
      m = extractSector 3 st
      s' = s
      w' = case w of
             [w1,w2,w3] -> [w1, -w2, -w3]
             _          -> w
      c' = colourConj c
      m' = mixedConj m
  in injectSector 0 s' (injectSector 1 w' (injectSector 2 c' (injectSector 3 m' zeroState)))

-- | Colour conjugation: swap pairs in Gell-Mann basis
colourConj :: [Double] -> [Double]
colourConj [c1,c2,c3,c4,c5,c6,c7,c8] = [c2,c1,c4,c3,c6,c5,c8,c7]
colourConj cs = cs

-- | Mixed conjugation: weak x colour on 24 = 3 x 8
mixedConj :: [Double] -> [Double]
mixedConj ms =
  let groups = chunksOf 8 ms
  in case groups of
       [g1, g2, g3] ->
         colourConj g1 ++ map negate (colourConj g2) ++ map negate (colourConj g3)
       _ -> ms

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = let (h,t) = splitAt n xs in h : chunksOf n t

-- | Verify J^2 = I
jSquaredIsIdentity :: CrystalState -> Bool
jSquaredIsIdentity st =
  let jj = applyJ (applyJ st)
  in all (\(a,b) -> abs (a - b) < 1e-14) (zip st jj)

-- =====================================================================
-- S5 gamma — GRADING (Chirality)
-- =====================================================================

-- | Chirality of each component: +1 = left, -1 = right
chiralityOf :: Int -> Double
chiralityOf i
  | i < d1 = 1.0
  | i < d1 + d2 = if (i - d1) < nW then 1.0 else (-1.0)
  | i < d1 + d2 + d3 = if (i - d1 - d2) < d3 `div` 2 then 1.0 else (-1.0)
  | otherwise = if (i - d1 - d2 - d3) < d4 `div` 2 then 1.0 else (-1.0)

-- | Apply gamma grading
applyGamma :: CrystalState -> CrystalState
applyGamma st = zipWith (\i x -> chiralityOf i * x) [0..] st

-- | Verify gamma^2 = I
gammaSquaredIsIdentity :: CrystalState -> Bool
gammaSquaredIsIdentity st =
  let gg = applyGamma (applyGamma st)
  in all (\(a,b) -> abs (a - b) < 1e-14) (zip st gg)

-- | Left-handed projection: P_L = (1 + gamma)/2
projectLeft :: CrystalState -> CrystalState
projectLeft st = zipWith (\i x -> if chiralityOf i > 0 then x else 0) [0..] st

-- | Right-handed projection: P_R = (1 - gamma)/2
projectRight :: CrystalState -> CrystalState
projectRight st = zipWith (\i x -> if chiralityOf i < 0 then x else 0) [0..] st

-- | Left-handed DOF per sector
leftDOF :: Int -> Int
leftDOF 0 = 1
leftDOF 1 = nW
leftDOF 2 = d3 `div` 2
leftDOF 3 = d4 `div` 2
leftDOF _ = 0

-- | Right-handed DOF per sector
rightDOF :: Int -> Int
rightDOF 0 = 0
rightDOF 1 = d2 - nW
rightDOF 2 = d3 - d3 `div` 2
rightDOF 3 = d4 - d4 `div` 2
rightDOF _ = 0

-- =====================================================================
-- S6 COMBINED CHECKS
-- =====================================================================

-- | {D_F, gamma} = D_F*gamma + gamma*D_F
checkAnticommutation :: CrystalState -> Double
checkAnticommutation st =
  let df_g = tickFull (applyGamma st)
      g_df = applyGamma (tickFull st)
      anticomm = zipWith (+) df_g g_df
  in sqrt (sum (map (\x -> x*x) anticomm))

-- | [D_F, J] = D_F*J - J*D_F. NON-ZERO = CP violation.
checkCommutator :: CrystalState -> Double
checkCommutator st =
  let df_j = tickFull (applyJ st)
      j_df = applyJ (tickFull st)
      comm = zipWith (-) df_j j_df
  in sqrt (sum (map (\x -> x*x) comm))

-- =====================================================================
-- S7 MIXING OBSERVABLES
-- =====================================================================

-- | Mixing strength between two sectors
mixingStrength :: Int -> Int -> Double
mixingStrength from to =
  let relevant = filter (\sc -> scFrom sc == from && scTo sc == to
                              || scFrom sc == to && scTo sc == from)
                        offDiagonalCouplings
  in sqrt (sum (map (\sc -> scValue sc * scValue sc) relevant))

-- | Total off-diagonal strength
totalMixing :: Double
totalMixing = sqrt (sum (map (\sc -> scValue sc * scValue sc) offDiagonalCouplings))

-- | Sector-resolved mixing summary
mixingSummary :: [(String, Double)]
mixingSummary =
  [ ("singlet<->weak",   mixingStrength 0 1)
  , ("singlet<->colour", mixingStrength 0 2)
  , ("singlet<->mixed",  mixingStrength 0 3)
  , ("weak<->colour",    mixingStrength 1 2)
  , ("weak<->mixed",     mixingStrength 1 3)
  , ("colour<->mixed",   mixingStrength 2 3)
  ]

-- =====================================================================
-- S8 STATE OBSERVABLES
-- =====================================================================

-- | Total norm squared
normSq :: CrystalState -> Double
normSq = sum . map (\x -> x * x)

-- | Sector weight (probability in sector k)
sectorWeight :: Int -> CrystalState -> Double
sectorWeight k st = sum . map (\x -> x * x) $ extractSector k st

-- | Shannon entropy
entropy :: CrystalState -> Double
entropy st =
  let total = normSq st
      ps = [sectorWeight k st / total | k <- [0..3], sectorWeight k st > 0]
  in negate $ sum [p * log p | p <- ps, p > 0]

-- | Energy from eigenvalues: E_k = -ln(lambda_k)
energy :: CrystalState -> Double
energy st =
  let total = normSq st
  in sum [sectorWeight k st / total * negate (log (lambda k))
         | k <- [0..3], lambda k > 0]

-- =====================================================================
-- S9 SELF-TEST
-- =====================================================================

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

r4 :: Double -> Double
r4 x = fromIntegral (round (x * 10000) :: Int) / 10000

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalOperators.hs — Component 5: The Five Operators"
  putStrLn " Imports: CrystalAtoms (2) + CrystalSectors (3) + CrystalEigen (4)"
  putStrLn "================================================================"
  putStrLn ""

  let st0 = replicate sigmaD (1.0 / fromIntegral sigmaD)
  let testSt = [fromIntegral i / fromIntegral sigmaD | i <- [1..sigmaD :: Int]]

  putStrLn "S1 Tick (diagonal):"
  check "tick contracts" (normSq (tick st0) < normSq st0)
  check "W o U = tick" (all (\(a,b) -> abs (a-b) < 1e-14) $ zip (applyW (applyU st0)) (tick st0))
  putStrLn ""

  putStrLn "S2 D_F matrix (36x36):"
  check "36x36" (length dfTick == 36 && all (\r -> length r == 36) dfTick)
  let offCount = length [() | i <- [0..35], j <- [0..35], i/=j, abs(dfTick!!i!!j) > 1e-15]
  putStrLn $ "  off-diagonal non-zero: " ++ show offCount
  check "has mixing" (offCount > 0)
  putStrLn ""

  putStrLn "S3 Couplings:"
  check "sin2_W = 3/13 = 0.2308" (abs (nC_d / gauss_d - 0.23077) < 0.001)
  check "V_cb = 192/4550" (abs (fromIntegral(d3*d4) / fromIntegral(beta0*sigmaD2) - 0.0422) < 0.001)
  check "alpha_s = 2/17" (abs (nW_d / fromIntegral(gauss+nW*nW) - 0.1176) < 0.002)
  putStrLn ""

  putStrLn "S4 J (conjugation):"
  check "J^2 = I" (jSquaredIsIdentity testSt)
  let jSt = applyJ testSt
  check "J preserves singlet" (jSt !! 0 == testSt !! 0)
  check "J flips weak charged" (jSt !! 2 == -(testSt !! 2))
  putStrLn ""

  putStrLn "S5 gamma (chirality):"
  check "gamma^2 = I" (gammaSquaredIsIdentity testSt)
  let totalL = sum [leftDOF k | k <- [0..3]]
      totalR = sum [rightDOF k | k <- [0..3]]
  check ("L=" ++ show totalL ++ " R=" ++ show totalR) (totalL == 19 && totalR == 17)
  check "L+R = 36" (totalL + totalR == sigmaD)
  check "L-R = 2 = N_w" (totalL - totalR == nW)
  putStrLn ""

  putStrLn "S6 Full tick vs diagonal:"
  let diff_ = sqrt (sum (zipWith (\a b -> (a-b)*(a-b)) (tick st0) (tickFull st0)))
  check "tickFull /= tick" (diff_ > 1e-10)
  putStrLn ""

  putStrLn "S7 CP violation:"
  let cpv = checkCommutator st0
  check "[D_F, J] /= 0 (CP exists)" (cpv > 1e-10)
  putStrLn ""

  putStrLn "S8 Integer identities:"
  check "N_c * 13 = 3 * gauss" (nC * 13 == 3 * gauss)
  check "d3 * d4 = 192" (d3 * d4 == 192)
  check "b0 * Sd2 = 4550" (beta0 * sigmaD2 == 4550)
  check "gauss + N_w^2 = 17" (gauss + nW*nW == 17)
  check "d4 = d2 * d3" (d4 == d2 * d3)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " Component 5 only. Sectors from 3. Eigenvalues from 4. Clean."
  putStrLn "================================================================"
