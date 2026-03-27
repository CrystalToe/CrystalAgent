# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""26 — Black Hole Thermodynamics"""
from crystal_topos import n_w, n_c, chi, d_total, gauss
import math

print("Black Hole Thermodynamics from the Crystal")
print("=" * 55)
print(f"\n  Bekenstein bound = N_w² = {n_w()**2}")
print(f"  S_BH = A / (4 G_N) — the 4 IS N_w².")
print(f"\n  Hawking temperature:")
print(f"  T_H = ℏc³ / (8πGM)")
print(f"  8π = N_w³ × π = {n_w()**3}π")
print(f"\n  Information paradox:")
print(f"  Max entanglement entropy = ln(χ) = ln({chi()}) = {math.log(chi()):.4f}")
print(f"  Page time = argmax ‖η(t)‖ — the Noether deviation peak.")
print(f"  Unitarity restored when ‖η‖ → 0. The crystal has no paradox.")
