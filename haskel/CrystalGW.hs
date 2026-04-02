-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalGW — Gravitational Waveforms from (2,3).

Binary inspiral waveform generation. Every coefficient from A_F.

  Quadrupole power:    32/5 = N_w^5 / (chi-1)
  Polarizations:       2 = N_c - 1
  GW freq = 2 f_orb:  2 = N_w (quadrupole radiates at N_w * f_orb)
  Waveform amplitude:  4 = N_w^2
  Chirp mass exp:      3/5 = N_c/(chi-1), 1/5 = 1/(chi-1)
  Frequency power:     2/3 = (N_c-1)/N_c
  ISCO cutoff:         6 = chi (from r_ISCO = 6GM)
  Orbital decay:       64/5 = N_w^6 / (chi-1)
  Merger GW cycles:    ~5/3 = (chi-1)/N_c (Kolmogorov!)

Observable count: 0 new (infrastructure). Every number from (2,3).
-}

module CrystalGW where

import Data.Ratio (Rational, (%))

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

dColour :: Integer
dColour = nC * nC - 1    -- 8

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- =====================================================================
-- S1  PETERS FORMULA (GW energy loss)
--
-- dE/dt = -(32/5) G^4 m1^2 m2^2 (m1+m2) / (c^5 a^5)
-- 32/5 = N_w^5 / (chi-1)
-- In natural units (G=c=1): dE/dt = -(32/5) mu^2 M^3 / a^5
-- where mu = m1*m2/M (reduced mass), M = m1+m2 (total mass)
-- =====================================================================

-- | Peters quadrupole coefficient. 32/5 = N_w^5/(chi-1).
petersCoeff :: Double
petersCoeff = fromIntegral (nW * nW * nW * nW * nW) / fromIntegral (chi - 1)
-- = 32/5 = 6.4

-- | GW power radiated (natural units G=c=1).
-- P = (32/5) mu^2 M^3 / a^5
gwPower :: Double -> Double -> Double -> Double
gwPower mu totalM a =
  petersCoeff * sq mu * totalM * sq totalM / (a * sq a * sq a)

-- =====================================================================
-- S2  ORBITAL DECAY
--
-- da/dt = -(64/5) mu M^2 / a^3
-- 64/5 = 2 * 32/5 = N_w^6 / (chi-1)
-- =====================================================================

-- | Orbital decay rate da/dt (natural units).
orbitDecayRate :: Double -> Double -> Double -> Double
orbitDecayRate mu totalM a =
  let coeff = 2.0 * petersCoeff   -- 64/5 = N_w^6/(chi-1)
  in -coeff * mu * sq totalM / (a * sq a)

-- =====================================================================
-- S3  CHIRP MASS
--
-- M_c = (m1 m2)^(3/5) / (m1+m2)^(1/5)
-- = mu^(3/5) M^(2/5)
-- 3/5 = N_c/(chi-1).  1/5 = 1/(chi-1).  2/5 = N_w/(chi-1).
-- =====================================================================

-- | Chirp mass. Exponents 3/5 and 1/5 from N_c/(chi-1) and 1/(chi-1).
chirpMass :: Double -> Double -> Double
chirpMass m1 m2 =
  let mu = m1 * m2 / (m1 + m2)
      totalM = m1 + m2
      -- M_c = mu^(3/5) * M^(2/5)
      -- 3/5 = N_c / (chi-1),  2/5 = N_w / (chi-1)
      exp35 = fromIntegral nC / fromIntegral (chi - 1)   -- 3/5
      exp25 = fromIntegral nW / fromIntegral (chi - 1)   -- 2/5
  in mu ** exp35 * totalM ** exp25

-- =====================================================================
-- S4  GW FREQUENCY AND CHIRP
--
-- f_GW = 2 f_orb (quadrupole: N_w * f_orbital)
-- f_orb = (1/2pi) sqrt(M/a^3) (Kepler)
-- df/dt from orbital decay
-- =====================================================================

