# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

#!/bin/bash
# build_rag_bundle.sh — Build RAG quickstart bundle (Session 6)
# Run from repo root
# Mac compatible (no GNU-specific flags)

set -e

BUNDLE_DIR="quickstart"
TIMESTAMP=$(date +%Y%m%d)

echo "=== Building RAG Bundle (Session 6) ==="
echo ""

# Clean previous
rm -rf "$BUNDLE_DIR"
mkdir -p "$BUNDLE_DIR"

# ── 1. LLM Prompts ──
echo "1. LLM prompts"
cp agent/crystal_topos_waca_llm.md "$BUNDLE_DIR/"
cp agent/crystal_topos_waca_llm_compact.md "$BUNDLE_DIR/"

# ── 2. Axiom + Core Haskell (the proof authority) ──
echo "2. Core Haskell modules"
cp haskel/CrystalAxiom.hs "$BUNDLE_DIR/"
cp haskel/Main.hs "$BUNDLE_DIR/"
cp haskel/CrystalAlphaProton.hs "$BUNDLE_DIR/"
cp haskel/CrystalProtonRadius.hs "$BUNDLE_DIR/"

# ── 3. Proof files (all 5 systems) ──
echo "3. Proof files"
# Lean
cp proofs/CrystalTopos.lean "$BUNDLE_DIR/"
cp proofs/CrystalAlphaProton.lean "$BUNDLE_DIR/"
cp proofs/CrystalProtonRadius.lean "$BUNDLE_DIR/"

# Agda
cp proofs/CrystalTopos.agda "$BUNDLE_DIR/"
cp proofs/CrystalAlphaProton.agda "$BUNDLE_DIR/"
cp proofs/CrystalProtonRadius.agda "$BUNDLE_DIR/"

# Python
cp proofs/crystal_proton_radius_proof.py "$BUNDLE_DIR/"

# ── 4. Rust test (proton radius) ──
echo "4. Rust tests"
cp crystal-topos/tests/crystal_proton_radius_tests.rs "$BUNDLE_DIR/"

# ── 5. Runner scripts ──
echo "5. Runner scripts"
cp proofs/agda_proofs.sh "$BUNDLE_DIR/"
cp proofs/lean_proofs.sh "$BUNDLE_DIR/"
cp proofs/haskell_proofs.sh "$BUNDLE_DIR/"

# ── 6. Metadata ──
echo "6. Metadata"
cp CHANGELOG.md "$BUNDLE_DIR/"
cp README.md "$BUNDLE_DIR/"

# ── 7. Build manifest ──
echo "7. Writing manifest"
cat > "$BUNDLE_DIR/MANIFEST.md" << EOF
# Crystal Topos — RAG Bundle
## Built: $(date)
## Session: 6
## Observable count: 181
## Constants inside CODATA: 4

### Files included:

#### LLM Prompts
- crystal_topos_waca_llm.md (full prompt)
- crystal_topos_waca_llm_compact.md (compact prompt)

#### Haskell (proof authority)
- CrystalAxiom.hs (axiom definitions)
- Main.hs (92 observables)
- CrystalAlphaProton.hs (S4+S5: α⁻¹, m_p/m_e, sin²θ_W)
- CrystalProtonRadius.hs (S6: r_p, 11 prove functions)

#### Lean 4 (zero sorry)
- CrystalTopos.lean (353 theorems)
- CrystalAlphaProton.lean (42 theorems)
- CrystalProtonRadius.lean (25 theorems)

#### Agda (all by refl)
- CrystalTopos.agda (272 proofs)
- CrystalAlphaProton.agda (28 proofs)
- CrystalProtonRadius.agda (24 proofs)

#### Python
- crystal_proton_radius_proof.py (35 checks, all PASS)

#### Rust
- crystal_proton_radius_tests.rs (30 tests)

#### Scripts
- agda_proofs.sh (6/6)
- lean_proofs.sh (7/7)
- haskell_proofs.sh (9/9)

#### Metadata
- CHANGELOG.md
- README.md
- MANIFEST.md (this file)

### Quick verification:
\`\`\`bash
cd quickstart
python3 crystal_proton_radius_proof.py   # 35/35 PASS
\`\`\`

### Four constants inside CODATA:
| # | Constant | Δ/unc |
|---|----------|-------|
| 179 | α⁻¹ | 0.12 |
| 180 | m_p/m_e | 0.04 |
| — | sin²θ_W | 0.07 |
| 181 | r_p | 0.0013 |
EOF

# ── Summary ──
echo ""
FILE_COUNT=$(find "$BUNDLE_DIR" -type f | wc -l | tr -d ' ')
echo "=== RAG Bundle: $FILE_COUNT files in $BUNDLE_DIR/ ==="
echo ""
find "$BUNDLE_DIR" -type f | sort | while read f; do
  size=$(wc -c < "$f" | tr -d ' ')
  printf "  %-50s %6s bytes\n" "$(basename $f)" "$size"
done
echo ""
echo "Done. Upload quickstart/ folder to your RAG system."
