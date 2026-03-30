-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- GravityDynTest.hs — Test driver for CrystalGravityDyn
module Main where

import CrystalGravityDyn

main :: IO ()
main = do
    putStrLn "=== CrystalGravityDyn Audit ==="
    mapM_ (putStrLn . showAudit) gravityAudit
    putStrLn $ if allGravityPass
               then "ALL 12 PASS PASS"
               else "SOME FAILED FAIL"
    -- Verify specific values
    putStrLn $ "16piG = " ++ show proveCoeff16piG
    putStrLn $ "Schwarzschild = " ++ show proveSchwarzschild2
    putStrLn $ "RT 4G = " ++ show proveRT4
    putStrLn $ "EFE 8 = " ++ show proveEFE8
    putStrLn $ "GW speed = " ++ show proveGWSpeed
    putStrLn $ "Polarizations = " ++ show proveGWPolarizations
    putStrLn $ "Quad 32 = " ++ show proveQuadrupole32
    putStrLn $ "Quad 5 = " ++ show proveQuadrupole5
    putStrLn $ "Quadrupole ratio = " ++ show proveQuadrupoleRatio
    putStrLn $ "Kolmogorov = " ++ show proveKolmogorov
    putStrLn $ "Equiv = " ++ show proveEquivPrinciple
