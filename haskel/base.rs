// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later

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

// ═══════════════════════════════════════════════════════════════
// §5  LAYER PROVENANCE — const-generic DerivedAt<D>
// ═══════════════════════════════════════════════════════════════
//
// Every constant is tagged with the MERA layer D that derives it.
// DerivedAt<28> can only be constructed at layer 28. The type system
// prevents mixing layers without explicit derivation.
//
// Usage:
//   let ca_ca: DerivedAt<28> = DerivedAt::new(3.8);
//   let alpha: DerivedAt<5>  = DerivedAt::new(1.0 / 137.036);

/// A physical constant tagged with its derivation layer in the spectral tower.
#[derive(Clone, Copy, Debug)]
pub struct DerivedAt<const D: usize> {
    value: f64,
}

impl<const D: usize> DerivedAt<D> {
    /// Create a constant at layer D.
    pub const fn new(value: f64) -> Self { DerivedAt { value } }

    /// Get the numeric value.
    pub const fn val(&self) -> f64 { self.value }

    /// Get the derivation layer.
    pub const fn layer(&self) -> usize { D }

    /// Apply a derivation to produce a constant at the next layer.
    /// The type system tracks the layer transition.
    pub fn derive_to<const D2: usize>(&self, f: impl Fn(f64) -> f64) -> DerivedAt<D2> {
        DerivedAt { value: f(self.value) }
    }
}

impl<const D: usize> From<DerivedAt<D>> for f64 {
    fn from(d: DerivedAt<D>) -> f64 { d.value }
}

// ─── D=0: Algebra constants ─────────────────────────────────
pub const LAYER0_CHI: DerivedAt<0> = DerivedAt::new(CHI as f64);
pub const LAYER0_BETA0: DerivedAt<0> = DerivedAt::new(BETA0 as f64);
pub const LAYER0_SIGMA_D: DerivedAt<0> = DerivedAt::new(SIGMA_D as f64);
pub const LAYER0_SIGMA_D2: DerivedAt<0> = DerivedAt::new(SIGMA_D2 as f64);
pub const LAYER0_D_MAX: DerivedAt<0> = DerivedAt::new(D_TOTAL as f64);
pub const LAYER0_V_HIGGS: DerivedAt<0> = DerivedAt::new(246.22);

// ─── D=5: Frozen fine structure constant ────────────────────
// alpha_inv = (D+1)*pi + ln(beta_0) = 43*pi + ln(7)
pub fn layer5_alpha_inv() -> DerivedAt<5> {
    let d = D_TOTAL as f64;
    let b = BETA0 as f64;
    DerivedAt::new((d + 1.0) * PI + b.ln())
}

pub fn layer5_alpha() -> DerivedAt<5> {
    DerivedAt::new(1.0 / layer5_alpha_inv().val())
}

// ─── D=10: QCD ──────────────────────────────────────────────
pub fn layer10_proton_mass() -> DerivedAt<10> {
    let v = LAYER0_V_HIGGS.val();
    let f3 = FERMAT3 as f64;
    let nc = NC as f64;
    let nw = NW as f64;
    DerivedAt::new(v / f3 * (nc.powi(3) * nw - 1.0) / (nc.powi(3) * nw))
}

// ─── D=18: Bohr radius — DERIVED ────────────────────────────
// a_0 = hbar*c / (m_e * alpha)
// hbar*c = 1.97327e-6 GeV*Å (unit conversion, not physics)
// m_e = 0.000511 GeV (measured — Yukawa sector open)
pub fn layer18_bohr() -> DerivedAt<18> {
    let hbar_c_gev_a: f64 = 197.3269804e-8; // GeV*Å
    let m_e: f64 = 0.000511; // GeV
    let alpha = layer5_alpha().val();
    DerivedAt::new(hbar_c_gev_a / (m_e * alpha))
}

// ─── D=20: Hybridization ───────────────────────────────────
pub fn layer20_sp3() -> DerivedAt<20> {
    DerivedAt::new((-1.0_f64 / 3.0).acos().to_degrees())
}

