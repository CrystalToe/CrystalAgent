<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# README_CrystalFriedmann.md

## Module: CrystalFriedmann — Cosmological Expansion from (2,3)

**Status:** Phase 5 dynamics refactor — COMPLETE  
**Lines:** ~640  
**Observable count:** 0 new (infrastructure)  
**Bespoke integrators:** ZERO  

---

## SECTOR ASSIGNMENT TABLE

| Data | Sector | Dim | λ | Physical meaning |
|------|--------|-----|---|-----------------|
| Total energy E_tot | singlet [1] | 1 | 1 (conserved) | Dark energy Ω_Λ: never decays |
| Scale factor a, ȧ, K | weak [3] | 3 | 1/2 | Geometry: halved per tick |
| H, Ω_m, Ω_r, ρ, P, ẇ, T_CMB, S_hor | colour [8] | 8 | 1/3 | Matter/radiation: thirded per tick |
| δ_k perturbation modes (24 Fourier) | mixed [24] | 24 | 1/6 | Perturbations: sixthed per tick |

**Total: 1 + 3 + 8 + 24 = 36 = Σd. All four sectors used.**

---

## HOW THE DYNAMICS WORKS

### S = W∘U (Full Symplectic Split)

**W step (kick) — intra-site sector coupling:**
```
Geometry (weak) is KICKED by matter content (colour):
  ȧ_new = (ȧ + wK₁ × H × a) × wK₁     ← Hubble drives expansion rate
  K_new = (K + wK₁ × (Ω_m×ρ − E_tot)) × wK₁  ← matter vs dark energy

Colour self-contracts by wK₂ = 1/√3:
  H'    = H × wK₂        ← Hubble decays
  ρ'    = ρ × wK₂        ← density dilutes
  T_CMB' = T × wK₂       ← CMB cools

Mixed contracts by wK₃ = 1/√6:
  δ_k'  = δ_k × wK₃     ← perturbation modes damp
```

**U step (drift) — inter-site spatial coupling:**
```
For each sector k, discrete Laplacian over N_c = 3 dimensions:
  val_new(i) = val(i) + uK²_k × Σ_neighbors (val(j) − val(i))

Weak coupling (uK²₁ = 1/2):  geometric coherence (homogeneity)
Colour coupling (uK²₂ = 1/3): matter exchange at horizons
Mixed coupling (uK²₃ = 1/6):  perturbation propagation (structure formation)
```

**Full tick:** `cosmoTick = map wStep . uStep`

### Why this IS Friedmann

- **Matter dilution in 3D:** λ_colour = 1/3 → ρ ∝ (1/3)^n. Exponent = N_c = 3. This IS 1/a³.
- **Radiation dilution in 4D:** λ_colour × λ_weak = 1/6 = λ_mixed. Exponent = N_c + 1 = 4. This IS 1/a⁴.
- **Dark energy domination:** Singlet (λ=1) never decays. After n ticks, Ω_Λ → 1. De Sitter.
- **Deceleration → acceleration:** q = Ω_m/2 − Ω_Λ crosses zero as singlet dominates.
- **Perturbation growth:** Mixed sector (δ_k) couples via 3D U disentangler → structure formation.

### 3D Lattice

6 neighbors per site (2 per axis × N_c = 3 axes = 6 = χ).
3D U step: discrete Laplacian with CFL-stable coefficient uK²/N_c.

---

## THREE.JS INTERFACE

### JSON Output Functions

| Function | Returns | Use |
|----------|---------|-----|
| `lattice3DToJSON tick grid` | Full 3D lattice snapshot | Volumetric rendering |
| `lattice1DToJSON tick lat` | 1D lattice snapshot | Line/bar visualization |
| `trajectoryToJSON snaps` | Time series of observables | Chart/timeline |

### Per-Site Render Data

```json
{
  "ix": 0, "iy": 0, "iz": 0,
  "r": 1.0,          // radius ∝ scale factor a
  "cr": 0.9, "cg": 0.1, "cb": 0.1,  // colour from T_CMB
  "op": 0.31,        // opacity ∝ Ω_m (matter)
  "gl": 0.68,        // glow ∝ Ω_Λ (dark energy)
  "pt": 0.005        // perturbation amplitude
}
```

### Visualization Recipe

```javascript
// Three.js: one sphere per site
sites.forEach(s => {
  const geo = new THREE.SphereGeometry(s.r * baseScale);
  const mat = new THREE.MeshStandardMaterial({
    color: new THREE.Color(s.cr, s.cg, s.cb),
    opacity: 0.3 + 0.7 * s.op,
    transparent: true,
    emissive: new THREE.Color(s.gl * 0.3, s.gl * 0.1, s.gl * 0.5)
  });
  const mesh = new THREE.Mesh(geo, mat);
  mesh.position.set(s.ix, s.iy, s.iz);
  scene.add(mesh);
});
```

---

## DENSITY PARAMETERS (all from (2,3))

