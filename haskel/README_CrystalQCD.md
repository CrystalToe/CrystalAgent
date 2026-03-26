<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQCD.hs — QCD & The Hadron Spectrum

**1,140 lines · Largest module · Proton, quarks, full hadron spectrum**

## Key Results

| Observable | Formula | Value | PWI |
|-----------|---------|-------|-----|
| m_p | v/2^(2^N_c) × 53/54 | 940.0 MeV | 0.18% |
| m_t/m_b | D×53/54 = 371/9 | 41.22 | 0.09% |
| m_b/m_s | N_c³×N_w = 54 | 54.00 | 0.11% |
| m_c/m_s | N_w²×N_c×53/54 = 106/9 | 11.78 | 0.04% |
| f_π | Λ√N_c/((N_c+N_w)√gauss) | 92.0 MeV | 0.06% |
| g_A | N_c²/β₀ = 9/7 | 1.286 | 0.79% |

Also: string tension, charge radius, Regge trajectories, glueballs, all heavy mesons.

## Key Insight
The proton mass uses the Fermat tower: v/2^(2^N_c) = v/256. The 53/54 factor is (D+gauss−N_w)/(D+gauss−N_w+1) — pure spectral data.

## Dependencies
Imports `CrystalAxiom`, `CrystalGauge`.
