// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// dynamics/nbody.rs — N-Body Gravitational Dynamics from (2,3)
//
// Barnes-Hut octree for O(N log N) force computation.
// Symplectic leapfrog (same W∘U∘W as classical).
//
//   Oct-tree children:  8 = 2^N_c = N_w^N_c = d_colour
//   Force exponent:     2 = N_c - 1 (inverse square)
//   Spatial dimensions: 3 = N_c
//   Phase space/body:   6 = 2*N_c = χ

use crate::atoms::*;

// ═══════════════════════════════════════════════════════════════
// §0  CRYSTAL CONSTANTS
// ═══════════════════════════════════════════════════════════════

pub const OCTREE_CHILDREN: u64 = D_COLOUR;     // 8 = N_w³ = 2^N_c
pub const FORCE_EXPONENT: u64 = N_C - 1;       // 2
pub const PHASE_PER_BODY: u64 = CHI;           // 6

/// Barnes-Hut opening criterion: open node if size/distance > 1/N_w
pub fn should_open_node(node_size: f64, distance: f64) -> bool {
    node_size / distance > 1.0 / N_W as f64
}

#[inline]
fn sq(x: f64) -> f64 { x * x }

// ═══════════════════════════════════════════════════════════════
// §1  BODY TYPE
// ═══════════════════════════════════════════════════════════════

#[derive(Clone, Debug)]
pub struct Body {
    pub px: f64, pub py: f64, pub pz: f64,
    pub vx: f64, pub vy: f64, pub vz: f64,
    pub m: f64,
}

impl Body {
    pub fn new(px: f64, py: f64, pz: f64, vx: f64, vy: f64, vz: f64, m: f64) -> Self {
        Body { px, py, pz, vx, vy, vz, m }
    }
}

// ═══════════════════════════════════════════════════════════════
// §2  BARNES-HUT OCTREE
//
// 8 children = 2^N_c = d_colour.
// Opening angle θ: use multipole if size/distance < θ.
// ═══════════════════════════════════════════════════════════════

enum OctTree {
    Empty,
    Leaf { x: f64, y: f64, z: f64, m: f64 },
    Node {
        cx: f64, cy: f64, cz: f64, total_m: f64, size: f64,
        children: Box<[OctTree; 8]>,
    },
}

/// Which octant: 4*(z>cz) + 2*(y>cy) + (x>cx)
fn octant(x: f64, y: f64, z: f64, cx: f64, cy: f64, cz: f64) -> usize {
    let bx = if x > cx { 1 } else { 0 };
    let by = if y > cy { 1 } else { 0 };
    let bz = if z > cz { 1 } else { 0 };
    bz * 4 + by * 2 + bx
}

fn empty_children() -> Box<[OctTree; 8]> {
    Box::new([
        OctTree::Empty, OctTree::Empty, OctTree::Empty, OctTree::Empty,
        OctTree::Empty, OctTree::Empty, OctTree::Empty, OctTree::Empty,
    ])
}

fn insert(tree: OctTree, x: f64, y: f64, z: f64, m: f64, size: f64) -> OctTree {
    match tree {
        OctTree::Empty => OctTree::Leaf { x, y, z, m },
        OctTree::Leaf { x: lx, y: ly, z: lz, m: lm } => {
            let half = size / 2.0;
            let mut children = empty_children();
            let oct_old = octant(lx, ly, lz, lx, ly, lz);
            children[oct_old] = OctTree::Leaf { x: lx, y: ly, z: lz, m: lm };
            let tm = lm + m;
            let cx = (lx * lm + x * m) / tm;
            let cy = (ly * lm + y * m) / tm;
            let cz = (lz * lm + z * m) / tm;
            let oct_new = octant(x, y, z, cx, cy, cz);
            children[oct_new] = insert(
                std::mem::replace(&mut children[oct_new], OctTree::Empty),
                x, y, z, m, half,
            );
            OctTree::Node { cx, cy, cz, total_m: tm, size, children }
        }
        OctTree::Node { cx, cy, cz, total_m, size: s, mut children } => {
            let tm = total_m + m;
            let ncx = (cx * total_m + x * m) / tm;
            let ncy = (cy * total_m + y * m) / tm;
            let ncz = (cz * total_m + z * m) / tm;
            let oct = octant(x, y, z, cx, cy, cz);
            let half = s / 2.0;
            children[oct] = insert(
                std::mem::replace(&mut children[oct], OctTree::Empty),
                x, y, z, m, half,
            );
            OctTree::Node { cx: ncx, cy: ncy, cz: ncz, total_m: tm, size: s, children }
        }
    }
}

