# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""59 — Biological Chirality: Why Life is Left-Handed"""
from crystal_topos import n_w, n_c, chi
print("Chirality from the Crystal")
print("=" * 55)
print(f"  Life uses L-amino acids and D-sugars. Not both. Why?")
print(f"\n  The (2,3) lattice is CHIRAL:")
print(f"    N_w = {n_w()} ≠ N_c = {n_c()}")
print(f"    The algebra A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ) is not symmetric.")
print(f"\n  Heyting negation is ASYMMETRIC:")
print(f"    ¬(1/N_w) = 1/χ = 1/{chi()}")
print(f"    ¬(1/N_c) = 1/χ = 1/{chi()}")
print(f"    BUT: ¬¬(1/N_w) = ¬(1/{chi()}) and the double negation")
print(f"    does NOT return to 1/N_w in general.")
print(f"    ¬¬x ≠ x in Heyting logic (unlike classical logic).")
print(f"\n  The algebra picks a handedness:")
print(f"    N_w < N_c → weak sector is 'smaller' than colour")
print(f"    This asymmetry propagates to molecular geometry.")
print(f"    L-amino acids and D-sugars inherit the (2,3) chirality.")
print(f"\n  If N_w = N_c (say, both = 3):")
print(f"    The algebra would be achiral. Life would use both hands.")
print(f"    But N_w ≠ N_c, so biology is homochiral.")
