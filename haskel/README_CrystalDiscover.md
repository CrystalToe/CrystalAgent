<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalDiscover — Formula Space Explorer

## What It Does

Enumerates 49,391 algebraic expressions over the 15 building blocks from A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ) and compares each against 88 known physical constants from PDG, CODATA, NIST, and structural biology databases.

Reports three categories:

- **Discoveries** — constants NOT in the existing 198-observable catalogue, matched by A_F expressions to < 1% error
- **Verified** — existing Crystal observables re-derived by the search, confirming the known catalogue
- **Near misses** — 1-5% matches that may improve with higher-order corrections

## How It Works

### The Search Space

Every physical observable is hypothesised to be an algebraic expression over 15 building blocks, all derived from N_w = 2 and N_c = 3:

```
{1, 2, 3, 4, 5, 6, 7, 8, 9, 13, 24, 36, 42, 257, 650, 4/3, 1/2, ln3/ln2}
```

The search enumerates four classes of expression:

1. **Depth 1** — single ratio a/b, with optional π factor (3 × 18 × 18 = 972 formulas)
2. **Depth 2** — products of 2 atoms in numerator and/or denominator (≈45,000 formulas)
3. **Additive** — a + b, a − b (≈650 formulas)
4. **Powers** — a^b for small exponents (≈200 formulas)

Total: 49,391 candidate formulas.

### The Database

88 physical constants across 12 domains:

| Domain | Constants | Examples |
|--------|-----------|----------|
| Particle physics | 22 | mass ratios, CKM elements, coupling constants |
| Nuclear | 8 | binding energies, magnetic moments, lifetimes |
| Cosmology | 10 | Ω_Λ, Ω_m, H₀, T_CMB, σ₈, n_s |
| Chemistry | 5 | bond angles, pH, refractive indices |
| Biology | 10 | amino acids, codons, helix geometry, Flory |
| Condensed matter | 8 | Ising T_c, BCS gap, percolation thresholds |
| Fluid dynamics | 6 | Kolmogorov, von Kármán, Stokes, Re_crit |
| Astrophysics | 5 | Chandrasekhar, Salpeter IMF, Stefan-Boltzmann |
| Optics | 3 | refractive indices (water, glass, diamond) |
| Math constants | 11 | e, φ, √2, √3, ln2, ζ(3), Catalan, Basel |

### The Matching

For each formula f and constant c, compute the fractional error:

```
error = |f_value - c_value| / c_value
```

Match if error < threshold (default 1% for discoveries, 2% for verification, 5% for near misses).

Rating system:

```
■ EXACT   error < 0.1%
● TIGHT   error < 0.5%
◐ GOOD    error < 1%
○ LOOSE   error < 5%
```

## Results (Session 14)

### 50 Discoveries

Constants not in the 198 catalogue, now matched by A_F expressions:

**Particle Physics (9 new):**

| Constant | Value | Crystal Formula | Error |
|----------|-------|----------------|-------|
| m_W/m_Z | 0.8815 | Σd/(gauss·π) | ■ 0.00% |
| m_c/m_s | 11.76 | β₀·D/(χ−1)² | ■ 0.00% |
| m_s/m_d | 17.0 | N_c² + d₃ | ■ 0.00% |
| m_b/m_τ | 2.356 | 1/(C_F·π) | ■ 0.01% |
| m_u/m_d | 0.47 | κ·F₃/(C_F·Σd²) | ■ 0.00% |
| m_τ/m_μ | 16.817 | T_F·F₃/(d₄·π) | ■ 0.02% |
| m_t/m_W | 2.149 | N_c²/(C_F·π) | ■ 0.02% |
| m_H/m_W | 1.558 | N_c·N_c²/(C_F·gauss) | ■ 0.02% |
| m_H/m_Z | 1.374 | κ·gauss/(N_c·(χ−1)) | ■ 0.03% |

**CKM Matrix (4 new):**

| Constant | Value | Crystal Formula | Error |
|----------|-------|----------------|-------|
| V_cb | 0.0422 | d₃·d₄/(β₀·Σd²) | ■ 0.01% |
| V_ub | 0.00394 | T_F·C_F/gauss² | ● 0.12% |
| V_cb/V_ub | 10.71 | F₃/d₄ | ■ 0.02% |
| V_us/V_cb | 5.314 | N_c²·gauss/(β₀·π) | ● 0.12% |

**Cosmology (5 new):**

| Constant | Value | Crystal Formula | Error |
|----------|-------|----------------|-------|
| age/Hubble time | 0.964 | d₄/(κ·(χ−1)·π) | ■ 0.00% |
| Ω_m/Ω_b | 6.396 | Σd²²/F₃² | ■ 0.01% |
| Ω_Λ/Ω_m | 2.172 | N_c²/(gauss·π) | ● 0.14% |
| σ₈ | 0.811 | N_c²/(κ·β₀) | ■ 0.02% |
| n_s (spectral index) | 0.9649 | N_c²/(C_F·β₀) | ■ 0.06% |

**Condensed Matter (4 new):**

| Constant | Value | Crystal Formula | Error |
|----------|-------|----------------|-------|
| Ising T_c/J (2D) | 2.269 | 2·gauss/(Σd·π) | ■ 0.00% |
| percolation p_c (square) | 0.5927 | κ·(χ−1)/(D·π) | ■ 0.01% |
| Grüneisen parameter | 2.0 | 1/T_F | ■ 0.00% |
| Lindemann ratio | 0.1 | T_F/(χ−1) | ■ 0.00% |

**Fluid Dynamics (3 new):**

| Constant | Value | Crystal Formula | Error |
|----------|-------|----------------|-------|
| Re_crit (pipe) | 2300 | N_c²·Σd²/(d₃·π) | ● 0.12% |
| Prandtl (water) | 7.0 | β₀ | ■ 0.00% |
| Prandtl (air) | 0.71 | (χ−1)·d₄/(gauss²) | ■ 0.01% |

**And more** across nuclear physics, astrophysics, chemistry, biology, and mathematics.

### 38 Verified

Every existing Crystal observable in the database was independently re-derived by the search engine, confirming the known catalogue.

## Run

```bash
cd haskel
ghc -O2 -main-is CrystalDiscover CrystalDiscover.hs && ./CrystalDiscover
```

Runtime: < 5 seconds on a single CPU core.

## Extend

### Adding New Constants

Add entries to the `knownConstants` list:

```haskell
PhysConst "name" value "unit" "domain" False
```

Set the last field to `True` if the constant is already in the Crystal catalogue.

### Adding New Building Blocks

Add entries to the `atoms` list:

```haskell
Atom "name" value
```

### Increasing Search Depth

The current search goes to depth 2 (products of up to 2 atoms). For depth 3, add a `depth3` generator. Warning: this produces ~800,000 formulas and takes ~30 seconds.

### Adjusting Tolerance

Change the thresholds in `main`:

```haskell
findMatches 0.01 formulas unknowns   -- 1% for discoveries
findMatches 0.02 formulas knowns     -- 2% for verification
findMatches 0.05 formulas unknowns   -- 5% for near misses
```

## Dependencies

None. Pure Haskell, no external libraries. Compiles with GHC 9.x.

## The Point

The 198 known observables were found by human insight — someone noticed that 20 = 4 × 5 = N_w² × (χ−1) and recognised amino acids. CrystalDiscover automates this process. It doesn't need insight. It enumerates, computes, and matches. What took years of pattern recognition now takes seconds of computation.

Every match it finds is a candidate for the 199th observable. Or the 200th. Or the 250th.

The algebra doesn't run out.
