

```bash
# 1. Pure Rust tests still work (no pyo3 needed)
cargo test

# 2. Install maturin
pip install maturin

# 3. Build Python wheel with bindings
maturin develop --features python

PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1 maturin develop --features python

```bash
cd crystal-toe
ghc -O2 CrystalOracle.hs -o crystal_oracle
python -c "from haskell_toe import HaskellToe; hs = HaskellToe(); print(hs)"
python cross_check.py
```

```bash
# 4. Test from Python
python test_crystal_toe.py
```


```python
from crystal_toe import Toe, Nuclear, Bio, QFT, Astro, QInfo, Chem, AlgebraState

# One constructor, default Crystal
toe = Toe()                    # 245.17 GeV
pdg = toe.to_pdg()            # 246.22 GeV via 1.00435
custom = Toe(250.0)           # any VEV

# Masses, couplings
toe.alpha_inv()                # 137.034
toe.proton_mass()              # GeV
toe.sin2_theta_w()             # 0.2312

# 21 dynamics modules
Nuclear().magic_numbers()      # [2, 8, 20, 28, 50, 82, 126]
Bio().amino_acids()            # 20
QFT().thomson_cs()             # 0.665 barn
Astro().lane_emden(1.5)        # (3.654, 2.714)
QInfo().steane_code()          # (7, 1, 3)
Chem().neutral_ph()            # 7

# Monad time tick
state = AlgebraState()
state.tick()                   # one application of S=W∘U
state.weak                     # 0.5 = 1/N_w
state.mixed                    # 0.167 = 1/χ
```


```python

# haskell_toe.py wraps the binary as a Python class:
from haskell_toe import HaskellToe
hs = HaskellToe()
hs.alpha_inv       # 137.034... (from GHC)
hs.proton_mass     # GeV (from GHC)
hs.mp_me_ratio     # 1836.15... (from GHC)

# cross_check.py then compares every value:
from crystal_toe import Toe   # ← Rust via PyO3
from haskell_toe import HaskellToe  # ← Haskell via subprocess

toe = Toe()
hs = HaskellToe()
# rust toe.alpha_inv() == hs.alpha_inv to 12+ digits?
```



















