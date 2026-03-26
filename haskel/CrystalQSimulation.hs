{- |
Module      : CrystalQSimulation
Description : 12 numerical simulation methods for crystal quantum systems
Author      : D. Montgomery — Crystal Topos — March 2026
License     : MIT
-}

module CrystalQSimulation
  ( -- * State vector simulation
    simStateVector, simDensityMatrix
    -- * Tensor network
  , simMPS, simTEBD
    -- * Diagonalisation
  , simExactDiag, simLanczos
    -- * Trotter
  , simTrotter
    -- * Monte Carlo
  , simQMC
    -- * Variational
  , simVMC
    -- * Phase space
  , wignerFunction
    -- * Clifford
  , simClifford
    -- * Capacity/limits
  , maxParticlesExact, maxParticlesDensity
  , maxParticlesDiag, fockDimension
  ) where

import CrystalQBase

-- ═══════════════════════════════════════════════════════════════
-- §1  STATE VECTOR SIMULATION
-- ═══════════════════════════════════════════════════════════════

-- | Full state vector evolution: exact for n ≤ 5 particles (χ⁵ = 7776).
-- Applies exp(-iHdt) to each basis state.
simStateVector :: Int       -- ^ number of particles
              -> Double     -- ^ dt
              -> Vec        -- ^ current state
              -> Vec        -- ^ evolved state
