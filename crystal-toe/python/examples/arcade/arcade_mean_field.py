#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Arcade — Mean-Field vs Exact Ising & Self-Test"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); arc = toe.arcade()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("Arcade Approximation Quality — Mean-Field, Fast InvSqrt, Self-Test",
             fontsize=14, fontweight='bold')

# ── Left: Mean-field vs Onsager + fast inv sqrt ──
ax = axes[0]
ax.axis('off')
ax.set_xlim(0, 1); ax.set_ylim(0, 1)

# Mean-field comparison
tc_mf = float(arc.mf_tc())
tc_exact = arc.onsager_tc()
mf_ratio = arc.mean_field_error()

ax.text(0.5, 0.92, 'Mean-Field vs Exact Ising T_c', ha='center',
        fontsize=12, fontweight='bold', transform=ax.transAxes)
ax.text(0.1, 0.80, f'Mean-field T_c = N_w² = {tc_mf:.1f}', fontsize=11,
        fontfamily='monospace', color='#e74c3c', transform=ax.transAxes)
ax.text(0.1, 0.72, f'Onsager exact  = 2/ln(1+√2) = {tc_exact:.3f}', fontsize=11,
        fontfamily='monospace', color='#2ecc71', transform=ax.transAxes)
ax.text(0.1, 0.64, f'Ratio = {mf_ratio:.3f} (MF overestimates by {(mf_ratio-1)*100:.0f}%)',
        fontsize=11, fontfamily='monospace', transform=ax.transAxes)

# Fast inv sqrt
exact_isqrt = 1.0 / np.sqrt(2.0)
fast_isqrt = arc.fast_inv_sqrt(2.0)
ax.text(0.5, 0.48, f'Fast Inverse Square Root', ha='center',
        fontsize=12, fontweight='bold', transform=ax.transAxes)
ax.text(0.1, 0.38, f'1/√2 exact = {exact_isqrt:.15f}', fontsize=10,
        fontfamily='monospace', transform=ax.transAxes)
ax.text(0.1, 0.30, f'fast ({arc.newton_iter()} iter) = {fast_isqrt:.15f}', fontsize=10,
        fontfamily='monospace', transform=ax.transAxes)
ax.text(0.1, 0.22, f'N_w = {arc.newton_iter()} Newton iterations → converged',
        fontsize=10, fontfamily='monospace', color='green', transform=ax.transAxes)

# Alpha check
ax.text(0.5, 0.10, f'α⁻¹ = ⌊(D+1)π + ln β₀⌋ = {arc.fast_alpha_inv()}  ✓ = {arc.verify_alpha_inv()}',
        ha='center', fontsize=11, fontfamily='monospace', fontweight='bold',
        color='green', transform=ax.transAxes)

# ── Right: Full self-test ──
ax = axes[1]
ax.axis('off')
passes, total, msgs = arc.self_test()
ax.text(0.5, 0.98, f"Self-Test: {passes}/{total} PASS", ha='center', fontsize=13,
        fontweight='bold', color='green' if passes == total else 'red',
        transform=ax.transAxes)
for i, msg in enumerate(msgs):
    y = 0.90 - i * 0.042
    color = 'green' if msg.startswith('PASS') else 'red'
    ax.text(0.02, y, msg, fontsize=8.5, fontfamily='monospace', color=color,
            transform=ax.transAxes)

fig.text(0.5, 0.01,
         f'{arc.observable_count()} observables — every approximation parameter from (2,3)',
         ha='center', fontsize=11, fontstyle='italic')

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig('arcade_mean_field.png', dpi=150, bbox_inches='tight'); plt.show()