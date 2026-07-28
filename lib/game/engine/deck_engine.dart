import '../models/card.dart';
import '../models/deck.dart';
import 'shuffle_strategy.dart';

/// Performs immutable transformations on a deck.
class DeckEngine {
  /// Returns [deck] with available cards reordered by [strategy].
  Deck shuffle(Deck deck, ShuffleStrategy strategy) =>
      Deck(cards: strategy.shuffle(deck.cards), usedCards: deck.usedCards);

  /// Moves [cards] from the available pile to the used pile.
  ///
  /// Throws [StateError] when any requested card is unavailable, including when
  /// a duplicate card is requested more times than it occurs in the deck.
  Deck removeCards(Deck deck, Iterable<Card> cards) {
    final remaining = deck.cards.toList();
    final removed = <Card>[];
    for (final card in cards) {
      if (!remaining.remove(card)) {
        throw StateError('Cannot remove a card that is not available: $card');
      }
      removed.add(card);
    }
    return Deck(cards: remaining, usedCards: [...deck.usedCards, ...removed]);
  }

  /// Moves [cards] from the used pile back to the available pile.
  ///
  /// When [cards] is omitted, restores all used cards in their used-pile order.
  /// Throws [StateError] if a requested card is not present in the used pile.
  Deck restoreCards(Deck deck, [Iterable<Card>? cards]) {
    final restore = cards?.toList() ?? deck.usedCards.toList();
    final used = deck.usedCards.toList();
    for (final card in restore) {
      if (!used.remove(card)) {
        throw StateError('Cannot restore a card that is not used: $card');
      }
    }
    return Deck(cards: [...deck.cards, ...restore], usedCards: used);
  }
}
