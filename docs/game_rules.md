# MindiKot — Game Rules Reference

> **Status**: DRAFT — This file is a placeholder. Game-specific rules need expert review.

---

## Overview

MindiKot is a trick-taking card game played by 4 players in 2 teams. It uses a standard 52-card deck (or double deck for certain variants).

---

## Known Rules (To Be Confirmed)

> ⚠️ The following is a general outline and must be verified against the official MindiKot rules before implementation.

### Players & Teams

- 4 players, divided into 2 teams of 2
- Partners sit across from each other (alternating seats)
- Teams: Team 1 (players at seats 0, 2) and Team 2 (players at seats 1, 3)

### Deck & Dealing

- Standard 52-card deck (or 104 cards for double-deck variant)
- Cards dealt evenly to all 4 players (13 cards each for single deck)
- Deal proceeds clockwise, round-robin

### Trump / Hakam

- A trump suit (Hakam) is designated for each round
- Trump cards outrank all non-trump cards
- *Exact Hakam selection mechanism TBD (dealt card, declared by dealer, etc.)*

### Trick Play

- Leader of the first trick: designated starting player (varies by round)
- Each player plays one card per trick, clockwise from the leader
- **Follow-suit rule**: Players must follow the suit led, if able
- If a player cannot follow suit, they may play any card (including trump)
- Trick is won by the highest trump played, or if no trump, the highest card of the led suit

### Trick Winner

- Winner of a trick leads the next trick
- All 4 cards of a completed trick are collected by the winning team

### Scoring

- Each team accumulates cards won in tricks
- *Specific scoring TBD (count certain cards, Mindi card value, etc.)*

### Round & Match

- A round consists of 13 tricks (single deck) or 26 tricks (double deck)
- A match consists of multiple rounds
- *Match win condition TBD (first to X points, best of N rounds, etc.)*

---

## Implementation Status

| Rule | Engine Support | Notes |
|------|---------------|-------|
| 4-player, 2-team setup | ✅ Models exist | Room, Team, Player models support this |
| Deck & dealing | ✅ Complete | DeckFactory, DealManager |
| Turn order (clockwise) | ✅ Complete | TurnManager |
| Trick lifecycle (start/play/end) | ✅ Basic | TrickEngine manages play, but no winner |
| Follow-suit enforcement | ❌ Not implemented | Requires `docs/game_rules.md` to be finalized |
| Hakam (trump) selection | ❌ Not implemented | No trump model or logic |
| Trick winner determination | ❌ Not implemented | `endTrick()` has TODO |
| Round winner determination | ❌ Not implemented | `endRound()` has TODO |
| Scoring | ❌ Not implemented | No scoring logic |
| Match lifecycle | ❌ Not implemented | MatchState model exists, no orchestrator |

---

## Open Questions

1. **How is the Hakam (trump) suit determined?** Is it declared by a player, revealed from a dealt card, or fixed?
2. **Is the "Mindi" card special?** Does it have a specific rank/value?
3. **How are points scored?** Is it based on card count, specific card values, or trick count?
4. **What determines the match winner?** First team to reach a point threshold? Best of N rounds?
5. **Is there a double-deck variant?** If so, how does it differ from single-deck?
6. **Are there any special card rankings?** (e.g., Ace high, or specific cards beating others)

---

## Next Steps

This document must be completed and reviewed by someone with authoritative knowledge of MindiKot rules before Agent 2 (Game Rules Engineer) can implement:
- Follow-suit enforcement in `RuleValidator`
- Trick winner determination in `TrickEngine`
- Round/scoring logic
- Hakam integration
