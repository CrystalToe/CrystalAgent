<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# Cross-Domain Scan: Hierarchical Implosion in MERA
## Literature Review & Code References

**Date:** 2026-03-30  
**Scope:** Broad cross-domain sweep — tensor networks, multigrid methods, coarse-grained molecular dynamics, game physics, spectral graph theory, renormalization group, annealing schedules. Deliberately wide aperture — extract signal, filter later.

---

## 1. MERA Tensor Network — Core Literature

### 1.1 Foundational References

- **Vidal (2007)** — "Entanglement Renormalization" (PRL 99, 220405). Introduced MERA. Key insight: disentanglers remove short-range entanglement before coarse-graining. Without disentanglers you get a tree tensor network that can't capture long-range correlations between neighbors across branch boundaries.

- **Evenbly & Vidal (2015)** — "Tensor Network Renormalization" (PRL 115, 180405). Shows TNR applied to Euclidean path integrals yields MERA. This is the derivation-not-axiom direction: MERA emerges from a well-chosen coarse-graining procedure.

- **Evenbly & Vidal (2015b)** — "TNR Yields MERA" (PRL 115, 200401). The scale-invariant RG flow for critical systems produces MERA structure with the correct conformal data.

### 1.2 Practical Implementations

- **tensors.net/mera** — Reference implementation for scale-invariant MERA energy minimization on 1D lattices. Binary MERA with bond dimension χ = 12. Single-tensor updates via linearized environment. Sweep over all layers per iteration. **Code available.**

- **Munich lecture notes** (Sec. 23, LMU) — Detailed TNR-to-MERA derivation. Projective truncation strategy. Transfer matrix spectrum matching for isotropization. Iterative application of RNT yields boundary layers of MERA.

### 1.3 Cross-Domain MERA Connections (High Relevance)

| Source Domain | Target Domain | Connection | Score | Reference |
|---|---|---|---|---|
| MERA (quantum physics) | Neural networks / ML | MERA layers = convolutional + pooling with disentanglers; 3900× parameter reduction on CIFAR-10 | 7 | OpenReview, Compact NN via MERA |
| MERA coarse-graining | Audio/time-series classification | Wavelet preprocessing = MERA layers; adaptive fine-graining backwards through layers | 7 | arXiv:2001.08286 |
| MERA (entanglement RG) | AdS/CFT holography | MERA tensor network identified with hyperbolic AdS geometry; surfaces define quantum states | 8 | Swingle 2012; Takayanagi et al. |
| MERA (RG flow) | Graph coarse-graining | Spectral coarse-grained Laplacian preserves dynamics across scales; reveals collective behavior in brain networks | 7 | Phys Rev E 112, 034303 (2025) |
| Tensor network structure | RG-guided optimization | RGTN: continuous topology evolution via learnable edge gates + systematic coarse-graining; multi-scale optimization beats single-scale | 7 | arXiv:2512.24663 (2025) |

---

## 2. Multigrid Methods — The Closest Structural Analogue

### 2.1 Core Insight

Multigrid is the most direct structural analogue to hierarchical implosion. The shared pattern:

1. **Smoothing** on the fine grid eliminates high-frequency error
2. **Restriction** transfers residual to coarser grid (where low-frequency error looks high-frequency)
3. **Coarse solve** — fast because grid is smaller
4. **Prolongation** — interpolate correction back to fine grid
5. **Repeat** recursively through hierarchy

This is exactly the structure of hierarchical gap closure: close domain-level gaps (coarse grid), re-scale, close super-element gaps (medium grid), re-scale, close element gaps (fine grid). Each level constrains the next.

### 2.2 V-Cycle vs W-Cycle vs Full Multigrid

- **V-Cycle**: fine → coarse → fine. Single pass. Fast.
- **W-Cycle**: fine → coarse → fine → coarse → fine. Stays coarse longer. 125% more compute than V-cycle in 2D, but better convergence for convection-diffusion.
- **Full Multigrid (FMG)**: Starts on coarsest grid and works up. Asymptotically optimal.

**Relevance to session 8g**: The current implosion is a V-cycle (domain → super-element → element, one pass each). Could gain convergence by switching to W-cycle (revisiting coarser levels after fine correction) or FMG (starting from coarsest MERA level and building up).

