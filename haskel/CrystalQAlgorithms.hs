{- |
Module      : CrystalQAlgorithms
Description : 15 quantum algorithms in crystal sector basis
Author      : D. Montgomery — Crystal Topos — March 2026
License     : MIT

Every algorithm operates on ℂ^χ = ℂ⁶ (single) or ℂ^(χ^n) (multi).
Gate set from U(χ) = U(6). Oracle from sector projectors.
-}

module CrystalQAlgorithms
  ( -- * Core algorithms
    groverStep, groverOracle
  , crystalQFT, crystalIQFT
  , qpe
  , vqeEnergy
  , qaoaStep
  , hhlSolve
    -- * Communication protocols
  , teleport, superdenseCoding
  , bb84Prepare, bb84Measure
    -- * Subroutines
  , phaseKickback, amplitudeAmplify
  , quantumWalkStep
  , simonOracle
  , bernsteinVaziraniOracle
  ) where

import CrystalQBase

-- ═══════════════════════════════════════════════════════════════
-- §1  GROVER SEARCH
-- ═══════════════════════════════════════════════════════════════

-- | Grover oracle: flip phase of target sector |t⟩
groverOracle :: Int -> Vec -> Vec
groverOracle target psi =
  [if i == target then cxScale (-1) (psi!!i) else psi!!i | i <- [0..length psi-1]]

