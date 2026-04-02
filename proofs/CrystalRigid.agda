-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalRigid where
open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)
nW : ℕ
nW = 2
nC : ℕ
nC = 3
chi : ℕ
chi = nW * nC
-- Structure
rot-axes : nC ≡ 3
rot-axes = refl
quat-comp : nW * nW ≡ 4
quat-comp = refl
inertia-tensor : chi ≡ 6
inertia-tensor = refl
rigid-dof : nC + nC ≡ chi
rigid-dof = refl
rot-matrix : nC * nC ≡ 9
rot-matrix = refl
-- MOI cross-multiply: 2*(chi-1) = 5*N_w → 10 = 10
i-sphere : 2 * 5 ≡ nW * 5
i-sphere = refl
i-rod : 2 * chi ≡ 12
i-rod = refl
i-disk : nW ≡ 2
i-disk = refl
i-shell : 2 * nC ≡ 3 * nW
i-shell = refl
-- Cross-checks
quat-spacetime : nW * nW ≡ 4
quat-spacetime = refl
chi-lorentz : chi ≡ 6
chi-lorentz = refl
