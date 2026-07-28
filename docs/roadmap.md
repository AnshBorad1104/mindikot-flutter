# MindiKot Flutter — Development Roadmap

> Last updated: 2026-07-28

---

## Vision

Build a polished, multiplayer MindiKot card game in Flutter with a clean, testable, pure-Dart game engine at its core.

---

## Milestones

### ✅ M1 — Core Domain Models (Complete)

All immutable, value-equality domain models for cards, decks, players, teams, rooms, rounds, tricks, game state, and match state.

**Deliverables**: 10 model files, 1 enum file, 1 barrel export.

---

### ✅ M2 — Deck Engine (Complete)

Standard deck creation (single/multi), Fisher-Yates shuffle (deterministic + random), card removal/restoration, and round-robin dealing.

**Deliverables**: 4 engine files (`DeckFactory`, `DeckEngine`, `ShuffleStrategy`, `DealManager`).

---

### ✅ M3 — Turn Management (Complete)

Circular seating order, clockwise turn progression, inactive-player skipping, and round start/end lifecycle.

**Deliverables**: 1 engine file (`TurnManager`) with `PlayerOrder`, `CurrentPlayer`, `NextPlayer`, `PreviousPlayer`, `RoundStart`, `RoundEnd`, `SkipInactivePlayer`.

---

### ✅ M4 — Trick Engine (Basic) (Complete)

Single-trick lifecycle: start, play cards, detect completion, end. No winner selection (deferred to M8).

**Deliverables**: 1 engine file (`TrickEngine`).

---

### ✅ M5 — Event System (Complete)

11 immutable event types covering match, round, turn, card-play, and player lifecycle events. Ordered by (sequence, occurredAt).

**Deliverables**: 1 event file with base class + 10 concrete event types.

---

### ✅ M6 — Basic Rule Validator (Complete)

Precondition validation for card plays: player identity, turn check, card ownership, card-not-already-played. Does NOT include MindiKot-specific rules.

**Deliverables**: 4 rule files (`RuleValidator`, `RuleResult`, `MoveValidationResult`, `RuleViolation`).

---

### ✅ M7 — Documentation & Project Scaffolding (This Milestone)

Establish project documentation, architecture docs, task tracker, and roadmap.

**Deliverables**: `docs/progress.md`, `docs/architecture.md`, `docs/game_rules.md`, `docs/tasks.md`, `docs/roadmap.md`, updated `README.md`.

**Agent**: Agent 1 (Project Manager)

---

### ⏳ M8 — MindiKot Game Rules Engine

Implement the complete MindiKot-specific rule set:

- Follow-suit enforcement
- Hakam (trump) suit selection and management
- Trick winner determination (highest trump > highest led suit)
- Card ranking within tricks
- Round scoring logic
- Round winner determination
- Match win condition

**Prerequisites**: `docs/game_rules.md` must be finalized with authoritative rules.

**Agent**: Agent 2 (Game Rules Engineer)

**Estimated scope**: Extend `RuleValidator`, modify `TrickEngine.endTrick()`, modify `TurnManager.endRound()`, add scoring model/logic, add ~50+ tests.

---

### ⏳ M9 — Game Orchestrator

Build the top-level game loop that connects all engines:

- Game lifecycle (initialize → deal → play tricks → score → next round → match end)
- State machine for game progression
- Event emission at each transition
- Integration with event system for replay/undo

**Prerequisites**: M8 complete.

**Agent**: Agent 3 (Game Orchestrator Engineer)

---

### ⏳ M10 — Multiplayer Networking

Add real-time multiplayer support:

- Choose transport (WebSocket, Supabase Realtime, Firebase, etc.)
- Room creation and joining
- State synchronization between players
- Event broadcasting
- Disconnection/reconnection handling
- Input validation on the server side

**Prerequisites**: M9 complete (or parallel with M9 if architecture is clear).

**Agent**: Agent 4 (Networking Engineer)

---

### ⏳ M11 — Flutter UI

Build the game's visual interface:

- Project scaffolding (pubspec.yaml, Flutter project setup)
- State management layer (BLoC, Riverpod, or Provider)
- Lobby/home screen
- Game board with card display
- Player hand visualization
- Trick area with card animations
- Score display
- Responsive layout for phone/tablet

**Prerequisites**: M9 complete (M10 for multiplayer UI).

**Agent**: Agent 5 (Flutter UI Engineer)

---

### ⏳ M12 — CI/CD & Quality

- GitHub Actions for build + test on push
- APK build pipeline
- Code coverage reporting
- Lint rules (flutter_lints / very_good_analysis)

---

### ⏳ M13 — Assets & Polish

- Card face/back images
- Sound effects (card play, trick win, round end)
- Haptic feedback
- App icon and splash screen

---

## Timeline Estimate

| Milestone | Estimated Duration | Dependencies |
|-----------|-------------------|--------------|
| M1–M6 | ✅ Done | — |
| M7 | 1 session | — |
| M8 | 2–3 sessions | M7, game rules source |
| M9 | 1–2 sessions | M8 |
| M10 | 2–3 sessions | M9 |
| M11 | 3–5 sessions | M9 (M10 for multiplayer) |
| M12 | 1 session | M11 |
| M13 | 2–3 sessions | M11 |

---

## Risk Factors

1. **Game rules ambiguity**: Without an authoritative MindiKot rules document, M8 is blocked.
2. **TrickEngine mutability**: The stateful `TrickEngine` may complicate multiplayer sync. Consider redesigning to return new state.
3. **No Flutter project setup**: `pubspec.yaml` is missing. Flutter integration requires project scaffolding before M11.
4. **Scope creep on UI**: Card game UIs can be complex. Keep M11 minimal for v1.
