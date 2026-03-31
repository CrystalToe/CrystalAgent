# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

#!/bin/bash
# Agda proof runner — auto-discovers all .agda files
# Run from proofs/ directory
set -e

echo "=== Agda Proof Runner ==="
echo ""

PASS=0
FAIL=0

for f in *.agda; do
  [ -f "$f" ] || continue
  echo -n "  $f ... "
  if agda "$f" 2>/dev/null; then
    echo "PASS"
    PASS=$((PASS + 1))
  else
    echo "FAIL"
    FAIL=$((FAIL + 1))
  fi
done

TOTAL=$((PASS + FAIL))
echo ""
echo "=== Agda: $PASS/$TOTAL PASS ==="

if [ "$FAIL" -ne 0 ]; then
  exit 1
fi
