<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# README_CrystalGravity.md

## Module: CrystalGravity — Gravitational Field Dynamics from (2,3)

**Status:** Phase 5 dynamics refactor — COMPLETE  
**Lines:** ~743  
**Observable count:** 0 new (infrastructure)  
**Bespoke integrators:** ZERO  

---

## Compile & Run

```bash
cd haskel
ghc -O2 -Wno-x-partial -main-is CrystalGravity CrystalGravity.hs && ./CrystalGravity
```

---

## SECTOR ASSIGNMENT TABLE

| Data | Sector | Dim | λ | Physical meaning |
|------|--------|-----|---|-----------------|
| ADM energy E_ADM | singlet [1] | 1 | 1 (conserved) | Total energy: never decays |
| Φ (potential), Ψ (lapse), χ_g (shift) | weak [3] | 3 | 1/2 | Metric geometry |
| R, R_xx, R_yy, R_zz, ρ, J_x, J_y, J_z | colour [8] | 8 | 1/3 | Curvature + matter source |
| h_+, h_× GW modes (2 pol × 6 dir × 2 conj) | mixed [24] | 24 | 1/6 | Gravitational wave phase space |

**Total: 1 + 3 + 8 + 24 = 36 = Σd. All four sectors used.**

24 = d_mixed: 10 independent h_μν + 10 conjugate π_μν + 4 constraint variables.
10 = (N_c+1)(N_c+2)/2 independent metric components in 4D.

---

## HOW THE DYNAMICS WORKS

### S = W∘U (Full Symplectic Split)

**W step (kick) — intra-site sector coupling:**
```
Geometry (weak) KICKED by curvature/matter (colour):
  Φ += wK₁ × R              (Poisson: geometry from curvature)
  Ψ += wK₁ × (R + ρ)        (lapse from total source)
  χ_g += wK₁ × (J_x+J_y+J_z) (shift from momentum current)

Curvature (colour) KICKED by geometry (weak):
  R += wK₂ × (Φ + Ψ)        (Bianchi identity)
  R_ii += wK₂ × Φ           (Ricci components)
  ρ, J_i contracted only     (matter conservation)

GW (mixed) decays by wK₃ = 1/√6:
  h_+, h_× *= wK₃           (quadrupole radiation damping)
```

**U step (drift) — inter-site spatial coupling (6-neighbor Laplacian):**
```
Weak sector (uK²₁ = 1/2):
  ∇²Φ from 6 neighbors. THIS IS the Poisson equation.

Colour sector (uK²₂ = 1/3):
  Curvature propagation at c = χ/χ = 1 (Lieb-Robinson).
  THIS IS the wave equation for Ricci.

Mixed sector (uK²₃ = 1/6):
  GW transverse-traceless propagation.
  2 = N_c − 1 polarizations per direction.
```

**Full tick:** `gravTick = map wStepGrav . uStepGrav`

### Jacobson Chain (Encoded in Sector Structure)

| Step | What | Integer | From |
|------|------|---------|------|
| 1 | Finite c | χ = 6 | Lieb-Robinson bound on MERA |
| 2 | KMS β = 2π | N_w = 2 | Bisognano-Wichmann vacuum |
| 3 | S = A/(4G) | 4 = N_w² | Ryu-Takayanagi |
| 4 | G_μν = 8πG T_μν | 8 = d_colour | Jacobson 1995 |

---

## INTEGER PROOFS (18 total)

| Integer | Value | Formula | Physical meaning |
|---------|-------|---------|-----------------|
| 4 | N_w² | S = A/(4G) | Ryu-Takayanagi |
| 8 | N_c²−1 | 8πG | Einstein field equation |
| 16 | N_w⁴ | □h = −16πG T | Linearized Einstein |
| 2 | N_c−1 | r_s = 2Gm | Schwarzschild radius |
| 1 | χ/χ | c = 1 | Speed of gravity |
| 2 | N_c−1 | h_+, h_× | GW polarizations |
| 32 | N_w⁵ | Quadrupole numerator | Peters formula |
| 5 | χ−1 | Quadrupole denominator | Peters formula |
| 32/5 | N_w⁵/(χ−1) | Full quadrupole | GW power |
| 4 | N_c+1 | Spacetime dimensions | Signature (3,1) |
| 10 | (N_c+1)(N_c+2)/2 | Metric components | Independent g_μν |
| 24 | d_mixed | GW phase space | h + π + constraints |
| 16 | N_w^(N_c+1) | Clifford dim | Cl(3,1) |
| 4 | N_w² | Spinor dim | Dirac |
| 1 | 650/650 | Equivalence principle | Universal coupling |
| 5/3 | (N_c+N_w)/N_c | Kolmogorov | Turbulence |
| 8 | N_w^N_c | Octree children | Barnes-Hut |
| 2 | N_c−1 | Force exponent | Inverse square |

---

## THREE.JS INTERFACE

### JSON Output Functions

| Function | Returns |
|----------|---------|
| `gravField3DToJSON tick grid` | Full 3D lattice snapshot |
| `gravField1DToJSON tick field` | 1D field snapshot |
| `gravTrajectoryToJSON snaps` | Time series |

### Per-Site Render Data

```json
{
  "ix": 0, "iy": 0, "iz": 0,
  "phi": -0.5,     // potential → color (blue=deep well, red=hill)
  "curv": 1.2,     // |R| → sphere deformation
  "rho": 2.0,      // matter → opacity
  "gw": 0.01,      // GW amplitude → ripple effect
  "e": 1.0         // ADM energy → glow
}
```

### Visualization Recipe

```javascript
// Three.js: gravitational field
sites.forEach(s => {
  const geo = new THREE.SphereGeometry(0.4 + 0.1 * s.curv);
  const depth = Math.max(0, Math.min(1, -s.phi / maxPhi));
  const mat = new THREE.MeshStandardMaterial({
    color: new THREE.Color(1 - depth, 0.1, depth),  // red=hill, blue=well
    opacity: 0.3 + 0.7 * Math.min(1, s.rho / maxRho),
    transparent: true,
    emissive: new THREE.Color(0, s.gw * 5, s.gw * 10)  // GW = cyan ripple
  });
  const mesh = new THREE.Mesh(geo, mat);
  mesh.position.set(s.ix * spacing, s.iy * spacing, s.iz * spacing);
  scene.add(mesh);
});
```

### Scenarios

| Init function | What it shows |
|---------------|--------------|
| `initPointMass1D 20 5.0` | 1/r² potential well, curvature at center |
| `initGWBurst1D 20 0.5` | GW packet propagating + decaying at λ_mixed=1/6 |
| `initBinary1D 30 3.0 3.0` | Two wells + GW emission between them |
| `initPointMass3D 4 5.0` | 3D Newtonian field, 1/r^(N_c−1) = 1/r² |

---

## IMPORT PATTERN

```haskell
import CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD, gauss, d1, d2, d3, d4, sigmaD2)
import CrystalSectors (CrystalState, sectorDim, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, applyW, applyU, normSq)
```

Zero CrystalEngine. Component stack only.

---

## WHAT YOU NEVER DO

- Write a geodesic ODE integrator
- Compute Christoffel symbols Γ^μ_νρ
- Write a finite-difference Poisson solver
- Write a GW evolution PDE
- Import or implement ANY numerical method as the simulation

The tick REPLACES all of these. They are what the tick IS.