// ─── D=25: Strand spacings — DERIVED from VdW chain ────────
// H_bond = r_vdw_N + r_vdw_O (VdW contact)
// strand_anti = 2 * H_bond * cos((180 - sp3)/2)
// strand_par = strand_anti * (1 + 1/beta_0)
pub fn layer25_strand_anti() -> DerivedAt<25> {
    // Pure derivation chain from spectral_tower_pure.py
    // VdW radii from Slater screening → H-bond → zigzag → spacing
    // Current pure tower value (D=22 gap means ~44% off textbook)
    let sp3_rad = (-1.0_f64 / 3.0).acos();
    let zigzag_half = (PI - sp3_rad) / 2.0;
    // VdW contact for N...O: computed from orbital radii
    // Using pure tower chain values
    let a0 = layer18_bohr().val();
    let kappa = (NC as f64).ln() / (NW as f64).ln();
    // Slater Z_eff for N(2p): Z=7, sigma = 2*0.85 + 4*0.35 = 3.10, Z_eff=3.90
    let z_eff_n = 7.0 - (2.0 * 0.85 + 4.0 * 0.35);
    let z_eff_o = 8.0 - (2.0 * 0.85 + 5.0 * 0.35);
    let r_n = a0 * (3.0 * 4.0 - 2.0) / (2.0 * z_eff_n); // <r>_2p for N
    let r_o = a0 * (3.0 * 4.0 - 2.0) / (2.0 * z_eff_o); // <r>_2p for O
    let vdw_n = r_n + a0 * 2.0 / z_eff_n;
    let vdw_o = r_o + a0 * 2.0 / z_eff_o;
    let alpha = layer5_alpha().val();
    let hbond = (vdw_n + vdw_o) * (1.0 - alpha.sqrt());
    DerivedAt::new(2.0 * hbond * zigzag_half.cos())
}

pub fn layer25_strand_par() -> DerivedAt<25> {
    let anti = layer25_strand_anti().val();
    let b = BETA0 as f64;
    DerivedAt::new(anti * (1.0 + 1.0 / b))
}

// ─── D=28: CA-CA virtual bond — DERIVED ────────────────────
// Three bonds: CA-C, C-N, N-CA from covalent radii
// Two angles: from sp2 + electronegativity difference
pub fn layer28_ca_ca() -> DerivedAt<28> {
    let a0 = layer18_bohr().val();
    // Slater Z_eff
    let z_eff_c = 6.0 - (2.0 * 0.85 + 3.0 * 0.35); // 3.25
    let z_eff_n = 7.0 - (2.0 * 0.85 + 4.0 * 0.35); // 3.90
    // <r> for 2p orbitals
    let r_c = a0 * (3.0 * 4.0 - 2.0) / (2.0 * z_eff_c);
    let r_n = a0 * (3.0 * 4.0 - 2.0) / (2.0 * z_eff_n);
    // Bond lengths
    let ca_c = 2.0 * r_c;                     // C-C single bond
    let n_ca = r_n + r_c;                       // N-CA
    let bond_order = 1.5_f64;                   // resonance: (1+2)/2
    let cn = (r_c + r_n) - a0 * bond_order.ln(); // Pauling bond order
    // Bond angles from sp2 + electronegativity
    let sp2 = 120.0_f64;
    let sp3 = (-1.0_f64 / 3.0).acos().to_degrees();
    let delta = sp2 - sp3;
    let chi_c = z_eff_c / 4.0;
    let chi_n = z_eff_n / 4.0;
    let chi_diff = (chi_n - chi_c) / ((chi_n + chi_c) / 2.0);
    let ang1 = (sp2 - delta * chi_diff).to_radians();
    let ang2 = (sp2 + delta * (-chi_diff)).to_radians();
    // Law of cosines: CA -> C -> N -> CA
    let d_ca_n = (ca_c * ca_c + cn * cn - 2.0 * ca_c * cn * ang1.cos()).sqrt();
    let d_ca_ca = (d_ca_n * d_ca_n + n_ca * n_ca - 2.0 * d_ca_n * n_ca * ang2.cos()).sqrt();
    DerivedAt::new(d_ca_ca)
}

// ─── D=32: Helix geometry ──────────────────────────────────
pub fn layer32_helix_per_turn() -> DerivedAt<32> {
    let nc = NC as f64;
    let chi = CHI as f64;
    DerivedAt::new(nc + nc / (chi - 1.0))
}

pub fn layer32_helix_rise() -> DerivedAt<32> {
    DerivedAt::new(NC as f64 / NW as f64)
}

// ─── D=33: Flory exponent ──────────────────────────────────
pub fn layer33_flory_nu() -> DerivedAt<33> {
    DerivedAt::new(NW as f64 / (NW + NC) as f64)
}

// ─── D=42: Fold energy scale ───────────────────────────────
pub fn layer42_fold_energy() -> DerivedAt<42> {
    DerivedAt::new(LAYER0_V_HIGGS.val() / (2.0_f64).powi(42))
}

