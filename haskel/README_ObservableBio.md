<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# ObservableBio.hs — Component 7 (Bio)

## Compile

```bash
ghc -O2 -main-is ObservableBio ObservableBio.hs && ./ObservableBio
```

## Observables (20) — ALL dimensionless, Shift=0

### Genetic Code (5, all EXACT)

| Name | Formula | Value |
|------|---------|-------|
| DNA bases | N_w^2 | 4 |
| Codons | (N_w^2)^N_c | 64 |
| Amino acids | gauss+beta0 = 13+7 | 20 |
| Codon signals | N_c*beta0 = 3*7 | 21 |
| Codon redundancy | 64-21 = D+1 | 43 |

### DNA Structure (3, all EXACT)

| Name | Formula | Value |
|------|---------|-------|
| A-T H-bonds | N_w | 2 |
| G-C H-bonds | N_c | 3 |
| DNA groove ratio | 11/chi = 11/6 | 1.833 |

### Protein Folding (5, all EXACT)

| Name | Formula | Value |
|------|---------|-------|
| alpha-helix res/turn | N_c+N_c/(chi-1) = 18/5 | 3.600 |
| alpha-helix rise (Å) | N_c/N_w = 3/2 | 1.500 |
| beta-sheet spacing (Å) | beta0/N_w = 7/2 | 3.500 |
| Flory exponent | N_w/(chi-1) = 2/5 | 0.400 |
| Ramachandran dof | N_w = 2 (phi, psi) | 2 |

### Chemistry (7)

| Name | Formula | Value | Expt | Gap |
|------|---------|-------|------|-----|
| s-orbital cap | N_w | 2 | 2 | EXACT |
| p-orbital cap | chi | 6 | 6 | EXACT |
| d-orbital cap | N_w*(chi-1) | 10 | 10 | EXACT |
| f-orbital cap | N_w*beta0 | 14 | 14 | EXACT |
| Bond angle (deg) | arccos(-1/N_c) | 109.471 | 109.471 | EXACT |
| H2 bond (eV) | Rydberg/N_c | 4.535 | 4.52 | 0.34% |
| Lattice lock | Sigma_d/chi^2 = 36/36 | 1.000 | 1.000 | EXACT |

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| ObservableBio.agda | refl | 19 |
| ObservableBio.lean | native_decide | 12 |
