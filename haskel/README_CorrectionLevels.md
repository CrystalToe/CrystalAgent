<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Correction Levels in the Crystal Topos

## The Core Question

When you compute an observable from the 15 building blocks, some come out
as exact integers. Some need a factor of π. Some need a loop correction.
Some need hierarchical implosion factors from higher tower layers.

How do you know which treatment an observable needs?

This document answers that question with a complete classification system,
the physical reason behind each level, and a decision procedure you can
apply to any new candidate.

---

## The Seven Levels

```
Level 0 — Exact Integer       counting representations, quantum numbers
Level 1 — Exact Rational      ratios of integers, algebraic structure
Level 2 — Single π            complex geometry of A_F
Level 3 — Single κ or ln      renormalization group flow
Level 4 — One-loop            virtual particle corrections, 1/(16π²)
Level 5 — Running             energy-scale dependence, β-function
Level 6 — Implosion           tower layer corrections, hierarchy
Level 7 — Compositeness       sums of pieces from multiple layers
```

Each level adds one layer of mathematical structure. Lower levels are
exact. Higher levels are perturbative corrections on top of lower levels.

---

## Level 0 — Exact Integer (Tree-Level Counting)

### What It Is

The observable IS an integer (or a small power of integers) that counts
something discrete in the algebra.

### Why It's Exact

These observables are **combinatorial**. They count the number of
representations, dimensions, quantum states, or symmetry operations.
Counting is exact. There is no approximation.

### How to Know

Ask: **"Does this observable count something?"**

If it counts particles, states, dimensions, symmetries, or generators
— it's Level 0. The algebra has a fixed number of irreps, a fixed
dimension, a fixed number of generators. These never change.

### Examples

| Observable | Value | Formula | What it counts |
|-----------|-------|---------|---------------|
| Gluon count | 8 | N_c²−1 = d₃ | Generators of SU(3) |
| Spatial dimensions | 3 | N_c | Colour dimension |
| Quark colors | 3 | N_c | Colour triplet |
| Force exponent | 2 | N_c−1 | Transverse dimensions |
| State space | 36 | Σd | Total irrep dimensions |
| Tower depth | 42 | Σd+χ | Layers in MERA |
| Amino acids | 20 | N_w²(χ−1) | Codon→AA map |
| Codons | 64 | (N_w²)^N_c | Genetic code size |
| DNA bases | 4 | N_w² | Base pair states |
| LJ attraction exp | 6 | χ | VdW multipole order |
| LJ repulsion exp | 12 | 2χ | Double multipole |
| Iron-56 | 56 | d₃·β₀ | Most stable nucleus |
| pH neutral | 7 | β₀ | QCD beta coefficient |
| Magic number 8 | 8 | d₃ | Colour shell closure |
| Ising z (square) | 4 | N_w² | Nearest neighbors |
| Ising z (cubic) | 6 | χ | Nearest neighbors |
| Stokes drag | 24 | d₄ | Mixed sector dim |
| Planck λ exponent | 5 | χ−1 | Radiation modes |
| Rayleigh size exp | 6 | χ | Dipole scattering |
| Rayleigh λ exp | 4 | N_w² | Acceleration order |
| Stefan-Boltzmann T exp | 4 | N_w² | Thermal radiation |
| sp2 angle | 120° | (χ−1)·d₄ | Planar symmetry |

### Rule

**If the measured value IS an integer or an obvious ratio of small
integers that you can read off by inspection → Level 0.**

No corrections needed. No π. No ln. No loops. It just IS the count.

---

## Level 1 — Exact Rational (Tree-Level Algebra)

### What It Is

The observable is a ratio of products of building blocks. Still exact,
but involves division, not just counting.

### Why It's Exact

These come from **algebraic relations** between representations.
A ratio like d₄/χ = 24/6 = 4 residues per tile is a consequence of
how the representations decompose under tensor product. It's exact
because the algebra has fixed structure.

### How to Know

