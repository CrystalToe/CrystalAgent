<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

Here's every deprecated `.hs` module:

| # | Module | Phase | Why deprecated |
|---|--------|-------|----------------|
| 1 | CrystalArcade.hs | Phase 2 | Standalone, not component stack |
| 2 | CrystalBio.hs | Phase 2 | Standalone, not component stack |
| 3 | CrystalChem.hs | Phase 2 | Standalone, not component stack |
| 4 | CrystalCondensed.hs | Phase 2 | Standalone, not component stack |
| 5 | CrystalDecay.hs | Phase 2 | Standalone, not component stack |
| 6 | CrystalDirac.hs | Phase 2 | Standalone, not component stack |
| 7 | CrystalGravityDyn.hs | Phase 5 | Replaced by new CrystalGravity.hs (dynamics) |
| 8 | CrystalHMC.hs | Phase 2 | Standalone, not component stack |
| 9 | CrystalHierarchy.hs | Phase 2 | Standalone, not component stack |
| 10 | CrystalHologron.hs | Phase 2 | Standalone, not component stack |
| 11 | CrystalLatticeGauge.hs | Phase 2 | Standalone, not component stack |
| 12 | CrystalLayer.hs | Phase 2 | Standalone, not component stack |
| 13 | CrystalMERA.hs | Phase 2 | Standalone, not component stack |
| 14 | CrystalNuclear.hs | Phase 2 | Standalone, not component stack |
| 15 | CrystalOptics.hs | Phase 2 | Standalone, not component stack |
| 16 | CrystalQAlgorithms.hs | Phase 1 | Quantum, not component stack |
| 17 | CrystalQChannels.hs | Phase 1 | Quantum, not component stack |
| 18 | CrystalQHamiltonians.hs | Phase 1 | Quantum, not component stack |
| 19 | CrystalQSimulation.hs | Phase 1 | Quantum, not component stack |
| 20 | CrystalSpin.hs | Phase 2 | Standalone, not component stack |
| 21 | CrystalVEV.hs | Phase 2 | Standalone, not component stack |

**21 modules deprecated.** All in `haskel/depricated/`. All replaced by the component stack: CrystalAtoms → CrystalSectors → CrystalEigen → CrystalOperators → dynamics modules.