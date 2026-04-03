<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Crystal Topos — Next Session TODO

## Priority: Haskell First, Then Rust Port, Then WASM

Everything starts in Haskell. Rust ports from Haskell. WASM exposes Rust.

---

## 1. CrystalQFT.hs — COLLIDER PHYSICS (highest priority)

### Currently has:
- e⁺e⁻ → μ⁺μ⁻ (Born level, 1/s falloff)
- Running α_s with β₀ = 7
- Running α_QED
- Thomson cross-section = (8/3)πr_e² where 8/3 = d_colour/N_c
- Pair threshold = N_w × m

### Needs adding:

#### Z resonance (Breit-Wigner) — ~30 lines
```haskell
-- Z width from Crystal: Γ_Z = α × M_Z / (N_c × sin²θ_W × cos²θ_W) × Σ channels
-- Z mass already in CrystalGauge.hs
-- Breit-Wigner: σ(s) = 12π/M_Z² × (s × Γ_ee × Γ_ff) / ((s - M_Z²)² + s² × Γ_Z²/M_Z²)
-- Every factor from (2,3): 12π = N_w² × N_c × π

proveZWidth :: Crystal Two Three -> Derived
-- Γ_Z = sum over all fermion channels
-- Each channel: Γ_f = N_c_f × α × M_Z / (N_c × sin²θ_W × cos²θ_W) × (v_f² + a_f²)
-- v_f, a_f from T₃ and Q — all Crystal integers

proveBreitWigner :: Crystal Two Three -> Double -> Derived
-- σ(√s) through Z pole — THE classic LEP/SLC plot
-- Shows interference between γ and Z (QED × weak mixing)

proveZPeakCrossSection :: Crystal Two Three -> Derived  
-- σ_peak = 12π Γ_ee Γ_had / (M_Z² Γ_Z²)
-- 12π = N_w² × N_c × π, every integer from (2,3)

proveNeutrinoCountFromZ :: Crystal Two Three -> Derived
-- N_ν = 3 = N_c (from invisible width)
-- The classic LEP result
```

#### W pair production — ~15 lines
```haskell
proveWWThreshold :: Crystal Two Three -> Derived
-- √s_threshold = N_w × M_W (pair = N_w copies)
-- σ_WW(s) rises as β³ where β = √(1 - 4M_W²/s)
-- 4 = N_w² in the threshold factor

proveWWidth :: Crystal Two Three -> Derived
-- Γ_W from CKM matrix (already proved in CrystalMixing.hs)
```

#### Higgs production — ~25 lines  
```haskell
proveHiggsGGF :: Crystal Two Three -> Derived
-- σ(gg→H) via top loop
-- Factor: α_s² × G_F / (N_c² × √2 × 2⁸ × π)
-- N_c² = 9 (gluon colour), 2⁸ = N_w⁸ (loop factor)

proveHiggsWidth :: Crystal Two Three -> Derived
-- Γ_H ≈ sum of partial widths
-- H→bb̄ dominant: Γ_bb = N_c × G_F × m_H × m_b² / (4π√2)
-- N_c = 3 colour factor

proveHiggsVBF :: Crystal Two Three -> Derived
-- σ(qq→qqH) via W/Z fusion
-- Proportional to G_F² × M_W⁴
```

#### Drell-Yan — ~15 lines
```haskell
proveDrellYan :: Crystal Two Three -> Double -> Double -> Derived
-- σ(qq̄→ℓ⁺ℓ⁻) = 4πα²/(N_c × s) × e_q²
-- N_c = 3 colour average (1/N_c in initial state)
-- e_q from Crystal: 2/3 for up, -1/3 for down
```

---

## 2. CrystalCollider.hs — NEW MODULE (~200 lines)

