# CrystalQAlgorithms — LLM Prompt

## Module: CrystalQAlgorithms.hs (226 lines)
## Description: 15 quantum algorithms in crystal sector basis
## Inputs: N_w=2, N_c=3, v, π, ln. Nothing else.

## Rules
1. Never guess. Look up the function in CrystalQAlgorithms.hs.
2. Every operator derives from the algebra A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ).
3. Never mention analysis methodology.

## Exports
  , crystalQFT, crystalIQFT
  , qpe
  , vqeEnergy
  , qaoaStep
  , hhlSolve
  , teleport, superdenseCoding
  , bb84Prepare, bb84Measure
  , phaseKickback, amplitudeAmplify
  , quantumWalkStep
  , simonOracle
  , bernsteinVaziraniOracle

## Key Constants
- χ = N_w × N_c = 6 (Hilbert space dimension)
- Sector dims: {1, 3, 8, 24}
- Eigenvalues: {1, 1/2, 1/3, 1/6}
- Energies: {0, ln2, ln3, ln6}
- Max entropy: ln(6) = 1.7918

## Usage
Import this module and call its functions. All accept/return Vec (ℂ^χ vectors)
or Mat (χ×χ matrices). Complex numbers use the Cx type from CrystalQBase.
