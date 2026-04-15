-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalGW where
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

quad-num : nW * nW * nW * nW * nW ≡ 32
quad-num = refl
quad-den : χ ∸ 1 ≡ 5
quad-den = refl
decay-num : nW * nW * nW * nW * nW * nW ≡ 64
decay-num = refl
polarizations : nC ∸ 1 ≡ 2
polarizations = refl
amplitude : nW * nW ≡ 4
amplitude = refl
gw-doubling : nW ≡ 2
gw-doubling = refl
isco : χ ≡ 6
isco = refl
chirp-num : nC ≡ 3
chirp-num = refl
chirp-den : χ ∸ 1 ≡ 5
chirp-den = refl
freq-num : nC ∸ 1 ≡ 2
freq-num = refl
freq-den : nC ≡ 3
freq-den = refl
colour-dim : d₃ ≡ 8
colour-dim = refl
-- Total: 12 proofs by refl.

-- §5a Ringdown / QNM
qnm-freq : nC ≡ 3
qnm-freq = refl
qnm-damping-num : nC ≡ 3
qnm-damping-num = refl
qnm-damping-den : nC ∸ 1 ≡ 2
qnm-damping-den = refl
qnm-shadow : nC * nC * nC ≡ 27
qnm-shadow = refl
ringdown-decay : nW * nC ≡ 6
ringdown-decay = refl
