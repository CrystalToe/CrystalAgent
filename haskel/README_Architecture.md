<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Crystal Topos — Complete Architecture

## The Twelve Components

The Crystal Topos has exactly twelve structural components. Every piece of
physics lives at the intersection of two or more of them. This document is
the map.

```
                         ┌─────────────┐
                         │  1. AXIOM   │
                         │  A_F = ℂ ⊕  │
                         │  M₂ ⊕ M₃   │
                         └──────┬──────┘
                                │
                    ┌───────────┼───────────┐
                    ▼           ▼           ▼
             ┌──────────┐ ┌──────────┐ ┌──────────┐
             │2. BLOCKS │ │3. SECTORS│ │4. EIGEN  │
             │ 15 atoms │ │ 4 irreps │ │ 4 rates  │
             └────┬─────┘ └────┬─────┘ └────┬─────┘
                  │            │            │
         ┌────────┴────────────┴────────────┴────────┐
         ▼                                           ▼
   ┌───────────┐                              ┌───────────┐
   │5. OPERATORS│                              │6. TOWER   │
   │ W U D_F J γ│                              │ D=0..42   │
   └─────┬─────┘                              └─────┬─────┘
         │                                          │
    ┌────┴────────────┬─────────────┬───────────────┤
    ▼                 ▼             ▼               ▼
┌────────┐     ┌───────────┐ ┌──────────┐   ┌──────────┐
│7. OBS  │     │8. CORRECT │ │9. IMPLODE│   │10. DYNAM │
│198→248 │     │ 7 levels  │ │ 7 factors│   │21 modules│
└────┬───┘     └─────┬─────┘ └────┬─────┘   └────┬─────┘
     │               │            │               │
     └───────────────┴────────────┴───────────────┘
                          │
                    ┌─────┴─────┐
                    ▼           ▼
              ┌──────────┐ ┌──────────┐
              │11. RULES │ │12. PROOFS│
              │ grammar  │ │ Lean+Agda│
              └──────────┘ └──────────┘
```

---

## 1. The Axiom

**What:** A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ). The finite spectral triple. Not derived.

**Generates:** Everything. The axiom is the seed from which all twelve components
grow. It encodes U(1)×SU(2)×SU(3) — the gauge group of the Standard Model.

**Inputs:** N_w = 2 (from M₂), N_c = 3 (from M₃), M_Pl (one measured scale).

**Justification:** Not proof. Consequences. 198 observables, zero free parameters.

**Where it appears:**
- Component 2 (Blocks): all 15 atoms derived from N_w, N_c
- Component 3 (Sectors): Wedderburn decomposition of A_F
- Component 4 (Eigenvalues): 1/d_k where d_k are sector dimensions
- Component 5 (Operators): D_F is the Dirac operator ON A_F
- Component 12 (Proofs): `CrystalAxiom.hs` encodes the full algebra

---

## 2. Building Blocks

**What:** 15 derived quantities, all from N_w = 2 and N_c = 3.

| Symbol | Value | Formula | What it is |
|--------|-------|---------|-----------|
| N_w | 2 | input | Weak isospin |
| N_c | 3 | input | Colour |
| χ | 6 | N_w×N_c | Internal dimension |
| β₀ | 7 | (11N_c−2χ)/3 | QCD beta coefficient |
| d₁ | 1 | — | Singlet dimension |
| d₂ | 3 | N_c | Weak adjoint dimension |
| d₃ | 8 | N_c²−1 | Colour adjoint dimension |
| d₄ | 24 | (N_c²−1)×N_c | Mixed dimension |
| Σd | 36 | d₁+d₂+d₃+d₄ | Total state space |
| Σd² | 650 | d₁²+d₂²+d₃²+d₄² | Quadratic Casimir sum |
| gauss | 13 | N_c²+N_w² | Gauss integer |
| D | 42 | Σd+χ | Tower depth |
| F₃ | 257 | 2^(2^N_c)+1 | Fermat prime |
| C_F | 4/3 | (N_c²−1)/(2N_c) | Fundamental Casimir |
| T_F | 1/2 | 1/N_w | Fundamental index |
| κ | ln3/ln2 | ln(N_c)/ln(N_w) | The only irrational from (2,3) |