Ask: **"Is this a ratio of discrete quantities?"**

If it's a fraction where both numerator and denominator count something
from the algebra — a ratio of dimensions, a ratio of quantum numbers,
a branching ratio of representations — it's Level 1.

### Examples

| Observable | Value | Formula | What ratio |
|-----------|-------|---------|-----------|
| sin²θ_W (GUT scale) | 3/13 | N_c/gauss | Colour/total generators |
| Helix residues/turn | 3.6 | 18/5 = N_c²N_w/(χ−1) | Rep dimensions |
| Flory exponent | 0.4 | 2/5 = N_w/(χ−1) | Weak/adjoint dim |
| β-sheet spacing | 3.5 | 7/2 = β₀/N_w | Beta/weak |
| Ramachandran | 0.5625 | 36/64 = Σd/(N_w²)^N_c | State/codon space |
| Kleiber exponent | 0.75 | 3/4 = N_c/N_w² | Colour/weak² |
| Kolmogorov | 5/3 | (χ−1)/N_c | Adjoint/colour |
| C_F (Casimir) | 4/3 | (N_c²−1)/(2N_c) | Adjoint/2×fund |
| n_water | 4/3 | C_F | Same as Casimir |
| n_glass | 3/2 | N_c/N_w | Colour/weak |
| Chandrasekhar | 3/2 | N_c/N_w | Same |
| Chirp mass exp | 5/3 | (χ−1)/N_c | Same as Kolmogorov |
| Peters 32/5 | 32/5 | N_w⁵/(χ−1) | Power/adjoint |
| Prandtl (air) | 120/169 | (χ−1)d₄/gauss² | Mixed geometry |
| GW bending | 4 = N_w² | N_w² | Weak quadratic |
| m_c/m_s | 294/25 | β₀·D/(χ−1)² | Tower×beta/adj² |
| V_cb | 192/4550 | d₃d₄/(β₀Σd²) | Colour×mixed / beta×Casimir |
| V_cb/V_ub | 257/24 | F₃/d₄ | Fermat/mixed |
| Lindemann | 1/10 | T_F/(χ−1) | Index/adjoint |
| Grüneisen | 2 | 1/T_F = N_w | Fund index inverse |
| Prandtl (water) | 7 | β₀ | Beta coefficient |
| GC content | 16/39 | C_F·N_w²/gauss | Casimir·weak²/Gauss |

### Rule

**If the value is a ratio of building-block products, and both sides
count or measure algebraic quantities → Level 1.**

The CKM elements V_cb = d₃d₄/(β₀Σd²) = 192/4550 are Level 1 because
they're ratios of representation products. They're exact at the scale
where the algebra is "unsplit."

---

## Level 2 — Single π (Complex Geometry)

### What It Is

The formula has a rational skeleton multiplied or divided by π.

### Why π Appears

π enters because A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ) is a **complex** algebra.
Complex numbers have circles. Circles have circumference 2π. Whenever
the observable involves:

- An angular integral (solid angle, phase space)
- A Fourier transform (momentum ↔ position)
- A circular contour (residue theorem)
- A continuous symmetry (rotation group measure)

a factor of π appears. The π is NOT a correction — it's part of the
exact formula. But it marks the observable as involving continuous
geometry, not just discrete counting.

### How to Know

Ask: **"Does this observable involve an angular integral, a Fourier
transform, or a continuous rotation?"**

If the observable involves measuring something over a continuous angle,
integrating over phase space, or normalising a wavefunction — it needs π.

### Examples

