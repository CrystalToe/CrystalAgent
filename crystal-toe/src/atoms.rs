// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// atoms.rs — A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ) atoms
//
// Every constant is `const` — evaluated at compile time.
// Nothing here allocates. Nothing here runs.

/// Weak doublet dimension (from M₂(ℂ)).
pub const N_W: u64 = 2;

/// Colour triplet dimension (from M₃(ℂ)).
pub const N_C: u64 = 3;

/// χ = N_w × N_c (total internal dimension).
pub const CHI: u64 = N_W * N_C; // 6

/// QCD one-loop beta coefficient: β₀ = (11N_c − 2χ)/3.
pub const BETA0: u64 = (11 * N_C - 2 * CHI) / 3; // 7

/// Sector dimensions: d₁=1, d₂=3, d₃=8, d₄=24.
pub const D1: u64 = 1;
pub const D2: u64 = N_C; // 3
pub const D3: u64 = N_C * N_C - 1; // 8
pub const D4: u64 = (N_C * N_C - 1) * N_C; // 24

/// Sector dimension array.
pub const SECTOR_DIMS: [u64; 4] = [D1, D2, D3, D4];

/// Σd = d₁ + d₂ + d₃ + d₄ = 36.
pub const SIGMA_D: u64 = D1 + D2 + D3 + D4; // 36

/// Σd² = d₁² + d₂² + d₃² + d₄² = 650.
pub const SIGMA_D2: u64 = D1 * D1 + D2 * D2 + D3 * D3 + D4 * D4; // 650

/// Gauss integer: N_c² + N_w² = 13.
pub const GAUSS: u64 = N_C * N_C + N_W * N_W; // 13

/// Tower depth: D = Σd + χ = 42.
pub const TOWER_D: u64 = SIGMA_D + CHI; // 42

/// d_colour = N_w³ = 8.
pub const D_COLOUR: u64 = N_W * N_W * N_W; // 8

/// d_mixed = d₃ × N_c = 24 (same as D4).
pub const D_MIXED: u64 = D3 * N_C; // 24

/// Shared core: Σd² × D = 27300.
pub const SHARED_CORE: u64 = SIGMA_D2 * TOWER_D; // 27300

/// Casimir C_F = (N_c²−1)/(2N_c) = 4/3. Stored as (num, den).
pub const C_F: (u64, u64) = (N_C * N_C - 1, 2 * N_C); // (8, 6) = 4/3

/// Trace T_F = 1/2.
pub const T_F: (u64, u64) = (1, 2);

/// κ = ln3/ln2 (transcendental, but defined from N_w, N_c).
pub fn kappa() -> f64 {
    (N_C as f64).ln() / (N_W as f64).ln()
}

/// Fermat prime F₃ = 2^(2^N_c) + 1 = 257.
pub const FERMAT3: u64 = (1u64 << (1u64 << N_C)) + 1; // 257

// ═══════════════════════════════════════════════════════════════════
// SECTOR ENUM
// ═══════════════════════════════════════════════════════════════════

/// The four irreducible sectors of A_F.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Sector {
    Singlet, // d=1, λ=1
    Weak,    // d=3, λ=1/N_w
    Colour,  // d=8, λ=1/N_c
    Mixed,   // d=24, λ=1/χ
}

impl Sector {
    pub const ALL: [Sector; 4] = [
        Sector::Singlet,
        Sector::Weak,
        Sector::Colour,
        Sector::Mixed,
    ];

    /// Dimension of this sector.
    pub const fn dim(self) -> u64 {
        match self {
            Sector::Singlet => D1,
            Sector::Weak => D2,
            Sector::Colour => D3,
            Sector::Mixed => D4,
        }
    }

    /// Monad eigenvalue as exact (numerator, denominator).
    pub const fn eigenvalue(self) -> (u64, u64) {
        match self {
            Sector::Singlet => (1, 1),
            Sector::Weak => (1, N_W),
            Sector::Colour => (1, N_C),
            Sector::Mixed => (1, CHI),
        }
    }

    /// Eigenvalue as f64.
    pub fn lambda(self) -> f64 {
        let (n, d) = self.eigenvalue();
        n as f64 / d as f64
    }

    /// Index into arrays (0..4).
    pub const fn index(self) -> usize {
        match self {
            Sector::Singlet => 0,
            Sector::Weak => 1,
            Sector::Colour => 2,
            Sector::Mixed => 3,
        }
    }
}

impl std::fmt::Display for Sector {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            Sector::Singlet => write!(f, "Singlet(d={D1}, λ=1)"),
            Sector::Weak => write!(f, "Weak(d={D2}, λ=1/{N_W})"),
            Sector::Colour => write!(f, "Colour(d={D3}, λ=1/{N_C})"),
            Sector::Mixed => write!(f, "Mixed(d={D4}, λ=1/{CHI})"),
        }
    }
}

// ═══════════════════════════════════════════════════════════════════
// EXACT RATIONAL
// ═══════════════════════════════════════════════════════════════════

/// Exact rational for algebraic computations.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Frac {
    pub num: i64,
    pub den: i64,
}

impl Frac {
    pub const fn new(num: i64, den: i64) -> Self {
        Frac { num, den }
    }

    pub const ONE: Frac = Frac { num: 1, den: 1 };
    pub const ZERO: Frac = Frac { num: 0, den: 1 };

    pub fn value(self) -> f64 {
        self.num as f64 / self.den as f64
    }

    pub fn reduce(self) -> Self {
        let g = gcd(self.num.unsigned_abs(), self.den.unsigned_abs()) as i64;
        let sign = if self.den < 0 { -1 } else { 1 };
        Frac {
            num: sign * self.num / g,
            den: (sign * self.den) / g,
        }
    }

    pub fn one_plus(c: Frac) -> Frac {
        Frac::new(c.den + c.num, c.den).reduce()
    }

    pub fn one_minus(c: Frac) -> Frac {
        Frac::new(c.den - c.num, c.den).reduce()
    }

    pub fn neg(self) -> Frac {
        Frac::new(-self.num, self.den)
    }
}

impl std::fmt::Display for Frac {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        if self.den == 1 {
            write!(f, "{}", self.num)
        } else {
            write!(f, "{}/{}", self.num, self.den)
        }
    }
}

pub fn gcd(a: u64, b: u64) -> u64 {
    if b == 0 { a } else { gcd(b, a % b) }
}

pub fn lcm(a: u64, b: u64) -> u64 {
    a / gcd(a, b) * b
}

// ═══════════════════════════════════════════════════════════════════
// COMPILE-TIME ASSERTIONS
// ═══════════════════════════════════════════════════════════════════

const _: () = assert!(N_W == 2);
const _: () = assert!(N_C == 3);
const _: () = assert!(CHI == 6);
const _: () = assert!(BETA0 == 7);
const _: () = assert!(SIGMA_D == 36);
const _: () = assert!(SIGMA_D2 == 650);
const _: () = assert!(GAUSS == 13);
const _: () = assert!(TOWER_D == 42);
const _: () = assert!(D_COLOUR == 8);
const _: () = assert!(SHARED_CORE == 27300);
const _: () = assert!(FERMAT3 == 257);
const _: () = assert!(D1 + D2 + D3 + D4 == SIGMA_D);
