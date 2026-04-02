#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Bio — Allometric Scaling from (2,3)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); bio = toe.bio()

fig, axes = plt.subplots(2, 2, figsize=(13, 10))
fig.suptitle("Allometric Scaling — Kleiber, Heart Rate, Lifespan, Surface",
             fontsize=14, fontweight='bold')

m_range = np.logspace(-2, 4, 200)  # mouse to whale

# ── Kleiber: P ~ M^(3/4) ──
ax = axes[0, 0]
p = [bio.kleiber(m) for m in m_range]
ax.loglog(m_range, p, 'r-', linewidth=2.5)
ax.set_xlabel('Body mass (relative)'); ax.set_ylabel('Metabolic rate (relative)')
k = bio.kleiber_exp_frac()
ax.set_title(f'Kleiber: P ~ M^({k[0]}/{k[1]}) = M^(N_c/N_w²)')
ax.grid(True, alpha=0.3, which='both')

# ── Heart rate: f ~ M^(-1/4) ──
ax = axes[0, 1]
hr = [bio.heart_rate(m) for m in m_range]
ax.loglog(m_range, hr, 'b-', linewidth=2.5)
ax.set_xlabel('Body mass (relative)'); ax.set_ylabel('Heart rate (relative)')
ax.set_title('Heart rate: f ~ M^(−1/N_w²) = M^(−1/4)')
ax.grid(True, alpha=0.3, which='both')

# ── Lifespan: T ~ M^(1/4) ──
ax = axes[1, 0]
ls = [bio.lifespan(m) for m in m_range]
ax.loglog(m_range, ls, 'g-', linewidth=2.5)
ax.set_xlabel('Body mass (relative)'); ax.set_ylabel('Lifespan (relative)')
ax.set_title('Lifespan: T ~ M^(1/N_w²) = M^(1/4)')
ax.grid(True, alpha=0.3, which='both')

# ── Total heartbeats: constant! ──
ax = axes[1, 1]
total_hb = [bio.heart_rate(m) * bio.lifespan(m) for m in m_range]
ax.semilogx(m_range, total_hb, 'm-', linewidth=2.5)
ax.axhline(y=1.0, color='gray', linewidth=1.5, linestyle='--')
ax.set_xlabel('Body mass (relative)'); ax.set_ylabel('Total heartbeats (relative)')
ax.set_title(f'Constant heartbeats: exponents cancel!\n'
             f'heart({bio.heart_rate_exponent():.2f}) + life({bio.lifespan_exponent():.2f}) = 0')
ax.set_ylim(0.5, 1.5)
ax.grid(True, alpha=0.3)
ax.text(0.5, 0.15, f'✓ constant_heartbeats = {bio.constant_heartbeats()}',
        transform=ax.transAxes, fontsize=11, fontweight='bold', ha='center',
        color='green', bbox=dict(boxstyle='round', facecolor='lightyellow'))

plt.tight_layout()
plt.savefig('bio_allometric.png', dpi=150, bbox_inches='tight'); plt.show()