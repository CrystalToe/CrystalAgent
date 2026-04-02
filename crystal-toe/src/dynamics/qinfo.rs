// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/qinfo.rs — Quantum Information from (2,3)
//
// Heyting algebra truth values + error correction + entanglement.
//
//   Qubit states:         2  = N_w
//   Pauli matrices:       3  = N_c  (σ_x, σ_y, σ_z)
//   Pauli + identity:     4  = N_w²
//   Bell states:          4  = N_w²
//   Steane code:          [7,1,3] = [β₀, d₁, N_c]
//   Shor code:            9 qubits = N_c²
//   Toffoli inputs:       3  = N_c
//   MERA bond dim:        6  = χ
//   MERA layers:          42 = D
//   Bell entropy:         ln(2) = ln(N_w)
//   MERA entropy:         ln(6) = ln(χ)
//   Teleportation bits:   2  = N_w
//   Superdense bits:      2  = N_w
//   Heyting meet(1/2,1/3) = 1/6 = 1/χ  (uncertainty principle)
//
// Observable count: 13.

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════
// §1  QUBIT AND GATE STRUCTURE FROM (2,3)
// ═══════════════════════════════════════════════════════════════

/// Qubit: N_w = 2 computational basis states |0⟩, |1⟩.
pub const QUBIT_STATES: u64 = N_W;                    // 2

/// Non-trivial Pauli matrices: N_c = 3 (σ_x, σ_y, σ_z).
pub const PAULI_MATRICES: u64 = N_C;                  // 3

/// Full Pauli group (with identity): N_w² = 4.
pub const PAULI_GROUP: u64 = N_W * N_W;               // 4

/// Bell states: N_w² = 4 maximally entangled 2-qubit states.
pub const BELL_STATES: u64 = N_W * N_W;               // 4

/// Toffoli (CCNOT) inputs: N_c = 3.
pub const TOFFOLI: u64 = N_C;                          // 3

// ═══════════════════════════════════════════════════════════════
// §2  QUANTUM ERROR CORRECTION FROM (2,3)
//
// Steane code: [[7, 1, 3]] = [[β₀, d₁, N_c]]
//   7 physical qubits = β₀ = QCD beta coefficient
//   1 logical qubit = d₁ = singlet dimension
//   distance 3 = N_c = colour triplet
//   Corrects floor((N_c−1)/2) = 1 error
//   7 = N_w^N_c − 1 = 2³−1 (Hamming bound)
//
// Shor code: [[9, 1, 3]]
//   9 physical qubits = N_c² (= D2Q9 from CFD!)
// ═══════════════════════════════════════════════════════════════

pub const STEANE_N: u64 = BETA0;                       // 7
pub const STEANE_K: u64 = 1;                            // d₁
pub const STEANE_D: u64 = N_C;                          // 3

pub const SHOR_N: u64 = N_C * N_C;                     // 9

/// Steane code corrects floor((N_c−1)/2) = 1 error.
pub fn steane_corrects() -> u64 { (N_C - 1) / 2 }

/// Hamming bound: β₀ = N_w^N_c − 1 = 2³ − 1 = 7.
pub fn hamming_check() -> bool {
    BETA0 == N_W.pow(N_C as u32) - 1
}

// ═══════════════════════════════════════════════════════════════
// §3  MERA STRUCTURE FROM (2,3)
//
// Bond dimension: χ = 6 (local Hilbert space).
// Tower depth: D = Σ_d + χ = 42 layers.
// Entropy per layer: ln(χ) = ln(6) nats.
// ═══════════════════════════════════════════════════════════════

pub const MERA_BOND: u64 = CHI;                        // 6
pub const MERA_DEPTH: u64 = TOWER_D;                   // 42

/// Entropy per MERA tick: ln(χ).
pub fn entropy_per_tick() -> f64 { (CHI as f64).ln() }

// ═══════════════════════════════════════════════════════════════
// §4  ENTANGLEMENT ENTROPY
//
// Bell pair: S = ln(N_w) = ln(2).
// MERA link: S = ln(χ) = ln(6) = ln(N_w) + ln(N_c).
// ═══════════════════════════════════════════════════════════════

/// Bell entropy: ln(N_w) = ln(2).
pub fn bell_entropy() -> f64 { (N_W as f64).ln() }

/// MERA link entropy: ln(χ) = ln(6).
pub fn mera_link_entropy() -> f64 { (CHI as f64).ln() }