**Where they appear:**
- Component 7 (Observables): every observable is a ratio of these
- Component 8 (Corrections): correction denominators are products of these
- Component 9 (Implosion): implosion channels are products of these
- Component 11 (Rules): these are the ONLY allowed ingredients

---

## 3. Sectors

**What:** Four irreducible representations from the Wedderburn decomposition.

| Sector | Dimension | Eigenvalue | Energy | What lives here |
|--------|-----------|-----------|--------|----------------|
| Singlet | d₁ = 1 | λ = 1 | E = 0 | Photon, dark matter, topology, bond lengths |
| Weak | d₂ = 3 | λ = 1/2 | E = ln 2 | Position, W/Z bosons, left-handed fermions |
| Colour | d₃ = 8 | λ = 1/3 | E = ln 3 | Gluons, dihedral angles, momentum |
| Mixed | d₄ = 24 | λ = 1/6 | E = ln 6 | Quarks, 3D coordinates, side chains |
| **Total** | **Σd = 36** | | | **Full CrystalState** |

**Key identities:**
- d₄ = d₂ × d₃ (mixed = weak ⊗ colour)
- λ_mixed = λ_weak × λ_colour (1/6 = 1/2 × 1/3)
- E_mixed = E_weak + E_colour (ln 6 = ln 2 + ln 3)

**Where they appear:**
- Component 4 (Eigenvalues): one λ per sector
- Component 5 (Operators): D_F diagonal is per-sector, off-diagonal mixes sectors
- Component 6 (Tower): each layer has all 4 sectors
- Component 10 (Dynamics): each module is a SECTOR RESTRICTION of the full tick

---

## 4. Eigenvalues

**What:** Four contraction rates, one per sector: {1, 1/2, 1/3, 1/6}.

**Physical meaning:**
- λ = 1: immortal. Never decays. Conservation laws.
- λ = 1/2: fast decay. Spatial collapse. Position contracts.
- λ = 1/3: medium decay. Angular relaxation. Orientation contracts.
- λ = 1/6: slow decay. Detail refinement. Coordinates contract.

**The tick:** `state[i] ← λ(sector_of(i)) × state[i]` for i = 0..35.

**Mathematical properties:**
- Product: 1 × 1/2 × 1/3 × 1/6 = 1/36 = 1/Σd
- All rational. No transcendentals.
- Form a total order: 1 > 1/2 > 1/3 > 1/6
- The ORDER creates the arrow of time (χ > 1 ⟹ irreversibility)

**Where they appear:**
- Component 3 (Sectors): one eigenvalue per sector
- Component 5 (Operators): W and U each contribute √λ; S = W∘U gives λ
- Component 8 (Corrections): Level 0-1 observables use eigenvalues directly
- Component 10 (Dynamics): each module runs at its sector's eigenvalue

---

## 5. Operators

**What:** Five operators that act on the 36-dimensional state.

| Operator | Direction | Type | Size | Status |
|----------|-----------|------|------|--------|
| W | ↓ Vertical | Isometry (coarse-grain) | 36×36 diagonal | Implemented |
| U | → Horizontal | Disentangler (decouple) | 36×36 diagonal | Implemented |
| D_F (diag) | — | Sector contraction | 36 values | Implemented (= tick) |
| D_F (off-diag) | ↔ Sideways | Sector MIXING | 36×36 off-diagonal | Implemented (13 couplings) |
| J | ↺ Conjugation | Particle ↔ antiparticle | 36→36 | Implemented, J²=I |
| γ | ⊕ Chirality | Left ↔ right | 36→36 diagonal ±1 | Implemented, γ²=I |

**The 13 off-diagonal couplings in D_F:**