### Parton distributions (simplified Crystal PDFs)
```haskell
-- NOT full LHAPDF — Crystal-derived structure functions
-- Valence: u(x) ~ x^(1/N_w) × (1-x)^N_c = x^0.5 × (1-x)³
-- Sea: q̄(x) ~ (1-x)^(β₀) = (1-x)⁷
-- Gluon: g(x) ~ (1-x)^(χ-1) / x = (1-x)⁵/x
-- Every exponent from (2,3)

proveValenceExponent :: Crystal Two Three -> Derived   -- 1/N_w, N_c
proveSeaExponent :: Crystal Two Three -> Derived       -- β₀ = 7
proveGluonExponent :: Crystal Two Three -> Derived     -- χ-1 = 5

-- Convolution for pp cross-sections:
-- σ(pp→X) = Σ ∫ f_a(x₁) × f_b(x₂) × σ̂(ab→X) dx₁ dx₂
-- This gives LHC predictions from Crystal
```

### Phase space and kinematics
```haskell
-- Mandelstam: s + t + u = Σm² (sum over N_c+1=4 momenta)
-- Rapidity: y = (1/N_w) ln(E+p_z)/(E-p_z)
-- Pseudorapidity: η = -ln(tan(θ/N_w))

proveMandelstam :: Crystal Two Three -> Derived
proveRapidity :: Crystal Two Three -> Derived
```

---

## 3. CrystalMixing.hs → WASM exposure

### Already proved in Haskell, NOT in WASM:
```
|V_us| = 9/40          — EXACT
|V_cb| = 81/2000       — EXACT  
|V_ub| = 729/(80000√6)
A† = 144/175
J = 5/1944
δ_CKM = arctan(8/3)
sin²θ₁₂ = 3/π²
sin²θ₂₃ = 6/11
sin²θ₁₃ = 1/45 (corrected: (2χ−1)/(N_w²(χ−1)³) = 11/500)
δ_PMNS = π + arctan(1/3)
```

### Needs in Rust mixing.rs + wasm.rs:
```rust
// WasmMixing — expose all 12 parameters
pub struct WasmMixing;
impl WasmMixing {
    fn v_us() -> f64;
    fn v_cb() -> f64;
    fn v_ub() -> f64;
    fn wolf_a() -> f64;
    fn jarlskog() -> f64;
    fn delta_ckm_deg() -> f64;
    fn sin2_theta_12() -> f64;
    fn sin2_theta_23() -> f64;
    fn sin2_theta_13() -> f64;
    fn delta_pmns_deg() -> f64;
    fn ckm_matrix() -> [[f64;3];3];  // full 3×3
    fn pmns_matrix() -> [[f64;3];3]; // full 3×3
}
```

---

## 4. CrystalDecay.hs — EXPAND

### Currently has:
- β spectrum curve
- Neutrino oscillation P(ν_μ→ν_e)
- Neutron lifetime
- Fermi golden rule
- Weinberg angle, PMNS angles

### Needs adding:

#### Muon decay — ~10 lines
```haskell
proveMuonLifetime :: Crystal Two Three -> Derived
-- τ_μ = 192π³ / (G_F² × m_μ⁵) where 192 = d_mixed × d_colour
-- Every integer from (2,3)

proveMuonWidth :: Crystal Two Three -> Derived  
-- Γ_μ = G_F² × m_μ⁵ / (192π³)
```

#### Tau decay — ~10 lines  
```haskell
proveTauLifetime :: Crystal Two Three -> Derived
proveTauBranchingRatios :: Crystal Two Three -> Derived
-- BR(τ→eν̄ν) = 1/(N_w + N_c) × (1 + N_c × |V_ud|²)
```

#### Pion decay — ~10 lines
```haskell
provePionLifetime :: Crystal Two Three -> Derived
-- π⁺ → μ⁺ν_μ helicity suppression: (m_μ/m_π)² × (1 - m_μ²/m_π²)²
-- m_μ, m_π both Crystal-derived
```

---

## 5. CrystalGauge.hs — EXPAND for W/Z widths

### Currently has:
- M_W, M_Z, M_H, sin²θ_W, α
- VEV = 245.17 GeV

### Needs adding:
```haskell
proveZWidth :: Crystal Two Three -> Derived
proveWWidth :: Crystal Two Three -> Derived
proveHiggsWidth :: Crystal Two Three -> Derived
proveTopMass :: Crystal Two Three -> Derived     -- if not already
proveBottomMass :: Crystal Two Three -> Derived   -- if not already
proveTauMass :: Crystal Two Three -> Derived      -- if not already
```

