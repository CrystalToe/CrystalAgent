#!/usr/bin/env python3
"""Crystal Thermo — MD Simulation with Energy Conservation"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); th = toe.thermo()
gas = th.make_gas(6, 0.3, 2.5)
eps, sigma, cutoff = 1.0, 1.0, 5.0

e0 = th.total_energy(eps, sigma, cutoff, gas)
t0 = th.temperature(gas)
print(f"Initial E={e0:.4f}, T={t0:.4f}, N={len(gas)}")

snaps = th.simulate(0.002, eps, sigma, cutoff, 1000, 10, gas)

energies = [th.total_energy(eps, sigma, cutoff, s) for s in snaps]
temps = [th.temperature(s) for s in snaps]
ke = [th.kinetic_energy(s) for s in snaps]

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle(f"Crystal Thermo — MD Simulation\nToe(v={toe.vev():.0f} MeV) → thermo() | "
             f"LJ {th.lj_attract()}-{th.lj_repel()}, Verlet W∘U∘W", fontsize=13, fontweight='bold')

# Trajectories
for i in range(min(len(gas), 6)):
    x = [s[i][0] for s in snaps]; y = [s[i][1] for s in snaps]
    axes[0][0].plot(x, y, linewidth=0.5, alpha=0.7)
axes[0][0].set_title('Particle Trajectories'); axes[0][0].set_xlabel('x'); axes[0][0].set_ylabel('y'); axes[0][0].grid(True, alpha=0.3)

e_dev = np.abs((np.array(energies)-e0)/(abs(e0)+1e-20))
axes[0][1].semilogy(range(len(energies)), e_dev+1e-20, 'purple', linewidth=1)
axes[0][1].set_title(f'Energy Conservation (max={e_dev.max():.2e})'); axes[0][1].grid(True, alpha=0.3)

axes[1][0].plot(range(len(temps)), temps, 'red', linewidth=1)
axes[1][0].set_title('Temperature'); axes[1][0].set_xlabel('Snapshot'); axes[1][0].grid(True, alpha=0.3)

axes[1][1].plot(range(len(ke)), ke, 'blue', linewidth=1, label='KE')
axes[1][1].plot(range(len(energies)), np.array(energies)-np.array(ke), 'green', linewidth=1, label='PE')
axes[1][1].set_title('KE vs PE'); axes[1][1].legend(); axes[1][1].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('thermo_md.png', dpi=150, bbox_inches='tight'); plt.show()