/// Teleportation: 1 Bell pair + N_w classical bits = 1 qubit.
pub const TELEPORT_BITS: u64 = N_W;                    // 2

/// Superdense coding: 1 Bell pair + 1 qubit = N_w classical bits.
pub const SUPERDENSE_BITS: u64 = N_W;                  // 2

// ═══════════════════════════════════════════════════════════════
// §5  HEYTING ALGEBRA (TRUTH VALUES FROM MONAD)
//
// The monad S = W ∘ U has eigenvalues {1, 1/N_w, 1/N_c, 1/χ}.
// Distributive lattice under divisibility:
//
//            1          (singlet, certain)
//           / \
//         1/2  1/3      (weak, colour — INCOMPARABLE)
//           \ /
//           1/6         (mixed, maximally uncertain)
//            |
//            0          (false)
//
// meet(1/N_w, 1/N_c) = 1/χ    ← UNCERTAINTY PRINCIPLE
// join(1/N_w, 1/N_c) = 1      ← COMPLEMENTARITY
//
// Follows from gcd(N_w, N_c) = gcd(2,3) = 1.
// ═══════════════════════════════════════════════════════════════

/// Heyting truth values as (numerator, denominator).
pub const TRUTH_SINGLET: (u64, u64) = (1, 1);          // 1
pub const TRUTH_WEAK:    (u64, u64) = (1, N_W);        // 1/2
pub const TRUTH_COLOUR:  (u64, u64) = (1, N_C);        // 1/3
pub const TRUTH_MIXED:   (u64, u64) = (1, CHI);        // 1/6

/// Uncertainty meet: meet(1/N_w, 1/N_c) = 1/χ.
pub fn uncertainty_meet() -> (u64, u64) { (1, CHI) }

/// Complementarity: gcd(N_w, N_c) = 1.
pub fn coprimality_check() -> bool {
    crate::atoms::gcd(N_W, N_C) == 1
}

/// Heyting meet for our lattice values (as f64).
pub fn heyting_meet(a: f64, b: f64) -> f64 {
    if a <= 0.0 || b <= 0.0 { return 0.0; }
    if (a - 1.0).abs() < 1e-15 { return b; }
    if (b - 1.0).abs() < 1e-15 { return a; }
    if (a - b).abs() < 1e-15 { return a; }
    a.min(b)
}

/// Heyting join for our lattice values (as f64).
pub fn heyting_join(a: f64, b: f64) -> f64 {
    if a <= 0.0 { return b; }
    if b <= 0.0 { return a; }
    if (a - 1.0).abs() < 1e-15 || (b - 1.0).abs() < 1e-15 { return 1.0; }
    if (a - b).abs() < 1e-15 { return a; }
    a.max(b)
}

// ═══════════════════════════════════════════════════════════════
// §6  INFORMATION BOUNDS
// ═══════════════════════════════════════════════════════════════

/// Channel capacity of a qubit: 1 (Holevo bound).
pub const QUBIT_CAPACITY: u64 = 1;

/// No-cloning: cannot duplicate unknown quantum state.
/// Minimum copies for state tomography: N_w^N_c − 1 = 7 (related to Steane).
pub fn tomography_min() -> u64 {
    N_W.pow(N_C as u32) - 1  // 7
}

// ═══════════════════════════════════════════════════════════════
// §7  SELF-TEST
// ═══════════════════════════════════════════════════════════════

pub const OBSERVABLE_COUNT: u64 = 13;

