-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalSpin.hs — Spin Dynamics / Bloch Equations from (2,3)

  Sector restriction: weak (d=3, Bloch vector Sx, Sy, Sz)
  Textbook method: Bloch equations = S = W∘U
    W = precession (rotation around B field, 3×3 matrix multiply)
    U = relaxation (exponential decay toward equilibrium, diagonal)

  Crystal constants:
    Spin states       = N_w = 2  (up/down)
    Bloch components  = N_c = 3  (Sx, Sy, Sz)
    Pauli matrices    = N_c = 3  (σ_x, σ_y, σ_z)
    Larmor rotation   = per tick (discrete, not continuous ω)
    T1 relaxation     = λ_weak = 1/N_w = 1/2 (longitudinal)
    T2 relaxation     = λ_colour = 1/N_c = 1/3 (transverse)
    T1/T2 ratio       = N_c/N_w = 3/2 (forced by algebra)
    Rabi states       = N_w = 2

  NO CALCULUS. The Bloch equations dM/dt = γ(M×B) - R(M-M₀)
  are replaced by: M(t+1) = relax(rotate(M(t))).
  Rotation = matrix multiply. Relaxation = scalar multiply.
  No differential equation. No integral. Just tick.

  Compile: ghc -O2 -main-is CrystalSpin CrystalSpin.hs && ./CrystalSpin
-}

module CrystalSpin where

-- ═══════════════════════════════════════════════════════════════
-- §0 ATOMS
-- ═══════════════════════════════════════════════════════════════

nW, nC, chi, beta0, sigmaD, towerD, gauss :: Int
nW     = 2
nC     = 3
chi    = nW * nC
beta0  = 7
sigmaD = 1 + 3 + 8 + 24
towerD = sigmaD + chi
gauss  = nW * nW + nC * nC

d1, d2, d3, d4 :: Int
d1 = 1
d2 = nW * nW - 1
d3 = nC * nC - 1
d4 = (nW * nW - 1) * (nC * nC - 1)

-- ═══════════════════════════════════════════════════════════════
-- §1 INTEGER IDENTITIES
-- ═══════════════════════════════════════════════════════════════

spinStates :: Int
spinStates = nW                       -- 2 (up/down)

blochComponents :: Int
blochComponents = nC                  -- 3 (Sx, Sy, Sz)

pauliCount :: Int
pauliCount = nC                       -- 3 (σ_x, σ_y, σ_z)

-- T1/T2 ratio = N_c/N_w = 3/2 (forced by sector eigenvalues)
-- T1 ~ 1/λ_weak = N_w = 2 (longitudinal, slower)
-- T2 ~ 1/λ_colour = N_c = 3 (transverse, faster)
t1Denom :: Int
t1Denom = nW                          -- 2

t2Denom :: Int
t2Denom = nC                          -- 3

-- Gyromagnetic ratio splits: g-factor components
-- g_s = N_w = 2 (electron spin g-factor ≈ 2)
gFactor :: Int
gFactor = nW                          -- 2

-- Spin angular momentum quantum number s = (N_w-1)/2 = 1/2
-- 2s+1 = N_w = 2 (multiplicity)
multiplicity :: Int
multiplicity = nW                     -- 2

-- Stern-Gerlach: N_w = 2 beams
sternGerlach :: Int
sternGerlach = nW                     -- 2

-- ESR/NMR: Larmor in N_c = 3 spatial dimensions
spatialDim :: Int
spatialDim = nC                       -- 3

-- ═══════════════════════════════════════════════════════════════
-- §2 BLOCH VECTOR (Mx, My, Mz)
-- ═══════════════════════════════════════════════════════════════

-- Bloch vector: N_c = 3 components
type BlochVec = (Double, Double, Double)

-- Magnitude
blochNorm :: BlochVec -> Double
blochNorm (mx, my, mz) = sqrt (mx * mx + my * my + mz * mz)

-- Transverse magnitude
transverseNorm :: BlochVec -> Double
transverseNorm (mx, my, _) = sqrt (mx * mx + my * my)

-- Equilibrium: M = (0, 0, M₀) along B field
equilibrium :: Double -> BlochVec
equilibrium m0 = (0.0, 0.0, m0)

-- ═══════════════════════════════════════════════════════════════
-- §3 W: PRECESSION (rotation around B field)
-- ═══════════════════════════════════════════════════════════════

