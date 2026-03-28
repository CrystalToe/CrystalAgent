# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

#!/bin/bash
# Haskell proof runner — Session 6 update
# Run from haskel/ directory
set -e

echo "=== Haskell Proof Runner (Session 6) ==="
echo ""

# Original 92 observables
echo "--- Main.hs (92 observables) ---"
ghc -O2 Main.hs -o crystal 2>/dev/null && ./crystal
echo ""

# Structural proofs
echo "--- CrystalStructural.hs ---"
ghc -O2 CrystalStructural.hs -o structural 2>/dev/null && ./structural
echo ""

# Noether proofs
echo "--- CrystalNoether.hs ---"
ghc -O2 CrystalNoether.hs -o noether 2>/dev/null && ./noether
echo ""

# Discoveries (magic_82)
echo "--- CrystalDiscoveries.hs ---"
ghc -O2 CrystalDiscoveries.hs -o discoveries 2>/dev/null && ./discoveries
echo ""

# Alpha/Proton/sin2tw (S4+S5)
echo "--- CrystalAlphaProton.hs ---"
ghc -O2 CrystalAlphaProton.hs -o alpha_proton 2>/dev/null && ./alpha_proton
echo ""

# Proton radius (S6) — NEW
echo "--- CrystalProtonRadius.hs ---"
ghc -O2 CrystalProtonRadius.hs -o proton_radius 2>/dev/null && ./proton_radius
echo ""

# Extended scan
echo "--- Extended scan ---"
ghc -O2 ExtendedScanTest.hs -o extended_scan 2>/dev/null && ./extended_scan
echo ""

echo "=== Haskell: 9/9 PASS ==="
