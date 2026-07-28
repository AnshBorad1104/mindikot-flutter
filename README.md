# MindiKot Flutter

A trick-taking card game engine for Flutter, built with pure-Dart immutability-first principles.

---

## Status

**Current Phase**: Core game engine complete (M1–M6). Documentation scaffolding in progress (M7).  
**Branch**: `arena/019fa926-mindikot-flutter`  
**Latest Commit**: `56a7724` — `feat(game): add single trick management engine`

---

## What's Built

### Pure-Dart Game Engine (`lib/game/`)

| Layer | Components | Status |
|-------|-----------|--------|
| **Models** | Card, Deck, Player, Team, Room, Round, Trick, GameState, MatchState | ✅ Complete |
| **Engine** | DeckFactory, DeckEngine, ShuffleStrategy, DealManager, TrickEngine, TurnManager | ✅ Complete |
| **Events** | 11 immutable event types (match, round, turn, card, player lifecycle) | ✅ Complete |
| **Rules** | RuleValidator (basic preconditions only — MindiKot-specific rules pending) | ✅ Basic |

### Tests (`test/game/`)

6 test files covering all models, engines, events, and basic rule validation.

---

## What's Not Built Yet

- **MindiKot-specific rules** (follow-suit, Hakam/trump, trick winner, scoring)
- **Game orchestrator** (full game loop)
- **Multiplayer networking** (`lib/multiplayer/`)
- **Flutter UI** (`lib/features/`)
- **Project scaffolding** (`pubspec.yaml`)
- **CI/CD** (`.github/workflows/`)
- **Assets** (card images, sounds)

---

## Project Structure

```
mindikot-flutter/
├── README.md
├── docs/
│   ├── progress.md        # Detailed progress report
│   ├── architecture.md    # Architecture & design decisions
│   ├── game_rules.md      # Game rules reference (DRAFT)
│   ├── tasks.md           # Task tracker
│   └── roadmap.md         # Development roadmap
├── lib/
│   └── game/
│       ├── game.dart      # Barrel export
│       ├── models/        # Immutable domain types
│       ├── engine/        # Game engines (deck, deal, turn, trick)
│       ├── events/        # Event types
│       └── rules/         # Rule validation
└── test/
    └── game/              # Unit tests
```

---

## Getting Started

> ⚠️ No `pubspec.yaml` yet. Tests run with pure Dart:

```bash
dart test test/
```

---

## Architecture

See [docs/architecture.md](docs/architecture.md) for the full architecture overview.

**Key design principles:**
- All models are **immutable** with **value equality**
- Engine is **pure Dart** (no Flutter dependency)
- State flows from models → engines → events
- Host application (Flutter UI / network) owns state mutations

---

## Documentation

| Document | Description |
|----------|-------------|
| [docs/progress.md](docs/progress.md) | Current milestone status, completed work, risks |
| [docs/architecture.md](docs/architecture.md) | Module structure, data flow, design decisions |
| [docs/game_rules.md](docs/game_rules.md) | MindiKot rules reference (DRAFT — needs expert review) |
| [docs/tasks.md](docs/tasks.md) | Task tracker by phase and agent |
| [docs/roadmap.md](docs/roadmap.md) | Development milestones and timeline |

---

## Next Steps

1. **Finalize game rules** in `docs/game_rules.md` (needs authoritative MindiKot rules source)
2. **Implement MindiKot-specific rules** (Agent 2: follow-suit, trump, trick winner, scoring)
3. **Build game orchestrator** (Agent 3: full game loop)
4. **Add multiplayer networking** (Agent 4)
5. **Build Flutter UI** (Agent 5)

---

## License

TBD