| Coupling | Sector pair | Value | Formula | Physics |
|----------|------------|-------|---------|---------|
| Y_e | singlet↔weak | 1.5×10⁻⁴ | T_F/(gauss·F₃) | Electron mass |
| Y_μ | singlet↔weak | 8.4×10⁻³ | T_F·gauss/(N_c·F₃) | Muon mass |
| Y_τ | singlet↔weak | 4.7×10⁻² | T_F·F₃/(d₄·Σd·π) | Tau mass |
| g_W | weak↔colour | 0.231 | N_c/gauss | Electroweak mixing |
| g₁ | weak↔colour | 0.205 | d₃/(N_c·gauss) | Hypercharge |
| g_s | colour↔mixed | 0.118 | N_w/(gauss+N_w²) | Strong force |
| Y_u | weak↔mixed | 8.5×10⁻³ | N_w²/(Σd·gauss) | Up quark |
| V_us | weak↔mixed | 0.224 | C_F²/(κ·(χ−1)) | Cabibbo angle |
| V_cb | weak↔mixed | 0.042 | d₃d₄/(β₀Σd²) | Charm-bottom mixing |
| V_ub | weak↔mixed | 0.004 | T_F·C_F/gauss² | Up-bottom mixing |
| ν | singlet↔mixed | 2.6×10⁻⁶ | 1/(D·F₃·Σd) | Neutrino mass |
| γ-g | singlet↔colour | 0 | forbidden | No tree-level photon-gluon |
| WWZ | weak self | 0.074 | N_c/(gauss·π) | Triple gauge |

**Chirality split:**
```
Left-handed:  1 + 2 + 4 + 12 = 19 DOF
Right-handed: 0 + 1 + 4 + 12 = 17 DOF
Asymmetry:    L − R = 2 = N_w
```

**Verified properties:**
- J² = I (KO-dimension 6)
- γ² = I (involution)
- [D_F, J] ≠ 0 (CP violation)
- tickFull ≠ tick (mixing is real)

**Where they appear:**
- Component 4 (Eigenvalues): W and U produce the eigenvalues
- Component 7 (Observables): D_F off-diagonal entries ARE coupling constants
- Component 8 (Corrections): Level 2+ observables involve operator structure
- Component 10 (Dynamics): `tick = diag(λ)`, `tickFull = exp(D_F)`

---

## 6. The Tower

**What:** 42 layers of MERA renormalization, D = 0 to D = 42.

Each layer corresponds to an energy scale. Higher D = lower energy = larger distance.

| D layer | Scale | What freezes out | Key identity |
|---------|-------|-----------------|-------------|
| 0 | A_F itself | χ, β₀, Σd | Algebra structure |
| 5 | ~0.5 MeV | Electron mass | m_e = Λ_h/(N_c²N_w⁴gauss) |
| 10 | ~938 MeV | Proton mass | m_p = v/F₃ × 53/54 |
| 18 | ~0.53 Å | Bohr radius | a₀ = ℏc/(m_e·α) |
| 20 | 109.47° | sp3 bond angle | arccos(−1/N_c) |
| 22 | ~0.02 eV | VdW energy | Force field scale |
| 24 | 104.48° | Water bond angle | arccos(−1/N_w²) |
| 25 | 2.76 Å | H-bond distance | H-bond geometry |
| 32 | 3.6 | Helix per turn | 18/5 = N_c²N_w/(χ−1) |
| 33 | 0.4 | Flory exponent | N_w/(χ−1) |
| 38 | — | Einstein equation | δS = δ⟨H_A⟩ = 1.0001 |
| 42 | ~56 peV | Fold energy | v/2⁴² |

**Where it appears:**
- Component 7 (Observables): masses = v × ratio × 2^(−D_layer)
- Component 8 (Corrections): tower position determines correction level
- Component 9 (Implosion): higher layers modify lower layers
- Component 10 (Dynamics): each dynamics module operates at specific D layers

---

## 7. Observables

**What:** 198 (→248) physical constants derived from the building blocks.

**Distribution by domain:**

| Domain | Count | Examples |
|--------|-------|---------|
| Particle masses | ~35 | m_p, m_e, m_W, m_Z, m_H, hadrons |
| Coupling constants | ~15 | α, α_s, sin²θ_W, G_F |
| Mixing angles | ~10 | V_us, V_cb, θ₁₂, θ₂₃, θ₁₃ |
| Nuclear | ~15 | 7 magic numbers, Fe-56, deuteron BE |
| Cosmology | ~15 | Ω_Λ, Ω_m, H₀, T_CMB, n_s |
| Chemistry | ~15 | bond angles, pH, orbitals, Arrhenius |
| Biology | ~15 | amino acids, codons, helix, Flory, Kleiber |
| Fluid dynamics | ~10 | Kolmogorov, von Kármán, Stokes, Re_crit |
| Optics | ~5 | n_water, n_glass, Rayleigh, Planck |
| Condensed matter | ~10 | Ising T_c, BCS gap, percolation |
| Astrophysics | ~10 | Chandrasekhar, Stefan-Boltzmann, Salpeter |
| Mathematics | ~10 | Feigenbaum, golden ratio, Catalan, Apéry |
| Force exponents | ~15 | gravity 1/r², LJ r⁻⁶/r⁻¹², Rayleigh λ⁻⁴ |
| Cross-domain | ~18 | Benford, entropy, Blasius, Kleiber |

