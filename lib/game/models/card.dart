import 'enums.dart';

/// An immutable physical playing card.
///
/// [id] identifies a physical card, so two cards with the same [suit] and
/// [rank] from separate decks remain distinct values. Supplying an [id] is
/// useful when restoring serialized state; otherwise a process-unique id is
/// assigned.
class Card {
  /// Creates a physical card with [suit], [rank], and an optional stable [id].
  Card({required this.suit, required this.rank, String? id})
      : id = id ?? _newPhysicalCardId() {
    if (this.id.isEmpty) {
      throw ArgumentError.value(id, 'id', 'must not be empty');
    }
  }

  static int _nextCardNumber = 0;

  /// Stable identifier of this physical card.
  final String id;

  /// The card's suit.
  final Suit suit;

  /// The card's rank.
  final Rank rank;

  @override
  bool operator ==(Object other) =>
      other is Card && other.id == id && other.suit == suit && other.rank == rank;

  @override
  int get hashCode => Object.hash(id, suit, rank);

  @override
  String toString() => '${rank.name} of ${suit.name} ($id)';

  static String _newPhysicalCardId() => 'card-${_nextCardNumber++}';
}
