-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | ObservableBio.hs — Component 7 (Bio): Genetics, protein folding, chemistry

  ALL observables are dimensionless (Shift = 0). No VEV dependence.
  No implosion corrections. No downstream correction issues.

  Compile: ghc -O2 -main-is ObservableBio ObservableBio.hs && ./ObservableBio
-}

module ObservableBio (allBio, main) where

import CrystalAtoms hiding (main)
import ObservableType
import Numeric (showFFloat)

-- =====================================================================
-- FOUR-COLUMN OBSERVABLE (same pattern)
-- =====================================================================

-- =====================================================================
-- GENETIC CODE (all EXACT, Level 0)
-- =====================================================================

obsDNABases :: Obs
obsDNABases = mk "DNA bases" "N_w^2 = 4"
  (\_ -> nW_d * nW_d) 4.0 ExactInteger

obsCodons :: Obs
obsCodons = mk "Codons" "(N_w^2)^N_c = 64"
  (\_ -> (nW_d * nW_d) ** nC_d) 64.0 ExactInteger

obsAminoAcids :: Obs
obsAminoAcids = mk "Amino acids" "gauss+b0 = 13+7 = 20"
  (\_ -> gauss_d + beta0_d) 20.0 ExactInteger

obsCodonSignals :: Obs
obsCodonSignals = mk "Codon signals" "Nc*b0 = 3*7 = 21"
  (\_ -> nC_d * beta0_d) 21.0 ExactInteger

obsCodonRedundancy :: Obs
obsCodonRedundancy = mk "Codon redundancy" "(Nw^2)^Nc - Nc*b0 = D+1 = 43"
  (\_ -> (nW_d * nW_d) ** nC_d - nC_d * beta0_d) 43.0 ExactInteger

-- =====================================================================
-- DNA STRUCTURE
-- =====================================================================

obsATBonds :: Obs
obsATBonds = mk "A-T H-bonds" "N_w = 2"
  (\_ -> nW_d) 2.0 ExactInteger

obsGCBonds :: Obs
obsGCBonds = mk "G-C H-bonds" "N_c = 3"
  (\_ -> nC_d) 3.0 ExactInteger

obsGrooveRatio :: Obs
obsGrooveRatio = mk "DNA groove ratio" "11/chi = 11/6"
  (\_ -> 11.0 / chi_d) (22.0/12.0) ExactRational

-- =====================================================================
-- PROTEIN FOLDING
-- =====================================================================

obsHelixTurn :: Obs
obsHelixTurn = mk "a-helix res/turn" "Nc+Nc/(chi-1) = 18/5"
  (\_ -> nC_d + nC_d / (chi_d - 1.0)) 3.6 ExactRational

obsHelixRise :: Obs
obsHelixRise = mk "a-helix rise (A)" "N_c/N_w = 3/2"
  (\_ -> nC_d / nW_d) 1.5 ExactRational

obsBetaSheet :: Obs
obsBetaSheet = mk "b-sheet space (A)" "b0/N_w = 7/2"
  (\_ -> beta0_d / nW_d) 3.5 ExactRational

obsFlory :: Obs
obsFlory = mk "Flory exponent" "N_w/(chi-1) = 2/5"
  (\_ -> nW_d / (chi_d - 1.0)) 0.4 ExactRational

obsRamachandran :: Obs
obsRamachandran = mk "Ramachandran dof" "N_w = 2 (phi,psi)"
  (\_ -> nW_d) 2.0 ExactInteger

-- =====================================================================
-- CHEMISTRY
-- =====================================================================

-- Orbital capacities
obsSOrbital :: Obs
obsSOrbital = mk "s-orbital cap" "N_w = 2"
  (\_ -> nW_d) 2.0 ExactInteger

obsPOrbital :: Obs
obsPOrbital = mk "p-orbital cap" "chi = 6"
  (\_ -> chi_d) 6.0 ExactInteger

obsDOrbital :: Obs
obsDOrbital = mk "d-orbital cap" "N_w*(chi-1) = 10"
  (\_ -> nW_d * (chi_d - 1.0)) 10.0 ExactInteger

obsFOrbital :: Obs
obsFOrbital = mk "f-orbital cap" "N_w*b0 = 14"
  (\_ -> nW_d * beta0_d) 14.0 ExactInteger

