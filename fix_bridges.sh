# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

#!/bin/bash
set -e

echo "Restoring Lean and Agda to clean state..."
git checkout haskel/CrystalTopos.lean
git checkout haskel/CrystalTopos.agda

echo "Appending Lean bridge theorems..."
cat lean_bridge_theorems.lean >> haskel/CrystalTopos.lean

echo "Fixing Agda monus operator and appending..."
sed 's/∸/-/g' agda_bridge_proofs.agda >> haskel/CrystalTopos.agda

echo "Cleaning up temp files..."
rm -f lean_bridge_theorems.lean agda_bridge_proofs.agda rust_bridge_tests.rs haskell_bridge_verification.hs apply_bridge_proofs.sh bridge_proofs.zip
rm -rf bridge_proofs/

echo ""
echo "Done. Verify:"
echo "  Lean theorems: $(grep -c 'theorem ' haskel/CrystalTopos.lean)"
echo "  Agda proofs:   $(grep -c 'refl' haskel/CrystalTopos.agda)"
echo "  Rust tests:    $(grep -c '#\[test\]' crystal-topos/tests/crystal_tests.rs)"