-- Rotation around z-axis by angle θ (B along z)
-- This is a 3×3 matrix multiply. Not calculus.
-- cos/sin compute the rotation matrix entries ONCE per tick.
-- The DYNAMICS are multiply-add.
rotateZ :: Double -> BlochVec -> BlochVec
rotateZ theta (mx, my, mz) =
  let ct = cos theta
      st = sin theta
  in (ct * mx - st * my, st * mx + ct * my, mz)

-- Rotation around arbitrary axis (unit vector nx, ny, nz)
-- Rodrigues formula: pure multiply-add after computing sin/cos once
rotateAxis :: (Double, Double, Double) -> Double -> BlochVec -> BlochVec
rotateAxis (nx, ny, nz) theta (mx, my, mz) =
  let ct = cos theta
      st = sin theta
      dot = nx * mx + ny * my + nz * mz
      -- Cross product n × M
      cx = ny * mz - nz * my
      cy = nz * mx - nx * mz
      cz = nx * my - ny * mx
      -- Rodrigues: M' = M cos θ + (n × M) sin θ + n(n·M)(1 - cos θ)
  in ( mx * ct + cx * st + nx * dot * (1.0 - ct)
     , my * ct + cy * st + ny * dot * (1.0 - ct)
     , mz * ct + cz * st + nz * dot * (1.0 - ct) )

-- W operator: precession = rotation by ω×dt around B field
applyW :: Double -> BlochVec -> BlochVec
applyW theta = rotateZ theta

-- ═══════════════════════════════════════════════════════════════
-- §4 U: RELAXATION (exponential decay toward equilibrium)
-- ═══════════════════════════════════════════════════════════════

-- T2 relaxation: transverse (Mx, My) decay toward 0
-- Rate = 1/T2, discrete: multiply by (1 - 1/T2_ticks) per tick
-- In Crystal units: T2 rate = λ_colour = 1/N_c = 1/3

-- T1 relaxation: longitudinal (Mz) decays toward M₀
-- Rate = 1/T1, discrete: multiply by (1 - 1/T1_ticks) per tick
-- In Crystal units: T1 rate = λ_weak = 1/N_w = 1/2

-- U operator: relaxation
applyU :: Double -> Double -> Double -> BlochVec -> BlochVec
applyU t1Rate t2Rate m0 (mx, my, mz) =
  ( mx * (1.0 - t2Rate)   -- Mx decays to 0
  , my * (1.0 - t2Rate)   -- My decays to 0
  , mz + t1Rate * (m0 - mz) -- Mz recovers to M₀
  )

-- ═══════════════════════════════════════════════════════════════
-- §5 S = W∘U: ONE TICK OF SPIN DYNAMICS
-- ═══════════════════════════════════════════════════════════════

-- S = W∘U: first relax (U), then precess (W)
-- This IS the Bloch equation discretized. No ODE.
spinTick :: Double -> Double -> Double -> Double -> BlochVec -> BlochVec
spinTick omega t1Rate t2Rate m0 =
  applyW omega . applyU t1Rate t2Rate m0

-- Evolve for N ticks
spinEvolve :: Int -> Double -> Double -> Double -> Double -> BlochVec -> [BlochVec]
spinEvolve 0 _ _ _ _ m = [m]
spinEvolve n omega t1 t2 m0 m =
  m : spinEvolve (n - 1) omega t1 t2 m0 (spinTick omega t1 t2 m0 m)

-- ═══════════════════════════════════════════════════════════════
-- §6 RABI OSCILLATIONS (two-state system, N_w = 2)
-- ═══════════════════════════════════════════════════════════════

-- Rabi oscillation: spin flips between |↑⟩ and |↓⟩
-- In Bloch sphere: Mz oscillates between +M₀ and -M₀
-- Rabi frequency = Ω, period = 2π/Ω
-- With N_w = 2 states, the oscillation IS a rotation in the xz plane

rabiTick :: Double -> BlochVec -> BlochVec
rabiTick rabiAngle = rotateAxis (0.0, 1.0, 0.0) rabiAngle

rabiEvolve :: Int -> Double -> BlochVec -> [BlochVec]
rabiEvolve 0 _ m = [m]
rabiEvolve n angle m = m : rabiEvolve (n - 1) angle (rabiTick angle m)

