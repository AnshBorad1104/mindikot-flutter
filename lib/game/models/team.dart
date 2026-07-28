/// An immutable team and its members.
class Team {
  /// Creates a team with a stable, non-empty [id].
  Team({required this.id, required Iterable<String> playerIds, this.score = 0})
      : assert(id != ''),
        assert(score >= 0),
        playerIds = List.unmodifiable(playerIds) {
    if (this.playerIds.toSet().length != this.playerIds.length) {
      throw ArgumentError.value(playerIds, 'playerIds', 'must not contain duplicates');
    }
  }

  /// Stable identity for this team.
  final String id;

  /// Identities of players assigned to this team.
  final List<String> playerIds;

  /// Score accumulated by this team.
  final int score;

  /// Returns a copy with selected fields replaced.
  Team copyWith({Iterable<String>? playerIds, int? score}) => Team(
        id: id,
        playerIds: playerIds ?? this.playerIds,
        score: score ?? this.score,
      );

  @override
  bool operator ==(Object other) =>
      other is Team &&
      other.id == id &&
      _sameList(other.playerIds, playerIds) &&
      other.score == score;

  @override
  int get hashCode => Object.hash(id, Object.hashAll(playerIds), score);
}

bool _sameList<T>(List<T> left, List<T> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}
