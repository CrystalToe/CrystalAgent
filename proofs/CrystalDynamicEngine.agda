-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalDynamicEngine.agda — Integer identities for the dynamics engine.
-- Tick loop, sector projections, HMC sampler, MERA layers.
-- All proofs by refl. Zero postulates.

module CrystalDynamicEngine where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

-- Atoms (from CrystalAtoms)
nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC

beta0 : ℕ
beta0 = 7

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

sigmaD2 : ℕ
sigmaD2 = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4

towerD : ℕ
towerD = sigmaD + chi

gauss : ℕ
gauss = nW * nW + nC * nC

-- ═══════════════════════════════════════════════════════════════
-- §1 STATE SPACE AND TICK
-- ═══════════════════════════════════════════════════════════════

-- State dimension
state-dim : sigmaD ≡ 36
state-dim = refl

-- Eigenvalue denominators: 1, 2, 3, 6
eigen-singlet : 1 ≡ 1
eigen-singlet = refl

eigen-weak : nW ≡ 2
eigen-weak = refl

eigen-colour : nC ≡ 3
eigen-colour = refl

eigen-mixed : chi ≡ 6
eigen-mixed = refl

-- Product of denominators = Σd
eigen-product : 1 * nW * nC * chi ≡ sigmaD
eigen-product = refl

-- ═══════════════════════════════════════════════════════════════
-- §2 SECTOR PROJECTIONS
-- ═══════════════════════════════════════════════════════════════

-- Classical mechanics: phase space = χ = 6 (3 pos + 3 vel)
classical-phase-space : chi ≡ 6
classical-phase-space = refl

-- Position DOF = d₂ = 3 (weak sector)
position-dof : d2 ≡ 3
position-dof = refl

-- Momentum DOF = first 3 of colour (d₃ = 8)
momentum-in-colour : d3 ≡ 8
momentum-in-colour = refl

-- Total classical DOF = weak + first-3-of-colour = 6 = χ
classical-dof : d2 + 3 ≡ chi
classical-dof = refl

-- Verlet integrator order = N_w = 2
verlet-order : nW ≡ 2
verlet-order = refl

-- EM: Yee FDTD courant number denominator = N_w = 2
yee-courant-den : nW ≡ 2
yee-courant-den = refl

-- EM field components = χ = 6 (3E + 3B)
em-field-components : chi ≡ 6
em-field-components = refl

-- EM lives in colour sector
em-sector-dim : d3 ≡ 8
em-sector-dim = refl

-- Thermal: Metropolis states per site = N_w = 2
metropolis-states : nW ≡ 2
metropolis-states = refl

-- Thermal lives in mixed sector
thermal-sector-dim : d4 ≡ 24
thermal-sector-dim = refl

-- LJ attractive exponent = χ = 6
lj-attractive : chi ≡ 6
lj-attractive = refl

-- LJ repulsive exponent = 2χ = 12
lj-repulsive : 2 * chi ≡ 12
lj-repulsive = refl

-- D2Q9 lattice velocities = N_c² = 9
d2q9-velocities : nC * nC ≡ 9
d2q9-velocities = refl

-- ═══════════════════════════════════════════════════════════════
-- §3 HMC PARAMETERS
-- ═══════════════════════════════════════════════════════════════

-- Momentum dimension = d_weak = 3
hmc-momentum-dim : d2 ≡ 3
hmc-momentum-dim = refl

-- HMC state space = full engine = Σd = 36
hmc-state-dim : sigmaD ≡ 36
hmc-state-dim = refl

-- LCG multiplier = Σd² = 650
lcg-multiplier : sigmaD2 ≡ 650
lcg-multiplier = refl

-- LCG increment = β₀ = 7
lcg-increment : beta0 ≡ 7
lcg-increment = refl

-- LCG modulus = 2^16 = 65536
lcg-modulus : 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 ≡ 65536
lcg-modulus = refl

-- Position + momentum DOF = weak ⊕ colour = 11
hmc-phase-space : d2 + d3 ≡ 11
hmc-phase-space = refl

-- ═══════════════════════════════════════════════════════════════
-- §4 MERA SAMPLING
-- ═══════════════════════════════════════════════════════════════

-- MERA layers = tower depth D = 42
mera-layers : towerD ≡ 42
mera-layers = refl

-- Tower = state space + internal dimension
tower-decomp : sigmaD + chi ≡ 42
tower-decomp = refl

-- Total MERA DOF = D × Σd = 42 × 36 = 1512
mera-total-dof : towerD * sigmaD ≡ 1512
mera-total-dof = refl

-- Entanglement entropy uses ln(χ), χ = 6
ent-entropy-base : chi ≡ 6
ent-entropy-base = refl

-- Ryu-Takayanagi: 4G denominator, 4 = N_w²
rt-four : nW * nW ≡ 4
rt-four = refl

-- ═══════════════════════════════════════════════════════════════
-- §5 ENERGY SPECTRUM
-- ═══════════════════════════════════════════════════════════════

-- E_mixed = E_weak + E_colour (denominators multiply: 2 × 3 = 6)
energy-additivity : nW * nC ≡ chi
energy-additivity = refl

-- Sector energy ordering: 1 < 2 < 3 < 6 (denominators of λ)
-- Stated as: each subsequent denominator is strictly larger
-- nW > 1, nC > nW, chi > nC
-- We verify the chain: 1 < 2 = nW
energy-order-1 : 1 + 1 ≡ nW
energy-order-1 = refl

-- ═══════════════════════════════════════════════════════════════
-- §6 ARROW OF TIME
-- ═══════════════════════════════════════════════════════════════

-- Lost DOF per tick = Σd − 1 = 35
lost-dof : sigmaD - 1 ≡ 35
lost-dof = refl

-- Entropy increase per tick: ΔS = ln(χ), χ = 6 > 1
irreversibility : chi ≡ 6
irreversibility = refl

-- χ > 1 guarantees arrow of time
-- Stated as: chi - 1 = 5 > 0
chi-gt-one : chi - 1 ≡ 5
chi-gt-one = refl

-- ═══════════════════════════════════════════════════════════════
-- §7 CROSS-CHECKS
-- ═══════════════════════════════════════════════════════════════

-- d₄ = d₂ × d₃ (mixed = weak ⊗ colour)
mixed-tensor : d2 * d3 ≡ d4
mixed-tensor = refl

-- Gauss integer
gauss-val : gauss ≡ 13
gauss-val = refl

-- Strong coupling denominator
alpha-s-den : gauss + nW * nW ≡ 17
alpha-s-den = refl

-- Sector boundaries (start indices)
boundary-0 : 0 ≡ 0
boundary-0 = refl

boundary-1 : d1 ≡ 1
boundary-1 = refl

boundary-2 : d1 + d2 ≡ 4
boundary-2 = refl

boundary-3 : d1 + d2 + d3 ≡ 12
boundary-3 = refl

boundary-end : d1 + d2 + d3 + d4 ≡ 36
boundary-end = refl
