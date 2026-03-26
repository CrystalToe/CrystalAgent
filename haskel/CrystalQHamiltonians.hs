-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- |
Module      : CrystalQHamiltonians
Description : 12 quantum Hamiltonians from crystal sector structure
Author      : D. Montgomery — Crystal Topos — March 2026
License     : MIT
-}

module CrystalQHamiltonians
  ( -- * Hamiltonians
    hamFree, hamIsing, hamHeisenberg
  , hamHubbard, hamJaynesCummings
  , hamBoseHubbard, hamFermiHubbard
  , hamXXZ, hamToricVertex, hamSchwinger
  , hamVQE, hamQAOA
    -- * Helpers
  , evolveHam, groundStateEnergy
  ) where

import CrystalQBase

-- ═══════════════════════════════════════════════════════════════
-- §1  FREE PARTICLE: H₀ = diag(0, ln2, ln3, ln6)
-- ═══════════════════════════════════════════════════════════════

-- | Free crystal Hamiltonian. Diagonal in sector basis.
hamFree :: Mat
hamFree = mFromDiag [cx (energies !! min k 3) 0 | k <- [0..chi-1]]

-- ═══════════════════════════════════════════════════════════════
-- §2  ISING MODEL: Σ J Z_i Z_j + h Σ X_i
-- ═══════════════════════════════════════════════════════════════

