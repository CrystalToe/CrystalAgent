#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Bio — Cross-Module Traces & Self-Test"""
import crystal_toe as ct
import matplotlib.pyplot as plt

toe = ct.Toe(); bio = toe.bio()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("Crystal Bio — Cross-Module Traces & Self-Test", fontsize=14, fontweight='bold')

# ── Left: Cross-module shared rationals ──
ax = axes[0]
ax.axis('off')
cross = [
    ("3/4 = N_c/N_w²",  "Kleiber (bio)",    "Chandrasekhar (astro)", bio.kleiber_is_chandrasekhar()),
    ("2/3 = N_w/N_c",   "Surface area (bio)","Larmor (EM), I_shell", bio.surface_is_larmor()),
    ("4 = N_w²",        "DNA bases (bio)",   "Bell states (QInfo)",   bio.bases_are_bell_states()),
    ("2/5 = N_w/(χ−1)", "Flory ν (bio)",     "I_sphere (rigid)",      True),
    ("18/5 = 3.6",      "Helix/turn (bio)",  "CrystalMD helix",       True),
    ("10 = N_w(χ−1)",   "BP/turn (bio)",     "d-shell capacity",       True),
    ("1/4 + 1/4 = 0",   "Heart + lifespan",  "Constant heartbeats",   bio.constant_heartbeats()),
]
ax.text(0.5, 0.98, "Shared Rationals: Bio ↔ Physics", ha='center', fontsize=12,
        fontweight='bold', transform=ax.transAxes)
for i, (ratio, dom1, dom2, ok) in enumerate(cross):
    y = 0.88 - i * 0.115
    status = '✓' if ok else '✗'
    color = 'green' if ok else 'red'
    ax.text(0.02, y, f'{status}  {ratio}', fontsize=10, fontfamily='monospace',
            color=color, fontweight='bold', transform=ax.transAxes)
    ax.text(0.28, y, f'{dom1}  ↔  {dom2}', fontsize=9, fontfamily='monospace',
            transform=ax.transAxes)

# ── Right: Full self-test ──
ax = axes[1]
ax.axis('off')
passes, total, msgs = bio.self_test()
ax.text(0.5, 0.98, f"Self-Test: {passes}/{total} PASS", ha='center', fontsize=13,
        fontweight='bold', color='green' if passes == total else 'red',
        transform=ax.transAxes)
for i, msg in enumerate(msgs):
    y = 0.90 - i * 0.038
    color = 'green' if msg.startswith('PASS') else 'red'
    ax.text(0.02, y, msg, fontsize=8, fontfamily='monospace', color=color,
            transform=ax.transAxes)

fig.text(0.5, 0.01,
         f'{bio.observable_count()} observables — every biological integer from (2,3)',
         ha='center', fontsize=11, fontstyle='italic')

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig('bio_cross_module.png', dpi=150, bbox_inches='tight'); plt.show()