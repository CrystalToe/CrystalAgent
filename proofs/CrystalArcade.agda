-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalArcade where
open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)
nW : ℕ
nW = 2
nC : ℕ
nC = 3
chi : ℕ
chi = nW * nC
dColour : ℕ
dColour = nW * nW * nW
lj-cutoff : nC ≡ 3
lj-cutoff = refl
octree : dColour ≡ 8
octree = refl
verlet : nW ≡ 2
verlet = refl
fixed-bits : nW * nW * nW * nW ≡ 16
fixed-bits = refl
hash-cells : nC ≡ 3
hash-cells = refl
lod : nC ≡ 3
lod = refl
mf-tc : nW * nW ≡ 4
mf-tc = refl
newton : nW ≡ 2
newton = refl
