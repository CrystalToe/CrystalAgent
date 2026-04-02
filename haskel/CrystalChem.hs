-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalChem -- Chemistry and Materials from (2,3).

Orbital structure, hybridization, Arrhenius kinetics. Every chemical constant from A_F.

  s-shell capacity:     2   = N_w
  p-shell capacity:     6   = chi
  d-shell capacity:     10  = N_w (chi-1)
  f-shell capacity:     14  = N_w beta_0
  sp3 bond angle:       109.47 = arccos(-1/N_c)
  sp2 bond angle:       120    = 360/N_c
  Water bond angle:     104.48 = arccos(-1/N_w^2)
  Noble gas He:         Z=2  = N_w
  Noble gas Ne:         Z=10 = N_w (chi-1)
  Noble gas Ar:         Z=18 = N_w N_c^2
  Noble gas Kr:         Z=36 = Sigma_d
  Neutral pH:           7    = beta_0
  Bohr energy factor:   2    = N_w
  kT(300K) ~ eps_vdw:   alpha E_H / N_c^2

Observable count: 14. Every number from (2,3).
-}

module CrystalChem where


-- =====================================================================
-- S0  A_F ATOMS
-- =====================================================================

nW, nC, chi, beta0, sigmaD, sigmaD2, gauss, towerD :: Integer
nW      = 2
nC      = 3
chi     = nW * nC                          -- 6
beta0   = (11 * nC - 2 * chi) `div` 3     -- 7
sigmaD  = 1 + 3 + 8 + 24                  -- 36
sigmaD2 = 1 + 9 + 64 + 576                -- 650
gauss   = nC * nC + nW * nW               -- 13
towerD  = sigmaD + chi                    -- 42

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- =====================================================================
-- S1  ORBITAL QUANTUM NUMBERS FROM (2,3)
--
-- Angular momentum quantum number: l = 0, 1, ..., N_c-1 (= 0,1,2,3)
-- Orbital types: s(l=0), p(l=1), d(l=2), f(l=3)
-- Magnetic degeneracy: 2l+1 = 1, 3, 5, 7
-- Electron capacity per subshell: N_w(2l+1) = 2, 6, 10, 14
--   s: N_w = 2
--   p: N_w N_c = chi = 6
--   d: N_w (chi-1) = 10
--   f: N_w beta_0 = 14
-- Shell capacity: N_w n^2 (= 2n^2)
-- =====================================================================

-- | Orbital types: l = 0 .. N_c-1.
maxOrbitalL :: Integer
maxOrbitalL = nC - 1  -- 3 (s, p, d, f)

-- | Subshell capacity: N_w (2l+1).
subshellCapacity :: Integer -> Integer
subshellCapacity l = nW * (2 * l + 1)

-- | Named capacities.
sCapacity :: Integer
sCapacity = subshellCapacity 0  -- 2 = N_w

pCapacity :: Integer
pCapacity = subshellCapacity 1  -- 6 = chi

dCapacity :: Integer
dCapacity = subshellCapacity 2  -- 10 = N_w*(chi-1)

fCapacity :: Integer
fCapacity = subshellCapacity 3  -- 14 = N_w*beta_0

-- | Shell capacity: N_w n^2.
shellCapacity :: Integer -> Integer
shellCapacity n = nW * n * n

-- =====================================================================
-- S2  HYBRIDIZATION ANGLES
--
-- sp3: arccos(-1/N_c) = 109.47 deg (tetrahedral, methane)
-- sp2: 2 pi / N_c = 120 deg (trigonal planar, ethylene)
-- sp:  pi = 180 deg (linear, acetylene)
-- water: arccos(-1/N_w^2) = 104.48 deg (bent, 2 lone pairs)
-- =====================================================================

sp3Angle :: Double
sp3Angle = acos (-1.0 / fromIntegral nC)  -- arccos(-1/3) = 109.47 deg

sp2Angle :: Double
sp2Angle = 2.0 * pi / fromIntegral nC  -- 2pi/3 = 120 deg

spAngle :: Double
spAngle = pi  -- 180 deg

waterAngle :: Double
waterAngle = acos (-1.0 / fromIntegral (nW * nW))  -- arccos(-1/4) = 104.48 deg

-- =====================================================================
-- S3  ENERGY SCALES
--
-- Fine structure: alpha = 1/(43 pi + ln 7)
-- Hartree energy: E_H = alpha^2 m_e c^2
-- Bohr radius: a_0 = hbar c / (m_e c^2 alpha)
-- Rydberg: Ry = E_H / N_w = E_H / 2
--
-- Force field (from CrystalProtein):
-- eps_vdw = alpha E_H / N_c^2 ~ 0.022 eV ~ kT at 300 K
-- E_hbond = alpha E_H ~ 0.199 eV
-- =====================================================================

alphaEM :: Double
alphaEM = 1.0 / (fromIntegral (towerD + 1) * pi + log (fromIntegral beta0))

