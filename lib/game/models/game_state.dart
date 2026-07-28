import 'card.dart';
import 'deck.dart';
import 'enums.dart';
import 'round.dart';
import 'room.dart';

/// Complete immutable in-progress state required by the pure game engine.
class GameState {
  /// Creates a game state. Hands are copied to prevent external mutation.
  GameState({
    required this.room,
    required this.deck,
    this.round,
    this.currentPlayerId,
    this.turnState = TurnState.notStarted,
    Map<String, Iterable<Card>> hands = const {},
  }) : hands = Map.unmodifiable({
          for (final entry in hands.entries) entry.key: List<Card>.unmodifiable(entry.value),
        });

  /// Room and players for this game.
  final Room room;

  /// Current deck state.
  final Deck deck;

  /// Active or most recently completed round.
  final Round? round;

  /// Player currently expected to act, when a turn is active.
  final String? currentPlayerId;

  /// Lifecycle status of the current turn.
  final TurnState turnState;

  /// Cards held by player identity. Lists are immutable.
  final Map<String, List<Card>> hands;

  /// Returns a defensive immutable view of [playerId]'s hand.
  List<Card> handFor(String playerId) => hands[playerId] ?? const [];
}
