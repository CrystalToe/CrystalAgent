-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
--
-- CrystalNobleGas.lean
-- Proves: blessed-prime gate holds for noble gas electron counts
-- Supports: "Same Song, Second Verse" paper (forthcoming)

-- ============================================================
-- § 0: RECTANGLE CONSTANTS
-- ============================================================

def N_w : Nat := 2
def N_c : Nat := 3

-- Heegner set H
def inH : Nat → Bool
  | 1 | 2 | 3 | 7 | 11 | 19 | 43 | 67 | 163 => true
  | _ => false

-- Blessed prime: p ∈ H or (4p - 1) ∈ H
def isBlessed (p : Nat) : Bool :=
  inH p || inH (4 * p - 1)

-- Foreign prime: prime and not blessed
def isForeign (p : Nat) : Bool :=
  !isBlessed p

-- ============================================================
-- § 1: NOBLE GAS FACTORIZATIONS
-- ============================================================

-- He: Z = 2
theorem he_factor : 2 = 2 := by native_decide
theorem he_blessed : isBlessed 2 = true := by native_decide

-- Ne: Z = 10 = 2 · 5
theorem ne_factor : 10 = 2 * 5 := by native_decide
theorem ne_b2 : isBlessed 2 = true := by native_decide
theorem ne_b5 : isBlessed 5 = true := by native_decide  -- 4·5-1=19 ∈ H

-- Ar: Z = 18 = 2 · 3²
theorem ar_factor : 18 = 2 * 3 * 3 := by native_decide
theorem ar_b3 : isBlessed 3 = true := by native_decide

-- Kr: Z = 36 = 2² · 3²
theorem kr_factor : 36 = 2 * 2 * 3 * 3 := by native_decide

-- Xe: Z = 54 = 2 · 3³
theorem xe_factor : 54 = 2 * 3 * 3 * 3 := by native_decide

-- Rn: Z = 86 = 2 · 43
theorem rn_factor : 86 = 2 * 43 := by native_decide
theorem rn_b43 : isBlessed 43 = true := by native_decide

-- ============================================================
-- § 2: OGANESSON (Z = 118) IS FORBIDDEN
-- ============================================================

-- 118 = 2 · 59, and 59 is foreign
theorem og_factor : 118 = 2 * 59 := by native_decide
theorem og_foreign_59 : isForeign 59 = true := by native_decide
-- 59 ∉ H, 4·59-1 = 235 ∉ H

-- ============================================================
-- § 3: RADON STAMPED BY HEEGNER PRIME 43
-- ============================================================

theorem h43_in_H : inH 43 = true := by native_decide

-- ============================================================
-- § 4: ELECTRON SHELL CAPACITY = N_w · n²
-- ============================================================

def electronShellCap (n : Nat) : Nat := N_w * n * n

theorem eshell_1 : electronShellCap 1 = 2  := by native_decide
theorem eshell_2 : electronShellCap 2 = 8  := by native_decide
theorem eshell_3 : electronShellCap 3 = 18 := by native_decide
theorem eshell_4 : electronShellCap 4 = 32 := by native_decide
theorem eshell_5 : electronShellCap 5 = 50 := by native_decide

-- ============================================================
-- § 5: NOBLE GAS Z = CUMULATIVE SHELL FILLING
-- Capacities: 2, 8, 8, 18, 18, 32 (each 2n² twice for n ≥ 2)
-- ============================================================

theorem noble_z_He : 2  = 2 := by native_decide
theorem noble_z_Ne : 10 = 2 + 8 := by native_decide
theorem noble_z_Ar : 18 = 2 + 8 + 8 := by native_decide
theorem noble_z_Kr : 36 = 2 + 8 + 8 + 18 := by native_decide
theorem noble_z_Xe : 54 = 2 + 8 + 8 + 18 + 18 := by native_decide
theorem noble_z_Rn : 86 = 2 + 8 + 8 + 18 + 18 + 32 := by native_decide

-- ============================================================
-- § 6: THE BILINEAR PARENT — n² vs n(n+1)
-- ============================================================

def pronic (n : Nat) : Nat := n * (n + 1)
def square (n : Nat) : Nat := n * n

-- Gap: pronic(n) - square(n) = n
theorem gap_1 : pronic 1 - square 1 = 1 := by native_decide
theorem gap_2 : pronic 2 - square 2 = 2 := by native_decide
theorem gap_3 : pronic 3 - square 3 = 3 := by native_decide
theorem gap_4 : pronic 4 - square 4 = 4 := by native_decide
theorem gap_5 : pronic 5 - square 5 = 5 := by native_decide
theorem gap_6 : pronic 6 - square 6 = 6 := by native_decide
theorem gap_7 : pronic 7 - square 7 = 7 := by native_decide

-- Nuclear L1 values (pronic)
theorem nuc_L1_4 : pronic 4 = 20 := by native_decide
theorem nuc_L1_5 : pronic 5 = 30 := by native_decide
theorem nuc_L1_6 : pronic 6 = 42 := by native_decide
theorem nuc_L1_7 : pronic 7 = 56 := by native_decide

-- ============================================================
-- § 7: SHELL CAPACITY DIFFERENCES = N_w · (2n + 1)
-- 2(n+1)² - 2n² = 2(2n+1)
-- ============================================================

theorem cap_diff_1 : electronShellCap 2 - electronShellCap 1 = 2 * 3  := by native_decide
theorem cap_diff_2 : electronShellCap 3 - electronShellCap 2 = 2 * 5  := by native_decide
theorem cap_diff_3 : electronShellCap 4 - electronShellCap 3 = 2 * 7  := by native_decide
theorem cap_diff_4 : electronShellCap 5 - electronShellCap 4 = 2 * 9  := by native_decide
theorem cap_diff_5 : electronShellCap 6 - electronShellCap 5 = 2 * 11 := by native_decide

-- ============================================================
-- § 8: EXTRA — 5 is blessed via the 4p-1 criterion
-- This is the only noble gas factor that isn't directly in H
-- ============================================================

theorem blessed_5_via : 4 * 5 - 1 = 19 := by native_decide
theorem h19_in_H : inH 19 = true := by native_decide
