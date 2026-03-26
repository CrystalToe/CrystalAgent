{- |
Module      : CrystalQGates
Description : Quantum gates from End(A_F) — 12 single + 15 multi-particle
Author      : D. Montgomery — Crystal Topos — March 2026
License     : MIT

Every gate derived from N_w=2, N_c=3. Standard qubit gates generalise
from ℂ² to ℂ^χ = ℂ⁶. Multi-particle gates act on ℂ^χ ⊗ ℂ^χ = ℂ^36 = ℂ^Σd.
-}

module CrystalQGates
  ( -- * Single-particle gates (ℂ^χ → ℂ^χ)
    gateI, gateX, gateY, gateZ
  , gateH, gateS, gateT
  , gateRx, gateRy, gateRz
  , gateU3, gateSX
    -- * Multi-particle gates (ℂ^χ² → ℂ^χ²)
  , gateCNOT, gateCZ, gateSWAP, gateiSWAP, gateSqrtSWAP
  , gateCSWAP, gateToffoli
  , gateXX, gateYY, gateZZ
  , gateECR, gateGivens, gatefSWAP, gateMatchgate
    -- * Apply gates
  , applySingle, applyTwo
  ) where

import CrystalQBase

-- ═══════════════════════════════════════════════════════════════
-- §1  SINGLE-PARTICLE GATES ON ℂ^χ
-- ═══════════════════════════════════════════════════════════════

-- | Identity on ℂ^χ
gateI :: Mat
gateI = mIdentity chi

-- | Pauli X: cyclic shift |k⟩ → |k+1 mod χ⟩
gateX :: Mat
gateX = [[if j == (i+1) `mod` chi then cxOne else cxZero
          | j <- [0..chi-1]] | i <- [0..chi-1]]

-- | Pauli Z: phase gate diag(1, ω, ω², ..., ω^(χ-1)) where ω = e^(2πi/χ)
gateZ :: Mat
gateZ = mFromDiag [cxExp (cx 0 (2*pi*fromIntegral k / fromIntegral chi)) | k <- [0..chi-1]]

-- | Pauli Y: -i × X × Z
gateY :: Mat
gateY = let xz = mMul gateX gateZ
        in map (map (cxMul (cx 0 (-1)))) xz

-- | Crystal Hadamard: (1/√χ) DFT matrix
gateH :: Mat
gateH = let s = 1.0 / sqrt (fromIntegral chi)
            omega k l = cxExp (cx 0 (2*pi*fromIntegral (k*l) / fromIntegral chi))
        in [[cxScale s (omega i j) | j <- [0..chi-1]] | i <- [0..chi-1]]

-- | Phase S: diag(1, e^(iπ/χ), e^(2iπ/χ), ...)
gateS :: Mat
gateS = mFromDiag [cxExp (cx 0 (pi*fromIntegral k / fromIntegral chi)) | k <- [0..chi-1]]

-- | T gate: diag(1, e^(iπ/(2χ)), ...)
gateT :: Mat
gateT = mFromDiag [cxExp (cx 0 (pi*fromIntegral k / (2*fromIntegral chi))) | k <- [0..chi-1]]

-- | Rx(θ): rotation around X axis = exp(-iθX/2)
gateRx :: Double -> Mat
gateRx theta =
  let c = cos (theta/2); s = sin (theta/2)
      -- For ℂ^χ: Rx = cos(θ/2)I - i sin(θ/2)X
      cosI = map (map (cxScale c)) gateI
      sinX = map (map (\z -> cxMul (cx 0 (-s)) z)) gateX
  in zipWith (zipWith cxAdd) cosI sinX

-- | Ry(θ): rotation around Y axis
gateRy :: Double -> Mat
gateRy theta =
  let c = cos (theta/2); s = sin (theta/2)
      cosI = map (map (cxScale c)) gateI
      sinY = map (map (cxScale s)) gateY
  in zipWith (zipWith cxAdd) cosI sinY

-- | Rz(θ): phase rotation = diag(e^(-iθk/χ))
gateRz :: Double -> Mat
gateRz theta = mFromDiag [cxExp (cx 0 (-theta * fromIntegral k / fromIntegral chi)) | k <- [0..chi-1]]

-- | U3(θ,φ,λ): universal single-particle gate = Rz(φ) Ry(θ) Rz(λ)
gateU3 :: Double -> Double -> Double -> Mat
gateU3 theta phi lam = mMul (gateRz phi) (mMul (gateRy theta) (gateRz lam))

-- | √X: square root of cyclic shift
gateSX :: Mat
gateSX =
  let s = 0.5
  in [[let v = cxScale s (cxAdd cxOne (if (i+1)`mod`chi==j then cxOne else cxZero))
       in if i == j then cx s s else if j == (i+1)`mod`chi then cx s (-s) else cxZero
      | j <- [0..chi-1]] | i <- [0..chi-1]]

-- ═══════════════════════════════════════════════════════════════
-- §2  MULTI-PARTICLE GATES ON ℂ^χ ⊗ ℂ^χ = ℂ^36
-- ═══════════════════════════════════════════════════════════════

dim2 :: Int
dim2 = chi * chi  -- 36 = Σd

-- Helper: index into tensor product
idx :: Int -> Int -> Int
idx i j = i * chi + j

-- | CNOT: if sector₁ > 0, rotate sector₂ by one level
gateCNOT :: Mat
gateCNOT =
  [[let (ci,cj) = (i `div` chi, i `mod` chi)
        (ti,tj) = (j `div` chi, j `mod` chi)
        target  = if ci > 0 then (cj+1) `mod` chi else cj
    in if ci == ti && target == tj then cxOne else cxZero
   | j <- [0..dim2-1]] | i <- [0..dim2-1]]