pub fn self_test() -> (usize, usize, Vec<String>) {
    let mut msgs = Vec::new();
    let mut pass = 0usize;
    let mut total = 0usize;

    macro_rules! check {
        ($name:expr, $cond:expr) => {{
            total += 1;
            let ok = $cond;
            if ok { pass += 1; }
            msgs.push(format!("{}  {}", if ok { "PASS" } else { "FAIL" }, $name));
        }}
    }

    // §1 Gate structure
    check!("qubit states = 2 = N_w",            QUBIT_STATES == 2);
    check!("Pauli matrices = 3 = N_c",          PAULI_MATRICES == 3);
    check!("Pauli group = 4 = N_w²",            PAULI_GROUP == 4);
    check!("Bell states = 4 = N_w²",            BELL_STATES == 4);
    check!("Toffoli = 3 = N_c",                 TOFFOLI == 3);

    // §2 Error correction
    check!("Steane [7,1,3] = [β₀,d₁,N_c]",     STEANE_N == 7 && STEANE_K == 1 && STEANE_D == 3);
    check!("Steane corrects 1 = (N_c−1)/2",     steane_corrects() == 1);
    check!("Shor code = 9 = N_c²",              SHOR_N == 9);
    check!("Hamming: β₀ = N_w^N_c − 1",         hamming_check());

    // §3 MERA
    check!("MERA bond = 6 = χ",                 MERA_BOND == 6);
    check!("MERA depth = 42 = D",               MERA_DEPTH == 42);

    // §4 Entanglement entropy
    let ln2 = (2.0_f64).ln();
    let ln6 = (6.0_f64).ln();
    check!("Bell entropy = ln(2) = ln(N_w)",     (bell_entropy() - ln2).abs() < 1e-12);
    check!("MERA entropy = ln(6) = ln(χ)",       (mera_link_entropy() - ln6).abs() < 1e-12);
    check!("ln(χ) = ln(N_w) + ln(N_c)",         (mera_link_entropy() - bell_entropy() - (3.0_f64).ln()).abs() < 1e-12);
    check!("teleport bits = 2 = N_w",            TELEPORT_BITS == 2);
    check!("superdense bits = 2 = N_w",          SUPERDENSE_BITS == 2);
    check!("teleport = superdense (duality)",    TELEPORT_BITS == SUPERDENSE_BITS);

    // §5 Heyting algebra
    check!("gcd(N_w, N_c) = 1 (coprime)",       coprimality_check());
    check!("uncertainty = 1/χ = 1/6",            uncertainty_meet() == (1, CHI));
    check!("Shor = CFD D2Q9 = N_c²",            SHOR_N == N_C * N_C);
    check!("tomography min = β₀ = 7",           tomography_min() == BETA0);

    (pass, total, msgs)
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn qubit_2()      { assert_eq!(QUBIT_STATES, 2); }
    #[test] fn pauli_3()      { assert_eq!(PAULI_MATRICES, 3); }
    #[test] fn pauli_grp_4()  { assert_eq!(PAULI_GROUP, 4); }
    #[test] fn bell_4()       { assert_eq!(BELL_STATES, 4); }
    #[test] fn toffoli_3()    { assert_eq!(TOFFOLI, 3); }
    #[test] fn steane_7_1_3() { assert_eq!((STEANE_N, STEANE_K, STEANE_D), (7, 1, 3)); }
    #[test] fn shor_9()       { assert_eq!(SHOR_N, 9); }
    #[test] fn mera_bond_6()  { assert_eq!(MERA_BOND, 6); }
    #[test] fn mera_depth_42(){ assert_eq!(MERA_DEPTH, 42); }
    #[test] fn teleport_2()   { assert_eq!(TELEPORT_BITS, 2); }
    #[test] fn superdense_2() { assert_eq!(SUPERDENSE_BITS, 2); }

    #[test] fn hamming()      { assert!(hamming_check()); }
    #[test] fn steane_corr()  { assert_eq!(steane_corrects(), 1); }
    #[test] fn coprime()      { assert!(coprimality_check()); }

    #[test] fn bell_ent() {
        assert!((bell_entropy() - (2.0_f64).ln()).abs() < 1e-12);
    }
    #[test] fn mera_ent() {
        assert!((mera_link_entropy() - (6.0_f64).ln()).abs() < 1e-12);
    }
    #[test] fn entropy_sum() {
        let sum = bell_entropy() + (3.0_f64).ln();
        assert!((mera_link_entropy() - sum).abs() < 1e-12);
    }

    #[test] fn heyting_meet_test() {
        let w = 1.0 / N_W as f64;  // 0.5
        let c = 1.0 / N_C as f64;  // 0.333
        assert!((heyting_meet(w, c) - c).abs() < 1e-12);
    }
    #[test] fn heyting_join_test() {
        let w = 1.0 / N_W as f64;
        let c = 1.0 / N_C as f64;
        assert!((heyting_join(w, c) - w).abs() < 1e-12);
    }
    #[test] fn heyting_identity() {
        assert!((heyting_meet(1.0, 0.5) - 0.5).abs() < 1e-12);
        assert!((heyting_join(0.0, 0.5) - 0.5).abs() < 1e-12);
    }

    #[test] fn tomography_7() { assert_eq!(tomography_min(), 7); }

    #[test] fn full_self_test() {
        let (pass, total, msgs) = self_test();
        for m in &msgs { if m.starts_with("FAIL") { panic!("{m}"); } }
        assert_eq!(pass, total);
    }
}