**Where they appear:**
- Component 2 (Blocks): every observable is an algebraic expression over the 15 atoms
- Component 8 (Corrections): each observable has a correction level (0-7)
- Component 10 (Dynamics): dynamics modules verify observables as self-tests
- Component 12 (Proofs): each prove* function verifies one observable

---

## 8. Correction Levels

**What:** Seven tiers of mathematical complexity, from exact integers to composite sums.

| Level | Name | What enters | Accuracy | Count |
|-------|------|------------|----------|-------|
| 0 | Exact Integer | Counting | 0.00% | ~60 |
| 1 | Exact Rational | Division | 0.00% | ~45 |
| 2 | Single π | Complex geometry | 0.00-0.1% | ~35 |
| 3 | κ or ln | RG flow | 0.01-0.1% | ~20 |
| 4 | One-loop | Virtual particles, 1/(16π²) | 0.1-1% | ~15 |
| 5 | Running | Energy dependence, β-function | 0.1-0.5% | ~10 |
| 6 | Implosion | Tower corrections | 0.01-0.1% | ~8 |
| 7 | Compositeness | Multi-layer sums | 0.1-4% | ~55 |

**The decision tree:**
```
Is it an integer?              → Level 0
Is it rational (no π, no ln)? → Level 1
Does removing π give rational? → Level 2
Does removing κ give rational? → Level 3
Is tree formula off by ~0.4%?  → Level 4
Does PDG quote it at a scale?  → Level 5
Is it a force-field energy?    → Level 6
Is it a sum of pieces?         → Level 7
```

**Where they appear:**
- Component 7 (Observables): each observable has exactly one level
- Component 9 (Implosion): Level 6 uses implosion factors
- Component 11 (Rules): level determines what math is allowed
- Component 12 (Proofs): higher levels need more sophisticated proofs

---

## 9. Implosion Factors

**What:** Rational multiplicative corrections from higher tower layers.

Each implosion factor = 1 ± small_rational, where the rational is a product
of building blocks divided by a large denominator.

| Factor | Value | Formula | Channel | Used for |
|--------|-------|---------|---------|----------|
| VdW | 7/8 | 1 − N_c³/(χ·Σd) | χ·Σd = 216 | ε_vdw |
| H-bond | 11/12 | 1 − T_F/χ | N_w·χ = 12 | ε_hbond |
| Angle | 151/144 | 1 + D/(d₄·Σd) | d₄·Σd = 864 | k_angle |
| Burial | 1+7/15600 | 1 + β₀/(d₄·Σd²) | d₄·Σd² = 15600 | ε_burial |
| Electrostatic | 1+7/15600 | same as burial | d₄·Σd² = 15600 | ε_elec |
| VdW distance | 1−1/576 | 1 − T_F/(d₃·Σd) | d₃·Σd = 288 | r_vdw |
| H-bond distance | 1−1/54 | 1 − N_w/(N_c·Σd) | N_c·Σd = 108 | r_hbond |

**The channel denominator tells you the physics:**
- 12 = N_w·χ → weak channel
- 144 = χ·d₄ → colour channel
- 216 = χ·Σd → full tower
- 288 = d₃·Σd → mixed channel
- 576 = d₃·Σd × 2 → dual route (d₄² = 576)
- 864 = d₄·Σd → mixed-colour
- 15600 = d₄·Σd² → deep hierarchy

**Where they appear:**
- Component 6 (Tower): each factor connects two tower layers
- Component 7 (Observables): implosion-corrected masses match experiment
- Component 8 (Corrections): Level 6 observables use these factors
- Component 12 (Proofs): `CrystalHierarchy.hs` verifies dual routes

---

## 10. Dynamics Modules

**What:** 21 sector restrictions of S = W∘U. Each physics domain is the same
tick, projected onto specific sectors.