| Parameter | Crystal | Formula | PDG/Planck | PWI |
|-----------|---------|---------|------------|-----|
| Ω_Λ | 0.6842 | gauss/(gauss+χ) = 13/19 | 0.6847 | 0.07% |
| Ω_m | 0.3158 | χ/(gauss+χ) = 6/19 | 0.3153 | 0.16% |
| w_DE | −1 | Landauer erasure | −1.03 ± 0.03 | EXACT |
| DM/baryon | 5.386 | 12π/7 | 5.36 | 0.49% |
| 100θ* | 1.0417 | 100/96 | 1.0411 | 0.06% |
| T_CMB | 2.714 K | 19/7 | 2.7255 | 0.42% |
| n_s | 0.9623 | 1 − κ/D | 0.9649 | 0.27% |
| ln(10¹⁰A_s) | 3.045 | ln(21) | 3.044 | 0.03% |
| Age | 13.857 Gyr | 97/7 | 13.797 | 0.43% |

---

## IMPORT PATTERN

```haskell
import CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD, gauss, d1, d2, d3, d4)
import CrystalSectors (CrystalState, sectorDim, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, applyW, applyU, normSq)
```

Zero CrystalEngine. Component stack only.

---

## HOW TO COMPILE AND RUN

### Prerequisites

All four component stack modules must be in the same directory:

```
haskel/
  CrystalAtoms.hs        # Component 2: nW, nC, chi, beta0, ...
  CrystalSectors.hs      # Component 3: CrystalState, extractSector, ...
  CrystalEigen.hs        # Component 4: lambda, wK, uK
  CrystalOperators.hs    # Component 5: tick, applyW, applyU, normSq
  CrystalFriedmann.hs    # THIS MODULE
```

### Compile & Run

```bash
cd haskel
ghc -O2 -Wno-x-partial -main-is CrystalFriedmann CrystalFriedmann.hs && ./CrystalFriedmann
```

### Run Self-Test

```bash
./friedmann
```

Expected output: all PASS across sections SA–SI (integer identities, density parameters, CMB, tick dynamics, W∘U coupling, 1D lattice, JSON output, 3D lattice, component stack).

### Run from GHCi (Interactive)

```bash
cd haskel
ghci CrystalFriedmann.hs
```

```haskell
-- Single-site evolution: 20 ticks
let cs0 = packRegion defaultRegion
let traj = trajectory 20 cs0
mapM_ print traj

-- 1D lattice with density bump: 10 sites, 15 ticks
let lat = initLattice1D 10
let snaps = trajectoryLattice 15 lat
mapM_ (\s -> putStrLn $ show (snTick s) ++ " a=" ++ show (snA s) ++ " OmL=" ++ show (snOmegaL s)) snaps

-- 3D lattice: 4x4x4, single tick
let lat3 = initLattice3D 4
let lat3' = cosmoTick3D lat3
putStrLn $ lattice3DToJSON 0 lat3

-- JSON trajectory for Three.js
let json = trajectoryToJSON (trajectory 30 cs0)
writeFile "friedmann_trajectory.json" json

-- 1D lattice animation frames (20 ticks)
let frames = evolve1D 20 (initLattice1D 16)
let jsons = zipWith lattice1DToJSON [0..] frames
writeFile "friedmann_frames.json" ("[" ++ intercalate "," jsons ++ "]")

-- 3D lattice animation frames (10 ticks, 4x4x4)
let frames3 = evolve3D 10 (initLattice3D 4)
let jsons3 = zipWith lattice3DToJSON [0..] frames3
writeFile "friedmann_3d_frames.json" ("[" ++ intercalate "," jsons3 ++ "]")
```

### Feed to Three.js

```javascript
// Load trajectory
fetch('friedmann_trajectory.json')
  .then(r => r.json())
  .then(data => {
    // data = [{t, a, H, OL, OM, OR, q, T, S, dP}, ...]
    // Animate: interpolate between ticks
    let tick = 0;
    function animate() {
      const snap = data[tick % data.length];
      // Update scene: scale universe by snap.a
      // Color background by snap.T (CMB temperature)
      // Show OmegaL glow increasing over time
      tick++;
      requestAnimationFrame(animate);
    }
    animate();
  });

// Load 3D lattice frames
fetch('friedmann_3d_frames.json')
  .then(r => r.json())
  .then(frames => {
    // frames = [{tick, nx, ny, nz, sites: [{ix,iy,iz,r,cr,cg,cb,op,gl,pt}]}, ...]
    let frame = 0;
    function animate() {
      const f = frames[frame % frames.length];
      f.sites.forEach(s => {
        // sphere at (s.ix, s.iy, s.iz)
        // radius = s.r * baseScale
        // color = (s.cr, s.cg, s.cb)
        // opacity = 0.3 + 0.7 * s.op
        // emissive glow = s.gl
        // perturbation ring = s.pt
      });
      frame++;
      requestAnimationFrame(animate);
    }
    animate();
  });
```

### Verify Proofs

```bash
# Lean 4
cd proofs
cp ../haskel/CrystalFriedmann.lean .
lake env lean CrystalFriedmann.lean
# All theorems pass via native_decide

# Agda
agda CrystalFriedmann.agda
# All theorems pass via refl
```

---

## WHAT YOU NEVER DO

- Write `integrateFriedmann` with RK2 midpoint
- Write `dadt a = a * hubbleNorm a`
- Write `sqrt (omegaRad / a4 + omegaMatter / a3 + omegaLambda)`
- Import or implement ANY ODE solver

The tick REPLACES all of these. They are what the tick IS.
