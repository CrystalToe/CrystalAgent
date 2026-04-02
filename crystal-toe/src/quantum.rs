// Copyright (c) 2026 Daland Montgomery
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// quantum.rs — 96 quantum operators from A_F
//
// TODO: Port from CrystalQuantum.hs + 8 Q* modules
// Operators act on the χ=6 dimensional Hilbert space.

use crate::atoms::*;

/// Hilbert space dimension = χ = 6.
pub const HILBERT_DIM: u64 = CHI;

/// Number of quantum operators.
pub const N_OPERATORS: u64 = 96;

/// Operator algebra dimension: χ² = 36.
pub const OPERATOR_DIM: u64 = CHI * CHI;

// TODO: Port the 8 Q* sub-modules:
// QBasis.hs     — basis states
// QOperator.hs  — operator construction
// QEigen.hs     — eigenvalue decomposition
// QEntangle.hs  — entanglement measures
// QChannel.hs   — quantum channels
// QError.hs     — error correction
// QCircuit.hs   — circuit model
// QMeasure.hs   — measurement theory
