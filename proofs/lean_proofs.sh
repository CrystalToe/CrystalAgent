# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

#!/bin/bash
# Lean 4 proof runner — auto-discovers all .lean files
# Run from proofs/ directory
set -e

echo "=== Lean 4 Proof Runner ==="
echo ""

PASS=0
FAIL=0

for f in *.lean; do
  [ -f "$f" ] || continue
  echo -n "  $f ... "
  if lean "$f" 2>/dev/null; then
    echo "PASS"
    PASS=$((PASS + 1))
  else
    echo "FAIL"
    FAIL=$((FAIL + 1))
  fi
done

TOTAL=$((PASS + FAIL))
echo ""
echo "=== Lean 4: $PASS/$TOTAL PASS ==="

# Produce .olean certificates
echo ""
echo "Producing .olean certificates..."
for f in *.lean; do
  [ -f "$f" ] || continue
  lean --make "$f" 2>/dev/null || true
done
echo "Done."

if [ "$FAIL" -ne 0 ]; then
  exit 1
fi
