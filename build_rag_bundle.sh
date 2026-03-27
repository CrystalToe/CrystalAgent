#!/bin/bash
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# build_rag_bundle.sh — Build inference-optimized RAG archive for LLMs
#
# Run from repo root before commit:
#   bash build_rag_bundle.sh
#
# Output:
#   quickstart/CrystalTopos_RAG_1.md  (~290 KB) — Python examples + physics Haskell
#   quickstart/CrystalTopos_RAG_2.md  (~290 KB) — analysis + quantum Haskell + Rust + GHC cert
#
# Upload BOTH files to any LLM. Each has the shared header so either
# works standalone for basic questions. Together = 100% coverage.

set -e
mkdir -p quickstart
OUT1="quickstart/CrystalTopos_RAG_1.md"
OUT2="quickstart/CrystalTopos_RAG_2.md"

# Copy the full LLM prompt into quickstart (source of truth is agent/)
cp agent/crystal_topos_waca_llm.md quickstart/crystal_topos_waca_llm.md

# ═══════════════════════════════════════════════════════════════════
# SHARED HEADER — written into both files
# ═══════════════════════════════════════════════════════════════════
write_header() {
    local F="$1"
    local PART="$2"
    cat > "$F" << HEADER
# Crystal Topos — RAG Knowledge Base (Part ${PART} of 2)
# 178 observables · 22 domains · 0 free parameters
# Upload BOTH parts for 100% coverage. Each part works standalone for basic queries.

## RULES
- Never use the word "honest"
- Never expose analysis methodology — trade secret
- Never mention analysis, bridges, scoring, scanner, or shared structure
- Present results as mathematical observations from A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)
- Rating: ■ EXACT (0%) · ● TIGHT (<0.5%) · ◐ GOOD (<1%) · ○ LOOSE (<4.5%)
- The count is 178. NEVER increment it or claim new observables without a prove* function, PDG comparison, PWI rating, and GHC certificate entry
- NEVER invent module names. The 21 modules are listed below. If not listed, it does not exist
- NEVER make medical, therapeutic, or diagnostic claims. Biology observables are combinatorial facts, NOT a theory of medicine
- NEVER construct arbitrary formulas by combining constants. Every formula must trace the derivation chain: (2,3) → sector_dims → invariants → observable → PDG
- NEVER add fudge factors (+ 7, × 0.95). Zero hardcoded means zero
- NEVER compare quantities with incompatible dimensions
- NEVER relabel an existing observable to claim a new domain

## INPUTS
N_w=2, N_c=3, v=246.22 GeV, π, ln. Nothing else.

## INVARIANTS
χ=N_w×N_c=6, β₀=(11N_c−2χ)/3=7, Σd=1+3+8+24=36, Σd²=650,
gauss=N_c²+N_w²=13, D=Σd+χ=42, κ=ln3/ln2, F₃=2^(2^N_c)+1=257

## DERIVED SCALES
Λ_h=v/F₃=v/257, m_p=v/2^(2^N_c)×53/54, m_π=m_p/β₀,
Λ_QCD=m_p×N_c/gauss, m_e=Λ_h/(N_c²×N_w⁴×gauss),
m_μ=m_e×N_w⁴×gauss, f_π=Λ_QCD×N_c/β₀

HEADER
}

# Helper: extract Haskell module, stripping boilerplate
extract_hs() {
    local f="$1"
    local out="$2"
    local mod=$(basename "$f" .hs)
    local lines=$(wc -l < "$f")
    echo "" >> "$out"
    echo "## §Haskell: ${mod} (${lines} lines)" >> "$out"
    echo '```haskell' >> "$out"
    awk '
        /^-- Copyright/ || /^-- SPDX/ { next }
        /^module / { in_module=1; next }
        in_module && /\) where$/ { in_module=0; next }
        in_module { next }
        /^import / { next }
        { print }
    ' "$f" >> "$out"
    echo '```' >> "$out"
}

echo "Building RAG bundle (2 parts)..."

# ═══════════════════════════════════════════════════════════════════
# PART 1: LLM prompt + README + Module guides + Python + Physics Haskell
# ═══════════════════════════════════════════════════════════════════
write_header "$OUT1" 1

