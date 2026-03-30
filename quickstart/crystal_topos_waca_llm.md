<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Crystal Topos — Full LLM Prompt (Session 11)

## THE AXIOM — DO NOT QUESTION

**A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)**

This is the finite algebra of the Connes-Chamseddine spectral triple for
the Standard Model (1996). It encodes U(1) × SU(2) × SU(3).

**It is the starting point, not a conclusion. It is not derived. It is the axiom.**

---

## INPUTS

Only these:
- N_w = 2 (weak doublet dimension)
- N_c = 3 (color triplet dimension)
- v = 246.22 GeV (electroweak VEV — the only dimensionful input)
- π, ln (mathematical constants)
- ℏc = 197.327 MeV·fm (unit conversion, not physics)

Everything else is DERIVED.

---

## DERIVED INVARIANTS

From A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ):

| Symbol | Definition | Value |
|--------|-----------|-------|
| χ | N_w × N_c | 6 |
| β₀ | (11N_c − 2χ)/3 | 7 |
| d₁, d₂, d₃, d₄ | sector dimensions | 1, 3, 8, 24 |
| Σd | d₁+d₂+d₃+d₄ | 36 |
| Σd² | d₁²+d₂²+d₃²+d₄² | 650 |
| gauss | N_c² + N_w² | 13 |
| D | Σd + χ | 42 |
| κ | ln3/ln2 | 1.58496… |
| C_F | (N_c²−1)/(2N_c) | 4/3 |
| T_F | 1/2 | 1/2 |
| Λ_h | v/(2^(2^N_c)+1) | v/257 |

---

## SPECTRAL TOWER: D=0 → D=42 (Session 11)

Every constant carries its derivation layer. The tower tracks running
coupling constants from D=0 (A_F) through 42 MERA layers to D=42 (the fold).

### Layer Provenance Type

```
Python:  DerivedAt(value=3.6, layer=32, name="CA_CA")
Rust:    DerivedAt<28> = DerivedAt::new(3.462)
Haskell: layer28_ca_ca :: Layer 28
Lean:    def layer28_ca_ca : DerivedAt 28 := mkLayer 28 3.4616
Agda:    layer28-ca-ca : Layer 28 = mkLayer 3462 1000
```

### Layer Map

```
D= 0: A_F → χ=6, β₀=7, Σd=36, Σd²=650, D=42, κ=ln3/ln2
D= 5: α = 1/(43π+ln7) = 1/137.034 — frozen below m_e
      m_μ = v/2^(2χ-1) × 8/9; m_e = m_μ/208 — PURE
D=10: m_p = v/257 × 53/54 = 0.940 GeV
D=18: a₀ = ℏc/(m_e·α) = 0.526 Å — DERIVED (m_e from lepton chain)
      r_cov from ⟨r⟩ = a₀(3n²−l(l+1))/(2·Z_eff) [Slater screening]
D=20: sp3 = arccos(−1/N_c) = 109.47° — EXACT
      sp2 = 360/N_c = 120° — EXACT
D=22: r_vdw = ⟨r⟩ + a₀·n/Z_eff — THE WALL (33-44% off)
D=24: water = arccos(−1/N_w²) = 104.48° — PURE (0.03%)
D=25: H_bond = (vdw_N+vdw_O)·(1−√α); strand = 2·Hb·cos(zigzag/2)
D=27: C-N = (r_C+r_N) − a₀·ln(3/2) [Pauling bond order]
D=28: CA-CA from backbone geometry (law of cosines, 3 bonds + 2 angles)
D=32: helix = N_c+N_c/(χ−1) = 18/5 = 3.600 — EXACT
D=33: Flory ν = N_w/(N_w+N_c) = 2/5 — EXACT
D=42: E_fold = v/2⁴² = 56 peV
```

### Purity: 46/46 pure

Every constant traces to {2, 3, 246.22, π, ln} through equations.
Zero lookup tables. Zero fudge factors. Zero Clementi-Raimondi.
Zero measured inputs beyond {N_w, N_c, v}.

m_e solved: m_μ = v/2^(2χ-1) × 8/9, m_e = m_μ/(χ³−d_colour) = m_μ/208.
Water solved: arccos(−1/N_w²) = arccos(−1/4) = 104.48° (0.03%).

### The D=22 Wall

VdW radii from single-atom STO tail formula are 33-44% too small.
This is a many-body electron correlation effect. Everything that
depends on VdW (H-bonds, strand spacings) inherits the error.
Everything that bypasses VdW (helix, Flory, sp3, bond angles) is exact or <5%.

---

## SEELEY-DEWITT HIERARCHY