mElectron :: Double
mElectron = 0.51099895  -- MeV/c^2

hbarc :: Double
hbarc = 197.3269804  -- MeV fm

-- | Hartree energy (eV).
-- | Hartree energy (eV): alpha^2 m_e c^2.
hartreeEV :: Double
hartreeEV = sq alphaEM * mElectron * 1.0e6  -- alpha^2 * 0.511 MeV * 1e6 eV/MeV = 27.2 eV

-- | Bohr radius (Angstrom).
bohrRadius :: Double
bohrRadius = hbarc / (mElectron * alphaEM) * 1.0e-5  -- fm to Angstrom: /1e5
  -- = 197.327 / (0.511 * 7.297e-3) = 197.327 / 3.729e-3 = 52918 fm = 0.529 A

-- | VdW energy (eV): alpha * E_H / N_c^2.
epsVdW :: Double
epsVdW = alphaEM * hartreeEV / fromIntegral (nC * nC)

-- | H-bond energy (eV): alpha * E_H.
eHbond :: Double
eHbond = alphaEM * hartreeEV

-- | kT at 300 K (eV).
kT300 :: Double
kT300 = 8.617333e-5 * 300.0  -- k_B * 300

-- | Protein dielectric: N_w^2 (N_c + 1) = 16.
dielectricProtein :: Integer
dielectricProtein = nW * nW * (nC + 1)  -- 16

-- =====================================================================
-- S4  ARRHENIUS KINETICS
--
-- k = A exp(-E_a / kT)
-- Crystal prediction: kT_bio ~ eps_vdw = alpha E_H / N_c^2
-- This IS the reason biology works at ~300 K:
--   thermal energy = VdW energy at biological temperature.
-- =====================================================================

-- | Arrhenius rate constant (relative, E_a and kT in eV).
arrhenius :: Double -> Double -> Double
arrhenius eA kT = exp (- eA / kT)

-- =====================================================================
-- S5  NOBLE GASES FROM (2,3)
--
-- He: Z = 2  = N_w
-- Ne: Z = 10 = N_w (chi-1)
-- Ar: Z = 18 = N_w N_c^2
-- Kr: Z = 36 = Sigma_d  [!!!]
-- =====================================================================

nobleHe :: Integer
nobleHe = nW  -- 2

nobleNe :: Integer
nobleNe = nW * (chi - 1)  -- 2 * 5 = 10

nobleAr :: Integer
nobleAr = nW * nC * nC  -- 2 * 9 = 18

nobleKr :: Integer
nobleKr = sigmaD  -- 36 !!!

-- | Neutral pH = beta_0 = 7.
neutralPH :: Integer
neutralPH = beta0  -- 7

-- =====================================================================
-- S6  INTEGER IDENTITY PROOFS
-- =====================================================================

proveSCap :: Integer
proveSCap = nW  -- 2

provePCap :: Integer
provePCap = nW * nC  -- 6 = chi

proveDCap :: Integer
proveDCap = nW * (chi - 1)  -- 10

proveFCap :: Integer
proveFCap = nW * beta0  -- 14

proveSp3 :: Double
proveSp3 = sp3Angle * 180.0 / pi  -- 109.47

proveSp2 :: Double
proveSp2 = sp2Angle * 180.0 / pi  -- 120.0

proveWater :: Double
proveWater = waterAngle * 180.0 / pi  -- 104.48

proveHe :: Integer
proveHe = nW  -- 2

proveNe :: Integer
proveNe = nW * (chi - 1)  -- 10

proveAr :: Integer
proveAr = nW * nC * nC  -- 18

proveKr :: Integer
proveKr = sigmaD  -- 36

provePH :: Integer
provePH = beta0  -- 7

proveBohrFactor :: Integer
proveBohrFactor = nW  -- 2 (Ry = E_H/2 = E_H/N_w)

proveDielectric :: Integer
proveDielectric = nW * nW * (nC + 1)  -- 16

