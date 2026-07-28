import 'card.dart';

/// A card played by a player during a trick.
class TrickPlay {
  /// Creates a play for [playerId] using [card].
  const TrickPlay({required this.playerId, required this.card}) : assert(playerId != '');

  /// Identity of the player who played the card.
  final String playerId;

  /// Card played by the player.
  final Card card;

  @override
  bool operator ==(Object other) =>
      other is TrickPlay && other.playerId == playerId && other.card == card;

  @override
  int get hashCode => Object.hash(playerId, card);
}

/// Immutable record of one trick's plays and optional winner.
class Trick {
  /// Creates a trick with a non-empty [leaderId].
  Trick({required this.leaderId, Iterable<TrickPlay> plays = const [], this.winnerId})
      : assert(leaderId != ''),
        plays = List.unmodifiable(plays) {
    if (this.plays.map((play) => play.playerId).toSet().length != this.plays.length) {
      throw ArgumentError('A player may play only once in a trick.');
    }
    if (winnerId != null && !this.plays.any((play) => play.playerId == winnerId)) {
      throw ArgumentError.value(winnerId, 'winnerId', 'must identify a player in plays');
    }
  }

  /// Player who led this trick.
  final String leaderId;

  /// Plays in the order made.
  final List<TrickPlay> plays;

  /// Winner after the trick has been resolved, or null while unresolved.
  final String? winnerId;

  /// Returns whether a player has already played in this trick.
  bool hasPlayed(String playerId) => plays.any((play) => play.playerId == playerId);
}