---

## 6. CrystalOptics.hs — EXPAND

### Needs:
```haskell
-- Blackbody spectrum: B(λ,T) with Wien peak at λ_max = b/T
-- b = hc/(β₀-1) k_B?  Check if this derives.
-- Stefan-Boltzmann: σ = 2π⁵/(15 × N_c(χ-1)) × k⁴/(h³c²)
-- 15 = N_c(χ-1) appears in SB denominator

proveStefanBoltzmann :: Crystal Two Three -> Derived
proveWienDisplacement :: Crystal Two Three -> Derived
```

---

## 6b. CrystalGR.hs — EXPAND for black hole + lensing

### Currently has:
- Schwarzschild metric, g_tt, g_rr
- V_eff massive + photon
- Geodesic integration (massive particles)
- Precession, light bending (analytic), ISCO, redshift

### Needs adding:

#### Photon geodesic integration — ~30 lines
```haskell
provePhotonGeodesic :: Double -> Double -> [(Double, Double)]
-- Integrate null geodesic (m=0), same stepper as massive
-- Input: impact parameter b
-- Output: [(r, φ)] — for ray-tracing / lensing
-- b < N_c·√N_c·GM → captured, b > → deflected
```

#### Disk temperature — ~10 lines
```haskell
proveDiskTemperature :: Double -> Double
-- T(r) ∝ r^{-3/4}, inner edge at ISCO = χ·GM
-- Radiative efficiency η = 1 − √(8/9) = 1 − 2√2/3
-- 8 = d_colour = N_w³, 9 = N_c²
```

#### Kerr metric — ~100 lines
```haskell
proveKerrISCO :: Double -> Double
-- Spin-dependent ISCO: from GM (maximal) to χ·GM (non-rotating)
-- Frame dragging, ergosphere, Penrose process
```

#### Einstein ring / lensing — ~20 lines
```haskell
proveEinsteinRadius :: Double -> Double -> Double -> Double
-- θ_E = √(N_w²·GM·D_LS / (D_L·D_S)), N_w² = 4
```

---

## 6c. CrystalPlasma.hs — EXPAND for accretion

### Needs:
```haskell
proveBondiAccretion :: Double -> Double
-- Ṁ = N_w²·π·G²·M²·ρ / c_s³, N_w² = 4

proveMRIGrowthRate :: Double -> Double
-- Magneto-rotational instability → accretion disk turbulence
```

---

## 7. WASM Exposure Gaps (Rust exists, WASM doesn't)

### From core modules — need in wasm.rs:
```
mixing.rs    → WasmMixing (CKM + PMNS, 12 parameters)
gauge.rs     → expand WasmToe with pion_mass, muon_mass, tau_mass, top_mass
waca_scan.rs → WasmWACAScan (all 103 observables as bulk export)
quantum.rs   → WasmQuantum (sector eigenvalues, Fock space, gates)
mera.rs      → WasmMERA (42 layers, RT, EFE)
```

---

## 8. THREE.JS VISUALIZATION DYNAMICS (crystaltoe.com)

Six showcase scenes for the website. Each needs specific dynamics.

### 8a. Volumetric Black Hole + Accretion Disk + Lensing
**Status: 80% — needs photon ray-tracing**
- ✅ HAVE: schwarzschild_r, isco_radius, geodesic(), gravitational_redshift, v_eff_photon, light_bending_analytic
- ❌ NEED (in TODO 6b): photon_geodesic(b, n_steps) [~30L Haskell], disk_temperature(r) [~10L], kerr_metric [~100L]

### 8b. Million-Particle Galaxy Collision
**Status: 100% — all dynamics exist**
- ✅ HAVE: WasmNBody.add_galaxy(), .tick(), .positions_2d(), plummer_sphere(), total_energy()
- No missing dynamics. Just Three.js bloom + HDR rendering.

### 8c. 3D Ising Lattice with Metallic Cubes
**Status: 60% — needs 3D lattice + spin export**
- ✅ HAVE: ising_sweep(), onsager_tc(), magnetization()
- ❌ NEED in CrystalCondensed.hs:
  - Lattice3D (cubic, z = χ = 6 neighbours) [~40L]
  - ising_sweep_3d() [~20L]
  - spin_array_export() → Vec<i8> [~5L]
  - Crystal: z_cubic = χ = N_w × N_c = 6