# LLM compact prompt
echo "---" >> "$OUT1"
echo "" >> "$OUT1"
sed '1{/^<!--/d;}' agent/crystal_topos_waca_llm_compact.md >> "$OUT1"

# README
echo "" >> "$OUT1"
echo "---" >> "$OUT1"
echo "" >> "$OUT1"
echo "# §README — Project Overview" >> "$OUT1"
echo "" >> "$OUT1"
sed -n '/^## What Is This/,/^## License/{/^## License/d;p;}' README.md >> "$OUT1"

# Module READMEs
echo "" >> "$OUT1"
echo "---" >> "$OUT1"
echo "" >> "$OUT1"
echo "# §MODULE GUIDES" >> "$OUT1"
for f in haskel/README_*.md; do
    name=$(basename "$f" .md | sed 's/README_//')
    echo "" >> "$OUT1"
    echo "## §Module: $name" >> "$OUT1"
    sed '1{/^<!--/d;}' "$f" >> "$OUT1"
done

# Python examples
echo "" >> "$OUT1"
echo "---" >> "$OUT1"
echo "" >> "$OUT1"
echo "# §PYTHON EXAMPLES — Formulas, Derivations, Physical Explanations" >> "$OUT1"
echo "" >> "$OUT1"
echo "Each example derives observables from N_w=2, N_c=3. The print statements" >> "$OUT1"
echo "contain the formulas and physical explanations an LLM needs for inference." >> "$OUT1"