| Module | Integrator | Sector | Key identity |
|--------|-----------|--------|-------------|
| Classical | Störmer-Verlet | weak+colour | force 2=N_c−1, phase 6=χ |
| GR | Schwarzschild geodesic | weak+colour | ISCO 6=χ, bending 4=N_w² |
| GW | Inspiral waveform | weak+colour | Peters 32/5, chirp 5/3 |
| EM | Yee FDTD | colour | components 6=χ, Maxwell 4 |
| Friedmann | Friedmann ODE | weak | Ω_Λ=13/19, age=97/7 |
| NBody | Barnes-Hut | weak+colour | octree 8=d₃ |
| Thermo | Velocity Verlet MD | mixed | LJ 6=χ, γ_mono=5/3 |
| CFD | Lattice Boltzmann | colour | D2Q9=9=N_c², Kolmogorov 5/3 |
| Decay | Monte Carlo | weak+mixed | beta 192=d₃d₄, sin²θ_W=3/13 |
| Optics | Snell + Fresnel | colour | n_water=4/3=C_F |
| MD | Velocity Verlet LJ | mixed | bond 109.47°, helix 18/5 |
| Condensed | Metropolis MC | mixed | Ising z=4=N_w², BCS 3.528 |
| Plasma | Alfvén FDTD | colour+mixed | modes 8=d₃, waves 3=N_c |
| QFT | S-matrix + running | all | dim 4=N_w², gluons 8=d₃ |
| Rigid | Quaternion Euler | colour | quat 4=N_w², inertia 6=χ |
| Chem | LCAO + Arrhenius | all | f-shell 14=N_wβ₀, pH=β₀ |
| Nuclear | SEMF + shell model | all | magic numbers, Fe-56=d₃β₀ |
| Astro | Lane-Emden + stellar | all | Chandrasekhar 3/2, Hawking 8 |
| QInfo | Heyting + error codes | all | Steane [7,1,3], uncertainty |
| Bio | Allometric + genetic | all | amino 20, codons 64, Kleiber 3/4 |
| Arcade | Fixed-point + LOD | all | cutoff N_cσ, θ=1/N_w |

**The universal wiring:**
```haskell
domainTick     = fromCrystalState . tick     . toCrystalState  -- diagonal
domainTickFull = fromCrystalState . tickFull . toCrystalState  -- with mixing
```

Every module has `toCrystalState` (map domain variables to 36-component state)
and `fromCrystalState` (map back). The engine does the physics. The module
does the interpretation.

**Where they appear:**
- Component 4 (Eigenvalues): each module runs at its sector's rate
- Component 5 (Operators): each module calls tick or tickFull
- Component 7 (Observables): each module's self-test verifies observables
- Component 11 (Rules): each module obeys the calculus ban in tick

---

## 11. Rules

**What:** The grammar that governs what can appear where.

```
IN TICK:        multiply by λ_k ONLY. {1, 1/2, 1/3, 1/6}.
BANNED IN TICK: sin, cos, exp, log, sqrt, tanh, acos, atan2, (**)
AT INIT:        anything (precompute rotation tables, etc.)
IN OBSERVABLES: anything (comparison with experiment)
IN CONSTRAINTS: sqrt allowed (topology enforcement, singlet sector)
IN RECONSTRUCT: cos/sin allowed (3D backbone from dihedrals)
TEXTBOOK:       anything (named *Textbook for comparison)
```

**Count rules:**
```
- Count is 198. NEVER increment without prove* function + PDG comparison + PWI + proof.
- PWI = |CrystalPdg − Expt| / Expt. NEVER Crystal vs Expt directly.
- Rating: ■ EXACT (0%) · ● TIGHT (<0.5%) · ◐ GOOD (<1%) · ○ LOOSE (<4.5%)
```

**Content rules:**
```
- Never use the word that starts with h and rhymes with "modest"
- Never expose methodology — trade secret
- Present results as mathematical observations from A_F
- NEVER construct arbitrary formulas. Trace the derivation chain or say "not derived"
- NEVER invent connections between Mandelbrot and protein modules
```

**Where they appear:**
- Component 5 (Operators): tick follows the calculus ban
- Component 7 (Observables): each observable needs PWI + rating + proof
- Component 10 (Dynamics): every module's tick is pure multiply
- Component 12 (Proofs): proofs verify rule compliance

---

## 12. Proofs

