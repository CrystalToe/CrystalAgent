-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalAudit — Naturality constraints and mass ratios from (2,3)
-- Imports CrystalAxiom only. No CrystalEngine.

module CrystalAudit where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

χ : ℕ
χ = nW * nC

σD : ℕ
σD = 1 + 3 + 8 + 24

towerD : ℕ
towerD = σD + χ

d4 : ℕ
d4 = nW * nW * nW * nC

-- §1 Naturality denominators
vus-denom : σD + nW * nW ≡ 40
vus-denom = refl

vus-num : nC * nC ≡ 9
vus-num = refl

s23-denom : 2 * χ - 1 ≡ 11
s23-denom = refl

s23-num : χ ≡ 6
s23-num = refl

s13-denom : σD + nC * nC ≡ 45
s13-denom = refl

-- §2 Endomorphism counts
mixed-endos : d4 * d4 ≡ 576
mixed-endos = refl

total-endos : 1 + 9 + 64 + 576 ≡ 650
total-endos = refl

-- §3 Mass ratio integers
ms-mud : nC * nC * nC ≡ 27
ms-mud = refl

mb-ms : nC * nC * nC * nW ≡ 54
mb-ms = refl

mu-md-num : χ - 1 ≡ 5
mu-md-num = refl

mu-md-denom : 2 * χ - 1 ≡ 11
mu-md-denom = refl

-- §4 Tower and structure
tower : towerD ≡ 42
tower = refl

sigma : σD ≡ 36
sigma = refl

chi-sq-is-sigma : χ * χ ≡ σD
chi-sq-is-sigma = refl
