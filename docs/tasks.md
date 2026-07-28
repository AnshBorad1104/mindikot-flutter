# MindiKot Flutter — Task Tracker

> Last updated: 2026-07-28

---

## Legend

- ✅ Done
- 🔄 In Progress
- ⏳ Ready
- ❌ Blocked

---

## Phase 1: Core Game Engine (lib/game/)

### Models ✅

| Task | Owner | Status |
|------|-------|--------|
| Card model (immutable, value equality) | Agent 3 | ✅ |
| Deck model (available + used) | Agent 3 | ✅ |
| Enums (Suit, Rank, PlayerState, RoomState, TurnState, MatchResult) | Agent 3 | ✅ |
| Player model (id, name, teamId, state) | Agent 3 | ✅ |
| Team model (playerIds, score) | Agent 3 | ✅ |
| Room model (players, teams) | Agent 3 | ✅ |
| Round model (tricks, winner) | Agent 3 | ✅ |
| Trick model (plays, winner) | Agent 3 | ✅ |
| GameState model (room, deck, round, hands) | Agent 3 | ✅ |
| MatchState model (current game, history, result) | Agent 3 | ✅ |

### Engine ✅

| Task | Owner | Status |
|------|-------|--------|
| DeckFactory (standard deck creation) | Agent 3 | ✅ |
| DeckEngine (shuffle, remove, restore) | Agent 3 | ✅ |
| ShuffleStrategy (deterministic + random) | Agent 3 | ✅ |
| DealManager (round-robin dealing) | Agent 3 | ✅ |
| TurnManager (turn order, round lifecycle) | Agent 3 | ✅ |
| TrickEngine (start, play, end trick) | Agent 3 | ✅ |

### Events ✅

| Task | Owner | Status |
|------|-------|--------|
| GameEvent base class | Agent 3 | ✅ |
| MatchStarted / MatchEnded events | Agent 3 | ✅ |
| RoundStarted / RoundEnded events | Agent 3 | ✅ |
| TurnStarted / TurnEnded events | Agent 3 | ✅ |
| CardPlayed event | Agent 3 | ✅ |
| Player lifecycle events (join/leave/disconnect/reconnect) | Agent 3 | ✅ |

### Rules (Basic) ✅

| Task | Owner | Status |
|------|-------|--------|
| RuleViolation enum | Agent 3 | ✅ |
| RuleResult base class | Agent 3 | ✅ |
| MoveValidationResult | Agent 3 | ✅ |
| RuleValidator (basic preconditions) | Agent 3 | ✅ |

---

## Phase 2: Game Rules Engine (lib/game/rules/) — Next

| Task | Owner | Status |
|------|-------|--------|
| Document MindiKot rules in `docs/game_rules.md` | Agent 2 | ❌ Blocked (needs rules source) |
| Implement follow-suit enforcement | Agent 2 | ⏳ |
| Implement Hakam (trump) selection | Agent 2 | ⏳ |
| Implement trick winner determination | Agent 2 | ⏳ |
| Implement round/scoring logic | Agent 2 | ⏳ |
| Extend RuleValidator with game-specific rules | Agent 2 | ⏳ |
| Add comprehensive rule tests | Agent 2 | ⏳ |

---

## Phase 3: Game Orchestrator

| Task | Owner | Status |
|------|-------|--------|
| Game orchestrator (connects all engines) | Agent 3 | ⏳ |
| Game loop (deal → play tricks → score → next round) | Agent 3 | ⏳ |
| State transition machine | Agent 3 | ⏳ |
| Orchestrator tests | Agent 3 | ⏳ |

---

## Phase 4: Multiplayer Networking

| Task | Owner | Status |
|------|-------|--------|
| Choose networking approach (WebSocket / Supabase / etc.) | Agent 4 | ⏳ |
| Implement room creation / joining | Agent 4 | ⏳ |
| Implement state synchronization | Agent 4 | ⏳ |
| Implement event broadcasting | Agent 4 | ⏳ |
| Handle disconnection / reconnection | Agent 4 | ⏳ |
| Networking tests | Agent 4 | ⏳ |

---

## Phase 5: Flutter UI

| Task | Owner | Status |
|------|-------|--------|
| Project setup (pubspec.yaml, Flutter integration) | Agent 5 | ⏳ |
| Choose state management (BLoC / Riverpod / etc.) | Agent 5 | ⏳ |
| Home / lobby screen | Agent 5 | ⏳ |
| Game board screen | Agent 5 | ⏳ |
| Card rendering (images or vector) | Agent 5 | ⏳ |
| Player hand display | Agent 5 | ⏳ |
| Trick area display | Agent 5 | ⏳ |
| Score display | Agent 5 | ⏳ |
| Animations (card play, trick win) | Agent 5 | ⏳ |

---

## Phase 6: CI/CD & Assets

| Task | Owner | Status |
|------|-------|--------|
| GitHub Actions workflow (build, test) | TBD | ⏳ |
| APK build workflow | TBD | ⏳ |
| Card image assets | TBD | ⏳ |
| Sound effects | TBD | ⏳ |

---

## Task Dependency Graph

```
M1-M6 (Engine) ──► M8 (Rules) ──► M9 (Orchestrator) ──► M11 (UI)
                 \                              \
                  └──► M10 (Networking) ─────────┘
                 
M7 (Docs) ──► enables all subsequent work
```
