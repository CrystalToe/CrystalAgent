# ObservableMixing.hs — Component 7 (Mixing)

## What This Module Is

CKM quark mixing, PMNS neutrino mixing, Weinberg angle, CP violation
phases, Jarlskog invariant. All dimensionless. All from (2,3).

This is the first Observable module (Component 7). It owns 13 observables
across CKM, PMNS, and electroweak mixing.

## Four-Column Architecture

Every observable carries FOUR values:

| Column | What | Purpose |
|--------|------|---------|
| Crystal | formula with crystal VEV (245.17) | Ground truth |
| CrystalPdg | formula with PDG VEV (246.22) | Apples-to-apples |
| PDG | experimental value | Target |
| Gap | \|PDG - CrystalPdg\| / PDG | The REAL residual |

**You cannot compare Crystal to PDG directly.** That includes scheme noise
for dimensionful quantities. For dimensionless quantities (all mixing),
Crystal = CrystalPdg so the gap IS the formula gap.

## Dependency

```
CrystalAtoms.hs        <- Component 2 (root)
    |
ObservableMixing.hs    <- Component 7 (this file)
```

Imports CrystalAtoms only.

## Observables

| Name | Formula | Crystal | PDG | Gap |
|------|---------|---------|-----|-----|
| \|V_us\| | 9/40 | 0.2250 | 0.22500 | 0.00% |
| \|V_cb\| | 81/2000 | 0.04050 | 0.04050 | 0.00% |
| \|V_ub\| | A lambda^3/sqrt(chi) | 0.00374 | 0.00369 | 1.4% |
| J (Jarlskog) | 5/1944 | 0.002572 | 0.00257 | 0.1% |
| delta_CKM | arctan(8/3) | 69.44 deg | 69.2 deg | 0.3% |
| A (Wolf) | 4/5 | 0.800 | 0.826 | 3.1% |
| sin^2 theta_12 | 3/pi^2 | 0.3040 | 0.307 | 1.0% |
| sin^2 theta_23 | 6/11 | 0.5455 | 0.547 | 0.3% |
| sin^2 theta_13 | 11/500 | 0.0220 | 0.0220 | 0.0% |
| delta_PMNS | pi+arctan(1/3) | 198.4 deg | 197.0 deg | 0.7% |
| sin^2 theta_W | 3/13 | 0.2308 | 0.23122 | 0.2% |
| cos(2 delta_PMNS) | 4/5 | 0.800 | 0.800 | 0.0% |
| Adjunction angle | pi+arctan(1/3)-arctan(8/3) | 129.0 deg | 129.0 deg | 0.0% |

## CP Violation as Berry Phase

CP phases are Berry phases on the sector tetrahedron:
- CKM: z = 3 + 8i (Weak->Colour face, 1st quadrant)
- PMNS: z = -3 - i (Singlet->Weak face, 3rd quadrant, +pi adjunction)
- cos(2 delta_PMNS) = 4/5 = A_tree (connects CKM and PMNS)
- Adjunction angle = pi + arctan(1/3) - arctan(8/3) (geometric invariant)

## Compile & Test

```bash
ghc -O2 -main-is ObservableMixing ObservableMixing.hs && ./ObservableMixing
```
