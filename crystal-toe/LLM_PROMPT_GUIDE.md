# How to Prompt an LLM to Build Crystal Topos Visualizations

## The Setup

You have `crystal_toe.js` + `crystal_toe_bg.wasm` in a `pkg/` directory
(built by `wasm-pack build --target web --features wasm`).

Give the LLM this file as context, then ask for any visualization.

---

## The Prompt Template

Paste this into any LLM (Claude, GPT, etc.):

```
I have a WebAssembly physics engine called crystal-toe. Here's the API:

IMPORT:
  import init, { WasmToe, WasmChem, WasmNuclear, WasmAstro,
                 WasmQInfo, WasmBio, WasmArcade, WasmNBody,
                 crystal_dump } from './pkg/crystal_toe.js';
  await init();

BULK DATA (one call, returns plain JS object):
  crystal_dump() → {
    n_w, n_c, chi, beta0, sigma_d, tower_d,
    magic_numbers: [2,8,20,28,50,82,126],
    binding_curve: [[a, B/A], ...],
    le_nr_profile: [[xi, theta], ...],  // Lane-Emden n=3/2
    le_rel_profile: [[xi, theta], ...], // Lane-Emden n=3
    shell_capacities: [2,6,10,14],
    noble_gases: [2,10,18,36],
    lj_scan: [[r, V_exact, V_arcade, V_wca], ...],
    hartree_ev, bohr_radius, eps_vdw, kt_300,
    dna_bases, amino_acids, total_codons,
    helix_per_turn, flory_nu, kleiber_exp,
    steane: [7,1,3], mera_bond, mera_depth,
    bell_entropy, mera_entropy,
  }

PER-MODULE (for interactive/computed values):
  WasmChem:     .arrhenius(ea, kt), .sp3_angle_deg(), .hartree_ev(), .noble_gases()
  WasmNuclear:  .binding_curve(max_a), .binding_per_nucleon(a,z), .nuclear_radius(a), .magic_numbers()
  WasmAstro:    .lane_emden_profile(n), .ms_luminosity(m), .hawking_temperature(m)
  WasmQInfo:    .bell_entropy(), .hamming_check(), .steane_n()
  WasmBio:      .kleiber(m), .heart_rate(m), .lifespan(m), .amino_acids()
  WasmArcade:   .lj_scan(rmin,rmax,n), .lj_exact(r), .fast_inv_sqrt(x)

NBODY (stateful simulation):
  const sim = new WasmNBody(dt, eps);
  sim.add_galaxy(n_stars, total_mass, r_scale, cx,cy,cz, vx,vy,vz);
  sim.tick();                    // one timestep
  sim.advance(n);                // n timesteps
  sim.positions_2d();            // [[x,y], ...] for rendering
  sim.total_energy();            // scalar
  sim.load_figure_eight();       // preset
  sim.load_solar_system();       // preset

Every integer traces to N_w=2, N_c=3. There are zero free parameters.

Create a single HTML page that: [YOUR REQUEST HERE]

Use D3 v7 from CDN. Import the WASM from '../pkg/crystal_toe.js'.
Include a JS fallback if WASM isn't available.
Dark theme. Make it beautiful.
```

---

## Example Prompts

### Galaxy Collision

```
Create a single HTML page that simulates two galaxies colliding.
Use WasmNBody with add_galaxy() for two Plummer spheres on collision course.
Render with Canvas (not SVG — too many particles).
Add play/pause, speed slider, and energy conservation readout.
Show trails by not fully clearing the canvas each frame.
Color galaxy 1 cyan, galaxy 2 orange.
```

### Interactive Binding Curve

```
Create a single HTML page with an interactive nuclear binding energy curve.
Use WasmNuclear.binding_curve(250) for the data.
D3 line chart. On hover, show a tooltip with A, Z, B/A, and the Crystal formula.
Highlight magic numbers as vertical dashed lines.
Mark Fe-56 with a green dot and label "d_colour·β₀ = 56".
Add a slider that lets me pick a nucleus and see its SEMF decomposition.
```

### Arrhenius Explorer

```
Create a single HTML page with an interactive Arrhenius kinetics explorer.
Use WasmChem.arrhenius(ea, kt) to compute rates live.
Two sliders: activation energy (0-1 eV) and temperature (100-1000 K).
D3 semilogy plot of rate vs temperature for the selected Ea.
Mark kT(300K) and eps_vdw from the Crystal engine.
Show the Crystal prediction: biology works at 300K because eps_vdw ≈ kT.
```

### Lane-Emden Stellar Profiles

```
Create a single HTML page showing Lane-Emden stellar structure profiles.
Use WasmAstro.lane_emden_profile(n) for n = 0, 1, 1.5, 3, 5.
D3 multi-line chart with a slider for continuous n.
Recompute the profile live as the slider moves.
Label n=3/2 as "N_c/N_w (white dwarf)" and n=3 as "N_c (Chandrasekhar)".
Show xi_1 and mass factor in a side panel.
```

### Allometric Scaling

```
Create a single HTML page showing Kleiber's law and allometric scaling.
Use WasmBio.kleiber(m), .heart_rate(m), .lifespan(m).
Four D3 log-log panels: metabolic rate, heart rate, lifespan, total heartbeats.
The fourth panel should show that heart × lifespan = constant.
Add animal silhouettes at mouse, rat, dog, human, elephant, whale mass ratios.
Label all exponents with their Crystal formulas: 3/4 = N_c/N_w², etc.
```

### Heyting Lattice

```
Create a single HTML page visualizing the Crystal Heyting algebra.
Use WasmQInfo for the truth values and entropy.
D3 force-directed graph with nodes: 1, 1/N_w, 1/N_c, 1/χ, 0.
Edges for the lattice ordering.
Animate meet(1/N_w, 1/N_c) → 1/χ with a pulse effect.
Show that gcd(2,3)=1 implies the uncertainty principle.
Side panel with Bell entropy, MERA entropy, and the ln decomposition.
```

---

## Tips for LLMs

1. **Always include the JS fallback** — the LLM should generate code that
   works even without the WASM binary (using hardcoded data or JS reimplementation).

2. **Use Canvas for particles, SVG/D3 for charts** — SVG breaks above ~1000 elements.

3. **`crystal_dump()` for static charts, per-module classes for interactive** —
   one bulk call is faster than hundreds of small ones.

4. **The LLM doesn't need to know physics** — the engine handles everything.
   The LLM just calls `binding_curve(250)` and plots the result.

5. **Dark theme always** — `#0a0a1a` background, cyan `#7ec8e3` for text,
   red `#e74c3c` for accents. This matches the Crystal aesthetic.

---

## File Serving

The WASM binary must be served over HTTP (not `file://`):

```bash
cd crystal-toe/web
python3 -m http.server 8080
# → http://localhost:8080/galaxy_collision.html
```

Or with Node:

```bash
npx serve crystal-toe/web
```
