import 'enums.dart';

/// An immutable participant in a game room.
class Player {
  /// Creates a player with a stable, non-empty [id].
  Player({required this.id, required this.name, this.teamId, this.state = PlayerState.active})
      : assert(id != ''),
        assert(name != '');

  /// Stable identity used by the engine to determine turn order.
  final String id;

  /// Display name supplied by the owning application.
  final String name;

  /// Optional team identity. Team assignment is game-mode dependent.
  final String? teamId;

  /// Current room participation status.
  final PlayerState state;

  /// Returns a copy with selected fields replaced.
  Player copyWith({String? name, String? teamId, PlayerState? state}) => Player(
        id: id,
        name: name ?? this.name,
        teamId: teamId ?? this.teamId,
        state: state ?? this.state,
      );

  @override
  bool operator ==(Object other) =>
      other is Player &&
      other.id == id &&
      other.name == name &&
      other.teamId == teamId &&
      other.state == state;

  @override
  int get hashCode => Object.hash(id, name, teamId, state);
}
