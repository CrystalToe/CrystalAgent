// Heyting algebra + error correction — Steane [7,1,3]=[β₀,d₁,N_c]
use crate::atoms::*;

pub const QUBIT_STATES: u64 = N_W;                   // 2
pub const PAULI_MATRICES: u64 = N_C;                 // 3
pub const BELL_STATES: u64 = N_W * N_W;              // 4
pub const STEANE_N: u64 = BETA0;                      // 7
pub const STEANE_K: u64 = 1;                          // 1
pub const STEANE_D: u64 = N_C;                        // 3
pub const SHOR_N: u64 = N_C * N_C;                   // 9
pub const TOFFOLI: u64 = N_C;                         // 3
pub const MERA_BOND: u64 = CHI;                       // 6
pub const MERA_DEPTH: u64 = TOWER_D;                  // 42
pub const TELEPORT_BITS: u64 = N_W;                   // 2

pub fn bell_entropy() -> f64 { (N_W as f64).ln() }
pub fn mera_link_entropy() -> f64 { (CHI as f64).ln() }

pub fn steane_corrects() -> u64 { (N_C - 1) / 2 } // 1
pub fn hamming_check() -> bool { BETA0 == N_W * N_W * N_W - 1 } // 7 = 2³-1