| Observable | Value | Formula | Why π |
|-----------|-------|---------|-------|
| α⁻¹ | 137.036 | (D+1)π + ln β₀ | Phase space integral |
| m_W/m_Z | 0.8815 | Σd/(gauss·π) | EW mixing angle geometry |
| m_b/m_τ | 2.356 | 1/(C_F·π) | Yukawa coupling normalisation |
| m_t/m_W | 2.149 | N_c²/(C_F·π) | Top quark phase space |
| Ising T_c/J | 2.269 | 2·gauss/(Σd·π) | Partition function |
| Re_crit | 2300 | N_c²Σd²/(d₃·π) | Turbulent transition |
| Salpeter IMF | 2.35 | N_w²d₄/(gauss·π) | Stellar mass function |
| BCS gap | 3.528 | N_w²Σd/(gauss·π) | Cooper pair integral |
| percolation p_c | 0.5927 | κ(χ−1)/(D·π) | Cluster percolation |
| μ_p/μ_N | 2.7928 | d₃/(N_c²·π) | Magnetic moment integral |
| Catalan const | 0.916 | β₀/(d₄·π) | Alternating series |
| Ω_Λ | 0.6847 | β₀d₃/(F₃·π) | Cosmological integral |
| n_diamond | 2.417 | 2(χ−1)/(gauss·π) | Electromagnetic response |
| e (Euler number) | 2.718 | β₀d₃/(κ·gauss) | Exponential growth |

### Rule

**If removing a single factor of π from the measured value leaves a
clean rational expression over building blocks → Level 2.**

Practically: compute `value × π` and `value / π` and `value × π²` etc.
If any of these is a recognisable ratio of building blocks, it's Level 2.
This is exactly what CrystalDiscover does when it searches with `pp <- [0, 1, -1]`.

---

## Level 3 — κ or ln (Renormalization Group Flow)

### What It Is

The formula involves κ = ln3/ln2 = ln(N_c)/ln(N_w), the only irrational
number generated purely from (2,3), or an explicit logarithm like ln(β₀).

### Why κ Appears

κ is the **scaling dimension** between the weak and colour sectors. It
measures how information flows between the two MERA layers. When an
observable depends on the RATIO of decay rates between sectors — how
fast the weak sector contracts relative to the colour sector — κ appears.

ln appears when the observable involves **dimensional transmutation**:
a discrete structure (the algebra) generating a continuous scale. The
most important example: α⁻¹ = (D+1)π + ln(β₀), where the ln(β₀) is
the QCD scale entering the electromagnetic coupling.

### How to Know

Ask: **"Does this observable measure a ratio between different sectors
or a scale that emerges from dimensional transmutation?"**

If it involves comparing how two sectors behave (weak vs colour rates),
or if a mass/energy scale emerges from a counting quantity (β₀ = 7
becomes Λ_QCD through dimensional transmutation) → Level 3.

### Examples

| Observable | Value | Formula | Why κ/ln |
|-----------|-------|---------|---------|
| α⁻¹ | 137.036 | (D+1)π + ln(β₀) | ln: QCD scale transmutation |
| σ₈ | 0.811 | N_c²/(κ·β₀) | κ: sector scaling in CMB |
| age/Hubble | 0.964 | d₄/(κ(χ−1)π) | κ: cosmological sector flow |
| m_H/m_Z | 1.374 | κ·gauss/(N_c(χ−1)) | κ: Higgs sector scaling |
| φ (golden) | 1.618 | κ·F₃/(χ·D) | κ: self-similar scaling |
| n_s (spectral) | 0.9649 | N_c²/(C_F·β₀) | Near-rational, κ-like |
| T_CMB | 2.7255 | κ·Σd²/(N_c²·D) | κ: CMB cooling scaling |

### Rule

**If the value divided by κ (or κ², or multiplied by κ) gives a clean
rational → Level 3. If the formula needs ln of a building block → Level 3.**

---

## Level 4 — One-Loop Correction (Virtual Particles)

### What It Is

The tree-level formula (Level 0-3) is slightly off from experiment. The
correction is proportional to α/(4π) ≈ 1/(16π²) ≈ 0.06%.

### Why It Appears

Quantum field theory: virtual particle-antiparticle pairs briefly exist
and modify the effective coupling. Each loop contributes a factor of
α/(4π) where α is the coupling. The correction from A_F:

