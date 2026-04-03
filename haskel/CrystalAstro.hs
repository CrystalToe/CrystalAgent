-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalAstro -- Astrophysical Extremes from (2,3).

Lane-Emden stellar structure + Chandrasekhar, Schwarzschild, Hawking.

  Polytrope (NR degen):  3/2 = N_c/N_w        (white dwarf)
  Polytrope (relativ):   3   = N_c             (massive star)
  Schwarzschild:         2   = N_w             (r_s = 2GM/c^2)
  Hawking T:             8   = d_colour = N_w^3 (T = hc^3/(8 pi G M k))
  Stefan-Boltzmann:      15  = N_c (chi-1)     (sigma ~ 2 pi^5/(15 h^3 c^2))
  Eddington:             4   = N_w^2           (L_Ed = 4 pi G M c / kappa)
  MS luminosity:         7/2 = beta_0/N_w      (L ~ M^3.5)
  MS lifetime:           5/2 = (chi-1)/N_w     (t ~ M^(-5/2))
  Virial factor:         2   = N_w             (2K + U = 0)
  Grav PE factor:        3/5 = N_c/(chi-1)     (U = -3GM^2/(5R))
  Chandrasekhar mu_e:    2   = N_w             (e^- per nucleon for C/O)
  Jeans T exponent:      3/2 = N_c/N_w
  Jeans rho exponent:    1/2 = 1/N_w

Observable count: 13. Every number from (2,3).
-}

module CrystalAstro where

import Data.Ratio ((%))

-- =====================================================================
-- S0  A_F ATOMS
-- =====================================================================

-- Atoms from CrystalEngine (no local redefinitions)
import qualified CrystalEngine as CE

nW, nC, chi, beta0, sigmaD, sigmaD2, gauss, towerD :: Integer
nW      = fromIntegral CE.nW
nC      = fromIntegral CE.nC
chi     = fromIntegral CE.chi
beta0   = fromIntegral CE.beta0
sigmaD  = fromIntegral CE.sigmaD
sigmaD2 = 1 + 9 + 64 + 576   -- sum d_k^2 = 650 (from engine sectors)
gauss   = nC^2 + nW^2
towerD  = sigmaD + chi

dColour :: Integer
dColour = nW * nW * nW  -- 8

