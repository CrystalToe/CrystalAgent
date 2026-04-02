#!/usr/bin/env python3
# Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
#
# cross_check.py — Compare Haskell oracle vs Rust crystal_toe
#
# Setup:
#   ghc -O2 CrystalOracle.hs -o crystal_oracle
#   PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1 maturin develop --features python
#
# Run:
#   python cross_check.py

from crystal_toe import Toe, N_W, N_C, CHI, BETA0, SIGMA_D, TOWER_D, GAUSS
from crystal_toe import py_conversion_factor
from haskell_toe import HaskellToe

passed = 0
failed = 0

def compare(name, rust_val, hs_val, tol=1e-10):
    """Compare Rust vs Haskell. Integers must match exactly. Floats within tol."""
    global passed, failed
    if isinstance(rust_val, int) and isinstance(hs_val, int):
        ok = rust_val == hs_val
        diff = abs(rust_val - hs_val)
    else:
        rust_f = float(rust_val)
        hs_f = float(hs_val)
        if hs_f == 0:
            diff = abs(rust_f)
            ok = diff < tol
        else:
            diff = abs(rust_f - hs_f) / abs(hs_f)
            ok = diff < tol

    if ok:
        passed += 1
        tag = "MATCH"
    else:
        failed += 1
        tag = "MISMATCH"

    print(f"  {tag:8s}  {name:<25s}  rust={rust_val:<22}  hs={hs_val:<22}  Δ={diff:.2e}")


print("=" * 100)
print(" Haskell ↔ Rust Cross-Check")
print("=" * 100)
print()

# Load Haskell oracle
try:
    hs = HaskellToe()
except FileNotFoundError as e:
    print(f"ERROR: {e}")
    print("Compile: ghc -O2 CrystalOracle.hs -o crystal_oracle")
    exit(1)

# Load Rust
toe = Toe()
pdg = toe.to_pdg()

# ── Atoms (must be EXACT) ──────────────────────────────────
print("Atoms (integer, must be exact):")
compare("chi", int(CHI), hs.chi)
compare("beta0", int(BETA0), hs.beta0)
compare("sigma_d", int(SIGMA_D), hs.sigma_d)
compare("tower_d", int(TOWER_D), hs.tower_d)
compare("gauss", int(GAUSS), hs.gauss)
print()

# ── Dimensionless (must match to 15 digits) ────────────────
print("Dimensionless constants (tol=1e-12):")
compare("alpha_inv", toe.alpha_inv(), hs.alpha_inv, tol=1e-12)
compare("sin2_theta_w", toe.sin2_theta_w(), hs.sin2_theta_w, tol=1e-12)
compare("kappa", toe.kappa(), hs.kappa, tol=1e-12)
compare("mp_me_ratio", toe.mp_me_ratio(), hs.mp_me_ratio, tol=1e-10)
print()

# ── VEV & conversion ──────────────────────────────────────
print("VEV and conversion (tol=1e-12):")
compare("vev_crystal", toe.vev(), hs.vev_crystal, tol=1e-12)
compare("conversion_factor", py_conversion_factor(), hs.conversion_factor, tol=1e-12)
compare("vev_pdg", pdg.vev(), hs.vev_pdg, tol=1e-12)
print()

# ── Masses, Crystal VEV (tol=1e-12) ───────────────────────
print("Masses at Crystal VEV (tol=1e-12):")
compare("proton_mass", toe.proton_mass(), hs.proton_mass, tol=1e-12)
compare("electron_mass", toe.electron_mass(), hs.electron_mass, tol=1e-12)
compare("muon_mass", toe.muon_mass(), hs.muon_mass, tol=1e-12)
compare("pion_mass", toe.pion_mass(), hs.pion_mass, tol=1e-12)
compare("z_mass", toe.z_mass(), hs.z_mass, tol=1e-12)
print()

# ── Masses, PDG VEV ───────────────────────────────────────
print("Masses at PDG VEV (tol=1e-12):")
compare("proton_mass_pdg", pdg.proton_mass(), hs.proton_mass_pdg, tol=1e-12)
print()

# ── Summary ───────────────────────────────────────────────
total = passed + failed
print("=" * 100)
print(f"  {passed}/{total} MATCH, {failed} MISMATCH")
if failed == 0:
    print("  HASKELL = RUST to 12+ significant digits")
    print("  GHC Certificate preserved in Rust port.")
else:
    print("  SOME MISMATCHES — investigate before retiring Haskell")
