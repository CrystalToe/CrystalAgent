#!/usr/bin/env python3
"""Crystal GW — Chirp Mass: M_c = μ^(3/5) M^(2/5) where 3/5=N_c/(χ−1), 2/5=N_w/(χ−1)"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); gw = toe.gw()
m_total = 60.0
q_vals = np.linspace(0.05, 1.0, 200)
mc_vals = [gw.chirp_mass(m_total*q/(1+q), m_total/(1+q)) for q in q_vals]
ttm_vals = [gw.time_to_merger(mc, 0.001) for mc in mc_vals]

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal GW — Chirp Mass\nM_c = μ^(N_c/(χ−1)) × M^(N_w/(χ−1)) = μ^(3/5) × M^(2/5)", fontsize=13, fontweight='bold')
axes[0].plot(q_vals, mc_vals, 'b-', linewidth=2); axes[0].set_xlabel('Mass ratio q'); axes[0].set_ylabel('M_chirp')
axes[0].set_title(f'Chirp Mass vs q (M_total={m_total:.0f})'); axes[0].grid(True, alpha=0.3)
axes[1].semilogy(q_vals, ttm_vals, 'r-', linewidth=2); axes[1].set_xlabel('q'); axes[1].set_ylabel('t_merge')
axes[1].set_title('Time to Merger vs q'); axes[1].grid(True, alpha=0.3)
masses = [(10,10),(20,20),(30,30),(10,30),(5,50)]
for m1,m2 in masses:
    mc = gw.chirp_mass(m1, m2); f_isco = gw.isco_frequency(m1+m2)
    t,f,hp,_ = gw.inspiral_waveform(m1, m2, 1e6, 0.0, f_isco/30, 0.3)
    axes[2].plot(t, hp, linewidth=0.5, label=f'{m1}+{m2}')
axes[2].set_title('Waveforms by Mass'); axes[2].legend(fontsize=9); axes[2].grid(True, alpha=0.3)
plt.tight_layout(); plt.savefig('gw_chirp_mass.png', dpi=150, bbox_inches='tight'); plt.show()
