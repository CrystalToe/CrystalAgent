<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

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