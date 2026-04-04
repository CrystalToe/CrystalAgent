<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalLatticeGauge — Wilson Lattice Gauge Theory from (2,3)

## Why This Module Exists

If the claim "every simulation is S = W∘U" is true, it MUST include lattice
gauge theory. This is how real QCD is computed. Wilson's plaquette action uses
U(1) × SU(2) × SU(3) — literally A_F. If we can't show Wilson's method is
a sector restriction of the engine, the claim fails where it matters most.

## The S = W∘U Decomposition

| Operator | What it does | Textbook name | Crystal constant |
|----------|-------------|---------------|-----------------|
| **W** | Plaquette product (4 matrix multiplies) | Gauge transport | N_w² = 4 links |
| **U** | Staple sum + accept/reject | Link update | χ = 6 staples |
| **S = W∘U** | Measure field strength, then update link | One gauge sweep | Sector restriction |

W is the KICK: it computes F_μν by transporting around a face.
U is the DRIFT: it computes what the link should be, then accepts/rejects.

## Every Integer from (2,3)

| Quantity | Value | Crystal | Traditional notation |
|----------|-------|---------|---------------------|
| Plaquette links | 4 | N_w² | □ has 4 edges |
| SU(3) generators | 8 | d_colour = N_c²−1 | Gell-Mann matrices |
| Wilson β | 6 | χ = N_w×N_c | 2N_c/g² at strong coupling |
| Spacetime dim | 4 | N_c+1 | d=4 Euclidean |
| Directions | 8 | N_w(N_c+1) | ±μ, μ=1..4 |
| Plaquettes/site | 6 | χ = C(4,2) | μν planes |
| Fundamental dim | 3 | N_c | Quarks are triplets |
| Link entries | 9 | N_c² | 3×3 complex matrix |
| String tension | 3/8 | N_c/d_colour | σ/Λ² |
| Casimir C_F | 4/3 | (N_c²−1)/(2N_c) | = n_water! |
| β₀ (QCD) | 7 | (11N_c−2χ)/3 | Asymptotic freedom |
| Gauge DOF | 32 | d₃+d₄ = N_w⁵ | Total gauge sector |
| Centre symmetry | Z(3) | Z(N_c) | Deconfinement |

## Sector Restriction

Lattice gauge lives in the **colour ⊕ mixed** sectors of CrystalEngine:

```
Full engine:  [1] ⊕ [3] ⊕ [8] ⊕ [24]  = 36 dims
Gauge:              [8] ⊕ [24]  = 32 dims = N_w⁵
```

The colour sector (d=8) carries the SU(3) generators.
The mixed sector (d=24) carries the full gauge coupling.
Together: 32 = N_w⁵ degrees of freedom per site.

## No Calculus

| Traditional | Crystal |
|------------|---------|
| Path integral Z = ∫ DU exp(-S) | Finite sum over lattice configurations |
| Action S = β ∫ Tr(F²) d⁴x | S = β Σ_{x,μν} (1 − ReTr(P)/N_c) |
| Functional derivative δS/δU | Staple sum (3 matrix multiplies per term) |
| Continuum limit a → 0 | Lattice IS the physics. No limit taken. |

The Wilson action is a **SUM** over sites × plaquettes. Not an integral.
Link updates are **MATRIX MULTIPLY**. Not a functional derivative.
Accept/reject is **COMPARE**. Not calculus.

## What the Tests Prove

The Haskell module runs checks on a 4⁴ = 256 site lattice:

1. All 10 integer identities verified from (2,3)
2. SU(3) matrix algebra: Tr(I) = N_c, I×I = I, I† = I
3. Cold start: all plaquettes = identity, ⟨P⟩ = 1.0
4. Wilson action = 0 on ordered configuration
5. Sector restriction: gauge DOF = d₃ + d₄ = 32 = N_w⁵
6. W∘U decomposition: W = N_w² multiplies, U = χ staples + Metropolis
7. Cross-module traces: β₀, α_s, string tension, Casimir, spacetime dim

## Files

| File | Location | Count | Method |
|------|----------|-------|--------|
| `CrystalLatticeGauge.hs` | `haskel/` | 40 checks | GHC runtime |
| `CrystalLatticeGauge.lean` | `proofs/` | 43 theorems | `native_decide` |
| `CrystalLatticeGauge.agda` | `proofs/` | 41 proofs | `refl` |

## Run

```bash
# Haskell (from haskel/)
ghc -O2 -main-is CrystalLatticeGauge CrystalLatticeGauge.hs && ./CrystalLatticeGauge

# Lean (from proofs/)
lean CrystalLatticeGauge.lean

# Agda (from proofs/)
agda CrystalLatticeGauge.agda
```

## Relationship to Other Modules

```
CrystalEngine.hs        S = W∘U on Σd = 36
    ↓ restrict to colour⊕mixed (d=32)
CrystalLatticeGauge.hs  Wilson plaquette + heat bath  ← YOU ARE HERE
    ↓ shares constants with
CrystalQFT.hs           β₀ = 7, α_s = 2/17
CrystalQCD.hs           string tension, Casimir
CrystalOptics.hs        C_F = 4/3 = n_water
CrystalNuclear.hs       Fe-56 = d_colour × β₀
```

The fact that the Casimir operator C_F = 4/3 is also the refractive index of
water is not a coincidence. Both are (N_c²−1)/(2N_c). The algebra decides.
