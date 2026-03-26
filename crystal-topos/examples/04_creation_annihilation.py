"""
04 — Creation and Annihilation Operators
â† raises a particle one sector level. â lowers it.
Factors: √(d_{k+1}/d_k) from sector dimensions {1, 3, 8, 24}.
"""
from crystal_topos import QuantumState

print("Creation/Annihilation Ladder")
print("=" * 60)

# Start at singlet (ground)
psi = QuantumState.singlet()
print(f"Start:    {psi.sector_probs()}")

# Create three times: singlet → weak → colour → mixed
psi1 = psi.create()
print(f"â†:       {psi1.sector_probs()}  (singlet → weak, factor √3)")

psi2 = psi1.create()
print(f"â†â†:     {psi2.sector_probs()}  (weak → colour, factor √(8/3))")

psi3 = psi2.create()
print(f"â†â†â†:   {psi3.sector_probs()}  (colour → mixed, factor √3)")

# Now annihilate back down
psi4 = psi3.annihilate()
print(f"â:        {psi4.sector_probs()}  (mixed → colour)")

psi5 = psi4.annihilate()
print(f"ââ:       {psi5.sector_probs()}  (colour → weak)")

psi6 = psi5.annihilate()
print(f"âââ:      {psi6.sector_probs()}  (weak → singlet)")

print()
print("The creation factors √(d_{k+1}/d_k) come from the sector")
print("dimensions {1, 3, 8, 24}. These ARE the particle content of A_F.")
