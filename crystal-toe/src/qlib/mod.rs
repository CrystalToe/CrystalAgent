// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// qlib/ — Quantum computing library from End(A_F)
//
// 8 sub-modules ported from the Haskell Q* library:
//   base         — Complex arithmetic, vectors, matrices, crystal constants
//   gates        — 12 single-qudit gates + multi-particle gates
//   channels     — Quantum channels (noise/decoherence) from sector structure
//   entangle     — 12 entanglement tools, PPT exact for ℂ²⊗ℂ³
//   hamiltonians — 12 Hamiltonians from crystal sector structure
//   algorithms   — 15 quantum algorithms in crystal sector basis
//   measure      — 8 measurement operators from sector structure
//   simulation   — 12 numerical simulation methods

pub mod base;
pub mod gates;
pub mod channels;
pub mod entangle;
pub mod hamiltonians;
pub mod algorithms;
pub mod measure;
pub mod simulation;
