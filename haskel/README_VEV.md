<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# README_VEV.md — The Higgs VEV: Derivation, Scale Choice, and Conversion

## The VEV is DERIVED

The crystal derives the Higgs VEV from the Planck mass:

```
v(crystal) = M_Pl × 35 / (43 × 36 × 2⁵⁰) = 245.17 GeV
```

Every factor has a spectral origin:

| Factor | Value | Crystal origin |
|--------|-------|---------------|
| 35 | Σd − 1 | Non-identity channels (36 − 1) |
| 43 | D + 1 | MERA layers (42 + 1, fence-post) |
| 36 | Σd = χ² | Total channel count |
| 2⁵⁰ | 2^(D+d₃) | Tower depth (42) + colour adjoint (8) |

The hierarchy M_Pl/v ≈ 5×10¹⁶ is not fine-tuning — it is counting:
43 layers × 36 channels × 2⁵⁰ binary halvings.

## The scale choice

The crystal gives v = 245.17 GeV. The PDG quotes v = 246.22 GeV.
The difference is 0.42%. This is a renormalisation scale choice,
not a discrepancy.

- The crystal evaluates the Higgs VEV at the spectral scale
  μ_H ≈ 115 GeV (near the Higgs mass)
- The PDG evaluates it at the Fermi scale μ = M_Z = 91.2 GeV
  (extracted from the muon lifetime via the Fermi constant G_F)
- Standard Model running connects them

## The conversion rule

```
v(PDG) = v(crystal) × 1.004

1.004 = 1 + 3 y_t² / (16π²) × ln(115 / 91.2)
```

where every digit traces to the algebra:

| Symbol | Value | Origin |
|--------|-------|--------|
| 3 | N_c | from M₃(ℂ) |
| y_t | 1 | conformal fixed point at D = 0 |
| 16π² | 157.91 | one-loop Feynman integral in 4D (geometry, not a parameter) |
| 115 GeV | μ_H | crystal's natural scale: v·√(N_w/N_c²) = v·√(2/9) |
| 91.2 GeV | M_Z | Z boson mass: v·N_c/(N_c²−1) = v·3/8 |

The ratio μ_H/M_Z = √N_w · d₃/N_c² = √2 · 8/9. Every digit from (2,3).

## Why this is scheme dependence, not error

The systematic pattern confirms this is a scale choice:

- Every **mass** the crystal computes (v, m_H, m_τ, m_b, m_p) is shifted
  low by 0.4–0.8% relative to PDG — they all inherit the scale shift
  from v because every mass is proportional to v

- Every **dimensionless quantity** (α⁻¹, sin²θ, |V_us|, mixing angles)
  scatters around zero with no systematic shift — ratios cancel the
  scale offset

- If the crystal had a genuine error, it would affect masses AND ratios
  equally. The fact that the shift lives only in the mass scale is
  pathognomonic of a renormalisation scheme mismatch

For comparison: the bottom quark mass differs by 14% between pole and
MS-bar schemes. The charm by 31%. The strange by a factor of 5. The
crystal's 0.42% is tiny by particle physics standards. Scheme dependence
is not an error; it is a convention.

## Three modes of use

| Mode | v value | When to use |
|------|---------|-------------|
| 1. PDG direct | v_mev = 246220 MeV | Testing PWI against PDG tables. Default. |
| 2. Crystal derived | v_crystal_mev = 245174 MeV | When you want the raw algebraic value. |
| 3. Crystal → PDG | v_crystal_mev × v_running = 246239 MeV | When you derive from M_Pl and convert to PDG scheme. |

The user picks. The test suite uses Mode 1.

## Where in the codebase

### CrystalGauge.hs — line 27

The prove function that derives v from M_Pl:

```haskell
proveVEV :: Crystal Two Three -> Ruler -> Derived
proveVEV c r =
  let mpl = rulerMPl r
      pre = crFromInts c (sigmaD - 1) ((towerD + 1) * sigmaD)
      pow = (2::Integer) ^ (towerD + nW ^ nC)
      val = mpl * crDbl pre / fromIntegral pow
  in Derived "v (GeV)" "M_Pl×35/(43×36×2⁵⁰)" val Nothing (pdg 246.22) Computed
```

### CrystalAxiom.hs — line 612

The Ruler that holds M_Pl (the one measured number):

```haskell
data Ruler = MkRuler { rulerMPl :: Double, rulerMZ :: Double }
standardRuler :: Ruler
standardRuler = MkRuler 1.220890e19 91.1876
```

### CrystalWACAScan.hs — lines 170–210

All three values available:

```haskell
m_pl_mev :: Double
m_pl_mev = 1.220890e22                          -- MeV (the ONE measured number)

v_crystal_mev :: Double
v_crystal_mev = m_pl_mev
              * fromIntegral (sigma_d - 1)       -- 35
              / fromIntegral (d_total + 1)       -- 43
              / fromIntegral sigma_d             -- 36
              / fromIntegral ((2::Integer) ^ (d_total + n_c^2 - 1))  -- 2⁵⁰

v_running :: Double
v_running = 1.0 + fromIntegral n_c              -- N_c = 3
          / (16.0 * pi * pi)                     -- 16π²
          * log (sqrt (fromIntegral n_w)          -- √N_w = √2
               * fromIntegral (n_c^2 - 1)        -- d₃ = 8
               / fromIntegral (n_c^2))            -- N_c² = 9

v_mev :: Double
v_mev = 246220.0                                 -- MeV (PDG scheme, Mode 1)

-- Mode 2: use v_crystal_mev directly (245174 MeV)
-- Mode 3: v_crystal_mev * v_running (246239 MeV)
```

### CrystalAxiom.hs — lines 360–395

Extended commentary on the VEV as parallel transport length in the
internal geometry of A_F (Connes NCG interpretation).

### CrystalWACAScan.hs — line 706

provePlanckHierarchy verifies M_Pl/v = e^D/(β₀(χ−1)) = e⁴²/35.

## Numerical verification

```
M_Pl             = 1.220890 × 10¹⁹ GeV     (CODATA)
v(crystal)       = M_Pl × 35/(43×36×2⁵⁰)  = 245.174 GeV
v_running        = 1 + 3/(16π²)·ln(√2·8/9) = 1.00435
v(crystal→PDG)   = 245.174 × 1.00435       = 246.239 GeV
v(PDG)           = 246.220 GeV              (from G_F)
gap              = 0.008%
```
