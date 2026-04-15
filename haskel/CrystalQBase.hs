-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- |
Module      : CrystalQBase
Description : Shared quantum types: complex vectors, matrices, crystal constants
Author      : D. Montgomery — Crystal Topos — March 2026
License     : MIT

Base types for the crystal quantum library. All modules import this.
Everything derived from N_w=2, N_c=3.
-}

module CrystalQBase
  ( -- * Complex arithmetic
    Cx(..), cx, cxAdd, cxSub, cxMul, cxScale, cxConj, cxNorm2, cxExp, cxZero, cxOne
    -- * Vector operations
  , Vec, vNew, vBasis, vEqual, vAdd, vScale, vNorm, vNormalize, vDot, vProb, vEntropy
    -- * Matrix operations
  , Mat, mNew, mIdentity, mMul, mApply, mDagger, mTrace, mFromDiag, mFromVecs
    -- * Crystal constants (from N_w=2, N_c=3)
  , nW, nC, chi, beta0, dims, sigmaD, sigmaD2, gauss, dTotal, kappa
  , lambdas, energies, maxEntropy, massGap, sectorNames, sectorColors
  ) where

-- ═══════════════════════════════════════════════════════════════
-- §0  CRYSTAL CONSTANTS
-- ═══════════════════════════════════════════════════════════════

nW, nC, chi, beta0, sigmaD, sigmaD2, gauss, dTotal :: Int
nW = 2
nC = 3
chi = nW * nC                                -- 6
beta0 = (11 * nC - 2 * chi) `div` 3         -- 7
dims = [1, nC, nC^2-1, nW^3*nC] :: [Int]    -- [1,3,8,24]
sigmaD = sum dims                            -- 36
sigmaD2 = sum (map (^2) dims)                -- 650
gauss = nC^2 + nW^2                          -- 13
dTotal = sigmaD + chi                        -- 42
kappa :: Double
kappa = log (fromIntegral nC) / log (fromIntegral nW)  -- ln3/ln2

lambdas :: [Double]
lambdas = [1, 1/fromIntegral nW, 1/fromIntegral nC, 1/fromIntegral chi]

energies :: [Double]
energies = map (\l -> -log l) lambdas  -- [0, ln2, ln3, ln6]

maxEntropy :: Double
maxEntropy = log (fromIntegral chi)  -- ln(6)

massGap :: Double
massGap = log (fromIntegral nW)  -- ln(2)

sectorNames :: [String]
sectorNames = ["Singlet", "Weak", "Colour", "Mixed"]

sectorColors :: [String]
sectorColors = ["#ffffff", "#3b82f6", "#ef4444", "#f59e0b"]

-- ═══════════════════════════════════════════════════════════════
-- §1  COMPLEX ARITHMETIC
-- ═══════════════════════════════════════════════════════════════

data Cx = Cx !Double !Double deriving (Eq)

instance Show Cx where
  show (Cx r i)
    | abs i < 1e-12 = show r
    | abs r < 1e-12 = show i ++ "i"
    | i >= 0        = show r ++ "+" ++ show i ++ "i"
    | otherwise     = show r ++ show i ++ "i"

cx :: Double -> Double -> Cx
cx = Cx

cxZero, cxOne :: Cx
cxZero = Cx 0 0
cxOne  = Cx 1 0

cxAdd, cxSub, cxMul :: Cx -> Cx -> Cx
cxAdd (Cx a b) (Cx c d) = Cx (a+c) (b+d)
cxSub (Cx a b) (Cx c d) = Cx (a-c) (b-d)
cxMul (Cx a b) (Cx c d) = Cx (a*c-b*d) (a*d+b*c)

cxScale :: Double -> Cx -> Cx
cxScale s (Cx a b) = Cx (s*a) (s*b)

cxConj :: Cx -> Cx
cxConj (Cx a b) = Cx a (-b)

cxNorm2 :: Cx -> Double
cxNorm2 (Cx a b) = a*a + b*b

cxExp :: Cx -> Cx
cxExp (Cx a b) = let r = exp a in Cx (r * cos b) (r * sin b)

-- ═══════════════════════════════════════════════════════════════
-- §2  VECTOR OPERATIONS (ℂ^n)
-- ═══════════════════════════════════════════════════════════════

type Vec = [Cx]

vNew :: Int -> Vec
vNew n = replicate n cxZero

vBasis :: Int -> Int -> Vec
vBasis n k = [if i == k then cxOne else cxZero | i <- [0..n-1]]

vEqual :: Int -> Vec
vEqual n = let s = 1.0 / sqrt (fromIntegral n)
           in replicate n (Cx s 0)

vAdd :: Vec -> Vec -> Vec
vAdd = zipWith cxAdd

vScale :: Double -> Vec -> Vec
vScale s = map (cxScale s)

vNorm :: Vec -> Double
vNorm v = sqrt (sum (map cxNorm2 v))

vNormalize :: Vec -> Vec
vNormalize v = let n = vNorm v
               in if n > 1e-15 then map (cxScale (1/n)) v else v

vDot :: Vec -> Vec -> Cx
vDot a b = foldl cxAdd cxZero (zipWith (\x y -> cxMul (cxConj x) y) a b)

vProb :: Vec -> Int -> Double
vProb v k = cxNorm2 (v !! k)

vEntropy :: Vec -> Double
vEntropy v = negate $ sum [let p = cxNorm2 a in if p > 1e-15 then p * log p else 0 | a <- v]

-- ═══════════════════════════════════════════════════════════════
-- §3  MATRIX OPERATIONS (M_n(ℂ))
-- ═══════════════════════════════════════════════════════════════

type Mat = [[Cx]]  -- row-major

mNew :: Int -> Mat
mNew n = replicate n (replicate n cxZero)

mIdentity :: Int -> Mat
mIdentity n = [[if i==j then cxOne else cxZero | j <- [0..n-1]] | i <- [0..n-1]]

mMul :: Mat -> Mat -> Mat
mMul a b =
  let n = length a
      bt = transpose' b
  in [[foldl cxAdd cxZero (zipWith cxMul (a!!i) (bt!!j)) | j <- [0..n-1]] | i <- [0..n-1]]
  where transpose' [] = []; transpose' ([] : _) = []; transpose' xss = [h | (h:_) <- xss] : transpose' [t | (_:t) <- xss]

mApply :: Mat -> Vec -> Vec
mApply m v = [foldl cxAdd cxZero (zipWith cxMul row v) | row <- m]

mDagger :: Mat -> Mat
mDagger m = let n = length m
            in [[cxConj (m !! j !! i) | j <- [0..n-1]] | i <- [0..n-1]]

mTrace :: Mat -> Cx
mTrace m = foldl cxAdd cxZero [m !! i !! i | i <- [0..length m - 1]]

mFromDiag :: [Cx] -> Mat
mFromDiag ds = [[if i==j then ds!!i else cxZero | j <- [0..n-1]] | i <- [0..n-1]]
  where n = length ds

mFromVecs :: [Vec] -> Mat
mFromVecs = id  -- rows = vectors
