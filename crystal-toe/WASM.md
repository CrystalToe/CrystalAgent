<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Crystal Toe — WebAssembly Build Guide

Run the full Crystal Topos physics engine in any browser. Same Rust code,
compiled to WASM. No server needed. D3, Three.js, Canvas — whatever you want.

---

## Prerequisites

```bash
# Install wasm-pack (one-time)
cargo install wasm-pack

# Or via npm
npm install -g wasm-pack
```

---

## Build

```bash
cd crystal-toe

# Build WASM package (outputs to pkg/)
wasm-pack build --target web --features wasm

# What you get:
# pkg/crystal_toe_bg.wasm    ← the compiled engine (~200KB)
# pkg/crystal_toe.js         ← JS glue (auto-generated)
# pkg/crystal_toe.d.ts       ← TypeScript types (free!)
# pkg/package.json           ← npm-ready
```

### Build Targets

| Target | Use case | Import style |
|--------|----------|-------------|
| `--target web` | `<script type="module">` | `import init from './crystal_toe.js'` |
| `--target bundler` | Webpack/Vite/Rollup | `import { WasmToe } from 'crystal-toe'` |
| `--target nodejs` | Node.js server | `const { WasmToe } = require('crystal-toe')` |

---

## Quick Test

After `wasm-pack build --target web --features wasm`:

```bash
# Serve the web/ directory
cd web
python3 -m http.server 8080
# Open http://localhost:8080
```

---

## JavaScript API

### One-Call Dump (recommended for D3)

```javascript
import init, { crystal_dump } from '../pkg/crystal_toe.js';

await init();
const data = crystal_dump();

// data is a plain JS object:
// {
//   n_w: 2, n_c: 3, chi: 6, beta0: 7,
//   magic_numbers: [2, 8, 20, 28, 50, 82, 126],
//   binding_curve: [[2, 1.11], [3, 2.83], ... [250, ...]],
//   le_nr_profile: [[0, 1.0], [0.001, 0.999], ...],
//   shell_capacities: [2, 6, 10, 14],
//   noble_gases: [2, 10, 18, 36],
//   ...
// }

// Feed directly to D3:
d3.select('svg').selectAll('circle')
  .data(data.binding_curve)
  .join('circle')
  .attr('cx', d => xScale(d[0]))
  .attr('cy', d => yScale(d[1]));
```

### Per-Module Classes

```javascript
import init, { WasmToe, WasmChem, WasmNuclear, WasmAstro,
               WasmQInfo, WasmBio, WasmArcade } from '../pkg/crystal_toe.js';

await init();

// Central object
const toe = new WasmToe();
toe.alpha_inv();           // 137.034
toe.proton_mass();         // GeV

// Chemistry
const chem = new WasmChem();
chem.sp3_angle_deg();      // 109.47
chem.hartree_ev();         // 27.2
chem.noble_gases();        // [2, 10, 18, 36]
chem.arrhenius(0.5, 0.026);  // rate at given Ea, kT

// Nuclear
const nuc = new WasmNuclear();
nuc.magic_numbers();       // [2, 8, 20, 28, 50, 82, 126]
nuc.binding_per_nucleon(56, 26);  // Fe-56 peak
nuc.binding_curve(250);    // [[a, B/A], ...] for D3

// Astrophysics
const ast = new WasmAstro();
ast.lane_emden_profile(1.5);  // [[xi, theta], ...] white dwarf
ast.ms_luminosity(10.0);      // L/L☉ for 10 M☉

// Quantum Info
const qi = new WasmQInfo();
qi.bell_entropy();         // ln(2)
qi.hamming_check();        // true: β₀ = 2³−1

// Biology
const bio = new WasmBio();
bio.amino_acids();         // 20
bio.kleiber(100.0);        // metabolic rate at 100× mass

// Arcade (approximation layers)
const arc = new WasmArcade();
arc.lj_scan(0.95, 4.0, 300);  // [[r, V_exact, V_arcade, V_wca], ...]
arc.verify_alpha_inv();        // true: 137 = ⌊43π + ln7⌋

// Self-test any module (returns {pass, total, msgs})
const result = chem.self_test();
console.log(`${result.pass}/${result.total} PASS`);
result.msgs.forEach(m => console.log(m));
```