obsBondAngle :: Obs
obsBondAngle = mk "Bond angle (deg)" "arccos(-1/Nc) = 109.47"
  (\_ -> acos (-1.0 / nC_d) * 180.0 / pi) 109.4712 SinglePi

-- H2 bond energy: Rydberg/N_c (dimensionless formula, value in eV)
obsH2Bond :: Obs
obsH2Bond = mk "H2 bond (eV)" "Rydberg/Nc"
  (\_ -> let alphaInv = fromIntegral (towerD + 1) * pi + log beta0_d
             alpha    = 1.0 / alphaInv
             meEv     = 0.51099895e6  -- m_e in eV (constant)
             ryd      = meEv * alpha * alpha / 2.0
         in ryd / nC_d)
  4.52 SinglePi

-- Lattice lock: Sigma_d / chi^2 = 36/36 = 1
obsLatticeLock :: Obs
obsLatticeLock = mk "Lattice lock" "Sd/chi^2 = 36/36 = 1"
  (\_ -> sigmaD_d / (chi_d * chi_d)) 1.0 ExactRational

-- =====================================================================
-- ALL
-- =====================================================================

allBio :: [Obs]
allBio =
  -- Genetic code
  [ obsDNABases, obsCodons, obsAminoAcids, obsCodonSignals, obsCodonRedundancy
  -- DNA structure
  , obsATBonds, obsGCBonds, obsGrooveRatio
  -- Protein folding
  , obsHelixTurn, obsHelixRise, obsBetaSheet, obsFlory, obsRamachandran
  -- Chemistry
  , obsSOrbital, obsPOrbital, obsDOrbital, obsFOrbital
  , obsBondAngle, obsH2Bond, obsLatticeLock
  ]

-- =====================================================================
-- OUTPUT
-- =====================================================================


main :: IO ()
main = do
  putStrLn "=================================================================="
  putStrLn " ObservableBio.hs -- Component 7 (Bio)"
  putStrLn " Genetics, protein folding, chemistry. All dimensionless."
  putStrLn "=================================================================="
  putStrLn ""
  putStrLn $ "  " ++ pr 20 "Name" ++ pr 30 "Formula"
           ++ pr 14 "Crystal" ++ pr 14 "CrystalPdg" ++ pr 14 "Expt"
           ++ pl 10 "Shift" ++ pl 10 "Gap" ++ "  Status"
  putStrLn $ "  " ++ replicate 122 '-'

  putStrLn "  --- Genetic Code ---"
  mapM_ row (take 5 allBio)
  putStrLn "  --- DNA Structure ---"
  mapM_ row (take 3 (drop 5 allBio))
  putStrLn "  --- Protein Folding ---"
  mapM_ row (take 5 (drop 8 allBio))
  putStrLn "  --- Chemistry ---"
  mapM_ row (drop 13 allBio)
  putStrLn ""

  check "All Shift = 0 (dimensionless)"
    (all (\o -> shiftPct o < 1e-10) allBio)
  check "DNA bases = 4" (abs (oCry obsDNABases - 4.0) < 1e-10)
  check "Codons = 64" (abs (oCry obsCodons - 64.0) < 1e-10)
  check "Amino acids = 20" (abs (oCry obsAminoAcids - 20.0) < 1e-10)
  check "Helix = 18/5" (abs (oCry obsHelixTurn - 18.0/5.0) < 1e-14)
  check "Flory = 2/5" (abs (oCry obsFlory - 2.0/5.0) < 1e-14)
  check "Lattice lock = 1" (abs (oCry obsLatticeLock - 1.0) < 1e-14)
  check "Bond angle = arccos(-1/3)" (abs (oCry obsBondAngle - 109.4712) < 0.001)
  putStrLn ""

  let gs = map gapPct allBio
  putStrLn $ "  " ++ show (length gs) ++ " obs"
           ++ " | mean gap " ++ showFFloat (Just 3) (sum gs / fromIntegral (length gs)) "%"
           ++ " | max " ++ showFFloat (Just 3) (maximum gs) "%"
           ++ " | <1%: " ++ show (length (filter (< 1.0) gs))
           ++ "/" ++ show (length gs)
  putStrLn "=================================================================="
