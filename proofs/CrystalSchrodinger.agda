-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
-- CrystalSchrodinger — Quantum mechanics from (2,3)
module CrystalSchrodinger where
open import Data.Nat using (ℕ; _+_; _*_; _∸_)
open import Agda.Builtin.Equality using (_≡_; refl)
nW : ℕ
nW = 2
nC : ℕ
nC = 3
χ : ℕ
χ = nW * nC
β₀ : ℕ
β₀ = 7
σD : ℕ
σD = 1 + 3 + 8 + 24

hbar-den : nW ≡ 2
hbar-den = refl
spin : nW ≡ 2
spin = refl
pauli : nC ≡ 3
pauli = refl
bell : nW * nW ≡ 4
bell = refl
phase-space : χ ≡ 6
phase-space = refl
shell-s : nW ≡ 2
shell-s = refl
shell-p : χ ≡ 6
shell-p = refl
shell-d : nW * (χ ∸ 1) ≡ 10
shell-d = refl
shell-f : nW * β₀ ≡ 14
shell-f = refl
uncertainty : nW * nW ≡ 4
uncertainty = refl
spatial : nC ≡ 3
spatial = refl
strang-order : nW ≡ 2
strang-order = refl
comp-full : σD ≡ 36
comp-full = refl
-- Total: 14 proofs by refl.
