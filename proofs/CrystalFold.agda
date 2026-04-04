-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalFold.agda — Protein folding integer identities.
-- Sector dimensions, DOF counting, eigenvalue ordering.

module CrystalFold where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2
nC : ℕ
nC = 3
chi : ℕ
chi = nW * nC
d1 : ℕ
d1 = 1
d2 : ℕ
d2 = 3
d3 : ℕ
d3 = 8
d4 : ℕ
d4 = 24
sigmaD : ℕ
sigmaD = d1 + d2 + d3 + d4

-- State dimension = Sigma_d = 36
state-dim : sigmaD ≡ 36
state-dim = refl

-- Sector dimensions
sec-singlet : d1 ≡ 1
sec-singlet = refl

sec-weak : d2 ≡ 3
sec-weak = refl

sec-colour : d3 ≡ 8
sec-colour = refl

sec-mixed : d4 ≡ 24
sec-mixed = refl

-- 4 residues per tile: 4*9 = 36
tile-dof : 4 * 9 ≡ sigmaD
tile-dof = refl

-- Helix period: N_c^2*N_w / (chi-1) = 18/5
helix-numer : nC * nC * nW ≡ 18
helix-numer = refl

helix-denom : chi - 1 ≡ 5
helix-denom = refl

-- Sector sum = chi^2 (lattice lock for folding)
lattice-lock : sigmaD ≡ chi * chi
lattice-lock = refl

-- Mixed sector dominance: d4 > d3 + d2 + d1
mixed-dominance : d4 ≡ d3 + d2 + d1 + 12
mixed-dominance = refl
