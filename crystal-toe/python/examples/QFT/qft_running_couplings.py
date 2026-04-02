#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""Crystal QFT — Running Couplings: α_s(Q) = 2π/(β₀·ln(Q/Λ))"""
import crystal_toe as ct
import numpy as np
import matplotlib.pyplot as plt

toe = ct.Toe(); qf = toe.qft()
qs, alphas = qf.alpha_s_curve(1.0, 1000.0, 0.217, 500)

fig, axes = plt.subplots(1, 3, figsize=(18, 6))
fig.suptitle(f"Crystal QFT — Running Couplings\nα_s = 2π/(β₀·ln(Q/Λ)), β₀ = {qf.qcd_beta0()} = (11N_c−2χ)/3",
             fontsize=13, fontweight='bold')

axes[0].semilogx(qs, alphas, 'r-', linewidth=2)
axes[0].axhline(qf.alpha_s_mz(), color='blue', linestyle='--', label=f'α_s(M_Z)={qf.alpha_s_mz():.4f}')
axes[0].set_xlabel('Q (GeV)'); axes[0].set_ylabel('α_s(Q)')
axes[0].set_title(f'QCD Running (β₀={qf.qcd_beta0()})'); axes[0].legend(); axes[0].grid(True, alpha=0.3)

# QED running
q_qed = np.logspace(0, 5, 200)
a_qed = [qf.alpha_qed(0.511e-3, q) for q in q_qed]
axes[1].semilogx(q_qed, [1/a for a in a_qed], 'blue', linewidth=2)
axes[1].set_xlabel('Q (GeV)'); axes[1].set_ylabel('α⁻¹(Q)')
axes[1].set_title('QED Running'); axes[1].grid(True, alpha=0.3)

axes[2].axis('off')
for i, l in enumerate([f"QCD: α_s = 2π/(β₀·ln(Q/Λ))", f"  β₀ = {qf.qcd_beta0()} = (11·{qf.n_c()}−2·{qf.chi()})/3",
    f"  Asymptotic freedom: α_s→0 as Q→∞", "",
    f"QED: α(Q) = α₀/(1−α₀/(N_c·π)·ln(Q²/μ²))",
    f"  Landau pole at high Q", "",
    f"α⁻¹ = (D+1)π + ln(β₀) = {qf.alpha_inv():.3f}",
    f"  = {int(toe.tower_d())+1}π + ln({qf.qcd_beta0()})"]):
    axes[2].text(0.05, 0.95-i*0.1, l, transform=axes[2].transAxes, fontsize=11, fontfamily='monospace', va='top')
plt.tight_layout(); plt.savefig('qft_running.png', dpi=150, bbox_inches='tight'); plt.show()