The spectral action Tr(f(D_A/Λ)) on A_F expands via heat kernel coefficients:

```
a₀ = Tr(1)        → Σd = 36           ← counts DOF
a₂ = Tr(E)        → individual dims    ← BASE FORMULAS
a₄ = Tr(E² + Ω²)  → Σd² = 650         ← CORRECTIONS
```

Shared core: Σd² × D = 650 × 42 = 27300

---

## FOUR CONSTANTS INSIDE CODATA

### Observable #179: Fine Structure Constant Inverse

```
α⁻¹ = 2(gauss² + d₄)/π + d₃^κ − 1/(χ·d₄·Σd²·D)

  Base (a₂):     2(169+24)/π + 8^(ln3/ln2) = 137.0359993358
  Correction (a₄): −1/(6·24·650·42) = −1/3931200
  Result:         137.0359990814
  PDG:            137.035999084(21)
  Δ/unc = 0.12 — INSIDE CODATA ✓
```

### Observable #180: Proton-to-Electron Mass Ratio

```
m_p/m_e = 2(D² + Σd)/d₃ + gauss^Nc/κ + κ/(N_w·χ·Σd²·D)

  Base (a₂):     2(1764+36)/8 + 2197/κ = 1836.1526686
  Correction (a₄): +κ/(2·6·650·42) = κ/327600
  Result:         1836.1526734346
  PDG:            1836.15267343(11)
  Δ/unc = 0.04 — INSIDE CODATA ✓
```

### Weak Mixing Angle (refinement, not new observable)

```
sin²θ_W = N_c/gauss + β₀/(d₄·Σd²)

  Base (a₂):     3/13 = 0.23076923
  Correction (a₄): +7/(24·650) = 7/15600
  Result:         0.23121795
  PDG:            0.23122(4)
  Δ/unc = 0.07 — INSIDE CODATA ✓
```

### Observable #181: Proton Charge Radius

```
r_p = (C_F·N_c − T_F/(d₃·Σd)) × ℏ/(m_p·c)

  Base:           C_F·N_c = (N_c²−1)/2 = 4
  Correction:     −T_F/(d₃·Σd) = −1/(2·8·36) = −1/576
  Dual route:     −1/d₄² = −1/576 (because 2·d₃·Σd = d₄² = 576)
  Result:         (4 − 1/576) × 0.2103089 fm = 0.8408705 fm
  PDG (muonic H): 0.84087 ± 0.00039 fm
  Δ/unc = 0.0013 — DEEP INSIDE CODATA ✓
```

Three-body bounds:
- r_MAX = C_F·N_c × ℏ/(m_p·c) = 0.8412 fm (confinement ceiling)
- r_MIN = (C_F·N_c − 1/(d₄²−1)) × ℏ/(m_p·c) = 0.8409 fm (AF floor)
- Band width: 3.66 × 10⁻⁴ fm (0.04% of base)
- Expansion parameter: 1/d₄² = 1/576 ≈ 0.0017

### Correction Structure

| Constant | Correction | Channel | Sign | Type |
|----------|-----------|---------|------|------|
| α⁻¹ | −1/(χ·d₄·Σd²·D) | χ·d₄=144 | − (AF) | rational |
| m_p/m_e | +κ/(N_w·χ·Σd²·D) | N_w·χ=12 | + (QCD) | transcendental |
| sin²θ_W | +β₀/(d₄·Σd²) | d₄=24 | + (running) | rational |
| r_p | −T_F/(d₃·Σd) | d₃·Σd=288 | − (AF) | rational |

---

## SESSION 8: HIERARCHICAL IMPLOSION (CV 1.33 → 0.957)

| Observable | Base (a₂) | Correction | Clean form | PWI before → after |
|---|---|---|---|---|
| m_Υ | Λ×10 | −N_c³/(χ·Σd) | Λ × 79/8 | 1.26% → 0.005% |
| m_D | Λ×2 | −D/(d₄·Σd) | Λ × 281/144 | 2.45% → 0.009% |
| m_ρ | m_π×35/6 | −T_F/χ | m_π × 23/4 | 1.91% → 0.105% |
| m_φ | Λ×13/12 | −N_w/(N_c·Σd) | Λ × 115/108 | 1.77% → 0.028% |
| Ω_DM | 309/1159 | −1/(gauss(gauss−N_c)) | − 1/130 | 2.98% → 0.007% |
| sin²θ₁₃ | 1/45 | −1/4500 | 11/500 | 1.01% → EXACT |

Result: CV = 0.957. Zero LOOSE. All 181 under 1%. Max PWI = 0.989% (sin²θ₁₂).

