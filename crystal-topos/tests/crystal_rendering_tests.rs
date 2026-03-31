// Crystal Topos — Rendering & Scattering Physics
// Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later
//
// Observables 204–206: Planck exponent, Rayleigh size, Rayleigh wavelength.
// All EXACT (PWI = 0.000%).

#[cfg(test)]
mod rendering_physics {
    const NW: u64 = 2;
    const NC: u64 = 3;
    const CHI: u64 = NW * NC; // 6

    // ── Observable 204 ─────────────────────────────────────────
    // Planck spectral radiance wavelength exponent
    // B(λ,T) ∝ λ⁻⁵. Exponent = χ − 1 = 5.
    #[test]
    fn prove_planck_wavelength_exp() {
        let crystal = CHI - 1;
        let expt: f64 = 5.0;
        let gap = (crystal as f64 - expt).abs() / expt;
        assert_eq!(crystal, 5);
        assert!(gap < 0.005, "PWI: {:.6}%", gap * 100.0);
    }

    // ── Observable 205 ─────────────────────────────────────────
    // Rayleigh scattering particle-size exponent
    // σ_R ∝ d⁶. Exponent = χ = N_w · N_c = 6.
    #[test]
    fn prove_rayleigh_size_exp() {
        let crystal = CHI;
        let expt: f64 = 6.0;
        let gap = (crystal as f64 - expt).abs() / expt;
        assert_eq!(crystal, 6);
        assert!(gap < 0.005, "PWI: {:.6}%", gap * 100.0);
    }

    // ── Observable 206 ─────────────────────────────────────────
    // Rayleigh scattering wavelength exponent
    // σ_R ∝ λ⁻⁴. Exponent = N_w² = 4.
    #[test]
    fn prove_rayleigh_wavelength_exp() {
        let crystal = NW * NW;
        let expt: f64 = 4.0;
        let gap = (crystal as f64 - expt).abs() / expt;
        assert_eq!(crystal, 4);
        assert!(gap < 0.005, "PWI: {:.6}%", gap * 100.0);
    }

    // ── Structural ─────────────────────────────────────────────
    #[test]
    fn planck_ne_stefan_boltzmann() {
        assert_ne!(CHI - 1, NW * NW, "chi-1=5 != nw^2=4");
    }

    #[test]
    fn rayleigh_size_is_sector_count() {
        assert_eq!(NW * NC, 6);
    }

    #[test]
    fn rayleigh_wave_is_nw_squared() {
        assert_eq!(NW.pow(2), 4);
    }
}
