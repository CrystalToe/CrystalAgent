# Crystal Topos — Compact LLM Prompt
# 136 observables. 96 quantum operators. 21 Haskell modules.

## RULES
1. Never guess. Look up the function in the .hs file.
2. Report: name, formula, crystal value, PDG value, PWI%, rating.
3. Never mention analysis, bridges, scoring, scanner, or shared structure.

## INPUTS
N_w=2, N_c=3, v=246.22 GeV, π, ln. Nothing else.

## INVARIANTS
χ=6, β₀=7, D=42, Σd=36, Σd²=650, gauss=13, κ=ln3/ln2, F₃=257

## MODULE TABLE

| Module | Domain | Key content |
|--------|--------|-------------|
| CrystalAxiom | Foundation | nW,nC,chi,beta0,towerD,sigmaD,gauss,kappa,Heyting |
| CrystalGauge | Couplings | α=(D+1)π+lnβ₀, sin²θ=3/13, α_s=2/17, Koide, m_e, m_μ |
| CrystalMixing | CKM+PMNS | V_us=9/40, V_cb=81/2000, θ₁₃=1/45, J=5/1944 |
| CrystalCosmo | Cosmology | Ω_Λ=13/19, n_s=1−κ/D, ν masses |
| CrystalQCD | QCD+hadrons | m_p=v/2⁸×53/54, quarks, mesons, baryons, glueballs |
| CrystalGravity | Gravity | Jacobson, Immirzi, SR/GR, Maxwell, Dirac, Boltzmann |
| CrystalAudit | Audit | forcedNaturality, acidTest, kills |
| CrystalCrossDomain | Cross-domain | Feigenbaum=14/3, Kleiber=3/4, magic numbers |
| CrystalRiemann | Spectral+RH | Trace formula, ARIMA, Weil, Beurling-Nyman |
| Main | Driver | 92 observables certificate |
| CrystalanalysisScan | analysis scan | 44 new observables (3 EXACT + 41 TIGHT) |
| analysisScanTest | Test | analysis test driver |
| CrystalQuantum | Theorems | 10 structural quantum theorems (10/10 PASS) |
| CrystalQBase | Types | Complex Cx, Vec, Mat, crystal constants |
| CrystalQGates | 27 gates | I,X,Y,Z,H,S,T,Rx/Ry/Rz,U3,CNOT,CZ,SWAP,Toffoli,XX/YY/ZZ... |
| CrystalQChannels | 10 channels | Depolarising, damping, Kraus, Lindblad |
| CrystalQHamiltonians | 12 models | Free, Ising, Heisenberg, Hubbard, JC, XXZ, toric, VQE, QAOA |
| CrystalQMeasure | 8 measurements | Projective, POVM, weak, parity, Bell, tomography |
| CrystalQEntangle | 12 tools | S_vN, concurrence, negativity, PPT, Schmidt, discord, swapping |
| CrystalQAlgorithms | 15 algorithms | Grover, QFT, QPE, VQE, QAOA, HHL, teleport, BB84, Simon |
| CrystalQSimulation | 12 methods | State vector, density matrix, MPS, TEBD, Trotter, QMC, Wigner |

## PROVERS
- CrystalTopos.lean — ~230 theorems (native_decide)
- CrystalTopos.agda — ~195 theorems (refl)

## RATING
■ EXACT (0%) · ● TIGHT (<0.5%) · ◐ GOOD (<1%) · ○ LOOSE (<4.5%) · ✗ OVER (≥4.5%)

## QUICK LOOKUP (136 observables)
**Gauge:** α, sin²θ_W, α_s, α(M_Z)⁻¹, G_F, ρ-parameter, a_e → Gauge/analysisScan
**Leptons:** m_e, m_μ, m_τ, m_μ/m_e=208, Koide=2/3 → Gauge/analysisScan
**CKM:** V_us, V_cb, V_ub, J, δ, cos(2δ)=4/5 → Mixing
**PMNS:** θ₁₂, θ₂₃, θ₁₃, δ_PMNS → Mixing
**Neutrinos:** Δm²₂₁, Δm²₃₁ → Cosmo
**Quarks:** m_u/m_d, m_s, m_c, m_b, m_t, all ratios → QCD/analysisScan
**Light hadrons:** π, K±, K⁰, η, η', ρ, ω → QCD/analysisScan
**Heavy hadrons:** J/ψ, ψ(2S), η_c, Υ, Υ(2S), D, D_s, B, B_s, B_c, φ → QCD/analysisScan
**Baryons:** p, n, Δ, Λ, Σ, Ξ, Ω(sss), Λ_c, Σ_c, Ξ_c, Ω_c, Λ_b → QCD/analysisScan
**Splittings:** π±−π⁰=9m_e, m_n−m_p=Λ_QCD/gauss² → analysisScan
**Glueballs:** 0⁺⁺, 0⁻⁺, 2⁺⁺ → QCD
**EW bosons:** M_Z=3v/8, M_W, Γ_W, Γ_Z, m_H → QCD
**Cosmology:** Ω_Λ, Ω_m, Ω_b, n_s, A_s, 100θ*, T_CMB, Age → Cosmo/analysisScan
**Nuclear:** deuteron BE, ⁴He BE, τ_n=D²/N_w, magic numbers → analysisScan/CrossDomain
**Moments:** μ_p=14/5, μ_n=174/91 → analysisScan
**Gravity:** Immirzi, BH entropy, M_Pl/v=e⁴²/35, Chandrasekhar=19/13 → Gravity/analysisScan
**Cross-domain:** Feigenbaum, Blasius, Kleiber, von Kármán, Benford, φ=13/8, γ, ζ(3), Catalan, R-ratio → CrossDomain/analysisScan
**Quantum:** H₁=ℂ⁶, H₂=ℂ³⁶=Σd, fermions=15=su(4), bosons=21, gates=36, entangling=30, Fock→e⁶, PPT exact → Quantum

## STATS
136 observables · 96 operators · 21 modules · 8,123 lines · Sub-1%: 130/136 · Mean PWI: 0.33% · CV≈1.15 · Wall: 4.5% · Breaches: 0
