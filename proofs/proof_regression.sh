#!/bin/sh
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

# proof_regression.sh — Never lose a proof
#
# Usage:
#   bash proof_regression.sh              # check current state vs baseline
#   bash proof_regression.sh --snapshot   # generate new baseline from current state
#
# Rules:
#   - ADD is OK (new proofs welcome)
#   - DELETE is FAIL (lost a proof)
#   - COUNT DECREASE is FAIL (something got removed)
#
# The baseline file is proofs/proof_manifest.baseline
# The candidate is generated fresh every run.

set -e

# Find repo root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -d "$SCRIPT_DIR/../haskel" ]; then
  REPO="$SCRIPT_DIR/.."
elif [ -d "$SCRIPT_DIR/haskel" ]; then
  REPO="$SCRIPT_DIR"
else
  echo "ERROR: Cannot find repo root." && exit 1
fi

PROOFS="$REPO/proofs"
HASKEL="$REPO/haskel"
RUST="$REPO/crystal-topos"
EXAMPLES="$REPO/crystal-topos/examples"
BASELINE="$PROOFS/proof_manifest.baseline"
CANDIDATE="/tmp/proof_manifest.candidate.$$"

# ════════════════════════════════════════════════════
# GENERATE MANIFEST from current source
# ════════════════════════════════════════════════════

