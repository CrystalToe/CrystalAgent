-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- CrystalQGates — Quantum gates from End(A_F)
-- Pure MERA. Imports CrystalQBase only. No engine, no time evolution.

module CrystalQGates where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

χ : ℕ
χ = nW * nC

-- §0 Gate space dimensions
single-dim : χ ≡ 6
single-dim = refl

two-particle-dim : χ * χ ≡ 36
two-particle-dim = refl

three-particle-dim : χ * χ * χ ≡ 216
three-particle-dim = refl

process-matrix-dim : χ * χ * χ * χ ≡ 1296
process-matrix-dim = refl

-- §1 Single-particle gate count: 12
-- gateI, gateX, gateY, gateZ, gateH, gateS, gateT,
-- gateRx, gateRy, gateRz, gateU3, gateSX

-- §2 Multi-particle gate count: 14
-- gateCNOT, gateCZ, gateSWAP, gateiSWAP, gateSqrtSWAP,
-- gateToffoli, gateCSWAP,
-- gateXX, gateYY, gateZZ, gateECR, gateGivens, gatefSWAP, gateMatchgate

-- §3 Pauli structure from (2,3)
pauli-non-trivial : nC ≡ 3
pauli-non-trivial = refl

pauli-group-size : nW * nW ≡ 4
pauli-group-size = refl

givens-pairs : χ * (χ - 1) ≡ 30
givens-pairs = refl

-- §4 Tensor product = algebra dimension
tensor-is-sigmaD : χ * χ ≡ 1 + 3 + 8 + 24
tensor-is-sigmaD = refl
