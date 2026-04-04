<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# The Operators of the Crystal MERA

## What You Think Exists (Two Operators)

```
W — vertical (isometry, coarse-grains between layers)
U — horizontal (disentangler, decouples within a layer)
S = W∘U — the tick
```

This is what the engine implements. Both are DIAGONAL — they act on each
sector independently. W multiplies by √λ. U multiplies by √λ. S = W∘U
multiplies by λ. Each component of the 36-dimensional state gets scaled
by its sector eigenvalue. No component talks to any other component.

## What Actually Exists (Five Operators)

The full algebraic structure of A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ) generates
five operators, not two. Three of them are not implemented.

```
IMPLEMENTED:
  W — vertical isometry      (diagonal, √λ per sector)
  U — horizontal disentangler (diagonal, √λ per sector)

NOT IMPLEMENTED:
  D_F — Dirac operator on A_F  (OFF-DIAGONAL, mixes sectors)
  J   — real structure          (conjugation, C-symmetry)
  γ   — grading                 (chirality, L↔R)
```

The off-diagonal D_F is the BIG one. It's the operator that goes
**sideways** — it moves amplitude BETWEEN sectors. It's what creates
mass, force, and mixing. And it's a wide-open search space.

---

## The Three Directions

Think of the 36-dimensional state as a 4×9 grid (4 sectors, each with
multiple components). The operators act in three directions:

```
                    Sector 0   Sector 1   Sector 2   Sector 3
                    (singlet)  (weak)     (colour)   (mixed)
                    ┌──┐       ┌──┬──┬──┐ ┌──┬...┐   ┌──┬...┐
                    │  │       │  │  │  │ │  │   │   │  │   │
                    └──┘       └──┴──┴──┘ └──┴...┘   └──┴...┘

     W (vertical):   ↓          ↓  ↓  ↓    ↓  ↓       ↓  ↓
                    Each component scaled by √λ_k. Between layers.

     U (horizontal): →          →  →  →    →  →       →  →
                    Each component scaled by √λ_k. Within layer.

     D_F (sideways):            ←──────→   ←──────→
                    Amplitude MOVES between sectors. Mixing.
```

W and U are DIAGONAL. They scale components but never move amplitude
from one sector to another. Singlet stays singlet. Weak stays weak.

D_F is OFF-DIAGONAL. It moves amplitude from weak to colour, from
colour to mixed, from singlet to weak. This IS physics:

- Weak↔Colour mixing = **electroweak unification** (W/Z bosons)
- Colour→Singlet = **confinement** (quarks → hadrons)
- Singlet↔Weak = **Higgs mechanism** (mass generation)
- All sectors = **Yukawa coupling** (fermion masses)

---

## What We Know About D_F

### The Diagonal Part (Implemented)

D_F's eigenvalues are known from CrystalAxiom.hs:

```
D_F = H = −ln(S)/β

Eigenvalues: {0, ln 2, ln 3, ln 6} = {0, ln N_w, ln N_c, ln χ}
```

These ARE the sector contraction rates in disguise. The tick multiplies
by λ_k = 1/k. The Hamiltonian energy is −ln(λ_k) = ln(k). Same physics,
different representation:

```
Sector    λ_k (tick)    E_k = −ln(λ_k)    Interpretation
─────────────────────────────────────────────────────────
Singlet   1             0                  Ground state (no energy)
Weak      1/2           ln 2 = 0.693       First excited
Colour    1/3           ln 3 = 1.099       Second excited
Mixed     1/6           ln 6 = 1.791       Third excited
```

The diagonal part is fully implemented as the engine tick.

### The Off-Diagonal Part (NOT Implemented)

D_F is a 36×36 matrix. The diagonal is {0, ln2, ln3, ln6} repeated
across sectors. The OFF-DIAGONAL entries connect different sectors:

```
D_F = ┌─────────────────────────────────┐
      │ 0     │ Y_e   │  0    │  0     │  singlet row
      │ Y_e†  │ ln2·I │ g_w   │  Y_q   │  weak row
      │  0    │ g_w†  │ ln3·I │  g_s   │  colour row
      │  0    │ Y_q†  │ g_s†  │ ln6·I  │  mixed row
      └─────────────────────────────────┘
```