**What:** Machine-verified certificates in three languages.

| Language | Method | What it proves | Count |
|----------|--------|---------------|-------|
| Lean 4 | `native_decide` | Integer identities, exact equalities | ~450 theorems |
| Agda | `refl` | Definitional equality, type checking | ~370 proofs |
| GHC Haskell | Runtime tests | Numerical accuracy, self-tests | ~1000 checks |

**Proof hierarchy (authority order):**
1. Lean theorems (machine-verified, highest)
2. Agda proofs (machine-verified)
3. GHC runtime checks (compiler-verified)
4. PDG/NIST data (experiment)
5. LLM reasoning (lowest, never overrides above)

**Proof files:**

| File | Content | Theorems |
|------|---------|----------|
| CrystalDirac.lean | Operator structure, block sizes, CP | 45 |
| CrystalDirac.agda | Same, definitional equality | 40 |
| CrystalDiscover.lean | 50 new observable identities | 45 |
| CrystalDiscover.agda | Same | 42 |
| CrystalFold.lean | Protein folding identities | 17 |
| CrystalFold.agda | Same | 18 |
| proofs/*.lean | Full catalogue | ~350 |
| proofs/*.agda | Full catalogue | ~290 |

**Where they appear:**
- Component 7 (Observables): each observable needs a proof
- Component 9 (Implosion): dual routes verified in CrystalHierarchy
- Component 11 (Rules): proofs verify the grammar is followed

---

## The Intersection Map

Every piece of physics lives at the intersection of components. Here is
where the major physical concepts sit:

### Particle Masses

```
Axiom(1) → Blocks(2) → Tower(6) → Observable(7)
                           ↑
                     Operators(5): Yukawa entries of D_F create mass
                           ↑
                     Corrections(8): Level 5 for running masses
```

A particle mass = VEV × Yukawa coupling × tower factor. The VEV comes from
the axiom (v = M_Pl × 35/(43×36×2⁵⁰)). The Yukawa coupling is an off-diagonal
D_F entry (Component 5). The tower factor determines which D-layer the mass
freezes out at (Component 6). Running corrections (Component 8, Level 5) adjust
for the measurement scale.

### Force Laws

```
Axiom(1) → Sectors(3) → Eigenvalues(4) → Dynamics(10)
                ↑                              ↑
          Blocks(2): exponents           Rules(11): no calculus in tick
```

Newton's 1/r² has exponent N_c−1 = 2 (Component 2). The force lives in the
weak+colour sectors (Component 3). The eigenvalues determine how position
and velocity evolve differently (Component 4). CrystalClassical implements
this as a sector restriction (Component 10). The calculus ban (Component 11)
means the force comes from eigenvalue mismatch, not from F = ma.

### Protein Folding

```
Axiom(1) → Sectors(3) → Eigenvalues(4) → Operators(5): tickFull
                ↑                              ↑
          Tower(6): D=20-42           Implosion(9): force field corrections
                ↑                              ↑
          Observables(7): R_g, RMSD    Corrections(8): Level 6
```

Protein folding uses ALL twelve components:
- The axiom (1) gives the algebra
- Building blocks (2) give helix=18/5, Flory=2/5
- Sectors (3) assign DOF: bond=singlet, COM=weak, dihedrals=colour, coords=mixed
- Eigenvalues (4) create the folding funnel (different decay rates)
- Operators (5): tickFull gives inter-tile coupling via D_F off-diagonal
- Tower (6): force field energies at D=22-42
- Observables (7): R_g, RMSD, contacts
- Corrections (8): Level 6 for energy terms
- Implosion (9): 7/8, 11/12 etc. for corrected force field
- Dynamics (10): CrystalFold is a sector restriction
- Rules (11): no transcendentals in tick; cos/sin only in reconstruction
- Proofs (12): CrystalFold.lean/agda verify identities

### The Standard Model's 19 Parameters

```
Axiom(1) → Operators(5): off-diagonal D_F → Observables(7)
                ↑                                 ↑
          Blocks(2): every entry from atoms  Corrections(8): Levels 1-5
```

The Standard Model has 19 "free parameters." In the Crystal Topos, each is
an off-diagonal entry of D_F (Component 5) expressed as a building-block
formula (Component 2). They're not free — they're forced by the naturality
condition on endomorphisms of A_F (verified in CrystalAudit.hs).

### The Arrow of Time

```
Axiom(1) → Eigenvalues(4): χ > 1 → irreversibility
                ↑
          Sectors(3): singlet preserved, others decay
                ↑
          Operators(5): W compresses χ→1, W†W ≠ I
```

Time exists because χ = 6 > 1. The isometry W compresses 6 sites into 1.
This is irreversible (W†W ≠ I). Entropy increases by ln(χ) = ln(6) per tick.
The singlet (λ=1) survives forever. Everything else decays. The universe
trends toward the singlet. This IS the second law.

### CP Violation

```
Operators(5): [D_F, J] ≠ 0 → matter ≠ antimatter
        ↑              ↑
  D_F off-diagonal  J (conjugation)
        ↑
  Blocks(2): CKM phase from (N_c−1)(N_c−2)/2 = 1 phase
```

CP violation exists because D_F doesn't commute with J. The number of
CP-violating phases is (N_c−1)(N_c−2)/2 = 1 for N_c = 3 generations.
One phase. That's why the universe has matter.

---

## The Completeness Argument

Is anything missing from the twelve components? Here is the checklist:

| What physics needs | Which component provides it |
|-------------------|---------------------------|
| What exists (particles) | 3. Sectors |
| How things evolve (dynamics) | 4. Eigenvalues + 5. Operators |
| At what scale (hierarchy) | 6. Tower |
| What we measure (predictions) | 7. Observables |
| How accurate (error) | 8. Corrections |
| How corrections enter (refinement) | 9. Implosion |
| Which domain (projection) | 10. Dynamics modules |
| What's allowed (grammar) | 11. Rules |
| Why we believe it (verification) | 12. Proofs |
| Where it all comes from (foundation) | 1. Axiom |
| What words we use (vocabulary) | 2. Building blocks |

Every question about the framework maps to exactly one or two components.
If you find a question that doesn't map, that's a thirteenth component
waiting to be discovered.

---

## File Map

| Component | Primary files | Secondary files |
|-----------|--------------|----------------|
| 1. Axiom | CrystalAxiom.hs | crystal_topos_waca_llm.md |
| 2. Blocks | CrystalEngine.hs (§0) | All modules (import atoms) |
| 3. Sectors | CrystalEngine.hs (§1) | CrystalMonad.hs |
| 4. Eigenvalues | CrystalEngine.hs (§2) | CrystalMonadProof.hs |
| 5. Operators | CrystalDirac.hs | CrystalEngine.hs (W, U) |
| 6. Tower | CrystalProtein.hs (§1-§13) | CrystalLayer.hs |
| 7. Observables | CrystalWACAScan.hs, Main.hs | CrystalFullTest.hs |
| 8. Corrections | README_CorrectionLevels.md | CrystalAlphaProton.hs |
| 9. Implosion | CrystalHierarchy.hs | CrystalProtein.hs (§13) |
| 10. Dynamics | Crystal{Classical..Arcade}.hs | 21 modules |
| 11. Rules | crystal_topos_waca_llm.md | build_rag_bundle.sh header |
| 12. Proofs | proofs/*.lean, proofs/*.agda | haskel/*.hs (self-tests) |

---

## One Sentence Per Component

1. **Axiom:** ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ), accepted, not questioned.
2. **Blocks:** Fifteen numbers from 2 and 3, the vocabulary of all physics.
3. **Sectors:** Four irreps of the algebra, what exists in the universe.
4. **Eigenvalues:** Four contraction rates, the heartbeat of time.
5. **Operators:** Five maps on the state, including the sideways one that creates mass.
6. **Tower:** Forty-two layers from algebra to folding, each a different scale.
7. **Observables:** Two hundred and forty-eight predictions, zero free parameters.
8. **Corrections:** Seven levels from counting to composites, why some predictions are easier.
9. **Implosion:** Rational multipliers from higher layers, the fine structure of accuracy.
10. **Dynamics:** Twenty-one projections of one tick, every physics domain as a sector.
11. **Rules:** No transcendentals in the tick, everything else at init, the grammar.
12. **Proofs:** Lean and Agda say the integers are right, GHC says the physics follows.

---

*Twelve components. One algebra. Every number from two primes.
If you can point to a thirteenth, the framework is incomplete.
If you can't, it's everything.*