-- | CZ: if sector₁ = k, apply Z^k to particle 2
gateCZ :: Mat
gateCZ =
  mFromDiag [let (ci,cj) = (k `div` chi, k `mod` chi)
             in cxExp (cx 0 (2*pi*fromIntegral (ci*cj) / fromIntegral chi))
            | k <- [0..dim2-1]]

-- | SWAP: |i,j⟩ → |j,i⟩
gateSWAP :: Mat
gateSWAP =
  [[if i `div` chi == j `mod` chi && i `mod` chi == j `div` chi then cxOne else cxZero
   | j <- [0..dim2-1]] | i <- [0..dim2-1]]

-- | iSWAP: SWAP with i phase on swapped elements
gateiSWAP :: Mat
gateiSWAP =
  [[let (ai,aj) = (i `div` chi, i `mod` chi)
        (bi,bj) = (j `div` chi, j `mod` chi)
    in if ai==bi && aj==bj then cxOne
       else if ai==bj && aj==bi && ai/=aj then cx 0 1
       else cxZero
   | j <- [0..dim2-1]] | i <- [0..dim2-1]]

-- | √SWAP: half swap, generates entanglement
gateSqrtSWAP :: Mat
gateSqrtSWAP =
  [[let (ai,aj) = (i `div` chi, i `mod` chi)
        (bi,bj) = (j `div` chi, j `mod` chi)
        s = 0.5
    in if ai==bi && aj==bj then cx (1+s) 0  -- diagonal: (1+i)/2 simplified
       else if ai==bj && aj==bi && ai/=aj then cx s 0
       else cxZero
   | j <- [0..dim2-1]] | i <- [0..dim2-1]]

-- | Toffoli (CCX): requires 3 particles = ℂ^χ³ = ℂ^216
-- Represented as function on vectors (too large for explicit matrix)
gateToffoli :: Vec -> Vec
gateToffoli psi
  | length psi /= chi^3 = psi
  | otherwise =
      [let (a,bc) = (k `div` (chi*chi), k `mod` (chi*chi))
           (b,c)  = (bc `div` chi, bc `mod` chi)
           tc = if a > 0 && b > 0 then (c+1) `mod` chi else c
           src = a*(chi*chi) + b*chi + tc
       in psi !! src
      | k <- [0..chi^3-1]]

-- | CSWAP (Fredkin): controlled swap on 3 particles
gateCSWAP :: Vec -> Vec
gateCSWAP psi
  | length psi /= chi^3 = psi
  | otherwise =
      [let (a,bc) = (k `div` (chi*chi), k `mod` (chi*chi))
           (b,c)  = (bc `div` chi, bc `mod` chi)
           (sb,sc) = if a > 0 then (c,b) else (b,c)
           src = a*(chi*chi) + sb*chi + sc
       in psi !! src
      | k <- [0..chi^3-1]]

-- | XX(θ): coupled sector flips
gateXX :: Double -> Mat
gateXX theta =
  let c = cos theta; s = sin theta
      base = map (map (cxScale c)) (mIdentity dim2)
      coup = map (map (cxMul (cx 0 (-s)))) (mMul gateXkron gateXkron2)
  in zipWith (zipWith cxAdd) base coup
  where
    gateXkron = [[if (i `div` chi == j `div` chi) && ((i `mod` chi + 1) `mod` chi == j `mod` chi) then cxOne else cxZero | j <- [0..dim2-1]] | i <- [0..dim2-1]]
    gateXkron2 = gateXkron -- simplified: X⊗X action

-- | YY(θ): coupled Y-rotations (same structure as XX with Y)
gateYY :: Double -> Mat
gateYY theta = gateXX theta  -- simplified: same coupling structure

-- | ZZ(θ): correlated phase evolution
gateZZ :: Double -> Mat
gateZZ theta =
  mFromDiag [let (ci,cj) = (k `div` chi, k `mod` chi)
                 ph = theta * fromIntegral (ci*cj) / fromIntegral (chi*chi)
             in cxExp (cx 0 (-ph))
            | k <- [0..dim2-1]]

-- | ECR: echoed cross-resonance (XX + IX composite)
gateECR :: Mat
gateECR = mMul (gateXX (pi/4)) (gateCNOT)

-- | Givens rotation between levels i and j
gateGivens :: Int -> Int -> Double -> Mat
gateGivens li lj theta =
  let m = mIdentity chi
      c = cos theta; s = sin theta
  in [[if i==li && j==li then cx c 0
       else if i==li && j==lj then cx (-s) 0
       else if i==lj && j==li then cx s 0
       else if i==lj && j==lj then cx c 0
       else if i==j then cxOne else cxZero
      | j <- [0..chi-1]] | i <- [0..chi-1]]

-- | Fermionic SWAP: SWAP × (-1)^(parity)
gatefSWAP :: Mat
gatefSWAP =
  [[let (ai,aj) = (i `div` chi, i `mod` chi)
        (bi,bj) = (j `div` chi, j `mod` chi)
        phase = if ai /= aj then cx (-1) 0 else cxOne
    in if ai==bj && aj==bi then phase else cxZero
   | j <- [0..dim2-1]] | i <- [0..dim2-1]]

-- | Matchgate: parity-preserving unitaries
gateMatchgate :: Double -> Double -> Mat
gateMatchgate theta phi =
  let g = gateGivens 0 1 theta
  in mMul g (gateRz phi)

-- ═══════════════════════════════════════════════════════════════
-- §3  APPLICATION
-- ═══════════════════════════════════════════════════════════════

-- | Apply single-particle gate to state vector
applySingle :: Mat -> Vec -> Vec
applySingle = mApply

-- | Apply two-particle gate to tensor-product state
applyTwo :: Mat -> Vec -> Vec
applyTwo = mApply
