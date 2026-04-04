-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- |
Module      : CrystalQMeasure
Description : 8 measurement operators from crystal sector structure
Author      : D. Montgomery — Crystal Topos — March 2026
License     : MIT
-}

module CrystalQMeasure
  ( -- * Measurements
    measureProjective, measurePOVM, measureWeak
  , measureParity, measureBell
  , measureHomodyne, measureHeterodyne
  , tomographyBases
    -- * Collapse
  , collapse, collapseToSector
    -- * Born probabilities
  , bornProbs, sectorProbs
    -- * Tomography (χ²-1 = 35 bases)
  , tomoRotation, tomoMeasureInBasis, tomoReconstruct, tomoFull, tomoFidelity
  ) where

import CrystalQBase

-- | Projective measurement in sector basis: P_k = |k⟩⟨k|
-- Returns (outcome, collapsed_state, probability).
measureProjective :: Vec -> Double -> (Int, Vec, Double)
measureProjective psi rand =
  let probs = map cxNorm2 psi
      cumul = scanl1 (+) probs
      outcome = length (takeWhile (< rand) cumul)
      k = min outcome (chi - 1)
  in (k, vBasis chi k, probs !! k)

-- | POVM measurement: E_k = (d_k/Σd) I_χ
-- Returns sector probabilities weighted by degeneracy.
measurePOVM :: Vec -> [(String, Double)]
measurePOVM psi =
  let probs = sectorProbs psi
      weighted = zipWith (\d p -> fromIntegral d * p / fromIntegral sigmaD) dims probs
  in zip sectorNames weighted

-- | Weak measurement: partial collapse with strength ε.
-- ρ → (1-ε)ρ + ε P_k ρ P_k / Tr(P_k ρ P_k)
measureWeak :: Double -> Int -> Vec -> Vec
measureWeak epsilon k psi =
  let p = cxNorm2 (psi !! k)
      original = vScale (sqrt (1 - epsilon)) psi
      projected = vScale (sqrt (epsilon / max p 1e-15)) (vBasis chi k)
      -- Weak measurement: mostly keep original, slightly collapse
  in vNormalize (zipWith cxAdd
      (map (cxScale (sqrt (1 - epsilon))) psi)
      (map (cxScale (sqrt epsilon * sqrt (max p 1e-15))) (vBasis chi k)))

-- | Parity measurement: even sectors (d=1,8) vs odd (d=3,24).
-- Returns (parity, probability).
measureParity :: Vec -> (String, Double)
measureParity psi =
  let probs = map cxNorm2 psi
      -- Even sectors: 0 (d=1), 2 (d=8); Odd: 1 (d=3), 3 (d=24)
      pEven = sum [probs !! k | k <- [0, 2], k < chi]
      pOdd  = sum [probs !! k | k <- [1, 3], k < chi]
  in if pEven >= pOdd then ("Even (d=1,8, sum=9)", pEven)
     else ("Odd (d=3,24, sum=27)", pOdd)

-- | Bell measurement on ℂ^χ ⊗ ℂ^χ: project onto |Φ_k⟩ = (1/√χ)Σ ω^(nk)|n,n⟩
measureBell :: Vec -> Int -> Double
measureBell psi k =
  let omega n = cxExp (cx 0 (2*pi*fromIntegral (n*k) / fromIntegral chi))
      s = 1.0 / sqrt (fromIntegral chi)
      -- Bell state |Φ_k⟩ amplitude at position (n,n)
      bellAmp n = cxScale s (omega n)
      -- Inner product
      overlap = foldl cxAdd cxZero
        [cxMul (cxConj (bellAmp n)) (psi !! (n * chi + n)) | n <- [0..chi-1]]
  in cxNorm2 overlap

-- | Homodyne: measure in sector eigenvalue basis (already diagonal).
measureHomodyne :: Vec -> [(Double, Double)]
measureHomodyne psi =
  [(lambdas !! min k 3, cxNorm2 (psi !! k)) | k <- [0..min chi (length psi) - 1]]

-- | Heterodyne: POVM on coherent sector states.
-- Returns Q-function values at χ phase points.
measureHeterodyne :: Vec -> [Double]
measureHeterodyne psi =
  [let coherent = [cxScale (1/sqrt (fromIntegral chi))
                   (cxExp (cx 0 (2*pi*fromIntegral (k*j) / fromIntegral chi)))
                  | j <- [0..chi-1]]
       overlap = foldl cxAdd cxZero (zipWith (\a b -> cxMul (cxConj a) b) coherent psi)
   in cxNorm2 overlap / (fromIntegral chi)
  | k <- [0..chi-1]]