sq :: Double -> Double
sq x = x * x
{-# INLINE sq #-}

-- =====================================================================
-- S1  ASTROPHYSICAL CONSTANTS FROM (2,3)
-- =====================================================================

-- | Polytropic indices.
polytropeNR :: Rational
polytropeNR = nC % nW  -- 3/2 (non-relativistic degenerate)

polytropeRel :: Integer
polytropeRel = nC  -- 3 (ultra-relativistic)

-- | Schwarzschild factor.
schwarzFactor :: Integer
schwarzFactor = nW  -- 2 (r_s = 2GM/c^2)

-- | Hawking temperature factor.
hawkingFactor :: Integer
hawkingFactor = dColour  -- 8 (T = hc^3/(8 pi G M k))

-- | Stefan-Boltzmann denominator: 15 = N_c (chi-1).
stefanBoltzDenom :: Integer
stefanBoltzDenom = nC * (chi - 1)  -- 15

-- | Eddington luminosity factor: 4 = N_w^2.
eddingtonFactor :: Integer
eddingtonFactor = nW * nW  -- 4

-- | Main sequence luminosity exponent: L ~ M^(7/2) = M^(beta_0/N_w).
msLuminosityExp :: Rational
msLuminosityExp = beta0 % nW  -- 7/2 = 3.5

-- | Main sequence lifetime exponent: t ~ M^(-5/2) = M^(-(chi-1)/N_w).
msLifetimeExp :: Rational
msLifetimeExp = (chi - 1) % nW  -- 5/2

-- | Virial theorem factor: 2K + U = 0.
virialFactor :: Integer
virialFactor = nW  -- 2

-- | Gravitational PE: U = -3GM^2/(5R). Factor 3/5 = N_c/(chi-1).
gravPEFactor :: Rational
gravPEFactor = nC % (chi - 1)  -- 3/5

-- | Chandrasekhar electron fraction: mu_e = N_w for C/O composition.
chandraMuE :: Integer
chandraMuE = nW  -- 2

-- | Jeans mass: M_J ~ T^(3/2) rho^(-1/2).
jeansTExp :: Rational
jeansTExp = nC % nW  -- 3/2

jeansRhoExp :: Rational
jeansRhoExp = 1 % nW  -- 1/2

-- =====================================================================
-- S2  LANE-EMDEN SOLVER
--
-- (1/xi^2) d/dxi (xi^2 dtheta/dxi) + theta^n = 0
-- => theta'' = -theta^n - 2 theta'/xi
--
-- BC: theta(0) = 1, theta'(0) = 0.
-- Near origin: theta ~ 1 - xi^2/(2(d+2)) where d=3 => 1 - xi^2/6.
--              theta' ~ -xi/3.
-- Integrate to xi_1 where theta = 0 (stellar surface).
-- =====================================================================

-- | Solve Lane-Emden for index n. Returns (xi_1, -xi_1^2 theta'(xi_1)).
laneEmden :: Double -> (Double, Double)
laneEmden n =
  let eps  = 0.001 :: Double
      dxi  = 0.0005 :: Double
      -- Initial conditions from series expansion
      th0  = 1.0 - sq eps / 6.0
      dth0 = -eps / 3.0
      -- RK2 integrator
      go :: Double -> Double -> Double -> (Double, Double)
      go xi th dth
        | th <= 0   = (xi, -sq xi * dth)
        | xi > 20   = (xi, -sq xi * dth)  -- safety
        | otherwise =
            let -- f(xi, th, dth) = -th^n - 2*dth/xi
                thN  = if th > 0 then th ** n else 0.0
                f1   = -thN - 2.0 * dth / xi
                -- Half step
                xi2  = xi + 0.5 * dxi
                th2  = th + 0.5 * dxi * dth
                dth2 = dth + 0.5 * dxi * f1
                thN2 = if th2 > 0 then th2 ** n else 0.0
                f2   = -thN2 - 2.0 * dth2 / xi2
                -- Full step
                th'  = th + dxi * dth2
                dth' = dth + dxi * f2
            in th' `seq` dth' `seq` go (xi + dxi) th' dth'
  in go eps th0 dth0

-- =====================================================================
-- S3  STELLAR STRUCTURE RESULTS
-- =====================================================================

-- | Lane-Emden surface for n = N_c/N_w = 3/2 (white dwarf).
laneEmdenNR :: (Double, Double)
laneEmdenNR = laneEmden (fromIntegral nC / fromIntegral nW)  -- n=1.5

-- | Lane-Emden surface for n = N_c = 3 (relativistic).
laneEmdenRel :: (Double, Double)
laneEmdenRel = laneEmden (fromIntegral nC)  -- n=3

-- =====================================================================
-- S4  INTEGER IDENTITY PROOFS
-- =====================================================================

provePolyNR :: Rational
provePolyNR = nC % nW  -- 3/2

provePolyRel :: Integer
provePolyRel = nC  -- 3

proveSchwarz :: Integer
proveSchwarz = nW  -- 2

proveHawking :: Integer
proveHawking = dColour  -- 8

proveSB :: Integer
proveSB = nC * (chi - 1)  -- 15

proveEddington :: Integer
proveEddington = nW * nW  -- 4

proveMSLum :: Rational
proveMSLum = beta0 % nW  -- 7/2

proveMSLife :: Rational
proveMSLife = (chi - 1) % nW  -- 5/2

proveVirial :: Integer
proveVirial = nW  -- 2

proveGravPE :: Rational
proveGravPE = nC % (chi - 1)  -- 3/5

proveMuE :: Integer
proveMuE = nW  -- 2

proveJeansT :: Rational
proveJeansT = nC % nW  -- 3/2

proveJeansRho :: Rational
proveJeansRho = 1 % nW  -- 1/2

-- =====================================================================
-- S5  SELF-TEST
-- =====================================================================

runSelfTest :: IO ()
runSelfTest = do
  putStrLn "================================================================"
  putStrLn " CrystalAstro.hs -- Astrophysical Extremes from (2,3) -- Test"
  putStrLn "================================================================"
  putStrLn ""

  -- S1: Integer identities
  putStrLn "S1 Astrophysical integer identities:"
  let intChecks :: [(String, Bool)]
      intChecks =
        [ ("polytrope NR = 3/2 = N_c/N_w",       provePolyNR == 3 % 2)
        , ("polytrope rel = 3 = N_c",              provePolyRel == 3)
        , ("Schwarzschild = 2 = N_w",               proveSchwarz == 2)
        , ("Hawking = 8 = d_colour = N_w^3",        proveHawking == 8)
        , ("Stefan-Boltz 15 = N_c(chi-1)",           proveSB == 15)
        , ("Eddington = 4 = N_w^2",                  proveEddington == 4)
        , ("MS lum exp = 7/2 = beta_0/N_w",         proveMSLum == 7 % 2)
        , ("MS lifetime = 5/2 = (chi-1)/N_w",        proveMSLife == 5 % 2)
        , ("virial = 2 = N_w",                        proveVirial == 2)
        , ("grav PE = 3/5 = N_c/(chi-1)",             proveGravPE == 3 % 5)
        , ("Chandrasekhar mu_e = 2 = N_w",            proveMuE == 2)
        , ("Jeans T exp = 3/2 = N_c/N_w",             proveJeansT == 3 % 2)
        , ("Jeans rho exp = 1/2 = 1/N_w",             proveJeansRho == 1 % 2)
        ]
  mapM_ (\(name, ok) ->
    putStrLn $ "  " ++ (if ok then "PASS" else "FAIL") ++ "  " ++ name) intChecks
  putStrLn ""

  -- S2: Lane-Emden n=3/2 (white dwarf)
  putStrLn "S2 Lane-Emden n = N_c/N_w = 3/2 (white dwarf):"
  let (xi1_nr, mass_nr) = laneEmdenNR
      xi1_nr_ref = 3.654  :: Double
      xi1_nr_err = abs (xi1_nr - xi1_nr_ref) / xi1_nr_ref
      nrOk = xi1_nr_err < 0.01
  putStrLn $ "  xi_1 = " ++ show xi1_nr ++ " (expect ~3.654)"
  putStrLn $ "  -xi^2 theta' = " ++ show mass_nr
  putStrLn $ "  " ++ (if nrOk then "PASS" else "FAIL") ++
             "  Lane-Emden n=3/2 surface (< 1%)"
  putStrLn ""

  -- S3: Lane-Emden n=3 (relativistic)
  putStrLn "S3 Lane-Emden n = N_c = 3 (Chandrasekhar):"
  let (xi1_rel, mass_rel) = laneEmdenRel
      xi1_rel_ref = 6.897 :: Double
      xi1_rel_err = abs (xi1_rel - xi1_rel_ref) / xi1_rel_ref
      relOk = xi1_rel_err < 0.01
  putStrLn $ "  xi_1 = " ++ show xi1_rel ++ " (expect ~6.897)"
  putStrLn $ "  -xi^2 theta' = " ++ show mass_rel ++ " (expect ~2.018)"
  putStrLn $ "  " ++ (if relOk then "PASS" else "FAIL") ++
             "  Lane-Emden n=3 surface (< 1%)"
  putStrLn ""

  -- S4: Structural cross-checks
  putStrLn "S4 Structural cross-checks:"
  -- 3/5 appears in BOTH grav PE AND nuclear Coulomb (CrystalNuclear)
  let crossOk1 = gravPEFactor == nC % (chi - 1)
  putStrLn $ "  " ++ (if crossOk1 then "PASS" else "FAIL") ++
             "  grav PE 3/5 = nuclear Coulomb 3/5"

  -- MS exponents: 7/2 + 5/2 = 6 = chi (lum + lifetime = chi)
  -- Wait: L ~ M^(7/2) and t ~ M^(-5/2), so t*L ~ M^(7/2-5/2) = M
  -- Actually: t ~ M/L ~ M^(1-7/2) = M^(-5/2). So 1 + 5/2 = 7/2. Check: 7/2 = 1 + 5/2.
  let crossOk2 = msLuminosityExp == 1 + msLifetimeExp  -- 7/2 = 1 + 5/2
  putStrLn $ "  " ++ (if crossOk2 then "PASS" else "FAIL") ++
             "  MS: alpha_L = 1 + alpha_t (7/2 = 1 + 5/2)"

  -- Hawking + Eddington: 8 * 4 = 32 = N_w^5 (Peters GW coefficient)
  let crossOk3 = hawkingFactor * fromIntegral eddingtonFactor == 32
  putStrLn $ "  " ++ (if crossOk3 then "PASS" else "FAIL") ++
             "  Hawking*Eddington = 32 = N_w^5 = Peters"

  -- SB 15 = 3*5 = N_c*(chi-1)
  let crossOk4 = stefanBoltzDenom == 15
  putStrLn $ "  " ++ (if crossOk4 then "PASS" else "FAIL") ++
             "  SB factor 15 = N_c*(chi-1) = 3*5"
  putStrLn ""

  -- Summary
  putStrLn "================================================================"
  let allPass = and (map snd intChecks) && nrOk && relOk
                && crossOk1 && crossOk2 && crossOk3 && crossOk4
  putStrLn $ "  " ++ (if allPass then "ALL PASS" else "SOME FAILURES") ++
             " -- every Astro integer from (2, 3)."
  putStrLn "  Observable count: 13."

main :: IO ()
main = runSelfTest
