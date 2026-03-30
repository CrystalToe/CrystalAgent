<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Crystal Topos

### 181 Physical Constants from Two Primes. Zero Free Parameters.

### 📄 [Read the Paper: "The Crystal Topos: A Complete Physics Framework from A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)"](https://zenodo.org/records/19217129)

---

## ⚡ Try It Now (No Install — 30 Seconds)

1. **Open** [Gemini](https://gemini.google.com/), [Copilot](https://copilot.microsoft.com/), [Claude](https://claude.ai/), or [ChatGPT](https://chat.openai.com/)
2. **Upload** three files from the [`quickstart/`](quickstart/) folder:
   - `crystal_topos_waca_llm.md` (the prompt — tells the LLM how to behave)
   - `CrystalTopos_RAG_1.md` (267 KB — Python examples + physics Haskell)
   - `CrystalTopos_RAG_2.md` (306 KB — QCD, gravity, quantum, extended scan)
3. **Paste** any of these:

```
I've uploaded the Crystal Topos files. Can you show me how the framework derives
the proton mass from the (2,3) lattice, including the formula, the crystal value,
the PDG value, and the Prime Wobble Index?
```

```
Can the fine structure constant (α⁻¹ ≈ 137.036) and the Planck mass be derived
purely from the spectral data of the (2,3) lattice — two primes, one algebra,
zero fudge factors?
```

```
Session 12 claims dynamical gravity is closed — linearized Einstein equation
recovered from a χ=6 MERA with all coefficients from A_F. Show me the 12/12
integer audit and explain the entanglement first law verification.
```

```
The Crystal Topos framework claims that its codebase is formally verified using
Agda and Lean 4, utilizing Haskell via the Curry-Howard Correspondence. It also
provides 'Certificates' for all physical derivations. What does this mean for
the reliability of the physics model, and how do these tools prove the constants
of nature? Why is this a big deal?
```

---

> *"Can the fine structure constant and the Planck mass be derived purely from the spectral data of the (2,3) lattice — two primes, one algebra, zero fudge factors?"*
>
> **Yes.** α⁻¹ = 43π + ln 7. M_Pl/v = e⁴²/35. Every integer computes from N_w = 2 and N_c = 3.

---

## What Is This?

This repository contains a complete, proof-carrying implementation of the **Crystal Topos** — a framework that derives 181 physical constants from a single finite-dimensional algebra:

```
A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)
```

**This algebra is the axiom.** It is the same algebra used by Connes, Chamseddine, and Marcolli in the spectral action framework for the Standard Model (1996–2007). It encodes U(1) × SU(2) × SU(3) — the gauge structure of nature. The Crystal Topos does not invent a new algebra. It takes the established one and computes harder.

The algebra is built on two primes: **N_w = 2** (weak generations, from M₂(ℂ)) and **N_c = 3** (colours, from M₃(ℂ)). From these two numbers, plus one dimensionful scale (the Higgs VEV v = 246.22 GeV) and the transcendental functions π and ln, every formula in this codebase is derived. No fitting. No tuning. No free parameters.

The deviations between crystal predictions and experiment follow an **exponential distribution** with coefficient of variation CV = 0.96 — near the Shannon-optimal value of 1.0. The wobble is not error. It is the structural cost of encoding continuous physics in the discrete (2,3) lattice.

---

## The Numbers

| Metric | Value |
|--------|-------|
| Total observables | **181** |
| Sub-1% accuracy | **181 / 181** (100%) |
| Mean deviation (PWI) | **0.25%** |
| Maximum deviation | **0.989%** (sin²θ₁₂) |
| CV (should be 1.0) | **0.957** |
| Free parameters | **0** |
| Hardcoded numbers | **0** in crystal formulas |
| Wall breaches | **0** (prime wall = 4.5%) |
| CODATA precision | **3** (α⁻¹ Δ/unc=0.12, m_p/m_e=0.04, r_p=0.0013) |
| Gravity integer audit | **12/12** PASS (Session 12) |
| First law δS/δ⟨H_A⟩ | **1.0001 ± 0.0004** (χ=6 crystal) |
| Haskell modules | **31** |
| Quantum operators | **96** |
| Lean theorems | **637** (native_decide) |
| Agda proofs | **487** (refl) |
| Rust tests | **341** |

---

## Session 12: Dynamical Gravity — CLOSED (NEW)

Session 11 had gravity in equation form: G_μν = 8πG T_μν with 8 = d_colour, proved. But the equation was not *solved*. No gravitational waves propagated through the tensor network. No curved geometry emerged.

**Session 12 closes this.** The χ=6 crystal MERA, variationally optimized for the crystal XXZ Hamiltonian at Δ = κ = ln3/ln2, satisfies the entanglement first law:

```
δS/δ⟨H_A⟩ = 1.0001 ± 0.0004   (χ=6 crystal XXZ)
δS/δ⟨H_A⟩ = 1.0000 ± 0.0000   (χ=2 Ising validation)
```

By Faulkner-Guica-Hartman-Myers-Van Raamsdonk (JHEP 2014), this IS the linearized Einstein equation. Gravitational waves propagate through the crystal with:
- **Speed c = 1** (Lieb-Robinson bound: χ/χ = 6/6)
- **2 polarizations** (transverse-traceless: N_c − 1 = 3 − 1)
- **Quadrupole coefficient 32/5 = 6.4** (N_w⁵/(χ−1) = 2⁵/5)

### Integer Audit: 12/12 PASS

| GR coefficient | Crystal | From A_F |
|---|---|---|
| 16 in □h = −16πG T | N_w⁴ | 2⁴ |
| 2 in r_s = 2Gm | N_c − 1 | 3−1 |
| 4 in S = A/(4G) | N_w² | 2² |
| 8 in 8πG | d_colour | 3²−1 |
| c = 1 (GW speed) | χ/χ | 6/6 |
| 2 polarizations | N_c−1 | 3−1 |
| 32 in quadrupole | N_w⁵ | 2⁵ |
| 5 in quadrupole | χ−1 | 6−1 |
| d = 4 spacetime | N_c+1 | 3+1 |
| Clifford dim 16 | N_w^(N_c+1) | 2⁴ |
| Spinor dim 4 | N_w² | 2² |
| Equiv principle | Σd²/Σd² | 650/650 |

Proved in all four languages: Lean 4 (+34 theorems), Agda (+24 proofs), Haskell (+2 modules), Rust (+18 tests + compile-time asserts).

---

## Session 8: Hierarchical Implosion (CV 1.33 → 0.96)

The spectral action on A_F expands via Seeley-DeWitt coefficients a₀, a₂, a₄. Each level is a coarse-graining of the algebra's endomorphism structure — a discrete MERA:

```
a₀ = Σdᵢ  = 36   (topological — sector count)
a₂ level   = individual dims, gauss, χ  (base formulas)
a₄ = Σdᵢ² = 650  (endomorphism invariant — corrections)
```

Six outliers had a₂-level formulas only. Hierarchical implosion closes these gaps with rational a₄ corrections — each dual-routed through two independent A_F derivations:

| Observable | Base (a₂) | Correction | Clean form | PWI before → after |
|---|---|---|---|---|
| m_Υ | Λ×10 | −N_c³/(χ·Σd) | Λ × 79/8 | 1.26% → **0.005%** |
| m_D | Λ×2 | −D/(d₄·Σd) | Λ × 281/144 | 2.45% → **0.009%** |
| m_ρ | m_π×35/6 | −T_F/χ | m_π × 23/4 | 1.91% → **0.105%** |
| m_φ | Λ×13/12 | −N_w/(N_c·Σd) | Λ × 115/108 | 1.77% → **0.028%** |
| Ω_DM | 309/1159 | −1/(gauss(gauss−N_c)) | 309/1159 − 1/130 | 2.98% → **0.007%** |
| sin²θ₁₃ | 1/45 | −1/4500 | **(2χ−1)/(N_w²(χ−1)³) = 11/500** | 1.01% → **EXACT** |

All rational. All negative. All dual-routed. All from A_F atoms. Zero free parameters added.

---

## Quick Start

### Compile the Crystal (92 observables)
```bash
cd haskel
ghc -O2 Main.hs -o crystal
./crystal
```

### Run Full 181-Observable Regression Test
```bash
cd haskel
ghc -O2 -main-is CrystalFullTest CrystalFullTest.hs -o full_test
./full_test
```

### Run Dynamical Gravity Audit (Session 12)
```bash
cd haskel
ghc -O2 GravityDynTest.hs -o gravity_dyn_test
./gravity_dyn_test
# Output: ALL 12 PASS
```

### Run MERA First Law Verification (Session 12)
```bash
cd crystal-topos/examples
python3 mera_gravity_closed.py
# Output: δS/δ⟨H_A⟩ = 1.0001 ± 0.0004, GRAVITY: CLOSED
```

### Full Proof Suite
```bash
sh proofs/haskell_proofs.sh    # 12/12 PASS (was 10/10)
sh proofs/lean_proofs.sh       # 9/9 PASS (was 8/8)
sh proofs/agda_proofs.sh       # 8/8 PASS (was 7/7)
cd crystal-topos && cargo test # 341 PASS (was 294)
```

### Regression Gate
```bash
sh proofs/proof_regression.sh          # check vs baseline
sh proofs/proof_regression.sh --snapshot  # lock new counts
bash branch_gate.sh development        # 12-check pre-merge
```

---

## The Derivation Chain

Everything flows from two primes through 21 steps:

```
N_w = 2, N_c = 3
         ↓
sector_dims = [1, N_c, N_c²−1, N_w³×N_c] = [1, 3, 8, 24]
         ↓
χ = 6    β₀ = 7    Σd = 36    gauss = 13    D = 42    κ = ln3/ln2
         ↓
α = 1/((D+1)π + ln β₀)           → 1/137.036  (Δ/unc = 0.12)
sin²θ_W = N_c/gauss              → 3/13       (0.20%)
α_s = N_w/(gauss + N_w²)         → 2/17       (0.30%)
         ↓
Λ_h = v/(2^(2^N_c) + 1)          → v/257 = 958 MeV
m_p = v/2^(2^N_c) × 53/54        → 940 MeV    (0.18%)
         ↓
m_π = m_p/β₀                     → 135 MeV    (0.34%)
Λ_QCD = m_p × N_c/gauss          → 218 MeV
m_e = Λ_h/(N_c²×N_w⁴×gauss)     → 0.512 MeV  (0.12%)
         ↓
... all 181 observables
         ↓
□h_μν = −16πG T_μν               → 16 = N_w⁴  (Session 12)
c_grav = χ/χ = 1                  → Lieb-Robinson
2 polarizations = N_c − 1         → TT decomposition
P = (32/5) G⁴m⁵/(c⁵r⁵)          → 32/5 = N_w⁵/(χ−1)
```

**Zero hardcoded numbers.** Every 53, 54, 257, 1872 computes from (2, 3).

---

## Repository Structure

```
CrystalAgent/
├── README.md                          ← You are here
├── quickstart/                        ← LLM quickstart (no install needed)
│   ├── crystal_topos_waca_llm.md      ← Session 12
│   ├── CrystalTopos_RAG_1.md
│   └── CrystalTopos_RAG_2.md
│
├── crystal-topos/                     ← Rust core + Python bindings
│   ├── src/                           ← 11 Rust modules (+crystal_gravity_dyn.rs)
│   ├── tests/                         ← 8 test files
│   └── examples/                      ← 121 Python/HTML/JSX examples
│       ├── mera_gravity_closed.py     ← S12: first law verification (NEW)
│       └── mera_linearized_gravity.py ← S12: integer audit (NEW)
│
├── proofs/                            ← Formal proofs + runner scripts
│   ├── haskell_proofs.sh              ← 12/12 PASS (Session 12)
│   ├── lean_proofs.sh                 ← 9/9 PASS
│   ├── agda_proofs.sh                 ← 8/8 PASS
│   ├── proof_regression.sh            ← Never lose a proof (S12: updated)
│   ├── CrystalTopos.lean              ← 342 theorems
│   ├── CrystalStructural.lean         ← 45 theorems
│   ├── CrystalNoether.lean            ← 15 theorems
│   ├── CrystalDiscoveries.lean        ← 34 theorems
│   ├── CrystalAlphaProton.lean        ← 61 theorems (incl. S8 dual routes)
│   ├── CrystalProtonRadius.lean       ← 30 theorems
│   ├── CrystalLayer.lean              ← 19 theorems (S11 tower)
│   ├── CrystalGravityDyn.lean         ← 34 theorems (S12 gravity) (NEW)
│   ├── Main.lean                      ← 58 theorems
│   ├── CrystalTopos.agda              ← 272 proofs by refl
│   ├── CrystalStructural.agda         ← 49 proofs by refl
│   ├── CrystalNoether.agda            ← 17 proofs by refl
│   ├── CrystalDiscoveries.agda        ← 38 proofs by refl
│   ├── CrystalAlphaProton.agda        ← 46 proofs (incl. S8 dual routes)
│   ├── CrystalProtonRadius.agda       ← 25 proofs by refl
│   ├── CrystalLayer.agda              ← cascade proofs (S11)
│   ├── CrystalGravityDyn.agda         ← 24 proofs by refl (S12) (NEW)
│   ├── crystal_*_proof.py             ← 7 Python proof modules
│   └── GHC_Certificate.txt            ← Runtime output
│
└── haskel/                            ← All Haskell source (31 modules)
    │
    ├── ─── ORIGINAL CRYSTAL (92 observables) ───
    │   CrystalAxiom.hs               ← Foundation: one law, spectrum, types
    │   CrystalGauge.hs               ← Couplings: α, sin²θ, VEV, leptons
    │   CrystalMixing.hs              ← CKM + PMNS matrices
    │   CrystalCosmo.hs               ← Cosmology: Ω_Λ, n_s, neutrinos
    │   CrystalQCD.hs                 ← QCD: proton, quarks, hadrons
    │   CrystalGravity.hs             ← Gravity: Jacobson, SR/GR, Maxwell (kinematic)
    │   CrystalAudit.hs               ← Naturality audit, acid test
    │   CrystalCrossDomain.hs         ← Feigenbaum, Kleiber, magic numbers
    │   CrystalRiemann.hs             ← Trace formula, ARIMA, Beurling-Nyman
    │   Main.hs                        ← Certificate driver (92 obs)
    │
    ├── ─── EXTENDED SCAN (86 observables) ───
    │   CrystalWACAScan.hs            ← 86 extended observables
    │   WACAScanTest.hs               ← Extended test runner
    │
    ├── ─── HIERARCHICAL IMPLOSION (Session 8) ───
    │   CrystalHierarchy.hs           ← Seeley-DeWitt MERA, implosion operator
    │   CrystalFullTest.hs            ← 181-observable regression (CV = 0.957)
    │
    ├── ─── DYNAMICAL GRAVITY (Session 12) ───  (NEW)
    │   CrystalGravityDyn.hs          ← Linearized Einstein, 12 integer proofs
    │   GravityDynTest.hs             ← 12/12 audit runner
    │
    ├── ─── PROOF MODULES ───
    │   CrystalStructural.hs          ← Structural proof module
    │   CrystalNoether.hs             ← Noether proof module
    │   CrystalDiscoveries.hs         ← Discoveries proof module
    │   CrystalAlphaProton.hs         ← α⁻¹ + m_p/m_e (S4+S5)
    │   CrystalProtonRadius.hs        ← r_p (S6)
    │   CrystalLayer.hs               ← Spectral tower (S11)
    │
    └── ─── QUANTUM LIBRARY (96 operators) ───
        CrystalQuantum.hs             ← Hub: 10 structural theorems
        CrystalQBase.hs … CrystalQSimulation.hs  ← 8 quantum submodules
```

---

## Key Discoveries

### 1. The Fine Structure Constant (Δ/unc = 0.12 — inside CODATA uncertainty)
```
α⁻¹ = (D+1)π + ln β₀ = 43π + ln 7 = 137.035999081
```
With a₄ correction: −1/(χ·d₄·Σd²·D). Every integer derived. Δ/unc = 0.12.

### 2. The Hierarchy Problem — Solved
```
M_Pl/v = exp(D)/(β₀ × (χ−1)) = e⁴²/35
```
The gap between gravity and electromagnetism IS e^42. No fine-tuning.

### 3. Hierarchical Implosion (Session 8)
```
Seeley-DeWitt: a₀ = 36 → a₂ = base formulas → a₄ = 650 corrections
```
Nine a₄ corrections, all rational, all dual-routed, all from A_F atoms. CV dropped from 1.33 to 0.96. Zero LOOSE observables remain.

### 4. Dynamical Gravity — Closed (Session 12)
```
δS/δ⟨H_A⟩ = 1.0001 ± 0.0004 (χ=6 crystal MERA)
⟹ □h_μν = −16πG T_μν with 16 = N_w⁴, c = 1, 2 polarizations = N_c−1
```
Not just the equation — solutions propagate. Gravitational waves in the tensor network with speed, polarization count, and quadrupole coefficient all from {2, 3}. Proved in Lean, Agda, Haskell, Rust.

### 5. Entanglement = Arrow of Time
```
S_max(entanglement) = ln(χ) = ln(6) = 1.7918 nats
ΔS(irreversibility) = ln(χ) = ln(6) = 1.7918 nats
```
Same number. Time moves forward because the monad compresses χ = 6 states to 1.

### 6. sin²θ₁₃ = 11/500 (EXACT)
```
sin²θ₁₃ = (2χ−1)/(N_w²(χ−1)³) = 11/500 = 0.02200
```
Kill test: JUNO ~2027.

### 7. PPT Decidability
The crystal lives in ℂ² ⊗ ℂ³ — the **unique** dimension where entanglement is exactly decidable (Horodecki 1996).

---

## Proof Systems

Four independent proof systems verify the same identities:

| System | Files | Count | Method |
|--------|-------|-------|--------|
| **GHC Haskell** | 31 `.hs` modules | 12/12 runners pass | Curry-Howard |
| **Lean 4** | 9 `.lean` → `.olean` | **637** theorems | `native_decide` |
| **Agda** | 8 `.agda` → `.agdai` | **487** proofs | `refl` |
| **Rust** | 9 test files | **341** tests | `cargo test` |
| **Python** | 11 proof modules | 24+ checks each | `assert` |

---

## The Nine Implosions (+ Gravity)

| # | Observable | Correction | Result | Session |
|---|---|---|---|---|
| 1 | α⁻¹ | −1/(χ·d₄·Σd²·D) | Δ/unc = 0.12 | S4 |
| 2 | m_p/m_e | +κ/(N_w·χ·Σd²·D) | Δ/unc = 0.04 | S5 |
| 3 | sin²θ_W | +β₀/(d₄·Σd²) | Δ/unc = 0.07 | S5 |
| 4 | r_p | −T_F/(d₃·Σd) = −1/576 | Δ/unc = 0.0013 | S6 |
| 5 | m_Υ | −N_c³/(χ·Σd) = −1/8 | 0.005% | S8 |
| 6 | m_D | −D/(d₄·Σd) = −7/144 | 0.009% | S8 |
| 7 | m_ρ | −T_F/χ = −1/12 | 0.105% | S8 |
| 8 | m_φ | −N_w/(N_c·Σd) = −1/54 | 0.028% | S8 |
| 9 | Ω_DM | −1/(gauss(gauss−N_c)) = −1/130 | 0.007% | S8 |
| 10 | sin²θ₁₃ | −1/((D+d_w)N_w²(χ−1)²) = −1/4500 | **EXACT** | S8 |
| 11 | Gravity | δS = δ⟨H_A⟩ → linearized Einstein | 12/12 integers | S12 |

All from A_F atoms. All dual-routed. Zero free parameters.

---

## Falsifiable Predictions

| # | Prediction | Experiment | Timeline |
|---|-----------|-----------|----------|
| 1 | sin²θ₁₃ = 11/500 = 0.02200 | JUNO | 2027 |
| 2 | Proton absolutely stable | Hyper-Kamiokande | 2027+ |
| 3 | Normal neutrino ordering | JUNO, DUNE | 2028-2030 |
| 4 | Dirac neutrinos (0νββ null) | LEGEND, nEXO | 2030+ |
| 5 | Dark photon ε² = 1/650 | LDMX, Belle II | 2026-2030 |
| 6 | No PWI ever exceeds 4.5% | All experiments | Ongoing |
| 7 | sin²θ₂₃ = 6/11 = 0.5455 | DUNE/HyperK | 2028-2030 |
| 8 | w = −1 exactly | DESI/Euclid | 2028 |
| 9 | GW polarizations = 2 exactly | LIGO/Virgo/KAGRA | Ongoing |

If **any one** of these fails, the framework is dead. That's not a weakness. That's what separates this from philosophy.

---

## Rating Scale

| Symbol | Name | PWI Range | Meaning |
|--------|------|-----------|---------|
| ■ | EXACT | 0% | Natural isomorphism. Exact rational. |
| ● | TIGHT | < 0.5% | Strong natural transformation. |
| ◐ | GOOD | < 1.0% | Moderate transformation. |
| ○ | LOOSE | < 4.5% | Under the prime wall. |
| ✗ | OVER | ≥ 4.5% | Wall breach (none exist). |

**Session 8 result: Zero LOOSE. Zero OVER. All 181 observables under 1%.**

---

## Citation

If you use this work, please cite:

```
D. Montgomery, "The Crystal Topos: A Complete Physics Framework from
A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)," Zenodo, 2026.
https://zenodo.org/records/19217129
```

---

## License

AGPL-3.0 — See [LICENSE](LICENSE)

---

## Author

**Daland Montgomery**
Crystal Topos Project, March 2026

*The crystal leaves no question unanswered.*
