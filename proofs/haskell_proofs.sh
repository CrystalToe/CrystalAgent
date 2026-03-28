#!/bin/bash
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

PASS=0; FAIL=0
PROOFS_DIR="$(pwd)"

run() {
    printf "  %-40s" "$1"
    local out="/tmp/_cr_out_$$"
    if eval "$2" > "$out" 2>&1; then
        echo "✓"; PASS=$((PASS+1))
    else
        echo "✗"
        tail -5 "$out" | sed 's/^/    /'
        FAIL=$((FAIL+1))
    fi
    rm -f "$out"
}

cd ../haskel

echo "═══ HASKELL / GHC PROOFS ═══"

echo "  §1 Standalone proof modules"
for mod in CrystalStructural CrystalNoether CrystalDiscoveries; do
    cat > _run_tmp.hs <<EOF
import ${mod}
main :: IO ()
main = runAll
EOF
    run "$mod" "ghc -O2 _run_tmp.hs -o _run_tmp -no-keep-hi-files -no-keep-o-files && ./_run_tmp"
    rm -f _run_tmp.hs _run_tmp
done

echo ""
echo "  §2 Main crystal (92 observables)"
run "Compile Main.hs" "ghc -O2 Main.hs -o crystal"
[ -f crystal ] && {
    printf "  %-40s" "Run → GHC_Certificate.txt"
    if ./crystal > "$PROOFS_DIR/GHC_Certificate.txt" 2>&1; then
        echo "✓"; PASS=$((PASS+1))
    else
        echo "✗"; FAIL=$((FAIL+1))
    fi
}

echo ""
echo "  §3 Extended (86 observables)"
EXTTEST=""
[ -f ExtendedTest.hs ] && EXTTEST="ExtendedTest.hs"
[ -f WACAScanTest.hs ] && [ -z "$EXTTEST" ] && EXTTEST="WACAScanTest.hs"

if [ -n "$EXTTEST" ]; then
    run "Compile $EXTTEST" "ghc -O2 $EXTTEST -o extended_scan"
    [ -f extended_scan ] && run "Run extended_scan" "./extended_scan"
else
    echo "  (skipped — test file not found)"
fi

rm -f *.o *.hi crystal extended_scan
cd "$PROOFS_DIR"

echo ""
echo "  $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "  ALL HASKELL PROOFS PASSED." || exit 1
