-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

module ObservableOptics where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

gauss : ℕ
gauss = nC * nC + nW * nW

-- n(water) = C_F = 4/3: (N_c^2-1)/(2*N_c)
-- cross: 4 * 2 * N_c = 3 * (N_c^2 - 1) → 24 = 24
water-numer : nC * nC - 1 ≡ 8
water-numer = refl

water-denom : 2 * nC ≡ 6
water-denom = refl

water-cross : (nC * nC - 1) * 3 ≡ 2 * nC * 4
water-cross = refl

-- n(glass) = N_c/N_w = 3/2
glass-cross : nC * 2 ≡ nW * 3
glass-cross = refl

-- n(diamond) = 29/12: (2*gauss+N_c)/(N_w^2*N_c)
diamond-numer : 2 * gauss + nC ≡ 29
diamond-numer = refl

diamond-denom : nW * nW * nC ≡ 12
diamond-denom = refl
