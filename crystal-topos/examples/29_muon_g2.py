# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""29 — Muon Anomalous Magnetic Moment"""
from crystal_topos import n_w, n_c, d_total, beta0, gauss
import math

print("Muon g-2 from the Crystal")
print("=" * 55)
alpha = 1.0 / ((d_total() + 1) * math.pi + math.log(beta0()))
a_mu_lo = alpha / (2 * math.pi)
print(f"\n  Leading order: a_μ = α/(2π)")
print(f"  α = 1/((D+1)π + ln β₀) = 1/(43π + ln 7)")
print(f"  α = {alpha:.8f}")
print(f"  a_μ(LO) = {a_mu_lo:.8f}")
print(f"\n  Crystal prediction: the anomaly persists.")
print(f"  Falsifiable: Fermilab Run 4/5 (2025-2028).")
print(f"  If it vanishes, the crystal is dead.")
