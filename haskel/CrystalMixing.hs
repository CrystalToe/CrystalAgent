-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalMixing — CKM + PMNS mixing matrices -}
module CrystalMixing
  ( proveVus, proveWolfA, proveWolfA_Z, proveVcb
  , proveDeltaCKM, proveVub, proveJarlskog
  , proveSinSq12, proveSinSq23, proveSinSq13, proveDeltaPMNS
    -- Berry phase / adjunction
  , cpVectorCKM, cpVectorPMNS
  , proveAdjunctionAngle, proveCos2PMNS, berryPhaseCheck
  ) where
import CrystalAxiom
import Data.Ratio ((%))

proveVus :: Crystal Two Three -> Derived
proveVus c =
  let exact = crFromInts c (nC^2) (sigmaD + nW^2)
  in Derived "|V_us|" "N_c²/(Σd+N_w²) = 9/40"
     (crDbl exact) (Just (crVal exact)) (pdg 0.22500) Exact

proveWolfA :: Crystal Two Three -> Derived
proveWolfA c =
  let exact = crFromInts c (nW^2) (nC + nW)
  in Derived "A" "N_w²/(N_c+N_w) = 4/5"
     (crDbl exact) (Just (crVal exact)) (pdg 0.826) Computed

proveWolfA_Z :: Crystal Two Three -> Derived
proveWolfA_Z c =
  let a = crVal (crFromInts c (nW^2) (nC + nW))
      z = sigmaD % (sigmaD - 1)
      exact = a * z
  in Derived "A†" "A×Z = 144/175"
     (fromRational exact) (Just exact) (pdg 0.826) Computed

proveVcb :: Crystal Two Three -> Derived
proveVcb c =
  let vus = crVal (crFromInts c (nC^2) (sigmaD + nW^2))
      a   = crVal (crFromInts c (nW^2) (nC + nW))
      exact = a * vus^(2::Int)
  in Derived "|V_cb|" "A×λ² = 81/2000"
     (fromRational exact) (Just exact) (pdg 0.04050) Exact

-- ═══════════════════════════════════════════════════════════════════
-- CP VIOLATION = BERRY PHASE (Adjunction Phase Theorem)
--
-- CP phases are Berry phases acquired by transporting states around
-- the object tetrahedron of the topos.
--
-- THE TETRAHEDRON:
--   The 4 sectors {Singlet, Weak, Colour, Mixed} form a tetrahedron.
--   Each edge carries a CG coefficient (natural transformation).
--   Each FACE defines a complex plane with coordinates (d_real, d_imag).
--   The CP phase = arg(z) of the complex vector on that face.
--
-- CKM (QUARKS): path through the Weak→Colour face.
--   z_CKM = d_weak + i × d_colour = 3 + 8i.
--   Real axis (CP-conserving): d_weak = 3 (weak adjoint degeneracy).
--   Imaginary axis (CP-violating): d_colour = 8 (colour adjoint).
--   Quarks mix TOWARD colour (ascending dimension): 1st quadrant.
--   δ_CKM = arctan(8/3) = 69.44°.
--   73 Weak+Colour endomorphisms (9 + 64) constrain this face.
--
-- PMNS (LEPTONS): DUAL path through the Singlet→Weak face.
--   z_PMNS = −(d_weak + i × d_singlet) = −3 − i.
--   Same d_weak = 3 reference. d_singlet = 1 (trivial rep).
--   Leptons mix TOWARD singlet (descending dimension): 3rd quadrant.
--   δ_PMNS = π + arctan(1/3) = 198.43°.
--   10 Singlet+Weak endomorphisms (1 + 9) constrain this face.
--
-- THE π ROTATION = ADJUNCTION REVERSAL:
--   CKM and PMNS are DUAL. The duality IS the Heyting negation ¬.
--   The adjunction F ⊣ G means F∘G = Id. Reversing the adjunction
--   flips the path on the tetrahedron, which adds π to the phase.
--   This is a GEOMETRIC (Berry) phase, not a dynamical phase.
--   Berry (1984) Proc. R. Soc. A 392, 45. Same mechanism as:
--     - Aharonov-Bohm (EM), - molecular Berry phase (chemistry),
--     - π phase in optical reflection, - capacitive vs inductive (AC).
--
-- STRUCTURAL CONNECTIONS:
--   cos(2δ_PMNS) = cos(2(π + arctan(1/3))) = cos(2·arctan(1/3))
--     = (1 − (1/3)²)/(1 + (1/3)²) = (8/9)/(10/9) = 4/5 = A_tree.
--   The Wolfenstein parameter A = 4/5 appears in BOTH CKM and PMNS.
--   The CKM modulus IS the PMNS double-angle cosine.
--
--   δ_PMNS − δ_CKM = (π + arctan(1/3)) − arctan(8/3)
--     = π + arctan(1/3) − arctan(8/3) ≈ 129°.
--   This is the adjunction angle. Not a free parameter.
--
-- WHAT'S NEW: CP violation is usually a free parameter in the SM.
-- Here it's a geometric invariant of the topos — the Berry phase
-- on the sector tetrahedron. The PHASE is the GEOMETRY.
-- ═══════════════════════════════════════════════════════════════════

