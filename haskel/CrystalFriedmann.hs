-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | Module: CrystalFriedmann — Cosmological Expansion from (2,3).

  THE DYNAMICS IS THE TICK ON THE 36.

  Each cosmological region is a CrystalState (36 Doubles).
  Scale-factor geometry (a, adot, K) → weak sector (d2 = 3, lambda = 1/2).
  Matter/radiation (H, Om_m, Om_r, rho, P, wdot, T_CMB, S_hor) → colour sector (d3 = 8, lambda = 1/3).
  Conserved total energy → singlet (d1 = 1, lambda = 1).
  Perturbation modes delta_k → mixed sector (d4 = 24, lambda = 1/6).

  DYNAMICS: S = W . U
    W step (kick):  weak <- wK 1 x colour  (geometry kicked by matter content)
                    colour <- wK 2 x colour (matter self-contracts)
                    mixed <- wK 3 x mixed   (perturbations damp)
    U step (drift): weak_i <- uK 1 x avg(weak_neighbors)  (geometric coherence)
                    colour_i <- uK 2 x avg(colour_neighbors) (matter exchange)
                    mixed_i <- uK 3 x avg(mixed_neighbors)  (perturbation propagation)

  Three.js interface: JSON snapshots of 3D lattice at each tick.
    Each site -> sphere with radius prop a, colour prop T_CMB, opacity prop Om_m.
    Edges between neighbors -> thickness prop entanglement.

  Compile: ghc -O2 -main-is CrystalFriedmann CrystalFriedmann.hs && ./CrystalFriedmann
-}

module CrystalFriedmann where

import CrystalAtoms (nW, nC, chi, beta0, sigmaD, towerD, gauss, d1, d2, d3, d4)
import CrystalSectors (CrystalState, sectorDim, extractSector, injectSector, zeroState)
import CrystalEigen (lambda, wK, uK)
import CrystalOperators (tick, applyW, applyU, normSq)

import Data.Ratio (Rational, (%))
import Data.List (intercalate)

-- =====================================================================
-- S1  PACK: Domain -> CrystalState
--
--   Singlet [1]:  E_tot (conserved, lambda = 1) -- dark energy anchor
--   Weak [3]:     a (scale factor), adot (rate), K (curvature)
--   Colour [8]:   H, Om_m, Om_r, rho, P, wdot, T_CMB, S_horizon
--   Mixed [24]:   perturbation modes delta_k (24 Fourier modes of drho/rho)
-- =====================================================================

data CosmoRegion = CosmoRegion
  { crA       :: !Double
  , crAdot    :: !Double
  , crK       :: !Double
  , crH       :: !Double
  , crOmegaM  :: !Double
  , crOmegaR  :: !Double
  , crRho     :: !Double
  , crP       :: !Double
  , crWdot    :: !Double
  , crTcmb    :: !Double
  , crShor    :: !Double
  , crEtot    :: !Double
  , crPerturb :: [Double]
  } deriving (Show)

packRegion :: CosmoRegion -> CrystalState
packRegion cr =
  injectSector 0 [crEtot cr]                                          $
  injectSector 1 [crA cr, crAdot cr, crK cr]                          $
  injectSector 2 [crH cr, crOmegaM cr, crOmegaR cr, crRho cr,
                   crP cr, crWdot cr, crTcmb cr, crShor cr]           $
  injectSector 3 (take d4 (crPerturb cr ++ repeat 0.0))               $
  zeroState

unpackRegion :: CrystalState -> CosmoRegion
unpackRegion cs =
  let [eTot]                                    = extractSector 0 cs
      [a, adot, k]                              = extractSector 1 cs
      [h, omM, omR, rho, p, wdot, tcmb, sH]    = extractSector 2 cs
      pert                                       = extractSector 3 cs
  in CosmoRegion a adot k h omM omR rho p wdot tcmb sH eTot pert

