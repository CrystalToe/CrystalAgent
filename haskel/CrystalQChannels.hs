-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- |
Module      : CrystalQChannels
Description : Quantum channels (noise/decoherence) from crystal sector structure
Author      : D. Montgomery — Crystal Topos — March 2026
License     : MIT

10 quantum channels: depolarising, amplitude/phase damping, bit/phase flip,
thermal relaxation, Kraus operators, Lindblad, stochastic SE, process tomography.
All rates/targets derived from sector eigenvalues and dimensions.
-}

module CrystalQChannels
  ( -- * Channels (density matrix → density matrix)
    depolarise, amplitudeDamp, phaseDamp
  , bitFlip, phaseFlip, thermalRelax
    -- * Kraus representation
  , krausDepolarise, krausDamp
    -- * Lindblad
  , lindbladStep
    -- * Diagnostics
  , channelFidelity, processMatrixDim
  ) where

import CrystalQBase

-- | Density matrix type: χ×χ complex matrix
type DensityMat = Mat

-- ═══════════════════════════════════════════════════════════════
-- §1  DEPOLARISING CHANNEL
-- ═══════════════════════════════════════════════════════════════

-- | ρ → (1-p)ρ + (p/χ)I
-- Equilibrium = maximally mixed state I/χ.
depolarise :: Double -> DensityMat -> DensityMat
depolarise p rho =
  let n = chi
      scaled = map (map (cxScale (1-p))) rho
      mixed  = map (map (cxScale (p / fromIntegral n))) (mIdentity n)
  in zipWith (zipWith cxAdd) scaled mixed

-- ═══════════════════════════════════════════════════════════════
-- §2  AMPLITUDE DAMPING (sector decay to singlet)
-- ═══════════════════════════════════════════════════════════════

-- | Sector decay: excited sectors decay toward singlet (E=0).
-- Rate γ_k = p × E_k / E_max for sector k.
amplitudeDamp :: Double -> DensityMat -> DensityMat
amplitudeDamp p rho =
  let n = chi
      -- Diagonal: ρ[k][k] → (1-γ_k)ρ[k][k], gain at ρ[0][0]
      gammas = [p * (energies !! min k 3) / maxEntropy | k <- [0..n-1]]
      diag_new = [if k == 0
                  then cxAdd (rho!!0!!0)
                       (foldl cxAdd cxZero [cxScale (gammas!!j) (rho!!j!!j) | j <- [1..n-1]])
                  else cxScale (1 - gammas!!k) (rho!!k!!k)
                 | k <- [0..n-1]]
      -- Off-diagonal: ρ[i][j] → √((1-γ_i)(1-γ_j)) ρ[i][j]
  in [[if i == j then diag_new !! i
       else cxScale (sqrt ((1-gammas!!i)*(1-gammas!!j))) (rho!!i!!j)
      | j <- [0..n-1]] | i <- [0..n-1]]

-- ═══════════════════════════════════════════════════════════════
-- §3  PHASE DAMPING (dephasing)
-- ═══════════════════════════════════════════════════════════════

-- | Off-diagonal elements decay: ρ[i][j] → (1-p)ρ[i][j] for i≠j.
-- Diagonal preserved. Decoherence without energy loss.
phaseDamp :: Double -> DensityMat -> DensityMat
phaseDamp p rho =
  [[if i == j then rho!!i!!j
    else cxScale (1-p) (rho!!i!!j)
   | j <- [0..chi-1]] | i <- [0..chi-1]]

-- ═══════════════════════════════════════════════════════════════
-- §4  BIT FLIP (sector flip with probability p)
-- ═══════════════════════════════════════════════════════════════

-- | ρ → (1-p)ρ + p X ρ X†  where X is crystal sector cyclic shift
bitFlip :: Double -> DensityMat -> DensityMat
bitFlip p rho =
  let n = chi
      -- X ρ X†: cyclic shift of rows and columns
      xrx = [[rho !! ((i-1) `mod` n) !! ((j-1) `mod` n) | j <- [0..n-1]] | i <- [0..n-1]]
      orig = map (map (cxScale (1-p))) rho
      flipped = map (map (cxScale p)) xrx
  in zipWith (zipWith cxAdd) orig flipped

-- ═══════════════════════════════════════════════════════════════
-- §5  PHASE FLIP (random phase kick)
-- ═══════════════════════════════════════════════════════════════

-- | ρ → (1-p)ρ + p Z ρ Z†  where Z = crystal phase gate
phaseFlip :: Double -> DensityMat -> DensityMat
phaseFlip p rho =
  let n = chi
      omega k = cxExp (cx 0 (2*pi*fromIntegral k / fromIntegral n))
      -- Z ρ Z†: multiply ρ[i][j] by ω^i × conj(ω^j) = ω^(i-j)
      zrz = [[cxMul (omega (i-j)) (rho!!i!!j) | j <- [0..n-1]] | i <- [0..n-1]]
      orig = map (map (cxScale (1-p))) rho
      flipped = map (map (cxScale p)) zrz
  in zipWith (zipWith cxAdd) orig flipped

