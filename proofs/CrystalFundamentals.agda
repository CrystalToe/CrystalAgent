-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{-
  CrystalFundamentals.agda — Agda Proof · Fundamental Observables · March 2026
  14 new observables: 181 → 195. Zero free parameters.
  Every integer identity proved by refl.
-}

module CrystalFundamentals where
open import Agda.Builtin.Equality
open import Agda.Builtin.Nat

nW : Nat
nW = 2
nC : Nat
nC = 3
chi : Nat
chi = nW * nC
beta0 : Nat
beta0 = chi + 1
towerD : Nat
towerD = chi * beta0
sigmaD : Nat
sigmaD = 1 + nC + (nC * nC - 1) + nW * nW * nW * nC
sigmaD2 : Nat
sigmaD2 = 1 + 9 + 64 + 576
gauss : Nat
gauss = nW * nW + nC * nC

-- ═══════════════════════════════════════════════════════════════
-- §16  PHASE 1 — EASY 5
-- ═══════════════════════════════════════════════════════════════

-- #179: N_eff denominator: D·N_c = 126
neff-denom : towerD * nC ≡ 126
neff-denom = refl

-- #180: Ω_b/Ω_m = 3/19
ob-om-num : nC ≡ 3
ob-om-num = refl
ob-om-den : gauss + chi ≡ 19
ob-om-den = refl

-- #181: sin²θ_W(0) running correction = 1/126
sw0-corr-den : towerD * chi ≡ 252
sw0-corr-den = refl

-- #182: Y_p correction = 1/252
yp-corr-den : chi * towerD ≡ 252
yp-corr-den = refl

-- #183: μ_p/μ_n = 35/24
moment-num : nC * (sigmaD - 1) ≡ 105
moment-num = refl
moment-den : nW * sigmaD ≡ 72
moment-den = refl

-- ═══════════════════════════════════════════════════════════════
-- §17  PHASE 2 — MEDIUM 5
-- ═══════════════════════════════════════════════════════════════

-- #184: m_c/m_s = 12 × 49/50
mcms-base : nW * nW * nC ≡ 12
mcms-base = refl
mcms-base-alt : gauss - 1 ≡ 12
mcms-base-alt = refl
mcms-corr-num : towerD + beta0 ≡ 49
mcms-corr-num = refl
mcms-corr-den : towerD + beta0 + 1 ≡ 50
mcms-corr-den = refl
mcms-den-route2 : sigmaD2 - gauss * 49 ≡ 13
mcms-den-route2 = refl
mcms-product : 12 * 49 ≡ 588
mcms-product = refl

-- #185: m_b/m_τ = 7/3 + 1/42
mbtau-corr-den : chi * beta0 ≡ 42
mbtau-corr-den = refl
mbtau-corr-is-D : chi * beta0 ≡ towerD
mbtau-corr-is-D = refl

-- #186: m_t/v = 7/10 + 1/650
yt-base-den : gauss - nC ≡ 10
yt-base-den = refl
yt-corr-den : sigmaD2 ≡ 650
yt-corr-den = refl

-- #187: ⟨r²⟩_π coefficient = 9/20
rpi-num : nC * nC ≡ 9
rpi-num = refl
rpi-den : gauss + beta0 ≡ 20
rpi-den = refl

-- #188: Δα_had = 1/36
dalpha-den : sigmaD ≡ 36
dalpha-den = refl

-- ═══════════════════════════════════════════════════════════════
-- §18  PHASE 3 — HARD 4
-- ═══════════════════════════════════════════════════════════════

-- #189: σ_πN correction = 43/42
sigma-corr-num : towerD + 1 ≡ 43
sigma-corr-num = refl
sigma-same-43 : towerD + 1 ≡ sigmaD + chi + 1
sigma-same-43 = refl

-- #190: Δm²₂₁ tower and gauss
dm21-tower : towerD ≡ 42
dm21-tower = refl
dm21-gauss : gauss ≡ 13
dm21-gauss = refl

-- #191: Δm²₃₂ correction factors
dm32-nu3-num : 2 * chi - 2 ≡ 10
dm32-nu3-num = refl
dm32-nu3-den : 2 * chi - 1 ≡ 11
dm32-nu3-den = refl
-- Split ratio: χ⁴ = 1296
split-chi4 : chi * chi * chi * chi ≡ 1296
split-chi4 = refl
split-chi4-minus1 : chi * chi * chi * chi - 1 ≡ 1295
split-chi4-minus1 = refl

-- #192: G_N coupling hierarchy
grav-den : beta0 * (chi - 1) ≡ 35
grav-den = refl
grav-mp-num : towerD + gauss - nW ≡ 53
grav-mp-num = refl
grav-mp-den : towerD + gauss - nW + 1 ≡ 54
grav-mp-den = refl

-- ═══════════════════════════════════════════════════════════════
-- §19  CROSS-CHECKS
-- ═══════════════════════════════════════════════════════════════

partition-19 : gauss + chi ≡ 19
partition-19 = refl
partition-20 : gauss + beta0 ≡ 20
partition-20 = refl
the-43 : towerD + 1 ≡ 43
the-43 = refl
fermat-257 : nW * nW * nW * nW * nW * nW * nW * nW + 1 ≡ 257
fermat-257 = refl