```
1-loop factor = 1 + N_c/(16π²) · ln(√N_w · d₃/N_c²)
              = 1 + 3/(16π²) · ln(√2 · 8/9)
              = 1.004
```

Every integer in this correction comes from (2,3).

### How to Know

Ask: **"Is the tree-level formula off by 0.1-1% from experiment?"**

If the Level 0-3 formula gives 99.0-99.9% of the measured value, and
the remainder is proportional to α/(4π), it's a one-loop correction.

The canonical example: the VEV. Crystal derives v = 245.17 GeV. PDG
extraction gives v = 246.22 GeV. Ratio: 1.004 = the one-loop factor.
This 0.4% gap IS the one-loop correction, and every digit in the
correction comes from (2,3).

### Examples

| Observable | Tree value | Measured | Gap | Correction |
|-----------|-----------|----------|-----|-----------|
| VEV | 245.17 GeV | 246.22 GeV | 0.43% | 1 + N_c/(16π²)·ln(√N_w·d₃/N_c²) |
| g-2 electron | 2.0 | 2.00232 | 0.12% | + α/(2π) = + 1/(N_w·16π²) |
| sin²θ_W running | 3/13 = 0.2308 | 0.23122 | 0.2% | RG running |

### Rule

**If the tree formula matches to < 1% and the correction is ~ α/(4π)
in size → Level 4.**

In practice: compute tree value, compute |tree − measured|/measured.
If this is in the range 10⁻⁴ to 10⁻², suspect a one-loop correction.
The correction formula will involve N_c/(16π²) × ln(something from atoms).

---

## Level 5 — Running (Multi-Loop RG)

### What It Is

The observable changes with energy scale. The formula at one scale needs
the β-function to translate to another scale.

### Why It Appears

The coupling "constants" aren't constant — they run with energy. α_s = 0.12
at the Z mass, but α_s = 0.3 at 1 GeV. The running is controlled by the
β-function, whose coefficients are:

```
β₀ = (11N_c − 2χ)/3 = 7         (one-loop)
β₁ = (34N_c² − 10N_cχ + 3χ)/3   (two-loop, all from (2,3))
```

Running means the formula at scale μ includes ln(μ/Λ) where Λ is the
QCD scale, itself derived from (2,3).

### How to Know

Ask: **"Does this observable depend on which energy scale you measure it?"**

If the value changes when measured at different energies (coupling constants,
quark masses in MS-bar scheme, parton distributions) → Level 5. The
number of loops needed depends on the precision required:

```
1-loop:  ~10% accuracy    (β₀ only)
2-loop:  ~1% accuracy     (β₀ + β₁)
3-loop:  ~0.1% accuracy   (β₀ + β₁ + β₂)
```

### Examples

| Observable | Scale | Value | Loops needed |
|-----------|-------|-------|-------------|
| α_s(M_Z) | 91.2 GeV | 0.1179 | 2-loop for 1% |
| α_s(1 GeV) | 1 GeV | ~0.3 | 3-loop |
| α⁻¹(M_Z) | 91.2 GeV | 127.95 | 2-loop |
| m_s(MS-bar) | 2 GeV | 93.4 MeV | 3-loop |
| m_c(MS-bar) | m_c | 1.27 GeV | 3-loop |
| m_b(MS-bar) | m_b | 4.18 GeV | 3-loop |

### Rule

**If the PDG quotes the value at a specific scale (like "m_s at 2 GeV")
→ Level 5.** The formula at the GUT scale is simpler (usually Level 1),
but translating to the measurement scale requires the β-function.

---

## Level 6 — Hierarchical Implosion (Tower Corrections)

### What It Is

The observable lives at a specific tower layer D_layer, and higher layers
modify it through multiplicative implosion factors.

### Why It Appears

The MERA tower has 42 layers. Each layer coarse-grains the layer below.
When a lower-layer observable (like VdW energy at D=22) is influenced by
structure at higher layers (like the overall tower geometry at D=42), the
influence enters as a multiplicative correction:

```
E_observed = E_base × implosion_factor
```