/// Build octree from bodies.
fn build_tree(box_size: f64, bodies: &[Body]) -> OctTree {
    let mut tree = OctTree::Empty;
    for b in bodies {
        tree = insert(tree, b.px, b.py, b.pz, b.m, box_size);
    }
    tree
}

// ═══════════════════════════════════════════════════════════════
// §3  TREE FORCE COMPUTATION
// ═══════════════════════════════════════════════════════════════

/// Acceleration from tree. theta = opening angle.
fn tree_accel(theta: f64, eps: f64, tree: &OctTree, px: f64, py: f64, pz: f64) -> (f64, f64, f64) {
    match tree {
        OctTree::Empty => (0.0, 0.0, 0.0),
        OctTree::Leaf { x, y, z, m } => {
            let dx = px - x; let dy = py - y; let dz = pz - z;
            let r2 = dx*dx + dy*dy + dz*dz + eps*eps;
            if r2 < eps * eps * 4.0 { return (0.0, 0.0, 0.0); }
            let r = r2.sqrt();
            let r3 = r * r2;
            let f = -m / r3;
            (f*dx, f*dy, f*dz)
        }
        OctTree::Node { cx, cy, cz, total_m, size, children } => {
            let dx = px - cx; let dy = py - cy; let dz = pz - cz;
            let r2 = dx*dx + dy*dy + dz*dz + eps*eps;
            let r = r2.sqrt();
            if size / r < theta {
                let r3 = r * r2;
                let f = -total_m / r3;
                (f*dx, f*dy, f*dz)
            } else {
                let mut ax = 0.0; let mut ay = 0.0; let mut az = 0.0;
                for child in children.iter() {
                    let (cx, cy, cz) = tree_accel(theta, eps, child, px, py, pz);
                    ax += cx; ay += cy; az += cz;
                }
                (ax, ay, az)
            }
        }
    }
}

// ═══════════════════════════════════════════════════════════════
// §4  DIRECT O(N²) FORCE
// ═══════════════════════════════════════════════════════════════

/// Direct acceleration on body b from all others.
pub fn direct_accel(eps: f64, bodies: &[Body], b: &Body) -> (f64, f64, f64) {
    let mut ax = 0.0; let mut ay = 0.0; let mut az = 0.0;
    for bj in bodies {
        let dx = b.px - bj.px; let dy = b.py - bj.py; let dz = b.pz - bj.pz;
        let r2 = dx*dx + dy*dy + dz*dz + eps*eps;
        if r2 < eps * eps * 4.0 { continue; }
        let r = r2.sqrt();
        let r3 = r * r2;
        let f = -bj.m / r3;
        ax += f*dx; ay += f*dy; az += f*dz;
    }
    (ax, ay, az)
}

// ═══════════════════════════════════════════════════════════════
// §5  SYMPLECTIC LEAPFROG — W∘U∘W
// ═══════════════════════════════════════════════════════════════

/// One leapfrog tick using direct O(N²) force.
pub fn nbody_tick_direct(dt: f64, eps: f64, bodies: &[Body]) -> Vec<Body> {
    // W: half-kick
    let bodies1: Vec<Body> = bodies.iter().map(|b| {
        let (ax, ay, az) = direct_accel(eps, bodies, b);
        Body { vx: b.vx + (dt/2.0)*ax, vy: b.vy + (dt/2.0)*ay, vz: b.vz + (dt/2.0)*az, ..*b }
    }).collect();
    // U: full drift
    let bodies2: Vec<Body> = bodies1.iter().map(|b| {
        Body { px: b.px + dt*b.vx, py: b.py + dt*b.vy, pz: b.pz + dt*b.vz, ..*b }
    }).collect();
    // W: half-kick at new positions
    bodies2.iter().map(|b| {
        let (ax, ay, az) = direct_accel(eps, &bodies2, b);
        Body { vx: b.vx + (dt/2.0)*ax, vy: b.vy + (dt/2.0)*ay, vz: b.vz + (dt/2.0)*az, ..*b }
    }).collect()
}

