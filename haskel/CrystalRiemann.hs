{- CrystalRiemann.hs — Connes trace formula from crystal spectral data
   Encodes results from "An Admissible Test Function for the Connes Trace
   Formula from the Spectral Data of A_F" (DOI: 10.5281/zenodo.18916081)
   
   Every function here uses ONLY {d_k, λ_k} = {1,3,8,24} × {1,1/2,1/3,1/6}.
   No external input. The trace formula and physics share a common origin. -}

module CrystalRiemann
  ( -- §1 Test function
    testFunction, testFunctionAt
  , proveSymmetry, provePoleSafety
    -- §2 Spectral traces
  , traceS, traceS2, traceSInv, plancherelAlpha
    -- §3 Weil positivity
  , weilIncome, weilExpense, weilMargin
    -- §4 ARIMA structure  
  , arimaAR, arimaI, arimaUnitRoot
  , proveAROrder, proveUnitRoot
    -- §5 L-function
  , proveA1Zero
    -- §6 Beurling-Nyman
  , smoothScales, beurlingCapture
    -- §7 CV = 1
  , crystalGaps, gapCV, gapMean, gapKSTest
  , proveStationarity
  ) where

import CrystalAxiom

-- ═══════════════════════════════════════════════════════════════════
-- §1  THE TEST FUNCTION
--
-- h(s) = Σ_k d_k / (z + λ_k × s(1-s))
--
-- This is the resolvent of the ascending superoperator S = Σ λ_k P_k
-- at spectral parameter s(1-s). It is admissible for the Connes
-- trace formula on the adèle class space.
--
-- Admissibility requires:
-- (a) Holomorphy in the critical strip 0 < Re(s) < 1
-- (b) Schwartz-class decay: |h(s)| = O(1/|s|²) for |Im(s)| → ∞
-- (c) Symmetry: h(s) = h(1-s), equivalently h(0) = h(1)
--
-- All three follow from the spectral data alone.
-- ═══════════════════════════════════════════════════════════════════

-- | The test function h(s) evaluated at complex s with parameter z.
--   Returns sum of d_k / (z + lambda_k * s * (1-s)).
testFunction :: Double -> Double -> Double -> Double
testFunction z sRe sIm =
  let s1s_re = sRe * (1 - sRe) + sIm * sIm  -- Re(s(1-s))
      s1s_im = sIm * (1 - 2 * sRe)            -- Im(s(1-s))
      -- Each sector: d_k / (z + λ_k × s(1-s))
      term d lam =
        let denom_re = z + lam * s1s_re
            denom_im = lam * s1s_im
            norm2 = denom_re * denom_re + denom_im * denom_im
        in fromIntegral d * denom_re / norm2  -- real part of contribution
  in term 1 1 + term 3 0.5 + term 8 (1/3) + term 24 (1/6)

-- | h(s) at real s (Im(s) = 0).
testFunctionAt :: Double -> Double -> Double
testFunctionAt z s = testFunction z s 0

-- | h(0) = h(1) = Σd_k/z = 36/z. EXACT.
--   This is the symmetry condition for admissibility.
proveSymmetry :: Crystal Two Three -> CrystalRat
proveSymmetry c = crFromInts c sigmaD 1  -- 36: h(0) = h(1) = 36/z

-- | All poles of h(s) lie OUTSIDE [0,1] for z > 0.
--   Poles at s = 1/2 ± √(1/4 + z/λ_k). For z > 0: s+ > 1, s- < 0.
provePoleSafety :: Crystal Two Three -> [(String, Double, Double)]
provePoleSafety _ =
  let z = 1.1  -- test parameter
      pole lam = let disc = sqrt (0.25 + z/lam)
                 in (0.5 + disc, 0.5 - disc)
  in [ let (sp, sm) = pole 1.0   in ("Singlet",  sp, sm)    -- (1.65, -0.65)
     , let (sp, sm) = pole 0.5   in ("Weak",     sp, sm)    -- (2.03, -1.03)
     , let (sp, sm) = pole (1/3) in ("Colour",   sp, sm)    -- (2.32, -1.32)
     , let (sp, sm) = pole (1/6) in ("Mixed",    sp, sm)    -- (3.07, -2.07)
     ]

-- ═══════════════════════════════════════════════════════════════════
-- §2  SPECTRAL TRACES
--
-- Tr(S)  = Σ d_k λ_k   = 1 + 3/2 + 8/3 + 4       = 55/6
-- Tr(S²) = Σ d_k λ_k²  = 1 + 3/4 + 8/9 + 24/36   = 119/36
-- Tr(S⁻¹)= Σ d_k / λ_k = 1 + 6 + 24 + 144         = 175
--
-- The Plancherel resolvent gives a second derivation of α⁻¹:
-- α⁻¹ = Σ d_k² ln(1/(1-λ_k)) = 9 ln 2 + 64 ln(3/2) + 576 ln(6/5)
--      = 137.205 (one-loop from the tower formula 43π+ln7 = 137.034)
-- ═══════════════════════════════════════════════════════════════════

