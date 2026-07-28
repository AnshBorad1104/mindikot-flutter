import '../models/card.dart';
import '../models/enums.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import 'move_validation_result.dart';
import 'rule_violation.dart';

/// Validates basic, rule-independent card-play preconditions.
///
/// TODO: `docs/game_rules.md` is unavailable. MindiKot-specific requirements
/// such as follow-suit, Hakam, trump, and trick resolution are intentionally
/// excluded from this validator.
class RuleValidator {
  /// Validates whether [playerId] may play [card] in [gameState].
  ///
  /// The returned result is immutable. This method never changes [gameState].
  MoveValidationResult validateMove({
    required GameState gameState,
    required String playerId,
    required Card card,
  }) {
    final Player? player = _playerById(gameState.room.players, playerId);
    if (player == null || player.state != PlayerState.active) {
      return MoveValidationResult(violations: [RuleViolation.invalidPlayer]);
    }

    final hand = gameState.handFor(playerId);
    if (hand.isEmpty) {
      return MoveValidationResult(violations: [RuleViolation.emptyHand]);
    }

    final violations = <RuleViolation>[];
    if (gameState.turnState != TurnState.active) {
      violations.add(RuleViolation.turnNotActive);
    } else if (gameState.currentPlayerId != playerId) {
      violations.add(RuleViolation.notPlayersTurn);
    }
    if (!hand.contains(card)) {
      violations.add(RuleViolation.cardNotOwned);
    }
    if (_hasBeenPlayed(gameState, card)) {
      violations.add(RuleViolation.cardAlreadyPlayed);
    }
    return MoveValidationResult(violations: violations);
  }

  bool _hasBeenPlayed(GameState gameState, Card card) => gameState.round?.tricks
          .expand((trick) => trick.plays)
          .any((play) => play.card == card) ??
      false;
}


Player? _playerById(Iterable<Player> players, String playerId) {
  for (final player in players) {
    if (player.id == playerId) return player;
  }
  return null;
}
