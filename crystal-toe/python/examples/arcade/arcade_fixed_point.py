#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Arcade — Fixed-Point 16.16 Precision (N_w⁴.N_w⁴)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); arc = toe.arcade()

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle(f"Fixed-Point {arc.fixed_bits()}.{arc.fixed_bits()} = N_w⁴.N_w⁴ Precision",
             fontsize=14, fontweight='bold')

# ── Left: Round-trip error vs value ──
ax = axes[0]
x_range = np.linspace(-10, 10, 1000)
errors = [abs(arc.fixed_round_trip(x) - x) for x in x_range]
resolution = arc.fixed_resolution()

ax.semilogy(x_range, np.maximum(errors, 1e-20), 'b.', markersize=1, alpha=0.5)
ax.axhline(y=resolution, color='red', linewidth=2, linestyle='--',
           label=f'Resolution = 1/2^{arc.fixed_bits()} = {resolution:.2e}')
ax.set_xlabel('Input value', fontsize=11)
ax.set_ylabel('Round-trip error', fontsize=11)
ax.set_title('Fixed-Point Quantization Error')
ax.legend(fontsize=10)
ax.grid(True, alpha=0.3)

# ── Right: Example values ──
ax = axes[1]
ax.axis('off')
test_vals = [0.0, 1.0, -1.0, 3.14159265, 2.71828, 0.001, 100.5]
ax.text(0.5, 0.95, f'Fixed-Point Round-Trip Examples\n'
        f'Format: {arc.fixed_bits()}.{arc.fixed_bits()} (N_w⁴.N_w⁴)\n'
        f'Resolution: {resolution:.2e}',
        ha='center', fontsize=11, fontweight='bold', transform=ax.transAxes)

headers = f'{"Input":>12}  {"Output":>12}  {"Error":>12}'
ax.text(0.1, 0.78, headers, fontsize=10, fontfamily='monospace',
        fontweight='bold', transform=ax.transAxes)
for i, x in enumerate(test_vals):
    rt = arc.fixed_round_trip(x)
    err = abs(rt - x)
    ok = '✓' if err < resolution else '✗'
    line = f'{x:>12.6f}  {rt:>12.6f}  {err:>12.2e}  {ok}'
    y = 0.70 - i * 0.08
    color = 'green' if err < resolution else 'red'
    ax.text(0.1, y, line, fontsize=10, fontfamily='monospace',
            color=color, transform=ax.transAxes)

plt.tight_layout()
plt.savefig('arcade_fixed_point.png', dpi=150, bbox_inches='tight'); plt.show()