#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
# test_crystal_toe.py — Full test of Python bindings
#
# Run:
#   cd crystal-toe
#   pip install maturin
#   maturin develop --features python
#   python test_crystal_toe.py

from crystal_toe import (
    Toe, Nuclear, Bio, QFT, Astro, QInfo, Chem, AlgebraState,
    N_W, N_C, CHI, BETA0, SIGMA_D, TOWER_D, D_COLOUR, VEV_CRYSTAL,
    py_conversion_factor, py_hologron_potential,
)

passed = 0
failed = 0

def check(name, result):
    global passed, failed
    if result:
        passed += 1
        print(f"  PASS  {name}")
    else:
        failed += 1
        print(f"  FAIL  {name}")

print("=" * 64)
print(" Crystal Toe — Python Binding Tests")
print("=" * 64)
print()

# ── Atoms ──
print("Atoms:")
check("N_W = 2", N_W == 2)
check("N_C = 3", N_C == 3)
check("CHI = 6", CHI == 6)
check("BETA0 = 7", BETA0 == 7)
check("SIGMA_D = 36", SIGMA_D == 36)
check("TOWER_D = 42", TOWER_D == 42)
check("D_COLOUR = 8", D_COLOUR == 8)
print()

# ── Toe ──
print("Toe (Crystal default):")
toe = Toe()
check("default VEV ~ 245.17", abs(toe.vev() - 245.17) < 0.01)
check("is_crystal_default", toe.is_crystal_default())
check("alpha_inv ~ 137.034", abs(toe.alpha_inv() - 137.034) < 0.01)
check("sin2_theta_w ~ 0.231", abs(toe.sin2_theta_w() - 0.231) < 0.001)
check("repr", "crystal" in repr(toe))
print()

print("Toe (PDG via to_pdg):")
pdg = toe.to_pdg()
check("PDG VEV ~ 246.22", abs(pdg.vev() - 246.22) < 0.1)
check("not crystal default", not pdg.is_crystal_default())
check("alpha_inv same", toe.alpha_inv() == pdg.alpha_inv())
check("masses differ", toe.proton_mass() != pdg.proton_mass())
check("ratio = conversion_factor", abs(pdg.proton_mass()/toe.proton_mass() - py_conversion_factor()) < 1e-10)
print()

print("Toe (custom VEV):")
custom = Toe(250.0)
check("custom VEV = 250", abs(custom.vev() - 250.0) < 1e-10)
print()

# ── Nuclear ──
print("Nuclear:")
nuc = Nuclear()
check("magic numbers", nuc.magic_numbers() == [2, 8, 20, 28, 50, 82, 126])
check("iron peak = 56", nuc.iron_peak() == 56)
check("Fe-56 is peak", nuc.binding_per_nucleon(56, 26) > nuc.binding_per_nucleon(55, 26))
print()

# ── Bio ──
print("Bio:")
bio = Bio()
check("DNA bases = 4", bio.dna_bases() == 4)
check("amino acids = 20", bio.amino_acids() == 20)
check("codons = 64", bio.codons() == 64)
check("Kleiber = 0.75", abs(bio.kleiber_exponent() - 0.75) < 1e-10)
check("helix = 3.6", abs(bio.helix_per_turn() - 3.6) < 1e-10)
check("redundancy ~ 3", abs(bio.codon_redundancy() - 3.05) < 0.01)
print()

# ── QFT ──
print("QFT:")
qft = QFT()
check("spacetime = 4", qft.spacetime_dim() == 4)
check("gluons = 8", qft.gluon_colours() == 8)
check("beta0 = 7", qft.qcd_beta0() == 7)
check("Thomson ~ 0.665 barn", abs(qft.thomson_cs() - 0.665) < 0.01)
check("sigma(ee->mumu, 10GeV) ~ 0.87 nb", abs(qft.sigma_ee_mumu(10.0) - 0.87) < 0.02)
print()

# ── Astro ──
print("Astro:")
astro = Astro()
xi1, _ = astro.lane_emden(1.5)  # n = N_c/N_w
check("Lane-Emden n=3/2: xi1 ~ 3.654", abs(xi1 - 3.654) < 0.01)
xi3, _ = astro.lane_emden(3.0)  # n = N_c
check("Lane-Emden n=3: xi1 ~ 6.897", abs(xi3 - 6.897) < 0.01)
check("Hawking = 8", astro.hawking_factor() == 8)
check("SB denom = 15", astro.sb_denominator() == 15)
print()

# ── QInfo ──
print("QInfo:")
qi = QInfo()
n, k, d = qi.steane_code()
check("Steane [7,1,3]", (n, k, d) == (7, 1, 3))
check("Bell states = 4", qi.bell_states() == 4)
check("MERA depth = 42", qi.mera_depth() == 42)
print()

# ── Chem ──
print("Chem:")
ch = Chem()
check("f-shell = 14 = N_w*beta0", ch.f_capacity() == 14)
check("Kr Z = 36 = Sigma_d", ch.noble_kr() == 36)
check("pH = 7 = beta0", ch.neutral_ph() == 7)
check("sp3 ~ 109.47", abs(ch.sp3_angle_deg() - 109.47) < 0.01)
print()

# ── Monad ──
print("Monad:")
state = AlgebraState()
check("tick 0: singlet = 1", abs(state.singlet - 1.0) < 1e-15)
state.tick()
check("tick 1: weak = 0.5", abs(state.weak - 0.5) < 1e-15)
check("tick 1: mixed = 1/6", abs(state.mixed - 1/6) < 1e-15)

state42 = AlgebraState.at_tick(42)
check("tick 42: singlet = 1", abs(state42.singlet - 1.0) < 1e-15)
check("tick 42: mixed ~ 0", state42.mixed < 1e-30)
print()

# ── Hologron ──
print("Hologron:")
check("V(2) < 0 (attractive)", py_hologron_potential(2.0) < 0)
check("|V(1)| > |V(2)| (falls off)", abs(py_hologron_potential(1.0)) > abs(py_hologron_potential(2.0)))
print()

# ── Summary ──
print("=" * 64)
total = passed + failed
print(f"  {passed}/{total} passed, {failed} failed")
if failed == 0:
    print("  ALL PASS — every number from N_w=2, N_c=3")
else:
    print("  SOME FAILURES")
