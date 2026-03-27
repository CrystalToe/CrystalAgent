//! Crystal Topos base types: complex numbers, vectors, matrices, and all constants.
//! Everything derived from N_w=2, N_c=3.

use std::f64::consts::PI;

// ═══════════════════════════════════════════════════════════════
// §0  CRYSTAL CONSTANTS — all from 2 and 3
// ═══════════════════════════════════════════════════════════════

pub const NW: usize = 2;
pub const NC: usize = 3;
pub const CHI: usize = NW * NC;                            // 6
pub const BETA0: usize = (11 * NC - 2 * CHI) / 3;         // 7
pub const DIMS: [usize; 4] = [1, NC, NC * NC - 1, NW * NW * NW * NC]; // [1,3,8,24]
pub const SIGMA_D: usize = 1 + NC + (NC * NC - 1) + (NW * NW * NW * NC); // 36
pub const SIGMA_D2: usize = 1 + 9 + 64 + 576;             // 650
pub const GAUSS: usize = NC * NC + NW * NW;                // 13
pub const D_TOTAL: usize = SIGMA_D + CHI;                  // 42
pub const FERMAT3: usize = 257;  // 2^(2^NC) + 1, computed at init

pub fn kappa() -> f64 { (NC as f64).ln() / (NW as f64).ln() }  // ln3/ln2

pub const LAMBDAS: [f64; 4] = [1.0, 0.5, 1.0 / 3.0, 1.0 / 6.0];

pub fn energies() -> [f64; 4] {
    [0.0, (NW as f64).ln(), (NC as f64).ln(), (CHI as f64).ln()]
}

pub fn max_entropy() -> f64 { (CHI as f64).ln() }  // ln(6)
pub fn mass_gap() -> f64 { (NW as f64).ln() }      // ln(2)

pub const SECTOR_NAMES: [&str; 4] = ["Singlet", "Weak", "Colour", "Mixed"];

// ═══════════════════════════════════════════════════════════════
// §1  COMPLEX NUMBERS
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Cx {
    pub re: f64,
    pub im: f64,
}

impl Cx {
    pub const ZERO: Cx = Cx { re: 0.0, im: 0.0 };
    pub const ONE: Cx = Cx { re: 1.0, im: 0.0 };
    pub const I: Cx = Cx { re: 0.0, im: 1.0 };

    pub fn new(re: f64, im: f64) -> Self { Cx { re, im } }
    pub fn from_real(r: f64) -> Self { Cx { re: r, im: 0.0 } }

    pub fn conj(self) -> Self { Cx { re: self.re, im: -self.im } }
    pub fn norm2(self) -> f64 { self.re * self.re + self.im * self.im }
    pub fn norm(self) -> f64 { self.norm2().sqrt() }

    pub fn exp(self) -> Self {
        let r = self.re.exp();
        Cx { re: r * self.im.cos(), im: r * self.im.sin() }
    }

    pub fn scale(self, s: f64) -> Self { Cx { re: s * self.re, im: s * self.im } }
}

impl std::ops::Add for Cx {
    type Output = Cx;
    fn add(self, rhs: Cx) -> Cx { Cx { re: self.re + rhs.re, im: self.im + rhs.im } }
}
impl std::ops::Sub for Cx {
    type Output = Cx;
    fn sub(self, rhs: Cx) -> Cx { Cx { re: self.re - rhs.re, im: self.im - rhs.im } }
}
impl std::ops::Mul for Cx {
    type Output = Cx;
    fn mul(self, rhs: Cx) -> Cx {
        Cx { re: self.re * rhs.re - self.im * rhs.im,
             im: self.re * rhs.im + self.im * rhs.re }
    }
}
impl std::ops::Neg for Cx {
    type Output = Cx;
    fn neg(self) -> Cx { Cx { re: -self.re, im: -self.im } }
}

// ═══════════════════════════════════════════════════════════════
// §2  VECTORS (ℂ^n)
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Debug)]
pub struct Vec_ {
    pub data: Vec<Cx>,
}

impl Vec_ {
    pub fn new(n: usize) -> Self { Vec_ { data: vec![Cx::ZERO; n] } }
    pub fn dim(&self) -> usize { self.data.len() }

    pub fn basis(n: usize, k: usize) -> Self {
        let mut v = Self::new(n);
        v.data[k] = Cx::ONE;
        v
    }

    pub fn equal(n: usize) -> Self {
        let s = 1.0 / (n as f64).sqrt();
        Vec_ { data: vec![Cx::from_real(s); n] }
    }

    pub fn norm(&self) -> f64 {
        self.data.iter().map(|c| c.norm2()).sum::<f64>().sqrt()
    }

    pub fn normalize(&mut self) {
        let n = self.norm();
        if n > 1e-15 {
            for c in &mut self.data { *c = c.scale(1.0 / n); }
        }
    }

    pub fn normalized(&self) -> Self {
        let mut v = self.clone();
        v.normalize();
        v
    }

    pub fn prob(&self, k: usize) -> f64 { self.data[k].norm2() }

    pub fn entropy(&self) -> f64 {
        let mut s = 0.0;
        for c in &self.data {
            let p = c.norm2();
            if p > 1e-15 { s -= p * p.ln(); }
        }
        s
    }

