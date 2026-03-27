# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""44 — The Hadron Spectrum Overview"""
from crystal_topos import n_w, n_c, chi, beta0, d_total, gauss
import math

print("The Hadron Spectrum from Two Primes")
print("=" * 55)
v_mev = 246220.0
fermat3 = 2**(2**n_c()) + 1
lambda_h = v_mev / fermat3
m_p = v_mev / 2**(2**n_c()) * (d_total()+gauss()-n_w()) / (d_total()+gauss()-n_w()+1)
m_pi = m_p / beta0()
m_e = lambda_h / (n_c()**2 * n_w()**4 * gauss())
lambda_qcd = m_p * n_c() / gauss()

particles = [
    ("π⁰",    m_pi,                                          134.977),
    ("K±",    m_pi*(gauss()-n_w())/n_c(),                    493.677),
    ("η",     lambda_h*n_w()**2/beta0(),                     547.862),
    ("ρ",     m_pi*(d_total()-beta0())/chi(),                775.26),
    ("p",     m_p,                                            938.272),
    ("η'",    lambda_h,                                       957.78),
    ("Δ",     lambda_h+lambda_qcd+m_pi*n_c()/beta0(),       1232.0),
    ("Ξ",     lambda_h*(gauss()-n_w())/n_w()**3,             1314.86),
    ("τ",     lambda_h*gauss()/beta0(),                      1776.86),
    ("D_s",   lambda_h*n_w()+m_pi/n_c(),                    1968.34),
    ("J/ψ",   lambda_h*gauss()/n_w()**2,                    3096.9),
    ("B_s",   lambda_h*(n_c()*gauss()/beta0()),              5366.88),
    ("Λ_b",   lambda_h*chi()-m_pi,                           5619.60),
]

print(f"\n  Λ_h = v/{fermat3} = {lambda_h:.2f} MeV")
print(f"\n  {'Particle':<8} {'Crystal':>10} {'PDG':>10} {'PWI':>8}")
print(f"  {'--------':<8} {'-------':>10} {'---':>10} {'---':>8}")
for name, crys, pdg in particles:
    pw = abs(crys-pdg)/pdg*100
    print(f"  {name:<8} {crys:>10.1f} {pdg:>10.1f} {pw:>7.3f}%")
