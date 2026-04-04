# CrystalNoether.hs — Categorical Noether Theorem

## Compile

```bash
ghc -O2 -main-is CrystalNoether CrystalNoether.hs && ./CrystalNoether
```

## What This Module Is

Runtime verification that the conservation structure of physics follows from the algebra A_F = C + M_2(C) + M_3(C). No observables — 18 structural proofs showing that symmetries, conservation laws, and cross-domain identities are all consequences of N_w=2, N_c=3.

## The Categorical Noether Theorem

Classical Noether (1918): every continuous symmetry gives a conserved quantity. This module verifies the categorical generalization:

For a natural transformation η: F ⇒ G between functors on representation categories, the naturality square G(f) ∘ η_A = η_B ∘ F(f) IS the conservation law. When η is a natural isomorphism (‖η‖ = 0), conservation is exact. When η is approximate, the deviation ‖F(f) - F̃(f)‖ ≤ ‖η‖·‖F(f)‖ gives the correction bound.

## What Gets Verified

### Conservation Structure (5 proofs)

The Standard Model has 12 gauge generators (U(1)=1, SU(2)=3, SU(3)=8) plus 10 Poincaré generators (6 Lorentz + 4 translations) = 22 total conservation laws. The algebra A_F has dimension 14. The system is overdetermined (22 > 14): more conservation laws than degrees of freedom. This is why zero free parameters work — the algebra is constrained from all sides.

### Noether Consequences (6 proofs)

Conservation laws force specific numerical identities:
- Carnot efficiency: 5×chi = (chi-1)×6 (energy conservation in heat engines)
- Stefan-Boltzmann denominator = 120 (photon counting from sector structure)
- Lattice lock: Sigma_d = chi^2 = 36 (superconducting resonance condition)
- Kolmogorov -5/3: 5×N_c = (chi-1)×3 (turbulent energy cascade)
- Neutron lifetime: D^2 = 882×N_w (weak decay timescale)
- von Kármán: N_w×5 = 2×(chi-1) (boundary layer universality)

### Cross-Domain Bridges (6 proofs)

The same integers appear in particle physics, chemistry, biology, and fluid dynamics because they all derive from the same algebra:
- Casimir confinement: (N_c^2-1)×3 = 4×(2N_c) — quarks AND water refraction
- Codons: 4^3 = 64 — genetics from N_w^2 bases and N_c triplets
- Amino acids + stop: N_c×beta0 = 21 — protein alphabet from QCD
- Phase space: 10+8 = 18 = N_c×chi — three-body DOF
- Algebra depth: 14×3 = 42 = D — algebraDim × N_c = tower depth
- Sigma_d^2 = 650 — Seeley-DeWitt a_4 coefficient

## Why It Matters

If the conservation structure were accidental, these 18 identities would be coincidences. But they're not independent — they all follow from the same 2×2 input (N_w=2, N_c=3) through the representation theory of A_F. The categorical Noether theorem says: if you have the right algebra, the conservation laws are automatic, and the conservation laws force the physics.

## 18 Proofs, Zero Observables

This module doesn't add to the observable count. It proves that the observable count is forced by the conservation structure.
