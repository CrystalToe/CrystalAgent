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


print("Hello, Crystal Toe!")