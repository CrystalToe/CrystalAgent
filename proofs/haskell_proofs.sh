#!/bin/bash
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

# Haskell proof runner — Phase 5 refactored
#
# Auto-discovers all .hs files in haskel/ (skips depricated/).
# Detects run mode from file content:
#   module Main + main  → compile & run (output binary)
#   main :: / main =    → compile & run with -main-is Module
#   neither             → type-check only (Curry-Howard: compilation = proof)
#
# GHC flags: -O2 -Wno-x-partial (suppress head/tail warnings from GHC 9.10+)
#
# Special outputs:
#   Main.hs             → writes GHC_Certificate.txt
#   CrystalFullTest.hs  → writes FullTest_Report.txt
#
# Phase 5 notes:
#   - CrystalGravity.hs is now a dynamics module (not the old proof module)
#   - 21 modules in depricated/ are skipped
#   - Component stack: CrystalAtoms → CrystalSectors → CrystalEigen → CrystalOperators
#   - All dynamics modules do pack → tick → unpack on the 36

set -e

# ── Find repo root ──────────────────────────────────────────────
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
mkdir -p "$PROOFS"
cd "$HASKEL"

# ── GHC flags ───────────────────────────────────────────────────
GHC_FLAGS="-O2 -Wno-x-partial"

# ── Cleanup on exit ─────────────────────────────────────────────
cleanup() {
  cd "$HASKEL"
  rm -f *.o *.hi
  rm -f /tmp/hs_proof_bin_*
}
trap cleanup EXIT

# ── Header ──────────────────────────────────────────────────────
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Haskell Proof Runner — Phase 5 Refactored                  ║"
echo "║  A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ).  N_w = 2, N_c = 3.            ║"
echo "║  The dynamics IS the tick on the 36.                        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "  GHC flags: $GHC_FLAGS"
echo "  Directory: $(pwd)"
echo ""

PASS=0
FAIL=0
SKIP=0

# ── Process each .hs file ──────────────────────────────────────
for f in *.hs; do
  [ -f "$f" ] || continue

  # Extract module name
  mod=$(grep "^module " "$f" | head -1 | awk '{print $2}')
  mod=${mod%%(*}   # strip export list paren

  # Skip if no module declaration (shouldn't happen but guard)
  if [ -z "$mod" ]; then
    printf "  %-40s SKIP (no module)\n" "$f"
    SKIP=$((SKIP+1))
    continue
  fi

  # Detect main function
  has_module_main=false
  has_main_func=false

  [ "$mod" = "Main" ] && has_module_main=true

  if grep -qE "^main |^main=|^main ::" "$f"; then
    has_main_func=true
  fi

  bin="/tmp/hs_proof_bin_$$_${f%.hs}"

  if $has_module_main && $has_main_func; then
    # ── module Main with main → compile & run ──
    printf "  %-40s " "$f (run)"
    if ghc $GHC_FLAGS "$f" -o "$bin" 2>/dev/null; then
      if [ "$f" = "Main.hs" ]; then
        if "$bin" > "$PROOFS/GHC_Certificate.txt" 2>&1; then
          echo "PASS → GHC_Certificate.txt"
          PASS=$((PASS+1))
        else
          echo "FAIL (runtime)"
          FAIL=$((FAIL+1))
        fi
      else
        if "$bin" > /dev/null 2>&1; then
          echo "PASS"
          PASS=$((PASS+1))
        else
          echo "FAIL (runtime)"
          FAIL=$((FAIL+1))
        fi
      fi
    else
      echo "FAIL (compile)"
      FAIL=$((FAIL+1))
    fi

  elif $has_main_func; then
    # ── Has main but not module Main → -main-is ──
    printf "  %-40s " "$f (-main-is $mod)"
    if ghc $GHC_FLAGS -main-is "$mod" "$f" -o "$bin" 2>/dev/null; then
      if [ "$f" = "CrystalFullTest.hs" ]; then
        if "$bin" > "$PROOFS/FullTest_Report.txt" 2>&1; then
          echo "PASS → FullTest_Report.txt"
          PASS=$((PASS+1))
        else
          echo "FAIL (runtime)"
          FAIL=$((FAIL+1))
        fi
      else
        if "$bin" > /dev/null 2>&1; then
          echo "PASS"
          PASS=$((PASS+1))
        else
          echo "FAIL (runtime)"
          FAIL=$((FAIL+1))
        fi
      fi
    else
      echo "FAIL (compile)"
      FAIL=$((FAIL+1))
    fi

  else
    # ── No main → type-check only (Curry-Howard) ──
    printf "  %-40s " "$f (type-check)"
    if ghc -fno-code $GHC_FLAGS "$f" 2>/dev/null; then
      echo "PASS"
      PASS=$((PASS+1))
    else
      echo "FAIL (type-check)"
      FAIL=$((FAIL+1))
    fi
  fi
done

# ── Summary ─────────────────────────────────────────────────────
TOTAL=$((PASS + FAIL))
echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  Haskell: $PASS/$TOTAL PASS"
[ "$SKIP" -gt 0 ] && echo "  Skipped: $SKIP"
echo "  Deprecated: $(ls depricated/*.hs 2>/dev/null | wc -l) modules in depricated/"
echo "══════════════════════════════════════════════════════════════"
[ "$FAIL" -eq 0 ] || exit 1
