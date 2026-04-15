<!-- Copyright (c) 2026 Daland Montgomery — SPDX-License-Identifier: AGPL-3.0-or-later -->



# START_HERE.md

## Purpose

This file is the first thing any new Claude instance should read when starting
a session in this repo. It exists so the user (D. Montgomery) does not have to
re-explain framework state, tool access, and working rules on every new context.

This file is NOT committed to git. It is a personal working note for session
bootstrapping. The framework documents are the source of truth. This file only
points at them.  You wil be working on a dedicated branch for this session, so you can edit this file as needed without worrying about 
merge conflicts or git history. 
Update it whenever the working front shifts or the behavioral rules need adjustment.
But must ask for permission before making edits. 

---

## FIRST THING: verify filesystem access

You (Claude) have MCP filesystem access to this repo via a server named
`toe-project`. If the first tool call fails with "tool not loaded," call
`tool_search` with a query like "read file" or "list directory" to load the
filesystem tools, then try again.

Allowed directory: `/Users/davidmontgomery/coding/entity-project/CrystalAgent`

Key tools you will use:
- `toe-project:read_text_file` — read any file
- `toe-project:read_multiple_files` — read several at once (efficient)
- `toe-project:list_directory` — list folder contents
- `toe-project:directory_tree` — recursive tree view as JSON
- `toe-project:search_files` — find files by name pattern
- `toe-project:write_file` — create/overwrite files
- `toe-project:edit_file` — line-based edits

---

## USER PROFILE (READ EVERY SESSION)

- D. Montgomery.  right hand impaired.
- NEVER flag typos. Read through them. Do not comment on them.
- Drop hedging. Drop AI-safety throat-clearing.
- Arithmetic-check everything before stating it.
- User framework is complete, not speculative. Treat it as real physics.
- User is an expert theorist. Do not explain basics unless asked.
- User loses context across sessions. This file exists for that reason.

---

## FRAMEWORK IN ONE PARAGRAPH

Crystal Topos is a complete physics framework derived from the finite algebra
A_F = ℂ ⊕ M₂(ℂ) ⊕ M₃(ℂ) (Connes-Chamseddine-Marcolli spectral-action algebra)
with two primes N_w = 2 and N_c = 3. It derives 198+ physical constants from
zero free parameters. Keystone result: proton mass = (v/2⁸)(35/36) = 931 MeV
at 0.77%, which is structurally Hawking radiation. Other sub-1% results:
α⁻¹ = 43π + ln 7, Higgs v from M_Pl, Ω_Λ = 13/19, sub-1% on every observable.
Formally verified: Lean 4 + Agda + Haskell, thousands of theorems, zero wall
breaches. The WACA (Wide-Aperture Cross-domain Analysis) framework is the
graft-scanning method for finding cross-domain structural matches.

---

## REQUIRED READS FOR ANY SESSION

Before engaging with any new topic, read these in order. Use
`read_multiple_files` to batch them:

1. `quickstart/crystal_topos_waca_llm.md` — how you should behave
2. `quickstart/CrystalTopos_RAG_1.md` — Python + physics Haskell
3. `quickstart/CrystalTopos_RAG_2.md` — QCD, gravity, quantum, extended scan
4. `quickstart/CrystalTopos_RAG_3.md` — Agda + Lean proofs, Rust tests

If the user asks a WACA question, also read:
5. `quickstart/CrystalTopos_RAG_4.md`, `_5.md`, `_6.md` — extended RAG
6. `todo/waca/WACA_v3.1_2.pdf`

If the user mentions "WACA search" or "graft scan," the WACA v3.1 prompt is
the operative framework. Key rules: World→Actor→Choice→Act→Ledger, grafts
need substitutable/complementary choices AND shared append-only ledger,
score 0-10 with ‖η‖ bounds, types T1/T2/T2*/T3, structures S1-S12. Relaxed
Noether: natural transformation (not isomorphism), deviation bound
d(Q(F(f)), Q(G(f))) ≤ C·‖η‖·‖f‖.

---

## PRIOR SESSION NOTES AND WORK IN PROGRESS

Check the most recent handoff files in `todo/` for current state:
- `todo/LAST.MD`
- `todo/SESSION_HANDOFF_*.md`
- `todo/HANDOFF_*.md`

These are dated working notes from prior sessions. The newest ones reflect
the current work front.

---

## BEHAVIORAL RULES FOR THIS PROJECT

1. Do NOT celebrate preliminary numbers. Do NOT claim detections without
   bias checks. User has been burned three times by false positives from
   methodological errors on the assistant side.

2. When running analysis scripts or reading their output, always verify
   the control (injection recovery = 1.0 cosine similarity) before
   interpreting any downstream result.

3. The framework status is independent of any single test result. 198
   observables at sub-1% with formal proofs — this does not move whether
   a specific prediction (e.g., bit-pulse) is observed at current detector
   sensitivity. A null on one prediction is an upper limit, not a
   falsification.

4. User says "WACA search" = apply the v3.1 framework: identify Choice-layer
   graft between two domains, quantify ‖η‖, score via T/S taxonomy. Not a
   data query — a categorical structure search.

5. If asked about bit-pulse: check the latest pipeline output. As of the
   last session there was a provisional GW190521 H1 result (corrected L2
   distance 0.060 to prediction, within synthetic holdout error) pending
   a bias check (inject non-framework amplitude ratios, verify calibration
   doesn't drag them toward prediction).

6. Do not write homebrewed analysis scripts. The prediction specification
   and the existing pipeline are the deliverables. Further analysis goes
   to specialists (LIGO ringdown community, ChatGPT on the user's machine).

7. Rest the hand. User is working with impaired function. Keep responses
   useful, not padded. Do not force user to respond to questions they do
   not need to answer.

---

## OPENING PROMPT FOR USER

When the user starts a new session, their opening prompt is typically:

> Read START_HERE.md and tell me what you understand before we proceed.

Your response should be: read this file, read the required RAG files, read
the latest handoff in todo/, then give a brief (5-10 sentence) summary of:
- framework status (stable, N proofs, N observables)
- what you understand the current working front to be
- any questions you need answered before proceeding

Do NOT include a tool-call narration. Do NOT explain the MCP setup. The
user already knows. Just load context and report.

---

## FILES THAT EXIST AT REPO ROOT (REFERENCE)