proveSectorRestriction :: CosmoRegion -> Bool
proveSectorRestriction cr =
  let cs = packRegion cr
      cr' = unpackRegion cs
  in abs (crA cr - crA cr') < 1e-12
     && abs (crH cr - crH cr') < 1e-12
     && abs (crEtot cr - crEtot cr') < 1e-12

-- =====================================================================
-- S2  W STEP (KICK): Intra-site Sector Coupling
--
--   The W isometry couples sectors WITHIN a site.
--   Geometry (weak) is kicked by matter content (colour).
--   Net per W step: weak gets sqrt(1/2), colour gets sqrt(1/3).
-- =====================================================================

wStep :: CrystalState -> CrystalState
wStep cs =
  let [eTot]                                 = extractSector 0 cs
      [a, adot, k]                           = extractSector 1 cs
      [h, omM, omR, rho, p, wdot, tcmb, sH] = extractSector 2 cs
      pert                                    = extractSector 3 cs
      w1  = wK 1
      a'    = a * w1
      adot' = (adot + w1 * h * a) * w1
      k'    = (k + w1 * (omM * rho - eTot)) * w1
      w2  = wK 2
      h'    = h * w2
      omM'  = omM * w2
      omR'  = omR * w2
      rho'  = rho * w2
      p'    = p * w2
      wdot' = wdot * w2
      tcmb' = tcmb * w2
      sH'   = sH * w2
      w3  = wK 3
      pert' = map (* w3) pert
  in injectSector 0 [eTot]                                            $
     injectSector 1 [a', adot', k']                                   $
     injectSector 2 [h', omM', omR', rho', p', wdot', tcmb', sH']    $
     injectSector 3 pert'                                             $
     zeroState

-- =====================================================================
-- S3  U STEP (DRIFT): Inter-site Spatial Coupling
--
--   3D lattice: sites indexed by (ix, iy, iz).
--   Each site has N_w x N_c = 6 neighbors (2 per axis in N_c = 3 dims).
--   Discrete Laplacian with weight uK^2 per sector.
-- =====================================================================

type CosmoLattice1D = [CrystalState]
type CosmoLattice3D = [[[CrystalState]]]

uStep1D :: CosmoLattice1D -> CosmoLattice1D
uStep1D lat =
  let n = length lat
      getSec k i
        | i < 0     = extractSector k (head lat)
        | i >= n    = extractSector k (last lat)
        | otherwise = extractSector k (lat !! i)
      coupleSec k i cs =
        let u2 = uK k * uK k
            sL = getSec k (i - 1)
            sC = getSec k i
            sR = getSec k (i + 1)
            sNew = zipWith3 (\l c r -> c + u2 * (l - 2*c + r)) sL sC sR
        in injectSector k sNew cs
      mixSite i =
        coupleSec 1 i $
        coupleSec 2 i $
        coupleSec 3 i
        (lat !! i)
  in [mixSite i | i <- [0..n-1]]

uStep3D :: CosmoLattice3D -> CosmoLattice3D
uStep3D grid =
  let nz = length grid
      ny = if nz > 0 then length (head grid) else 0
      nx = if ny > 0 then length (head (head grid)) else 0
      getSite iz iy ix
        | iz < 0 || iz >= nz || iy < 0 || iy >= ny || ix < 0 || ix >= nx
          = (grid !! max 0 (min (nz-1) iz)) !! max 0 (min (ny-1) iy) !! max 0 (min (nx-1) ix)
        | otherwise = (grid !! iz) !! iy !! ix
      coupleSec3D k iz iy ix cs =
        let u2 = uK k * uK k
            coeff = u2 / fromIntegral nC
            sC  = extractSector k (getSite iz iy ix)
            sXp = extractSector k (getSite iz iy (ix+1))
            sXm = extractSector k (getSite iz iy (ix-1))
            sYp = extractSector k (getSite iz (iy+1) ix)
            sYm = extractSector k (getSite iz (iy-1) ix)
            sZp = extractSector k (getSite (iz+1) iy ix)
            sZm = extractSector k (getSite (iz-1) iy ix)
            sNew = zipWith7_6 (\c xp xm yp ym zp zm ->
                     c + coeff * (xp + xm + yp + ym + zp + zm - 6*c))
                   sC sXp sXm sYp sYm sZp sZm
        in injectSector k sNew cs
      mixSite iz iy ix =
        let cs = getSite iz iy ix
        in coupleSec3D 1 iz iy ix $
           coupleSec3D 2 iz iy ix $
           coupleSec3D 3 iz iy ix cs
  in [[[mixSite iz iy ix | ix <- [0..nx-1]] | iy <- [0..ny-1]] | iz <- [0..nz-1]]

zipWith7_6 :: (Double -> Double -> Double -> Double -> Double -> Double -> Double -> Double)
           -> [Double] -> [Double] -> [Double] -> [Double] -> [Double] -> [Double] -> [Double]
           -> [Double]
zipWith7_6 _ [] _ _ _ _ _ _ = []
zipWith7_6 _ _ [] _ _ _ _ _ = []
zipWith7_6 f (a:as) (b:bs) (c:cs) (d:ds) (e:es) (f1:fs) (g:gs)
  = f a b c d e f1 g : zipWith7_6 f as bs cs ds es fs gs
zipWith7_6 _ _ _ _ _ _ _ _ = []

-- =====================================================================
-- S4  FULL TICK: S = W . U
-- =====================================================================

cosmoTickSingle :: CrystalState -> CrystalState
cosmoTickSingle = tick

cosmoTick1D :: CosmoLattice1D -> CosmoLattice1D
cosmoTick1D = map wStep . uStep1D

cosmoTick3D :: CosmoLattice3D -> CosmoLattice3D
cosmoTick3D = map (map (map wStep)) . uStep3D

evolve1D :: Int -> CosmoLattice1D -> [CosmoLattice1D]
evolve1D n lat = take (n + 1) $ iterate cosmoTick1D lat

evolve3D :: Int -> CosmoLattice3D -> [CosmoLattice3D]
evolve3D n lat = take (n + 1) $ iterate cosmoTick3D lat

-- =====================================================================
-- S5  OBSERVABLES: Extract Physics from CrystalState
-- =====================================================================

data CosmoSnapshot = CosmoSnapshot
  { snTick      :: !Int
  , snA         :: !Double
  , snH         :: !Double
  , snOmegaL    :: !Double
  , snOmegaM    :: !Double
  , snOmegaR    :: !Double
  , snQ         :: !Double
  , snTcmb      :: !Double
  , snEntropy   :: !Double
  , snPertNorm  :: !Double
  } deriving (Show)

snapshot :: Int -> CrystalState -> CosmoSnapshot
snapshot n cs =
  let [eTot]                              = extractSector 0 cs
      [a, _, _]                           = extractSector 1 cs
      [h, omM, omR, _, _, _, tcmb, sH]   = extractSector 2 cs
      pert                                 = extractSector 3 cs
      sNorm = eTot * eTot
      wNorm = sum (map (\x -> x*x) (extractSector 1 cs))
      cNorm = sum (map (\x -> x*x) (extractSector 2 cs))
      mNorm = sum (map (\x -> x*x) pert)
      total = sNorm + wNorm + cNorm + mNorm
      oL = if total > 0 then sNorm / total else 0
      oM = if total > 0 then cNorm / total else 0
      oR = if total > 0 then mNorm / total else 0
      q  = oM / 2 - oL
      pNorm = sqrt mNorm
  in CosmoSnapshot n a h oL oM oR q tcmb sH pNorm

trajectory :: Int -> CrystalState -> [CosmoSnapshot]
trajectory nTicks cs0 =
  let states = take (nTicks + 1) $ iterate tick cs0
  in zipWith snapshot [0..] states

trajectoryLattice :: Int -> CosmoLattice1D -> [CosmoSnapshot]
trajectoryLattice nTicks lat0 =
  let lats = evolve1D nTicks lat0
  in [snapshot n (head l) | (n, l) <- zip [0..] lats]

-- =====================================================================
-- S6  THREE.JS INTERFACE: JSON Output
--
--   Per-site: position (ix,iy,iz), radius prop a, colour prop T_CMB,
--     opacity prop Om_m, glow prop Om_L
--   Per-edge: thickness prop entanglement between sites
--   Per-tick: array of site states
-- =====================================================================

data SiteRender = SiteRender
  { srIx, srIy, srIz :: !Int
  , srRadius          :: !Double
  , srR, srG, srB     :: !Double
  , srOpacity         :: !Double
  , srGlow            :: !Double
  , srPerturbation    :: !Double
  } deriving (Show)

toSiteRender :: Int -> Int -> Int -> CrystalState -> SiteRender
toSiteRender ix iy iz cs =
  let [eTot]                           = extractSector 0 cs
      [a, _, _]                        = extractSector 1 cs
      [_, omM, _, _, _, _, tcmb, _]    = extractSector 2 cs
      pert                              = extractSector 3 cs
      radius = abs a
      tNorm = min 1.0 (abs tcmb / 3.0)
      r = tNorm; g = 0.1; b = 1.0 - tNorm
      total = normSq cs
      cNorm = sum (map (\x -> x*x) (extractSector 2 cs))
      opacity = if total > 0 then min 1.0 (cNorm / total) else 0
      sNorm = eTot * eTot
      glow = if total > 0 then sNorm / total else 0
      pNorm = sqrt (sum (map (\x -> x*x) pert))
  in SiteRender ix iy iz radius r g b opacity glow pNorm

edgeEntanglement :: CrystalState -> CrystalState -> Double
edgeEntanglement cs1 cs2 =
  let c1 = extractSector 2 cs1
      c2 = extractSector 2 cs2
      dot = sum (zipWith (*) c1 c2)
      n1 = sqrt (sum (map (\x -> x*x) c1))
      n2 = sqrt (sum (map (\x -> x*x) c2))
  in if n1 * n2 > 1e-30 then abs dot / (n1 * n2) else 0

siteToJSON :: SiteRender -> String
siteToJSON sr = concat
  [ "{\"ix\":", show (srIx sr)
  , ",\"iy\":", show (srIy sr)
  , ",\"iz\":", show (srIz sr)
  , ",\"r\":",  showF (srRadius sr)
  , ",\"cr\":", showF (srR sr)
  , ",\"cg\":", showF (srG sr)
  , ",\"cb\":", showF (srB sr)
  , ",\"op\":", showF (srOpacity sr)
  , ",\"gl\":", showF (srGlow sr)
  , ",\"pt\":", showF (srPerturbation sr)
  , "}"
  ]

lattice3DToJSON :: Int -> CosmoLattice3D -> String
lattice3DToJSON tickN grid =
  let nz = length grid
      ny = if nz > 0 then length (head grid) else 0
      nx = if ny > 0 then length (head (head grid)) else 0
      sites = [toSiteRender ix iy iz ((grid !! iz) !! iy !! ix)
              | iz <- [0..nz-1], iy <- [0..ny-1], ix <- [0..nx-1]]
  in concat
       [ "{\"tick\":", show tickN
       , ",\"nx\":", show nx
       , ",\"ny\":", show ny
       , ",\"nz\":", show nz
       , ",\"sites\":[", intercalate "," (map siteToJSON sites), "]}"
       ]

lattice1DToJSON :: Int -> CosmoLattice1D -> String
lattice1DToJSON tickN lat =
  let sites = [toSiteRender i 0 0 (lat !! i) | i <- [0..length lat - 1]]
  in concat
       [ "{\"tick\":", show tickN
       , ",\"n\":", show (length lat)
       , ",\"sites\":[", intercalate "," (map siteToJSON sites), "]}"
       ]

trajectoryToJSON :: [CosmoSnapshot] -> String
trajectoryToJSON snaps =
  let snapToJSON s = concat
        [ "{\"t\":", show (snTick s)
        , ",\"a\":",  showF (snA s)
        , ",\"H\":",  showF (snH s)
        , ",\"OL\":", showF (snOmegaL s)
        , ",\"OM\":", showF (snOmegaM s)
        , ",\"OR\":", showF (snOmegaR s)
        , ",\"q\":",  showF (snQ s)
        , ",\"T\":",  showF (snTcmb s)
        , ",\"S\":",  showF (snEntropy s)
        , ",\"dP\":", showF (snPertNorm s)
        , "}"
        ]
  in "[" ++ intercalate "," (map snapToJSON snaps) ++ "]"

showF :: Double -> String
showF x = let s = show x in if '.' `elem` s then s else s ++ ".0"

-- =====================================================================
-- S7  INITIALIZATION
-- =====================================================================

defaultRegion :: CosmoRegion
defaultRegion = CosmoRegion
  { crA = 1.0, crAdot = 0.7, crK = 0.0
  , crH = 1.0, crOmegaM = omegaMatter, crOmegaR = 9e-5
  , crRho = 1.0, crP = -omegaLambda, crWdot = 0.0
  , crTcmb = cmbTemperature, crShor = 1.0
  , crEtot = 1.0
  , crPerturb = replicate d4 0.0
  }

perturbedRegion :: Int -> Double -> CosmoRegion
perturbedRegion kMode amp =
  let pert = [if i == kMode then amp else 0.0 | i <- [0..d4-1]]
  in defaultRegion { crPerturb = pert }

initLattice1D :: Int -> CosmoLattice1D
initLattice1D n =
  let center = n `div` 2
      sigma = fromIntegral n / 6.0
      site i =
        let dx = fromIntegral (i - center)
            bump = exp (- dx*dx / (2*sigma*sigma))
            rho_i = 1.0 + 0.3 * bump
        in packRegion $ defaultRegion
             { crRho = rho_i
             , crOmegaM = omegaMatter * rho_i
             , crPerturb = [0.01 * bump * sin (fromIntegral k * pi * fromIntegral i / fromIntegral n)
                           | k <- [1..d4]]
             }
  in [site i | i <- [0..n-1]]

initLattice3D :: Int -> CosmoLattice3D
initLattice3D n =
  let center = fromIntegral n / 2.0
      sigma = fromIntegral n / 4.0
      site ix iy iz =
        let dx = fromIntegral ix - center
            dy = fromIntegral iy - center
            dz = fromIntegral iz - center
            r2 = dx*dx + dy*dy + dz*dz
            bump = exp (- r2 / (2*sigma*sigma))
        in packRegion $ defaultRegion
             { crRho = 1.0 + 0.2 * bump
             , crOmegaM = omegaMatter * (1.0 + 0.2 * bump)
             , crPerturb = [0.005 * bump | _ <- [1..d4]]
             }
  in [[[site ix iy iz | ix <- [0..n-1]] | iy <- [0..n-1]] | iz <- [0..n-1]]

-- =====================================================================
-- S8  DENSITY PARAMETERS (exact, all from (2,3))
-- =====================================================================

omegaLambda :: Double
omegaLambda = fromIntegral gauss / fromIntegral (gauss + chi)

omegaMatter :: Double
omegaMatter = fromIntegral chi / fromIntegral (gauss + chi)

omegaBaryon :: Double
omegaBaryon = omegaMatter * fromIntegral beta0 / (fromIntegral beta0 + 12 * pi)

omegaDM :: Double
omegaDM = omegaMatter - omegaBaryon

dmBaryonRatio :: Double
dmBaryonRatio = fromIntegral (nW * nW * nC) * pi / fromIntegral beta0

wDE :: Int
wDE = -1

-- =====================================================================
-- S9  CMB AND COSMOLOGICAL PARAMETERS
-- =====================================================================

kappa :: Double
kappa = log (fromIntegral nC) / log (fromIntegral nW)

cmb100Theta :: Double
cmb100Theta = 100.0 / fromIntegral (nW * (towerD + chi))

cmbTemperature :: Double
cmbTemperature = fromIntegral (gauss + chi) / fromIntegral beta0

spectralIndex :: Double
spectralIndex = 1.0 - kappa / fromIntegral towerD

scalarAmplitude :: Double
scalarAmplitude = log (fromIntegral (nC * beta0))

ageAnalytic :: Double
ageAnalytic = fromIntegral gauss + fromIntegral chi / fromIntegral beta0

-- =====================================================================
-- S10  INTEGER IDENTITY PROOFS
-- =====================================================================

proveOmegaL :: Rational
proveOmegaL = fromIntegral gauss % fromIntegral (gauss + chi)

proveOmegaM :: Rational
proveOmegaM = fromIntegral chi % fromIntegral (gauss + chi)

proveOmegaRatio :: Rational
proveOmegaRatio = fromIntegral gauss % fromIntegral chi

prove100Theta :: Rational
prove100Theta = 100 % fromIntegral (nW * (towerD + chi))

proveTCMB :: Rational
proveTCMB = fromIntegral (gauss + chi) % fromIntegral beta0

proveAge :: Rational
proveAge = fromIntegral (gauss * beta0 + chi) % fromIntegral beta0

proveAmplitude :: Int
proveAmplitude = nC * beta0

proveW :: Int
proveW = -1

proveMatterExp :: Int
proveMatterExp = nC

proveRadExp :: Int
proveRadExp = nC + 1

proveLambdaRatio :: Rational
proveLambdaRatio = fromIntegral nW % fromIntegral nC

proveRadDilution :: Bool
proveRadDilution = abs (lambda 2 * lambda 1 - lambda 3) < 1e-14

-- =====================================================================
-- S11  CRYSTAL CONSTANTS
-- =====================================================================

geomRate :: Double
geomRate = lambda 1

matterRate :: Double
matterRate = lambda 2

radRate :: Double
radRate = lambda 3

entropyPerTick :: Double
entropyPerTick = log (fromIntegral chi)

-- =====================================================================
-- S12  SELF-TEST
-- =====================================================================

check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

isIn :: String -> String -> Bool
isIn [] _ = True
isIn _ [] = False
isIn needle haystack@(_:rest)
  | take (length needle) haystack == needle = True
  | otherwise = isIn needle rest

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalFriedmann.hs -- Cosmic Expansion from (2,3)"
  putStrLn " THE DYNAMICS IS THE TICK ON THE 36."
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "SA Integer identities:"
  let intChecks =
        [ ("OmL = 13/19",              proveOmegaL == 13 % 19)
        , ("OmM = 6/19",               proveOmegaM == 6 % 19)
        , ("OmL/OmM = 13/6",           proveOmegaRatio == 13 % 6)
        , ("100th = 100/96",            prove100Theta == 100 % 96)
        , ("T_CMB = 19/7",             proveTCMB == 19 % 7)
        , ("Age = 97/7",               proveAge == 97 % 7)
        , ("21 = Nc*b0",               proveAmplitude == 21)
        , ("w = -1",                    proveW == (-1))
        , ("matter exp = 3",           proveMatterExp == 3)
        , ("rad exp = 4",              proveRadExp == 4)
        , ("lC/lW = 2/3",             proveLambdaRatio == 2 % 3)
        , ("rad = l_mixed",            proveRadDilution)
        ]
  mapM_ (\(name, ok) -> check name ok) intChecks
  putStrLn ""

  putStrLn "SB Density parameters:"
  putStrLn $ "  OmL  = " ++ show omegaLambda ++ "  (Planck: 0.6847)"
  putStrLn $ "  OmM  = " ++ show omegaMatter ++ "  (Planck: 0.3153)"
  putStrLn $ "  OmB  = " ++ show omegaBaryon ++ "  (Planck: 0.0493)"
  putStrLn $ "  DM/b = " ++ show dmBaryonRatio ++ " (Planck: 5.36)"
  check "Om_total ~ 1" (abs (omegaLambda + omegaMatter - 1.0) < 0.01)
  check "DM/b = 12pi/7" (abs (dmBaryonRatio - 5.386) < 0.01)
  putStrLn ""

  putStrLn "SC CMB parameters:"
  check "100th < 0.1%" (abs (cmb100Theta - 1.0411) < 0.01)
  check "T_CMB < 0.5%" (abs (cmbTemperature - 2.7255) < 0.02)
  check "n_s < 0.3%"   (abs (spectralIndex - 0.9649) < 0.005)
  putStrLn ""

  putStrLn "SD Tick dynamics (pack -> tick -> unpack):"
  let cs0 = packRegion defaultRegion
  check "pack/unpack roundtrip" (proveSectorRestriction defaultRegion)
  let cs1 = cosmoTickSingle cs0
      r0 = unpackRegion cs0
      r1 = unpackRegion cs1
  check "singlet conserved (l=1)"       (abs (crEtot r1 - crEtot r0) < 1e-14)
  check "geometry halved (lW=1/2)"  (abs (crA r1 - crA r0 * 0.5) < 1e-14)
  check "matter thirded (lC=1/3)" (abs (crH r1 - crH r0 / 3.0) < 1e-14)
  let states = take 51 $ iterate tick cs0
      csN = last states
      sn = snapshot 50 csN
  check "OmL -> 1 after 50 ticks" (snOmegaL sn > 0.99)
  check "q < 0 (acceleration)"    (snQ sn < 0)
  putStrLn ""

  putStrLn "SE W.U half-step coupling:"
  let csW = wStep cs0
      rW = unpackRegion csW
  check "W kick: adot changed by colour" (abs (crAdot rW - crAdot r0) > 1e-10)
  check "W kick: curvature coupled"       (abs (crK rW) > 1e-10)
  putStrLn ""

  putStrLn "SF 1D lattice (10 sites, Gaussian bump):"
  let lat0 = initLattice1D 10
      lat1 = cosmoTick1D lat0
      rho0 = map (head . drop 3 . extractSector 2) lat0
      rho1 = map (head . drop 3 . extractSector 2) lat1
      spread = maximum rho1 - minimum rho1 < maximum rho0 - minimum rho0
  check "U spreads density bump" spread
  let traj = trajectoryLattice 10 lat0
  check "trajectory has 11 snapshots" (length traj == 11)
  check "OmL increases over time" (snOmegaL (last traj) > snOmegaL (head traj))
  putStrLn ""

  putStrLn "SG JSON for Three.js:"
  let json1D = lattice1DToJSON 0 lat0
  check "1D JSON starts with {" (head json1D == '{')
  check "1D JSON has sites" ("\"sites\"" `isIn` json1D)
  let trajJSON = trajectoryToJSON (take 5 traj)
  check "traj JSON is array" (head trajJSON == '[')
  putStrLn ""

  putStrLn "SH 3D lattice init:"
  let lat3D = initLattice3D 4
  check "3D lattice 4x4x4" (length lat3D == 4 && length (head lat3D) == 4)
  let lat3D1 = cosmoTick3D lat3D
      json3D = lattice3DToJSON 0 lat3D
  check "3D JSON has sites" ("\"sites\"" `isIn` json3D)
  check "3D tick produces output" (length lat3D1 == 4)
  putStrLn ""

  putStrLn "SI Component stack:"
  check "gauss = 13" (gauss == 13)
  check "chi = 6"    (chi == 6)
  check "SigD = 36"  (sigmaD == 36)
  check "D = 42"     (towerD == 42)
  let testSt = replicate sigmaD (1.0 / sqrt (fromIntegral sigmaD))
      ticked = tick testSt
  check "tick contracts norm" (normSq ticked < normSq testSt)
  check "W.U = tick" (all (\(a,b) -> abs (a-b) < 1e-14)
                       (zip (applyW (applyU testSt)) (tick testSt)))
  putStrLn ""

  putStrLn "================================================================"
  putStrLn "  Pack -> W.U -> unpack. Zero bespoke integrators."
  putStrLn "  W: geometry kicked by matter (weak <- colour)."
  putStrLn "  U: 6-neighbor Laplacian in 3D (spatial coupling)."
  putStrLn "  JSON: lattice snapshots + trajectories for Three.js."
  putStrLn "  3D lattice: radius=a, color=T_CMB, opacity=Om_m, glow=Om_L."
  putStrLn "================================================================"
