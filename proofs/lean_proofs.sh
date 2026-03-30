# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

#!/bin/bash
# Lean 4 proof runner — Session 6 update
# Run from proofs/ directory
set -e

echo "=== Lean 4 Proof Runner (Session 6) ==="
echo ""

FILES=(
  CrystalTopos.lean
  CrystalStructural.lean
  CrystalNoether.lean
  CrystalDiscoveries.lean
  CrystalAlphaProton.lean
  CrystalProtonRadius.lean
  CrystalLayer.lean
  Main.lean
)

PASS=0
TOTAL=${#FILES[@]}

for f in "${FILES[@]}"; do
  echo -n "  $f ... "
  if lean "$f" 2>/dev/null; then
    echo "PASS"
    PASS=$((PASS + 1))
  else
    echo "FAIL"
  fi
done

echo ""
echo "=== Lean 4: $PASS/$TOTAL PASS ==="

# Produce .olean certificates
echo ""
echo "Producing .olean certificates..."
for f in "${FILES[@]}"; do
  lean --make "$f" 2>/dev/null || true
done
echo "Done."
