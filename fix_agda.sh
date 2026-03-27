# Copyright (c) 2026 Daland Montgomery
# SPDX-License-Identifier: AGPL-3.0-or-later

#!/bin/bash
set -e
git checkout haskel/CrystalTopos.agda
cat agda_bridge_proofs.agda >> haskel/CrystalTopos.agda
echo "Done. Proofs: $(grep -c 'refl' haskel/CrystalTopos.agda)"
echo "Now run: cd haskel && agda CrystalTopos.agda"
