import '../models/enums.dart';
import '../models/player.dart';

/// Immutable seating order used by the turn engine.
class PlayerOrder {
  /// Creates a non-empty seating order of uniquely identified players.
  PlayerOrder(Iterable<String> playerIds) : playerIds = List.unmodifiable(playerIds) {
    if (this.playerIds.isEmpty) {
      throw ArgumentError.value(playerIds, 'playerIds', 'must not be empty');
    }
    if (this.playerIds.any((id) => id.isEmpty) ||
        this.playerIds.toSet().length != this.playerIds.length) {
      throw ArgumentError.value(
        playerIds,
        'playerIds',
        'must contain unique non-empty player ids',
      );
    }
  }

  /// Player identifiers in clockwise order.
  final List<String> playerIds;

  /// Returns the seat index for [playerId].
  int indexOf(String playerId) {
    final index = playerIds.indexOf(playerId);
    if (index == -1) {
      throw ArgumentError.value(playerId, 'playerId', 'is not in this player order');
    }
    return index;
  }

  /// Returns the player at [index], wrapping around the seating order.
  String playerAt(int index) => playerIds[index % playerIds.length];
}

/// A player selected as the current actor and their seat index.
class CurrentPlayer {
  /// Creates a current-player selection.
  const CurrentPlayer({required this.playerId, required this.seatIndex});

  /// Identity of the selected player.
  final String playerId;

  /// Zero-based seat index in the associated [PlayerOrder].
  final int seatIndex;

  @override
  bool operator ==(Object other) =>
      other is CurrentPlayer &&
      other.playerId == playerId &&
      other.seatIndex == seatIndex;

  @override
  int get hashCode => Object.hash(playerId, seatIndex);
}

/// The next active player selected by the turn engine.
class NextPlayer extends CurrentPlayer {
  /// Creates a next-player selection.
  const NextPlayer({required super.playerId, required super.seatIndex});
}

/// The previous active player selected by the turn engine.
class PreviousPlayer extends CurrentPlayer {
  /// Creates a previous-player selection.
  const PreviousPlayer({required super.playerId, required super.seatIndex});
}

/// Result emitted when a round starts.
class RoundStart {
  /// Creates a round-start result with the first active [currentPlayer].
  const RoundStart(this.currentPlayer);

  /// First player allowed to act in the new round.
  final CurrentPlayer currentPlayer;
}

/// Result emitted when a round ends.
class RoundEnd {
  /// Creates a round-end result after [lastPlayer] acted.
  const RoundEnd(this.lastPlayer);

  /// Last player to act before the round ended.
  final CurrentPlayer lastPlayer;
}

/// Describes inactive seats bypassed while selecting an active player.
class SkipInactivePlayer {
  /// Creates a skipped-player result.
  SkipInactivePlayer({required Iterable<String> playerIds, required this.selectedPlayer})
      : playerIds = List.unmodifiable(playerIds);

  /// Inactive players bypassed in seating order.
  final List<String> playerIds;

  /// Active player selected after the skipped seats.
  final CurrentPlayer selectedPlayer;
}

/// Computes turn order without mutating player or game state.
class TurnManager {
  /// Returns [playerId] as the current player after validating its seat.
  CurrentPlayer currentPlayer(PlayerOrder order, String playerId) => CurrentPlayer(
        playerId: playerId,
        seatIndex: order.indexOf(playerId),
      );

  /// Returns the next active player after [playerId], skipping inactive players.
  NextPlayer nextPlayer({
    required PlayerOrder order,
    required Iterable<Player> players,
    required String playerId,
  }) {
    final selection = _findActive(
      order: order,
      players: players,
      fromPlayerId: playerId,
      direction: 1,
    );
    return NextPlayer(
      playerId: selection.selectedPlayer.playerId,
      seatIndex: selection.selectedPlayer.seatIndex,
    );
  }

  /// Returns the previous active player before [playerId], skipping inactive players.
  PreviousPlayer previousPlayer({
    required PlayerOrder order,
    required Iterable<Player> players,
    required String playerId,
  }) {
    final selection = _findActive(
      order: order,
      players: players,
      fromPlayerId: playerId,
      direction: -1,
    );
    return PreviousPlayer(
      playerId: selection.selectedPlayer.playerId,
      seatIndex: selection.selectedPlayer.seatIndex,
    );
  }

  /// Starts a round at [startingPlayerId], or the next active player if needed.
  RoundStart startRound({
    required PlayerOrder order,
    required Iterable<Player> players,
    required String startingPlayerId,
  }) {
    final selection = _findActive(
      order: order,
      players: players,
      fromPlayerId: startingPlayerId,
      direction: 1,
      includeStartingPlayer: true,
    );
    return RoundStart(selection.selectedPlayer);
  }

  /// Ends a round after [lastPlayerId] has acted.
  ///
  /// TODO: `docs/game_rules.md` is unavailable, so this method deliberately
  /// does not select a winner, leader, or next-round starter.
  RoundEnd endRound(PlayerOrder order, String lastPlayerId) =>
      RoundEnd(currentPlayer(order, lastPlayerId));

  /// Selects the next active player and records inactive players bypassed.
  SkipInactivePlayer skipInactivePlayers({
    required PlayerOrder order,
    required Iterable<Player> players,
    required String fromPlayerId,
    int direction = 1,
    bool includeStartingPlayer = false,
  }) {
    if (direction != 1 && direction != -1) {
      throw ArgumentError.value(direction, 'direction', 'must be 1 or -1');
    }
    return _findActive(
      order: order,
      players: players,
      fromPlayerId: fromPlayerId,
      direction: direction,
      includeStartingPlayer: includeStartingPlayer,
    );
  }

  SkipInactivePlayer _findActive({
    required PlayerOrder order,
    required Iterable<Player> players,
    required String fromPlayerId,
    required int direction,
    bool includeStartingPlayer = false,
  }) {
    final playerStates = {for (final player in players) player.id: player.state};
    if (playerStates.length != players.length) {
      throw ArgumentError.value(players, 'players', 'must have unique ids');
    }
    if (!playerStates.keys.toSet().containsAll(order.playerIds)) {
      throw ArgumentError.value(players, 'players', 'must include every player in order');
    }
    final origin = order.indexOf(fromPlayerId);
    final skipped = <String>[];
    final startOffset = includeStartingPlayer ? 0 : 1;
    for (var offset = startOffset; offset < order.playerIds.length + startOffset; offset++) {
      final seatIndex = (origin + (direction * offset)) % order.playerIds.length;
      final candidate = order.playerAt(seatIndex);
      if (playerStates[candidate] == PlayerState.active) {
        return SkipInactivePlayer(
          playerIds: skipped,
          selectedPlayer: CurrentPlayer(playerId: candidate, seatIndex: seatIndex),
        );
      }
      skipped.add(candidate);
    }
    throw StateError('Cannot select a turn: no active players are available.');
  }
}
