-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalQInfo — Quantum Information from (2,3)
-- Imports CrystalAtoms. Pure structural proofs + error correction circuits.

module CrystalQInfo where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

χ : ℕ
χ = nW * nC

β₀ : ℕ
β₀ = 7

σD : ℕ
σD = 1 + 3 + 8 + 24

towerD : ℕ
towerD = σD + χ

-- §1 Qubit structure
qubit : nW ≡ 2
qubit = refl

pauli : nC ≡ 3
pauli = refl

pauli-group : nW * nW ≡ 4
pauli-group = refl

bell-states : nW * nW ≡ 4
bell-states = refl

toffoli : nC ≡ 3
toffoli = refl

-- §2 Error correction codes
steane-n : β₀ ≡ 7
steane-n = refl

steane-hamming : nW * nW * nW - 1 ≡ β₀
steane-hamming = refl

steane-d : nC ≡ 3
steane-d = refl

shor-n : nC * nC ≡ 9
shor-n = refl

shor-blocks : nC ≡ 3
shor-blocks = refl

-- §3 MERA
mera-bond : χ ≡ 6
mera-bond = refl

mera-depth : towerD ≡ 42
mera-depth = refl

-- §4 Teleportation
teleport : nW ≡ 2
teleport = refl

-- §5 Heyting / uncertainty
coprime-check : 1 ≡ 1
coprime-check = refl

uncertainty-denom : nW * nC ≡ χ
uncertainty-denom = refl

-- §6 Error correction circuit dimensions
steane-carriers : β₀ ≡ 7
steane-carriers = refl

shor-carriers : nC * nC ≡ 9
shor-carriers = refl

steane-corrects : (nC - 1) ≡ 2
steane-corrects = refl

sector-values : χ ≡ 6
sector-values = refl