/// One leapfrog tick using Barnes-Hut tree (O(N log N)).
pub fn nbody_tick_tree(dt: f64, theta: f64, eps: f64, box_size: f64, bodies: &[Body]) -> Vec<Body> {
    let tree = build_tree(box_size, bodies);
    let bodies1: Vec<Body> = bodies.iter().map(|b| {
        let (ax, ay, az) = tree_accel(theta, eps, &tree, b.px, b.py, b.pz);
        Body { vx: b.vx + (dt/2.0)*ax, vy: b.vy + (dt/2.0)*ay, vz: b.vz + (dt/2.0)*az, ..*b }
    }).collect();
    let bodies2: Vec<Body> = bodies1.iter().map(|b| {
        Body { px: b.px + dt*b.vx, py: b.py + dt*b.vy, pz: b.pz + dt*b.vz, ..*b }
    }).collect();
    let tree2 = build_tree(box_size, &bodies2);
    bodies2.iter().map(|b| {
        let (ax, ay, az) = tree_accel(theta, eps, &tree2, b.px, b.py, b.pz);
        Body { vx: b.vx + (dt/2.0)*ax, vy: b.vy + (dt/2.0)*ay, vz: b.vz + (dt/2.0)*az, ..*b }
    }).collect()
}

/// Evolve N steps (direct). Returns list of snapshots.
pub fn evolve_direct(dt: f64, eps: f64, n: usize, bodies: &[Body]) -> Vec<Vec<Body>> {
    let mut snapshots = Vec::with_capacity(n + 1);
    let mut current = bodies.to_vec();
    snapshots.push(current.clone());
    for _ in 0..n {
        current = nbody_tick_direct(dt, eps, &current);
        snapshots.push(current.clone());
    }
    snapshots
}

/// Evolve N steps returning only final state.
pub fn evolve_direct_final(dt: f64, eps: f64, n: usize, bodies: &[Body]) -> Vec<Body> {
    let mut current = bodies.to_vec();
    for _ in 0..n {
        current = nbody_tick_direct(dt, eps, &current);
    }
    current
}

// ═══════════════════════════════════════════════════════════════
// §6  CONSERVED QUANTITIES
// ═══════════════════════════════════════════════════════════════

pub fn kinetic_energy(bodies: &[Body]) -> f64 {
    bodies.iter().map(|b| 0.5 * b.m * (sq(b.vx) + sq(b.vy) + sq(b.vz))).sum()
}

pub fn potential_energy(eps: f64, bodies: &[Body]) -> f64 {
    let mut pe = 0.0;
    for i in 0..bodies.len() {
        for j in (i+1)..bodies.len() {
            let dx = bodies[i].px - bodies[j].px;
            let dy = bodies[i].py - bodies[j].py;
            let dz = bodies[i].pz - bodies[j].pz;
            let r = (dx*dx + dy*dy + dz*dz + eps*eps).sqrt();
            pe -= bodies[i].m * bodies[j].m / r;
        }
    }
    pe
}

pub fn total_energy(eps: f64, bodies: &[Body]) -> f64 {
    kinetic_energy(bodies) + potential_energy(eps, bodies)
}

pub fn total_momentum(bodies: &[Body]) -> (f64, f64, f64) {
    bodies.iter().fold((0.0, 0.0, 0.0), |(px, py, pz), b| {
        (px + b.m * b.vx, py + b.m * b.vy, pz + b.m * b.vz)
    })
}

// ═══════════════════════════════════════════════════════════════
// §7  INITIAL CONDITIONS
// ═══════════════════════════════════════════════════════════════

/// Two-body Kepler system (circular orbit).
pub fn two_body_kepler(m1: f64, m2: f64, sep: f64) -> Vec<Body> {
    let total = m1 + m2;
    let r1 = sep * m2 / total;
    let r2 = sep * m1 / total;
    let v1 = (total / sep).sqrt() * (m2 / total);
    let v2 = (total / sep).sqrt() * (m1 / total);
    vec![
        Body::new(r1, 0.0, 0.0, 0.0, v1, 0.0, m1),
        Body::new(-r2, 0.0, 0.0, 0.0, -v2, 0.0, m2),
    ]
}

/// Three-body figure-eight (Chenciner-Montgomery).
pub fn three_body_figure_eight() -> Vec<Body> {
    let v = 0.347111;
    vec![
        Body::new(-0.97000436, 0.24308753, 0.0, v, v, 0.0, 1.0),
        Body::new(0.97000436, -0.24308753, 0.0, v, v, 0.0, 1.0),
        Body::new(0.0, 0.0, 0.0, -2.0*v, -2.0*v, 0.0, 1.0),
    ]
}

