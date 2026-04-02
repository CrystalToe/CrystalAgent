#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal GW — Orbital Decay: da/dt = −(64/5) μM²/a³ where 64/5 = N_w⁶/(χ−1)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); gw = toe.gw()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle("Crystal GW — Orbital Decay\nda/dt = −(64/5)μM²/a³ where 64/5 = N_w⁶/(χ−1)", fontsize=13, fontweight='bold')

for m1, m2, color in [(30,30,'b'), (10,30,'r'), (10,10,'g')]:
    t, a, f = gw.integrate_inspiral(float(m1), float(m2), 500.0, 0.5)
    axes[0].plot(t, a, color=color, linewidth=1.5, label=f'{m1}+{m2}')
    axes[1].plot(t, f, color=color, linewidth=1.5, label=f'{m1}+{m2}')
axes[0].set_xlabel('Time'); axes[0].set_ylabel('Separation a'); axes[0].set_title('Inspiral'); axes[0].legend(); axes[0].grid(True, alpha=0.3)
axes[1].set_xlabel('Time'); axes[1].set_ylabel('f_GW'); axes[1].set_title('Frequency Evolution'); axes[1].legend(); axes[1].grid(True, alpha=0.3)

a_vals = np.linspace(50, 500, 200)
for m1, m2, color in [(30,30,'b'), (10,30,'r')]:
    mu = m1*m2/(m1+m2); M = float(m1+m2)
    power = [gw.gw_power(mu, M, a) for a in a_vals]
    axes[2].semilogy(a_vals, power, color=color, linewidth=2, label=f'{m1}+{m2}')
axes[2].set_xlabel('Separation'); axes[2].set_ylabel('GW Power'); axes[2].set_title('Radiated Power'); axes[2].legend(); axes[2].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('gw_orbital_decay.png', dpi=150, bbox_inches='tight'); plt.show()