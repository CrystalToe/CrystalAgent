# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

"""85 — The IO Monad IS the Arrow of Time"""
from crystal_topos import chi, crystal_max_entropy
import math
print("Why Haskell's IO Monad IS Physics")
print("=" * 55)
print(f"  HASKELL:")
print(f"    pure computation: a → b (reversible, no side effects)")
print(f"    IO computation:   IO a → IO b (irreversible, has effects)")
print(f"    You can't extract 'a' from 'IO a' without running it.")
print(f"    Running it = committing to time's arrow.")
print(f"\n  THE CRYSTAL:")
print(f"    unitary evolution: |ψ⟩ → U|ψ⟩ (reversible, no measurement)")
print(f"    measurement:       |ψ⟩ → |k⟩ (irreversible, collapses)")
print(f"    You can't un-measure. Just like you can't un-print.")
print(f"\n  THE CORRESPONDENCE:")
print(f"    {'Haskell':<25} {'Crystal':<25} {'Physics'}")
print(f"    {'─'*25} {'─'*25} {'─'*20}")
print(f"    {'pure function':<25} {'unitary operator':<25} {'reversible'}")
print(f"    {'IO action':<25} {'measurement':<25} {'irreversible'}")
print(f"    {'>>= (bind)':<25} {'compression step':<25} {'entropy +ln(χ)'}")
print(f"    {'return':<25} {'state preparation':<25} {'S = 0'}")
print(f"    {'unsafePerformIO':<25} {'¬¬x pretend = x':<25} {'time travel'}")
print(f"\n  unsafePerformIO is 'time travel' — it pretends")
print(f"  an irreversible operation was reversible.")
print(f"  The crystal says: ¬¬x ≠ x. That's why it's 'unsafe.'")
print(f"\n  ΔS = ln(χ) = {crystal_max_entropy():.4f} nats per >>= bind.")
print(f"  The Haskell runtime IS a thermodynamic engine.")
