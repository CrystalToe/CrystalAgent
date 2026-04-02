#!/usr/bin/env python3
"""Crystal EM — Planck λ^(−5) and Stefan T⁴: exponents from (2,3)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); em = toe.em()
fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal EM — Planck & Stefan-Boltzmann\n"
             f"λ^(−(χ−1)) = λ^(−{em.planck_exponent()}), T^(N_w²) = T^{em.stefan_exponent()}", fontsize=13, fontweight='bold')

temps = [3000, 4000, 5000, 6000, 8000]
lam = np.linspace(100e-9, 3000e-9, 500)
for T in temps:
    # Simplified Planck: B ∝ λ^{-5} / (exp(hc/λkT) - 1)
    x = 0.0143 / (lam * T)  # hc/kT proxy
    B = lam**(-em.planck_exponent()) / (np.exp(np.clip(x, 0, 50)) - 1)
    B /= np.max(B)
    axes[0].plot(lam*1e9, B, linewidth=1.5, label=f'{T}K')
axes[0].set_xlabel('λ (nm)'); axes[0].set_ylabel('B (normalized)'); axes[0].set_title(f'Planck: λ^(−{em.planck_exponent()}) = λ^(−(χ−1))')
axes[0].legend(); axes[0].grid(True, alpha=0.3); axes[0].set_xlim(0, 2000)

T_arr = np.linspace(100, 10000, 200)
P = [em.stefan_boltzmann_power(T) for T in T_arr]
axes[1].semilogy(T_arr, P, 'red', linewidth=2); axes[1].set_xlabel('T (K)'); axes[1].set_ylabel('P ∝ T⁴')
axes[1].set_title(f'Stefan-Boltzmann: T^{em.stefan_exponent()} = T^(N_w²)'); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"Planck exp = χ−1 = {em.planck_exponent()}", f"Stefan exp = N_w² = {em.stefan_exponent()}",
    f"Stefan denom = N_c(χ−1) = {em.stefan_denom()}", f"Z₀ = 120π = N_w·N_c·(gauss+β₀)·π",
    f"  = {em.wave_impedance():.2f} Ω", "", f"Three derivations of N_w² = 4:",
    f"  Stefan T⁴, Rayleigh λ⁻⁴, Bekenstein A/4G"]):
    axes[2].text(0.05, 0.95-i*0.11, l, transform=axes[2].transAxes, fontsize=12, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('em_planck_stefan.png', dpi=150, bbox_inches='tight'); plt.show()