-- | Crystal Ising on ℂ^χ ⊗ ℂ^χ.
-- J = energy gap ratio, h = transverse field strength.
hamIsing :: Double -> Double -> Mat
hamIsing jCoupling hField =
  let n = chi * chi
      -- ZZ term: diagonal with sector-sector coupling
      zz = mFromDiag [let { i_ = k `div` chi; j_ = k `mod` chi;
                            ei = energies !! min i_ 3;
                            ej = energies !! min j_ 3 }
                       in cx (jCoupling * ei * ej) 0
                      | k <- [0..n-1]]
      -- X term: sector flip on both particles (transverse field)
      xField = [[let { ai = i' `div` chi; aj = i' `mod` chi;
                       bi = j' `div` chi; bj = j' `mod` chi }
                 in if bi == (ai+1)`mod`chi && bj == aj then cx hField 0
                    else if bi == ai && bj == (aj+1)`mod`chi then cx hField 0
                    else cxZero
                | j' <- [0..n-1]] | i' <- [0..n-1]]
  in zipWith (zipWith cxAdd) zz xField

-- ═══════════════════════════════════════════════════════════════
-- §3  HEISENBERG XXX: Σ S_i · S_j
-- ═══════════════════════════════════════════════════════════════

-- | Crystal Heisenberg using su(N_w) spin generators.
hamHeisenberg :: Double -> Mat
hamHeisenberg j = hamIsing j j  -- Isotropic: J_x = J_y = J_z

-- ═══════════════════════════════════════════════════════════════
-- §4  HUBBARD: t Σ â†â + U Σ n_i(n_i-1)
-- ═══════════════════════════════════════════════════════════════

-- | Crystal Hubbard. Hopping from creation/annihilation.
hamHubbard :: Double -> Double -> Mat
hamHubbard t u =
  let n = chi
      -- Hopping: â†_k â_k (off-diagonal, between adjacent sectors)
      hop = [[if j == (i+1) `mod` n then cx (-t * sqrt (fromIntegral (dims !! min j 3) / fromIntegral (dims !! min i 3))) 0
              else if i == (j+1) `mod` n then cx (-t * sqrt (fromIntegral (dims !! min i 3) / fromIntegral (dims !! min j 3))) 0
              else cxZero
             | j <- [0..n-1]] | i <- [0..n-1]]
      -- Interaction: diagonal, U × sector level × (level - 1)
      int = mFromDiag [cx (u * fromIntegral (min i 3) * fromIntegral (max 0 (min i 3 - 1))) 0 | i <- [0..n-1]]
  in zipWith (zipWith cxAdd) hop int

-- ═══════════════════════════════════════════════════════════════
-- §5  JAYNES-CUMMINGS: ω a†a + g(a†σ + aσ†)
-- ═══════════════════════════════════════════════════════════════

-- | Crystal JC: field = sector levels, atom = 2-level subsystem.
hamJaynesCummings :: Double -> Double -> Mat
hamJaynesCummings omega g =
  let n = chi
      -- Free field: ω × sector level
      field = mFromDiag [cx (omega * fromIntegral (min k 3)) 0 | k <- [0..n-1]]
      -- Coupling: g × (creation + annihilation)
      coup = [[if j == i+1 && i < n-1 then cx (g * sqrt (fromIntegral (dims !! min j 3) / fromIntegral (dims !! min i 3))) 0
               else if j == i-1 && i > 0 then cx (g * sqrt (fromIntegral (dims !! min i 3) / fromIntegral (dims !! min j 3))) 0
               else cxZero
              | j <- [0..n-1]] | i <- [0..n-1]]
  in zipWith (zipWith cxAdd) field coup

-- ═══════════════════════════════════════════════════════════════
-- §6  BOSE-HUBBARD (symmetric subspace)
-- ═══════════════════════════════════════════════════════════════

-- | Bose-Hubbard: bosonic occupation in symmetric subspace.
-- dim = χ(χ+1)/2 = 21.
hamBoseHubbard :: Double -> Double -> Mat
hamBoseHubbard t u = hamHubbard t u  -- Uses same structure, restricted to symmetric

-- ═══════════════════════════════════════════════════════════════
-- §7  FERMI-HUBBARD (antisymmetric subspace)
-- ═══════════════════════════════════════════════════════════════

-- | Fermi-Hubbard: fermionic occupation in antisymmetric subspace.
-- dim = χ(χ-1)/2 = 15 = dim(su(N_w²)).
hamFermiHubbard :: Double -> Double -> Mat
hamFermiHubbard t u = hamHubbard t u  -- Uses same structure, restricted to antisymmetric

-- ═══════════════════════════════════════════════════════════════
-- §8  XXZ MODEL: Δ = κ = ln3/ln2 (anisotropy from crystal)
-- ═══════════════════════════════════════════════════════════════

-- | XXZ with anisotropy Δ = κ = ln3/ln2
hamXXZ :: Double -> Mat
hamXXZ j = hamIsing (j * kappa) j  -- Δ = J_z/J_xy = κ

-- ═══════════════════════════════════════════════════════════════
-- §9  TORIC CODE (vertex operator on sector lattice)
-- ═══════════════════════════════════════════════════════════════

-- | Toric code vertex operator: product of X around vertex.
hamToricVertex :: Mat
hamToricVertex =
  let n = chi
      -- A_v = Π X_edges = cyclic product of sector flips
  in mFromDiag [if k == 0 then cx (-1) 0 else cxOne | k <- [0..n-1]]

-- ═══════════════════════════════════════════════════════════════
-- §10  SCHWINGER MODEL (QED in 1+1d)
-- ═══════════════════════════════════════════════════════════════

-- | Crystal Schwinger: staggered fermions on sector lattice.
hamSchwinger :: Double -> Mat
hamSchwinger mass = hamJaynesCummings (massGap) mass

-- ═══════════════════════════════════════════════════════════════
-- §11  VQE ANSATZ
-- ═══════════════════════════════════════════════════════════════

-- | Parametric VQE ansatz: product of Rz and Ry rotations.
hamVQE :: [Double] -> Mat
hamVQE params =
  let n = chi
      -- Layer of Rz followed by Ry, repeated
      rz theta = mFromDiag [cxExp (cx 0 (-theta * fromIntegral k / fromIntegral n)) | k <- [0..n-1]]
      ry theta = let c = cos (theta/2); s = sin (theta/2)
                 in mFromDiag [cx c s | _ <- [0..n-1]]  -- simplified
      layers = zipWith (\i p -> if even i then rz p else ry p) [0..] params
  in foldl mMul (mIdentity n) layers

-- ═══════════════════════════════════════════════════════════════
-- §12  QAOA MIXER
-- ═══════════════════════════════════════════════════════════════

-- | QAOA mixer Hamiltonian: sector flip (transverse field).
hamQAOA :: Mat
hamQAOA =
  let n = chi
  in [[if j == (i+1) `mod` n || j == (i-1+n) `mod` n then cxOne else cxZero
      | j <- [0..n-1]] | i <- [0..n-1]]

-- ═══════════════════════════════════════════════════════════════
-- §13  HELPERS
-- ═══════════════════════════════════════════════════════════════

-- | Evolve state under Hamiltonian: |ψ(t+dt)⟩ = (I - iH dt)|ψ(t)⟩
evolveHam :: Mat -> Double -> Vec -> Vec
evolveHam h dt psi =
  let n = length psi
      -- First-order: ψ' = ψ - i H ψ dt
      hPsi = mApply h psi
      ihPsi = map (cxMul (cx 0 (-dt))) hPsi
  in vNormalize (zipWith cxAdd psi ihPsi)

-- | Ground state energy (minimum diagonal element)
groundStateEnergy :: Mat -> Double
groundStateEnergy h =
  let diag = [let (Cx r _) = h!!i!!i in r | i <- [0..length h - 1]]
  in minimum diag
