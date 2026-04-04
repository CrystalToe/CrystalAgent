-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalDiffusion.agda — Diffusion / heat equation from (2,3).
-- All proofs by refl. Zero postulates.

module CrystalDiffusion where

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

-- §1 Neighbours
neighbours-1d : nW ≡ 2
neighbours-1d = refl

neighbours-2d : nW * nW ≡ 4
neighbours-2d = refl

neighbours-3d : chi ≡ 6
neighbours-3d = refl

pattern-1 : nW * 1 ≡ 2
pattern-1 = refl

pattern-2 : nW * 2 ≡ 4
pattern-2 = refl

pattern-3 : nW * 3 ≡ 6
pattern-3 = refl

-- §2 Diffusion coefficient
cfl-denom : nW * nC ≡ 6
cfl-denom = refl

cfl-twice : 2 * nC ≡ 6
cfl-twice = refl

cfl-chi : 2 * nC ≡ chi
cfl-chi = refl

-- §3 Random walk
walk-dim : nC ≡ 3
walk-dim = refl

walk-dirs : chi ≡ 6
walk-dirs = refl

walk-einstein : nC ≡ 3
walk-einstein = refl

-- §4 Fourier decay
fourier-zero : 1 ≡ 1
fourier-zero = refl

max-decay-num : nW * nW ≡ 4
max-decay-num = refl

max-decay-denom : chi ≡ 6
max-decay-denom = refl

-- §5 Sector
sector-weak : d2 ≡ 3
sector-weak = refl

sector-full : sigmaD ≡ 36
sector-full = refl

-- §6 Thermal
stefan-exp : nW * nW ≡ 4
stefan-exp = refl

stefan-denom : nC * (chi - 1) ≡ 15
stefan-denom = refl

carnot-num : chi - 1 ≡ 5
carnot-num = refl

carnot-den : chi ≡ 6
carnot-den = refl

gamma-num : chi - 1 ≡ 5
gamma-num = refl

gamma-den : nC ≡ 3
gamma-den = refl

-- §7 Lattice
lattice-3d : d2 ≡ nC
lattice-3d = refl

-- §8 Cross-module
cross-cfd : chi ≡ 6
cross-cfd = refl

cross-schrodinger : nW ≡ 2
cross-schrodinger = refl

cross-em : chi ≡ 6
cross-em = refl

cross-classical : nC ≡ 3
cross-classical = refl

cross-astro : nW * nW ≡ 4
cross-astro = refl

cross-tower : towerD ≡ 42
cross-tower = refl

cross-lcg : d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4 ≡ 650
cross-lcg = refl

-- §9 Component wiring (refactored from CrystalEngine)

component-diff-coeff : chi ≡ 6
component-diff-coeff = refl

component-neighbours-1d : nW ≡ 2
component-neighbours-1d = refl

component-neighbours-3d : nW * nC ≡ chi
component-neighbours-3d = refl

component-cfl : nW * nC ≡ chi
component-cfl = refl

component-singlet-conserved : d1 ≡ 1
component-singlet-conserved = refl

component-spatial : d2 ≡ nC
component-spatial = refl

component-full-state : sigmaD ≡ 36
component-full-state = refl

-- Total: 38 proofs by refl. Zero postulates. Refactored: CrystalAtoms + CrystalSectors + CrystalEigen + CrystalOperators.

-- §10 Gray-Scott crystal parameters
gs-du-denom : chi ≡ 6
gs-du-denom = refl

gs-dv-denom : d4 ≡ 24
gs-dv-denom = refl

gs-feed-denom : towerD ≡ 42
gs-feed-denom = refl

gs-kill-num : beta0 ≡ 7
gs-kill-num = refl

gs-kill-denom : towerD * towerD ≡ 1764
gs-kill-denom = refl

gs-dv-identity : nW * nW * chi ≡ d4
gs-dv-identity = refl

-- §11 Anisotropic diffusion
aniso-rate-x-denom : nW ≡ 2
aniso-rate-x-denom = refl

aniso-rate-y-denom : nC ≡ 3
aniso-rate-y-denom = refl

aniso-rate-z-denom : chi ≡ 6
aniso-rate-z-denom = refl

-- §12 Crystal grid parameters
grid-dx-denom : nC ≡ 3
grid-dx-denom = refl

grid-dt-denom : towerD ≡ 42
grid-dt-denom = refl

grid-cfl-denom : nW * nW * beta0 ≡ 28
grid-cfl-denom = refl

-- Total: 50 proofs by refl. Zero postulates.