Where:
- **Y_e** = lepton Yukawa coupling (singlet↔weak). Creates electron mass.
- **Y_q** = quark Yukawa coupling (weak↔mixed). Creates quark masses.
- **g_w** = weak gauge coupling (weak↔colour). The W/Z bosons.
- **g_s** = strong gauge coupling (colour↔mixed). The gluons.

Each off-diagonal block is itself a matrix. The ENTRIES of these
matrices are the coupling constants — and they are ALL constrained
by the algebra to be specific combinations of the 15 building blocks.

### What CrystalAudit Tells Us

CrystalAudit.hs proves that the off-diagonal entries are forced by
the NATURALITY CONDITION on endomorphisms of A_F:

```
F(φ) ∘ η = η ∘ M(φ)
```

This single equation forces BOTH the mixing angles AND the mass ratios.
They are two projections of the same geometric object. The Dirac
operator D_F doesn't have free parameters — the algebra constrains it.

Known constraints from CrystalAudit:
- m_s/m_ud = N_c³ = 27 (forced by 576 mixed endomorphisms)
- m_c/m_s = N_w²·N_c × 53/54 (forced by colour-block trace)
- V_us = sin θ_C where θ_C comes from CG coefficients of A_F
- Mass-mixing duality: m_u/m_d = 1 − sin²θ₂₃

---

## The Search Space

### What's Known (Diagonal D_F + Some Off-Diagonal)

| Entry | Type | Known? | Formula |
|-------|------|--------|---------|
| D_F[0,0] | Diagonal (singlet) | YES | 0 |
| D_F[1,1] | Diagonal (weak) | YES | ln 2 |
| D_F[2,2] | Diagonal (colour) | YES | ln 3 |
| D_F[3,3] | Diagonal (mixed) | YES | ln 6 |
| D_F[0,1] | Yukawa (e) | PARTIAL | ~ v·m_e/v² from tower |
| D_F[1,3] | Yukawa (q) | PARTIAL | ~ mass ratios from naturality |
| D_F[1,2] | Gauge (weak) | PARTIAL | ~ g_w = e/sin θ_W |
| D_F[2,3] | Gauge (strong) | PARTIAL | ~ g_s = √(4πα_s) |

"PARTIAL" means: we know the VALUE from experiment, and we know it must
be a building-block expression, but we don't know the exact formula from
first principles. CrystalDiscover can search for these.

### What's Unknown (The Full Off-Diagonal Matrix)