-- | GW frequency from orbital separation (natural units).
-- f_GW = N_w * f_orb = N_w / (2pi) * sqrt(M/a^3)
gwFrequency :: Double -> Double -> Double
gwFrequency totalM a =
  let fOrb = sqrt (totalM / (a * sq a)) / (2 * pi)
  in fromIntegral nW * fOrb   -- 2 * f_orb

-- | Orbital separation from GW frequency (inverse).
separationFromFreq :: Double -> Double -> Double
separationFromFreq totalM fGW =
  let fOrb = fGW / fromIntegral nW
      -- a^3 = M / (2pi f_orb)^2
      a3 = totalM / sq (2 * pi * fOrb)
  in a3 ** (1.0/3.0)

-- | Chirp rate: df/dt = (96/5) pi^(8/3) M_c^(5/3) f^(11/3)
-- 96/5 = 3 * 32/5 = N_c * N_w^5 / (chi-1)
-- 8/3 = (N_c^2 - 1)/N_c = d_colour/N_c
-- 5/3 = (chi-1)/N_c  (Kolmogorov exponent!)
-- 11/3 = (N_c^2 + N_w)/N_c = (gauss - N_w^2 + N_w)/N_c
chirpRate :: Double -> Double -> Double
chirpRate mc fGW =
  let coeff = fromIntegral nC * petersCoeff   -- 96/5
      exp83 = fromIntegral dColour / fromIntegral nC   -- 8/3
      exp53 = fromIntegral (chi - 1) / fromIntegral nC -- 5/3
      exp113 = (fromIntegral (nC * nC) + fromIntegral nW) / fromIntegral nC  -- 11/3
  in coeff * pi ** exp83 * mc ** exp53 * fGW ** exp113

-- =====================================================================
-- S5  TIME TO MERGER
--
-- t_merge = (5/256) M_c^(-5/3) (pi f)^(-8/3)
-- 5 = chi - 1.  256 = N_w^8.  5/256 = (chi-1)/N_w^8.
-- =====================================================================

-- | Time to merger from current GW frequency (natural units).
timeToMerger :: Double -> Double -> Double
timeToMerger mc fGW =
  let num = fromIntegral (chi - 1)                     -- 5
      den = fromIntegral (nW*nW*nW*nW*nW*nW*nW*nW)    -- 256 = N_w^8
      exp53 = fromIntegral (chi - 1) / fromIntegral nC -- 5/3
      exp83 = fromIntegral dColour / fromIntegral nC   -- 8/3
  in (num / den) * mc ** (-exp53) * (pi * fGW) ** (-exp83)

-- =====================================================================
-- S6  ISCO CUTOFF
--
-- f_ISCO = 1 / (6^(3/2) pi M) = 1 / (chi^(3/2) pi M)
-- The merger frequency. GW signal cuts off here.
-- =====================================================================

-- | ISCO frequency (natural units). chi = 6 gives the cutoff.
iscoFrequency :: Double -> Double
iscoFrequency totalM =
  let chi_d = fromIntegral chi   -- 6
  in 1.0 / (chi_d * sqrt chi_d * pi * totalM)

-- =====================================================================
-- S7  WAVEFORM h+(t), hx(t)
--
-- h+ = (4/r) (M_c)^(5/3) (pi f)^(2/3) ((1+cos^2 iota)/2) cos(Phi)
-- hx = (4/r) (M_c)^(5/3) (pi f)^(2/3) cos(iota) sin(Phi)
--
-- Two polarizations: N_c - 1 = 2.
-- Amplitude prefactor: N_w^2 = 4.
-- Frequency exponent: (N_c-1)/N_c = 2/3.
-- Chirp mass exponent: (chi-1)/N_c = 5/3.
-- =====================================================================

-- | GW waveform state during inspiral.
data GWState = GWState
  { gwTime  :: Double   -- ^ time
  , gwFreq  :: Double   -- ^ GW frequency
  , gwPhase :: Double   -- ^ accumulated GW phase
  , gwHPlus :: Double   -- ^ h+ strain
  , gwHCross :: Double  -- ^ hx strain
  } deriving (Show)