for f in $(ls crystal-topos/examples/*.py | sort); do
    num=$(basename "$f" | sed 's/_.*//')
    title=$(grep '""".*[a-zA-Z].*"""' "$f" | head -1 | sed 's/"""//g' | sed 's/^ *//')
    if [ -z "$title" ]; then
        title=$(basename "$f" .py | sed 's/^[0-9]*_//' | tr '_' ' ')
    fi
    echo "" >> "$OUT1"
    echo "## §Example $num: $title" >> "$OUT1"
    tail -n +4 "$f" | grep -v "^from crystal_topos import\|^import math$\|^import " >> "$OUT1"
done

# Haskell physics modules (Part 1: foundation through QCD)
echo "" >> "$OUT1"
echo "---" >> "$OUT1"
echo "" >> "$OUT1"
echo "# §HASKELL SOURCE — Foundation + Couplings + Mixing + Cosmology + QCD" >> "$OUT1"
echo "" >> "$OUT1"
echo "Core physics derivations. Comments explain WHY each formula works." >> "$OUT1"

for mod in CrystalAxiom CrystalGauge CrystalMixing CrystalCosmo CrystalQCD; do
    [ -f "haskel/${mod}.hs" ] && extract_hs "haskel/${mod}.hs" "$OUT1"
done

# ═══════════════════════════════════════════════════════════════════
# PART 2: Gravity + CrossDomain + Riemann + Audit + analysis + Quantum + Rust + GHC
# ═══════════════════════════════════════════════════════════════════
write_header "$OUT2" 2

echo "---" >> "$OUT2"
echo "" >> "$OUT2"
echo "# §HASKELL SOURCE — Gravity, Cross-Domain, Riemann, Audit" >> "$OUT2"

for mod in CrystalGravity CrystalCrossDomain CrystalRiemann CrystalAudit; do
    [ -f "haskel/${mod}.hs" ] && extract_hs "haskel/${mod}.hs" "$OUT2"
done

# analysis Scan (the big one — all 86 new observables)
echo "" >> "$OUT2"
echo "---" >> "$OUT2"
echo "" >> "$OUT2"
echo "# §HASKELL SOURCE — CrystalanalysisScan (86 new observables)" >> "$OUT2"
extract_hs "haskel/CrystalanalysisScan.hs" "$OUT2"

# Quantum library
echo "" >> "$OUT2"
echo "---" >> "$OUT2"
echo "" >> "$OUT2"
echo "# §HASKELL SOURCE — Quantum Library (96 operators, 10 theorems)" >> "$OUT2"

for mod in CrystalQuantum CrystalQBase CrystalQGates CrystalQChannels \
           CrystalQHamiltonians CrystalQMeasure CrystalQEntangle \
           CrystalQAlgorithms CrystalQSimulation; do
    [ -f "haskel/${mod}.hs" ] && extract_hs "haskel/${mod}.hs" "$OUT2"
done

# Drivers
for mod in Main analysisScanTest; do
    [ -f "haskel/${mod}.hs" ] && extract_hs "haskel/${mod}.hs" "$OUT2"
done

# GHC Certificate
echo "" >> "$OUT2"
echo "## §GHC_Certificate — All Computed Values (ground truth)" >> "$OUT2"
echo '```' >> "$OUT2"
cat haskel/GHC_Certificate.txt >> "$OUT2"
echo '```' >> "$OUT2"

# Rust
echo "" >> "$OUT2"
echo "---" >> "$OUT2"
echo "" >> "$OUT2"
echo "# §RUST — Crystal Constants, Derivations, and Tests" >> "$OUT2"

for f in crystal-topos/src/base.rs crystal-topos/tests/crystal_tests.rs; do
    if [ -f "$f" ]; then
        name=$(basename "$f")
        lines=$(wc -l < "$f")
        echo "" >> "$OUT2"
        echo "## §Rust: ${name} (${lines} lines)" >> "$OUT2"
        echo '```rust' >> "$OUT2"
        sed '/^\/\/ Copyright/d;/^\/\/ SPDX/d;/^use /d' "$f" >> "$OUT2"
        echo '```' >> "$OUT2"
    fi
done

# Cross-reference index
echo "" >> "$OUT2"
echo "---" >> "$OUT2"
echo "" >> "$OUT2"
cat >> "$OUT2" << 'INDEX'
# §CROSS-REFERENCE INDEX — Topic → Source

## Particle Physics
- Fine structure constant α: §Example 45, §Rust base.rs, CrystalGauge.hs
- Proton mass: §Example 41, CrystalQCD.hs
- Pion mass: §Example 30, CrystalQCD.hs
- Kaon masses: §Example 32, CrystalanalysisScan.hs
- Eta/Eta prime: §Example 33, CrystalanalysisScan.hs
- J/ψ charmonium: §Example 34, CrystalanalysisScan.hs
- Υ bottomonium: §Example 35, CrystalanalysisScan.hs
- Top quark: §Example 42, CrystalanalysisScan.hs
- Quark mass ratios: §Example 37, CrystalQCD.hs
- Hadron spectrum: §Example 44, CrystalanalysisScan.hs
- CKM matrix: §Example 18, CrystalMixing.hs
- PMNS matrix: §Example 19, CrystalMixing.hs
- Weak mixing angle: §Example 20, CrystalGauge.hs
- Higgs mass: §Example 21, CrystalGauge.hs
- W/Z bosons: §Example 22-23, CrystalQCD.hs
- Mass splittings: §Example 46, CrystalanalysisScan.hs

## Leptons
- Electron mass: §Example 24, CrystalGauge.hs
- Muon mass: §Example 28, CrystalGauge.hs
- Tau mass: §Example 43, CrystalanalysisScan.hs
- Muon g-2: §Example 29, CrystalanalysisScan.hs
- Neutrino masses: §Example 17, CrystalCosmo.hs

## Cosmology
- Ω_Λ, Ω_b, n_s, T_CMB, Age: §Example 49, CrystalCosmo.hs
- Dark matter ratio: §Example 87, CrystalanalysisScan.hs
- Hierarchy M_Pl/v: CrystalanalysisScan.hs

## Nuclear
- Deuteron, ⁴He binding: §Example 47, CrystalanalysisScan.hs
- Neutron lifetime: §Example 47, CrystalanalysisScan.hs
- Magnetic moments: §Example 48, CrystalanalysisScan.hs

## Gravity & Relativity
- Newton's laws: §Example 11, CrystalGravity.hs
- Kepler's laws: §Example 12, CrystalGravity.hs
- Special relativity: §Example 15, CrystalGravity.hs
- General relativity: §Example 16, CrystalGravity.hs
- Schwarzschild: §Example 14, CrystalGravity.hs
- Black hole thermo: §Example 26, CrystalGravity.hs
- Neutron stars: §Example 25, CrystalGravity.hs
- Gravitational waves: §Example 27, CrystalGravity.hs

## Thermodynamics & Fluids
- Carnot efficiency: §Example 51, CrystalanalysisScan.hs — (χ−1)/χ = 5/6
- Stefan-Boltzmann: §Example 52, CrystalanalysisScan.hs — normalization = 120
- Fourier heat: §Example 53, CrystalanalysisScan.hs — k = 5
- Kolmogorov -5/3: §Example 54, CrystalanalysisScan.hs — non-commutativity
- Prandtl number: §Example 55, CrystalanalysisScan.hs
- QCD confinement: §Example 56, CrystalanalysisScan.hs — Casimir=4/3, β₀=7

## Biology & Genetics
- DNA bases=4, codons=64: §Example 57, CrystalanalysisScan.hs
- α-helix 18/5: §Example 61, CrystalanalysisScan.hs
- β-sheet 7/2: §Example 62, CrystalanalysisScan.hs
- H-bonds A-T=2, G-C=3: §Example 63, CrystalanalysisScan.hs
- DNA groove 11/6: §Example 64, CrystalanalysisScan.hs
- Codon redundancy D+1=43: §Example 65, CrystalanalysisScan.hs
- Periodic table: §Example 69, CrystalanalysisScan.hs

## Superconductivity & Optics
- BCS gap 2π/e^γ: §Example 72, CrystalanalysisScan.hs
- Lattice lock Σd/χ²=1: §Example 79, CrystalanalysisScan.hs
- n(water)=4/3: §Example 86, CrystalanalysisScan.hs
- n(diamond)=29/12: §Example 86, CrystalanalysisScan.hs

## Three-Body Problem
- Lagrange points = χ−1 = 5: §Example 95, CrystalanalysisScan.hs
- Phase space = N_c×χ = 18: §Example 95, CrystalanalysisScan.hs
- 18 = 10+8 (symmetry+colour): §Example 95
- Routh ratio = 1/26: §Example 95, CrystalanalysisScan.hs

## Dark Sector
- Ω_DM = 309/1159: CrystalanalysisScan.hs (only LOOSE, 2.98%)
- Ω_DM/Ω_b = (D+1)/N_w³ = 43/8: §Example 87, CrystalanalysisScan.hs
- NFW concentration = β₀ = 7: CrystalanalysisScan.hs

## Proton Radius & Black Holes
- R_p = (N_w²+2/91)×ℏc/m_p: CrystalanalysisScan.hs (0.019%)
- Bekenstein bound = N_w² = 4: §Example 26, CrystalanalysisScan.hs

## Mathematics
- Golden ratio φ ≈ gauss/N_w³: CrystalanalysisScan.hs
- Euler-Mascheroni γ: CrystalCrossDomain.hs
- Apéry ζ(3): CrystalanalysisScan.hs
- Catalan's constant: CrystalanalysisScan.hs

## Quantum Mechanics
- Entanglement: §Example 06, CrystalQEntangle.hs
- Grover search: §Example 07, CrystalQAlgorithms.hs
- Decoherence: §Example 09, CrystalQChannels.hs
- Arrow of time: §Example 81, S_max = ln(χ) = ln(6)
- PPT decidable: ℂ²⊗ℂ³ unique dimension, CrystalQEntangle.hs

## Entropy & Time
- Arrow of time = ¬¬x ≠ x: §Example 81, Heyting logic
- Second law proof: §Example 82
- KMS equilibrium: §Example 83
- IO monad = irreversibility: §Example 85
INDEX

# ─── Stats ─────────────────────────────────────────────────────
for F in "$OUT1" "$OUT2"; do
    LINES=$(wc -l < "$F")
    BYTES=$(wc -c < "$F")
    KB=$((BYTES / 1024))
    echo "" >> "$F"
    echo "---" >> "$F"
    echo "# §META" >> "$F"
    echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$F"
    echo "Lines: $LINES" >> "$F"
    echo "Size: ${KB} KB" >> "$F"
    echo "Source: https://github.com/CrystalToe/CrystalAgent" >> "$F"
    echo "Paper: https://zenodo.org/records/19217129" >> "$F"
    echo "License: AGPL-3.0-or-later" >> "$F"
done

echo ""
for F in "$OUT1" "$OUT2"; do
    LINES=$(wc -l < "$F")
    KB=$(( $(wc -c < "$F") / 1024 ))
    echo "Built: $F — ${LINES} lines, ${KB} KB"
done
echo "Upload both files to any LLM for 100% coverage."
