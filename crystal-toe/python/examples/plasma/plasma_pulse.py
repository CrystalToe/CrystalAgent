#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal Plasma — Alfvén Pulse Propagation"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); pl = toe.plasma()
vys, bys, ens = pl.simulate_alfven(300, 0.5, 600, 40, True)

fig, ax = plt.subplots(figsize=(14, 6))
fig.suptitle("Crystal Plasma — Alfvén Pulse Propagation\nv_A = 1 (normalised), pulse splits left+right",
             fontsize=13, fontweight='bold')
x = np.linspace(0, 1, len(vys[0]))
for i, vy in enumerate(vys):
    ax.plot(x, np.array(vy) + i*0.3, 'b-', linewidth=0.8, alpha=0.7)
ax.set_xlabel('x'); ax.set_ylabel('v_y + offset'); ax.set_title('Waterfall Plot')
ax.grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('plasma_pulse.png', dpi=150, bbox_inches='tight'); plt.show()