// Genetic code, Kleiber — amino acids 20=N_w²(χ−1), codons 64=(N_w²)^N_c
use crate::atoms::*;

pub const DNA_BASES: u64 = N_W * N_W;                // 4
pub const CODON_LEN: u64 = N_C;                      // 3
pub const TOTAL_CODONS: u64 = 64;                     // (N_w²)^N_c
pub const AMINO_ACIDS: u64 = N_W * N_W * (CHI - 1);  // 20
pub const STOP_CODONS: u64 = N_C;                     // 3
pub const HBOND_AT: u64 = N_W;                        // 2
pub const HBOND_GC: u64 = N_C;                        // 3
pub const HELIX_STRANDS: u64 = N_W;                   // 2
pub const BP_PER_TURN: u64 = N_W * (CHI - 1);        // 10
pub const LIPID_LAYERS: u64 = N_W;                    // 2

pub fn kleiber_exp() -> f64 { N_C as f64 / (N_W * N_W) as f64 } // 3/4
pub fn surface_exp() -> f64 { N_W as f64 / N_C as f64 }          // 2/3
pub fn heart_rate_exp() -> f64 { 1.0 / (N_W * N_W) as f64 }     // 1/4
pub fn helix_per_turn() -> f64 { (N_C*N_C*N_W) as f64 / (CHI-1) as f64 } // 3.6
pub fn flory_nu() -> f64 { N_W as f64 / (CHI - 1) as f64 }      // 2/5
pub fn codon_redundancy() -> f64 { (TOTAL_CODONS - STOP_CODONS) as f64 / AMINO_ACIDS as f64 }
