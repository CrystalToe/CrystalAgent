-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableAll.hs — Combined runner for all 10 Observable modules.

  Runs each module's main, then prints grand total.
  Proves the refactored architecture end-to-end.

  Compile: ghc -O2 -main-is ObservableAll ObservableAll.hs && ./ObservableAll
-}

module ObservableAll (main) where

import qualified ObservableMixing    (main)
import qualified ObservableGauge     (main)
import qualified ObservableMass      (main)
import qualified ObservableCosmo     (main)
import qualified ObservableNuclear   (main)
import qualified ObservableBio       (main)
import qualified ObservableCondensed (main)
import qualified ObservableFluid     (main)
import qualified ObservableOptics    (main)
import qualified ObservableMath      (main)

main :: IO ()
main = do
  putStrLn "╔══════════════════════════════════════════════════════════════════════╗"
  putStrLn "║  CrystalTopos — Full Observable Catalogue (Refactored Architecture) ║"
  putStrLn "║  N_w = 2, N_c = 3. Zero free parameters. f(VEV) × 2.              ║"
  putStrLn "╚══════════════════════════════════════════════════════════════════════╝"
  putStrLn ""

  ObservableMixing.main
  putStrLn ""
  ObservableGauge.main
  putStrLn ""
  ObservableMass.main
  putStrLn ""
  ObservableCosmo.main
  putStrLn ""
  ObservableNuclear.main
  putStrLn ""
  ObservableBio.main
  putStrLn ""
  ObservableCondensed.main
  putStrLn ""
  ObservableFluid.main
  putStrLn ""
  ObservableOptics.main
  putStrLn ""
  ObservableMath.main

  putStrLn ""
  putStrLn "╔══════════════════════════════════════════════════════════════════════╗"
  putStrLn "║                     GRAND TOTAL                                    ║"
  putStrLn "╠══════════════════════════════════════════════════════════════════════╣"
  putStrLn "║  Module              Obs   Domain                                  ║"
  putStrLn "║  ─────────────────── ───── ──────────────────────────────────────── ║"
  putStrLn "║  ObservableMixing     13   CKM, PMNS, Weinberg                     ║"
  putStrLn "║  ObservableGauge      16   alpha, M_Z, M_W, widths                 ║"
  putStrLn "║  ObservableMass       30   ratios, hadrons, leptons, quarks         ║"
  putStrLn "║  ObservableCosmo      17   Omega_L, CMB, neutrinos                 ║"
  putStrLn "║  ObservableNuclear    17   magic numbers, binding, moments          ║"
  putStrLn "║  ObservableBio        20   genetics, folding, chemistry             ║"
  putStrLn "║  ObservableCondensed  15   BCS, Ising, thermo, chaos               ║"
  putStrLn "║  ObservableFluid      11   Kolmogorov, Reynolds, Rayleigh           ║"
  putStrLn "║  ObservableOptics      3   n_water, n_glass, n_diamond             ║"
  putStrLn "║  ObservableMath       13   e, phi, sqrt(2), zeta(3), Basel         ║"
  putStrLn "║  ─────────────────── ───── ──────────────────────────────────────── ║"
  putStrLn "║  TOTAL              155   Zero free parameters. All from (2,3).    ║"
  putStrLn "╚══════════════════════════════════════════════════════════════════════╝"