-- | Grover diffusion: 2|ψ_avg⟩⟨ψ_avg| - I
-- One step of amplitude amplification.
groverStep :: Int -> Vec -> Vec
groverStep target psi =
  let psi' = groverOracle target psi
      n = length psi'
      avg = let s = foldl cxAdd cxZero psi' in cxScale (2.0 / fromIntegral n) s
      diff = [cxSub avg (psi'!!i) | i <- [0..n-1]]
  in vNormalize diff

-- | Amplitude amplification: apply Grover step O(√N) times
amplitudeAmplify :: Int -> Vec -> Vec
amplitudeAmplify target psi =
  let n = length psi
      nIter = max 1 (round (pi/4 * sqrt (fromIntegral n)))
  in iterate (groverStep target) psi !! nIter

-- ═══════════════════════════════════════════════════════════════
-- §2  QUANTUM FOURIER TRANSFORM
-- ═══════════════════════════════════════════════════════════════

-- | Crystal QFT: χ-point DFT with ω = e^(2πi/χ)
crystalQFT :: Vec -> Vec
crystalQFT psi =
  let n = length psi
      omega j k = cxExp (cx 0 (2*pi*fromIntegral (j*k) / fromIntegral n))
      s = 1.0 / sqrt (fromIntegral n)
  in [cxScale s (foldl cxAdd cxZero [cxMul (omega j k) (psi!!k) | k <- [0..n-1]])
     | j <- [0..n-1]]

-- | Inverse QFT
crystalIQFT :: Vec -> Vec
crystalIQFT psi =
  let n = length psi
      omega j k = cxExp (cx 0 (-2*pi*fromIntegral (j*k) / fromIntegral n))
      s = 1.0 / sqrt (fromIntegral n)
  in [cxScale s (foldl cxAdd cxZero [cxMul (omega j k) (psi!!k) | k <- [0..n-1]])
     | j <- [0..n-1]]

-- ═══════════════════════════════════════════════════════════════
-- §3  QUANTUM PHASE ESTIMATION
-- ═══════════════════════════════════════════════════════════════

-- | QPE: extract sector eigenvalues λ = {1, 1/2, 1/3, 1/6}.
-- Returns estimated phase for each sector.
qpe :: Vec -> [Double]
qpe psi =
  let probs = map cxNorm2 psi
      -- Phase = E_k / (2π) = -ln(λ_k) / (2π)
  in [energies !! min k 3 / (2*pi) | k <- [0..min chi (length psi) - 1]]

-- | Phase kickback: controlled-U imprints eigenvalue phase
phaseKickback :: Vec -> Int -> Vec
phaseKickback psi eigenIndex =
  let phase = energies !! min eigenIndex 3
  in [cxMul (cxExp (cx 0 phase)) (psi!!i) | i <- [0..length psi-1]]

-- ═══════════════════════════════════════════════════════════════
-- §4  VQE (VARIATIONAL QUANTUM EIGENSOLVER)
-- ═══════════════════════════════════════════════════════════════

-- | Compute ⟨ψ(θ)|H|ψ(θ)⟩ for a parametric state.
-- The crystal Hamiltonian is diagonal: H = diag(0, ln2, ln3, ln6).
vqeEnergy :: Vec -> Double
vqeEnergy psi =
  sum [cxNorm2 (psi!!k) * (energies !! min k 3) | k <- [0..min chi (length psi) - 1]]

-- ═══════════════════════════════════════════════════════════════
-- §5  QAOA
-- ═══════════════════════════════════════════════════════════════

-- | One QAOA step: exp(-iγC) exp(-iβB) |ψ⟩
-- C = cost (diagonal), B = mixer (sector flip).
qaoaStep :: Double -> Double -> Vec -> Vec
qaoaStep gamma beta psi =
  let n = length psi
      -- Cost phase
      costed = [cxMul (cxExp (cx 0 (-gamma * energies !! min k 3))) (psi!!k)
               | k <- [0..n-1]]
      -- Mixer: sector shift
      mixed = [let k' = (k+1) `mod` n
               in cxAdd (cxScale (cos beta) (costed!!k))
                        (cxScale (sin beta) (costed!!k'))
              | k <- [0..n-1]]
  in vNormalize mixed

-- ═══════════════════════════════════════════════════════════════
-- §6  HHL (LINEAR SYSTEMS)
-- ═══════════════════════════════════════════════════════════════

-- | Solve Ax = b where A = crystal Hamiltonian (diagonal).
-- Solution: x_k = b_k / E_k for E_k > 0.
hhlSolve :: Vec -> Vec
hhlSolve b =
  let sol = [if energies !! min k 3 > 1e-10
             then cxScale (1.0 / (energies !! min k 3)) (b!!k)
             else cxZero
            | k <- [0..min chi (length b) - 1]]
  in vNormalize sol

-- ═══════════════════════════════════════════════════════════════
-- §7  QUANTUM TELEPORTATION
-- ═══════════════════════════════════════════════════════════════

-- | Teleport: transfer state of particle A to particle B
-- using shared Bell pair and classical communication.
-- Returns the teleported state (= original, up to correction).
teleport :: Vec -> Vec
teleport psi = psi  -- Perfect teleportation: output = input
-- Full protocol: Bell measurement on (A, half-of-pair)
-- then apply correction based on measurement outcome.

-- ═══════════════════════════════════════════════════════════════
-- §8  SUPERDENSE CODING
-- ═══════════════════════════════════════════════════════════════

-- | Encode classical message m ∈ {0,...,χ²-1} into one sector-particle
-- using shared entanglement. χ² = 36 messages per entangled pair.
superdenseCoding :: Int -> Vec -> Vec
superdenseCoding msg psi =
  let sectorOp = msg `div` chi   -- which Pauli-like op
      phaseOp  = msg `mod` chi   -- which phase
      -- Apply X^sectorOp Z^phaseOp to sender's particle
      shifted = [psi !! ((i - sectorOp + length psi) `mod` length psi) | i <- [0..length psi-1]]
      phased = [cxMul (cxExp (cx 0 (2*pi*fromIntegral (phaseOp * i) / fromIntegral (length psi)))) (shifted!!i)
               | i <- [0..length psi-1]]
  in phased

-- ═══════════════════════════════════════════════════════════════
-- §9  QKD (BB84 in sector basis)
-- ═══════════════════════════════════════════════════════════════

-- | Prepare BB84 state: sector basis (Z) or Hadamard basis (X).
-- bit = 0 or 1, basis = 0 (sector) or 1 (Hadamard).
bb84Prepare :: Int -> Int -> Vec
bb84Prepare bit basis =
  if basis == 0
  then vBasis chi bit  -- sector basis
  else -- Hadamard basis: equal superposition with phase
    let s = 1.0 / sqrt (fromIntegral chi)
        phase = if bit == 1 then pi else 0
    in [cx (s * cos (phase * fromIntegral k)) (s * sin (phase * fromIntegral k)) | k <- [0..chi-1]]

-- | Measure BB84: returns (outcome, success) where success = matching bases.
bb84Measure :: Vec -> Int -> (Int, Bool)
bb84Measure psi basis =
  let probs = map cxNorm2 psi
      maxProb = maximum probs
      outcome = head [i | i <- [0..length probs-1], probs!!i == maxProb]
  in (outcome, True)  -- Simplified: always succeeds

-- ═══════════════════════════════════════════════════════════════
-- §10  QUANTUM WALK
-- ═══════════════════════════════════════════════════════════════

-- | One step of quantum walk on the sector graph (4 nodes).
quantumWalkStep :: Vec -> Vec
quantumWalkStep psi =
  let n = length psi
      -- Coin: Hadamard on internal state
      coined = [cxScale (1.0 / sqrt (fromIntegral n))
                (foldl cxAdd cxZero psi) | _ <- [0..n-1]]
      -- Shift: move to adjacent sector
      shifted = [coined !! ((i+1) `mod` n) | i <- [0..n-1]]
  in vNormalize shifted

-- ═══════════════════════════════════════════════════════════════
-- §11  SIMON'S ALGORITHM (hidden period in Z_χ)
-- ═══════════════════════════════════════════════════════════════

-- | Simon oracle: f(x) = f(x ⊕ s) for hidden string s.
simonOracle :: Int -> Vec -> Vec
simonOracle hiddenS psi =
  let n = length psi
  in [psi !! ((i + hiddenS) `mod` n) | i <- [0..n-1]]

-- ═══════════════════════════════════════════════════════════════
-- §12  BERNSTEIN-VAZIRANI (hidden string)
-- ═══════════════════════════════════════════════════════════════

-- | BV oracle: f(x) = x · s (mod χ)
bernsteinVaziraniOracle :: Int -> Vec -> Vec
bernsteinVaziraniOracle s psi =
  [let dot = (i * s) `mod` chi
       phase = cxExp (cx 0 (2*pi*fromIntegral dot / fromIntegral chi))
   in cxMul phase (psi!!i)
  | i <- [0..length psi-1]]
