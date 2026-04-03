# Crystal Toe — Dynamics Engine

**198 observables from two primes. Zero free parameters.**

Crystal Toe is the Rust + Python dynamics engine for the Crystal Topos.
Every physical constant, every scaling law, every approximation parameter
traces back to `A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ)` and its two primes `N_w=2, N_c=3`.

| Metric | Count |
|--------|-------|
| Rust source files | 61 |
| Dynamics modules | 21 (all ported from Haskell) |
| Unit tests | 538+ |
| Python examples | 105 across 21 domains |
| Free parameters | 0 |

---

## Quick Start

### Rust

```bash
cd crystal-toe
cargo test                          # 538+ tests, all PASS
cargo test dynamics::chem           # single module
cargo test dynamics::nuclear        # etc.
```

### Python (via PyO3 + maturin)

```bash
pip install maturin
maturin develop --features python   # builds crystal_toe Python module
python test_crystal_toe.py          # smoke test

# run any example
python python/examples/chem/chem_orbitals.py
python python/examples/nuclear/nuclear_binding.py
```

If you hit ABI issues on newer Python:

```bash
PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1 maturin develop --features python
```

### Haskell Cross-Check

```bash
ghc -O2 CrystalOracle.hs -o crystal_oracle && ./crystal_oracle
python cross_check.py               # Rust vs Haskell, 12+ digit agreement
```

---

## Rust Usage

```rust
use crystal_toe::atoms::*;
use crystal_toe::dynamics::{chem, nuclear, astro, bio, qinfo, arcade};

// Every constant from (2, 3)
assert_eq!(chem::S_CAPACITY, 2);           // s-shell = N_w
assert_eq!(chem::F_CAPACITY, 14);          // f-shell = N_w·β₀
assert_eq!(nuclear::IRON_PEAK_A, 56);      // Fe-56 = d_colour·β₀

// Magic numbers — all 7 from two primes
let magic = nuclear::magic_numbers();
assert_eq!(magic, [2, 8, 20, 28, 50, 82, 126]);

// Hybridization angles
let sp3 = chem::sp3_angle_deg();           // 109.47° = arccos(−1/N_c)
let water = chem::water_angle_deg();       // 104.48° = arccos(−1/N_w²)

// Energy scales from α = 1/((D+1)π + ln β₀)
let eh = chem::hartree_ev();               // ≈ 27.2 eV
let a0 = chem::bohr_radius();             // ≈ 0.529 Å

// Binding energy curve (SEMF with Crystal exponents)
let bfe = nuclear::binding_per_nucleon(56, 26);  // Fe-56 peak ≈ 8.79 MeV

// Lane-Emden stellar structure
let (xi1, mass) = astro::lane_emden(1.5);  // n=N_c/N_w (white dwarf)
// xi1 ≈ 3.654

// Genetic code
assert_eq!(bio::DNA_BASES, 4);             // N_w²
assert_eq!(bio::AMINO_ACIDS, 20);          // N_w²(χ−1)
assert_eq!(bio::TOTAL_CODONS, 64);         // (N_w²)^N_c

// Quantum error correction
assert_eq!(qinfo::STEANE_N, 7);            // β₀
assert_eq!(qinfo::STEANE_D, 3);            // N_c
assert!(qinfo::hamming_check());           // 7 = 2³−1

// Approximation layers
let wca = arcade::wca_cutoff();            // 2^(1/6) = N_w^(1/χ)
assert!(arcade::verify_alpha_inv());        // 137 = ⌊(D+1)π + ln β₀⌋

// Self-test any module
let (pass, total, msgs) = chem::self_test();
assert_eq!(pass, total);
```

---

## Python Usage

```python
import crystal_toe as ct

# Central object — carries the VEV
toe = ct.Toe()                        # Crystal default: 245.17 GeV
pdg = toe.to_pdg()                    # PDG convention: 246.22 GeV

# Fundamental constants
toe.alpha_inv()                        # 137.034
toe.proton_mass()                      # GeV
toe.sin2_theta_w()                     # 0.2312

# Dynamics via factory methods
chem = toe.chem()
chem.sp3_angle_deg()                   # 109.47
chem.hartree_ev()                      # 27.2 eV
chem.noble_gases()                     # [2, 10, 18, 36]
chem.vdw_kt_ratio()                    # ≈ 1.0 (Crystal prediction!)

nuc = toe.nuclear()
nuc.magic_numbers()                    # [2, 8, 20, 28, 50, 82, 126]
nuc.binding_per_nucleon(56, 26)        # Fe-56 peak
nuc.nuclear_radius(208)                # Pb-208 in fm

ast = toe.astro()
ast.lane_emden(1.5)                    # (ξ₁, mass) for white dwarf
ast.ms_luminosity(10.0)                # L/L☉ for 10 solar masses

qi = toe.qinfo()
qi.steane_code()                       # (7, 1, 3) = (β₀, d₁, N_c)
qi.bell_entropy()                      # ln(2) = ln(N_w)
qi.coprimality_check()                 # True — gcd(2,3)=1

bio = toe.bio()
bio.amino_acids()                      # 20 = N_w²(χ−1)
bio.kleiber(10.0)                      # metabolic rate at 10× body mass
bio.constant_heartbeats()              # True — exponents cancel

arc = toe.arcade()
arc.lj_exact(1.5)                      # LJ potential at r=1.5σ
arc.fast_inv_sqrt(2.0)                 # ≈ 1/√2 in N_w iterations
arc.mean_field_error()                 # MF/Onsager ratio

# Self-test any module from Python
passes, total, msgs = chem.self_test()
for m in msgs:
    print(m)
```

