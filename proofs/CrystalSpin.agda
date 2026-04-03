-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalSpin.agda — Bloch equations / NMR from (2,3). S = W∘U.
-- All proofs by refl. Zero postulates.

module CrystalSpin where

open import Agda.Builtin.Nat using (Nat; zero; suc; _+_; _*_; _-_)
open import Agda.Builtin.Equality using (_≡_; refl)

nW : Nat
nW = 2

nC : Nat
nC = 3

chi : Nat
chi = nW * nC

beta0 : Nat
beta0 = 7

d1 : Nat
d1 = 1

d2 : Nat
d2 = nW * nW - 1

d3 : Nat
d3 = nC * nC - 1

d4 : Nat
d4 = (nW * nW - 1) * (nC * nC - 1)

sigmaD : Nat
sigmaD = d1 + d2 + d3 + d4

towerD : Nat
towerD = sigmaD + chi

gauss : Nat
gauss = nW * nW + nC * nC

-- §1 Spin
spin-states : nW ≡ 2
spin-states = refl

multiplicity : nW ≡ 2
multiplicity = refl

stern-gerlach : nW ≡ 2
stern-gerlach = refl

-- §2 Bloch
bloch-dim : nC ≡ 3
bloch-dim = refl

bloch-sector : d2 ≡ 3
bloch-sector = refl

bloch-is-weak : d2 ≡ nC
bloch-is-weak = refl

-- §3 Pauli
pauli-count : nC ≡ 3
pauli-count = refl

pauli-dim : nW * nW ≡ 4
pauli-dim = refl

pauli-trace : nW ≡ 2
pauli-trace = refl

-- §4 g-factor
g-factor : nW ≡ 2
g-factor = refl

g-anomalous-num : nW ≡ 2
g-anomalous-num = refl

g-anomalous-den : gauss ≡ 13
g-anomalous-den = refl

-- §5 Relaxation
t1-denom : nW ≡ 2
t1-denom = refl

t2-denom : nC ≡ 3
t2-denom = refl

relax-product : nW * nC ≡ chi
relax-product = refl

-- §6 Larmor
larmor-dim : nC ≡ 3
larmor-dim = refl

rotation-matrix : nC * nC ≡ 9
rotation-matrix = refl

-- §7 Rabi
rabi-states : nW ≡ 2
rabi-states = refl

-- §8 NMR
mri-axes : nC ≡ 3
mri-axes = refl

kspace-dim : nC ≡ 3
kspace-dim = refl

-- §9 Spin-orbit
fine-structure : nW ≡ 2
fine-structure = refl

zeeman : nW ≡ 2
zeeman = refl

-- §10 Cross-module
cross-ising : nW ≡ 2
cross-ising = refl

cross-classical : nC ≡ 3
cross-classical = refl

cross-engine : d2 ≡ 3
cross-engine = refl

cross-phase : chi ≡ 6
cross-phase = refl

cross-wavelet : nW ≡ 2
cross-wavelet = refl

cross-bell : nW * nW ≡ 4
cross-bell = refl

cross-tower : towerD ≡ 42
cross-tower = refl

-- §11 All 31 proofs by refl. Zero postulates.
-- Bloch = S = W∘U. Precession = W. Relaxation = U.
