-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

/- CrystalGW.lean — GW integer identities from (N_w, N_c) = (2, 3). -/

def N_w : Nat := 2
def N_c : Nat := 3
def chi : Nat := N_w * N_c

-- Quadrupole formula
theorem quadrupole_num : N_w ^ 5 = 32 := by native_decide
theorem quadrupole_den : chi - 1 = 5 := by native_decide

-- Orbital decay
theorem decay_num : N_w ^ 6 = 64 := by native_decide
theorem decay_den : chi - 1 = 5 := by native_decide

-- Chirp rate
theorem chirp_coeff_num : N_c * N_w ^ 5 = 96 := by native_decide

-- Merger time coefficient
theorem merger_num : chi - 1 = 5 := by native_decide
theorem merger_den : N_w ^ 8 = 256 := by native_decide

-- Chirp mass exponents: 3/5, 2/5, 1/5
theorem chirp_mass_3 : N_c = 3 := by native_decide   -- numerator of 3/5
theorem chirp_mass_5 : chi - 1 = 5 := by native_decide  -- denominator

-- Frequency exponent 2/3
theorem freq_exp_num : N_c - 1 = 2 := by native_decide
theorem freq_exp_den : N_c = 3 := by native_decide

-- Waveform amplitude
theorem amplitude_4 : N_w ^ 2 = 4 := by native_decide

-- Polarizations
theorem polarizations_2 : N_c - 1 = 2 := by native_decide

-- GW frequency doubling
theorem gw_doubling : N_w = 2 := by native_decide

-- ISCO cutoff
theorem isco_6 : chi = 6 := by native_decide

-- Kolmogorov in GW chirp
theorem kolmogorov_num : chi - 1 = 5 := by native_decide
theorem kolmogorov_den : N_c = 3 := by native_decide

-- Chirp 8/3 exponent
theorem chirp_83_num : N_c ^ 2 - 1 = 8 := by native_decide  -- d_colour
theorem chirp_83_den : N_c = 3 := by native_decide

-- Chirp 11/3 exponent
theorem chirp_113_num : N_c ^ 2 + N_w = 11 := by native_decide
