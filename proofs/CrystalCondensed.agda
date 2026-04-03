-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalCondensed — Ising/BCS integer identities from (2,3)

module CrystalCondensed where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

-- S0: A_F atoms
nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC  -- 6

sigmaD : ℕ
sigmaD = 1 + 3 + 8 + 24  -- 36

towerD : ℕ
towerD = sigmaD + chi  -- 42

-- Atom sanity
nW-val : nW ≡ 2
nW-val = refl

nC-val : nC ≡ 3
nC-val = refl

chi-val : chi ≡ 6
chi-val = refl

towerD-val : towerD ≡ 42
towerD-val = refl

-- S1: Lattice coordination numbers
z-square : nW * nW ≡ 4
z-square = refl

z-cubic : chi ≡ 6
z-cubic = refl

-- S2: Ising states
ising-states : nW ≡ 2
ising-states = refl

-- S3: Critical exponent beta = 1/N_w^3 = 1/8
crit-beta-den : nW * nW * nW ≡ 8
crit-beta-den = refl

-- S4: Ground energy: z/2 = N_w (bonds per site, as multiplication)
bonds-per-site : nW * nW ≡ nW * 2
bonds-per-site = refl

-- S5: BCS prefactor
bcs-prefactor : nW ≡ 2
bcs-prefactor = refl

-- S6: Cross-checks
-- chi - z_square = N_w (as addition: N_w + z_square = chi)
z-diff : nW + nW * nW ≡ chi
z-diff = refl

nW-cubed : nW * nW * nW ≡ 8
nW-cubed = refl

z-square-val : nW * nW ≡ 4
z-square-val = refl

-- Engine wiring (no ∸, using - from Agda.Builtin.Nat)
engine-metropolis : nW ≡ 2
engine-metropolis = refl

engine-cubic : chi ≡ 6
engine-cubic = refl

engine-full : sigmaD ≡ 36
engine-full = refl
-- Engine wired.