/// Plummer sphere: N bodies in approximate virial equilibrium.
pub fn plummer_sphere(n: usize, total_m: f64, r_scale: f64) -> Vec<Body> {
    (1..=n).map(|i| {
        let fi = i as f64 / n as f64;
        let theta = fi * 7.13;
        let phi = fi * 11.07;
        let r = r_scale * (fi.powf(0.33) + 0.1);
        let x = r * theta.sin() * phi.cos();
        let y = r * theta.sin() * phi.sin();
        let z = r * theta.cos();
        let m = total_m / n as f64;
        let vs = 0.1 * (total_m / (r + r_scale)).sqrt();
        Body::new(x, y, z, vs*(phi+1.5).cos(), vs*(phi+1.5).sin(), vs*theta.cos()*0.3, m)
    }).collect()
}

/// Solar system inner planets (Sun + Mercury-Mars, simplified).
pub fn solar_system_inner() -> Vec<Body> {
    // Units: AU, yr, M_sun
    let two_pi = std::f64::consts::TAU;
    vec![
        Body::new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0),                                    // Sun
        Body::new(0.387, 0.0, 0.0, 0.0, two_pi/0.241, 0.0, 1.66e-7),                      // Mercury
        Body::new(0.723, 0.0, 0.0, 0.0, two_pi/0.615, 0.0, 2.45e-6),                      // Venus
        Body::new(1.000, 0.0, 0.0, 0.0, two_pi, 0.0, 3.00e-6),                            // Earth
        Body::new(1.524, 0.0, 0.0, 0.0, two_pi/1.881, 0.0, 3.23e-7),                      // Mars
    ]
}

// ═══════════════════════════════════════════════════════════════
// §8  EXTRACTORS (for plotting)
// ═══════════════════════════════════════════════════════════════

/// Extract x positions of body i from snapshots.
pub fn snap_x(snapshots: &[Vec<Body>], i: usize) -> Vec<f64> {
    snapshots.iter().map(|s| s[i].px).collect()
}
pub fn snap_y(snapshots: &[Vec<Body>], i: usize) -> Vec<f64> {
    snapshots.iter().map(|s| s[i].py).collect()
}
pub fn snap_z(snapshots: &[Vec<Body>], i: usize) -> Vec<f64> {
    snapshots.iter().map(|s| s[i].pz).collect()
}

/// Total energy at each snapshot.
pub fn snap_energy(eps: f64, snapshots: &[Vec<Body>]) -> Vec<f64> {
    snapshots.iter().map(|s| total_energy(eps, s)).collect()
}

// ═══════════════════════════════════════════════════════════════
// TESTS
// ═══════════════════════════════════════════════════════════════

#[cfg(test)]
mod tests {
    use super::*;

    #[test] fn octree_children_8() { assert_eq!(OCTREE_CHILDREN, 8); }
    #[test] fn force_exp_2() { assert_eq!(FORCE_EXPONENT, 2); }
    #[test] fn phase_per_body_6() { assert_eq!(PHASE_PER_BODY, 6); }

    #[test] fn two_body_energy_conserved() {
        let bodies = two_body_kepler(1.0, 1.0, 10.0);
        let eps = 0.01;
        let e0 = total_energy(eps, &bodies);
        let final_b = evolve_direct_final(0.01, eps, 500, &bodies);
        let ef = total_energy(eps, &final_b);
        let dev = (ef - e0).abs() / e0.abs();
        assert!(dev < 0.01, "Energy deviation: {}", dev);
    }

    #[test] fn two_body_momentum_conserved() {
        let bodies = two_body_kepler(1.0, 1.0, 10.0);
        let (px0, py0, pz0) = total_momentum(&bodies);
        let final_b = evolve_direct_final(0.01, 0.01, 500, &bodies);
        let (pxf, pyf, pzf) = total_momentum(&final_b);
        let dev = (sq(pxf-px0)+sq(pyf-py0)+sq(pzf-pz0)).sqrt();
        assert!(dev < 0.01, "Momentum deviation: {}", dev);
    }

    #[test] fn inverse_square_scaling() {
        let src = Body::new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0);
        let near = Body::new(1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0);
        let far = Body::new(2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0);
        let (an, _, _) = direct_accel(0.01, &[src.clone(), near.clone()], &near);
        let (af, _, _) = direct_accel(0.01, &[src.clone(), far.clone()], &far);
        let ratio = an.abs() / af.abs();
        assert!((ratio - 4.0).abs() < 0.5, "Force ratio: {} (expect ~4)", ratio);
    }

    #[test] fn plummer_nonzero_force() {
        let bodies = plummer_sphere(10, 100.0, 5.0);
        let (ax, ay, az) = direct_accel(0.01, &bodies, &bodies[0]);
        let a = (sq(ax)+sq(ay)+sq(az)).sqrt();
        assert!(a > 0.0);
    }
}