### 2.3 Key References

- **Strang (MIT 18.086)** — V-cycle and W-cycle multigrid. Proof that cost of deep V-cycle is bounded by constant multiple of two-grid cost. W-cycle superior for anisotropic problems.
- **Briggs et al.** — "A Multigrid Tutorial" (SIAM). Standard reference.
- **Multigrid for Nonlinear Problems** (OSTI/LLNL report) — Full Approximation Scheme (FAS) handles nonlinear constraint equations via nonlinear Gauss-Seidel relaxation on each level. Directly applicable to position-based gap closure.
- **Algebraic Multigrid (AMG)** — Constructs hierarchy from system matrix alone, no geometry needed. Relevant if switching from geometric (MERA hierarchy) to algebraic (coupling-matrix-derived) coarsening.

### 2.4 Code Pointers

- **PyAMG** (pyamg.org) — Python algebraic multigrid. Direct apply to coupling Laplacian.
- **hypre** (LLNL) — Parallel semicoarsening multigrid (SMG, PFMG). C library.
- **Long Chen, UCI** — MATLAB multigrid on bisection grids (ifem package). Clean implementation of V-cycle with hierarchical basis.

---

## 3. Hierarchical Position-Based Dynamics — Game Physics

### 3.1 Core Papers

- **Müller et al. (2006)** — "Position Based Dynamics" (VRIPHYS). Omits velocity layer, works directly on positions. Constraints resolved by Gauss-Seidel projection. Key property: controllable, no overshooting, penetrations resolved by projecting to valid locations.

- **Müller (2008)** — "Hierarchical Position Based Dynamics" (VRIPHYS). **This is the most directly relevant paper.** Applies multigrid to PBD:
  - Particles marked coarse/fine via greedy algorithm
  - Cardinality-n constraints distributed across levels
  - Coarse constraints propagate coupling across distant vertices
  - Fine iterations start from lower residual
  - "Significantly faster than original PBD"

- **XPBD (2016)** — "Extended Position-Based Simulation of Compliant Constrained Dynamics". Adds compliance to PBD constraints.

- **Multi-Layer PBD (recent)** — Automatic generation of rigid/elastic layers based on strain rate. Rigid bodies at each layer provide coupling between progressively less distant vertices. Final elastic iterations start from low residual. Fast impact propagation through mixed rigid-elastic solves.

### 3.2 Direct Translation to Protein Back-Mapping

| PBD Concept | Protein Pipeline Equivalent | Status |
|---|---|---|
| Particles | Cα atoms (76 for ubiquitin) | Implemented |
| Distance constraints | CA-CA bond length = 3.8 Å | Implemented |
| Collision constraints | CLASH_DIST = 4.0 Å | Implemented |
| Gauss-Seidel projection | Gap closure iteration | Implemented |
| **Hierarchical coarsening** | **MERA-level gap closure** | **Implemented (8f)** |
| Multigrid prolongation | Rg re-scaling between levels | Implemented (8f) |
| Multi-layer rigid/elastic | Scheduled force weights (τ = 5/18) | Implemented (8f) |

**Unexploited direction**: Müller's hierarchical PBD uses automatic coarse/fine marking based on mesh connectivity. Currently using fixed MERA hierarchy. Could auto-derive hierarchy from coupling matrix instead.

### 3.3 Code

- **GitHub: InteractiveComputerGraphics/PositionBasedDynamics** — Full C++ library with hierarchical PBD, rigid bodies, deformables, fluids. MIT license (but project uses AGPL-3.0; check compatibility if incorporating).

---

## 4. Coarse-Grained Molecular Dynamics — Domain-Native Literature

### 4.1 Multi-Resolution Protein Methods

- **Rosetta coarse-to-fine** — Switches seamlessly between low-resolution (coarse-grained backbone + Cβ + virtual side-chains) and all-atom. Coarse-grained conformations subjected to side-chain reconstruction + FastRelax. Fragment insertion sampling in coarse mode, rotamer library in fine mode. Hierarchical code organization mirrors hierarchical resolution.

- **UNRES** (Scheraga group) — United-residue force field. ~4000× extension of simulation time scale vs all-atom. Averaging out fast-moving DOF reduces both cost and noise. Coarse-grained → atomistic back-mapping validated by energy landscape comparison.

