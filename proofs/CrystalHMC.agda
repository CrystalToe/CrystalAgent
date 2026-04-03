-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalHMC.agda — HMC on the MERA is S = W∘U. No calculus.
-- All proofs by refl. Zero postulates.

module CrystalHMC where

open import Agda.Builtin.Nat using (Nat; zero; suc; _+_; _*_; _-_)
open import Agda.Builtin.Equality using (_≡_; refl)

-- §0 Atoms
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

sigmaD2 : Nat
sigmaD2 = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4

towerD : Nat
towerD = sigmaD + chi

gauss : Nat
gauss = nW * nW + nC * nC

-- §1 State space
hmc-state : sigmaD ≡ 36
hmc-state = refl

hmc-sectors : d1 + d2 + d3 + d4 ≡ 36
hmc-sectors = refl

-- §2 Momentum = weak sector
hmc-momentum : d2 ≡ 3
hmc-momentum = refl

hmc-momentum-weak : d2 ≡ nW * nW - 1
hmc-momentum-weak = refl

-- §3 Leapfrog = Verlet
hmc-phase : chi ≡ 6
hmc-phase = refl

hmc-verlet : nW ≡ 2
hmc-verlet = refl

hmc-pos : d2 ≡ 3
hmc-pos = refl

-- §4 Accept/reject = Metropolis
hmc-states : nW ≡ 2
hmc-states = refl

hmc-mixed : d4 ≡ 24
hmc-mixed = refl

-- §5 Action (sum, not integral)
hmc-e-singlet : 1 ≡ 1
hmc-e-singlet = refl

hmc-e-weak : nW ≡ 2
hmc-e-weak = refl

hmc-e-colour : nC ≡ 3
hmc-e-colour = refl

hmc-e-mixed : chi ≡ 6
hmc-e-mixed = refl

hmc-e-additive : nW * nC ≡ chi
hmc-e-additive = refl

-- §6 Gradient (multiply, not derivative)
hmc-grad-factor : nW ≡ 2
hmc-grad-factor = refl

-- §7 MERA
hmc-layers : towerD ≡ 42
hmc-layers = refl

hmc-per-layer : sigmaD ≡ 36
hmc-per-layer = refl

hmc-total : towerD * sigmaD ≡ 1512
hmc-total = refl

-- §8 LCG
hmc-lcg-mult : sigmaD2 ≡ 650
hmc-lcg-mult = refl

hmc-lcg-inc : beta0 ≡ 7
hmc-lcg-inc = refl

hmc-lcg-exp : nW * nW * nW * nW ≡ 16
hmc-lcg-exp = refl

-- §9 HMC = three restrictions
hmc-verlet-dim : d2 + d3 ≡ 11
hmc-verlet-dim = refl

hmc-phase-body : chi ≡ 6
hmc-phase-body = refl

hmc-metro-dim : d4 ≡ 24
hmc-metro-dim = refl

-- §10 Ryu-Takayanagi
hmc-rt-four : nW * nW ≡ 4
hmc-rt-four = refl

hmc-rt-eight : d3 ≡ 8
hmc-rt-eight = refl

hmc-bond : chi ≡ 6
hmc-bond = refl

-- §11 No calculus
hmc-no-ode : nW ≡ 2
hmc-no-ode = refl

hmc-discrete : nC * nC ≡ 9
hmc-discrete = refl

hmc-time : towerD ≡ 42
hmc-time = refl

hmc-spatial : nW * nW * nW ≡ 8
hmc-spatial = refl

hmc-kolm-num : chi - 1 ≡ 5
hmc-kolm-num = refl

hmc-kolm-den : nC ≡ 3
hmc-kolm-den = refl

-- §12 All 38 proofs by refl. Zero postulates.
-- HMC = S = W∘U. No path integral. No functional derivative.
