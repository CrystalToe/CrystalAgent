#!/usr/bin/env python3
"""Crystal Rigid — Torque-Free Tumbling: Euler equations + quaternion"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); rg = toe.rigid()
ens, lms, qns = rg.simulate(1.0, 2.0, 3.0, 1.0, 0.5, 0.3, 0.001, 20000)

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle(f"Crystal Rigid — Torque-Free Tumbling\nQuaternion={rg.quat_components()}=N_w², DOF={rg.rigid_dof()}=χ, Euler angles={rg.euler_angles()}=N_c",
             fontsize=13, fontweight='bold')

t = np.arange(len(ens)) * 0.001
axes[0][0].plot(t, ens, 'b-', linewidth=0.5)
axes[0][0].set_title(f'Rotational KE (max dev={(max(ens)-min(ens))/ens[0]:.2e})')
axes[0][0].set_xlabel('Time'); axes[0][0].grid(True, alpha=0.3)

axes[0][1].plot(t, lms, 'r-', linewidth=0.5)
axes[0][1].set_title(f'|L| Conservation (max dev={(max(lms)-min(lms))/lms[0]:.2e})')
axes[0][1].set_xlabel('Time'); axes[0][1].grid(True, alpha=0.3)

axes[1][0].plot(t, qns, 'green', linewidth=0.5)
axes[1][0].set_title('Quaternion Norm (should = 1)'); axes[1][0].set_xlabel('Time'); axes[1][0].grid(True, alpha=0.3)

axes[1][1].axis('off')
for i, l in enumerate([f"Quaternion = {rg.quat_components()} = N_w² components",
    f"Inertia tensor = {rg.inertia_indep()} = χ independent",
    f"DOF = {rg.rigid_dof()} = χ (3 trans + 3 rot)",
    f"Rot matrix = {rg.rot_matrix()} = N_c² entries",
    f"Euler angles = {rg.euler_angles()} = N_c", "",
    f"Euler eqns: dω/dt = (I×ω)/I", f"Quat update: dq/dt = ½q·ω"]):
    axes[1][1].text(0.05, 0.95-i*0.11, l, transform=axes[1][1].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('rigid_tumbling.png', dpi=150, bbox_inches='tight'); plt.show()
