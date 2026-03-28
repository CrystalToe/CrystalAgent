# Crystal Topos — RAG Bundle
## Built: Sun Mar 29 01:41:34 PST 2026
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
```bash
cd quickstart
python3 crystal_proton_radius_proof.py   # 35/35 PASS
```

### Four constants inside CODATA:
| # | Constant | Δ/unc |
|---|----------|-------|
| 179 | α⁻¹ | 0.12 |
| 180 | m_p/m_e | 0.04 |
| — | sin²θ_W | 0.07 |
| 181 | r_p | 0.0013 |