- **Multi-Scale CG (MS-CG)** — Force-matching from atomistic to coarse-grained. Back-mapped CG → AA landscapes agree. CG landscape biased toward folding (accelerates dynamics). Extended to arbitrary protein sequences via generic mapping.

- **Decimate (Koehl et al., JCTC 2017)** — Explicitly RG-based coarse-graining of elastic networks. Hierarchy of decreasing-size models that are *consistent* with each other (each model contains dynamics info of predecessor). Based on renormalization group decimation of normal modes.

### 4.2 Hierarchical Assembly / Foldons

- **Boninsegna, Banisch & Clementi (JCTC 2018)** — Data-driven hierarchical assembly from MD. Partitions degrees of freedom in both structural and conformational space. Identifies "foldons" — prestructured regions that combine during folding. Suggests hierarchical characterization of assembly process. **Directly relevant**: elements in the pipeline may correspond to foldons, and the MERA hierarchy may recapitulate the folding order.

- **Hierarchical GNM (Chennubhotla & Bahar, RECOMB 2006)** — Markov-based hierarchical coarse-graining of Gaussian Network Model. Maps full-atom GNM (8015 nodes for GroEL-GroES) into hierarchy of lower-resolution networks. Reconstructs detailed dynamics with minimal data loss. 35 "soft nodes" reproduce the dominant 25 modes of a 8015-node system. Uses algebraic multigrid optimization for graph drawing (Koren et al. 2003).

### 4.3 Key Takeaway for Session 8g

The multi-resolution protein literature consistently shows that **hierarchical coarse-graining preserves the essential dynamics** if the hierarchy is derived from the system's own coupling structure (Laplacian eigenmodes, Markov transition matrices, or RG blocking). The MERA solver already uses spectral embedding of the coupling Laplacian — this is exactly the right object.

---

## 5. Spectral Embedding & Graph Coarse-Graining

### 5.1 Laplacian Eigenmaps (Belkin & Niyogi, NIPS 2001)

Core algorithm: construct graph from data, compute Laplacian L = D − W, take bottom-k eigenvectors (excluding trivial). Embedding preserves locality. Natural connection to clustering. Justified by Laplace-Beltrami operator on underlying manifold.

**Direct connection to MERA solver**: The spectral embedding of the coupling Laplacian IS a Laplacian Eigenmap. The 3D coordinates come from the 2nd, 3rd, 4th eigenvectors of the coupling graph. This is already implemented.

### 5.2 Diffusion Maps & Coarse-Graining (Coifman & Lafon, 2006)

Unified framework: dimensionality reduction, graph partitioning, and data set parameterization via diffusion process. Time parameter controls scale of analysis. **Coarse-graining the Markov random walk** produces reduced graph with same spectral properties.

**Relevance**: The MERA hierarchy could be derived from diffusion time-scales on the coupling graph instead of fixed 3:1 blocking. Short diffusion time → fine (element-level), long diffusion time → coarse (domain-level). This would make the hierarchy adaptive.

### 5.3 Laplacian Renormalization Group (2024-2025)

- **Nature Reviews Physics 7, 203-219 (2025)** — "Network Renormalization." Comprehensive review of extending RG to complex networks without geometric coordinates. Key challenge: no homogeneous lattice symmetries.

- **Phys Rev E 112, 034303 (2025)** — Spectral coarse-graining and rescaling for graphs. Preserves both dynamics and large-scale topology. Applied to EEG brain networks: reveals collective neural activity at different scales. Scale-invariant activity during attention vs. generalized patterns during rest.

**Relevance**: The protein contact graph is a complex network. Laplacian RG provides principled coarse-graining that preserves spectral properties. Could replace the fixed 3:1 MERA ratio with data-driven blocking.

---

## 6. Annealing Schedules & Stretched Exponentials

### 6.1 Cooling Schedules in Simulated Annealing

