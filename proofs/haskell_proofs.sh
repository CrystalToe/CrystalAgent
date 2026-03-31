#!/bin/bash
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

# Haskell proof runner — auto-discovers all .hs files
# Detects run mode from file content:
#   module Main + main  → compile & run (output binary)
#   main :: / main =    → compile & run with -main-is Module
#   neither             → type-check only (Curry-Howard: compilation = proof)
set -e

# Find repo root
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

cleanup() {
  cd "$HASKEL"
  rm -f *.o *.hi
  rm -f /tmp/hs_proof_bin_*
}
trap cleanup EXIT

echo "=== Haskell Proof Runner ==="
echo "    Running from: $(pwd)"
echo ""

PASS=0
FAIL=0

for f in *.hs; do
  [ -f "$f" ] || continue

  # Extract module name from file
  mod=$(grep "^module " "$f" | head -1 | awk '{print $2}')
  mod=${mod%%(*}   # strip (blah) if present e.g. "Main(main)"

  has_module_main=false
  has_main_func=false

  if echo "$mod" | grep -q "^Main$"; then
    has_module_main=true
  fi

  if grep -q "^main " "$f" || grep -q "^main=" "$f" || grep -q "^main ::" "$f"; then
    has_main_func=true
  fi

  bin="/tmp/hs_proof_bin_$$_$(echo "$f" | sed 's/\.hs$//')"

  if $has_module_main && $has_main_func; then
    # module Main with main → compile & run
    printf "  %s (run) ... " "$f"
    if ghc -O2 "$f" -o "$bin" 2>/dev/null; then
      if [ "$f" = "Main.hs" ]; then
        # Special: Main.hs writes GHC certificate
        "$bin" 2>&1 | tee "$PROOFS/GHC_Certificate.txt" && { echo "PASS"; PASS=$((PASS+1)); } || { echo "FAIL"; FAIL=$((FAIL+1)); }
      else
        "$bin" 2>&1 && { echo "PASS"; PASS=$((PASS+1)); } || { echo "FAIL"; FAIL=$((FAIL+1)); }
      fi
    else
      echo "COMPILE FAIL"; FAIL=$((FAIL+1))
    fi

  elif $has_main_func; then
    # Has main but not module Main → compile with -main-is
    printf "  %s (-main-is %s) ... " "$f" "$mod"
    if ghc -O2 -main-is "$mod" "$f" -o "$bin" 2>/dev/null; then
      "$bin" 2>&1 && { echo "PASS"; PASS=$((PASS+1)); } || { echo "FAIL"; FAIL=$((FAIL+1)); }
    else
      echo "COMPILE FAIL"; FAIL=$((FAIL+1))
    fi

  else
    # No main → type-check only (Curry-Howard)
    printf "  %s (type-check) ... " "$f"
    if ghc -fno-code "$f" 2>/dev/null; then
      echo "PASS"; PASS=$((PASS+1))
    else
      echo "FAIL"; FAIL=$((FAIL+1))
    fi
  fi
done

TOTAL=$((PASS + FAIL))
echo ""
echo "=== Haskell: $PASS/$TOTAL PASS ==="
[ "$FAIL" -eq 0 ] || exit 1