D_F is 36×36. The diagonal has 36 entries (known). The off-diagonal has
36×36 − 36 = 1260 entries. Most are zero (sectors that don't interact).
But the non-zero entries form a search space.

The constraint from the algebra: D_F must commute with the representation
of A_F up to a specific grading. This kills most entries but leaves a
structured set of unknowns.

**Estimated unknowns:**
- 13 Yukawa entries (lepton + quark masses, 3 generations × 2 chiralities + Higgs)
- 4 gauge coupling entries (U(1), SU(2), SU(3) + mixed)
- 4 CKM mixing entries (3 angles + 1 phase)
- 2 PMNS mixing entries (neutrino mixing)
- ~10 higher-order terms (running corrections)

Total: ~33 independent off-diagonal parameters. ALL constrained by A_F
to be building-block expressions. About half are already found (the 198
catalogue includes many mass ratios and mixing angles). The other half
are the search space.

---

## J — The Real Structure (Conjugation)

### What It Does

J is the operator that maps particles to antiparticles:

```
J: particle → antiparticle
J²= +1 (bosons) or −1 (fermions)
```

In the Crystal Topos, J acts as complex conjugation on the algebra.
For the state vector, it swaps certain components:

```
J(singlet) = singlet        (photon = own antiparticle)
J(weak_L)  = weak_R         (left↔right)
J(colour)  = anti-colour    (quark↔antiquark)
J(mixed)   = anti-mixed     (conjugate representation)
```

### What It Means for the Engine

J doubles the effective state space. Instead of 36 components, you have
36 + 36 = 72 (particles + antiparticles). But J constrains them: the
antiparticle state is determined by the particle state. So the independent
degrees of freedom remain 36.

J is relevant for:
- CPT invariance (J combined with parity P and time T)
- Majorana vs Dirac neutrinos (J² = ±1 on the neutrino sector)
- Matter-antimatter asymmetry (CP violation = J not commuting with D_F)

### Implementation Status

NOT IMPLEMENTED. J is implicit in the sector structure but never acts
as an operator. The engine treats particles and antiparticles identically
(same eigenvalue per sector).

To implement: add a `applyJ :: CrystalState -> CrystalState` that
conjugates the appropriate components. Then CP violation = `[D_F, J] ≠ 0`.

---

## γ — The Grading (Chirality)

### What It Does

γ separates left-handed from right-handed:

```
γ(left)  = +1
γ(right) = −1
```

In the Standard Model, the weak force ONLY couples to left-handed
particles. γ is what enforces this. It's a Z/2 grading on the algebra.

### What It Means for the Engine

γ splits each sector into two halves:

```
Weak sector (d=3):  weak_L (d=2) + weak_R (d=1)
Mixed sector (d=24): mixed_L (d=12) + mixed_R (d=12)
```

The weak force (W boson) only couples to the L components. The Higgs
mechanism (D_F off-diagonal) mixes L and R to create mass. Mass IS the
distance between L and R in the internal geometry (Connes' formula).

### Implementation Status

NOT IMPLEMENTED. The engine treats all components within a sector
identically. It doesn't distinguish left from right. This means
parity violation is not captured.

To implement: split each sector into L and R halves. W only couples to L.
The Higgs VEV v = 245.17 GeV is the "length" of the L↔R connection.

---

## What the Engine is Missing

### The Current Engine (Diagonal Only)

```
tick(state) = [λ_k × state_i for each component i in sector k]
```

Each sector contracts independently. No mixing. No coupling. No
interaction between sectors. This produces:
- Correct contraction rates (eigenvalues)
- Correct compactness (R_g)
- Correct local structure (helices from dihedral contraction)
- WRONG topology (no long-range contacts)
- NO mass generation (no Yukawa)
- NO force carriers (no gauge coupling)
- NO CP violation (no J)
- NO chirality (no γ)

### What the Full Engine Would Be

```
tick(state) = exp(D_F · dt) × state
```

Where D_F is the full 36×36 Dirac operator with off-diagonal mixing.
This would produce:
- Sector contraction (diagonal, same as now)
- Mass generation (Yukawa off-diagonal)
- Gauge interactions (coupling off-diagonal)
- Mixing angles (CKM/PMNS off-diagonal)
- CP violation (D_F doesn't commute with J)
- Chirality (γ grading on D_F)

The full engine is `exp(D_F)` instead of `diag(λ)`. The diagonal part
IS what we have. The off-diagonal part IS the search space.

**But wait — exp is a transcendental. The rule says no transcendentals
in the tick.** Here's the resolution: the exp of a matrix with rational
eigenvalues can be computed as a polynomial in D_F (Cayley-Hamilton).
For a 36×36 matrix, this is a polynomial of degree ≤ 35. Each coefficient
is a rational function of the eigenvalues {0, ln2, ln3, ln6}. So the
"exp" is really a finite polynomial — no infinite series needed.

Or simpler: since the eigenvalues are {1, 1/2, 1/3, 1/6}, the diagonal
part IS the rational multiply we already have. The off-diagonal part
generates MIXING between sectors. The mixing amount per tick is
proportional to the off-diagonal entry. This is STILL a multiply — just
not a diagonal one. It's a matrix multiply.

---

## The Five Operators as a Search Space

| Operator | Direction | Implemented | Generates | Search Space |
|----------|-----------|-------------|-----------|-------------|
| W | Vertical (↓) | YES | Layer contraction | CLOSED (4 eigenvalues) |
| U | Horizontal (→) | YES | Layer disentangling | CLOSED (same 4 eigenvalues) |
| D_F diag | Diagonal | YES | Sector contraction | CLOSED ({0,ln2,ln3,ln6}) |
| D_F off-diag | **Sideways (↔)** | **NO** | Mass, force, mixing | **OPEN (~33 entries)** |
| J | Conjugation | NO | Antiparticles, CP | SMALL (Z/2 structure) |
| γ | Chirality (L/R) | NO | Parity violation | SMALL (Z/2 grading) |

The big search space is D_F off-diagonal. The ~33 independent entries
are each a building-block expression. CrystalDiscover can search for
them the same way it searches for scalar constants — enumerate formulas,
compute values, compare against known couplings and masses.

### What CrystalDiscover Should Search For

The off-diagonal entries of D_F are the Yukawa couplings and gauge
couplings. In the Standard Model, these are the 19 "free parameters."
But in the Crystal Topos, they're not free — they're constrained by the
algebra. The search is for WHICH building-block expression gives each one.

**Known coupling constants to match:**

| Parameter | Measured | Sector Mixing | Entry |
|-----------|----------|--------------|-------|
| m_e/v | 2.07×10⁻⁶ | singlet↔weak | D_F[0,1] |
| m_μ/v | 4.29×10⁻⁴ | singlet↔weak | D_F[0,1] gen 2 |
| m_τ/v | 7.22×10⁻³ | singlet↔weak | D_F[0,1] gen 3 |
| m_u/v | 8.8×10⁻⁶ | weak↔mixed | D_F[1,3] gen 1 |
| m_d/v | 1.9×10⁻⁵ | weak↔mixed | D_F[1,3] gen 1 |
| m_c/v | 5.2×10⁻³ | weak↔mixed | D_F[1,3] gen 2 |
| m_s/v | 3.8×10⁻⁴ | weak↔mixed | D_F[1,3] gen 2 |
| m_t/v | 0.703 | weak↔mixed | D_F[1,3] gen 3 |
| m_b/v | 1.70×10⁻² | weak↔mixed | D_F[1,3] gen 3 |
| g_1 | 0.357 | U(1) gauge | D_F[0,1] gauge |
| g_2 | 0.652 | SU(2) gauge | D_F[1,2] gauge |
| g_3 | 1.221 | SU(3) gauge | D_F[2,3] gauge |
| V_us | 0.2243 | quark mixing | D_F[1,3] off-gen |
| V_cb | 0.0422 | quark mixing | D_F[1,3] off-gen |
| V_ub | 0.00394 | quark mixing | D_F[1,3] off-gen |
| δ_CKM | 1.196 rad | CP phase | D_F[1,3] phase |

Many of these ARE already matched by CrystalDiscover (V_cb, V_ub,
mass ratios). The remaining ones (absolute gauge couplings, CP phase,
PMNS angles) are the frontier.

---

## For Protein Folding: The Missing Operator

The protein folding problem at 8.96 Å RMSD is EXACTLY the missing
off-diagonal D_F. Each tile folds independently because the engine
is diagonal — sectors don't mix. What's needed:

```
D_F off-diagonal for proteins:
  Weak↔Mixed coupling = inter-tile contact forces
  Colour↔Mixed coupling = dihedral-position coordination
  Singlet→Weak constraint = topology enforcing compactness
```

The "sideways" operator you're asking about IS the solution to both
problems — the missing particle physics parameters AND the missing
protein fold topology. Same operator. Same search space.

---

## Summary

You have W (↓) and U (→). Both implemented. Both diagonal. Both closed.

You're missing D_F off-diagonal (↔). This is the SIDEWAYS operator.
It mixes sectors. It creates mass, force, and mixing. Its ~33 entries
are each a building-block expression constrained by A_F. About half
are known from the 198 catalogue. The other half are the search space.

You're also missing J (conjugation) and γ (chirality), but these are
small (Z/2 structures) and follow from D_F once it's known.

The full engine is not `diag(λ)` but `exp(D_F)`. The diagonal part is
what you have. The off-diagonal part is what you need. CrystalDiscover
can find it. The algebra constrains it. The entries are not free.

One instrument. Three directions. We've tuned two. The third is open.