| Schedule | Formula | Properties |
|---|---|---|
| Linear | T(t) = T₀ − αt | Simple, risk of premature convergence |
| Exponential | T(t) = T₀ · αᵗ | Standard, peaks entropy production at intermediate T |
| Logarithmic | T(t) = c/log(1+t) | Provably converges to global optimum if c ≥ depth of deepest non-global local minimum |
| Thermodynamic (TDS2) | T ∝ accumulated cost/accumulated entropy | Adaptive, optimal for permanent computation |
| **Stretched exponential** | **exp(−(t/τ)^β)** | **β < 1 gives sub-exponential decay; spends more time at intermediate scales** |

### 6.2 Stretched Exponential Relaxation in Physics

The Kohlrausch stretched exponential exp(−(t/τ)^β) appears universally in disordered systems:
- **Glasses and supercooled liquids**: β ≈ 0.6-0.8 (Angell, Ngai)
- **Confined water**: β = d/(d+2) = 3/5 exactly in 3D (diffusion with random traps)
- **Spin glasses, charge density waves, polymers**: each has characteristic β

**Connection to τ = 5/18**: The pipeline uses β = 5/18 ≈ 0.278, which is quite low — deep sub-exponential. This means global forces persist much longer than exponential decay before finally dropping. Physically, this corresponds to a system with very broadly distributed relaxation times, where the coarse degrees of freedom relax much more slowly than the fine ones. This is exactly the right behavior for coarse-to-fine: you want global shape locked in while local geometry is still adjusting.

### 6.3 Optimal Schedule Theory

- **Sivak & Crooks (PRL 108, 190602, 2012)** — Optimal control of thermodynamic systems. The optimal schedule minimizes excess work (entropy production). For systems with scale-dependent relaxation times, the optimal cooling should spend more time at the scale transitions.

- **Huse & Wang (optimal SA schedules, 2024)** — Derived formalism for optimal annealing in multidimensional parameter spaces. Key result: the restricted friction tensor determines the optimal pace of change. For systems with separation of time scales (local fast, global slow), the schedule must slow down at the global → local crossover.

**Implication**: The τ = 5/18 schedule is consistent with optimal control theory for hierarchical systems. The "slow decay early + fast ramp late" pattern matches what optimal annealing theory predicts for systems with coarse degrees of freedom that relax slowly.

---

## 7. Cross-Domain Hits — Ranked Summary

### Tier 1: High-scoring, actionable

| # | Source → Target | Key Insight | Score | Action |
|---|---|---|---|---|
| 1 | **Multigrid V/W-cycle** → hierarchical implosion | Implosion is a V-cycle. W-cycle (revisiting coarser levels) may improve convergence. FMG (start from coarsest) may improve initialization. | 8 | Implement W-cycle variant: after element-level gap closure, re-check domain-level gaps |
| 2 | **Hierarchical PBD (Müller 2008)** → gap closure | Multigrid applied to position-based constraints. Coarse constraints propagate coupling. Fine iterations start from lower residual. | 8 | Already implemented. Validate that constraint ordering matches Müller's Gauss-Seidel strategy |
| 3 | **Decimate / RG coarse-graining** → MERA hierarchy | Derive hierarchy from coupling Laplacian (not fixed 3:1). Each level preserves predecessor's dynamics. | 7 | Replace fixed 3:1 with spectral blocking of coupling Laplacian |
| 4 | **Rosetta coarse-to-fine** → back-mapping | Seamless switch from low to high resolution. Coarse conformations → side-chain reconstruction → FastRelax. | 7 | Study Rosetta's FastRelax protocol for post-implosion refinement |
| 5 | **Diffusion maps coarse-graining** → adaptive MERA levels | Time parameter of Markov chain defines scale. Coarse-graining preserves spectral properties. | 7 | Compute diffusion map of coupling graph; use time scales to define MERA levels |

### Tier 2: Moderate scoring, exploratory

