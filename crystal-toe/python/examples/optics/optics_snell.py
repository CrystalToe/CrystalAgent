#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Optics — Snell's Law & Total Internal Reflection"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); op = toe.optics()
angles = np.linspace(0, 89, 200)
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal Optics — Snell's Law\nn₁sinθ₁ = n₂sinθ₂, crystal refractive indices", fontsize=13, fontweight='bold')

# Air → material refraction
for n2, name, c in [(op.n_water(),'Water','blue'), (op.n_glass(),'Glass','green'), (op.n_diamond(),'Diamond','red')]:
    refracted = []
    for a in angles:
        t = op.snell(1.0, n2, np.radians(a))
        refracted.append(np.degrees(t) if t is not None else None)
    valid = [(a,r) for a,r in zip(angles, refracted) if r is not None]
    if valid:
        axes[0].plot([v[0] for v in valid], [v[1] for v in valid], color=c, linewidth=2, label=f'{name} (n={n2:.2f})')
axes[0].plot(angles, angles, 'k--', linewidth=0.5, label='n=1')
axes[0].set_xlabel('θ_incident (°)'); axes[0].set_ylabel('θ_refracted (°)')
axes[0].set_title('Air → Material'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

# TIR: material → air
for n1, name, c in [(op.n_water(),'Water','blue'), (op.n_glass(),'Glass','green'), (op.n_diamond(),'Diamond','red')]:
    tc = op.critical_angle(n1, 1.0)
    if tc is not None:
        tc_deg = np.degrees(tc)
        axes[1].barh(name, tc_deg, color=c, alpha=0.7)
        axes[1].text(tc_deg+1, list(range(3))[['Water','Glass','Diamond'].index(name)], f'{tc_deg:.1f}°', va='center')
axes[1].set_xlabel('Critical Angle (°)'); axes[1].set_title('Total Internal Reflection')
axes[1].grid(True, alpha=0.3, axis='x')

axes[2].axis('off')
for i, l in enumerate([f"n_water = C_F = 4/3 = {op.n_water():.4f}", f"n_glass = N_c/N_w = 3/2 = {op.n_glass():.4f}",
    f"n_diamond = gauss/(χ−1) = 13/5 = {op.n_diamond():.4f}", "",
    f"Critical angles:", f"  Water→Air: {np.degrees(op.critical_angle(op.n_water(), 1.0)):.1f}°",
    f"  Glass→Air: {np.degrees(op.critical_angle(op.n_glass(), 1.0)):.1f}°",
    f"  Diamond→Air: {np.degrees(op.critical_angle(op.n_diamond(), 1.0)):.1f}°"]):
    axes[2].text(0.05, 0.95-i*0.11, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('optics_snell.png', dpi=150, bbox_inches='tight'); plt.show()