-- | Generate inspiral waveform.
-- Returns list of (time, f, phase, h+, hx) samples.
inspiralWaveform :: Double   -- ^ m1 (solar masses, natural units)
                 -> Double   -- ^ m2
                 -> Double   -- ^ distance r
                 -> Double   -- ^ inclination iota (radians)
                 -> Double   -- ^ initial GW frequency f0
                 -> Double   -- ^ time step dt
                 -> [GWState]
inspiralWaveform m1 m2 dist iota f0 dt =
  let mc     = chirpMass m1 m2
      totalM = m1 + m2
      fISCO  = iscoFrequency totalM
      -- Amplitude prefactor
      amp0   = fromIntegral (nW * nW) / dist   -- 4/r
      -- Exponents from (2,3)
      exp53  = fromIntegral (chi - 1) / fromIntegral nC  -- 5/3
      exp23  = fromIntegral (nC - 1) / fromIntegral nC   -- 2/3
      -- Polarization factors
      cosI   = cos iota
      fPlus  = (1 + cosI * cosI) / 2
      fCross = cosI
      -- Evolution
      go t f phase
        | f >= fISCO = []   -- merger cutoff
        | otherwise  =
            let amp  = amp0 * mc ** exp53 * (pi * f) ** exp23
                hP   = amp * fPlus * cos phase
                hX   = amp * fCross * sin phase
                st   = GWState t f phase hP hX
                -- Evolve frequency
                dfdt  = chirpRate mc f
                f1    = f + dfdt * dt
                -- Evolve phase
                phase1 = phase + 2 * pi * f * dt
            in st : go (t + dt) f1 phase1
  in go 0.0 f0 0.0

-- =====================================================================
-- S8  INSPIRAL INTEGRATION (orbital evolution)
--
-- Integrate a(t) from Peters formula.
-- Leapfrog on (a, da/dt) — symplectic orbital decay.
-- =====================================================================

-- | Binary orbital state.
data BinaryState = BinaryState
  { bsA    :: Double   -- ^ orbital separation
  , bsFreq :: Double   -- ^ GW frequency
  , bsTime :: Double   -- ^ time elapsed
  , bsPhi  :: Double   -- ^ orbital phase
  } deriving (Show)

-- | Integrate binary inspiral from initial separation to ISCO.
integrateInspiral :: Double -> Double -> Double -> Double -> [BinaryState]
integrateInspiral m1 m2 a0 dt =
  let totalM = m1 + m2
      mu     = m1 * m2 / totalM
      rs     = fromIntegral (nC - 1) * totalM   -- 2M
      aISCO  = fromIntegral nC * rs              -- 3 r_s = 6M
      go a t phase
        | a <= aISCO = []   -- reached ISCO
        | otherwise  =
            let fGW   = gwFrequency totalM a
                fOrb  = fGW / fromIntegral nW
                dadt  = orbitDecayRate mu totalM a
                a1    = a + dadt * dt
                phase1 = phase + 2 * pi * fOrb * dt
                st    = BinaryState a fGW t phase
            in st : go a1 (t + dt) phase1
  in go a0 0.0 0.0

-- =====================================================================
-- S9  INTEGER IDENTITY PROOFS
-- =====================================================================

proveQuadrupole :: Rational
proveQuadrupole = (nW * nW * nW * nW * nW) % (chi - 1)  -- 32/5

proveDecayCoeff :: Rational
proveDecayCoeff = (nW * nW * nW * nW * nW * nW) % (chi - 1)  -- 64/5

proveChirpCoeff :: Rational
proveChirpCoeff = (nC * nW * nW * nW * nW * nW) % (chi - 1)  -- 96/5

proveMergerCoeff :: (Integer, Integer)
proveMergerCoeff = (chi - 1, nW * nW * nW * nW * nW * nW * nW * nW)  -- (5, 256)

