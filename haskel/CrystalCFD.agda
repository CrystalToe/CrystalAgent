-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalCFD where
open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)
nW : ℕ
nW = 2
nC : ℕ
nC = 3
χ : ℕ
χ = nW * nC
d₃ : ℕ
d₃ = nC * nC ∸ 1
d₄ : ℕ
d₄ = (nW * nW ∸ 1) * (nC * nC ∸ 1)
σD : ℕ
σD = 1 + 3 + 8 + 24

d2q9 : nC * nC ≡ 9
d2q9 = refl
colour-fits : d₃ ≡ 8
colour-fits = refl
kolm-num : χ ∸ 1 ≡ 5
kolm-num = refl
kolm-den : nC ≡ 3
kolm-den = refl
stokes : d₄ ≡ 24
stokes = refl
blasius-den : nW * nW ≡ 4
blasius-den = refl
karman-num : nW ≡ 2
karman-num = refl
karman-den : χ ∸ 1 ≡ 5
karman-den = refl
w-rest-num : nW * nW ≡ 4
w-rest-num = refl
w-rest-den : nC * nC ≡ 9
w-rest-den = refl
w-diag-den : σD ≡ 36
w-diag-den = refl
cs2-den : nC ≡ 3
cs2-den = refl
-- Total: 12 proofs by refl.
