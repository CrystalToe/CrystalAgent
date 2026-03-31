<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# proofs/ — Formal Verification Suite

**5 proof systems · 13+ files per system · Every integer identity verified independently**

## What This Directory Contains

Four independent formal proof systems verify the same crystal identities. If GHC says `chi - 1 = 5`, Lean says it with `native_decide`, Agda says it with `refl`, Rust says it with `assert_eq!`, and Python says it with `assert`. No single system is trusted alone.

## Proof Systems

| System | Files | Count | Verification method |
|--------|-------|-------|---------------------|
| Lean 4 | `Crystal*.lean` | 757+ theorems | `native_decide` (kernel-checked) |
| Agda | `Crystal*.agda` | 603+ proofs | `refl` (definitional equality) |
| Rust | `crystal_*_tests.rs` | 466+ tests | `assert_eq!` + PWI bounds |
| Python | `crystal_*_proof.py` | 13 modules | `assert` + numerical checks |
| Haskell | `haskel/*.hs` | 33 modules | Curry-Howard (compilation = proof) |

## Runner Scripts

All scripts auto-discover files via glob — no hardcoded lists to maintain.

| Script | Command | Expected |
|--------|---------|----------|
| `agda_proofs.sh` | `sh agda_proofs.sh` | 12/12 PASS |
| `lean_proofs.sh` | `sh lean_proofs.sh` | 13/13 PASS |
| `haskell_proofs.sh` | `sh haskell_proofs.sh` | 33/33 PASS |
| `proof_regression.sh` | `sh proof_regression.sh` | PASS (no lost proofs) |
| `proof_regression.sh --snapshot` | generates baseline | writes proof_manifest.baseline |

## Lean Files

| File | Theorems | Domain |
|------|----------|--------|
| CrystalTopos.lean | 342 | Core algebra identities |
| CrystalStructural.lean | 45 | Structural properties |
| CrystalNoether.lean | 15 | Conservation laws |
| CrystalDiscoveries.lean | 34 | Extended scan identities |
| CrystalAlphaProton.lean | 61 | α⁻¹, m_p/m_e, dual routes |
| CrystalProtonRadius.lean | 30 | Proton radius |
| CrystalLayer.lean | 19 | Spectral tower cascade |
| CrystalGravityDyn.lean | 34 | Dynamical gravity integers |
| CrystalProtein.lean | 52 | Protein force field |
| CrystalMandelbrot.lean | 35 | Mandelbrot functor |
| CrystalFundamentals.lean | 52 | Fundamental observables |
| CrystalRendering.lean | 6 | Rendering/scattering exponents |
| Main.lean | 58 | Original crystal theorems |

## Agda Files

Same structure as Lean. Every Agda file has a corresponding `.agdai` compiled certificate. Proofs use `refl` (definitional equality in Agda's type theory).

## Python Proof Files

| File | What it checks |
|------|----------------|
| crystal_fundamentals_proof.py | 47 fundamental observable checks |
| crystal_rendering_proof.py | 3 rendering/scattering checks |
| crystal_alpha_proton_proof.py | α⁻¹ and m_p/m_e precision |
| crystal_discoveries_proof.py | Extended scan identities |
| crystal_noether_proof.py | Conservation law checks |
| crystal_structural_proof.py | Structural property checks |
| crystal_certificate_proof.py | GHC certificate validation |
| crystal_hierarchy_proof.py | Hierarchical implosion |
| crystal_proton_radius_proof.py | Proton radius precision |
| crystal_proof_certificate.py | Cross-validation |

## Regression System

`proof_regression.sh` ensures proofs are never lost:

- **--snapshot**: scans all files, counts every theorem/proof/test, writes `proof_manifest.baseline`
- **check mode**: generates a candidate manifest, compares to baseline
- **ADD is OK**: new proofs welcome
- **DELETE is FAIL**: lost a proof = regression failure
- **COUNT DECREASE is FAIL**: something got removed

Run `--snapshot` after adding new proofs. Run without args before every merge.

## How Haskell Proof Detection Works

`haskell_proofs.sh` auto-detects the compile mode for each `.hs` file:

| Pattern | Mode | Example |
|---------|------|---------|
| `module Main` + `main =` | compile & run | Main.hs, GravityDynTest.hs |
| `main =` but not `module Main` | `-main-is Module` | CrystalFullTest.hs, CrystalProtein.hs |
| no `main` | type-check only (`-fno-code`) | CrystalAxiom.hs, CrystalGravity.hs |

Drop a new `.hs` file in `haskel/`, it gets picked up automatically.