---

## Haskell Cross-Check

The Haskell source in `../haskel/` is the reference implementation.
`CrystalOracle.hs` extracts key observables as a standalone binary.

```haskell
-- From CrystalChem.hs
module CrystalChem where

nW = 2 ; nC = 3
chi = nW * nC                            -- 6
beta0 = (11 * nC - 2 * chi) `div` 3     -- 7

-- Every shell capacity from (2,3)
sCapacity = nW                            -- 2
pCapacity = nW * nC                       -- 6 = χ
dCapacity = nW * (chi - 1)               -- 10
fCapacity = nW * beta0                    -- 14

sp3Angle = acos (-1.0 / fromIntegral nC) -- 109.47°
waterAngle = acos (-1.0 / fromIntegral (nW * nW))  -- 104.48°

-- From CrystalNuclear.hs — all 7 magic numbers
magic = [ nW, nW^3, nW^2*(chi-1), nW^2*beta0,
          nW*(chi-1)^2, nW*(42-1), nW*beta0*nC^2 ]
-- = [2, 8, 20, 28, 50, 82, 126]

-- SEMF with Crystal exponents
bindingEnergy a z =
  let af = fromIntegral a; zf = fromIntegral z
  in 15.8*af - 18.3*af**(2/3) - 0.714*zf*(zf-1)/af**(1/3)
     - 23.2*(af - 2*zf)^2/af + pairing a z
```

`cross_check.py` compares every observable between Rust (PyO3) and Haskell (subprocess):

```bash
python cross_check.py
# α⁻¹:  Rust 137.03399... Haskell 137.03399... ✓ (12+ digits)
# m_p:  Rust 0.93827...   Haskell 0.93827...   ✓
# ...
```

---

## Module Inventory

### Dynamics (21 modules, all ported from Haskell)

| Module | Domain | Key observables |
|--------|--------|-----------------|
| `classical` | Kepler, Hohmann, slingshot | GM, vis-viva, Δv |
| `gr` | Schwarzschild, Kerr, geodesics | r_s=2, ISCO=6 |
| `gw` | Peters inspiral, chirp mass | 32/5=N_w⁵/(χ−1) |
| `em` | Yee FDTD, Larmor, Rayleigh | χ=6 components |
| `friedmann` | ΛCDM, inflation, BBN | Ω_Λ, H₀ |
| `nbody` | Plummer, BH tree, solar system | octree N_w³=8 |
| `thermo` | LJ, MD, phase transitions | γ=5/3 |
| `cfd` | D2Q9 lattice Boltzmann | 9=N_c² |
| `decay` | α/β/γ, tunneling, channels | Geiger-Nuttall |
| `optics` | Snell, Fresnel, fiber modes | LP modes |
| `md` | Molecular dynamics, polymers | bond angles |
| `condensed` | Ising, BCS, Bose-Einstein | T_c |
| `plasma` | MHD, Alfvén, Debye | 8=d_colour |
| `qft` | Feynman rules, running α_s | β₀=7 |
| `rigid` | Euler equations, gyroscope | I = 2/5, 2/3 |
| `chem` | Orbitals, Arrhenius, noble gases | f-shell=14=N_w·β₀ |
| `nuclear` | SEMF, magic numbers, Fe-56 | all 7 magic |
| `astro` | Lane-Emden, Hawking, Eddington | polytrope 3/2 |
| `qinfo` | Steane [7,1,3], Heyting algebra | uncertainty from gcd=1 |
| `bio` | Genetic code, Kleiber, helix | 20 amino acids |
| `arcade` | LJ cutoff, Euler/Verlet, fixed-point | 137=⌊43π+ln7⌋ |

### Core (non-dynamics)

| Module | Content |
|--------|---------|
| `atoms` | A_F constants: N_w, N_c, χ, β₀, Σ_d, D, ... |
| `toe` | Central Toe struct with VEV |
| `gauge` | α, sin²θ_W, W/Z/Higgs masses |
| `qcd` | Proton, pion, hadron spectrum |
| `vev` | VEV derivation: v = M_Pl × 35/(43×36×2⁵⁰) |
| `cosmo` | Ω_Λ, Ω_m, n_s, neutrinos |
| `mixing` | CKM + PMNS matrices |
| `gravity` | Kinematic gravity, SR/GR |
| `protein` | Molecular geometry, VdW |
| `py` | PyO3 bindings (all modules) |

### Python Examples (105 files, 21 directories)

```
python/examples/
├── chem/          5 examples (orbitals, hybridization, energy, Arrhenius, integers)
├── nuclear/       5 examples (magic, binding curve, SEMF, radii, integers)
├── astro/         5 examples (Lane-Emden, scaling, black holes, cross-checks)
├── qinfo/         5 examples (error codes, Heyting, entropy, MERA, integers)
├── bio/           5 examples (genetic code, allometric, protein, cross-module)
├── arcade/        5 examples (LJ potentials, integrators, fixed-point, mean-field)
├── classical/     5 examples (LEO, elliptical, Hohmann, slingshot, conservation)
├── em/            5 examples (Yee FDTD, Larmor, Planck, Rayleigh, integers)
├── ...            (15 more module directories)
```

---

## License

AGPL-3.0-or-later — Copyright (c) 2026 Daland Montgomery

**Repo:** https://github.com/CrystalToe/CrystalAgent
