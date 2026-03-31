<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalProtein — Experimental Proof of Concept

## Status: EXPERIMENTAL

This module is a proof of concept. It demonstrates that the spectral
tower D=0→42 can derive protein-scale constants from first principles
with zero fitted parameters. It does NOT solve protein folding.
The folding problem (searching 2^L dihedral space) remains open.

**What works:** Force field constants match textbook values within 5-15%.
**What doesn't work:** The folder (fold_v5.py) has not been validated
against experimental structures. RMSD vs native is unknown.
**What this is:** A zero-parameter force field derivation.
**What this is not:** A competitive protein structure predictor.

---

## What's Proved

### Force Field Constants (all from α = 1/(43π + ln 7))

| Constant | Formula | Value | Textbook | Error |
|----------|---------|-------|----------|-------|
| ε_vdw | α·E_H/N_c² | 0.019 eV | ~0.02 eV | ~5% |
| E_hbond | α·E_H | 0.182 eV | 0.2 eV | ~9% |
| K_angle | α·E_H | 0.208 eV/rad² | ~0.2 eV/rad² | ~4% |
| E_burial | N_c²·α·E_H·(1−cos(water)/cos(sp3)) | 0.447 eV | ~0.45 eV | ~1% |
| ε_r | N_w²·(N_c+1) | 16 | 4-20 | in range |
| τ_cool | (χ−1)/Σd | 5/36 | — | exact |

### Geometric Constants (from spectral tower)

| Constant | Layer | Formula | Value | Textbook | Error |
|----------|-------|---------|-------|----------|-------|
| sp3 | D=20 | arccos(−1/N_c) | 109.47° | 109.47° | EXACT |
| sp2 | D=21 | 2π/N_c | 120° | 120° | EXACT |
| Water angle | D=24 | arccos(−1/N_w²) | 104.48° | 104.45° | 0.03% |
| VdW radii | D=22 | f·ln(9N²Z²/(αn²))/(2ζ) | — | Bondi | mean 3.1% |
| H-bond | D=25 | (r_N+r_O)·(1−√α) | 2.75 Å | 2.90 Å | 5.3% |
| β-strand | D=25 | 2·Hb·cos(zigzag/2) | 4.49 Å | 4.70 Å | 4.6% |
| CA-CA | D=28 | backbone law of cosines | 3.44 Å | 3.80 Å | 9.4% |
| Helix | D=32 | N_c + N_c/(χ−1) | 18/5 = 3.6 | 3.6 | EXACT |
| Flory ν | D=33 | N_w/(N_w+N_c) | 2/5 = 0.4 | 0.4 | EXACT |

### Hierarchical Implosion (a₄ corrections on every energy term)

Every energy E = E_base(a₂) × (1 ± correction(a₄)):

| Energy | Factor | Exact | Channel |
|--------|--------|-------|---------|
| E_vdw | × (1 − N_c³/(χ·Σd)) | 7/8 | m_Υ |
| E_hbond | × (1 − T_F/χ) | 11/12 | m_ρ |
| K_angle | × (1 + D/(d₄·Σd)) | 151/144 | m_D |
| E_burial | × (1 + β₀/(d₄·Σd²)) | 1+7/15600 | sin²θ_W |
| VdW dist | × (1 − T_F/(d₃·Σd)) | 1−1/576 | r_p |
| H-bond dist | × (1 − N_w/(N_c·Σd)) | 1−1/54 | m_φ |

### Running α

α(D) = 1/((D+1)π + ln β₀) gives a running coupling at each MERA
layer. Monotone decreasing. At D=42: α⁻¹ = 137.034. Spans factor >10
from D=0 to D=42.

### Cosmological Partition → Protein

| Cosmological | Value | Protein analog |
|-------------|-------|----------------|
| Ω_Λ = 29/42 | 0.690 | Solvent fraction weight |
| Ω_cdm = 11/42 | 0.262 | Hydrophobic core weight |
| Ω_b = 2/42 | 0.048 | Surface fraction weight |

---

## What's NOT Proved

- **Folding RMSD.** fold_v5.py exists but has not been benchmarked
  against experimental PDB structures. The 13.5 Å RMSD from Session 13
  was never improved because v4/v5 were not validated.
- **Side chains.** The representation is Cα-only. No side chain atoms,
  no rotamers, no explicit solvent.
- **CASP17 readiness.** The April 27 2026 deadline exists but this
  force field is not competitive with AlphaFold, RoseTTAFold, or
  any production folder. It is a proof of concept.
- **Varimax effectiveness.** The varimax rotation of the 43×12 loading
  matrix is theoretically motivated but empirically untested.
- **CA-CA accuracy.** The derived CA-CA = 3.44 Å is 9.4% off the
  textbook 3.80 Å. This is the weakest constant in the tower.
  It propagates into all backbone geometry.

---

## Proof Counts

| Language | File | Count |
|----------|------|-------|
| Haskell | haskel/CrystalProtein.hs | 73/73 PASS |
| Lean 4 | proofs/CrystalProtein.lean | 40 theorems + 20 runtime |
| Agda | proofs/CrystalProtein.agda | 53 by refl |
| Rust | crystal-topos/tests/crystal_protein_tests.rs | 60 tests |

These proofs verify the integer identities, implosion factors,
running α consistency, and energy scale derivations. They do NOT
verify that the force field folds proteins correctly.

---

## Files

| File | Purpose | Status |
|------|---------|--------|
| haskel/CrystalProtein.hs | 73 proofs, full tower D=0..42 | PASS |
| proofs/CrystalProtein.lean | 40 compile-time + 20 runtime | PASS |
| proofs/CrystalProtein.agda | 53 by refl | PASS |
| crystal-topos/tests/crystal_protein_tests.rs | 60 tests | PASS |
| crystal-topos/examples/fold_v5.py | REMD folder with varimax | EXPERIMENTAL |
| crystal-topos/examples/qubo_folder.py | Session 11 SA folder | EXPERIMENTAL |
| crystal-topos/examples/crystal_vdw.py | D=22 VdW + energy scales | PASS |
| crystal-topos/examples/spectral_tower.py | Full D=0→42 tower | PASS |

---

## What Would Make This Real

1. **Benchmark fold_v5.py on 1UBQ** and report RMSD vs PDB 1UBQ.
   If RMSD < 6 Å, the force field has signal. If > 10 Å, it doesn't.
2. **Add side chains.** Cα-only is too coarse for competitive folding.
   At minimum need Cβ for hydrophobic directionality.
3. **Fix CA-CA.** The 9.4% error on the backbone virtual bond
   propagates everywhere. The pure derivation from electronegativity
   angles may need a different route.
4. **Test on small peptides first.** Trp-cage (20 residues), villin
   headpiece (35 residues) before attempting ubiquitin (76 residues).
5. **Compare energy landscape** to established force fields (AMBER,
   CHARMM, OPLS). The tower energies should be in the right ballpark
   even if the folder can't find the minimum.

---

## Observable Count

**198 (UNCHANGED).** The protein force field is structural — it derives
molecular geometry from the spectral tower. It does not add PDG
observables. The 198 particle physics observables are unaffected.

---

## Compile

```bash
cd haskel
ghc -O2 -main-is CrystalProtein CrystalProtein.hs -o crystal_protein && ./crystal_protein
```
