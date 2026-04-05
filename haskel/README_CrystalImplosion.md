<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalImplosion.hs — Component 9: Hierarchical Implosion

## What This Module Is

The Seeley-DeWitt hierarchical implosion operator on A_F. Takes base formulas
at the a_2 level and applies a_4 corrections using sector dimensions {1, 3, 8, 24}.

This is Component 9 of the 12-component architecture. It owns:

- Hierarchy levels (a_0, a_2, a_4 — the 3-level MERA on A_F)
- Correction channels (Colour=144, Weak=12, Mixed=288, D4Sq=576, Full=42, Custom)
- The implosion operator (base +/- X / (channel x Sigma_d^2 x D))
- Dual route verification (two independent derivations must match)
- 11 proven corrections (4 CODATA + 6 Session 8 + 5 Session 9 outliers)
- Implosion factors for protein force field (7/8, 11/12, 151/144, etc.)

## Dependency

```
CrystalAtoms.hs       <- Component 2 (root)
    |
CrystalImplosion.hs   <- Component 9 (this file)
```

Imports CrystalAtoms only. Uses Integer aliases for Rational arithmetic
(Data.Ratio needs Integer, CrystalAtoms exports Int).

## Replaces

CrystalHierarchy.hs (which duplicated atoms). CrystalHierarchy stays
untouched as the parallel path. Both compile. Both produce identical values.

## The Correction Pattern

Every a_4 correction has the same structure:

    base +/- X / (channel x Sigma_d^2 x D)

- channel selects the gauge sector (product of A_F atoms)
- sign from physics (asymptotic freedom = negative, QCD binding = positive)
- Sigma_d^2 x D = 650 x 42 = 27300 is the shared core
- X is the numerator from A_F atoms
- Every correction has a dual route (two independent derivations)

## Channels

| Channel | Product | Value | Used for |
|---------|---------|-------|----------|
| ColourChannel | chi x d_4 | 144 | alpha_inv (SU(3)) |
| WeakChannel | N_w x chi | 12 | m_p/m_e (weak) |
| MixedChannel | d_3 x Sigma_d | 288 | r_p (mixed) |
| D4Squared | d_4^2 | 576 | r_p dual route |
| FullChannel | D | 42 | Cosmological |

## Dual Routes Verified

| Observable | Route A | Route B | Value |
|-----------|---------|---------|-------|
| r_p | T_F/(d_3 x Sigma_d) | 1/d_4^2 | 1/576 |
| m_Upsilon | N_c^3/(chi x Sigma_d) | N_c^2/(N_w x Sigma_d) | 1/8 |
| m_D | D/(d_4 x Sigma_d) | 1/d_4 + chi/(d_4 x Sigma_d) | 7/144 |
| m_rho | T_F/chi | N_c/Sigma_d | 1/12 |
| m_phi | N_w/(N_c x Sigma_d) | (d_4-d_3)/(d_4 x Sigma_d) | 1/54 |
| Omega_DM | 1/(gauss x (gauss-N_c)) | 1/(N_w x (chi-1) x gauss) | 1/130 |
| sin^2 theta_13 | 1/((D+d_w) x N_w^2 x (chi-1)^2) | 1/(Sigma_d x (chi-1)^3) | 1/4500 |
| m_eta | 1/(N_c x (chi-1)^2) | 1/(N_w x Sigma_d + N_c) | 1/75 |
| M_Z | 1/((D+1) x (chi-1)) | 1/((Sigma_d+chi+1) x (N_w x N_c-1)) | 1/215 |
| decuplet | N_w/gauss^2 | N_w/(N_c^2+N_w^2)^2 | 2/169 |
| m_mu | 1/(d_8 x (2chi-1)) | 1/(N_w^4(chi-1)+d_8) | 1/88 |

All 11 match to machine precision.

## Proofs

| File | Prover | Theorems |
|------|--------|----------|
| CrystalImplosion.agda | refl | 35 |
| CrystalImplosion.lean | native_decide | 30 |

## Compile & Test

```bash
ghc -O2 -main-is CrystalImplosion CrystalImplosion.hs && ./CrystalImplosion
```