### 8d. Earth + Atmosphere + Satellite Tracks
**Status: 85% — needs atmosphere Rayleigh model**
- ✅ HAVE: satellite_circular(), kepler_period(), rayleigh_intensity(), sky_blue_ratio()
- ❌ NEED in CrystalOptics.hs:
  - atmosphere_scatter(theta, alt) → RGB [~20L] (I ∝ λ^(−N_w²))
  - optical_depth(alt, wavelength) [~10L]

### 8e. Fluid Surface with Reflections
**Status: 40% — needs 3D LBM or height-field**
- ✅ HAVE: WasmCFD (D2Q9, 2D)
- ❌ NEED in CrystalCFD.hs:
  - D3Q19 lattice (19 = gauss + χ = 13 + 6!) [~80L] or D3Q27 (27 = N_c³) [~80L]
  - OR simpler: height_field from 2D pressure z = p(x,y) [~10L]
  - Crystal: D2Q9 = N_c², D3Q19 = gauss+χ, D3Q27 = N_c³

### 8f. MERA Tensor Network Tower (fly-through)
**Status: 30% — needs geometry export**
- ✅ HAVE: TOTAL_LAYERS=42, BOND_DIM=6, ISOMETRY_IN=χ, DISENTANGLERS_PER_LAYER=3
- ❌ NEED in CrystalMERA.hs:
  - mera_node_positions(layer) → [(x,y,z)] [~30L]
  - mera_connections(layer) → [(from,to)] [~20L]
  - mera_entanglement_profile() → [S(layer)] [~10L]
  - mera_causal_cone(site) → [nodes] [~15L]
  - Crystal: 42 layers, χ=6 bond, Σ_d=36 boundary → 1 bulk

### PRIORITY:
1. 8b Galaxy — **ready now**
2. 8a Black hole — ~30L Haskell
3. 8f MERA tower — ~75L Haskell
4. 8c 3D Ising — ~70L Haskell
5. 8d Earth — ~30L Haskell
6. 8e Fluid — ~150L Haskell

---

## SESSION PLAN

### Phase 1: CrystalQFT.hs (Breit-Wigner + Z peak)
1. Add Z width formula (all factors from (2,3))
2. Add Breit-Wigner σ(√s) with γ-Z interference
3. Add N_ν = N_c proof from invisible width
4. Add W pair threshold
5. Run `ghc -O2 -main-is CrystalQFT CrystalQFT.hs && ./CrystalQFT`
6. Verify: Z peak at 91.19 GeV, width ≈ 2.495 GeV

### Phase 2: Port to Rust qft.rs
7. Add corresponding Rust functions
8. `cargo test dynamics::qft`
9. Add to WasmQFT in wasm.rs
10. `wasm-pack build --target web --features wasm`

### Phase 3: CrystalCollider.hs (new module)
11. Crystal PDFs (valence, sea, gluon exponents)
12. Drell-Yan cross-section
13. Higgs ggF cross-section
14. Run + verify

### Phase 4: Expand existing
15. Muon/tau/pion decay in CrystalDecay.hs
16. Z/W/H widths in CrystalGauge.hs
17. CKM/PMNS WASM exposure

### Phase 5: Visualizations
18. LEP Z-scan plot (THE classic collider plot)
19. LHC-style Higgs bump
20. Running coupling unification
21. Neutrino oscillation patterns

---

## PROOF REGRESSION

After all additions:
```bash
sh proofs/proof_regression.sh --snapshot
# Expected: Lean 1226+, Agda 991+, Rust 600+, Python 135+
# New Haskell module count: 36 + 21 + 1 (CrystalCollider) = 58
```

---

## NON-NEGOTIABLE RULES
- Every integer from (2,3). No hardcoded physics numbers.
- Haskell FIRST. Rust ports. WASM exposes.
- All prove* functions take Crystal Two Three as first argument.
- self_test at bottom of every module.
- Lean + Agda proofs for all new rational identities.
