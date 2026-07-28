import 'card.dart';

/// An immutable deck state, including cards still available and cards used.
class Deck {
  /// Creates a deck with unique physical cards.
  Deck({Iterable<Card> cards = const [], Iterable<Card> usedCards = const []})
      : cards = List.unmodifiable(cards),
        usedCards = List.unmodifiable(usedCards) {
    final allCards = [...this.cards, ...this.usedCards];
    if (allCards.map((card) => card.id).toSet().length != allCards.length) {
      throw ArgumentError('A deck cannot contain the same physical card twice.');
    }
  }

  /// Cards available to draw, in draw order.
  final List<Card> cards;

  /// Cards removed from play, in removal order.
  final List<Card> usedCards;

  /// Total cards represented by this deck.
  int get totalCards => cards.length + usedCards.length;

  @override
  bool operator ==(Object other) =>
      other is Deck && _sameCards(cards, other.cards) && _sameCards(usedCards, other.usedCards);

  @override
  int get hashCode => Object.hash(Object.hashAll(cards), Object.hashAll(usedCards));
}

bool _sameCards(List<Card> left, List<Card> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}
