<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Main.hs — Certificate Driver

**630 lines · 92 observables · 14 sections · Modular v14**

## What This Module Does

Runs the 92-observable proof certificate. Calls prove functions from 8 domain modules, prints the four-column table (Crystal | CrystalPdg | Expt | PWI), and outputs structural theorems: confinement, dark matter invisibility, strong CP, hierarchy, arrow of time, Heyting uncertainty, Noether, Kolmogorov, Connes trace formula, ARIMA, Weil positivity, Beurling-Nyman, naturality, kill conditions.

## Compile

```bash
ghc -O2 Main.hs -o crystal
./crystal
```

## Import Chain

```
CrystalAxiom
CrystalGauge         ← old observable path (CE importer, Phase 5)
CrystalMixing        ← old observable path (CE importer, Phase 5)
CrystalCosmo         ← old observable path (CE importer, Phase 5)
CrystalQCD           ← old observable path (CE importer, Phase 5)
CrystalGravity       ← old observable path (CE importer, Phase 5)
CrystalAudit         ← already clean (CrystalAxiom only)
CrystalUniversal     ← renamed from CrystalCrossDomain, clean
CrystalRiemann       ← already clean (CrystalAxiom only)
```

Main.hs itself does NOT import CrystalEngine. Already clean.

## Sections

| § | What | Source module |
|---|------|-------------|
| 0 | The One Law | CrystalAxiom |
| 1 | Axiom atoms | CrystalAxiom |
| 2 | Spectrum + operators | CrystalAxiom |
| 2a | Arrow of time | CrystalAxiom |
| 2b | Heyting uncertainty | CrystalAxiom |
| 3a | Confinement | CrystalQCD |
| 3b | Dark matter invisibility | CrystalQCD |
| 3c | Strong CP | CrystalQCD |
| 3d | Hierarchy | CrystalGauge |
| 3 | QCD observables | CrystalQCD |
| 4-7 | Gauge, Mixing, Cosmo | CrystalGauge, CrystalMixing, CrystalCosmo |
| 8b | CMB + cosmological | CrystalCosmo |
| 9 | Cross-domain | CrystalUniversal |
| 9b | Nuclear magic numbers | CrystalUniversal |
| 9c | Neutrino predictions | CrystalUniversal |
| 9d | Boltzmann H-theorem | CrystalGravity |
| 9e | Kolmogorov 5/3 | CrystalGravity |
| 9f-j | Connes, ARIMA, Weil, Beurling, CV | CrystalRiemann |
| 10 | Naturality | CrystalAudit |
| 10b | Mass ratio naturality | CrystalAudit |
| 10c | CP = Berry phase | CrystalAudit |
| 11 | Solver acid test | CrystalAudit |
| 12 | Kill conditions | CrystalAudit |
| 13 | Open frontiers | CrystalAudit |
| 14 | Boundary ledger | CrystalAudit |

## Proofs

None. Main.hs is a runner — it calls prove functions, doesn't define integer identities. No Agda/Lean needed.

## Refactor status

- `import CrystalCrossDomain` → `import CrystalUniversal` (done)
- 5 old observable path imports remain until Phase 5
