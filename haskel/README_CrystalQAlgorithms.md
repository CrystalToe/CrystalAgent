<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->

# CrystalQAlgorithms — 15 Quantum Algorithms from (2,3)

## What This Module Does

Implements 15 quantum algorithms operating on ℂ^χ = ℂ⁶ with gate set from U(6).
Every algorithm uses the crystal sector basis and sector eigenvalues.

### Algorithms

1. **Grover search** — oracle flips target sector phase, diffusion amplifies. O(√χ) iterations.
2. **Amplitude amplification** — generalised Grover, iterates to max probability.
3. **QFT** — χ-point discrete Fourier transform, ω = e^(2πi/χ).
4. **Inverse QFT** — conjugate of QFT.
5. **QPE** — quantum phase estimation extracts sector eigenvalues {1, 1/2, 1/3, 1/6}.
6. **Phase kickback** — controlled-U imprints eigenvalue phase on control.
7. **VQE** — variational eigensolver computes ⟨ψ(θ)|H|ψ(θ)⟩ with diagonal H = {0, ln2, ln3, ln6}.
8. **QAOA** — cost phase exp(−iγC) then mixer exp(−iβB) on sector basis.
9. **HHL** — linear systems solver with crystal Hamiltonian A = H.
10. **Teleportation** — perfect state transfer via Bell pair + classical channel.
11. **Superdense coding** — encode χ² = 36 messages per entangled pair.
12. **BB84 QKD** — key distribution in sector basis and Hadamard basis.
13. **Quantum walk** — coin + shift on 4-node sector graph.
14. **Simon's algorithm** — hidden period oracle on Z_χ.
15. **Bernstein-Vazirani** — hidden string oracle with phase kickback.

## Engine Wiring

**Status: WIRED.** Module #20 on the Engine Wiring Work List.

- **`import qualified CrystalEngine as CE`** for engine functions.
- **Atoms from CrystalQBase** (same Int type as engine).
- **`toCrystalState` / `fromCrystalState`** — mixed sector (d₄=24).
- **`proveSectorRestriction`** — round-trip test.
- **`main`** with Grover, QFT, QAOA, VQE tests + engine wiring checks.

### Sector

**Mixed (d=24).** Quantum algorithms act on internal Hilbert space indices.
No spatial (weak) or gauge (colour) coupling.

## Self-Test

```bash
ghc -O2 -main-is CrystalQAlgorithms CrystalQAlgorithms.hs && ./CrystalQAlgorithms
```

## Proof Certificate

- `proofs/CrystalQAlgorithms.lean`
- `proofs/CrystalQAlgorithms.agda`