generate_manifest() {
  local out="$1"
  > "$out"

  # ── Lean: every theorem name ──
  echo "# LEAN THEOREMS" >> "$out"
  for f in CrystalTopos.lean CrystalStructural.lean CrystalNoether.lean \
           CrystalDiscoveries.lean CrystalAlphaProton.lean \
           CrystalProtonRadius.lean CrystalLayer.lean Main.lean \
           CrystalGravityDyn.lean \
           CrystalProtein.lean; do                                        # S13
    if [ -f "$PROOFS/$f" ]; then
      grep "^theorem " "$PROOFS/$f" | sed "s/theorem \([^ :]*\).*/LEAN $f \1/" >> "$out"
    fi
    # Also check haskel/LeanCert/ for Lean files
    if [ -f "$HASKEL/LeanCert/$f" ]; then
      grep "^theorem " "$HASKEL/LeanCert/$f" | sed "s/theorem \([^ :]*\).*/LEAN $f \1/" >> "$out"
    fi
  done

  # ── Lean file count ──
  local lean_files=0
  for f in CrystalTopos.lean CrystalStructural.lean CrystalNoether.lean \
           CrystalDiscoveries.lean CrystalAlphaProton.lean \
           CrystalProtonRadius.lean CrystalLayer.lean Main.lean \
           CrystalGravityDyn.lean \
           CrystalProtein.lean; do                                        # S13
    [ -f "$PROOFS/$f" ] && lean_files=$((lean_files + 1))
    [ -f "$HASKEL/LeanCert/$f" ] && lean_files=$((lean_files + 1))
  done
  echo "LEAN_FILES $lean_files" >> "$out"

  # ── Agda: every proof name (line before = refl) ──
  echo "# AGDA PROOFS" >> "$out"
  for f in CrystalTopos.agda CrystalStructural.agda CrystalNoether.agda \
           CrystalDiscoveries.agda CrystalAlphaProton.agda \
           CrystalProtonRadius.agda CrystalLayer.agda \
           CrystalGravityDyn.agda \
           CrystalProtein.agda; do                                        # S13
    # Check proofs/ dir
    if [ -f "$PROOFS/$f" ]; then
      grep -B1 "= refl" "$PROOFS/$f" | grep -v "= refl" | grep -v "^--" | \
        sed 's/^ *//' | sed "s/ .*//" | grep -v "^$" | \
        while read -r name; do
          echo "AGDA $f $name"
        done >> "$out"
    fi
    # Check haskel/ dir (where agda files also live)
    if [ -f "$HASKEL/$f" ]; then
      grep -B1 "= refl" "$HASKEL/$f" | grep -v "= refl" | grep -v "^--" | \
        sed 's/^ *//' | sed "s/ .*//" | grep -v "^$" | \
        while read -r name; do
          echo "AGDA $f $name"
        done >> "$out"
    fi
  done

  # ── Agda file count ──
  local agda_files=0
  for f in CrystalTopos.agda CrystalStructural.agda CrystalNoether.agda \
           CrystalDiscoveries.agda CrystalAlphaProton.agda \
           CrystalProtonRadius.agda CrystalLayer.agda \
           CrystalGravityDyn.agda \
           CrystalProtein.agda; do                                        # S13
    [ -f "$PROOFS/$f" ] && agda_files=$((agda_files + 1))
    [ -f "$HASKEL/$f" ] && agda_files=$((agda_files + 1))
  done
  echo "AGDA_FILES $agda_files" >> "$out"

  # ── Haskell: compilable modules ──
  echo "# HASKELL MODULES" >> "$out"
  for f in Main.hs CrystalStructural.hs CrystalNoether.hs \
           CrystalDiscoveries.hs CrystalAlphaProton.hs \
           CrystalProtonRadius.hs WACAScanTest.hs \
           CrystalHierarchy.hs CrystalLayer.hs \
           CrystalAxiom.hs CrystalGauge.hs CrystalMixing.hs \
           CrystalCosmo.hs CrystalQCD.hs CrystalGravity.hs \
           CrystalAudit.hs CrystalCrossDomain.hs CrystalRiemann.hs \
           CrystalWACAScan.hs CrystalQuantum.hs \
           CrystalQBase.hs CrystalQGates.hs CrystalQChannels.hs \
           CrystalQHamiltonians.hs CrystalQMeasure.hs \
           CrystalQEntangle.hs CrystalQAlgorithms.hs \
           CrystalQSimulation.hs \
           CrystalGravityDyn.hs GravityDynTest.hs \
           CrystalProtein.hs; do                                          # S13
    [ -f "$HASKEL/$f" ] && echo "HASKELL $f" >> "$out"
  done

  # ── Haskell observable count ──
  if [ -f "$HASKEL/CrystalFullTest.hs" ]; then
    echo "HASKELL CrystalFullTest.hs" >> "$out"
  fi

  # ── Rust: every #[test] function name ──
  echo "# RUST TESTS" >> "$out"
  if [ -d "$RUST/tests" ]; then
    for f in "$RUST"/tests/*.rs; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      grep -A1 "#\[test\]" "$f" 2>/dev/null | grep "fn " | \
        sed "s/.*fn \([^ (]*\).*/RUST $fname \1/" >> "$out"
    done
  fi
  if [ -d "$RUST/src" ]; then
    for f in "$RUST"/src/*.rs; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      grep -A1 "#\[test\]" "$f" 2>/dev/null | grep "fn " | \
        sed "s/.*fn \([^ (]*\).*/RUST $fname \1/" >> "$out"
    done
  fi

  # ── Rust test count per file ──
  if [ -d "$RUST/tests" ]; then
    for f in "$RUST"/tests/*.rs; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      local count
      count=$(grep -c "#\[test\]" "$f" 2>/dev/null) || count=0
      echo "RUST_COUNT $fname $count" >> "$out"
    done
  fi
  if [ -d "$RUST/src" ]; then
    for f in "$RUST"/src/*.rs; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      local count
      count=$(grep -c "#\[test\]" "$f" 2>/dev/null) || count=0
      [ "$count" -gt 0 ] && echo "RUST_COUNT $fname $count" >> "$out"
    done
  fi

  # ── Python proof files ──
  echo "# PYTHON PROOF MODULES" >> "$out"
  for f in "$PROOFS"/crystal_*_proof.py; do
    if [ -f "$f" ]; then
      local fname=$(basename "$f")
      echo "PYTHON $fname" >> "$out"
    fi
  done
  # Session 12: gravity computation files in examples/
  for f in mera_gravity_closed.py mera_linearized_gravity.py spectral_tower.py qubo_folder.py \
           crystal_vdw.py; do                                             # S13
    if [ -f "$EXAMPLES/$f" ]; then
      echo "PYTHON $f" >> "$out"
    fi
  done

  # ── Summary counts ──
  echo "# SUMMARY COUNTS" >> "$out"
  local lean_thm=$(grep "^LEAN " "$out" | grep -v "LEAN_FILES" | wc -l)
  local agda_prf=$(grep "^AGDA " "$out" | grep -v "AGDA_FILES" | wc -l)
  local rust_tst=$(grep "^RUST " "$out" | grep -v "RUST_COUNT" | wc -l)
  local haskell_mod=$(grep "^HASKELL " "$out" | wc -l)
  local python_mod=$(grep "^PYTHON " "$out" | wc -l)
  echo "TOTAL_LEAN_THEOREMS $lean_thm" >> "$out"
  echo "TOTAL_AGDA_PROOFS $agda_prf" >> "$out"
  echo "TOTAL_RUST_TESTS $rust_tst" >> "$out"
  echo "TOTAL_HASKELL_MODULES $haskell_mod" >> "$out"
  echo "TOTAL_PYTHON_MODULES $python_mod" >> "$out"
}

# ════════════════════════════════════════════════════
# SNAPSHOT MODE: generate baseline
# ════════════════════════════════════════════════════

if [ "${1:-}" = "--snapshot" ]; then
  echo "=== Generating proof baseline ==="
  generate_manifest "$BASELINE"
  lean_thm=$(grep "^TOTAL_LEAN_THEOREMS" "$BASELINE" | awk '{print $2}')
  agda_prf=$(grep "^TOTAL_AGDA_PROOFS" "$BASELINE" | awk '{print $2}')
  rust_tst=$(grep "^TOTAL_RUST_TESTS" "$BASELINE" | awk '{print $2}')
  hask_mod=$(grep "^TOTAL_HASKELL_MODULES" "$BASELINE" | awk '{print $2}')
  py_mod=$(grep "^TOTAL_PYTHON_MODULES" "$BASELINE" | awk '{print $2}')
  echo ""
  echo "  Lean theorems:    $lean_thm"
  echo "  Agda proofs:      $agda_prf"
  echo "  Rust tests:       $rust_tst"
  echo "  Haskell modules:  $hask_mod"
  echo "  Python modules:   $py_mod"
  echo ""
  echo "  Baseline written to: $BASELINE"
  echo "  Run without --snapshot to check against this baseline."
  exit 0
fi

# ════════════════════════════════════════════════════
# REGRESSION MODE: compare candidate vs baseline
# ════════════════════════════════════════════════════

if [ ! -f "$BASELINE" ]; then
  echo "ERROR: No baseline found at $BASELINE"
  echo "Run: bash proof_regression.sh --snapshot"
  exit 1
fi

echo "=== Proof Regression Test ==="
echo "    Baseline: $BASELINE"
echo ""

generate_manifest "$CANDIDATE"

FAIL=0
WARN=0
ADDED=0

# Temp files for POSIX compatibility (no process substitution)
TMPCHECK="/tmp/proof_regression_check.$$"
trap 'rm -f "$CANDIDATE" "$TMPCHECK"' EXIT

# ── Check: every baseline proof still exists in candidate ──
echo "  Checking for lost proofs..."

check_deleted() {
  local prefix="$1"
  local exclude="$2"
  if [ -n "$exclude" ]; then
    grep "^$prefix " "$BASELINE" | grep -v "$exclude" > "$TMPCHECK" 2>/dev/null || true
  else
    grep "^$prefix " "$BASELINE" > "$TMPCHECK" 2>/dev/null || true
  fi
  while IFS= read -r line; do
    if ! grep -qF "$line" "$CANDIDATE"; then
      echo "    FAIL (DELETED): $line"
      FAIL=$((FAIL + 1))
    fi
  done < "$TMPCHECK"
}

check_deleted "LEAN" "LEAN_FILES"
check_deleted "AGDA" "AGDA_FILES"
check_deleted "RUST" "RUST_COUNT"
check_deleted "HASKELL" ""
check_deleted "PYTHON" ""

# ── Check: no count decreases ──
echo ""
echo "  Checking proof counts..."

check_count() {
  local label="$1"
  local base=$(grep "^$label " "$BASELINE" | head -1 | awk '{print $2}')
  local cand=$(grep "^$label " "$CANDIDATE" | head -1 | awk '{print $2}')
  base=${base:-0}
  cand=${cand:-0}

  if [ "$cand" -lt "$base" ]; then
    echo "    FAIL: $label decreased from $base to $cand (lost $((base - cand)))"
    FAIL=$((FAIL + 1))
  elif [ "$cand" -gt "$base" ]; then
    local diff=$((cand - base))
    echo "    OK:   $label $base -> $cand (+$diff added)"
    ADDED=$((ADDED + diff))
  else
    echo "    OK:   $label $cand (unchanged)"
  fi
}

check_count "TOTAL_LEAN_THEOREMS"
check_count "TOTAL_AGDA_PROOFS"
check_count "TOTAL_RUST_TESTS"
check_count "TOTAL_HASKELL_MODULES"
check_count "TOTAL_PYTHON_MODULES"
check_count "LEAN_FILES"
check_count "AGDA_FILES"

# ── Check per-file Rust counts ──
grep "^RUST_COUNT " "$BASELINE" > "$TMPCHECK" 2>/dev/null || true
while IFS= read -r line; do
  fname=$(echo "$line" | awk '{print $2}')
  base_count=$(echo "$line" | awk '{print $3}')
  cand_count=$(grep "^RUST_COUNT $fname " "$CANDIDATE" | head -1 | awk '{print $3}')
  cand_count=${cand_count:-0}
  if [ "$cand_count" -lt "$base_count" ]; then
    echo "    FAIL: Rust $fname decreased from $base_count to $cand_count"
    FAIL=$((FAIL + 1))
  fi
done < "$TMPCHECK"

# ── Check for new proofs (additions — just report) ──
echo ""
echo "  Checking for new proofs..."
NEW_PROOFS=0
grep "^LEAN \|^AGDA \|^RUST \|^HASKELL \|^PYTHON " "$CANDIDATE" | \
  grep -v "LEAN_FILES\|AGDA_FILES\|RUST_COUNT" > "$TMPCHECK" 2>/dev/null || true
while IFS= read -r line; do
  if ! grep -qF "$line" "$BASELINE"; then
    echo "    NEW: $line"
    NEW_PROOFS=$((NEW_PROOFS + 1))
  fi
done < "$TMPCHECK"

if [ "$NEW_PROOFS" -eq 0 ]; then
  echo "    (none)"
fi

# ── Verdict ──
echo ""
echo "  ============================================="
if [ "$FAIL" -gt 0 ]; then
  echo "  RESULT: FAIL -- $FAIL proof(s) lost or count(s) decreased"
  echo "  ============================================="
  exit 1
else
  echo "  RESULT: PASS"
  if [ "$NEW_PROOFS" -gt 0 ]; then
    echo "    $NEW_PROOFS new proof(s) added"
    echo "    Run --snapshot to update baseline"
  else
    echo "    No changes from baseline"
  fi
  echo "  ============================================="
  exit 0
fi