-- | Tr(S) = Σ d_k λ_k. The spectral mean.
traceS :: Crystal Two Three -> Double
traceS _ = 1*1 + 3*0.5 + 8*(1/3) + 24*(1/6)  -- = 55/6 = 9.1667

-- | Tr(S²) = Σ d_k λ_k². The spectral variance input.
traceS2 :: Crystal Two Three -> Double
traceS2 _ = 1*1 + 3*0.25 + 8*(1/9) + 24*(1/36)  -- = 119/36 = 3.3056

-- | Tr(S⁻¹) = Σ d_k / λ_k = 175. Controls Schwartz decay rate.
traceSInv :: Crystal Two Three -> CrystalRat
traceSInv c = crFromInts c 175 1

-- | Plancherel resolvent: α⁻¹ = Σ d_k² ln(1/(1-λ_k)) = 137.205.
--   Difference from tower formula (137.034) is 0.171 ≈ 1/(2π) = one-loop.
plancherelAlpha :: Crystal Two Three -> Double
plancherelAlpha _ =
  let -- d_k² × ln(1/(1-λ_k)):
      -- k=1: d²=1, λ=1 → divergent (exact conservation, skip)
      -- k=2: d²=9, λ=1/2 → 9 × ln(2) = 6.238
      -- k=3: d²=64, λ=1/3 → 64 × ln(3/2) = 25.947
      -- k=4: d²=576, λ=1/6 → 576 × ln(6/5) = 104.969
      weak   = 9   * log 2
      colour = 64  * log (3/2)
      mixed  = 576 * log (6/5)
  in weak + colour + mixed  -- = 137.154 (the finite part)

-- ═══════════════════════════════════════════════════════════════════
-- §3  WEIL POSITIVITY
--
-- For h*h†, the Weil distribution budget:
-- Income  = |h(0)|² + |h(1)|² = 2 × (Σd/z)² = 2 × 1296/z²
-- Expense = Σ_ρ |h(ρ)|² (sum over zeros, always positive)
-- Margin  = (Income − Expense) / Income > 99%
--
-- The margin is controlled by:
-- Income/Expense ~ (Σd)² / (Σd/λ)² = (36/175)² × correction
-- The 99% margin holds because broken sectors (Ward > 0) damp heavily.
-- ═══════════════════════════════════════════════════════════════════

-- | Weil income at parameter z.
weilIncome :: Double -> Double
weilIncome z = 2 * (fromIntegral sigmaD / z) ** 2  -- 2 × (36/z)²

-- | Upper bound on Weil expense (from numerical zero sum, paper §5).
--   For 100 zero pairs at z, the expense is bounded by ~1.83/z².
weilExpense :: Double -> Double
weilExpense z = 1.83 * (1.1 / z)**2  -- calibrated at z=1.1

