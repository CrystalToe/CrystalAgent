#!/usr/bin/env python3
"""
Crystal N-Body — Inner Solar System
=====================================
Sun + Mercury + Venus + Earth + Mars.
Symplectic leapfrog preserves orbital structure over many periods.
"""

import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
nb = toe.nbody()

bodies = nb.solar_system_inner()
names = ['Sun', 'Mercury', 'Venus', 'Earth', 'Mars']
colors = ['gold', 'gray', 'orange', 'royalblue', 'red']

eps = 1e-6
dt = 0.0005  # ~0.18 days
n_steps = 10000  # ~5 years

print("Simulating inner solar system...")
snaps = nb.evolve_direct(dt, eps, n_steps, bodies)
print(f"Done. {len(snaps)} snapshots.")

fig, axes = plt.subplots(1, 3, figsize=(20, 6))
fig.suptitle("Crystal N-Body — Inner Solar System\n"
             f"Toe(v={toe.vev():.0f} MeV) → nbody() | Sun + 4 planets, leapfrog W∘U∘W",
             fontsize=13, fontweight='bold')

# Orbits
ax = axes[0]
for i in range(1, 5):
    x = [s[i][0] for s in snaps]
    y = [s[i][1] for s in snaps]
    ax.plot(x, y, color=colors[i], linewidth=0.5, label=names[i])
ax.plot(0, 0, 'o', color='gold', markersize=12)
ax.set_aspect('equal'); ax.legend(loc='upper right')
ax.set_xlabel('x (AU)'); ax.set_ylabel('y (AU)')
ax.set_title('Planetary Orbits'); ax.grid(True, alpha=0.3)

# Radii vs time
ax2 = axes[1]
time = np.arange(len(snaps)) * dt
for i in range(1, 5):
    r = [np.sqrt(s[i][0]**2 + s[i][1]**2 + s[i][2]**2) for s in snaps[::10]]
    t = time[::10]
    ax2.plot(t, r, color=colors[i], linewidth=0.5, label=names[i])
ax2.set_xlabel('Time (yr)'); ax2.set_ylabel('r (AU)')
ax2.set_title('Orbital Radii'); ax2.legend(); ax2.grid(True, alpha=0.3)

# Energy conservation
ax3 = axes[2]
energies = [nb.total_energy(eps, s) for s in snaps[::20]]
e0 = energies[0]
e_dev = np.abs((np.array(energies) - e0) / abs(e0))
ax3.semilogy(time[::20], e_dev + 1e-20, 'purple', linewidth=0.5)
ax3.set_xlabel('Time (yr)'); ax3.set_ylabel('|ΔE/E₀|')
ax3.set_title(f'Energy Conservation (max={e_dev.max():.2e})')
ax3.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('nbody_solar_system.png', dpi=150, bbox_inches='tight')
plt.show()
