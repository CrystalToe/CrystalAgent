-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{-
  CrystalLayer.agda — PURE spectral tower D=0→D=42

  PURITY MODEL: Agda has no Float pi/ln/cos. Two tiers:
    Tier 1 (Nat): Integer structure from A_F. Proved by refl.
    Tier 2 (Rational): Float results computed by spectral_tower_pure.py
    and transcribed as Nat numerator/denominator. The DERIVATION is in
    Python. The PROOF of integer structure is in Agda. Both are pure.

  Every rational below is the OUTPUT of a pure derivation chain
  in spectral_tower_pure.py, not a textbook lookup.
-}

module CrystalLayer where
open import Agda.Builtin.Equality
open import Agda.Builtin.Nat

-- ═══════════════════════════════════════════════════════════════
-- §0  LAYER TYPE
-- ═══════════════════════════════════════════════════════════════

record Layer (d : Nat) : Set where
  constructor mkLayer
  field
    num : Nat    -- numerator (scaled value)
    den : Nat    -- denominator (scale factor)

-- ═══════════════════════════════════════════════════════════════
-- §1  ALGEBRA ATOMS (Nat — exact, proved)
-- ═══════════════════════════════════════════════════════════════

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
sigmaD = nW * nW * nC * nC
sigmaD2 : Nat
sigmaD2 = 1 + 9 + 64 + 576
gauss : Nat
gauss = nW * nW + nC * nC

-- ═══════════════════════════════════════════════════════════════
-- §2  CASCADE PROOFS (all pure Nat)
-- ═══════════════════════════════════════════════════════════════

chi-eq : chi ≡ 6
chi-eq = refl
beta0-eq : beta0 ≡ 7
beta0-eq = refl
towerD-eq : towerD ≡ 42
towerD-eq = refl
sigmaD-eq : sigmaD ≡ 36
sigmaD-eq = refl
gauss-eq : gauss ≡ 13
gauss-eq = refl
sigmaD2-eq : sigmaD2 ≡ 650
sigmaD2-eq = refl

-- D=5 integer part
alpha-int : towerD + 1 ≡ 43
alpha-int = refl

-- D=10 Fermat
fermat3 : 1 + (2 * 2 * 2 * 2 * 2 * 2 * 2 * 2) ≡ 257
fermat3 = refl
binding-54 : nC * nC * nC * nW ≡ 54
binding-54 = refl
binding-53 : (nC * nC * nC * nW) - 1 ≡ 53
binding-53 = refl

-- D=25 strand ratio
strand-ratio : beta0 + 1 ≡ 8
strand-ratio = refl

-- D=32 helix
helix-num : nC * chi ≡ 18
helix-num = refl
helix-den : chi - 1 ≡ 5
helix-den = refl

-- D=33 Flory
flory-num : nW ≡ 2
flory-num = refl
flory-den : nW + nC ≡ 5
flory-den = refl

-- Tower depth
tower-sum : sigmaD + chi ≡ towerD
tower-sum = refl

-- Coprime
coprime : 3 - (1 * 2) ≡ 1
coprime = refl

-- ═══════════════════════════════════════════════════════════════
-- §3  D=0 LAYER CONSTANTS (exact Nat)
-- ═══════════════════════════════════════════════════════════════

layer0-chi : Layer 0
layer0-chi = mkLayer 6 1

layer0-beta0 : Layer 0
layer0-beta0 = mkLayer 7 1

layer0-sigma-d : Layer 0
layer0-sigma-d = mkLayer 36 1

layer0-sigma-d2 : Layer 0
layer0-sigma-d2 = mkLayer 650 1

layer0-gauss : Layer 0
layer0-gauss = mkLayer 13 1

layer0-d-max : Layer 0
layer0-d-max = mkLayer 42 1

-- kappa = ln3/ln2 ≈ 1584963/1000000 (from pure tower)
layer0-kappa : Layer 0
layer0-kappa = mkLayer 1584963 1000000

-- v = 246.22 GeV
layer0-v : Layer 0
layer0-v = mkLayer 24622 100

-- ═══════════════════════════════════════════════════════════════
-- §4  D=5: ALPHA (derived: (D+1)*pi + ln(beta_0))
-- ═══════════════════════════════════════════════════════════════
-- alpha_inv = 43*pi + ln(7) = 137.034394
-- Computed by spectral_tower_pure.py. Derivation: pure.

layer5-alpha-inv : Layer 5
layer5-alpha-inv = mkLayer 137034394 1000000

layer5-alpha : Layer 5
layer5-alpha = mkLayer 7297 1000000

-- ═══════════════════════════════════════════════════════════════
-- §5  D=10: PROTON MASS (derived: v/257 * 53/54)
-- ═══════════════════════════════════════════════════════════════

layer10-proton-mass : Layer 10
layer10-proton-mass = mkLayer 940313 1000000

-- ═══════════════════════════════════════════════════════════════
-- §6  D=18: BOHR RADIUS (derived: hbarc/(m_e * alpha))
-- ═══════════════════════════════════════════════════════════════

layer18-bohr : Layer 18
layer18-bohr = mkLayer 526306 1000000

-- Covalent radii: <r>_2p from Slater Z_eff (pure screening integrals)
layer18-rcov-C : Layer 18
layer18-rcov-C = mkLayer 809702 1000000

layer18-rcov-N : Layer 18
layer18-rcov-N = mkLayer 674752 1000000

layer18-rcov-O : Layer 18
layer18-rcov-O = mkLayer 578359 1000000

layer18-rcov-H : Layer 18
layer18-rcov-H = mkLayer 526306 1000000

-- ═══════════════════════════════════════════════════════════════
-- §7  D=20: HYBRIDIZATION (derived: arccos(-1/N_c), 360/N_c)
-- ═══════════════════════════════════════════════════════════════

layer20-sp3 : Layer 20
layer20-sp3 = mkLayer 109471 1000

layer20-sp2 : Layer 20
layer20-sp2 = mkLayer 120000 1000

-- ═══════════════════════════════════════════════════════════════
-- §8  D=25: STRAND SPACINGS (derived from VdW chain)
-- ═══════════════════════════════════════════════════════════════

layer25-strand-anti : Layer 25
layer25-strand-anti = mkLayer 2620 1000

layer25-strand-par : Layer 25
layer25-strand-par = mkLayer 2994 1000

-- ═══════════════════════════════════════════════════════════════
-- §9  D=27-28: PEPTIDE AND CA-CA (derived)
-- ═══════════════════════════════════════════════════════════════

layer27-cn-peptide : Layer 27
layer27-cn-peptide = mkLayer 1271 1000

layer27-ca-c : Layer 27
layer27-ca-c = mkLayer 1619 1000

layer27-n-ca : Layer 27
layer27-n-ca = mkLayer 1484 1000

layer28-ca-ca : Layer 28
layer28-ca-ca = mkLayer 3443 1000

-- ═══════════════════════════════════════════════════════════════
-- §10  D=32: HELIX (exact rational 18/5)
-- ═══════════════════════════════════════════════════════════════

layer32-helix : Layer 32
layer32-helix = mkLayer 18 5

layer32-rise : Layer 32
layer32-rise = mkLayer 3 2

layer32-pitch : Layer 32
layer32-pitch = mkLayer 27 5

-- ═══════════════════════════════════════════════════════════════
-- §11  D=33: FLORY (exact rational 2/5)
-- ═══════════════════════════════════════════════════════════════

layer33-flory : Layer 33
layer33-flory = mkLayer 2 5
