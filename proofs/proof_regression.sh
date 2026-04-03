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

set +e

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
RUST_TOE="$REPO/crystal-toe"
EXAMPLES="$REPO/crystal-topos/examples"
TOE_EXAMPLES="$REPO/crystal-toe/python/examples"
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
  for f in "$PROOFS"/*.lean; do
    [ -f "$f" ] || continue
    local fname=$(basename "$f")
    grep "^theorem " "$f" | sed "s/theorem \([^ :]*\).*/LEAN $fname \1/" >> "$out"
  done
  if [ -d "$HASKEL/LeanCert" ]; then
    for f in "$HASKEL"/LeanCert/*.lean; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      grep "^theorem " "$f" | sed "s/theorem \([^ :]*\).*/LEAN $fname \1/" >> "$out"
    done
  fi

  # ── Lean file count ──
  local lean_files=0
  for f in "$PROOFS"/*.lean; do
    [ -f "$f" ] && lean_files=$((lean_files + 1))
  done
  if [ -d "$HASKEL/LeanCert" ]; then
    for f in "$HASKEL"/LeanCert/*.lean; do
      [ -f "$f" ] && lean_files=$((lean_files + 1))
    done
  fi
  echo "LEAN_FILES $lean_files" >> "$out"

  # ── Agda: every proof name (line before = refl) ──
  echo "# AGDA PROOFS" >> "$out"
  for f in "$PROOFS"/*.agda; do
    [ -f "$f" ] || continue
    local fname=$(basename "$f")
    grep -B1 "= refl" "$f" | grep -v "= refl" | grep -v "^--" | \
      sed 's/^ *//' | sed "s/ .*//" | grep -v "^$" | \
      while read -r name; do
        echo "AGDA $fname $name"
      done >> "$out"
  done
  for f in "$HASKEL"/*.agda; do
    [ -f "$f" ] || continue
    local fname=$(basename "$f")
    grep -B1 "= refl" "$f" | grep -v "= refl" | grep -v "^--" | \
      sed 's/^ *//' | sed "s/ .*//" | grep -v "^$" | \
      while read -r name; do
        echo "AGDA $fname $name"
      done >> "$out"
  done

  # ── Agda file count ──
  local agda_files=0
  for f in "$PROOFS"/*.agda; do
    [ -f "$f" ] && agda_files=$((agda_files + 1))
  done
  for f in "$HASKEL"/*.agda; do
    [ -f "$f" ] && agda_files=$((agda_files + 1))
  done
  echo "AGDA_FILES $agda_files" >> "$out"

  # ── Haskell: compilable modules ──
  echo "# HASKELL MODULES" >> "$out"
  for f in "$HASKEL"/*.hs; do
    [ -f "$f" ] || continue
    local fname=$(basename "$f")
    echo "HASKELL $fname" >> "$out"
  done

  # ── Rust (crystal-topos): every #[test] function name ──
  echo "# RUST TESTS (crystal-topos)" >> "$out"
  if [ -d "$RUST/tests" ]; then
    for f in "$RUST"/tests/*.rs; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      grep -A1 "#\[test\]" "$f" 2>/dev/null | grep "fn " | \
        sed "s|.*fn \([^ (]*\).*|RUST topos/tests/$fname \1|" >> "$out"
    done
  fi
  if [ -d "$RUST/src" ]; then
    for f in "$RUST"/src/*.rs; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      grep -A1 "#\[test\]" "$f" 2>/dev/null | grep "fn " | \
        sed "s|.*fn \([^ (]*\).*|RUST topos/src/$fname \1|" >> "$out"
    done
  fi

  # ── Rust (crystal-toe): every #[test] function name ──
  # Scans src/, src/dynamics/, src/qlib/, tests/
  echo "# RUST TESTS (crystal-toe)" >> "$out"
  if [ -d "$RUST_TOE" ]; then
    find "$RUST_TOE/src" -name '*.rs' 2>/dev/null | sort | while read -r f; do
      [ -f "$f" ] || continue
      local relpath
      relpath=$(echo "$f" | sed "s|$RUST_TOE/||")
      grep -A1 "#\[test\]" "$f" 2>/dev/null | grep "fn " | \
        sed "s|.*fn \([^ (]*\).*|RUST toe/$relpath \1|" >> "$out"
    done
    if [ -d "$RUST_TOE/tests" ]; then
      for f in "$RUST_TOE"/tests/*.rs; do
        [ -f "$f" ] || continue
        local fname=$(basename "$f")
        grep -A1 "#\[test\]" "$f" 2>/dev/null | grep "fn " | \
          sed "s|.*fn \([^ (]*\).*|RUST toe/tests/$fname \1|" >> "$out"
      done
    fi
  fi

  # ── Rust test count per file (crystal-topos) ──
  if [ -d "$RUST/tests" ]; then
    for f in "$RUST"/tests/*.rs; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      local count
      count=$(grep -c "#\[test\]" "$f" 2>/dev/null) || count=0
      echo "RUST_COUNT topos/tests/$fname $count" >> "$out"
    done
  fi
  if [ -d "$RUST/src" ]; then
    for f in "$RUST"/src/*.rs; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      local count
      count=$(grep -c "#\[test\]" "$f" 2>/dev/null) || count=0
      [ "$count" -gt 0 ] && echo "RUST_COUNT topos/src/$fname $count" >> "$out"
    done
  fi

  # ── Rust test count per file (crystal-toe) ──
  if [ -d "$RUST_TOE" ]; then
    find "$RUST_TOE/src" -name '*.rs' 2>/dev/null | sort | while read -r f; do
      [ -f "$f" ] || continue
      local relpath
      relpath=$(echo "$f" | sed "s|$RUST_TOE/||")
      local count
      count=$(grep -c "#\[test\]" "$f" 2>/dev/null) || count=0
      [ "$count" -gt 0 ] && echo "RUST_COUNT toe/$relpath $count" >> "$out"
    done
    if [ -d "$RUST_TOE/tests" ]; then
      for f in "$RUST_TOE"/tests/*.rs; do
        [ -f "$f" ] || continue
        local fname=$(basename "$f")
        local count
        count=$(grep -c "#\[test\]" "$f" 2>/dev/null) || count=0
        [ "$count" -gt 0 ] && echo "RUST_COUNT toe/tests/$fname $count" >> "$out"
      done
    fi
  fi

  # ── Python proof files ──
  echo "# PYTHON PROOF MODULES" >> "$out"
  for f in "$PROOFS"/crystal_*_proof.py; do
    [ -f "$f" ] || continue
    local fname=$(basename "$f")
    echo "PYTHON proofs/$fname" >> "$out"
  done
  if [ -d "$EXAMPLES" ]; then
    for f in "$EXAMPLES"/*.py; do
      [ -f "$f" ] || continue
      local fname=$(basename "$f")
      echo "PYTHON topos/examples/$fname" >> "$out"
    done
  fi

  # ── Python examples (crystal-toe) ──
  echo "# PYTHON EXAMPLES (crystal-toe)" >> "$out"
  if [ -d "$TOE_EXAMPLES" ]; then
    find "$TOE_EXAMPLES" -name '*.py' 2>/dev/null | sort | while read -r f; do
      [ -f "$f" ] || continue
      local relpath
      relpath=$(echo "$f" | sed "s|$RUST_TOE/||")
      echo "PYTHON toe/$relpath" >> "$out"
    done
  fi

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
