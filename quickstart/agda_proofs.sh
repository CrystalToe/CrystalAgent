# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

#!/bin/bash
# Agda proof runner — Session 6 update
# Run from proofs/ directory
set -e

echo "=== Agda Proof Runner (Session 6) ==="
echo ""

FILES=(
  CrystalTopos.agda
  CrystalStructural.agda
  CrystalNoether.agda
  CrystalDiscoveries.agda
  CrystalAlphaProton.agda
  CrystalProtonRadius.agda
)

PASS=0
TOTAL=${#FILES[@]}

for f in "${FILES[@]}"; do
  echo -n "  $f ... "
  if agda "$f" 2>/dev/null; then
    echo "PASS"
    PASS=$((PASS + 1))
  else
    echo "FAIL"
  fi
done

echo ""
echo "=== Agda: $PASS/$TOTAL PASS ==="
