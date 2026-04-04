{-# LANGUAGE BangPatterns #-}
-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{- | CrystalFold.hs — Protein Folding from (2,3) v2

  1. 3D GEOMETRY: dihedrals from colour sector → 3D backbone via rotations
  2. SIDE CHAINS: Cβ centroid, 9 DOF/residue, 4×9≈36=Σd per tile
  3. SEQUENCE-DEPENDENT: amino acid identity sets initial amplitudes

  Sector layout:
    Singlet (d=1):  bond length — λ=1 (conserved topology)
    Weak    (d=3):  tile COM — λ=1/2 (hydrophobic collapse)
    Colour  (d=8):  4×(φ,ψ) dihedrals — λ=1/3 (angle relaxation)
    Mixed   (d=24): 4×(x,y,z,scX,scY,scZ) — λ=1/6 (refinement)

  ghc -O2 -main-is CrystalFold CrystalFold.hs && ./CrystalFold
-}

module CrystalFold where

import Data.List (foldl')
import CrystalEngine
  ( nW, nC, chi, beta0, sigmaD, towerD, gauss
  , d1, d2, d3, d4
  , lambda, CrystalState
  , sectorDim, extractSector, injectSector
  , normSq, tick, zeroState
  )

-- §0 Constants
caBondLength :: Double
caBondLength = 3.8

helixPhi, helixPsi, sheetPhi, sheetPsi :: Double
helixPhi = -1.047;  helixPsi = -0.820
sheetPhi = -2.094;  sheetPsi =  2.094

helixPerTurn :: Double
helixPerTurn = fromIntegral (nC*nC*nW) / fromIntegral (chi-1)

floryNu :: Double
floryNu = fromIntegral nW / fromIntegral (chi-1)

contactCutoff :: Double
contactCutoff = fromIntegral d3

-- §1 Amino acids (20 = N_w²(χ-1))
data AminoAcid = Ala|Arg|Asn|Asp|Cys|Gln|Glu|Gly|His|Ile
               |Leu|Lys|Met|Phe|Pro|Ser|Thr|Trp|Tyr|Val
               deriving (Show, Eq, Enum, Bounded, Ord)

hydrophobicity :: AminoAcid -> Double
hydrophobicity aa = case aa of
  Ile->1.0;  Val->0.93; Leu->0.87; Phe->0.73; Cys->0.60
  Met->0.47; Ala->0.47; Gly->0.13; Thr->0.0;  Ser->(-0.07)
  Trp->(-0.07); Tyr->(-0.27); Pro->(-0.40); His->(-0.67)
  Gln->(-0.73); Asn->(-0.73); Glu->(-0.73); Asp->(-0.73)
  Lys->(-0.80); Arg->(-1.0)

helixPropensity :: AminoAcid -> Double
helixPropensity aa = case aa of
  Ala->1.0;  Leu->0.79; Met->0.74; Glu->0.68; Gln->0.65
  Lys->0.59; Arg->0.55; His->0.50; Val->0.47; Ile->0.41
  Tyr->0.38; Trp->0.35; Phe->0.35; Cys->0.32; Asp->0.30
  Thr->0.26; Asn->0.23; Ser->0.21; Gly->0.15; Pro->0.0

scRadius :: AminoAcid -> Double
scRadius aa = case aa of
  Gly->0.0; Ala->1.5; Val->2.1; Leu->2.8; Ile->2.5; Pro->1.9
  Phe->3.4; Trp->3.8; Tyr->3.5; Met->3.0; Cys->2.0; Ser->1.8
  Thr->2.0; Asp->2.4; Glu->2.8; Asn->2.4; Gln->2.8; Lys->3.2
  Arg->3.5; His->2.8

-- §2 Residue: 9 DOF
data Residue = Residue
  { resX, resY, resZ :: !Double
  , resPhi, resPsi   :: !Double
  , resScX, resScY, resScZ :: !Double
  , resAA :: !AminoAcid
  } deriving (Show)

residueDistance :: Residue -> Residue -> Double
residueDistance r1 r2 =
  let dx=resX r1-resX r2; dy=resY r1-resY r2; dz=resZ r1-resZ r2
  in sqrt (dx*dx+dy*dy+dz*dz)

emptyRes :: Residue
emptyRes = Residue 0 0 0 helixPhi helixPsi 0 0 0 Gly

-- §3 3D backbone from dihedrals (cos/sin in RECONSTRUCTION, not tick)
buildBackbone :: Double -> [(Double,Double)] -> [(Double,Double,Double)]
buildBackbone bond pps = go (0,0,0) (1,0,0) (0,1,0) pps
  where
    go pos _ _ [] = [pos]
    go (px,py,pz) (fx,fy,fz) (ux,uy,uz) ((phi,psi):rest) =
      let rx=fy*uz-fz*uy; ry=fz*ux-fx*uz; rz=fx*uy-fy*ux
          cp=cos psi; sp=sin psi
          fx'=fx*cp+rx*sp; fy'=fy*cp+ry*sp; fz'=fz*cp+rz*sp
          cf=cos phi; sf=sin phi
          fx''=fx'*cf+ux*sf; fy''=fy'*cf+uy*sf; fz''=fz'*cf+uz*sf
          ux'=fy''*rz-fz''*ry; uy'=fz''*rx-fx''*rz; uz'=fx''*ry-fy''*rx
          ul=sqrt(ux'*ux'+uy'*uy'+uz'*uz')
          un=if ul>1e-10 then (ux'/ul,uy'/ul,uz'/ul) else (ux,uy,uz)
          fl=sqrt(fx''*fx''+fy''*fy''+fz''*fz'')
          fn=if fl>1e-10 then (fx''/fl,fy''/fl,fz''/fl) else (fx,fy,fz)
          (fnx,fny,fnz)=fn; (unx,uny,unz)=un
      in (px,py,pz) : go (px+bond*fnx,py+bond*fny,pz+bond*fnz) fn un rest

placeSideChain :: (Double,Double,Double)->(Double,Double,Double)->AminoAcid
               -> (Double,Double,Double)
placeSideChain (cx,cy,cz) (nx,ny,nz) aa =
  let r=scRadius aa
      dx=nx-cx; dy=ny-cy; dz=nz-cz
      dl=sqrt(dx*dx+dy*dy+dz*dz)
      (px,py,pz)=if abs dz<0.9*dl then (dy,-dx,0) else (0,dz,-dy)
      pl=sqrt(px*px+py*py+pz*pz)
  in if pl>1e-10 && r>0 then (cx+r*px/pl,cy+r*py/pl,cz+r*pz/pl)
     else (cx,cy,cz)

-- §4 Tile (4 residues)
data Tile = Tile { tileRes :: ![Residue] } deriving (Show)
tileResidues :: Tile -> [Residue]
tileResidues = tileRes
tileFromList :: [Residue] -> Tile
tileFromList rs = Tile (take 4 (rs ++ repeat emptyRes))

-- §5 Tile ↔ CrystalState

-- | PAIR dihedral target (strict, no intermediate list)
targetPP :: AminoAcid -> AminoAcid -> (Double, Double)
targetPP _   Pro = (-1.309, 2.618)
targetPP Pro _   = (-1.047, 2.618)
targetPP Gly _   = (-1.396, 0.0)
targetPP aa  _   = let !hp=helixPropensity aa
                   in (helixPhi*hp+sheetPhi*(1-hp), helixPsi*hp+sheetPsi*(1-hp))

tileToCrystalState :: Tile -> CrystalState
tileToCrystalState tile =
  let rs = tileRes tile
      aas = map resAA rs
      !singlet = [caBondLength]
      -- Hydrophobic COM
      ws = map (\r -> 1.0 + max 0 (hydrophobicity(resAA r))) rs
      !tw = sum ws
      !weak = [sum(zipWith(\r w->resX r*w/tw)rs ws),
               sum(zipWith(\r w->resY r*w/tw)rs ws),
               sum(zipWith(\r w->resZ r*w/tw)rs ws)]
      -- Pair targets inline
      nexts = drop 1 aas ++ [Gly]
      !colour = concat(zipWith3(\r a n->let(!tp,!ts)=targetPP a n
                                       in [resPhi r-tp, resPsi r-ts]) rs aas nexts)
      !mixed = concatMap (\r ->
        let !h=1.0+0.5*hydrophobicity(resAA r)
        in [resX r*h, resY r*h, resZ r*h,
            resScX r*h, resScY r*h, resScZ r*h]) rs
  in singlet ++ weak ++ colour ++ mixed

crystalStateToTile :: Tile -> CrystalState -> Tile
crystalStateToTile oldTile cs =
  let aas = map resAA (tileRes oldTile)
      !bondLen = head (extractSector 0 cs)
      [cx,cy,cz] = extractSector 1 cs
      devs = extractSector 2 cs
      mixed = extractSector 3 cs
      nexts = drop 1 aas ++ [Gly]
      devPairs = pairUp devs
      phiPsis = zipWith3 (\a n (dp,ds)->let(!tp,!ts)=targetPP a n in(tp+dp,ts+ds))
                         aas nexts (devPairs++repeat(0,0))
      backbone = buildBackbone bondLen (phiPsis ++ repeat (helixPhi,helixPsi))
      caPos = take 4 backbone
      oldRs = tileRes oldTile
      ws=map(\r->1.0+max 0(hydrophobicity(resAA r)))oldRs
      !tw=sum ws
      !ocx=sum(zipWith(\r w->resX r*w/tw)oldRs ws)
      !ocy=sum(zipWith(\r w->resY r*w/tw)oldRs ws)
      !ocz=sum(zipWith(\r w->resZ r*w/tw)oldRs ws)
      !dx=cx-ocx; !dy=cy-ocy; !dz=cz-ocz
      nextP i = if i+1<length caPos then caPos!!(i+1)
                else let(px,py,pz)=caPos!!i in(px+bondLen,py,pz)
      buildRes i aa =
        let (bx,by,bz)=if i<length caPos then caPos!!i else (0,0,0)
            (phi,psi)=if i<length phiPsis then phiPsis!!i else (helixPhi,helixPsi)
            (scx,scy,scz)=placeSideChain (bx+dx,by+dy,bz+dz) (let(a,b,c)=nextP i in(a+dx,b+dy,c+dz)) aa
        in Residue (bx+dx)(by+dy)(bz+dz) phi psi scx scy scz aa
  in tileFromList (zipWith buildRes [0..] aas)

pairUp :: [a] -> [(a,a)]
pairUp (a:b:r) = (a,b):pairUp r
pairUp _ = []

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = let(h,t)=splitAt n xs in h:chunksOf n t

-- §6 Chain
data Chain = Chain
  { chainTiles :: ![Tile], chainSequence :: ![AminoAcid], chainLength :: !Int
  } deriving (Show)

makeChain :: [AminoAcid] -> Chain
makeChain aas =
  let n=length aas
      -- Start EXTENDED: φ=ψ=0 (far from helix).
      -- Deviation from target = 0 - target = large.
      -- Colour sector contracts deviation → dihedrals approach target.
      rs = zipWith (\i aa ->
        let x=fromIntegral i*caBondLength
            r=scRadius aa
            -- Extended initial dihedrals (not at target yet)
            phi0 = 0.0    -- will be driven toward targetPhi by engine
            psi0 = 0.0    -- will be driven toward targetPsi by engine
        in Residue x 0 0 phi0 psi0 x r 0 aa
        ) [0..] aas
  in Chain (map tileFromList (chunksOf 4 rs)) aas n

numTiles :: Chain -> Int
numTiles = length . chainTiles

allResidues :: Chain -> [Residue]
allResidues = concatMap tileRes . chainTiles

-- §7 Energy
epsVdw, epsHbond, epsBurial :: Double
epsVdw=0.019337; epsHbond=0.18242; epsBurial=0.447

pairEnergy :: Residue -> Residue -> Double
pairEnergy r1 r2 =
  let d=residueDistance r1 r2
      vdw=if d<2 then epsVdw*100 else if d<contactCutoff then -epsVdw*(contactCutoff/d) else 0
      hb=if d<3.5 && hydrophobicity(resAA r1)<0 && hydrophobicity(resAA r2)<0
         then -epsHbond else 0
      bur=if d<contactCutoff && hydrophobicity(resAA r1)>0.3 && hydrophobicity(resAA r2)>0.3
          then -epsBurial*hydrophobicity(resAA r1)*hydrophobicity(resAA r2) else 0
  in vdw+hb+bur

totalEnergy :: Chain -> Double
totalEnergy c = let rs=allResidues c; n=length rs
  in sum [pairEnergy(rs!!i)(rs!!j)|i<-[0..n-1],j<-[i+2..n-1]]

-- §8 Fold step
foldStep :: Chain -> Chain
foldStep c = c{chainTiles=fixBoundaries(map tickTile(chainTiles c))}

tickTile :: Tile -> Tile
tickTile tile = crystalStateToTile tile (tick (tileToCrystalState tile))

fixBoundaries :: [Tile] -> [Tile]
fixBoundaries [] = []
fixBoundaries [t] = [t]
fixBoundaries (t1:t2:rest) =
  let r4=last(tileRes t1); r1=head(tileRes t2)
      dx=resX r1-resX r4; dy=resY r1-resY r4; dz=resZ r1-resZ r4
      dist=sqrt(dx*dx+dy*dy+dz*dz)
      (nx,ny,nz)=if dist<1e-10 then(resX r4+caBondLength,resY r4,resZ r4)
                 else let s=caBondLength/dist in(resX r4+dx*s,resY r4+dy*s,resZ r4+dz*s)
      sx=nx-resX r1; sy=ny-resY r1; sz=nz-resZ r1
      shift r=r{resX=resX r+sx,resY=resY r+sy,resZ=resZ r+sz,
                resScX=resScX r+sx,resScY=resScY r+sy,resScZ=resScZ r+sz}
  in t1:fixBoundaries(Tile(map shift(tileRes t2)):rest)

foldN :: Int -> Chain -> Chain
foldN 0 c = c
foldN n c = let c'=foldStep c in c' `seq` foldN(n-1) c'

-- | PRE-FOLD CONDITIONING: pull hydrophobic residues toward each other
-- BEFORE engine ticks. Constant-force (direction only, not 1/r²) so it
-- works at extended-chain distances (50-70 Å).
condition :: Int -> Chain -> Chain
condition 0 c = c
condition n c =
  let rs = allResidues c
      nR = length rs
      str = 0.3  -- Å per round per partner
      step i ri = foldl' acc (0::Double,0::Double,0::Double) [0..nR-1]
        where acc (!ax,!ay,!az) j
                | abs(i-j)<=2 = (ax,ay,az)
                | otherwise =
                    let rj=rs!!j
                        !d=max 1.0(residueDistance ri rj)
                        hi=hydrophobicity(resAA ri)
                        hj=hydrophobicity(resAA rj)
                        -- CONSTANT FORCE: direction only, no 1/r falloff
                        -- So it works at 50 Å just as well as 5 Å
                        !a | hi>0.2&&hj>0.2 = str*hi*hj         -- hydrophobic attract
                           | hi<(-0.3)&&hj<(-0.3) = str*0.15    -- polar H-bond
                           | hi>0.2&&hj<(-0.2) = -str*0.05      -- repel mixed
                           | hi<(-0.2)&&hj>0.2 = -str*0.05
                           | otherwise = 0
                    in (ax+a*(resX rj-resX ri)/d,
                        ay+a*(resY rj-resY ri)/d,
                        az+a*(resZ rj-resZ ri)/d)
      displaced = zipWith(\i ri->let(!dx,!dy,!dz)=step i ri
        in ri{resX=resX ri+dx,resY=resY ri+dy,resZ=resZ ri+dz,
              resScX=resScX ri+dx,resScY=resScY ri+dy,resScZ=resScZ ri+dz})[0..]rs
      c' = c{chainTiles=map tileFromList(chunksOf 4 displaced)}
  in c' `seq` condition (n-1) c'

-- | Full pipeline: condition → extract dihedrals → fold.
-- Conditioning moves atoms via LR forces.
-- Then we extract the new dihedrals from the 3D positions.
-- Engine fold preserves the conditioned shape through colour sector.
foldPipeline :: Int -> Int -> Chain -> Chain
foldPipeline condRounds foldSteps c =
  let !conditioned = condition condRounds c
      !withAngles = extractDihedrals conditioned
      !folded = foldN foldSteps withAngles
  in folded

-- | Extract backbone dihedrals from 3D Cα positions.
-- Uses atan2 — this is INIT, not tick. Allowed.
extractDihedrals :: Chain -> Chain
extractDihedrals c =
  let rs = allResidues c
      n = length rs
      -- Compute dihedral-like angles from consecutive Cα positions
      -- For each residue i, compute the "virtual torsion" from
      -- positions i-1, i, i+1 which determines local chain direction
      newRs = zipWith (\i r ->
        if i < 1 || i >= n-1 then r  -- endpoints keep original
        else let r0 = rs!!(i-1); r2 = rs!!(i+1)
                 -- Vector from previous to current
                 dx1 = resX r - resX r0; dy1 = resY r - resY r0; dz1 = resZ r - resZ r0
                 -- Vector from current to next
                 dx2 = resX r2 - resX r; dy2 = resY r2 - resY r; dz2 = resZ r2 - resZ r
                 -- Bend angle in xy-plane → maps to φ
                 phi = atan2 (dx1*dy2 - dy1*dx2) (dx1*dx2 + dy1*dy2)
                 -- Bend angle in xz-plane → maps to ψ
                 psi = atan2 (dx1*dz2 - dz1*dx2) (dx1*dx2 + dz1*dz2)
             in r { resPhi = phi, resPsi = psi }
        ) [0..] rs
  in c { chainTiles = map tileFromList (chunksOf 4 newRs) }

-- | Long-range hydrophobic steering (post-tick version, weaker).
longRangePass :: Chain -> Chain
longRangePass c =
  let rs = allResidues c
      n = length rs
      str = 0.2
      step i ri = foldl' acc (0::Double,0::Double,0::Double) [0..n-1]
        where acc (!ax,!ay,!az) j
                | abs(i-j)<=3 = (ax,ay,az)
                | otherwise   =
                    let rj=rs!!j; d=max 1.0(residueDistance ri rj)
                    in if d>2*contactCutoff then (ax,ay,az)
                       else let hi=hydrophobicity(resAA ri)
                                hj=hydrophobicity(resAA rj)
                                a | hi>0&&hj>0 = str*hi*hj/d
                                  | hi<(-0.3)&&hj<(-0.3) = str*0.3/d
                                  | otherwise = 0
                            in (ax+a*(resX rj-resX ri)/d,
                                ay+a*(resY rj-resY ri)/d,
                                az+a*(resZ rj-resZ ri)/d)
      displaced = zipWith(\i ri->let(!dx,!dy,!dz)=step i ri
        in ri{resX=resX ri+dx,resY=resY ri+dy,resZ=resZ ri+dz,
              resScX=resScX ri+dx,resScY=resScY ri+dy,resScZ=resScZ ri+dz})[0..]rs
  in c{chainTiles=map tileFromList(chunksOf 4 displaced)}

-- | Fold with periodic long-range passes (every `p` steps)
foldLR :: Int -> Int -> Chain -> Chain
foldLR 0 _ c = c
foldLR n p c =
  let c1 = foldStep c
      c2 = if n`mod`p==0 then longRangePass c1 else c1
  in c2 `seq` foldLR (n-1) p c2

-- §9 Observables
radiusOfGyration :: Chain -> Double
radiusOfGyration c =
  let rs=allResidues c; n=fromIntegral(length rs)
      cx=sum(map resX rs)/n; cy=sum(map resY rs)/n; cz=sum(map resZ rs)/n
  in sqrt(sum[let dx=resX r-cx;dy=resY r-cy;dz=resZ r-cz in dx*dx+dy*dy+dz*dz|r<-rs]/n)

endToEnd :: Chain -> Double
endToEnd c = let rs=allResidues c
  in if null rs then 0 else residueDistance(head rs)(last rs)

numContacts :: Chain -> Int
numContacts c = let rs=allResidues c; n=length rs
  in length[()|i<-[0..n-1],j<-[i+2..n-1],residueDistance(rs!!i)(rs!!j)<contactCutoff]

data SSType = Helix|Sheet|Coil deriving(Show,Eq)
assignSS :: Residue -> SSType
assignSS r
  | abs(resPhi r-helixPhi)<0.5 && abs(resPsi r-helixPsi)<0.5 = Helix
  | abs(resPhi r-sheetPhi)<0.5 && abs(resPsi r-sheetPsi)<0.5 = Sheet
  | otherwise = Coil

ssContent :: Chain -> (Double,Double,Double)
ssContent c = let rs=allResidues c; n=fromIntegral(length rs); ss=map assignSS rs
                  h=fromIntegral(length(filter(==Helix)ss))
                  s=fromIntegral(length(filter(==Sheet)ss))
              in (h/n,s/n,(n-h-s)/n)

-- §10 PDB output
chainToPDB :: String -> Chain -> String
chainToPDB title c = unlines $
  ["HEADER    CRYSTAL FOLD FROM (2,3)","TITLE     "++title,
   "REMARK   1 3D backbone from dihedral eigenvalue relaxation",
   "REMARK   2 Side chains placed by amino acid type",
   "REMARK   3 36 = Sigma_d DOF per tile. Zero calculus in tick."]
  ++ zipWith caLine [1..] rs
  ++ concatMap(\(i,r)->if scRadius(resAA r)>0 then[cbLine i r]else[])(zip[1..]rs)
  ++ ["END"]
  where
    rs=take(chainLength c)(allResidues c)
    fmt v=let s=show(fromIntegral(round(v*1000)::Int)/1000::Double)
          in replicate(8-length(take 8 s))' '++take 8 s
    caLine i r="ATOM  "++rp 5(show i)++"  CA  "++take 3(show(resAA r)++"   ")
              ++" A"++rp 4(show i)++"    "++fmt(resX r)++fmt(resY r)++fmt(resZ r)
              ++"  1.00  0.00           C"
    cbLine i r="ATOM  "++rp 5(show(i+1000))++"  CB  "++take 3(show(resAA r)++"   ")
              ++" A"++rp 4(show i)++"    "++fmt(resScX r)++fmt(resScY r)++fmt(resScZ r)
              ++"  1.00  0.00           C"
    rp n s=replicate(n-length s)' '++s

-- §11 Test
check :: String -> Bool -> IO ()
check name True  = putStrLn $ "  PASS  " ++ name
check name False = putStrLn $ "  FAIL  " ++ name

r2 :: Double -> Double
r2 x = fromIntegral(round(x*100)::Int)/100

main :: IO ()
main = do
  putStrLn "================================================================"
  putStrLn " CrystalFold.hs v2 — 3D + Side Chains + Sequence-Dependent"
  putStrLn "================================================================"
  putStrLn ""

  putStrLn "§1 Crystal identities:"
  check "Σd = 36 (entire CrystalState)" (sigmaD == 36)
  check "d4 = 24 = 4 × chi" (d4 == 4 * chi)
  check "helix = 3.6 = 18/5" (abs(helixPerTurn-3.6)<1e-10)
  check "Flory = 0.4 = 2/5" (abs(floryNu-0.4)<1e-10)
  putStrLn ""

  putStrLn "§2 Eigenvalue funnel:"
  check "weak(1/2) > colour(1/3) > mixed(1/6)" (lambda 1>lambda 2 && lambda 2>lambda 3)
  check "singlet = 1 (topology conserved)" (lambda 0 == 1.0)
  putStrLn ""

  putStrLn "§3 Engine tick:"
  let t0=Tile[Residue 0 0 0 (-1) 1 0 1.5 0 Ala,Residue 3.8 0 0 (-1) 1 3.8 1.5 0 Leu,
              Residue 7.6 0 0 (-1) 1 7.6 2.1 0 Val,Residue 11.4 0 0 (-1) 1 11.4 1.5 0 Ile]
      cs0=tileToCrystalState t0; cs1=tick cs0
      m0=sum(map(\x->x*x)(extractSector 3 cs0))
      m1=sum(map(\x->x*x)(extractSector 3 cs1))
  check "mixed contracts by λ²=1/36" (abs(m1/m0-lambda 3*lambda 3)<1e-10)
  check "singlet preserved (bond length)" (abs(head cs1-caBondLength)<1e-10)
  putStrLn ""

  let trp=[Ala,Ser,Trp,Ile,Leu,Asp,Gly,Lys,Phe,Ala,
           Glu,Leu,Val,His,Ala,Asn,Ala,Ile,Lys,Ala]
      c0=makeChain trp
      rg0=radiusOfGyration c0; ee0=endToEnd c0; e0=totalEnergy c0
      (h0,s0,l0)=ssContent c0

  putStrLn "§4 Trp-cage-like (20 res) — initial:"
  putStrLn$"  R_g="++show(r2 rg0)++" Å  E2E="++show(r2 ee0)++" Å  E="++show(r2 e0)++" eV"
  putStrLn$"  SS: H="++show(r2 h0)++" S="++show(r2 s0)++" C="++show(r2 l0)
  putStrLn ""

  let c200=foldN 200 c0
      rg2=radiusOfGyration c200; ee2=endToEnd c200; nc2=numContacts c200
      (h2,s2,l2)=ssContent c200

  putStrLn "§5 After 200 fold steps:"
  putStrLn$"  R_g="++show(r2 rg2)++" Å  E2E="++show(r2 ee2)++" Å"
  putStrLn$"  contacts="++show nc2
  putStrLn$"  SS: H="++show(r2 h2)++" S="++show(r2 s2)++" C="++show(r2 l2)
  check "R_g decreased (folded)" (rg2<rg0)
  check "end-to-end decreased" (ee2<ee0)
  check "contacts formed" (nc2>0)
  putStrLn ""

  putStrLn "§6 3D structure (first 5 residues):"
  let rs5=take 5(allResidues c200)
  mapM_(\(i,r)->putStrLn$"  "++show i++" "++show(resAA r)
    ++" ("++show(r2$resX r)++","++show(r2$resY r)++","++show(r2$resZ r)++")"
    ++" φ="++show(r2$resPhi r)++" ψ="++show(r2$resPsi r)
    ++" SC=("++show(r2$resScX r)++","++show(r2$resScY r)++","++show(r2$resScZ r)++")")
    (zip[1::Int ..]rs5)
  let hasY=any(\r->abs(resY r)>0.01)rs5
      hasZ=any(\r->abs(resZ r)>0.01)rs5
  check "3D: y-coordinates non-zero" hasY
  check "3D: z-coordinates non-zero" hasZ
  check "side chains offset from backbone" (any(\r->scRadius(resAA r)>0&&abs(resScY r-resY r)>0.01)rs5)
  putStrLn ""

  let c500=foldN 500 c0
  writeFile "crystal_fold.pdb"
    (chainToPDB "TRP-CAGE-LIKE 20MER FOLDED 500 STEPS" c500)
  putStrLn "§7 PDB written: crystal_fold.pdb"
  putStrLn$"  final R_g = "++show(r2$radiusOfGyration c500)++" Å"
  putStrLn ""

  putStrLn "================================================================"
  putStrLn " 3D backbone from dihedral eigenvalue relaxation."
  putStrLn " Side chains from amino acid type. Sequence sets amplitudes."
  putStrLn " 36 DOF per tile. Zero calculus in tick."
  putStrLn "================================================================"
