<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# ObservableAll.hs — Combined Runner

## Compile

```bash
ghc -O2 -main-is ObservableAll ObservableAll.hs && ./ObservableAll
```

This single command compiles the entire refactored architecture:

```
CrystalAtoms.hs
├── CrystalImplosion.hs
├── CrystalCorrections.hs
├── ObservableMixing.hs      13 obs
├── ObservableGauge.hs       16 obs
├── ObservableMass.hs        30 obs
├── ObservableCosmo.hs       17 obs
├── ObservableNuclear.hs     17 obs
├── ObservableBio.hs         20 obs
├── ObservableCondensed.hs   15 obs
├── ObservableFluid.hs       11 obs
├── ObservableOptics.hs       3 obs
├── ObservableMath.hs        13 obs
└── ObservableAll.hs        155 total
```

## What It Does

Runs all 10 Observable modules in sequence. Each prints its own table with Name, Formula, Crystal, CrystalPdg, Expt, Shift, Gap, Status. Then prints the grand total.

## Four-Column Architecture

Every observable is `type Formula = Double -> Double`. Called twice:

- **Crystal** = f(v_crystal) where v_crystal = 245.17 GeV (derived from M_Pl)
- **CrystalPdg** = f(v_pdg) where v_pdg = 246.22 GeV (PDG experimental)
- **Shift** = |CrystalPdg - Crystal| / Crystal (VEV scheme noise)
- **Gap** = |Expt - CrystalPdg| / Expt (formula accuracy, Status follows this)

## The 155 → 198 Gap

The refactored modules cover 155 observables. The original Main.hs catalogue has 198. The remaining 43 are:

- Heavy hadrons in Main.hs §9c (B_c, B_s, Lambda_b, Xi_c, Sigma_c, Omega_c, D_s, psi(2S), Upsilon(2S), eta_c, Delta(1232), Xi)
- Additional mass chain entries (m_b, m_c MS-bar pole masses)
- Cross-domain extras (proton radius, sigma_piN, m_n-m_p splitting, pion mass difference, hadronic VP)
- Cosmological extras (N_eff, Omega_b/Omega_m, Y_p, sin^2 theta_W running)

These can be added to existing Observable modules — no new modules needed. Each is just another `mk "name" "formula" (\v -> ...) expt level` entry.

## Correction Rules (enforced across all modules)

1. A correction applies ONLY to the specific observable it was derived for
2. M_Z implosion → M_Z mass only. M_W uses uncorrected M_Z = v*3/8
3. m_nu3 correction (10/11) → m_nu3 only. rho_Lambda uses tree m_nu1
4. m_e for nuclear binding uses WACAScan formula (v/257/1872), not muon chain
5. Mass chain (m_t→m_b→m_c→m_s) for quark masses and dm_dec, not Lambda_h/10

## Proofs

Every Observable module has matching Agda (.agda) and Lean (.lean) proof files in `proofs/`. All integer identities verified by `refl` (Agda) or `native_decide` (Lean). Zero postulates.
