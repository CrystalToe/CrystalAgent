"""
02 — The Sector Spectrum
Four sectors: Singlet, Weak, Colour, Mixed.
Energies: {0, ln2, ln3, ln6} — from the eigenvalues {1, 1/2, 1/3, 1/6}.
"""
from crystal_topos import QuantumState, crystal_energies, crystal_max_entropy

energies = crystal_energies()
names = ["Singlet", "Weak", "Colour", "Mixed"]

print("Crystal Sector Spectrum")
print("=" * 50)
for i, (name, e) in enumerate(zip(names, energies)):
    psi = [QuantumState.singlet, QuantumState.weak,
           QuantumState.colour, QuantumState.mixed][i]()
    print(f"  |{name}⟩  E = {e:.4f}  prob = {psi.sector_probs()}")

print()
print(f"Mass gap:    ΔE = E_weak − E_singlet = {energies[1]:.4f} = ln(2)")
print(f"Max energy:  E_mixed = {energies[3]:.4f} = ln(6)")
print(f"Max entropy: S_max = {crystal_max_entropy():.4f} = ln(6)")
print()
print("The mass gap is ln(N_w) = ln(2). The weak prime sets the scale.")
print("Max energy = max entropy = ln(χ). Entanglement = irreversibility.")