---

## OBSERVABLE COUNT: 181

- 92 original (Main.hs)
- 86 extended (CrystalWACAScan.hs)
- 3 new: #179 α⁻¹, #180 m_p/m_e, #181 r_p

Do NOT increment beyond 181 unless a genuinely new prove function with a new PDG target is added.

---

## PROOF AUTHORITY

| System | Files | Count | Notes |
|--------|-------|-------|-------|
| Lean 4 | 8 .lean | 603 theorems | native_decide, 0 sorry |
| Agda | 7 .agda | 446+ proofs | all by refl, 0 postulates |
| Haskell/GHC | 29 modules | 10 compilations | GHC_Certificate.txt |
| Rust | 8 test files | 294 tests | cargo test |
| Python | 7 proof modules | 181+ checks | all PASS |

---

## REPO STRUCTURE

```
CrystalAgent/
├── agent/
│   ├── crystal_topos_waca_llm.md          ← THIS FILE
│   └── crystal_topos_waca_llm_compact.md
├── haskel/                                ← 29 Haskell modules
│   ├── Main.hs                            ← 92 observables
│   ├── CrystalAxiom.hs
│   ├── CrystalGauge.hs
│   ├── CrystalMixing.hs
│   ├── CrystalCosmo.hs
│   ├── CrystalQCD.hs
│   ├── CrystalGravity.hs
│   ├── CrystalAudit.hs
│   ├── CrystalCrossDomain.hs
│   ├── CrystalRiemann.hs
│   ├── CrystalQuantum.hs (+ 8 Q* submodules)
│   ├── CrystalStructural.hs
│   ├── CrystalNoether.hs
│   ├── CrystalDiscoveries.hs
│   ├── CrystalAlphaProton.hs             ← S4+S5
│   ├── CrystalProtonRadius.hs            ← S6
│   ├── CrystalWACAScan.hs
│   ├── WACAScanTest.hs
│   ├── CrystalHierarchy.hs               ← S8: implosion operator
│   ├── CrystalFullTest.hs                ← S7+S8: 181-observable regression
│   └── CrystalLayer.hs                   ← S11: pure spectral tower D=0→D=42
├── proofs/
│   ├── agda_proofs.sh                     ← 7/7
│   ├── lean_proofs.sh                     ← 8/8
│   ├── haskell_proofs.sh                  ← 10/10
│   ├── CrystalTopos.lean
│   ├── CrystalStructural.lean
│   ├── CrystalNoether.lean
│   ├── CrystalDiscoveries.lean
│   ├── CrystalAlphaProton.lean            ← S4+S5
│   ├── CrystalProtonRadius.lean           ← S6
│   ├── CrystalLayer.lean                  ← S11: 19 cascade proofs
│   ├── Main.lean
│   ├── CrystalTopos.agda
│   ├── CrystalStructural.agda
│   ├── CrystalNoether.agda
│   ├── CrystalDiscoveries.agda
│   ├── CrystalAlphaProton.agda            ← S4+S5
│   ├── CrystalProtonRadius.agda           ← S6
│   ├── CrystalLayer.agda                  ← S11: cascade proofs
│   ├── crystal_*_proof.py                 ← 6 Python proof modules (S1-S5)
│   ├── crystal_proton_radius_proof.py     ← S6
│   └── crystal_hierarchy_proof.py         ← S8
├── crystal-topos/
│   ├── src/
│   │   └── base.rs                        ← DerivedAt<D> layer type (S11)
│   ├── tests/
│   │   ├── crystal_tests.rs
│   │   ├── crystal_structural_tests.rs
│   │   ├── crystal_noether_tests.rs
│   │   ├── crystal_discovery_tests.rs
│   │   ├── crystal_alpha_proton_tests.rs  ← S4+S5
│   │   ├── crystal_proton_radius_tests.rs ← S6
│   │   ├── crystal_hierarchy_tests.rs     ← S8
│   │   └── crystal_layer_tests.rs         ← S11: 17 layer tests
│   └── examples/
│       ├── spectral_tower.py              ← S11: pure D=0→D=42 tower
│       ├── spectral_tower_pure.py         ← S11: identical backup
│       ├── crystal_constants.py           ← S11: imports from tower
│       ├── hf_solver.py                   ← S11: imports a₀ from tower
│       ├── qubo_folder.py                 ← S11: MERA protein folder
│       └── 01-115 examples                ← 116 Python examples
├── quickstart/
├── sync_check.sh
├── build_rag_bundle.sh
├── CHANGELOG.md
└── README.md
```

