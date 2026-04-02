-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalBio where
open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)
nW : ℕ
nW = 2
nC : ℕ
nC = 3
chi : ℕ
chi = nW * nC
bases : nW * nW ≡ 4
bases = refl
codon-len : nC ≡ 3
codon-len = refl
total-codons : 4 * 4 * 4 ≡ 64
total-codons = refl
amino-acids : nW * nW * 5 ≡ 20
amino-acids = refl
strands : nW ≡ 2
strands = refl
hbond-at : nW ≡ 2
hbond-at = refl
hbond-gc : nC ≡ 3
hbond-gc = refl
bp-turn : nW * 5 ≡ 10
bp-turn = refl
bilayer : nW ≡ 2
bilayer = refl
helix-num : nC * nC * nW ≡ 18
helix-num = refl
flory-num : nW ≡ 2
flory-num = refl
kleiber-cross : nC * 4 ≡ 3 * (nW * nW)
kleiber-cross = refl
surface-cross : nW * 3 ≡ 2 * nC
surface-cross = refl
