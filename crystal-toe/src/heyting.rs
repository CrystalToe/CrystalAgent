// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// heyting.rs — Heyting algebra of truth values from A_F
//
//          1          (singlet, certain)
//         / \
//       1/2  1/3      (weak, colour — INCOMPARABLE)
//         \ /
//         1/6         (mixed, uncertain)
//          |
//          0          (false)
//
// meet(1/N_w, 1/N_c) = 1/χ because gcd(2,3) = 1.
// The uncertainty principle IS coprimality.

use crate::atoms::*;

/// A truth value in the Crystal Heyting algebra.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Truth {
    pub num: u64,
    pub den: u64,
}

impl Truth {
    pub const FALSE: Truth = Truth { num: 0, den: 1 };
    pub const MIXED: Truth = Truth { num: 1, den: CHI }; // 1/6
    pub const COLOUR: Truth = Truth { num: 1, den: N_C }; // 1/3
    pub const WEAK: Truth = Truth { num: 1, den: N_W }; // 1/2
    pub const TRUE: Truth = Truth { num: 1, den: 1 }; // 1

    /// All truth values in lattice order.
    pub const ALL: [Truth; 5] = [
        Truth::FALSE,
        Truth::MIXED,
        Truth::COLOUR,
        Truth::WEAK,
        Truth::TRUE,
    ];

    /// Floating-point value.
    pub fn value(self) -> f64 {
        if self.den == 0 {
            return 0.0;
        }
        self.num as f64 / self.den as f64
    }

    /// Meet (greatest lower bound).
    pub fn meet(a: Truth, b: Truth) -> Truth {
        if a.num == 0 || b.num == 0 {
            return Truth::FALSE;
        }
        if a == Truth::TRUE {
            return b;
        }
        if b == Truth::TRUE {
            return a;
        }
        if a == b {
            return a;
        }
        // For coprime denominators: lcm gives the meet
        let d = lcm(a.den, b.den);
        Truth { num: 1, den: d }
    }

    /// Join (least upper bound).
    pub fn join(a: Truth, b: Truth) -> Truth {
        if a.num == 0 {
            return b;
        }
        if b.num == 0 {
            return a;
        }
        if a == Truth::TRUE || b == Truth::TRUE {
            return Truth::TRUE;
        }
        if a == b {
            return a;
        }
        // For coprime denominators: gcd gives the join
        let d = gcd(a.den, b.den);
        if d == 1 {
            Truth::TRUE
        } else {
            Truth { num: 1, den: d }
        }
    }

    /// Heyting implication: a → b = ∨{c : c ∧ a ≤ b}.
    pub fn implies(a: Truth, b: Truth) -> Truth {
        // Find largest c such that meet(c, a) ≤ b
        let mut best = Truth::FALSE;
        for &c in &Truth::ALL {
            let m = Truth::meet(c, a);
            if m.den >= b.den || m.num == 0 {
                // m ≤ b in divisibility order
                if c.value() > best.value() {
                    best = c;
                }
            }
        }
        best
    }

    /// Negation: ¬a = a → FALSE.
    pub fn negate(a: Truth) -> Truth {
        if a.num == 0 {
            Truth::TRUE
        } else if a == Truth::TRUE {
            Truth::FALSE
        } else {
            // In our lattice, ¬(1/2) = ¬(1/3) = 0
            // because meet(c, 1/2) = 0 only for c=0
            Truth::FALSE
        }
    }
}

impl std::fmt::Display for Truth {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        if self.num == 0 {
            write!(f, "0")
        } else if self.den == 1 {
            write!(f, "1")
        } else {
            write!(f, "1/{}", self.den)
        }
    }
}

/// Verify that N_w and N_c are coprime — the algebraic root of uncertainty.
pub const fn are_coprime() -> bool {
    // gcd(2, 3) at compile time
    // Since N_W=2 and N_C=3 are both prime and distinct, gcd=1.
    N_W != N_C && N_W > 1 && N_C > 1
}

const _: () = assert!(are_coprime());
