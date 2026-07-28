import '../models/card.dart';
import '../models/trick.dart';
import 'turn_manager.dart';

/// Manages one in-progress trick while leaving rule and winner decisions to
/// their dedicated engines.
class TrickEngine {
  /// Creates a trick engine that completes a trick after [playerCount] plays.
  TrickEngine({required this.playerCount}) {
    if (playerCount < 1) {
      throw ArgumentError.value(playerCount, 'playerCount', 'must be positive');
    }
  }

  /// Number of player turns required to complete a trick.
  final int playerCount;

  Trick? _currentTrick;

  /// The active trick, or null if no trick has been started.
  Trick? get currentTrick => _currentTrick;

  /// Cards played in the active trick, in play order.
  List<Card> get playedCards => List.unmodifiable(
        _currentTrick?.plays.map((play) => play.card) ?? const <Card>[],
      );

  /// Whether the active trick has received [playerCount] plays.
  bool get isTrickComplete =>
      _currentTrick != null && _currentTrick!.plays.length == playerCount;

  /// Starts an empty trick led by [leader] selected by the turn manager.
  ///
  /// Throws [StateError] if another trick has not yet been ended.
  Trick startTrick(CurrentPlayer leader) {
    if (_currentTrick != null) {
      throw StateError('End the current trick before starting another trick.');
    }
    _currentTrick = Trick(leaderId: leader.playerId);
    return _currentTrick!;
  }

  /// Adds [card] to the active trick for [player] selected by the turn manager.
  ///
  /// Throws [StateError] when no trick is active, the trick is complete, the
  /// player has already played, or the physical card is already in this trick.
  Trick playCard({required CurrentPlayer player, required Card card}) {
    final trick = _currentTrick;
    if (trick == null) {
      throw StateError('Start a trick before playing a card.');
    }
    if (isTrickComplete) {
      throw StateError('Cannot play a card after the trick is complete.');
    }
    if (trick.hasPlayed(player.playerId)) {
      throw StateError('A player may play only once in a trick.');
    }
    if (trick.plays.any((play) => play.card == card)) {
      throw StateError('This physical card has already been played in this trick.');
    }
    _currentTrick = Trick(
      leaderId: trick.leaderId,
      plays: [...trick.plays, TrickPlay(playerId: player.playerId, card: card)],
    );
    return _currentTrick!;
  }

  /// Ends and returns the active trick, then clears it from this engine.
  ///
  /// TODO: `docs/game_rules.md` is unavailable, so ending a trick deliberately
  /// does not select a winner or the leader of a subsequent trick.
  Trick endTrick() {
    final trick = _currentTrick;
    if (trick == null) {
      throw StateError('There is no active trick to end.');
    }
    _currentTrick = null;
    return trick;
  }
}
