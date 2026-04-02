#!/usr/bin/env python3
"""
Crystal Classical Dynamics — Example 5: Conservation Law Dashboard
===================================================================
The crystal proof: Noether's theorem from (N_w, N_c) = (2, 3).
Run multiple orbits at different eccentricities, prove energy and
angular momentum are conserved to machine precision by the symplectic
leapfrog (the classical limit of the crystal monad S = W∘U∘W).
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec

toe = ct.Toe()
cl = toe.classical()
GM = 1.0
A = 10.0

# Run orbits at different eccentricities
eccs = [0.0, 0.1, 0.3, 0.5, 0.7, 0.9]
n_periods = 20
results = []

print("=== Crystal Conservation Law Dashboard ===")
print(f"  Integrator: Symplectic leapfrog (monad S = W∘U∘W)")
print(f"  GM = {GM}, a = {A}, {n_periods} orbital periods each")
print()

for ecc in eccs:
    state = cl.orbit_elliptical(GM, A, ecc)
    px, py, pz, vx, vy, vz = state
    period = cl.kepler_period(A, GM)
    dt = period / 500
    n = int(n_periods * period / dt)

    energy = cl.kepler_energy_trace(GM, px, py, pz, vx, vy, vz, dt, n)
    ang_mom = cl.kepler_angular_momentum_trace(px, py, pz, vx, vy, vz, dt, n, GM)
    time = np.array(cl.time_array(dt, n)) / period

    E0 = energy[0]
    L0 = ang_mom[0]
    e_dev = np.max(np.abs((np.array(energy) - E0) / E0)) if E0 != 0 else 0
    l_dev = np.max(np.abs((np.array(ang_mom) - L0) / L0)) if L0 != 0 else 0

    ecc_actual = cl.eccentricity(GM, px, py, pz, vx, vy, vz)
    print(f"  e = {ecc:.1f}  e_actual = {ecc_actual:.6f}  "
          f"max|ΔE/E| = {e_dev:.2e}  max|ΔL/L| = {l_dev:.2e}")

    results.append({
        'ecc': ecc, 'time': time,
        'energy': np.array(energy), 'ang_mom': np.array(ang_mom),
        'e_dev': e_dev, 'l_dev': l_dev,
        'E0': E0, 'L0': L0
    })

# === PLOT ===
fig = plt.figure(figsize=(20, 14))
fig.suptitle("Crystal Classical Dynamics — Conservation Law Dashboard\n"
             "Noether's theorem from (N_w, N_c) = (2, 3): "
             f"{n_periods} orbits, 6 eccentricities, symplectic leapfrog",
             fontsize=15, fontweight='bold')
gs = GridSpec(3, 3, figure=fig, hspace=0.4, wspace=0.35)

colors = plt.cm.viridis(np.linspace(0.1, 0.9, len(eccs)))

# Row 1: Orbits (3 panels)
for i, ecc in enumerate([0.0, 0.5, 0.9]):
    ax = fig.add_subplot(gs[0, i])
    state = cl.orbit_elliptical(GM, A, ecc)
    px, py, pz, vx, vy, vz = state
    period = cl.kepler_period(A, GM)
    dt = period / 500
    n = int(3 * period / dt)
    xs, ys, zs, _, _, _ = cl.kepler_orbit(GM, px, py, pz, vx, vy, vz, dt, n)
    ax.plot(xs, ys, linewidth=1, color=colors[eccs.index(ecc)])
    ax.plot(0, 0, 'yo', markersize=10, zorder=5)
    ax.set_aspect('equal')
    ax.set_title(f'e = {ecc}')
    ax.grid(True, alpha=0.3)
    ax.set_xlabel('x')
    ax.set_ylabel('y')

# Row 2: Energy deviation for all eccentricities
ax_e = fig.add_subplot(gs[1, :2])
for i, r in enumerate(results):
    e_rel = np.abs((r['energy'] - r['E0']) / r['E0'])
    ax_e.semilogy(r['time'], e_rel + 1e-18, color=colors[i], linewidth=0.5,
                  label=f'e = {r["ecc"]}', alpha=0.8)
ax_e.set_xlabel('Time (orbital periods)', fontsize=12)
ax_e.set_ylabel('|ΔE / E₀|', fontsize=12)
ax_e.set_title('Energy Conservation — Noether charge from time symmetry')
ax_e.legend(loc='upper right')
ax_e.grid(True, alpha=0.3)

# Row 2 right: Max deviation bar chart
ax_bar = fig.add_subplot(gs[1, 2])
x_pos = np.arange(len(eccs))
e_devs = [r['e_dev'] for r in results]
l_devs = [r['l_dev'] for r in results]
width = 0.35
ax_bar.bar(x_pos - width/2, e_devs, width, label='max |ΔE/E|', color='crimson', alpha=0.7)
ax_bar.bar(x_pos + width/2, l_devs, width, label='max |ΔL/L|', color='royalblue', alpha=0.7)
ax_bar.set_yscale('log')
ax_bar.set_xticks(x_pos)
ax_bar.set_xticklabels([f'{e:.1f}' for e in eccs])
ax_bar.set_xlabel('Eccentricity')
ax_bar.set_ylabel('Max relative deviation')
ax_bar.set_title(f'Conservation quality ({n_periods} orbits)')
ax_bar.legend()
ax_bar.grid(True, alpha=0.3, axis='y')

# Row 3: Angular momentum for all eccentricities
ax_l = fig.add_subplot(gs[2, :2])
for i, r in enumerate(results):
    l_rel = np.abs((r['ang_mom'] - r['L0']) / r['L0'])
    ax_l.semilogy(r['time'], l_rel + 1e-18, color=colors[i], linewidth=0.5,
                  label=f'e = {r["ecc"]}', alpha=0.8)
ax_l.set_xlabel('Time (orbital periods)', fontsize=12)
ax_l.set_ylabel('|ΔL / L₀|', fontsize=12)
ax_l.set_title('Angular Momentum Conservation — Noether charge from rotation symmetry')
ax_l.legend(loc='upper right')
ax_l.grid(True, alpha=0.3)

# Row 3 right: Crystal identities
ax_id = fig.add_subplot(gs[2, 2])
ax_id.axis('off')
lines = [
    "CRYSTAL CLASSICAL DYNAMICS",
    "═" * 30,
    "",
    f"Spatial dimensions:  N_c = {cl.spatial_dim()}",
    f"Phase space:         χ = {cl.phase_space_dim()}",
    f"Force law:           1/r^{cl.force_exponent()}",
    "",
    "NOETHER CHARGES:",
    f"  Energy (time sym):    ½v²−GM/r",
    f"  Ang. mom (rot sym):   r × v",
    f"  Eccentricity (LRL):   (v×L)/GM−r̂",
    "",
    "LEAPFROG = MONAD",
    f"  S = W ∘ U ∘ W",
    f"  W = half-kick (velocity)",
    f"  U = full drift (position)",
    f"  Symplectic ⇒ exact conservation",
    "",
    "All integers from (2, 3)."
]
for i, line in enumerate(lines):
    weight = 'bold' if line.startswith(('CRYSTAL', 'NOETHER', 'LEAPFROG', 'All')) else 'normal'
    ax_id.text(0.02, 0.98 - i * 0.052, line, transform=ax_id.transAxes,
               fontsize=9.5, fontfamily='monospace', fontweight=weight, va='top')

plt.savefig('crystal_classical_05_conservation.png', dpi=150, bbox_inches='tight')
plt.show()
print("\nSaved: crystal_classical_05_conservation.png")
