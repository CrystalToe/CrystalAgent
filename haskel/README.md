<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalTopos


```bash
# From haskel/ directory:
 
# 1. Main (92 observables)
ghc -O2 Main.hs -o crystal && ./crystal
 
# 2-4. Library proof modules (type-check = proof, no main)
ghc -fno-code CrystalStructural.hs
ghc -fno-code CrystalNoether.hs
ghc -fno-code CrystalDiscoveries.hs
 
# 5. Alpha + proton mass (S4+S5)
ghc -O2 -main-is CrystalAlphaProton CrystalAlphaProton.hs -o alpha_proton && ./alpha_proton
 
# 6. Proton radius (S6)
ghc -O2 -main-is CrystalProtonRadius CrystalProtonRadius.hs -o proton_radius && ./proton_radius
 
# 7. Extended scan (86 observables)
ghc -O2 WACAScanTest.hs -o extended_scan && ./extended_scan
 
# 8. Hierarchical implosion (S8)
ghc -O2 -main-is CrystalHierarchy CrystalHierarchy.hs -o hierarchy_test && ./hierarchy_test
 
# 9. Full regression (all 181)
ghc -O2 -main-is CrystalFullTest CrystalFullTest.hs -o full_test && ./full_test
 
# 10. Spectral tower (S11)
ghc -O2 -main-is CrystalLayer CrystalLayer.hs -o crystal_layer && ./crystal_layer
 
# 11. Dynamical gravity type-check (S12 — Curry-Howard proof)
ghc -fno-code CrystalGravityDyn.hs
 
# 12. Dynamical gravity audit (S12 — 12/12 integer audit)
ghc -O2 GravityDynTest.hs -o gravity_dyn_test && ./gravity_dyn_test
 
# 13. Protein force field (S13 — 26 proofs, D=0..D=38)
ghc -O2 -main-is CrystalProtein CrystalProtein.hs -o crystal_protein && ./crystal_protein

# 14. Mandelbrot <-> A_F (S14 — 38 proofs, functor + external angles)
ghc -O2 -main-is CrystalMandelbrot CrystalMandelbrot.hs -o crystal_mandelbrot && ./crystal_mandelbrot
 
# Clean up
rm -f *.o *.hi crystal alpha_proton proton_radius extended_scan hierarchy_test full_test crystal_layer gravity_dyn_test crystal_protein
 
```





# Branch Protection
```bash
# Lean (7/7)
bash proofs/lean_proofs.sh

# Agda (6/6)
bash proofs/agda_proofs.sh

# Rust (235 tests)
cd crystal-topos && cargo test && cd ..

# 1. Haskell proofs (7/7 compile + run)
bash proofs/haskell_proofs.sh

# 2. Full unit test (181 observables, CV, outliers)
cd haskel && ghc -O2 -main-is CrystalFullTest CrystalFullTest.hs -o full_test && ./full_test && cd ..

# 3. Proof regression (no proofs lost)
bash proofs/proof_regression.sh

# 4. Branch gate (12 checks)
bash branch_gate.sh development

```

```bash
# 1. You're on your working branch
git checkout foobar

# 2. Run the gate — it checks, reports pass/fail, touches nothing
bash branch_gate.sh development

# 3. Only if it passes, YOU do the merge manually
git checkout development
git merge session7
```












