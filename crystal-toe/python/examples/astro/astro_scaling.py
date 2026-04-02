#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Astro — Main Sequence Scaling Laws from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); ast = toe.astro()

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle("Main Sequence Scaling — L ~ M^(β₀/N_w), t ~ M^(−(χ−1)/N_w)",
             fontsize=13, fontweight='bold')

m_range = np.logspace(-0.5, 1.5, 100)  # 0.3 to ~30 solar masses

# ── Left: Luminosity ──
ax = axes[0]
lum = [ast.ms_luminosity(m) for m in m_range]
ax.loglog(m_range, lum, 'r-', linewidth=2.5, label=f'L ~ M^({ast.ms_lum_exp()[0]}/{ast.ms_lum_exp()[1]})')
# Mark solar
ax.plot(1, 1, '*', color='gold', markersize=20, zorder=5, markeredgecolor='orange')
ax.annotate('Sun', xy=(1, 1), xytext=(1.5, 0.3), fontsize=11,
            arrowprops=dict(arrowstyle='->', color='orange'))
# Mark 10 M_sun
l10 = ast.ms_luminosity(10.0)
ax.plot(10, l10, 'o', color='blue', markersize=10, zorder=5)
ax.annotate(f'10 M☉\nL={l10:.0f} L☉', xy=(10, l10), xytext=(15, l10/5),
            fontsize=9, arrowprops=dict(arrowstyle='->', color='blue'))
ax.set_xlabel('M / M☉', fontsize=11)
ax.set_ylabel('L / L☉', fontsize=11)
ax.set_title(f'Luminosity: M^(β₀/N_w) = M^3.5')
ax.legend(fontsize=11)
ax.grid(True, alpha=0.3, which='both')

# ── Right: Lifetime ──
ax = axes[1]
life = [ast.ms_lifetime(m) for m in m_range]
ax.loglog(m_range, life, 'b-', linewidth=2.5, label=f't ~ M^(−{ast.ms_life_exp()[0]}/{ast.ms_life_exp()[1]})')
ax.plot(1, 1, '*', color='gold', markersize=20, zorder=5, markeredgecolor='orange')
ax.annotate('Sun\n~10 Gyr', xy=(1, 1), xytext=(0.4, 0.15), fontsize=10,
            arrowprops=dict(arrowstyle='->', color='orange'))
t10 = ast.ms_lifetime(10.0)
ax.plot(10, t10, 'o', color='red', markersize=10, zorder=5)
ax.annotate(f'10 M☉\n~{t10*10:.0f} Myr', xy=(10, t10), xytext=(15, t10*3),
            fontsize=9, arrowprops=dict(arrowstyle='->', color='red'))
ax.set_xlabel('M / M☉', fontsize=11)
ax.set_ylabel('t / t☉', fontsize=11)
ax.set_title(f'Lifetime: M^(−(χ−1)/N_w) = M^(−2.5)')
ax.legend(fontsize=11)
ax.grid(True, alpha=0.3, which='both')

plt.tight_layout()
plt.savefig('astro_scaling.png', dpi=150, bbox_inches='tight'); plt.show()