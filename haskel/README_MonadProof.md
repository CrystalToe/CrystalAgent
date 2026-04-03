<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalMonadProof — S = W∘U Unique Factorisation

## Theorem

Given A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ), the unique *-endomorphism preserving
unitarity, causality, and the Heyting lattice is **S = W ∘ U**, where
W is the isometry (Higgs, vertical) and U is the disentangler (gravity,
horizontal). No other factorisation exists.

## Proof Steps

| Step | Statement | Method |
|------|-----------|--------|
| 1 | Wedderburn: sectors {1,3,8,24}, Σd = 36 | Arithmetic |
| 2 | Heyting lattice: 4 truth values {1,½,⅓,⅙}, total order | Enumeration |
| 3 | Lattice rigid: \|Aut(Ω)\| = 1 (total order, distinct elements) | Order theory |
| 4 | Endomorphism block-diagonal (rigidity forces sector preservation) | Step 2+3 |
| 5 | Eigenvalues forced: λ_mixed = λ_weak × λ_colour = 1/6 | Tensor structure |
| 6 | S = W∘U: λ_k = (√λ_k)², MERA causal cone forces W∘U order | MERA geometry |
| 7 | Uniqueness: any Φ ∈ Aut(Ω) = {id}, so W'=W and U'=U | Step 3 |

## Corollary

All textbook integration methods are projections of S = W∘U:

| Method | W (kick) | U (drift) | Crystal constant |
|--------|----------|-----------|-----------------|
| Verlet | velocity update | position update | order = N_w = 2 |
| Yee FDTD | B-update | E-update | components = χ = 6 |
| Lattice Boltzmann | collision | streaming | D2Q9 = N_c² = 9 |
| Metropolis | accept/reject | propose | states = N_w = 2 |
| Leapfrog (GR) | momentum | coordinate | phase space = χ = 6 |

The universe does not integrate differential equations. It applies S = W∘U.

## Files

| File | Location | Proofs | Method |
|------|----------|--------|--------|
| `CrystalMonadProof.hs` | `haskel/` | 12 prove functions | GHC runtime |
| `CrystalMonadProof.lean` | `proofs/` | 42 theorems | `native_decide` |
| `CrystalMonadProof.agda` | `proofs/` | 36 proofs | `refl` |

## Run

```bash
# Haskell (from haskel/)
ghc -O2 -main-is CrystalMonadProof CrystalMonadProof.hs -o monad_proof && ./monad_proof

# Lean (from proofs/)
lean CrystalMonadProof.lean

# Agda (from proofs/)
agda CrystalMonadProof.agda
```

## Key Insight

The factorisation is unique because the Heyting lattice {1, 1/2, 1/3, 1/6}
is a total order on 4 distinct elements. The only order-automorphism of a
finite total order with distinct elements is the identity. This means any
two factorisations S = W∘U = W'∘U' must satisfy W' = W and U' = U.

The number 4 = N_w² is not a coincidence. The algebra M₂(ℂ) has N_w² = 4
matrix entries, giving exactly 4 truth values in the subobject classifier.
The rigidity of the factorisation is inherited from the rigidity of the
(2,3) lattice.