-- | Tomography: χ²-1 = 35 measurement bases needed to reconstruct ρ.
tomographyBases :: Int
tomographyBases = chi * chi - 1  -- 35

-- ═══════════════════════════════════════════════════════════════
-- §2  COLLAPSE AND BORN RULE
-- ═══════════════════════════════════════════════════════════════

-- | Collapse to basis state |k⟩
collapse :: Int -> Vec
collapse k = vBasis chi k

-- | Collapse to sector k (for multi-particle: keep particle 2)
collapseToSector :: Int -> Vec -> Vec
collapseToSector k psi
  | length psi == chi = vBasis chi k
  | length psi == chi * chi =
      let sub = [psi !! (k * chi + j) | j <- [0..chi-1]]
          n = sqrt (sum (map cxNorm2 sub))
      in if n > 1e-15
         then [cxZero | _ <- [0..k*chi-1]]
              ++ map (cxScale (1/n)) sub
              ++ [cxZero | _ <- [(k+1)*chi..chi*chi-1]]
         else psi
  | otherwise = psi

-- | Born probabilities for each basis state
bornProbs :: Vec -> [Double]
bornProbs = map cxNorm2

-- | Sector probabilities (sum within degeneracy bands)
sectorProbs :: Vec -> [Double]
sectorProbs psi
  | length psi <= chi = map cxNorm2 psi ++ replicate (4 - min 4 (length psi)) 0
  | otherwise = -- Two-particle: marginal of particle 1
      [sum [cxNorm2 (psi !! (i * chi + j)) | j <- [0..chi-1]] | i <- [0..min 3 (chi-1)]]

-- ═══════════════════════════════════════════════════════════════
-- §3  TOMOGRAPHY FROM (2,3)
--
-- Full state reconstruction requires χ²-1 = 35 measurement bases.
-- Each basis is a DFT rotation of the sector basis by angle
-- θ_k = 2πk/(χ²-1) for k = 0..34.
-- The number 35 = χ²-1 = 6²-1 is from (2,3).
-- ═══════════════════════════════════════════════════════════════

-- | Rotation matrix: DFT-like basis change by angle θ
-- R(θ)_ij = (1/√χ) × exp(2πi × i × j / χ + i × θ × j)
tomoRotation :: Double -> Mat
tomoRotation theta =
  let s = 1.0 / sqrt (fromIntegral chi)
  in [[cxScale s (cxExp (cx 0 (2*pi*fromIntegral (i*j) / fromIntegral chi
                               + theta * fromIntegral j)))
      | j <- [0..chi-1]] | i <- [0..chi-1]]

-- | Measure state in rotated basis k, return Born probabilities.
-- k ∈ {0..χ²-2} = {0..34}.
tomoMeasureInBasis :: Int -> Vec -> [Double]
tomoMeasureInBasis k psi =
  let theta = 2 * pi * fromIntegral k / fromIntegral tomographyBases
      rot = tomoRotation theta
      rotated = mApply rot psi
  in map cxNorm2 rotated

-- | Reconstruct density matrix diagonal from χ²-1 = 35 basis measurements.
-- Input: list of (basis_index, probabilities) from tomoMeasureInBasis.
-- Output: χ×χ diagonal density matrix (sector populations).
-- Uses linear inversion: ρ_diag = average over all rotated measurements.
tomoReconstruct :: [Vec] -> Mat
tomoReconstruct measResults =
  let nBases = length measResults
      -- Average probabilities across all bases → diagonal of ρ
      avgProbs = [sum [cxNorm2 (m !! k) | m <- measResults]
                  / fromIntegral nBases | k <- [0..chi-1]]
      -- Construct diagonal density matrix
  in mFromDiag [cx p 0 | p <- avgProbs]

-- | Full tomography: measure state in all 35 bases, reconstruct ρ
tomoFull :: Vec -> Mat
tomoFull psi =
  let rotatedStates = [mApply (tomoRotation (2*pi*fromIntegral k
                        / fromIntegral tomographyBases)) psi
                      | k <- [0..tomographyBases-1]]
  in tomoReconstruct rotatedStates

-- | State fidelity: F(ψ, ρ) = ⟨ψ|ρ|ψ⟩ for pure target ψ and reconstructed ρ.
-- F = 1 means perfect reconstruction. Range [0,1].
tomoFidelity :: Vec -> Mat -> Double
tomoFidelity target rho =
  let result = mApply rho target
      overlap = foldl cxAdd cxZero (zipWith (\a b -> cxMul (cxConj a) b) target result)
  in abs (let (Cx r _) = overlap in r)
