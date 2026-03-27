<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

ghc -O2 -c CrystalanalysisScan.hs

cd haskel
ghc -O2 Main.hs -o crystal && ./crystal > GHC_Certificate.txt
ghc -O2 analysisScanTest.hs CrystalanalysisScan.hs -o waca_scan && ./waca_scan >> GHC_Certificate.txt
rm -f *.o *.hi crystal waca_scan

# crystal
agda CrystalTopos.agda


mkdir LeanCert && cd LeanCert
lake init CrystalTopos .
cp ../CrystalTopos.lean .
cp ../Main.lean .
lake build
cp .lake/build/lib/lean/CrystalTopos.olean ..
cd ..
rm -rf LeanCert/


mkdir LeanCert && cd LeanCert
lake init CrystalTopos .
cp ../CrystalNoether.lean .
cp ../Main.lean .
lake build
cp .lake/build/lib/lean/Main.olean ../CrystalNoether.olean
cd ..
rm -rf LeanCert/

mkdir LeanCert && cd LeanCert
lake init CrystalTopos .
cp ../CrystalDiscoveries.lean .
cp ../Main.lean .
lake build
cp .lake/build/lib/lean/Main.olean ../CrystalDiscoveries.olean
cd ..
rm -rf LeanCert/