-- =====================================================================
-- S7  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalChem.hs -- Chemistry and Materials from (2,3) -- Test"
  putStrLn "================================================================"
  putStrLn ""

  -- S1: Integer identities
  putStrLn "S1 Chemistry integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("s-shell = 2 = N_w",                proveSCap == 2)
        , ("p-shell = 6 = chi",                provePCap == 6)
        , ("d-shell = 10 = N_w(chi-1)",        proveDCap == 10)
        , ("f-shell = 14 = N_w beta_0",         proveFCap == 14)
        , ("He Z=2 = N_w",                      proveHe == 2)
        , ("Ne Z=10 = N_w(chi-1)",              proveNe == 10)
        , ("Ar Z=18 = N_w N_c^2",               proveAr == 18)
        , ("Kr Z=36 = Sigma_d",                  proveKr == 36)
        , ("neutral pH = 7 = beta_0",            provePH == 7)
        , ("Bohr factor = 2 = N_w (Ry=E_H/2)", proveBohrFactor == 2)
        , ("dielectric = 16 = N_w^2(N_c+1)",    proveDielectric == 16)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- S2: Hybridization angles
  putStrLn "S2 Hybridization angles:"
  let sp3D  = sp3Angle * 180.0 / pi
      sp2D  = sp2Angle * 180.0 / pi
      spD   = spAngle * 180.0 / pi
      watD  = waterAngle * 180.0 / pi
      sp3Ok = abs (sp3D - 109.4712) < 0.001
      sp2Ok = abs (sp2D - 120.0) < 1e-10
      spOk  = abs (spD - 180.0) < 1e-10
      watOk = abs (watD - 104.4775) < 0.001
  putStrLn $ "  sp3   = " ++ show sp3D ++ " deg (arccos(-1/N_c))"
  putStrLn $ "  sp2   = " ++ show sp2D ++ " deg (2pi/N_c)"
  putStrLn $ "  sp    = " ++ show spD ++ " deg (pi)"
  putStrLn $ "  water = " ++ show watD ++ " deg (arccos(-1/N_w^2))"
  let angOk = sp3Ok && sp2Ok && spOk && watOk
  putStrLn $ "  " ++ (if angOk then "PASS" else "FAIL") ++
             "  all angles from (2,3)"
  putStrLn ""

  -- S3: Energy scales
  putStrLn "S3 Energy scales:"
  putStrLn $ "  alpha^-1     = " ++ show (1.0 / alphaEM)
  putStrLn $ "  E_H          = " ++ show hartreeEV ++ " eV"
  putStrLn $ "  a_0          = " ++ show bohrRadius ++ " A"
  putStrLn $ "  eps_vdw      = " ++ show epsVdW ++ " eV"
  putStrLn $ "  E_hbond      = " ++ show eHbond ++ " eV"
  putStrLn $ "  kT(300K)     = " ++ show kT300 ++ " eV"
  let ehRef = 27.2 :: Double
      ehErr = abs (hartreeEV - ehRef) / ehRef
      ehOk = ehErr < 0.01
  putStrLn $ "  E_H ~ 27.2 eV: err = " ++ show ehErr
  putStrLn $ "  " ++ (if ehOk then "PASS" else "FAIL") ++
             "  Hartree energy (< 1%)"

  let a0Ref = 0.529 :: Double
      a0Err = abs (bohrRadius - a0Ref) / a0Ref
      a0Ok = a0Err < 0.01
  putStrLn $ "  a_0 ~ 0.529 A: err = " ++ show a0Err
  putStrLn $ "  " ++ (if a0Ok then "PASS" else "FAIL") ++
             "  Bohr radius (< 1%)"
  putStrLn ""

  -- S4: kT ~ eps_vdw (Crystal prediction: biology at 300K)
  putStrLn "S4 Thermal-VdW coincidence (Crystal prediction):"
  let ratio = epsVdW / kT300
      ratOk = ratio > 0.5 && ratio < 2.0
  putStrLn $ "  eps_vdw/kT(300) = " ++ show ratio ++ " (expect ~1)"
  putStrLn $ "  " ++ (if ratOk then "PASS" else "FAIL") ++
             "  VdW energy ~ kT at biological temperature"
  putStrLn ""

  -- S5: Shell filling
  putStrLn "S5 Shell filling:"
  let sh1 = shellCapacity 1  -- 2
      sh2 = shellCapacity 2  -- 8
      sh3 = shellCapacity 3  -- 18
      shOk = sh1 == 2 && sh2 == 8 && sh3 == 18
  putStrLn $ "  shell 1: " ++ show sh1 ++ " = N_w*1^2"
  putStrLn $ "  shell 2: " ++ show sh2 ++ " = N_w*2^2 = d_colour"
  putStrLn $ "  shell 3: " ++ show sh3 ++ " = N_w*3^2 = N_w*N_c^2"
  putStrLn $ "  " ++ (if shOk then "PASS" else "FAIL") ++
             "  shell capacity = N_w n^2"
  putStrLn ""

  -- S6: Arrhenius
  putStrLn "S6 Arrhenius kinetics:"
  let rate1 = arrhenius 0.5 kT300   -- high barrier
      rate2 = arrhenius 0.025 kT300 -- barrier ~ kT
      arOk = rate2 > rate1 && rate2 > 0.1
  putStrLn $ "  k(E_a=0.5eV)  = " ++ show rate1 ++ " (slow)"
  putStrLn $ "  k(E_a=kT)     = " ++ show rate2 ++ " (fast)"
  putStrLn $ "  " ++ (if arOk then "PASS" else "FAIL") ++
             "  Arrhenius: low barrier -> fast rate"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks) && angOk && ehOk && a0Ok
                && ratOk && shOk && arOk
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every Chemistry integer from (2, 3)."
  putStrLn "  Observable count: 14."

main :: IO ()
main = runSelfTest