---

## D3 Integration Patterns

### Pattern 1: Binding Energy Curve

```javascript
const nuc = new WasmNuclear();
const curve = nuc.binding_curve(250);  // [[a, B/A], ...]

const svg = d3.select('#binding-chart');
const x = d3.scaleLinear().domain([0, 250]).range([0, width]);
const y = d3.scaleLinear().domain([0, 9]).range([height, 0]);

svg.append('path')
  .datum(curve)
  .attr('d', d3.line().x(d => x(d[0])).y(d => y(d[1])))
  .attr('stroke', '#3498db')
  .attr('fill', 'none');
```

### Pattern 2: Lane-Emden Profiles

```javascript
const ast = new WasmAstro();
const profiles = [
  { n: 1.0, label: 'n=1', color: '#3498db' },
  { n: 1.5, label: 'n=3/2 (WD)', color: '#e74c3c' },
  { n: 3.0, label: 'n=3 (Chandra)', color: '#2ecc71' },
];

profiles.forEach(({ n, label, color }) => {
  const pts = ast.lane_emden_profile(n);
  svg.append('path')
    .datum(pts)
    .attr('d', d3.line().x(d => x(d[0])).y(d => y(d[1])))
    .attr('stroke', color);
});
```

### Pattern 3: LJ Potential Comparison

```javascript
const arc = new WasmArcade();
const scan = arc.lj_scan(0.95, 4.0, 300);
// scan[i] = [r, V_exact, V_arcade, V_wca]

['V_exact', 'V_arcade', 'V_wca'].forEach((label, col) => {
  svg.append('path')
    .datum(scan)
    .attr('d', d3.line().x(d => x(d[0])).y(d => y(d[col + 1])));
});
```

### Pattern 4: Interactive — Compute on Demand

```javascript
// Slider controls activation energy, D3 updates Arrhenius curve live
const chem = new WasmChem();
slider.on('input', function() {
  const ea = +this.value;
  const data = d3.range(100, 600).map(T => {
    const kt = 8.617e-5 * T;
    return { T, rate: chem.arrhenius(ea, kt) };
  });
  path.datum(data).attr('d', line);
});
```

---

## npm Publishing (optional)

```bash
wasm-pack build --target bundler --features wasm
cd pkg
npm publish
```

Then in any JS project:

```bash
npm install crystal-toe
```

```javascript
import { WasmToe, crystal_dump } from 'crystal-toe';
```

---

## Troubleshooting

**"wasm-pack not found"** — `cargo install wasm-pack` or `npm i -g wasm-pack`

**"feature wasm not found"** — make sure Cargo.toml has `wasm = ["wasm-bindgen", "serde", "serde-wasm-bindgen"]`

**CORS errors** — use a local server (`python3 -m http.server`), don't open HTML as `file://`

**Big .wasm file** — add to Cargo.toml:
```toml
[profile.release]
opt-level = "z"
lto = true
```
Then: `wasm-pack build --release --target web --features wasm`

---

## File Structure After Build

```
crystal-toe/
├── src/
│   ├── wasm.rs          ← WASM bindings (this file)
│   ├── py.rs            ← Python bindings
│   └── ...
├── pkg/                 ← wasm-pack output (git-ignored)
│   ├── crystal_toe.js
│   ├── crystal_toe.d.ts
│   ├── crystal_toe_bg.wasm
│   └── package.json
├── web/                 ← example HTML pages
│   ├── index.html
│   └── ...
├── Cargo.toml
└── WASM.md              ← this file
```
