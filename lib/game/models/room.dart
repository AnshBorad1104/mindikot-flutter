import 'enums.dart';
import 'player.dart';
import 'team.dart';

/// Immutable lobby configuration and membership for one game room.
class Room {
  /// Creates a room with uniquely identified [players] and [teams].
  Room({
    required this.id,
    Iterable<Player> players = const [],
    Iterable<Team> teams = const [],
    this.state = RoomState.waiting,
  })  : assert(id != ''),
        players = List.unmodifiable(players),
        teams = List.unmodifiable(teams) {
    if (this.players.map((player) => player.id).toSet().length != this.players.length) {
      throw ArgumentError('Room players must have unique ids.');
    }
    if (this.teams.map((team) => team.id).toSet().length != this.teams.length) {
      throw ArgumentError('Room teams must have unique ids.');
    }
  }

  /// Stable room identity owned by the host application.
  final String id;

  /// Participants in seating order.
  final List<Player> players;

  /// Teams playing in this room.
  final List<Team> teams;

  /// Current room lifecycle status.
  final RoomState state;
}
