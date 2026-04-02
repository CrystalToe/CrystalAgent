#!/usr/bin/env python3
"""Crystal Nuclear — Nuclear Radii: R = r₀·A^(1/N_c)"""
import crystal_toe as ct
import matplotlib.pyplot as plt
import numpy as np

toe = ct.Toe(); nuc = toe.nuclear()

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle("Nuclear Radii — R = r₀·A^(1/N_c) where 1/N_c = 1/3",
             fontsize=14, fontweight='bold')

# ── Left: R vs A ──
ax = axes[0]
a_range = np.arange(2, 260)
radii = [nuc.nuclear_radius(int(a)) for a in a_range]
ax.plot(a_range, radii, 'b-', linewidth=2, label='R = 1.25·A^(1/3) fm')

# Overlay A^(1/3) fit
a_cont = np.linspace(2, 260, 200)
ax.plot(a_cont, 1.25 * a_cont**(1.0/3.0), 'r--', linewidth=1.5,
        label='r₀·A^(1/N_c)', alpha=0.7)

# Mark key nuclei
for a, z, name, color in [(4, 2, 'He-4', '#e74c3c'), (56, 26, 'Fe-56', '#2ecc71'),
                            (208, 82, 'Pb-208', '#3498db')]:
    r = nuc.nuclear_radius(a)
    ax.plot(a, r, 'o', color=color, markersize=10, zorder=5)
    ax.annotate(f'{name}\nR={r:.2f} fm', xy=(a, r),
                xytext=(a + 15, r + 0.3), fontsize=9, fontweight='bold',
                arrowprops=dict(arrowstyle='->', color=color))

ax.set_xlabel('Mass number A', fontsize=11)
ax.set_ylabel('Radius R (fm)', fontsize=11)
ax.legend(fontsize=10)
ax.grid(True, alpha=0.3)

# ── Right: Volume ∝ A (extensive property) ──
ax = axes[1]
vols = [nuc.nuclear_volume(int(a)) for a in a_range]
ax.plot(a_range, vols, 'purple', linewidth=2, label='V = (4π/3)R³')
# Linear fit overlay
ax.plot(a_cont, (4*np.pi/3) * 1.25**3 * a_cont, 'r--', linewidth=1.5,
        label='∝ A (extensive)', alpha=0.7)

ax.set_xlabel('Mass number A', fontsize=11)
ax.set_ylabel('Volume (fm³)', fontsize=11)
ax.set_title('Volume is extensive: V ∝ A')
ax.legend(fontsize=10)
ax.grid(True, alpha=0.3)

# Self-test
passes, total, msgs = nuc.self_test()
fig.text(0.5, 0.01,
         f'Self-test: {passes}/{total} PASS — {nuc.observable_count()} observables from (2,3)',
         ha='center', fontsize=11, fontweight='bold',
         color='green' if passes == total else 'red')

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig('nuclear_radii.png', dpi=150, bbox_inches='tight'); plt.show()
