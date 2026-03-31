<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalExtendedScan — WACAScan Test Runner

**WACAScanTest.hs — test runner for the 103 extended observables in CrystalWACAScan.hs**

This is the test driver that exercises CrystalWACAScan.hs. It imports the wacaScanResults list and runs the audit. For the actual physics and formulas, see README_CrystalWACAScan.md.

## What It Tests

- All 103 observables from CrystalWACAScan.hs
- PWI for each observable
- Rating distribution (EXACT/TIGHT/GOOD/LOOSE/OVER)
- CV (coefficient of variation)
- Wall breaches (must be zero)

## Compile & Run

```bash
cd haskel
ghc -O2 WACAScanTest.hs -o extended_scan && ./extended_scan
```

## Dependencies

Imports `CrystalWACAScan`.