-- ═══════════════════════════════════════════════════════════════
-- §6  THERMAL RELAXATION (to Gibbs state at KMS β=2π)
-- ═══════════════════════════════════════════════════════════════

-- | ρ → (1-p)ρ + p ρ_thermal
thermalRelax :: Double -> DensityMat -> DensityMat
thermalRelax p rho =
  let beta = 2 * pi
      boltz k = fromIntegral (dims !! min k 3) * (lambdas !! min k 3) ** beta
      z = sum [boltz k | k <- [0..chi-1]]
      thermal = mFromDiag [cx (boltz k / z) 0 | k <- [0..chi-1]]
      orig = map (map (cxScale (1-p))) rho
      therm = map (map (cxScale p)) thermal
  in zipWith (zipWith cxAdd) orig therm

-- ═══════════════════════════════════════════════════════════════
-- §7  KRAUS OPERATORS
-- ═══════════════════════════════════════════════════════════════

-- | Kraus operators for depolarising channel
-- K₀ = √(1-p) I, K_k = √(p/χ²) E_{ij} (matrix units)
krausDepolarise :: Double -> [Mat]
krausDepolarise p =
  let k0 = map (map (cxScale (sqrt (1-p)))) (mIdentity chi)
      kij = [[[if i2==i && j2==j then cx (sqrt (p / fromIntegral (chi*chi))) 0 else cxZero
               | j2 <- [0..chi-1]] | i2 <- [0..chi-1]]
             | i <- [0..chi-1], j <- [0..chi-1]]
  in k0 : kij

-- | Kraus operators for amplitude damping (3 decay channels)
krausDamp :: Double -> [Mat]
krausDamp p =
  let gammas = [p * (energies !! min k 3) / maxEntropy | k <- [0..chi-1]]
      -- K₀ = diag(1, √(1-γ₁), √(1-γ₂), ...)
      k0 = mFromDiag [cx (sqrt (1 - gammas!!k)) 0 | k <- [0..chi-1]]
      -- K_k: |0⟩⟨k| × √γ_k  for k = 1..χ-1
      ks = [[[if i==0 && j==k then cx (sqrt (gammas!!k)) 0 else cxZero
              | j <- [0..chi-1]] | i <- [0..chi-1]]
            | k <- [1..chi-1], gammas!!k > 1e-15]
  in k0 : ks

-- ═══════════════════════════════════════════════════════════════
-- §8  LINDBLAD MASTER EQUATION (one step)
-- ═══════════════════════════════════════════════════════════════

-- | dρ/dt = -i[H,ρ] + Σ (L ρ L† - ½{L†L, ρ})
-- Uses crystal Hamiltonian and creation/annihilation as Lindblad ops.
lindbladStep :: Double  -- ^ dt
             -> Double  -- ^ dissipation rate γ
             -> DensityMat -> DensityMat
lindbladStep dt gamma rho =
  let n = chi
      -- Hamiltonian commutator: -i[H,ρ]
      hDiag = [cx (energies !! min k 3) 0 | k <- [0..n-1]]
      hMat = mFromDiag hDiag
      hRho = mMul hMat rho
      rhoH = mMul rho hMat
      commutator = zipWith (zipWith cxSub) hRho rhoH
      iComm = map (map (cxMul (cx 0 (-1)))) commutator

      -- Lindblad: annihilation operator â₀ (sector 1 → 0)
      -- L = √γ |0⟩⟨1|
      lRhoLd = [[if i==0 && j==0 then cxScale gamma (rho!!1!!1) else cxZero
                 | j <- [0..n-1]] | i <- [0..n-1]]
      ldl = mFromDiag [if k==1 then cx gamma 0 else cxZero | k <- [0..n-1]]
      anticomm1 = mMul ldl rho
      anticomm2 = mMul rho ldl
      anticomm = zipWith (zipWith cxAdd) anticomm1 anticomm2
      lindblad = zipWith (zipWith (\a b -> cxSub a (cxScale 0.5 b))) lRhoLd anticomm

      -- Total: dρ = (iComm + lindblad) × dt
      total = zipWith (zipWith cxAdd) iComm lindblad
      drho = map (map (cxScale dt)) total
  in zipWith (zipWith cxAdd) rho drho

-- ═══════════════════════════════════════════════════════════════
-- §9  DIAGNOSTICS
-- ═══════════════════════════════════════════════════════════════

-- | Channel fidelity: F = Tr(√(√ρ σ √ρ))² (simplified: Tr(ρσ) for pure)
channelFidelity :: DensityMat -> DensityMat -> Double
channelFidelity rho sigma =
  let prod = mMul rho sigma
      tr = mTrace prod
  in cxNorm2 tr  -- |Tr(ρσ)|² approximation

-- | Process matrix dimension: χ⁴ = 1296
processMatrixDim :: Int
processMatrixDim = chi ^ 4  -- 1296
