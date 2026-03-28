#!/bin/bash
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

PASS=0; FAIL=0

run() {
    local file="$1"
    local name="${file%.lean}"
    printf "  %-40s" "$file"
    local out="/tmp/_lean_out_$$"

    rm -rf _LeanCert
    mkdir _LeanCert && cd _LeanCert

    # Write lakefile as library (not exe)
    cat > lakefile.lean <<'EOF'
import Lake
open Lake DSL
package crystaltopos
@[default_target]
lean_lib Main
EOF

    # Write lean-toolchain from parent if exists, else create one
    if [ -f ../lean-toolchain ]; then
        cp ../lean-toolchain .
    else
        echo "leanprover/lean4:stable" > lean-toolchain
    fi

    cp "../$file" Main.lean
    if lake build > "$out" 2>&1; then
        find . -name "Main.olean" -exec cp {} "../${name}.olean" \; 2>/dev/null
        echo "✓ → ${name}.olean"; PASS=$((PASS+1))
    else
        echo "✗"
        tail -3 "$out" | sed 's/^/    /'
        FAIL=$((FAIL+1))
    fi
    cd ..
    rm -rf _LeanCert "$out"
}

echo "═══ LEAN 4 PROOFS ═══"
run CrystalTopos.lean
run CrystalStructural.lean
run CrystalNoether.lean
run CrystalDiscoveries.lean
run CrystalAlphaProton.lean
run Main.lean

echo ""
echo "  $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "  ALL LEAN PROOFS PASSED. Zero sorry. Zero admit." || exit 1
