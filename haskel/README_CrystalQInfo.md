<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->
# CrystalQInfo — Quantum Information from (2,3)
## Overview
Heyting algebra truth values, error correction codes, entanglement entropy.
The uncertainty principle IS the coprimality of N_w=2 and N_c=3.
## Integer Traces
| Physical quantity | Value | Crystal derivation |
|---|---|---|
| Qubit states | 2 | N_w |
| Pauli matrices | 3 | N_c |
| Pauli group | 4 | N_w² |
| Bell states | 4 | N_w² |
| Steane code n | 7 | β₀ = N_w^N_c − 1 |
| Steane distance | 3 | N_c |
| Shor code | 9 | N_c² |
| Toffoli inputs | 3 | N_c |
| MERA bond dim | 6 | χ |
| MERA depth | 42 | D |
| Bell entropy | ln(2) | ln(N_w) |
| Teleport bits | 2 | N_w |
| Uncertainty meet | 1/6 | 1/χ |
## Self-Test
```bash
ghc -O2 -main-is CrystalQInfo CrystalQInfo.hs 2>/dev/null && ./CrystalQInfo
```
## Observable Count
13 new. All integers from (2,3).
