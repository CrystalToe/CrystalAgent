-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalFold where
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
d₃ : ℕ
d₃ = nC * nC ∸ 1
d₄ : ℕ
d₄ = (nW * nW ∸ 1) * (nC * nC ∸ 1)

tile-dof : σD ≡ 36
tile-dof = refl
mixed-is-4chi : d₄ ≡ 4 * χ
mixed-is-4chi = refl
helix-num : nC * nC * nW ≡ 18
helix-num = refl
helix-den : χ ∸ 1 ≡ 5
helix-den = refl
flory-num : nW ≡ 2
flory-num = refl
flory-den : χ ∸ 1 ≡ 5
flory-den = refl
amino-acids : nW * nW * (χ ∸ 1) ≡ 20
amino-acids = refl
contact-cutoff : d₃ ≡ 8
contact-cutoff = refl
residues-per-tile : nW * nW ≡ 4
residues-per-tile = refl
dof-per-residue : nC * nC ≡ 9
dof-per-residue = refl
-- Total: 10 proofs by refl.
