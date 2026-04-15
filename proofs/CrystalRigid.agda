-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalRigid — Rigid body dynamics from (2,3)
-- Refactored: CrystalAtoms + CrystalSectors + CrystalEigen + CrystalOperators

module CrystalRigid where

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
d₁ : ℕ
d₁ = 1
d₂ : ℕ
d₂ = nW * nW ∸ 1
d₃ : ℕ
d₃ = nC * nC ∸ 1
d₄ : ℕ
d₄ = (nW * nW ∸ 1) * (nC * nC ∸ 1)
σD : ℕ
σD = d₁ + d₂ + d₃ + d₄
towerD : ℕ
towerD = σD + χ

-- §1 Rigid body structure
rot-axes : nC ≡ 3
rot-axes = refl

quat-comp : nW * nW ≡ 4
quat-comp = refl

inertia-tensor : χ ≡ 6
inertia-tensor = refl

rigid-dof : nC + nC ≡ 6
rigid-dof = refl

rot-mat : nC * nC ≡ 9
rot-mat = refl

euler-angles : nC ≡ 3
euler-angles = refl

-- §2 Moments of inertia (numerators/denominators)
sphere-num : nW ≡ 2
sphere-num = refl

sphere-den : χ ∸ 1 ≡ 5
sphere-den = refl

rod-den : 2 * χ ≡ 12
rod-den = refl

disk-den : nW ≡ 2
disk-den = refl

shell-num : nW ≡ 2
shell-num = refl

shell-den : nC ≡ 3
shell-den = refl

-- §3 Cross products and rotations
cross-dim : nC ≡ 3
cross-dim = refl

so3-generators : nC * (nC ∸ 1) ≡ 6
so3-generators = refl

-- §4 Crystal timestep
dt-denom : towerD ≡ 42
dt-denom = refl

-- §5 Flory = sphere MOI
flory-num : nW ≡ 2
flory-num = refl

flory-den : χ ∸ 1 ≡ 5
flory-den = refl

-- §6 Component wiring
comp-full : σD ≡ 36
comp-full = refl

comp-chi : χ ≡ 6
comp-chi = refl

comp-nw : nW ≡ 2
comp-nw = refl

-- Total: 20 proofs by refl. Zero postulates.