| # | Source → Target | Key Insight | Score | Action |
|---|---|---|---|---|
| 6 | **Optimal SA schedules** → τ = 5/18 schedule | Restricted friction tensor determines optimal pace. Hierarchical systems need slow decay at global scales. | 6 | Theoretical justification for stretched exponential. Compare τ = 5/18 against optimal-control-derived schedule |
| 7 | **MERA → ML (wavelet preprocessing)** | MERA layers are wavelet transforms. Can fine-grain optimized model backwards through layers. | 6 | Apply backwards fine-graining after MERA solver: refine coarse solution through layers |
| 8 | **Graph Laplacian RG (2025)** → coupling graph | Principled network renormalization without geometric coordinates. Preserves dynamics at each scale. | 6 | Apply Laplacian RG to coupling graph; compare resulting hierarchy vs fixed MERA 3:1 |
| 9 | **Hierarchical GNM (Bahar)** → elastic network contact prior | 35 "soft nodes" reproduce dominant 25 modes of 8015-node system. Markov-based hierarchy. | 6 | Build GNM of coupling graph; check if MERA grouping matches GNM soft-node decomposition |
| 10 | **MERA-AdS/CFT** → holographic interpretation | MERA = discrete hyperbolic geometry. Surfaces in the network define quantum states. Causal cones define locality. | 5 | Theoretical. The causal cone of an element in the MERA defines which other elements can influence it. Verify causal cones match expected contact neighborhoods |

### Tier 3: Lower scoring, background enrichment

| # | Source → Target | Score | Note |
|---|---|---|---|
| 11 | TNR loop optimization (Gu/Wen/Yang 2017) → tensor optimization | 5 | Deforming 2D tensor network into small loops then optimizing. May inspire local optimization strategy for MERA solver |
| 12 | Multi-layer PBD with rigid/elastic → scheduled relaxation | 5 | Automatic rigid body generation based on strain rate. Rigid bodies provide long-range coupling |
| 13 | RGTN (arXiv:2512.24663) → tensor network structure search | 5 | Learnable edge gates + coarse-graining for architecture search. Novel but computational overhead may be prohibitive |
| 14 | Foldons (Clementi) → element-level assembly order | 5 | Foldons combine hierarchically during folding. Check if MERA hierarchy matches experimentally determined folding order for ubiquitin |
| 15 | MS-CG back-mapping (Thorpe 2008) → chain-walk validation | 4 | CG→AA back-mapping energy landscape validation. Could validate implosion by comparing CG and AA energy surfaces |

---

## 8. Code Repositories (Direct Use)

| Repository | Language | Relevance | URL |
|---|---|---|---|
| **tensors.net** | Python/Julia | MERA energy minimization, reference implementation | tensors.net/mera |
| **PositionBasedDynamics** | C++ | Hierarchical PBD, multigrid constraints | github.com/InteractiveComputerGraphics/PositionBasedDynamics |
| **PyAMG** | Python | Algebraic multigrid for coupling Laplacian | pyamg.org |
| **scikit-learn** | Python | Laplacian Eigenmaps (SpectralEmbedding) | sklearn.manifold.SpectralEmbedding |
| **diffusion_maps** | Python | Diffusion maps for adaptive scale analysis | Multiple implementations on PyPI |
| **Rosetta** | C++ | Coarse-to-fine protein folding, FastRelax | rosettacommons.org |

---

## 9. Immediate Actionable Items for Session 8g

### From this scan:

1. **W-cycle implosion**: After closing element gaps (fine level), re-check super-element gaps. If residual > threshold, do another coarse pass before final element cleanup. Cost: one more Rg re-scale. Expected benefit: better global consistency after local corrections.

2. **Spectral blocking**: Replace fixed 3:1 MERA ratio. Compute Laplacian of coupling matrix, find spectral gap locations, use those to define natural hierarchy levels. Elements that are spectrally close should be grouped first. This is the algebraic multigrid approach.

3. **Backwards fine-graining from MERA**: After the MERA solver finds coarse-level element positions, refine backwards through levels (as in the ML wavelet-MERA paper). Each refinement step adds spatial detail while preserving coarse structure.

4. **Validate causal cones**: For each element in the MERA, compute its causal cone (which elements can influence it through the tensor network). Compare against actual contact neighborhoods. If causal cone ⊃ contact neighborhood, the MERA has the right structure. If not, the hierarchy needs adjustment.

5. **Compare τ = 5/18 against optimal control**: Compute the "restricted friction tensor" of the implosion system (how fast each DOF equilibrates). Derive the theoretically optimal schedule. Compare against the current stretched exponential. This could either validate or improve the schedule.

---

*Wide aperture scan complete. 15 cross-domain hits identified. 5 actionable items extracted. All previous results preserved.*
