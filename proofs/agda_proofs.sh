#!/bin/bash
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

PASS=0; FAIL=0

run() {
    printf "  %-40s" "$1"
    if agda "$1" 2>/dev/null; then
        echo "✓"; PASS=$((PASS+1))
    else
        echo "✗"; FAIL=$((FAIL+1))
    fi
}

echo "═══ AGDA PROOFS ═══"
run CrystalTopos.agda
run CrystalStructural.agda
run CrystalNoether.agda
run CrystalDiscoveries.agda

echo ""
echo "  $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "  ALL AGDA PROOFS PASSED." || exit 1
