// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/rigid.rs — Rigid Body Dynamics from (2,3)
//
// Quaternion = N_w² = 4 components. Inertia tensor = χ = 6 independent.
// I_sphere = 2/5 = N_w/(χ−1) = Flory! I_rod = 1/12 = 1/(2χ).

use crate::atoms::*;

#[inline] fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  RIGID BODY CONSTANTS
// ═══════════════════════════════════════════════════════════════

pub const QUAT_COMPONENTS: u64 = N_W * N_W;      // 4
pub const INERTIA_INDEP: u64 = CHI;               // 6
pub const RIGID_DOF: u64 = CHI;                    // 6 = 3+3
pub const ROT_MATRIX: u64 = N_C * N_C;            // 9
pub const EULER_ANGLES: u64 = N_C;                 // 3
pub const ROTATION_AXES: u64 = N_C;                // 3

// ═══════════════════════════════════════════════════════════════
// §2  MOMENTS OF INERTIA
// ═══════════════════════════════════════════════════════════════

/// I_sphere = (2/5)MR² = N_w/(χ−1)·MR².
pub fn i_sphere(m: f64, r: f64) -> f64 { N_W as f64 / (CHI - 1) as f64 * m * r * r }
/// I_rod = (1/12)ML² = 1/(2χ)·ML².
pub fn i_rod(m: f64, l: f64) -> f64 { m * l * l / (2 * CHI) as f64 }
/// I_disk = (1/2)MR² = (1/N_w)·MR².
pub fn i_disk(m: f64, r: f64) -> f64 { m * r * r / N_W as f64 }
/// I_shell = (2/3)MR² = (N_w/N_c)·MR².
pub fn i_shell(m: f64, r: f64) -> f64 { N_W as f64 / N_C as f64 * m * r * r }

pub fn i_sphere_factor() -> f64 { N_W as f64 / (CHI - 1) as f64 }
pub fn i_rod_factor() -> f64 { 1.0 / (2 * CHI) as f64 }
pub fn i_disk_factor() -> f64 { 1.0 / N_W as f64 }
pub fn i_shell_factor() -> f64 { N_W as f64 / N_C as f64 }

// ═══════════════════════════════════════════════════════════════
// §3  QUATERNION ALGEBRA
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Debug, Copy)]
pub struct Quat { pub w: f64, pub x: f64, pub y: f64, pub z: f64 }

impl Quat {
    pub fn new(w: f64, x: f64, y: f64, z: f64) -> Self { Quat { w, x, y, z } }
    pub fn identity() -> Self { Quat { w: 1.0, x: 0.0, y: 0.0, z: 0.0 } }

    pub fn mul(&self, o: &Quat) -> Quat {
        Quat {
            w: self.w*o.w - self.x*o.x - self.y*o.y - self.z*o.z,
            x: self.w*o.x + self.x*o.w + self.y*o.z - self.z*o.y,
            y: self.w*o.y - self.x*o.z + self.y*o.w + self.z*o.x,
            z: self.w*o.z + self.x*o.y - self.y*o.x + self.z*o.w,
        }
    }

    pub fn norm(&self) -> f64 { (sq(self.w)+sq(self.x)+sq(self.y)+sq(self.z)).sqrt() }

    pub fn normalize(&self) -> Quat {
        let n = self.norm();
        if n < 1e-20 { Quat::identity() }
        else { Quat { w: self.w/n, x: self.x/n, y: self.y/n, z: self.z/n } }
    }

    pub fn conj(&self) -> Quat { Quat { w: self.w, x: -self.x, y: -self.y, z: -self.z } }
}

// ═══════════════════════════════════════════════════════════════
// §4  EULER EQUATIONS + INTEGRATOR
// ═══════════════════════════════════════════════════════════════

/// Torque-free Euler acceleration.
pub fn euler_accel(inertia: (f64,f64,f64), omega: (f64,f64,f64)) -> (f64,f64,f64) {
    let (ix, iy, iz) = inertia;
    let (wx, wy, wz) = omega;
    ((iy - iz) / ix * wy * wz,
     (iz - ix) / iy * wz * wx,
     (ix - iy) / iz * wx * wy)
}

#[derive(Clone, Debug)]
pub struct RigidBody {
    pub quat: Quat,
    pub omega: (f64, f64, f64),
    pub inertia: (f64, f64, f64),
}

impl RigidBody {
    pub fn new(inertia: (f64,f64,f64), omega: (f64,f64,f64)) -> Self {
        RigidBody { quat: Quat::identity(), omega, inertia }
    }

    /// Rotational KE = ½(I_x·ω_x² + I_y·ω_y² + I_z·ω_z²).
    pub fn energy(&self) -> f64 {
        let (ix,iy,iz) = self.inertia;
        let (wx,wy,wz) = self.omega;
        0.5 * (ix*sq(wx) + iy*sq(wy) + iz*sq(wz))
    }

    /// |L| = √((I_x·ω_x)² + (I_y·ω_y)² + (I_z·ω_z)²).
    pub fn ang_mom_mag(&self) -> f64 {
        let (ix,iy,iz) = self.inertia;
        let (wx,wy,wz) = self.omega;
        (sq(ix*wx) + sq(iy*wy) + sq(iz*wz)).sqrt()
    }
}