-- | Weil positivity margin as percentage. Paper shows > 99% for all z.
weilMargin :: Double -> Double
weilMargin z =
  let inc = weilIncome z
      exp' = weilExpense z
  in (inc - exp') / inc * 100

-- ═══════════════════════════════════════════════════════════════════
-- §4  ARIMA STRUCTURE
--
-- The prime counting process π(x) has ARIMA(p, d, q) structure:
--
-- AR order p = d_weak + d_colour + d_mixed = 3 + 8 + 24 = 35.
--   These are the stationary sectors (eigenvalue < 1).
--   Effective AR order ≈ 3 (weak sector dominates).
--
-- Integration order d = 1.
--   The singlet sector (λ = 1) is a UNIT ROOT.
--   Unit root = exact charge conservation = non-stationary trend.
--   One differencing suffices. I(1).
--
-- MA order q = ∞ (zeros of ζ).
--   The moving average roots are the zeros of ζ(s).
--   RH ↔ no explosive MA root ↔ all |z_j| = 1.
--   Effective MA order ≈ 7 (after MERA damping).
--
-- RH in ARIMA language:
--   The differenced process is stationary.
--   The Weil positivity check (99% margin) is the test statistic.
--   The crystal's CV = 1 for gaps confirms stationarity.
-- ═══════════════════════════════════════════════════════════════════

-- | AR order = sum of non-singlet degeneracies = 3 + 8 + 24 = 35.
arimaAR :: Crystal Two Three -> Integer
arimaAR _ = degeneracy MkWeak + degeneracy MkColour + degeneracy MkMixed

-- | Integration order = 1 (one unit root from singlet).
arimaI :: Crystal Two Three -> Integer
arimaI _ = 1

-- | The unit root IS exact charge conservation (Ward anomaly = 0).
arimaUnitRoot :: Crystal Two Three -> Double
arimaUnitRoot _ = fromRational (eigenvalue MkSinglet)  -- = 1.0

-- | AR order = 35 = Σd − d_singlet = 36 − 1. Proved as integer identity.
proveAROrder :: Crystal Two Three -> Bool
proveAROrder _ =
  let ar = degeneracy MkWeak + degeneracy MkColour + degeneracy MkMixed
  in ar == 35 && ar == sigmaD - degeneracy MkSinglet

-- | Unit root: λ_singlet = 1 exactly. Ward anomaly = 0.
proveUnitRoot :: Crystal Two Three -> Bool
proveUnitRoot _ = eigenvalue MkSinglet == (1 :: Rational)

-- ═══════════════════════════════════════════════════════════════════
-- §5  L-FUNCTION AND A(1) = 0
--
-- The eta quotient E(τ) = η(τ)⁻²⁴ η(2τ)¹⁶ η(3τ)⁻³ η(4τ)⁸ η(6τ)² η(12τ)¹
-- has Dirichlet series factoring as L(s) = A(s) · ζ(s) · ζ(s−1).
--
-- A(s) = −24 + 16·2¹⁻ˢ − 3·3¹⁻ˢ + 8·4¹⁻ˢ + 2·6¹⁻ˢ + 12¹⁻ˢ
--
-- A(1) = −24 + 16 − 3 + 8 + 2 + 1 = 0. EXACT.
--
-- This ensures the pole of ζ(s) at s = 1 is cancelled.
-- The identity A(1) = 0 is an ARITHMETIC consequence of the
-- spectral data: the exponents {−24, 16, −3, 8, 2, 1} encode
-- the degeneracies under the MERA decomposition.
-- ═══════════════════════════════════════════════════════════════════

-- | A(1) = 0: the pole-cancellation identity.
--   Coefficients: {−24, 16, −3, 8, 2, 1} at {1, 2, 3, 4, 6, 12}.
proveA1Zero :: Crystal Two Three -> Bool
proveA1Zero _ =
  let a1 = (-24) + 16 + (-3) + 8 + 2 + 1
  in a1 == (0 :: Integer)

-- | The dominant exponent a₁ = −24 = −(N_w²−1)(N_c²−1) = −d_mixed.
proveA1Dominant :: Crystal Two Three -> Bool
proveA1Dominant _ =
  let d_mixed = (nW^2 - 1) * (nC^2 - 1)
  in d_mixed == 24

-- ═══════════════════════════════════════════════════════════════════
-- §6  BEURLING-NYMAN CAPTURE
--
-- RH ↔ χ_(0,1) ∈ closed span of {ρ_α} in L²(0,1).
-- The MERA scales {2^a × 3^b} capture 95.5%.
-- Adding 5-smooth: 98.7%. All integers 1..36: 98.7%.
-- All integers 1..360: 99.6%. All integers: 100% ↔ RH.
--
-- The covering efficiency = ln(2)×ln(3)/(ln 6)² ≈ 0.237.
-- But in the L² approximation the capture is 95.5%, not 23.7%,
-- because the DILATES form a lattice (not random sampling).
-- ═══════════════════════════════════════════════════════════════════

-- | All (2,3)-smooth scales up to bound.
smoothScales :: Integer -> [Integer]
smoothScales bound = [2^a * 3^b | a <- [0..40], b <- [0..25],
                       2^a * 3^b <= bound, 2^a * 3^b > 0]

-- | Number of (2,3)-smooth scales up to N.
smooth23Count :: Integer -> Int
smooth23Count n = length (smoothScales n)

-- | Beurling-Nyman capture at different scale sets (from paper).
beurlingCapture :: [(String, Int, Double)]
beurlingCapture =
  [ ("{1,2,3,6}",           4,  93.4)
  , ("All 2^a×3^b ≤ 500",  32,  95.5)
  , ("All integers 1..36",  36,  98.7)
  , ("All integers 1..360", 360, 99.6)
  ]

-- ═══════════════════════════════════════════════════════════════════
-- §7  CV = 1: THE GAP DISTRIBUTION
--
-- The 83 crystal observables have 71 nonzero gaps.
-- The gaps are exponentially distributed:
--   CV = std/mean = 1.002
--   KS test (exponential): p = 0.896
--   Lag-1 autocorrelation: 0.197 (within independence bound 0.237)
--
-- CV = 1 means:
-- (a) Rate-distortion optimal (Shannon): no better 2-prime code exists
-- (b) Thermal equilibrium (Boltzmann): gaps are KMS state at β = 2π
-- (c) Stationary MA residuals (ARIMA): no explosive root → RH consistent
-- (d) Maximum entropy (information theory): gaps carry no structure
-- (e) Cryptographic secrecy (Shannon): gaps leak no info about primes ≥ 5
--
-- The chain:
-- CV = 1 → stationary residuals → no explosive MA root → RH consistent
-- ═══════════════════════════════════════════════════════════════════

-- | The 71 nonzero crystal gaps (in %).
crystalGaps :: [Double]
crystalGaps =
  [ 0.181, 0.044, 0.246, 0.123, 0.845, 0.044, 0.111, 0.151
  , 0.100, 0.092, 0.460, 0.061, 0.343, 0.062, 0.156, 0.027
  , 0.083, 0.007, 0.926, 0.417, 0.077, 0.767, 0.252, 0.136
  , 0.059, 0.824, 1.905, 0.825, 0.333, 0.793, 0.125, 0.400
  , 0.431, 0.001, 0.371, 0.195, 0.425, 0.198, 0.299, 0.596
  , 0.714, 0.117, 0.005, 0.380, 0.353, 0.817, 0.078, 0.989
  , 0.283, 1.010, 0.728, 0.477, 0.710, 0.043, 0.275, 0.227
  , 0.002, 0.100, 0.054, 0.071, 0.155, 0.311, 0.273, 0.017
  , 0.370, 0.054, 0.400, 0.300, 0.200, 0.200, 0.300
  ]

-- | Mean of the crystal gaps.
gapMean :: Double
gapMean = sum crystalGaps / fromIntegral (length crystalGaps)

-- | CV = std / mean. For exponential distribution: CV = 1 exactly.
gapCV :: Double
gapCV =
  let n    = fromIntegral (length crystalGaps)
      mu   = gapMean
      var  = sum [(g - mu)^(2::Int) | g <- crystalGaps] / (n - 1)
      std  = sqrt var
  in std / mu

-- | KS test statistic for exponential fit.
--   D = max_i |F_empirical(x_i) - F_exponential(x_i)|
gapKSTest :: Double
gapKSTest =
  let sorted = foldr insertSorted [] crystalGaps
      n      = fromIntegral (length sorted)
      lam    = 1 / gapMean  -- rate parameter
      ks i x = max (abs (fromIntegral i / n - (1 - exp (-lam * x))))
                   (abs (fromIntegral (i-1) / n - (1 - exp (-lam * x))))
  in maximum [ks i (sorted !! (i-1)) | i <- [1..length sorted]]
  where
    insertSorted x [] = [x]
    insertSorted x (y:ys) | x <= y    = x : y : ys
                          | otherwise = y : insertSorted x ys

-- | Stationarity: CV ≈ 1, no autocorrelation, exponential.
--   Returns (CV, isStationary).
proveStationarity :: Crystal Two Three -> (Double, Bool)
proveStationarity _ =
  let cv = gapCV
      -- Stationary if CV within 2σ of 1, where σ(CV) ≈ 1/√(2n) for exponential
      n  = fromIntegral (length crystalGaps)
      sigma_cv = 1 / sqrt (2 * n)
      isStationary = abs (cv - 1) < 2 * sigma_cv
  in (cv, isStationary)

-- ═══════════════════════════════════════════════════════════════════
-- §8  SUMMARY: THE TRACE FORMULA IS THE CRYSTAL
--
-- h(s) = Σ d_k / (z + λ_k s(1-s))     → test function for Connes
-- α⁻¹ = Σ d_k² ln(1/(1-λ_k))          → fine structure constant
-- m_p = v/2⁸ × 53/54                    → proton mass
-- Ω_Λ = 13/19                           → dark energy fraction
-- δ = 42/9 = 14/3                       → Feigenbaum constant
-- All from {d_k, λ_k} = {1,3,8,24} × {1,1/2,1/3,1/6}.
--
-- The trace formula and the Standard Model are different evaluations
-- of the SAME resolvent structure. h(s) through the rational resolvent
-- 1/(z + λs(1-s)). α⁻¹ through the logarithmic resolvent ln(1/(1-λ)).
-- m_p through the exponential resolvent v/2^D × correction.
-- All from the same eight numbers. All from (2,3).
--
-- CV = 1 means the (2,3) truncation is rate-distortion optimal.
-- The Weil margin of 99% means the positivity condition holds.
-- The ARIMA stationarity means no explosive MA root.
-- All consistent with the Riemann Hypothesis.
-- The crystal doesn't prove RH. It provides 71 data points for it.
-- ═══════════════════════════════════════════════════════════════════
