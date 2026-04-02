<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalGW.hs — Gravitational Waveforms from (2,3)

## What This Module Does

Binary inspiral waveform generation. Chirp signal h+(t), hx(t) from
Peters quadrupole formula through ISCO cutoff. Every coefficient from A_F.

## The GW Integer Map

| Quantity | Value | Crystal Source | Physical Meaning |
|----------|-------|---------------|-----------------|
| Peters coefficient | 32/5 | N_w^5/(chi-1) | Quadrupole power |
| Orbital decay | 64/5 | N_w^6/(chi-1) | da/dt coefficient |
| Chirp rate | 96/5 | N_c*N_w^5/(chi-1) | df/dt coefficient |
| Merger time | 5/256 | (chi-1)/N_w^8 | t_merge coefficient |
| Chirp mass exp | 3/5 | N_c/(chi-1) | M_c = mu^(3/5)*M^(2/5) |
| Frequency exp | 2/3 | (N_c-1)/N_c | h ~ f^(2/3) |
| Waveform amplitude | 4 | N_w^2 | 4/r prefactor |
| Polarizations | 2 | N_c-1 | h+, hx |
| GW freq doubling | 2 | N_w | f_GW = 2*f_orb |
| ISCO cutoff | 6 | chi | f_ISCO ~ 1/(6^(3/2) pi M) |
| Kolmogorov in chirp | 5/3 | (chi-1)/N_c | M_c exponent |
| Chirp power | 8/3 | d_colour/N_c | pi exponent |
| Chirp power | 11/3 | (N_c^2+N_w)/N_c | f exponent |

## Key Surprise

The Kolmogorov turbulence exponent 5/3 = (chi-1)/N_c appears in the
chirp mass formula. GW inspiral and turbulent energy cascade use the
same number from the same algebraic source. WACA graft score: 8/10.

## Proof Certificate

- `proofs/crystal_gw_proof.py` — 35/35 PASS
- `proofs/CrystalGW.lean` — 22 theorems by native_decide
- `proofs/CrystalGW.agda` — 14 proofs by refl
