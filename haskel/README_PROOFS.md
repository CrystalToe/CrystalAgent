# crystal
agda CrystalTopos.agda


mkdir LeanCert && cd LeanCert
lake init CrystalTopos .
cp ../CrystalTopos.lean .
cp ../Main.lean .
lake build
cp .lake/build/lib/lean/CrystalTopos.olean ..