-- | CKM CP phase: δ_CKM = arctan(d_colour/d_weak) = arctan(8/3).
--   Berry phase on the Weak→Colour face of the sector tetrahedron.
--   z_CKM = 3 + 8i. 73 Weak+Colour endomorphisms constrain.
proveDeltaCKM :: Crystal Two Three -> Derived
proveDeltaCKM c =
  let arg = crFromInts c (degeneracy MkColour) (degeneracy MkWeak)  -- 8/3
      val = atan (crDbl arg) * 180 / pi
  in Derived "δ_CKM (deg)" "arctan(d_col/d_w) = arctan(8/3)"
     val (Just (crVal arg)) (pdg 69.2) Computed

proveVub :: Crystal Two Three -> Derived
proveVub c =
  let vus  = dCrystal (proveVus c)
      a    = dCrystal (proveWolfA c)
      chiR = crFromInts c chi 1
      val  = a * vus ^ (3::Int) / sqrt (crDbl chiR)
  in Derived "|V_ub|" "Aλ³/√χ" val Nothing (pdg 0.00369) Computed

proveJarlskog :: Crystal Two Three -> Derived
proveJarlskog c =
  let exact = crFromInts c (nW + nC) (nW^3 * nC^5)
  in Derived "J" "(N_w+N_c)/(N_w³N_c⁵) = 5/1944"
     (crDbl exact) (Just (crVal exact)) (pdg 2.57e-3) Computed

proveSinSq12 :: Crystal Two Three -> Derived
proveSinSq12 c =
  let b   = crystalBasis c
      num = crFromInts c nC 1
      val = crDbl num / (basisPi b)^(2::Int)
  in Derived "sin²θ₁₂" "N_c/π² = 3/π²"
     val (Just (crVal num)) (nufit 0.307) Computed

proveSinSq23 :: Crystal Two Three -> Derived
proveSinSq23 c =
  let exact = crFromInts c chi (2 * chi - 1)
  in Derived "sin²θ₂₃" "χ/(2χ-1) = 6/11"
     (crDbl exact) (Just (crVal exact)) (nufit 0.547) Computed

proveSinSq13 :: Crystal Two Three -> Derived
proveSinSq13 c =
  let dw    = nW^2 - 1
      exact = crFromInts c 1 (towerD + dw)
  in Derived "sin²θ₁₃" "1/(D+d_w) = 1/45"
     (crDbl exact) (Just (crVal exact)) (nufit 0.0220) Computed

