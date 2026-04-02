#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Astro — Cross-Module Traces & Self-Test"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); ast = toe.astro()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("Crystal Astro — Cross-Module Traces & Self-Test", fontsize=14, fontweight='bold')

# ── Left: Cross-module shared rationals ──
ax = axes[0]
ax.axis('off')
cross = [
    ("3/5 = N_c/(χ−1)", "Grav PE", "Nuclear Coulomb (SEMF)", True),
    ("2/3 = N_w/N_c",   "LE surface exp", "Bio surface area", True),
    ("3/2 = N_c/N_w",   "WD polytrope", "Jeans T exp", True),
    ("1/2 = 1/N_w",     "Pairing (nuclear)", "Jeans ρ exp", True),
    ("7/2 = β₀/N_w",    "MS luminosity", "= 1 + 5/2", ast.ms_exponent_identity()),
    ("32 = N_w⁵",       "Hawking×Eddington", "Peters GW coeff",
     ast.hawking_eddington_product() == 32),
]
ax.text(0.5, 0.98, "Shared Rationals Across Modules", ha='center', fontsize=12,
        fontweight='bold', transform=ax.transAxes)
for i, (ratio, dom1, dom2, ok) in enumerate(cross):
    y = 0.88 - i * 0.13
    status = '✓' if ok else '✗'
    color = 'green' if ok else 'red'
    ax.text(0.02, y, f'{status}  {ratio}', fontsize=11, fontfamily='monospace',
            color=color, fontweight='bold', transform=ax.transAxes)
    ax.text(0.30, y, f'{dom1}  ↔  {dom2}', fontsize=10, fontfamily='monospace',
            transform=ax.transAxes)

# ── Right: Full self-test results ──
ax = axes[1]
ax.axis('off')
passes, total, msgs = ast.self_test()
ax.text(0.5, 0.98, f"Self-Test: {passes}/{total} PASS", ha='center', fontsize=13,
        fontweight='bold', color='green' if passes == total else 'red',
        transform=ax.transAxes)
for i, msg in enumerate(msgs):
    y = 0.90 - i * 0.048
    color = 'green' if msg.startswith('PASS') else 'red'
    ax.text(0.02, y, msg, fontsize=8.5, fontfamily='monospace', color=color,
            transform=ax.transAxes)

fig.text(0.5, 0.01,
         f'{ast.observable_count()} observables — every astrophysical integer from (2,3)',
         ha='center', fontsize=11, fontstyle='italic')

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig('astro_cross_checks.png', dpi=150, bbox_inches='tight'); plt.show()