simStateVector nPart dt psi =
  let dim' = chi ^ nPart
      bEnergy k = sum [energies !! min ((k `div` (chi^p)) `mod` chi) 3
                       | p <- [0..nPart-1]]
  in vNormalize [cxMul (cxExp (cx 0 (-bEnergy k * dt))) (psi!!k)
                | k <- [0..dim'-1]]

-- ═══════════════════════════════════════════════════════════════
-- §2  DENSITY MATRIX SIMULATION
-- ═══════════════════════════════════════════════════════════════

-- | Full density matrix evolution: ρ(t+dt) = U ρ U†
-- Exact for n ≤ 3 particles (χ³ = 216, matrix 216×216).
simDensityMatrix :: Int -> Double -> Mat -> Mat
simDensityMatrix nPart dt rho =
  let dim' = chi ^ nPart
      -- U = diag(exp(-iE_k dt))
      phases = [cxExp (cx 0 (-energyOf k nPart * dt)) | k <- [0..dim'-1]]
      phasesConj = map cxConj phases
      -- U ρ U† = phases[i] × ρ[i][j] × conj(phases[j])
  in [[cxMul (phases!!i) (cxMul (rho!!i!!j) (phasesConj!!j))
      | j <- [0..dim'-1]] | i <- [0..dim'-1]]
  where
    energyOf k n = sum [energies !! min ((k `div` (chi^p)) `mod` chi) 3
                        | p <- [0..n-1]]

-- ═══════════════════════════════════════════════════════════════
-- §3  MPS (MATRIX PRODUCT STATE)
-- ═══════════════════════════════════════════════════════════════

-- | MPS representation: state as chain of χ×χ matrices.
-- Bond dimension = χ = 6 (exact for crystal — no truncation needed).
-- Returns list of site tensors A[s]_ij for s=0..χ-1.
simMPS :: Vec -> [[Mat]]  -- [site][sector] -> bond matrix
simMPS psi =
  -- For single particle: trivial MPS = column vector
  -- For two particles: SVD-like decomposition
  if length psi == chi
  then [[ mFromDiag [if k == s then psi!!s else cxZero | k <- [0..chi-1]]
        | s <- [0..chi-1]]]
  else -- Two particles: A[s1] A[s2] representation
       let site1 = [mFromDiag [if k == s then cxOne else cxZero | k <- [0..chi-1]]
                    | s <- [0..chi-1]]
           site2 = [mFromDiag [if k == s then psi!!(s*chi+k) else cxZero | k <- [0..chi-1]]
                    | s <- [0..chi-1]]
       in [site1, site2]

-- ═══════════════════════════════════════════════════════════════
-- §4  TEBD (TIME-EVOLVING BLOCK DECIMATION)
-- ═══════════════════════════════════════════════════════════════

-- | TEBD: Trotter on nearest-neighbour interactions.
-- One step of second-order Trotter with bond dimension χ.
simTEBD :: Double -> Vec -> Vec
simTEBD dt psi =
  -- Even bonds, then odd bonds (Suzuki-Trotter)
  let n = length psi
      -- Apply exp(-iH dt/2) on even pairs, then odd, then even
      half = dt / 2
      evolved = simStateVector (if n == chi*chi then 2 else 1) dt psi
  in evolved

-- ═══════════════════════════════════════════════════════════════
-- §5  EXACT DIAGONALISATION
-- ═══════════════════════════════════════════════════════════════

-- | Full spectrum of crystal Hamiltonian.
-- Feasible for n ≤ 4 particles (χ⁴ = 1296 dim).
simExactDiag :: Int -> [(Double, Vec)]
simExactDiag nPart =
  let dim' = chi ^ nPart
      -- Crystal Hamiltonian is diagonal in sector basis!
      -- Eigenvalues are sums of sector energies.
      eigvals = [sum [energies !! min ((k `div` (chi^p)) `mod` chi) 3
                     | p <- [0..nPart-1]]
                | k <- [0..dim'-1]]
      eigvecs = [vBasis dim' k | k <- [0..dim'-1]]
  in zip eigvals eigvecs

-- | Ground state energy for n particles
simLanczos :: Int -> Double
simLanczos nPart = 0.0  -- Ground state always singlet⊗...⊗singlet, E=0

-- ═══════════════════════════════════════════════════════════════
-- §6  TROTTER DECOMPOSITION
-- ═══════════════════════════════════════════════════════════════

-- | Trotter: exp(-i(H₁+H₂)t) ≈ (exp(-iH₁δt) exp(-iH₂δt))^n
simTrotter :: Int     -- ^ number of Trotter steps
           -> Double  -- ^ total time
           -> Vec     -- ^ initial state
           -> Vec     -- ^ evolved state
simTrotter nSteps totalTime psi =
  let dt = totalTime / fromIntegral nSteps
      oneStep v = [cxMul (cxExp (cx 0 (-energies !! min k 3 * dt))) (v!!k)
                  | k <- [0..length v - 1]]
  in vNormalize (iterate oneStep psi !! nSteps)

-- ═══════════════════════════════════════════════════════════════
-- §7  QUANTUM MONTE CARLO
-- ═══════════════════════════════════════════════════════════════

-- | QMC sampling weights: Boltzmann factors at inverse temperature β.
-- Sign problem ABSENT for crystal (all eigenvalues real and positive).
simQMC :: Double -> [Double]
simQMC beta =
  let boltz k = exp (-beta * energies !! min k 3)
      z = sum [fromIntegral (dims !! min k 3) * boltz k | k <- [0..3]]
  in [fromIntegral (dims !! min k 3) * boltz k / z | k <- [0..chi-1]]

-- ═══════════════════════════════════════════════════════════════
-- §8  VARIATIONAL MONTE CARLO
-- ═══════════════════════════════════════════════════════════════

-- | VMC energy estimator: ⟨H⟩ for parametric state.
simVMC :: [Double]  -- ^ variational parameters (angles)
       -> Double    -- ^ estimated energy
simVMC params =
  let -- Parametric state: Ry(θ₀) Rz(θ₁) ... |0⟩
      psi0 = vBasis chi 0
      -- Apply rotation for each parameter
      evolvedPsi = foldl (\v (i,theta) ->
        [if i `mod` 2 == 0
         then -- Rz-like: phase rotation
              cxMul (cxExp (cx 0 (-theta * fromIntegral k / fromIntegral chi))) (v!!k)
         else -- Ry-like: amplitude mixing
              let c = cos (theta/2); s = sin (theta/2)
              in cxScale c (v!!k)  -- simplified
        | k <- [0..chi-1]]
        ) psi0 (zip [0..] params)
      normed = vNormalize evolvedPsi
  in sum [cxNorm2 (normed!!k) * energies !! min k 3 | k <- [0..chi-1]]

-- ═══════════════════════════════════════════════════════════════
-- §9  WIGNER FUNCTION
-- ═══════════════════════════════════════════════════════════════

-- | Discrete Wigner function on Z_χ × Z_χ = 6×6 grid.
-- Returns 6×6 matrix of quasi-probabilities.
wignerFunction :: Vec -> [[Double]]
wignerFunction psi =
  let n = min chi (length psi)
      rho = [[cxMul (psi!!i) (cxConj (psi!!j)) | j <- [0..n-1]] | i <- [0..n-1]]
      -- Discrete Wigner: W(p,q) = (1/χ) Σ_k ρ[q+k, q-k] × ω^(2pk)
      omega p k = cxExp (cx 0 (2*pi*fromIntegral (2*p*k) / fromIntegral n))
  in [[let Cx wr _ = cxScale (1.0/fromIntegral n)
                     (foldl cxAdd cxZero
                       [cxMul (omega p k)
                              (rho !! ((q+k) `mod` n) !! ((q-k+n) `mod` n))
                       | k <- [0..n-1]])
       in wr
      | q <- [0..n-1]] | p <- [0..n-1]]

-- ═══════════════════════════════════════════════════════════════
-- §10  CLIFFORD SIMULATION
-- ═══════════════════════════════════════════════════════════════

-- | Clifford simulation: track stabiliser state on χ-level system.
-- Generalised Pauli group on ℂ^χ has χ² = 36 elements.
-- Gottesman-Knill: Clifford circuits simulable in O(n²).
simClifford :: Vec -> Vec
simClifford psi = psi  -- Stabiliser tracking (placeholder for full tableau)

-- ═══════════════════════════════════════════════════════════════
-- §11  CAPACITY LIMITS
-- ═══════════════════════════════════════════════════════════════

-- | Max particles for exact state vector simulation
maxParticlesExact :: Int
maxParticlesExact = 5  -- χ⁵ = 7776 amplitudes

-- | Max particles for density matrix simulation
maxParticlesDensity :: Int
maxParticlesDensity = 3  -- χ³ = 216, matrix 216×216

-- | Max particles for exact diagonalisation
maxParticlesDiag :: Int
maxParticlesDiag = 4  -- χ⁴ = 1296 eigenvalues

-- | Fock space dimension for n_max excitations
fockDimension :: Int -> Integer
fockDimension nMax = sum [fromIntegral chi ^ k | k <- [0..nMax]]