The implosion factors are exact rationals from (2,3):

```
VdW:      × (1 − N_c³/(χ·Σd))           = 7/8
H-bond:   × (1 − T_F/χ)                  = 11/12
Angle:    × (1 + D/(d₄·Σd))              = 151/144
Burial:   × (1 + β₀/(d₄·Σd²))           = 1 + 7/15600
VdW dist: × (1 − T_F/(d₃·Σd))           = 1 − 1/576
H-b dist: × (1 − N_w/(N_c·Σd))          = 1 − 1/54
```

### How to Know

Ask: **"Is this an energy scale that lives at a specific tower layer, and
is the measured value slightly off from the layer's base prediction?"**

If the base formula (from the tower layer) gives 90-99% of the value, and
the correction is a clean rational involving D, Σd, or Σd² in the
denominator → Level 6.

The denominator tells you which implosion CHANNEL is active:

```
χ·d₄  = 144   colour channel
N_w·χ = 12    weak channel
d₃·Σd = 288   mixed channel
d₄²   = 576   dual route
d₄·Σd = 864   mixed-colour
d₄·Σd² = 15600 deep hierarchy
```

### Examples

| Observable | Base | Factor | Final | Channel |
|-----------|------|--------|-------|---------|
| ε_vdw | 0.0221 eV | 7/8 | 0.0194 eV | χ·Σd = 216 |
| ε_hbond | 0.199 eV | 11/12 | 0.182 eV | N_w·χ = 12 |
| k_angle | 0.199 eV/rad² | 151/144 | 0.209 eV/rad² | d₄·Σd = 864 |
| ε_burial | ~0.447 eV | 1+7/15600 | ~0.447 eV | d₄·Σd² = 15600 |
| VdW distance | base Å | 1−1/576 | corrected | d₃·Σd = 288 (dual) |

### Rule

**If the observable is a force-field energy or distance that comes from
CrystalProtein's 43-layer tower, and the base layer value needs a small
rational multiplicative correction → Level 6.**

The channel identifies itself: look at the denominator of the correction.
If it's 144 → colour. If it's 12 → weak. If it's 288 → mixed.

---

## Level 7 — Compositeness (Multi-Layer Assembly)

### What It Is

The observable is a SUM of pieces from different tower layers. Composite
particles (hadrons, nuclei, atoms) get their mass from multiple sources.

### Why It Appears

A proton isn't a "single number from the algebra." It's a bound state of
quarks and gluons. Its mass comes from:
- Quark masses (D=10 layer, from v/F₃)
- QCD binding energy (D~15, from Λ_QCD)
- Electromagnetic corrections (D~5, from α × m_p)

Each piece is a Level 0-6 observable. The composite is their sum.

### How to Know

Ask: **"Is this particle/system made of parts?"**

If the observable is a hadron mass, a nuclear binding energy, an atomic
energy level, or any composite system → Level 7. The formula will be a
sum of terms, each from a different tower layer.

### Examples

| Observable | Pieces | Formula |
|-----------|--------|---------|
| K± mass | m_π × (gauss−N_w)/N_c | Tree pion × CKM ratio |
| K⁰ mass | K± + β₀ × m_e | K± + EM self-energy |
| Δ(1232) | m_p + m_π × N_c/β₀ | Proton + pion excitation |
| Ξ baryon | m_p + m_π × (gauss−2)/β₀ | Proton + strangeness |
| Deuteron BE | ~2.2 MeV | N_w²(χ−1)/N_c² from nuclear |
| Alpha BE | ~28.3 MeV | 4 × N_c/(C_F·π) per nucleon |

### Rule

**If the formula is an additive expression (not just a ratio) with terms
from different scales → Level 7.**

---

## The Decision Tree

Given a new candidate observable, apply this procedure:

