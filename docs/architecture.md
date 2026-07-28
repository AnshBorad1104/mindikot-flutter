# MindiKot Flutter — Architecture

> Last updated: 2026-07-28

---

## Overview

MindiKot Flutter is a **pure-Dart game engine** for the MindiKot card game, designed with immutability-first principles to support future multiplayer networking and Flutter UI integration.

The engine is structured as a **library of composable, testable modules** with no framework dependencies.

---

## Design Principles

1. **Immutability-first**: All models (`Card`, `Deck`, `GameState`, `Round`, `Trick`, etc.) are immutable value objects with value equality.
2. **Pure Dart**: No Flutter, dart:io, or web dependencies in the engine layer. Pure `dart:math` only for shuffle.
3. **Engine ≠ UI**: The game engine produces state and events; it does not render or manage widgets.
4. **Engine ≠ Network**: The engine does not own transport. The host application pushes events and state mutations.
5. **Defensive copies**: All collections passed into constructors are defensively copied and made immutable.

---

## Module Structure

```
lib/game/
├── game.dart                     # Barrel export (single library directive)
├── models/                       # Immutable domain value types
│   ├── card.dart                 # Card (id, suit, rank)
│   ├── deck.dart                 # Deck (available + used cards)
│   ├── enums.dart                # Suit, Rank, PlayerState, RoomState, TurnState, MatchResult
│   ├── game_state.dart           # GameState (room, deck, round, hands, turn)
│   ├── match_state.dart          # MatchState (current game, history, result)
│   ├── player.dart               # Player (id, name, teamId, state)
│   ├── room.dart                 # Room (id, players, teams, state)
│   ├── round.dart                # Round (number, tricks, winner)
│   ├── team.dart                 # Team (id, playerIds, score)
│   └── trick.dart                # Trick (plays, winner) + TrickPlay
├── engine/                       # Stateless or minimally-stateful engines
│   ├── deck_factory.dart         # Creates standard 52-card decks (single/multi)
│   ├── deck_engine.dart          # Shuffle, remove, restore operations
│   ├── shuffle_strategy.dart     # Deterministic and random Fisher-Yates
│   ├── deal_manager.dart         # Round-robin card dealing
│   ├── trick_engine.dart         # Single-trick lifecycle (start, play, end)
│   └── turn_manager.dart         # Turn order, inactive-player skip, round lifecycle
├── events/                       # Event types for event-sourcing / replay
│   └── game_event.dart           # 11 concrete event types (match, round, turn, card, player)
└── rules/                        # Validation and rule enforcement
    ├── rule_violation.dart       # Violation enum
    ├── rule_result.dart          # Base validation result
    ├── move_validation_result.dart # Card-play validation result
    └── rule_validator.dart       # Basic preconditions (game-specific rules pending)
```

---

## Data Flow

```
                    ┌──────────────┐
                    │  Host App    │  (Flutter UI / Network)
                    └──────┬───────┘
                           │ creates/updates
                           ▼
┌──────────────────────────────────────────────────┐
│               Immutable State Layer               │
│                                                    │
│  MatchState ──► GameState ──► Round ──► Trick      │
│       │              │                              │
│       │         ┌────┴────┐                        │
│       │         │  Room   │                        │
│       │         │ Players │                        │
│       │         │  Teams  │                        │
│       │         └─────────┘                        │
│       │              │                              │
│       │         ┌────┴────┐                        │
│       │         │  Deck   │                        │
│       │         │  Card[] │                        │
│       │         └─────────┘                        │
└──────────────────────────────────────────────────┘
                           │
                           │ passed to (never mutated by)
                           ▼
┌──────────────────────────────────────────────────┐
│               Engine Layer                         │
│                                                    │
│  DeckFactory  ──► DeckEngine  ──► DealManager     │
│                                                    │
│  TurnManager  (pure functions, stateless)          │
│  TrickEngine  (stateful: tracks current trick)     │
│  RuleValidator (validates moves against state)     │
└──────────────────────────────────────────────────┘
                           │
                           │ emits
                           ▼
┌──────────────────────────────────────────────────┐
│               Event Layer                          │
│                                                    │
│  GameEvent (MatchStarted, RoundStarted,            │
│             TurnStarted, CardPlayed, ...)          │
│                                                    │
│  Ordered by (sequence, occurredAt)                 │
└──────────────────────────────────────────────────┘
```

---

## Key Design Decisions

### Physical Card Identity

Cards use a stable `id` field (e.g., `deck-0-clubs-two`) to distinguish physical cards from the same value in different decks. This supports multi-deck MindiKot variants and event-sourced replay.

### Immutable Models, Mutable Engines

Domain models are fully immutable. `TrickEngine` is the sole mutable engine (tracks the current trick). `TurnManager` is stateless — all methods are pure functions. This separation makes the models safe to serialize, cache, and transmit.

### No Winner Logic Yet

`TrickEngine.endTrick()` and `TurnManager.endRound()` deliberately do NOT select winners or next-round starters. These require game-specific rules documented in `docs/game_rules.md` (currently missing).

### Event Ordering

Events use a `(sequence, occurredAt)` tuple for deterministic ordering. The host application assigns sequence values; the engine does not generate them.

---

## Missing Layers (Planned)

| Layer | Path | Status |
|-------|------|--------|
| Flutter UI | `lib/features/` | Not started |
| Multiplayer networking | `lib/multiplayer/` | Not started |
| Assets (card images) | `assets/` | Not started |
| CI/CD | `.github/workflows/` | Not started |
| Game-specific rules | `lib/game/rules/` (extended) | Not started |

---

## Dependencies

| Dependency | Status |
|------------|--------|
| `dart:core` | ✅ Used |
| `dart:math` | ✅ Used (shuffle only) |
| `package:test` | ✅ Used (dev dependency) |
| Flutter SDK | ❌ Not configured (no pubspec.yaml) |
| External packages | ❌ None |

---

## Testing Strategy

All tests use `package:test` (pure Dart, no Flutter test runner). Tests cover:

- **Value equality**: Models with the same fields are equal
- **Immutability**: Collections cannot be mutated after construction
- **Validation**: Invalid inputs throw `ArgumentError` or `StateError`
- **Engine behavior**: Deck operations, dealing, trick lifecycle, turn order
- **Event ordering**: Events sort correctly by sequence and time
