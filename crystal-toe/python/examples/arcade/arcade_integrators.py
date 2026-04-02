#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Arcade — Euler (d₁=1) vs Verlet (N_w=2) Integrators"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); arc = toe.arcade()

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle(f"Integrators: Euler (order d₁={arc.euler_order()}) vs Verlet (order N_w={arc.verlet_order()})",
             fontsize=14, fontweight='bold')

# Simple harmonic oscillator: x'' = -x, x(0)=1, v(0)=0
dt = 0.1
n_steps = 200
t = np.arange(n_steps) * dt

# Exact solution
x_exact = np.cos(t)

# Euler integration
x_euler = np.zeros(n_steps); v_euler = np.zeros(n_steps)
x_euler[0] = 1.0; v_euler[0] = 0.0
for i in range(n_steps - 1):
    x_euler[i+1] = arc.euler_step(x_euler[i], v_euler[i], dt)
    v_euler[i+1] = v_euler[i] + (-x_euler[i]) * dt  # Euler for v too

# Verlet integration
x_verlet = np.zeros(n_steps); v_verlet = np.zeros(n_steps)
x_verlet[0] = 1.0; v_verlet[0] = 0.0
for i in range(n_steps - 1):
    a = -x_verlet[i]
    x_verlet[i+1] = arc.verlet_step(x_verlet[i], v_verlet[i], a, dt)
    a_new = -x_verlet[i+1]
    v_verlet[i+1] = v_verlet[i] + 0.5 * (a + a_new) * dt

# ── Left: Trajectories ──
ax = axes[0]
ax.plot(t, x_exact, 'k-', linewidth=2, label='Exact: cos(t)')
ax.plot(t, x_euler, 'r--', linewidth=1.5, label=f'Euler (order {arc.euler_order()})')
ax.plot(t, x_verlet, 'b:', linewidth=2, label=f'Verlet (order {arc.verlet_order()})')
ax.set_xlabel('Time', fontsize=11); ax.set_ylabel('x(t)', fontsize=11)
ax.set_title('Harmonic Oscillator Trajectories')
ax.legend(fontsize=10)
ax.grid(True, alpha=0.3)

# ── Right: Errors ──
ax = axes[1]
err_euler = np.abs(x_euler - x_exact)
err_verlet = np.abs(x_verlet - x_exact)
ax.semilogy(t, err_euler, 'r-', linewidth=2, label=f'Euler error (order d₁={arc.euler_order()})')
ax.semilogy(t, np.maximum(err_verlet, 1e-16), 'b-', linewidth=2,
            label=f'Verlet error (order N_w={arc.verlet_order()})')
ax.set_xlabel('Time', fontsize=11); ax.set_ylabel('|error|', fontsize=11)
ax.set_title('Integration Error')
ax.legend(fontsize=10)
ax.grid(True, alpha=0.3, which='both')

plt.tight_layout()
plt.savefig('arcade_integrators.png', dpi=150, bbox_inches='tight'); plt.show()