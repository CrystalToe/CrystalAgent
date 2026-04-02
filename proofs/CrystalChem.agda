-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalChem where
open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)
nW : ℕ
nW = 2
nC : ℕ
nC = 3
chi : ℕ
chi = nW * nC
sigmaD : ℕ
sigmaD = 1 + 3 + 8 + 24
-- Orbital capacities
s-cap : nW ≡ 2
s-cap = refl
p-cap : nW * nC ≡ 6
p-cap = refl
d-cap : nW * 5 ≡ 10
d-cap = refl
f-cap : nW * 7 ≡ 14
f-cap = refl
shell1 : nW ≡ 2
shell1 = refl
shell2 : nW * 4 ≡ 8
shell2 = refl
shell3 : nW * 9 ≡ 18
shell3 = refl
-- Noble gases
he-z : nW ≡ 2
he-z = refl
ne-z : nW * 5 ≡ 10
ne-z = refl
ar-z : nW * (nC * nC) ≡ 18
ar-z = refl
kr-z : sigmaD ≡ 36
kr-z = refl
-- Chemistry
dielectric : nW * nW * (nC + 1) ≡ 16
dielectric = refl
dcolour-shell : nW * nW * nW ≡ 8
dcolour-shell = refl