-- | PMNS CP phase: δ_PMNS = π + arctan(d_singlet/d_weak) = π + arctan(1/3).
--   Berry phase on the Singlet→Weak face. DUAL to CKM.
--   z_PMNS = −3 − i. The π = adjunction reversal (Heyting ¬).
--   Leptons mix toward singlet (descending dim) → 3rd quadrant → +π.
--   10 Singlet+Weak endomorphisms constrain.
proveDeltaPMNS :: Crystal Two Three -> Derived
proveDeltaPMNS c =
  let arg = crFromInts c (degeneracy MkSinglet) (degeneracy MkWeak)  -- 1/3
      val = (pi + atan (crDbl arg)) * 180 / pi
  in Derived "δ_PMNS (deg)" "π+arctan(d_s/d_w) = π+arctan(1/3)"
     val (Just (crVal arg)) (nufit 197.0) Computed

-- ═══════════════════════════════════════════════════════════════════
-- BERRY PHASE VERIFICATION FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

-- | The complex vectors on the tetrahedron faces.
--   CKM: z = d_weak + i·d_colour = 3 + 8i (1st quadrant, toward colour)
--   PMNS: z = −d_weak − i·d_singlet = −3 − i (3rd quadrant, toward singlet)
--   The sign flip IS the adjunction F ⊣ G → G ⊣ F.
cpVectorCKM :: (Integer, Integer)
cpVectorCKM = (degeneracy MkWeak, degeneracy MkColour)   -- (3, 8)

cpVectorPMNS :: (Integer, Integer)
cpVectorPMNS = (-(degeneracy MkWeak), -(degeneracy MkSinglet))  -- (-3, -1)

-- | Adjunction phase theorem: δ_PMNS − δ_CKM ≈ 129° (exact transcendental).
--   The difference = π + arctan(1/3) − arctan(8/3).
--   This is NOT a free parameter. It's the geometry of the tetrahedron.
proveAdjunctionAngle :: Crystal Two Three -> Double
proveAdjunctionAngle _ =
  let dCKM  = atan (8/3)                -- arctan(d_colour/d_weak)
      dPMNS = pi + atan (1/3)           -- π + arctan(d_singlet/d_weak)
  in (dPMNS - dCKM) * 180 / pi          -- ≈ 129.0°

-- | cos(2δ_PMNS) = A_tree = 4/5.
--   The Wolfenstein parameter appears in the PMNS double-angle cosine.
--   cos(2(π + arctan(1/3))) = cos(2·arctan(1/3))
--     = (1 − (1/3)²)/(1 + (1/3)²)
--     = (1 − 1/9)/(1 + 1/9)
--     = (8/9)/(10/9) = 8/10 = 4/5.
--   EXACT RATIONAL. The CKM modulus IS the PMNS double-angle cosine.
--   This connects CKM and PMNS through the tetrahedron geometry.
proveCos2PMNS :: Crystal Two Three -> CrystalRat
proveCos2PMNS c =
  let -- cos(2·arctan(x)) = (1 − x²)/(1 + x²) for x = d_singlet/d_weak = 1/3
      x_num = degeneracy MkSinglet                      -- 1
      x_den = degeneracy MkWeak                          -- 3
      -- Numerator: x_den² − x_num² = 9 − 1 = 8
      num   = x_den^2 - x_num^2                          -- 8
      -- Denominator: x_den² + x_num² = 9 + 1 = 10
      den   = x_den^2 + x_num^2                          -- 10
  in crFromInts c num den                                 -- 8/10 = 4/5 = A_tree

-- | Berry phase verification: exact rational checks.
--   All verified in Rational arithmetic. No floating point needed.
berryPhaseCheck :: Crystal Two Three -> (Rational, Rational, Bool)
berryPhaseCheck c =
  let -- cos(2δ_PMNS) should equal A_tree = N_w²/(N_c+N_w) = 4/5
      cos2pmns = crVal (proveCos2PMNS c)                 -- 4/5
      a_tree   = nW^2 % (nC + nW)                        -- 4/5
      match    = cos2pmns == a_tree                       -- True
  in (cos2pmns, a_tree, match)
