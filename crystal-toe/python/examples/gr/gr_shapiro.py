#!/usr/bin/env python3
"""
Crystal GR — Shapiro Time Delay
=================================
Δt = 2·r_s·ln(4·r₁·r₂/b²) where 2=N_c−1, 4=N_w².
Radio signals slow down near massive objects.
"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe()
gr = toe.gr()

# Sun parameters
gm_sun = 1.327e11  # km³/s²
rs_sun = gr.schwarzschild_r(gm_sun / 3e5**2)  # convert to geometric units
r_earth = 1.496e8  # km
r_mars = 2.279e8

# Shapiro delay as signal grazes Sun at different impact parameters
b_vals = np.linspace(6.957e5, 5e6, 200)  # from Sun surface outward
delays = [gr.shapiro_delay(gm_sun/9e10, r_earth, r_mars, b) * 1e6 for b in b_vals]  # microseconds

print(f"Shapiro delay coefficients: ({gr.n_c()-1}, {gr.bending_factor()}) = (N_c−1, N_w²)")
print(f"At Sun limb: {delays[0]:.1f} μs")

fig, axes = plt.subplots(1, 2, figsize=(14, 6))
fig.suptitle(f"Crystal GR — Shapiro Time Delay\nToe(v={toe.vev():.0f} MeV) → gr() | "
             f"Δt = (N_c−1)·r_s·ln(N_w²·r₁r₂/b²)",
             fontsize=13, fontweight='bold')

axes[0].plot(np.array(b_vals)/6.957e5, delays, 'darkorange', linewidth=2)
axes[0].set_xlabel('Impact parameter b / R☉'); axes[0].set_ylabel('Delay (μs)')
axes[0].set_title('Shapiro Delay: Earth–Mars Signal'); axes[0].grid(True, alpha=0.3)

# Frequency ratio (redshift) at different radii
r_vals = np.linspace(1.5*rs_sun, 20*rs_sun, 200)
ratios = [gr.frequency_ratio(rs_sun, r, 1e10) for r in r_vals]  # emit at r, receive at infinity
axes[1].plot(r_vals/rs_sun, ratios, 'darkred', linewidth=2)
axes[1].set_xlabel('Emission radius r / r_s'); axes[1].set_ylabel('f_recv / f_emit')
axes[1].set_title('Gravitational Frequency Shift'); axes[1].grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('gr_shapiro.png', dpi=150, bbox_inches='tight'); plt.show()
