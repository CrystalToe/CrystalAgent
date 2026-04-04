-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- ObservableBio.agda — Component 7 (Bio): genetic code + chemistry identities.
-- All proofs by refl. Zero postulates.

module ObservableBio where

open import Agda.Builtin.Equality
open import Agda.Builtin.Nat renaming (Nat to ℕ)

nW : ℕ
nW = 2

nC : ℕ
nC = 3

chi : ℕ
chi = nW * nC

beta0 : ℕ
beta0 = 7

d3 : ℕ
d3 = nC * nC - 1

sigmaD : ℕ
sigmaD = 1 + 3 + d3 + (nW * nW - 1) * d3

gauss : ℕ
gauss = nC * nC + nW * nW

towerD : ℕ
towerD = sigmaD + chi

-- DNA bases
dna-bases : nW * nW ≡ 4
dna-bases = refl

-- Codons
codons : nW * nW * (nW * nW) * (nW * nW) ≡ 64
codons = refl

-- Amino acids
amino : gauss + beta0 ≡ 20
amino = refl

-- Codon signals
signals : nC * beta0 ≡ 21
signals = refl

-- Codon redundancy = 64 - 21 = 43 = D+1
redundancy : 64 - 21 ≡ towerD + 1
redundancy = refl

-- A-T bonds
at : nW ≡ 2
at = refl

-- G-C bonds
gc : nC ≡ 3
gc = refl

-- Groove ratio: 11 = 2*chi - 1
groove-numer : 2 * chi - 1 ≡ 11
groove-numer = refl

-- Helix turn: 18/5 cross-multiply Nc*(chi-1) + Nc = Nc*chi = 18
helix-numer : nC * chi ≡ 18
helix-numer = refl

helix-denom : chi - 1 ≡ 5
helix-denom = refl

-- Helix rise: N_c = 3, N_w = 2 (3/2 = 1.5)
-- Beta sheet: beta0 = 7, N_w = 2 (7/2 = 3.5)

-- Flory: N_w/(chi-1) = 2/5
flory-numer : nW ≡ 2
flory-numer = refl

flory-denom : chi - 1 ≡ 5
flory-denom = refl

-- Orbital capacities
s-orbital : nW ≡ 2
s-orbital = refl

p-orbital : chi ≡ 6
p-orbital = refl

d-orbital : nW * (chi - 1) ≡ 10
d-orbital = refl

f-orbital : nW * beta0 ≡ 14
f-orbital = refl

-- Lattice lock: Sigma_d = chi^2 = 36
lattice-lock : sigmaD ≡ chi * chi
lattice-lock = refl

sigma-val : sigmaD ≡ 36
sigma-val = refl