```
1. Is the value an integer?
   YES → Level 0 (check: is it a building block product?)
   NO  → continue

2. Is value × {1, π, π², 1/π} a clean ratio of building blocks?
   YES and no π needed → Level 1
   YES and π needed    → Level 2
   NO                  → continue

3. Is value × {κ, 1/κ, κ²} a clean ratio?
   YES → Level 3
   NO  → continue

4. Does a Level 0-3 formula give 99-100% of the value?
   YES → Level 4 (one-loop correction fills the gap)
   NO  → continue

5. Does PDG quote the value at a specific energy scale?
   YES → Level 5 (running needed)
   NO  → continue

6. Is the value a force-field energy with a small rational correction?
   YES → Level 6 (implosion)
   NO  → continue

7. Is the value a sum of terms from different scales?
   YES → Level 7 (compositeness)
   NO  → not yet classified (may need deeper analysis or new atoms)
```

### What CrystalDiscover Does

CrystalDiscover automates steps 1-3. It enumerates formulas at Levels 0-3
(integers, rationals, ×π, ×κ) and matches against known constants. It
found 50 new observables this way.

### What It Doesn't Do Yet

Levels 4-7 require physical knowledge:
- Level 4: knowing which coupling runs the loop
- Level 5: knowing the β-function coefficients
- Level 6: knowing the implosion channel
- Level 7: knowing which pieces compose the system

These require a physicist (or a more sophisticated search) to identify.
But the integer skeleton — the tree-level starting point — comes from
Levels 0-3. CrystalDiscover finds the skeleton. The corrections are
perturbative: they improve accuracy from ~1% to ~0.01%.

---

## Distribution of the 198+50 Observables

| Level | Count (est.) | PWI range | Example |
|-------|-------------|-----------|---------|
| 0 (integer) | ~60 | 0.00% | amino acids = 20 |
| 1 (rational) | ~45 | 0.00% | sin²θ_W = 3/13 |
| 2 (×π) | ~35 | 0.00-0.1% | α⁻¹ = 43π + ln7 |
| 3 (×κ/ln) | ~20 | 0.01-0.1% | T_CMB = κΣd²/(N_c²D) |
| 4 (1-loop) | ~15 | 0.1-1.0% | g-2 = 2+α/(2π) |
| 5 (running) | ~10 | 0.1-0.5% | α_s(M_Z) = 0.1179 |
| 6 (implosion) | ~8 | 0.01-0.1% | ε_vdw × 7/8 |
| 7 (composite) | ~55 | 0.1-4% | hadron masses |

The overwhelming majority (Levels 0-2, ~140 observables) are either exact
or exact-up-to-π. These are the easiest to discover and the most convincing.

Levels 4-7 (~83 observables) require perturbative corrections. These are
harder to discover because you need to identify the correction type first,
but they're also the most physically rich — they test whether the framework
handles quantum corrections, not just tree-level counting.

---

## Practical Guidance for Discovery

### Finding Level 0-1 Observables (Easy)

Run CrystalDiscover with `pp <- [0]` (no π). Any match IS exact.
These are the highest-confidence discoveries. Zero ambiguity.

### Finding Level 2 Observables (Medium)

Run CrystalDiscover with `pp <- [0, 1, -1]` (include ±π).
Matches with π are still exact formulas — the π is structural, not an
approximation. But verify: is there a physical reason π should appear?
(Angular integral? Phase space? Fourier transform?)

### Finding Level 3 Observables (Medium-Hard)

Add κ to the atom list (already done in CrystalDiscover). Matches
involving κ need physical justification: why should the weak-colour
scaling dimension appear in this observable?

### Finding Level 4-7 Observables (Hard)

These can't be found by pure enumeration. You need to:
1. Start with a Level 0-3 skeleton
2. Notice it's 0.1-4% off from experiment
3. Identify the correction type from the PHYSICS
4. Verify the correction formula uses only (2,3) atoms

This is where human insight (or future AI) is still needed.

---

*Every observable has a level. The level tells you what kind of mathematical
structure connects the algebra to the measurement. The algebra is exact.
The levels are the lens through which we see it.*