    pub fn dot(&self, other: &Vec_) -> Cx {
        self.data.iter().zip(other.data.iter())
            .map(|(a, b)| a.conj() * *b)
            .fold(Cx::ZERO, |acc, x| acc + x)
    }

    pub fn add(&self, other: &Vec_) -> Self {
        Vec_ { data: self.data.iter().zip(other.data.iter()).map(|(a, b)| *a + *b).collect() }
    }

    pub fn scale(&self, s: f64) -> Self {
        Vec_ { data: self.data.iter().map(|c| c.scale(s)).collect() }
    }
}

// ═══════════════════════════════════════════════════════════════
// §3  MATRICES (M_n(ℂ))
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Debug)]
pub struct Mat {
    pub rows: usize,
    pub cols: usize,
    pub data: Vec<Cx>,  // row-major
}

impl Mat {
    pub fn new(n: usize) -> Self {
        Mat { rows: n, cols: n, data: vec![Cx::ZERO; n * n] }
    }

    pub fn identity(n: usize) -> Self {
        let mut m = Self::new(n);
        for i in 0..n { m.set(i, i, Cx::ONE); }
        m
    }

    pub fn get(&self, i: usize, j: usize) -> Cx { self.data[i * self.cols + j] }
    pub fn set(&mut self, i: usize, j: usize, v: Cx) { self.data[i * self.cols + j] = v; }

    pub fn from_diag(diag: &[Cx]) -> Self {
        let n = diag.len();
        let mut m = Self::new(n);
        for i in 0..n { m.set(i, i, diag[i]); }
        m
    }

    pub fn mul_mat(&self, other: &Mat) -> Mat {
        let n = self.rows;
        let mut result = Mat::new(n);
        for i in 0..n {
            for j in 0..n {
                let mut sum = Cx::ZERO;
                for k in 0..n { sum = sum + self.get(i, k) * other.get(k, j); }
                result.set(i, j, sum);
            }
        }
        result
    }

    pub fn apply(&self, v: &Vec_) -> Vec_ {
        let n = self.rows;
        let mut result = Vec_::new(n);
        for i in 0..n {
            let mut sum = Cx::ZERO;
            for j in 0..n { sum = sum + self.get(i, j) * v.data[j]; }
            result.data[i] = sum;
        }
        result
    }

    pub fn dagger(&self) -> Mat {
        let n = self.rows;
        let mut result = Mat::new(n);
        for i in 0..n {
            for j in 0..n { result.set(i, j, self.get(j, i).conj()); }
        }
        result
    }

    pub fn trace(&self) -> Cx {
        (0..self.rows).map(|i| self.get(i, i)).fold(Cx::ZERO, |a, b| a + b)
    }

    pub fn scale(&self, s: f64) -> Mat {
        Mat { rows: self.rows, cols: self.cols,
              data: self.data.iter().map(|c| c.scale(s)).collect() }
    }
}

// ═══════════════════════════════════════════════════════════════
// §4  NEW DERIVED CONSTANTS — thermodynamics, fluids, confinement, biology
// ═══════════════════════════════════════════════════════════════

pub const D_SINGLET: usize = 1;   // first sector dimension
pub const D_COLOUR: usize = 8;    // N_c² - 1 = adjoint = gluon count
pub const D_MIXED: usize = 24;    // N_w³ × N_c
pub const MIXING_OPS: usize = CHI * (CHI - 1);  // 30 sector-mixing operators

// Thermodynamics
pub fn carnot_efficiency() -> f64 { (CHI - 1) as f64 / CHI as f64 }  // 5/6
pub const STEFAN_BOLTZMANN_DENOM: usize = NW * NC * (NC*NC + NW*NW + (11*NC - 2*NW*NC)/3); // 120
pub fn thermal_conductivity() -> f64 { (CHI * MIXING_OPS) as f64 / SIGMA_D as f64 } // 5.0

// Fluid dynamics
pub fn kolmogorov_exponent() -> f64 { (NC + NW) as f64 / NC as f64 }  // 5/3
pub fn kolmogorov_microscale() -> f64 { 1.0 / (NW * NW) as f64 }      // 1/4
pub fn von_karman() -> f64 { NW as f64 / (NC + NW) as f64 }           // 2/5
pub fn reynolds_critical() -> f64 { (D_TOTAL * (D_TOTAL + GAUSS)) as f64 } // 2310

// Color confinement
pub fn casimir_fundamental() -> f64 { (NC*NC - 1) as f64 / (2 * NC) as f64 } // 4/3
pub fn string_tension_ratio() -> f64 { NC as f64 / (NC*NC - 1) as f64 }       // 3/8

// Biological information
pub const DNA_BASES: usize = NW * NW;                    // 4
pub const CODONS: usize = (NW*NW) * (NW*NW) * (NW*NW);  // 64
pub const AMINO_ACIDS: usize = NC*NC + NW*NW + (11*NC - 2*NW*NC)/3; // 20
pub const CODON_SIGNALS: usize = NC * ((11*NC - 2*NW*NC)/3);         // 21
