import 'enums.dart';

/// An immutable standard playing card.
class Card {
  /// Creates a card with [suit] and [rank].
  const Card({required this.suit, required this.rank});

  /// The card's suit.
  final Suit suit;

  /// The card's rank.
  final Rank rank;

  @override
  bool operator ==(Object other) =>
      other is Card && other.suit == suit && other.rank == rank;

  @override
  int get hashCode => Object.hash(suit, rank);

  @override
  String toString() => '${rank.name} of ${suit.name}';
}
