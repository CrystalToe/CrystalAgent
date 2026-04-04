-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalEigen.agda — Component 4: Eigenvalue identities.
-- All proofs by refl. Zero postulates.

module CrystalEigen where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC

sigmaD : ℕ
sigmaD = 36

-- Eigenvalue denominators
denom-singlet : 1 ≡ 1
denom-singlet = refl

denom-weak : nW ≡ 2
denom-weak = refl

denom-colour : nC ≡ 3
denom-colour = refl

denom-mixed : chi ≡ 6
denom-mixed = refl

-- Product of denominators = Sigma_d
denom-product : 1 * nW * nC * chi ≡ sigmaD
denom-product = refl

-- Sum of reciprocals (cross-multiplied): 6+3+2+1 = 12
recip-sum : chi + nC + nW + 1 ≡ 12
recip-sum = refl

-- Mixed = weak x colour (denominators multiply)
mixed-product : nW * nC ≡ chi
mixed-product = refl

-- W o U factorisation: denom(S) = denom(W) x denom(U)
-- For symmetric split: denom(W) = denom(U) = sqrt(denom(S))
-- Integer check: denom_k^2 = denom_k x denom_k
factor-singlet : 1 * 1 ≡ 1
factor-singlet = refl

factor-weak : nW ≡ nW
factor-weak = refl

factor-colour : nC ≡ nC
factor-colour = refl

factor-mixed : chi ≡ nW * nC
factor-mixed = refl

-- Energy ordering (denominators increase: 1 < 2 < 3 < 6)
order-1-2 : 1 + 1 ≡ nW
order-1-2 = refl

order-2-3 : nW + 1 ≡ nC
order-2-3 = refl

order-3-6 : nC + nC ≡ chi
order-3-6 = refl