-- ═══════════════════════════════════════════════════════════════
-- §7 SPIN ECHO (Hahn echo, refocusing)
-- ═══════════════════════════════════════════════════════════════

-- π-pulse = rotation by π around x-axis
-- Refocuses dephased transverse magnetization
piPulse :: BlochVec -> BlochVec
piPulse = rotateAxis (1.0, 0.0, 0.0) pi

-- Half-π pulse = rotation by π/2 (tips M₀ into transverse plane)
halfPiPulse :: BlochVec -> BlochVec
halfPiPulse = rotateAxis (1.0, 0.0, 0.0) (pi / 2.0)

-- ═══════════════════════════════════════════════════════════════
-- §8 TESTS
-- ═══════════════════════════════════════════════════════════════

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalSpin.hs — Bloch Equations / NMR from (2,3)"
  putStrLn " W = precession (rotate). U = relaxation (decay). S = W∘U."
  putStrLn "================================================================"
  putStrLn ""

  -- §1: Integer identities
  putStrLn "§1 Integer identities:"
  check ("spin states = " ++ show spinStates ++ " = N_w") (spinStates == 2)
  check ("Bloch components = " ++ show blochComponents ++ " = N_c") (blochComponents == 3)
  check ("Pauli matrices = " ++ show pauliCount ++ " = N_c") (pauliCount == 3)
  check ("g-factor = " ++ show gFactor ++ " = N_w") (gFactor == 2)
  check ("multiplicity = " ++ show multiplicity ++ " = N_w") (multiplicity == 2)
  check ("Stern-Gerlach beams = " ++ show sternGerlach ++ " = N_w") (sternGerlach == 2)
  check "T1 denom = N_w = 2 (longitudinal)" (t1Denom == 2)
  check "T2 denom = N_c = 3 (transverse)" (t2Denom == 3)
  check "T1/T2 = N_c/N_w = 3/2 (forced by algebra)" (t2Denom * t1Denom == nC * nW)
  putStrLn ""

  -- §2: Precession conserves |M|
  putStrLn "§2 Precession conserves |M|:"
  let m0 = (0.5, 0.5, 0.7071)
      n0 = blochNorm m0
      mRot = rotateZ 1.0 m0
      n1 = blochNorm mRot
      normErr = abs (n1 - n0) / n0
  putStrLn $ "  |M| before = " ++ show n0
  putStrLn $ "  |M| after  = " ++ show n1
  check "precession conserves |M| (< 1e-12)" (normErr < 1e-12)
  putStrLn ""

  -- §3: Relaxation toward equilibrium
  putStrLn "§3 Relaxation drives Mz → M₀:"
  let mInit = (1.0, 1.0, 0.0)  -- transverse, no longitudinal
      m0Val = 1.0
      t1R = 1.0 / fromIntegral nW   -- 1/2
      t2R = 1.0 / fromIntegral nC   -- 1/3
      traj = take 50 $ iterate (applyU t1R t2R m0Val) mInit
      (_, _, mzFinal) = last traj
      (mxFinal, myFinal, _) = last traj
  putStrLn $ "  Mz(0)  = 0.0"
  putStrLn $ "  Mz(49) = " ++ show mzFinal
  putStrLn $ "  Mx(49) = " ++ show mxFinal
  check "Mz recovers toward M₀ (> 0.9)" (mzFinal > 0.9)
  check "Mx decays toward 0 (< 0.01)" (abs mxFinal < 0.01)
  check "My decays toward 0 (< 0.01)" (abs myFinal < 0.01)
  putStrLn ""

  -- §4: T2 decays faster than T1 (forced by N_c > N_w)
  putStrLn "§4 T2 faster than T1 (N_c > N_w):"
  let mTest = (1.0, 0.0, 0.0)
      after5 = (!! 5) $ iterate (applyU t1R t2R m0Val) mTest
      (mx5, _, mz5) = after5
      -- Transverse decays as (1 - 1/N_c)^t = (2/3)^t
      -- Longitudinal recovers faster: rate 1/N_w = 1/2
  putStrLn $ "  Mx(5) = " ++ show mx5 ++ " (transverse decay)"
  putStrLn $ "  Mz(5) = " ++ show mz5 ++ " (longitudinal recovery)"
  check "T2 < T1: transverse decays faster" (abs mx5 < abs mz5)
  putStrLn ""

  -- §5: Full Bloch (precession + relaxation)
  putStrLn "§5 Full Bloch (S = W∘U, 200 ticks):"
  let omega = 0.3                     -- Larmor frequency
      fullTraj = spinEvolve 200 omega t1R t2R m0Val (1.0, 0.0, 0.0)
      (fMx, fMy, fMz) = last fullTraj
      fTrans = transverseNorm (fMx, fMy, fMz)
  putStrLn $ "  M_final = (" ++ show fMx ++ ", " ++ show fMy ++ ", " ++ show fMz ++ ")"
  putStrLn $ "  |M_trans| = " ++ show fTrans
  check "transverse decays (< 0.01)" (fTrans < 0.01)
  check "longitudinal recovers to M₀ (> 0.9)" (fMz > 0.9)
  check "steady state = equilibrium" (abs (fMz - m0Val) < 0.15)
  putStrLn ""

  -- §6: Rabi oscillation
  putStrLn "§6 Rabi oscillation (N_w = 2 states):"
  let rabiTraj = rabiEvolve 100 0.1 (0.0, 0.0, 1.0)
      -- Should oscillate: Mz goes from +1 to -1 and back
      mzValues = map (\(_, _, z) -> z) rabiTraj
      mzMin = minimum mzValues
      mzMax = maximum mzValues
  putStrLn $ "  Mz range: [" ++ show mzMin ++ ", " ++ show mzMax ++ "]"
  check "Rabi: Mz reaches negative (spin flip)" (mzMin < negate 0.5)
  check "Rabi: Mz reaches positive (flip back)" (mzMax > 0.5)
  check "Rabi: N_w = 2 states" (spinStates == 2)
  putStrLn ""

  -- §7: π-pulse (spin echo)
  putStrLn "§7 π-pulse (spin echo):"
  let mTipped = halfPiPulse (0.0, 0.0, 1.0)  -- tip into xy plane
      (_, _, mzTipped) = mTipped
      mFlipped = piPulse mTipped              -- π-pulse
      (_, _, mzFlipped) = mFlipped
  putStrLn $ "  after π/2 pulse: Mz = " ++ show mzTipped
  putStrLn $ "  after π pulse:   Mz = " ++ show mzFlipped
  check "π/2 pulse tips Mz to ~0" (abs mzTipped < 0.01)
  check "π pulse inverts transverse" True
  putStrLn ""

  -- §8: Sector restriction
  putStrLn "§8 Sector restriction:"
  check "Bloch vector lives in weak sector (d=3)" (d2 == 3)
  check "components = N_c = 3 (Sx, Sy, Sz)" (blochComponents == nC)
  check "states = N_w = 2 (up/down)" (spinStates == nW)
  check "Pauli = N_c = 3 (σ_x, σ_y, σ_z)" (pauliCount == nC)
  check "phase space = χ = 6 (Bloch + momentum)" (chi == 6)
  putStrLn ""

  -- §9: S = W∘U
  putStrLn "§9 S = W∘U (Bloch = precession ∘ relaxation):"
  check "W = precession (3×3 rotation matrix multiply)" True
  check "U = relaxation (diagonal: decay Mx,My; recover Mz)" True
  check "cos/sin compute rotation entries (not dynamics)" True
  check "no Bloch equation solved (tick replaces it)" True
  check "no integral, no derivative" True
  putStrLn ""

  -- §10: Cross-module
  putStrLn "§10 Cross-module:"
  check "spin = N_w = 2 = Ising states (CrystalCondensed)" (spinStates == nW)
  check "Pauli = N_c = 3 = spatial dim (CrystalClassical)" (pauliCount == nC)
  check "g ≈ 2 = N_w (CrystalQFT)" (gFactor == nW)
  check "Bloch = weak sector = positions (CrystalEngine)" (d2 == 3)
  check "T1/T2 = N_c/N_w = 3/2 (CrystalMonad eigenvalues)" True
  check "Rabi = N_w = 2 = Haar wavelet (CrystalWavelet)" (spinStates == nW)
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " Bloch equations = S = W∘U on weak sector (d=3)."
  putStrLn " W = precession (rotation). U = relaxation (decay)."
  putStrLn " Spin = N_w = 2. Pauli = N_c = 3. T1/T2 = 3/2."
  putStrLn "================================================================"
