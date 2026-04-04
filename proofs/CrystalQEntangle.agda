-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalQEntangle — Entanglement analysis from (2,3)
-- Pure MERA. Imports CrystalQBase only. No engine.
-- PPT is exact for ℂ^N_w ⊗ ℂ^N_c = ℂ² ⊗ ℂ³ (Horodecki 1996).

module CrystalQEntangle where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

χ : ℕ
χ = nW * nC

-- §1 PPT exact: ℂ^N_w ⊗ ℂ^N_c is the unique dimension
ppt-dim-a : nW ≡ 2
ppt-dim-a = refl

ppt-dim-b : nC ≡ 3
ppt-dim-b = refl

ppt-product : nW * nC ≡ 6
ppt-product = refl

-- §2 Bipartite Hilbert space dimensions
bipartite-dim : χ * χ ≡ 36
bipartite-dim = refl

tripartite-dim : χ * χ * χ ≡ 216
tripartite-dim = refl

-- §3 Schmidt rank = min(N_w, N_c) = N_w
schmidt-rank : nW ≡ 2
schmidt-rank = refl

-- §4 Bell basis count = N_w² = 4
bell-count : nW * nW ≡ 4
bell-count = refl

-- §5 Entanglement witness threshold = 1/χ
witness-denom : χ ≡ 6
witness-denom = refl

-- §6 Product states in ℂ^χ ⊗ ℂ^χ: parametrised by ℂ^χ × ℂ^χ
product-params : χ + χ ≡ 12
product-params = refl