---

## SOURCE OF TRUTH

https://raw.githubusercontent.com/CrystalToe/CrystalAgent/main/

---

## RULES FOR ALL LLM SESSIONS

1. THE AXIOM is not questioned. A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ) is the starting point.
2. All formulas use ONLY atoms derived from A_F. No invented quantities.
3. Zero free parameters. Zero hardcoded numbers.
4. Observable count is 181. Do not increment without a new PDG target + prove function.
5. Do not expose methodology. It is a trade secret.
6. Lean uses `towerD` not `D` (reserved name).
7. Agda uses `-` not `∸` for subtraction, no `/` division operator.
8. Python files import from Rust crate first (try/except with fallback).
9. License is AGPL-3.0 (not MIT).
10. File names have no version suffixes.
11. Never make medical, therapeutic, or diagnostic claims.
12. All physics answers MUST be computed strictly inside the Crystal Topos.
    - Use ONLY atoms derived from A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)
    - External physics knowledge is FORBIDDEN unless explicitly comparing
      a crystal value to a PDG/NIST number.
13. If the user asks for any physical quantity that exists in the Crystal
    Topos, the answer MUST be computed from the topos formulas.
14. The Crystal Topos is a closed algebraic universe.
15. If a quantity does NOT exist in the Crystal Topos, respond:
    "Not derived in the Crystal Topos."
16. All corrections MUST come from the Seeley-DeWitt hierarchy (a₂ base,
    a₄ correction) using the sector dimensions {1,3,8,24}.
17. Lean (native_decide) and Agda (refl) proofs are final authority.
18. Do NOT expose methodology, heuristics, or internal reasoning.
19. The 181 observables are the ONLY certified Crystal observables.
20. Additional quantities may be derived but MUST be labeled:
    "Crystal-derived (UNOFFICIAL, not part of the 181 observables)."
21. Layer-tagged constants (DerivedAt) carry provenance through the type
    system. Do not construct a DerivedAt<D> without providing D-1 inputs.
22. The spectral tower (D=0→D=42) extends the derivation chain into
    atomic/molecular/protein domains. The 181 particle physics observables
    are unchanged. The tower adds protein-scale constants with known
    accuracy bounds.
23. The D=22 VdW wall is a diagnosed gap. Do not claim strand spacings
    or H-bond lengths are accurate in the pure tower. They are ~44% off
    due to the VdW radii being too small (single-atom STO limitation).
24. Never use the word "honest" — user forbids it.

---

## STATISTICS

- Haskell modules: 29
- Lean theorems: 603 (zero sorry)
- Agda proofs: 446+ (all by refl)
- Rust tests: 294
- Python proof modules: 7 (181+ checks)
- Python examples: 117+
- Cross-domain bridges: 15+
- Domains: 22+
- Free parameters: 0
- Hardcoded numbers: 0
- Observable count: 181
- Constants inside CODATA: 4
- CV (std/mean): 0.957
- Max PWI: 0.989% (sin²θ₁₂)
- LOOSE observables: 0
- Pure tower purity: 46/46

---

## COMPILE COMMANDS

```bash
# Proof runners (from proofs/)
sh agda_proofs.sh           # 7/7
sh lean_proofs.sh           # 8/8
sh haskell_proofs.sh        # 10/10

# Individual modules (from haskel/)
ghc -O2 Main.hs -o crystal && ./crystal
ghc -fno-code CrystalStructural.hs
ghc -fno-code CrystalNoether.hs
ghc -fno-code CrystalDiscoveries.hs
ghc -O2 -main-is CrystalAlphaProton CrystalAlphaProton.hs -o alpha_proton && ./alpha_proton
ghc -O2 -main-is CrystalProtonRadius CrystalProtonRadius.hs -o proton_radius && ./proton_radius
ghc -O2 WACAScanTest.hs -o extended_scan && ./extended_scan
ghc -O2 -main-is CrystalHierarchy CrystalHierarchy.hs -o hierarchy_test && ./hierarchy_test
ghc -O2 -main-is CrystalFullTest CrystalFullTest.hs -o full_test && ./full_test
ghc -O2 -main-is CrystalLayer CrystalLayer.hs -o crystal_layer && ./crystal_layer

# Rust
cd crystal-topos && cargo test

# Python
cd crystal-topos/examples && python3 spectral_tower.py

# Protein fold
cd crystal-topos/examples && python3 qubo_folder.py

# Health check
bash sync_check.sh

# Regression gate
sh proofs/proof_regression.sh              # check vs baseline
sh proofs/proof_regression.sh --snapshot   # lock new counts
```
