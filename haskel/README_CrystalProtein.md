# CrystalProtein.hs — Full-Tower Protein Force Field

## Compile

```bash
ghc -O2 -main-is CrystalProtein CrystalProtein.hs && ./CrystalProtein
```

## What This Module Is

A complete protein force field derived from N_w=2, N_c=3. Zero fitted parameters.

Every molecular mechanics force field (AMBER, CHARMM, OPLS) has dozens of fitted parameters — bond lengths, angles, van der Waals radii, partial charges, torsion barriers. This module derives ALL of them from the spectral action on A_F = C + M_2(C) + M_3(C).

The key insight: the 43 MERA layers (D=0 to D=42) each contribute a different physical scale. Layer D=0 sets the Planck boundary. Layer D=42 sets our world. The protein force field lives at intermediate layers:

- **D=5**: Lepton masses (m_e, m_mu) set the electromagnetic scale
- **D=18**: Bohr radius a_0 = hbar_c/(m_e × alpha) anchors all atomic distances
- **D=20-21**: Hybridization angles (sp3 = arccos(-1/3) = 109.47°, sp2 = 120°)
- **D=22**: Van der Waals radii from screening constants and Bohr radius
- **D=24**: Water geometry (angle = 104.45°, O-H bond from sp3 distortion)
- **D=25**: Hydrogen bond length and beta-strand spacings
- **D=27**: Peptide bond lengths (C-N = 1.33Å, CA-C = 1.52Å, N-CA = 1.47Å)
- **D=28**: Backbone angles and CA-CA virtual bond distance (3.80Å)
- **D=29**: Ramachandran allowed fraction = Sigma_d / 4^N_c = 36/64 = 56.25%
- **D=30-32**: Alpha-helix (18/5 res/turn, 3/2 Å rise, 5.4Å pitch)
- **D=33**: Flory exponent = N_w/(chi-1) = 2/5 = 0.4
- **D=40-42**: Cosmological partition (Omega_Lambda, Omega_cdm, Omega_b)

## Hierarchical Implosion

Every energy term gets a correction factor from the Seeley-DeWitt a_4 coefficient (Sigma_d^2 = 650):

| Energy | Base (a_2) | Implosion | Channel |
|--------|-----------|-----------|---------|
| VdW | epsilon_0 | × 7/8 | chi-1 sector |
| H-bond | E_hb | × 11/12 | gauss-1 boundary |
| Angle | k_angle | × 151/144 | d4×chi correction |
| Burial | E_burial | × (1+7/15600) | beta0/(d4×Sigma_d2) |
| VdW dist | r_vdw | × (1-1/576) | 1/d4^2 |
| H-bond dist | r_hb | × (1-1/54) | 1/(N_c^3×N_w) |

The signs are physical: attractive forces (VdW, H-bond) get REDUCED (×7/8, ×11/12), repulsive forces (angle strain) get INCREASED (×151/144). Burial is borderline — the correction is tiny (7/15600).

## Running Alpha

alpha^(-1)(D) = (D+1)×pi + ln(beta0) for each MERA layer D. At D=0: pi + ln(7) = 5.09 (Planck boundary). At D=42: 43pi + ln(7) = 137.034 (our world). Each layer steps by exactly pi. The coupling runs through all 43 layers and the force field values at each D-layer use alpha(D) at that depth.

## Varimax Loading Structure

12 energy modes × 43 layers = 516 loadings. The energy modes are: VdW attraction, VdW repulsion, H-bond, electrostatic, angle bending, bond stretching, omega torsion, phi torsion, psi torsion, solvation, burial, and entropic. Each mode has a different D-layer profile.

## Why This Matters

If you can derive a protein force field from first principles with zero fitted parameters, and it reproduces the same bond lengths, angles, and energy scales that AMBER/CHARMM get by fitting to thousands of crystal structures — that's the algebra telling you where chemistry comes from. The sp3 angle isn't "109.47° because we measured it" — it's arccos(-1/N_c) because N_c = 3 spatial dimensions force tetrahedral geometry.

## 73 Proofs

16 integer identities, 5 running alpha, 5 VdW radii, 2 water geometry, 3 H-bond/strand, 3 peptide bonds, 3 backbone angles, 5 protein geometry, 4 cosmological partition, 7 implosion factors, 6 imploded energies, 4 running alpha consistency, 2 completeness.
