#!/bin/bash
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

# Haskell proof runner — Session 13
set -e

# Find repo root (works from proofs/, haskel/, or repo root)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -d "$SCRIPT_DIR/../haskel" ]; then
  REPO="$SCRIPT_DIR/.."
elif [ -d "$SCRIPT_DIR/haskel" ]; then
  REPO="$SCRIPT_DIR"
else
  echo "ERROR: Cannot find haskel/ directory." && exit 1
fi

HASKEL="$REPO/haskel"
PROOFS="$REPO/proofs"
cd "$HASKEL"

# Clean up build artifacts on exit (always, even on failure)
cleanup() {
  cd "$HASKEL"
  rm -f *.o *.hi
  rm -f crystal structural noether discoveries alpha_proton proton_radius extended_scan hierarchy_test full_test crystal_layer gravity_dyn_test crystal_protein crystal_mandelbrot
}
trap cleanup EXIT

echo "=== Haskell Proof Runner (Session 13) ==="
echo "    Running from: $(pwd)"
echo "    Certificate:  $PROOFS/GHC_Certificate.txt"
echo ""

PASS=0
FAIL=0

run_main() {
  local label="$1" src="$2" out="$3"
  echo "--- $label ---"
  if ghc -O2 "$src" -o "$out" 2>&1; then
    ./"$out" && PASS=$((PASS+1)) || FAIL=$((FAIL+1))
  else
    echo "  COMPILE FAILED"; FAIL=$((FAIL+1))
  fi
  echo ""
}

run_exe() {
  local label="$1" src="$2" mod="$3" out="$4"
  echo "--- $label ---"
  if ghc -O2 -main-is "$mod" "$src" -o "$out" 2>&1; then
    ./"$out" && PASS=$((PASS+1)) || FAIL=$((FAIL+1))
  else
    echo "  COMPILE FAILED"; FAIL=$((FAIL+1))
  fi
  echo ""
}

typecheck() {
  local label="$1" src="$2"
  echo "--- $label (type-check = proof) ---"
  if ghc -fno-code "$src" 2>&1; then
    echo "  Type-checks OK (Curry-Howard: compilation = proof)"
    PASS=$((PASS+1))
  else
    echo "  TYPE-CHECK FAILED"; FAIL=$((FAIL+1))
  fi
  echo ""
}

# 1. Original 92 observables (module Main) -> GHC_Certificate.txt
echo "--- Main.hs (92 observables) ---"
if ghc -O2 Main.hs -o crystal 2>&1; then
  ./crystal | tee "$PROOFS/GHC_Certificate.txt" && PASS=$((PASS+1)) || FAIL=$((FAIL+1))
else
  echo "  COMPILE FAILED"; FAIL=$((FAIL+1))
fi
echo ""

# 2-4. Library proof modules (no main -- type-check IS the proof)
typecheck "CrystalStructural.hs"  "CrystalStructural.hs"
typecheck "CrystalNoether.hs"     "CrystalNoether.hs"
typecheck "CrystalDiscoveries.hs" "CrystalDiscoveries.hs"

# 5-6. Standalone proof modules (have main, need -main-is)
run_exe "CrystalAlphaProton.hs (S4+S5)"  "CrystalAlphaProton.hs"  "CrystalAlphaProton"  "alpha_proton"
run_exe "CrystalProtonRadius.hs (S6)"    "CrystalProtonRadius.hs" "CrystalProtonRadius" "proton_radius"

# 7. Extended scan (module Main)
run_main "Extended scan" "WACAScanTest.hs" "extended_scan"

# 8. Hierarchical implosion (S8)
run_exe "CrystalHierarchy.hs (S8)"  "CrystalHierarchy.hs"  "CrystalHierarchy"  "hierarchy_test"

# 9. Full 181-observable regression test (S7+S8)
run_exe "CrystalFullTest.hs (181 obs)"  "CrystalFullTest.hs"  "CrystalFullTest"  "full_test"

# 10. Spectral tower layer provenance (S11)
run_exe "CrystalLayer.hs (S11 tower)"  "CrystalLayer.hs"  "CrystalLayer"  "crystal_layer"

# 11. Dynamical gravity type-check (S12)
typecheck "CrystalGravityDyn.hs (S12 gravity)"  "CrystalGravityDyn.hs"

# 12. Dynamical gravity audit (S12 — 12/12 integer audit)
run_main "GravityDynTest.hs (S12 audit)"  "GravityDynTest.hs"  "gravity_dyn_test"

# 13. Protein force field (S14 — 73 proofs, D=0..D=42)
run_exe "CrystalProtein.hs (S14 force field)"  "CrystalProtein.hs"  "CrystalProtein"  "crystal_protein"

# 14. Mandelbrot <-> A_F (S14 — 28 proofs)
run_exe "CrystalMandelbrot.hs (S14 Mandelbrot)"  "CrystalMandelbrot.hs"  "CrystalMandelbrot"  "crystal_mandelbrot"

# Tally (cleanup runs automatically via trap)
TOTAL=$((PASS+FAIL))
echo "=== Haskell: $PASS/$TOTAL PASS ==="
[ "$FAIL" -eq 0 ] || exit 1
