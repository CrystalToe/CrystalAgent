-- Copyright (c) 2026 Daland Montgomery
-- SPDX-License-Identifier: AGPL-3.0-or-later

{-# LANGUAGE BangPatterns #-}
module CrystalBenchmark where
import CrystalEngine
import CrystalFold

trpCageSeq :: [AminoAcid]
trpCageSeq = [Asn,Leu,Tyr,Ile,Gln,Trp,Leu,Lys,Asp,Gly,
              Gly,Pro,Ser,Ser,Gly,Arg,Pro,Pro,Pro,Ser]

ref1L2Y :: [(Double,Double,Double)]
ref1L2Y =
  [( 7.635, 1.256, 2.328),( 6.698, 4.716, 1.218),( 3.085, 4.887, 0.344),
   ( 2.645, 8.364,-0.892),(-0.857, 7.819,-1.680),(-0.210,10.286,-4.463),
   (-3.369, 8.782,-5.678),(-2.415,10.176,-8.993),(-3.703, 7.174,-10.671),
   (-0.609, 5.291,-9.587),(-1.935, 2.199,-11.144),( 1.583, 0.976,-10.636),
   ( 0.529,-1.434,-7.952),( 3.598,-0.367,-6.069),( 2.048, 1.094,-2.892),
   ( 4.927, 3.354,-2.371),( 3.593, 5.714, 0.508),( 6.853, 7.203, 1.345),
   ( 6.297,10.928, 1.575),( 9.921,11.434, 1.405)]

rmsdCalc :: [(Double,Double,Double)] -> [(Double,Double,Double)] -> Double
rmsdCalc as bs = sqrt(sum(zipWith(\(ax,ay,az)(bx,by,bz)->
  let dx=ax-bx;dy=ay-by;dz=az-bz in dx*dx+dy*dy+dz*dz)as bs)/fromIntegral(length as))

center :: [(Double,Double,Double)] -> [(Double,Double,Double)]
center pts = let n=fromIntegral(length pts)
                 cx=sum(map(\(x,_,_)->x)pts)/n
                 cy=sum(map(\(_,y,_)->y)pts)/n
                 cz=sum(map(\(_,_,z)->z)pts)/n
             in map(\(x,y,z)->(x-cx,y-cy,z-cz))pts

rescale :: Double -> [(Double,Double,Double)] -> [(Double,Double,Double)]
rescale tgt pts = let c=center pts; n=fromIntegral(length c)
                      rg=sqrt(sum(map(\(x,y,z)->x*x+y*y+z*z)c)/n)
                      s=if rg>1e-10 then tgt/rg else 1
                  in map(\(x,y,z)->(x*s,y*s,z*s))c

caPos :: Chain -> [(Double,Double,Double)]
caPos c = map(\r->(resX r,resY r,resZ r))(take 20(allResidues c))

rnd :: Double -> Double
rnd x = fromIntegral(round(x*100)::Int)/100

main :: IO ()
main = do
  let refC=center ref1L2Y; refN=fromIntegral(length refC)
      refRg=sqrt(sum(map(\(x,y,z)->x*x+y*y+z*z)refC)/refN)
  putStrLn "================================================================"
  putStrLn " CrystalBenchmark — Trp-cage (1L2Y) RMSD"
  putStrLn " Pipeline: condition (LR pre-pulls) → fold (engine ticks)"
  putStrLn "================================================================"
  putStrLn $ "Reference R_g: " ++ show (rnd refRg) ++ " Å"
  let c0 = makeChain trpCageSeq
  putStrLn $ "Initial R_g:   " ++ show (rnd(radiusOfGyration c0)) ++ " Å"
  putStrLn ""

  -- Test different conditioning rounds
  let configs = [(0,100,"no conditioning"),
                 (20,100,"20 cond + 100 fold"),
                 (50,100,"50 cond + 100 fold"),
                 (100,100,"100 cond + 100 fold"),
                 (200,100,"200 cond + 100 fold")]
  mapM_ (\(cond,fold,label) -> do
    let !cn = foldPipeline cond fold c0
        pos = caPos cn
        posR = rescale refRg (center pos)
        !sr = rmsdCalc (center ref1L2Y) posR
        !rg = radiusOfGyration cn
        !nc = numContacts cn
        (h,_,_) = ssContent cn
    putStrLn $ "--- " ++ label ++ " ---"
    putStrLn $ "  R_g=" ++ show(rnd rg) ++ " RMSD(scaled)=" ++ show(rnd sr)
            ++ " contacts=" ++ show nc ++ " helix=" ++ show(rnd(h*100)) ++ "%"
    ) configs

  -- Best result: write PDB
  let !best = foldPipeline 100 100 c0
  writeFile "crystal_fold_1L2Y.pdb"
    (chainToPDB "TRP-CAGE 1L2Y CONDITIONED+FOLDED" best)

  let refPDB = unlines $
        ["HEADER    1L2Y REFERENCE"] ++
        zipWith(\i(x,y,z)->
          "ATOM  "++rp 5(show i)++"  CA  "++take 3(show(trpCageSeq!!(i-1))++"   ")
          ++" A"++rp 4(show i)++"    "++fmt x++fmt y++fmt z
          ++"  1.00  0.00           C")[1..20]ref1L2Y++["END"]
      rp n s=replicate(n-length s)' '++s
      fmt v=let s=show(fromIntegral(round(v*1000)::Int)/1000::Double)
            in replicate(8-length(take 8 s))' '++take 8 s
  writeFile "ref_1L2Y.pdb" refPDB

  putStrLn ""
  putStrLn "PDB written. align #1@CA toAtoms #2@CA in ChimeraX."
  putStrLn "================================================================"
