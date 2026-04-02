#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal QInfo — MERA Structure & Teleport/Superdense Duality"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); qi = toe.qinfo()

fig, axes = plt.subplots(1, 2, figsize=(14, 7))
fig.suptitle("MERA Tower & Information Duality — from (2,3)", fontsize=14, fontweight='bold')

# ── Left: MERA tower schematic ──
ax = axes[0]
ax.set_xlim(-3, 3); ax.set_ylim(-0.5, 8)
ax.set_title(f'MERA: bond χ={qi.mera_bond()}, depth D={qi.mera_depth()}',
             fontsize=12, fontweight='bold')

# Draw layers of the tensor network
n_show = 8  # show 8 layers
for layer in range(n_show):
    y = layer * 0.9
    n_sites = max(1, 2**(n_show - layer - 1) // 4)
    n_sites = min(n_sites, 8)
    xs = np.linspace(-2, 2, max(n_sites, 2))
    for x in xs:
        ax.plot(x, y, 's', color='#3498db', markersize=10 + layer,
                markeredgecolor='black', zorder=3)
    # Draw bonds
    if layer < n_show - 1:
        xs_next = np.linspace(-2, 2, max(n_sites // 2, 2))
        for x1 in xs:
            closest = min(xs_next, key=lambda xn: abs(xn - x1))
            ax.plot([x1, closest], [y, y + 0.9], '-',
                    color='#e74c3c', linewidth=1.5, alpha=0.6)

ax.text(2.5, 3, f'Bond dim = χ = {qi.mera_bond()}\n'
        f'Each bond: S = ln(χ)\n'
        f'= {qi.mera_link_entropy():.3f} nats\n\n'
        f'Total depth: D = {qi.mera_depth()}\n'
        f'= Σ_d + χ = 36 + 6',
        fontsize=10, fontfamily='monospace',
        bbox=dict(boxstyle='round', facecolor='lightyellow', alpha=0.9))
ax.set_xticks([]); ax.set_yticks([])
ax.set_xlabel('← UV (many sites)        IR (few sites) →', fontsize=10)

# ── Right: Teleportation / Superdense duality ──
ax = axes[1]
ax.axis('off')
ax.set_xlim(0, 1); ax.set_ylim(0, 1)
ax.set_title('Teleportation ↔ Superdense Duality', fontsize=12, fontweight='bold')

# Teleportation box
ax.add_patch(plt.Rectangle((0.05, 0.55), 0.4, 0.35, fill=True,
             facecolor='#3498db', alpha=0.2, edgecolor='#3498db', linewidth=2))
ax.text(0.25, 0.82, 'TELEPORTATION', ha='center', fontsize=11, fontweight='bold', color='#3498db')
ax.text(0.25, 0.72, f'1 Bell pair\n+ {qi.teleport_bits()} classical bits (N_w)\n= 1 qubit transferred',
        ha='center', fontsize=10, fontfamily='monospace')

# Superdense box
ax.add_patch(plt.Rectangle((0.55, 0.55), 0.4, 0.35, fill=True,
             facecolor='#e74c3c', alpha=0.2, edgecolor='#e74c3c', linewidth=2))
ax.text(0.75, 0.82, 'SUPERDENSE', ha='center', fontsize=11, fontweight='bold', color='#e74c3c')
ax.text(0.75, 0.72, f'1 Bell pair\n+ 1 qubit\n= {qi.superdense_bits()} classical bits (N_w)',
        ha='center', fontsize=10, fontfamily='monospace')

# Duality arrow
ax.annotate('', xy=(0.55, 0.725), xytext=(0.45, 0.725),
            arrowprops=dict(arrowstyle='<->', color='black', lw=2))
ax.text(0.5, 0.75, 'DUAL', ha='center', fontsize=9, fontweight='bold')

# Key insight
ax.text(0.5, 0.35, f'N_w = {qi.teleport_bits()} appears in BOTH protocols\n'
        f'Bell entropy = ln(N_w) = {qi.bell_entropy():.4f} nats\n\n'
        f'N_w coprime with N_c → uncertainty principle\n'
        f'meet(1/N_w, 1/N_c) = 1/χ = 1/{qi.chi()}',
        ha='center', fontsize=11, fontfamily='monospace',
        bbox=dict(boxstyle='round', facecolor='lightyellow', alpha=0.9))

# Self-test
passes, total, msgs = qi.self_test()
fig.text(0.5, 0.01,
         f'Self-test: {passes}/{total} PASS — {qi.observable_count()} observables from (2,3)',
         ha='center', fontsize=11, fontweight='bold',
         color='green' if passes == total else 'red')

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig('qinfo_mera.png', dpi=150, bbox_inches='tight'); plt.show()