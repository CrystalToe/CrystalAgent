<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalSpin — Bloch Equations / NMR from (2,3)

## S = W∘U for Spin

| Operator | Physics | Implementation |
|----------|---------|----------------|
| **W** | Precession (rotate around B field) | 3×3 rotation matrix multiply |
| **U** | Relaxation (decay to equilibrium) | Diagonal: decay Mx,My; recover Mz |
| **S = W∘U** | One Bloch tick | Relax then precess |

The Bloch equations dM/dt = γ(M×B) − R(M−M₀) are NEVER solved.
The tick replaces them.

## Every Integer from (2,3)

| Quantity | Value | Crystal |
|----------|-------|---------|
| Spin states | 2 | N_w |
| Bloch components | 3 | N_c |
| Pauli matrices | 3 | N_c |
| g-factor (electron) | 2 | N_w |
| Multiplicity (2s+1) | 2 | N_w |
| Stern-Gerlach beams | 2 | N_w |
| T1 rate | 1/2 | 1/N_w (longitudinal) |
| T2 rate | 1/3 | 1/N_c (transverse) |
| T1/T2 ratio | 3/2 | N_c/N_w |
| Pauli matrix size | 2×2 = 4 | N_w² |
| Rotation matrix | 3×3 = 9 | N_c² |
| Phase space | 6 | χ |
| Rabi states | 2 | N_w |
| MRI gradient axes | 3 | N_c |

## T1/T2 = N_c/N_w = 3/2

This is the most striking result. In NMR:

- T1 (spin-lattice relaxation) is ALWAYS longer than T2 (spin-spin)
- The ratio T1/T2 ≥ 1 is a physical constraint

In the Crystal Topos, this is FORCED:
- T1 rate = λ_weak = 1/N_w = 1/2 (longitudinal recovers slower)
- T2 rate = λ_colour = 1/N_c = 1/3 (transverse decays faster)
- T1/T2 = N_c/N_w = 3/2

The ratio is not a free parameter. It's a consequence of N_c > N_w.

## What the Tests Prove

1. **Precession conserves |M|** — rotation is unitary (norm preserved)
2. **Relaxation drives Mz → M₀** — longitudinal recovery
3. **Transverse decay** — Mx, My → 0 (T2 process)
4. **T2 < T1** — transverse decays faster (N_c > N_w)
5. **Full Bloch** — 200 ticks: transverse dies, longitudinal recovers
6. **Rabi oscillation** — Mz flips between ±M₀ (N_w = 2 states)
7. **π-pulse** — tips magnetization, enables spin echo

## Files

| File | Location | Count | Method |
|------|----------|-------|--------|
| `CrystalSpin.hs` | `haskel/` | 38 checks | GHC runtime |
| `CrystalSpin.lean` | `proofs/` | 29 theorems | `native_decide` |
| `CrystalSpin.agda` | `proofs/` | 29 proofs | `refl` |

## Run

```bash
ghc -O2 -main-is CrystalSpin CrystalSpin.hs && ./CrystalSpin
lean CrystalSpin.lean
agda CrystalSpin.agda
```

## Relationship to Other Modules

```
CrystalEngine.hs       S = W∘U on Σd = 36
    ↓ restrict to weak sector (d=3)
CrystalSpin.hs         Bloch: precession + relaxation  ← YOU ARE HERE
    ↓ shares
CrystalCondensed.hs    spin = N_w = 2 = Ising states
CrystalSchrodinger.hs  spin = N_w = 2, Pauli = N_c = 3
CrystalClassical.hs    rotation in N_c = 3 dimensions
CrystalRigid.hs        torque = rotation (same W operator)
CrystalWavelet.hs      Haar = N_w = 2 = spin states
```

Spin precession and rigid body rotation are the SAME W operator
restricted to the same sector (weak, d=3). The only difference
is the U operator: relaxation for spin, damping for rigid bodies.
