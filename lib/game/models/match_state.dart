import 'enums.dart';
import 'game_state.dart';

/// Immutable match-level state, including completed game snapshots.
class MatchState {
  /// Creates a match state with optional current game and history.
  MatchState({
    required this.id,
    this.currentGame,
    Iterable<GameState> completedGames = const [],
    this.result = MatchResult.undecided,
  })  : assert(id != ''),
        completedGames = List.unmodifiable(completedGames);

  /// Stable match identity owned by the host application.
  final String id;

  /// Current game, if a game has started.
  final GameState? currentGame;

  /// Immutable snapshots of completed games in this match.
  final List<GameState> completedGames;

  /// Overall match result.
  final MatchResult result;
}
