import 'trick.dart';

/// Immutable state and outcome data for one round.
class Round {
  /// Creates a round with a positive sequential [number].
  Round({
    required this.number,
    required this.startingPlayerId,
    Iterable<Trick> tricks = const [],
    this.winnerTeamId,
  })  : assert(number > 0),
        assert(startingPlayerId != ''),
        tricks = List.unmodifiable(tricks);

  /// One-based round number within a match.
  final int number;

  /// Player who starts the first trick in this round.
  final String startingPlayerId;

  /// Completed and active tricks in order.
  final List<Trick> tricks;

  /// Winning team when the round is complete.
  final String? winnerTeamId;

  /// The currently active unresolved trick, if any.
  Trick? get activeTrick => tricks.where((trick) => trick.winnerId == null).lastOrNull;
}

extension _IterableLastOrNull<T> on Iterable<T> {
  T? get lastOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    var result = iterator.current;
    while (iterator.moveNext()) {
      result = iterator.current;
    }
    return result;
  }
}
