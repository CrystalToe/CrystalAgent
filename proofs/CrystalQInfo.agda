-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later
module CrystalQInfo where
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
towerD : ℕ
towerD = sigmaD + chi
qubit : nW ≡ 2
qubit = refl
pauli : nC ≡ 3
pauli = refl
pauli-group : nW * nW ≡ 4
pauli-group = refl
bell-states : nW * nW ≡ 4
bell-states = refl
steane-n : 7 + 1 ≡ nW * nW * nW
steane-n = refl
steane-d : nC ≡ 3
steane-d = refl
shor-n : nC * nC ≡ 9
shor-n = refl
mera-bond : chi ≡ 6
mera-bond = refl
mera-depth : towerD ≡ 42
mera-depth = refl
teleport : nW ≡ 2
teleport = refl
uncertainty : nW * nC ≡ chi
uncertainty = refl
