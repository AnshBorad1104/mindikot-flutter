import '../models/card.dart';
import '../models/deck.dart';
import '../models/enums.dart';

/// Builds and validates standard playing-card decks.
class DeckFactory {
  /// Number of cards in one standard deck without jokers.
  static final int standardDeckSize = Suit.values.length * Rank.values.length;

  /// Creates [deckCount] concatenated standard 52-card decks without jokers.
  ///
  /// Duplicate card values intentionally represent the same card from distinct
  /// physical decks when [deckCount] is greater than one.
  Deck createStandard({int deckCount = 1}) {
    if (deckCount < 1) {
      throw ArgumentError.value(deckCount, 'deckCount', 'must be at least one');
    }
    return Deck(cards: _standardCards(deckCount));
  }

  /// Returns whether [deck] contains exactly [deckCount] complete standard decks.
  ///
  /// Used cards are included because validation applies to the complete deck.
  bool isValidStandardDeck(Deck deck, {int deckCount = 1}) {
    if (deckCount < 1 || deck.totalCards != standardDeckSize * deckCount) {
      return false;
    }
    final counts = <Card, int>{};
    for (final card in [...deck.cards, ...deck.usedCards]) {
      counts.update(card, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts.length == standardDeckSize &&
        counts.values.every((count) => count == deckCount);
  }

  List<Card> _standardCards(int deckCount) => List.unmodifiable([
        for (var deckIndex = 0; deckIndex < deckCount; deckIndex++)
          for (final suit in Suit.values)
            for (final rank in Rank.values) Card(suit: suit, rank: rank),
      ]);
}