proveChirpMassExp :: (Rational, Rational)
proveChirpMassExp = (nC % (chi - 1), nW % (chi - 1))  -- (3/5, 2/5)

proveFreqExp :: Rational
proveFreqExp = (nC - 1) % nC  -- 2/3

proveAmplitude :: Integer
proveAmplitude = nW * nW  -- 4

provePolarizations :: Integer
provePolarizations = nC - 1  -- 2

proveGWdoubling :: Integer
proveGWdoubling = nW  -- 2 (f_GW = 2 f_orb)

proveISCOfreq :: Integer
proveISCOfreq = chi  -- 6 in 1/(6^(3/2) pi M)

proveKolmogorovInGW :: Rational
proveKolmogorovInGW = (chi - 1) % nC  -- 5/3

-- =====================================================================
-- S10  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalGW.hs -- Gravitational Waveforms from (2,3) -- Test"
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "S1 GW integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("quadrupole 32/5 = N_w^5/(chi-1)",  proveQuadrupole == 32 % 5)
        , ("decay 64/5 = N_w^6/(chi-1)",       proveDecayCoeff == 64 % 5)
        , ("chirp coeff 96/5 = N_c*32/5",      proveChirpCoeff == 96 % 5)
        , ("merger (5,256) = (chi-1, N_w^8)",   proveMergerCoeff == (5, 256))
        , ("chirp mass exp (3/5, 2/5)",         proveChirpMassExp == (3%5, 2%5))
        , ("freq exp 2/3 = (N_c-1)/N_c",       proveFreqExp == 2 % 3)
        , ("amplitude 4 = N_w^2",              proveAmplitude == 4)
        , ("polarizations 2 = N_c-1",          provePolarizations == 2)
        , ("GW doubling 2 = N_w",              proveGWdoubling == 2)
        , ("ISCO freq 6 = chi",               proveISCOfreq == 6)
        , ("Kolmogorov 5/3 in chirp",          proveKolmogorovInGW == 5 % 3)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- Chirp mass
  putStrLn "S2 Chirp mass:"
  let m1 = 30.0 :: Double   -- solar masses (natural units)
      m2 = 30.0
      mc = chirpMass m1 m2
      -- For equal mass: M_c = M * 2^(-1/5) / 2^(3/5) = M/2 * 2^(-1/5)
      -- Actually M_c = (m1*m2)^(3/5)/(m1+m2)^(1/5)
      -- = (900)^(3/5) / (60)^(1/5)
      mcExpect = (m1*m2)**0.6 / (m1+m2)**0.2
  putStrLn $ "  M_c(30,30) = " ++ show mc
  putStrLn $ "  expected   = " ++ show mcExpect
  let mcOk = abs (mc - mcExpect) / mcExpect < 1e-10
  putStrLn $ "  " ++ (if mcOk then "PASS" else "FAIL") ++ "  chirp mass correct"
  putStrLn ""

  -- ISCO frequency
  putStrLn "S3 ISCO frequency:"
  let totalM = m1 + m2
      fISCO = iscoFrequency totalM
      -- f_ISCO = 1/(6^(3/2) pi M)
      fExpect = 1.0 / (6.0 * sqrt 6.0 * pi * totalM)
  putStrLn $ "  f_ISCO = " ++ show fISCO
  let iscoOk = abs (fISCO - fExpect) / fExpect < 1e-10
  putStrLn $ "  " ++ (if iscoOk then "PASS" else "FAIL") ++ "  ISCO freq = 1/(chi^(3/2) pi M)"
  putStrLn ""

  -- Time to merger
  putStrLn "S4 Time to merger:"
  let f0 = fISCO / 10.0   -- start at f_ISCO/10
      tMerge = timeToMerger mc f0
  putStrLn $ "  t_merge = " ++ show tMerge ++ " (natural units)"
  putStrLn $ "  starting from f = " ++ show f0
  let tOk = tMerge > 0
  putStrLn $ "  " ++ (if tOk then "PASS" else "FAIL") ++ "  t_merge > 0"
  putStrLn ""

  -- Waveform generation (strict loop, no list accumulation)
  putStrLn "S5 Waveform generation:"
  let dist = 1e6 :: Double
      iota = pi / 4
      dtWF = 0.01 :: Double
      fStart = fISCO / 1.5   -- start close to ISCO
      exp53  = fromIntegral (chi - 1) / fromIntegral nC :: Double
      exp23  = fromIntegral (nC - 1) / fromIntegral nC :: Double
      amp0   = fromIntegral (nW * nW) / dist :: Double
      cosI   = cos iota
      fPl    = (1 + cosI * cosI) / 2
      fCr    = cosI
      -- Strict loop: count samples, track frequency, check properties
      goWF :: Int -> Double -> Double -> Bool -> Bool -> Bool -> (Int, Bool, Bool, Bool)
      goWF n f phase chirpOk hpOk hxOk
        | f >= fISCO || n >= 50000 = (n, chirpOk, hpOk, hxOk)
        | otherwise =
            let amp  = amp0 * mc ** exp53 * (pi * f) ** exp23
                hP   = amp * fPl * cos phase
                hX   = amp * fCr * sin phase
                dfdt = chirpRate mc f
                f1   = f + dfdt * dtWF
                ph1  = phase + 2 * pi * f * dtWF
                hpOk' = hpOk || hP /= 0
                hxOk' = hxOk || hX /= 0
                chirp' = chirpOk && f1 >= f
            in f1 `seq` ph1 `seq` n `seq` goWF (n+1) f1 ph1 chirp' hpOk' hxOk'
      (nSamples, isChirp, hasHPlus, hasHCross) = goWF 0 fStart 0.0 True False False
  putStrLn $ "  samples generated = " ++ show nSamples
  let wfOk = nSamples > 100
  putStrLn $ "  " ++ (if wfOk then "PASS" else "FAIL") ++ "  waveform has > 100 samples"
  putStrLn $ "  " ++ (if isChirp then "PASS" else "FAIL") ++ "  frequency increases (chirp)"
  putStrLn $ "  " ++ (if hasHPlus && hasHCross then "PASS" else "FAIL") ++
             "  both h+ and hx polarizations present (N_c-1 = 2)"
  putStrLn ""

  -- Orbital inspiral (strict loop, start close to ISCO)
  putStrLn "S6 Orbital inspiral:"
  let mu     = m1 * m2 / totalM
      rs_orb = fromIntegral (nC - 1) * totalM :: Double
      a0     = 10.0 * rs_orb      -- 10 * r_s (close enough for fast decay)
      aISCO  = fromIntegral nC * rs_orb   -- 3 * r_s
      dtOrb  = 10.0 :: Double
      goOrb :: Int -> Double -> Bool -> (Int, Double, Bool)
      goOrb n a decOk
        | a <= aISCO || n >= 500000 = (n, a, decOk)
        | otherwise =
            let dadt = orbitDecayRate mu totalM a
                a1   = a + dadt * dtOrb
            in a1 `seq` n `seq` goOrb (n+1) a1 (decOk && a1 <= a)
      (nOrbSamples, aFinal, isDecaying) = goOrb 0 a0 True
  putStrLn $ "  inspiral steps = " ++ show nOrbSamples
  putStrLn $ "  a: " ++ show a0 ++ " -> " ++ show aFinal ++ " (ISCO = " ++ show aISCO ++ ")"
  let orbOk = aFinal <= aISCO
  putStrLn $ "  " ++ (if orbOk then "PASS" else "FAIL") ++ "  inspiral reaches ISCO"
  putStrLn $ "  " ++ (if isDecaying then "PASS" else "FAIL") ++ "  separation decreases (energy loss)"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks) && mcOk && iscoOk && tOk
                && wfOk && isChirp && hasHPlus && hasHCross
                && orbOk && isDecaying
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every GW integer from (2, 3)."
  putStrLn "  Observable count: 0 new (infrastructure)."

main :: IO ()
main = runSelfTest