/// One symplectic step.
pub fn rigid_step(dt: f64, rb: &RigidBody) -> RigidBody {
    let (ax, ay, az) = euler_accel(rb.inertia, rb.omega);
    let (wx, wy, wz) = rb.omega;
    let wx2 = wx + ax * dt;
    let wy2 = wy + ay * dt;
    let wz2 = wz + az * dt;
    // Quaternion update: dq/dt = 0.5·q·(0,ω)
    let om_q = Quat::new(0.0, wx2, wy2, wz2);
    let dq = rb.quat.mul(&om_q);
    let q2 = Quat::new(
        rb.quat.w + 0.5 * dt * dq.w, rb.quat.x + 0.5 * dt * dq.x,
        rb.quat.y + 0.5 * dt * dq.y, rb.quat.z + 0.5 * dt * dq.z,
    ).normalize();
    RigidBody { quat: q2, omega: (wx2, wy2, wz2), inertia: rb.inertia }
}

/// Evolve rigid body. Returns (energies, ang_mom_magnitudes, quat_norms).
pub fn rigid_evolve(dt: f64, n_steps: usize, rb0: &RigidBody) -> (Vec<f64>, Vec<f64>, Vec<f64>) {
    let mut ens = Vec::with_capacity(n_steps + 1);
    let mut lms = Vec::with_capacity(n_steps + 1);
    let mut qns = Vec::with_capacity(n_steps + 1);
    let mut rb = rb0.clone();
    ens.push(rb.energy()); lms.push(rb.ang_mom_mag()); qns.push(rb.quat.norm());
    for _ in 0..n_steps {
        rb = rigid_step(dt, &rb);
        ens.push(rb.energy()); lms.push(rb.ang_mom_mag()); qns.push(rb.quat.norm());
    }
    (ens, lms, qns)
}

// ═══════════════════════════════════════════════════════════════
// §5  INTEGER PROOFS
// ═══════════════════════════════════════════════════════════════

pub const PROVE_QUAT: u64 = N_W * N_W;                       // 4
pub const PROVE_INERTIA: u64 = CHI;                            // 6
pub const PROVE_DOF: u64 = N_C + N_C;                         // 6
pub const PROVE_ROT_MAT: u64 = N_C * N_C;                    // 9
pub const PROVE_I_SPHERE: (u64, u64) = (N_W, CHI - 1);       // 2/5
pub const PROVE_I_ROD: (u64, u64) = (1, 2 * CHI);            // 1/12
pub const PROVE_I_DISK: (u64, u64) = (1, N_W);               // 1/2
pub const PROVE_I_SHELL: (u64, u64) = (N_W, N_C);            // 2/3

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn quat_4() { assert_eq!(PROVE_QUAT, 4); }
    #[test] fn inertia_6() { assert_eq!(PROVE_INERTIA, 6); }
    #[test] fn dof_6() { assert_eq!(PROVE_DOF, 6); }
    #[test] fn rot_mat_9() { assert_eq!(PROVE_ROT_MAT, 9); }
    #[test] fn i_sphere_2_5() { assert!((i_sphere_factor() - 0.4).abs() < 1e-10); }
    #[test] fn i_rod_1_12() { assert!((i_rod_factor() - 1.0/12.0).abs() < 1e-10); }
    #[test] fn i_disk_1_2() { assert!((i_disk_factor() - 0.5).abs() < 1e-10); }
    #[test] fn i_shell_2_3() { assert!((i_shell_factor() - 2.0/3.0).abs() < 1e-10); }

    #[test] fn quat_mul_identity() {
        let q = Quat::new(0.5_f64.sqrt(), 0.5_f64.sqrt(), 0.0, 0.0);
        let r = q.mul(&Quat::identity());
        assert!((r.w - q.w).abs() < 1e-10);
    }

    #[test] fn quat_norm_preserved() {
        let q = Quat::new(1.0, 2.0, 3.0, 4.0).normalize();
        assert!((q.norm() - 1.0).abs() < 1e-10);
    }

    #[test] fn energy_conserved_torque_free() {
        let rb = RigidBody::new((1.0, 2.0, 3.0), (1.0, 0.5, 0.3));
        let (ens, _, _) = rigid_evolve(0.001, 10000, &rb);
        let e0 = ens[0];
        let max_dev = ens.iter().map(|e| (e - e0).abs() / e0).fold(0.0_f64, f64::max);
        assert!(max_dev < 0.01, "Energy dev: {}", max_dev);
    }

    #[test] fn ang_mom_conserved() {
        let rb = RigidBody::new((1.0, 2.0, 3.0), (1.0, 0.5, 0.3));
        let (_, lms, _) = rigid_evolve(0.001, 10000, &rb);
        let l0 = lms[0];
        let max_dev = lms.iter().map(|l| (l - l0).abs() / l0).fold(0.0_f64, f64::max);
        assert!(max_dev < 0.01, "L dev: {}", max_dev);
    }
}
