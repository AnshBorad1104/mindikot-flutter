import '../models/card.dart';
import '../models/deck.dart';
import '../models/enums.dart';

/// Builds and validates standard playing-card decks.
class DeckFactory {
  /// Number of cards in one standard deck without jokers.
  static final int standardDeckSize = Suit.values.length * Rank.values.length;

  /// Creates [deckCount] concatenated standard 52-card decks without jokers.
  ///
  /// Duplicate card values represent distinct physical cards from separate decks
  /// when [deckCount] is greater than one.
  Deck createStandard({int deckCount = 1, String? deckId}) {
    if (deckCount < 1) {
      throw ArgumentError.value(deckCount, 'deckCount', 'must be at least one');
    }
    final physicalDeckId = deckId ?? _newDeckId();
    if (physicalDeckId.isEmpty) {
      throw ArgumentError.value(deckId, 'deckId', 'must not be empty');
    }
    return Deck(cards: _standardCards(deckCount, physicalDeckId));
  }

  /// Returns whether [deck] contains exactly [deckCount] complete standard decks.
  ///
  /// Used cards are included because validation applies to the complete deck.
  bool isValidStandardDeck(Deck deck, {int deckCount = 1}) {
    if (deckCount < 1 || deck.totalCards != standardDeckSize * deckCount) {
      return false;
    }
    final cards = [...deck.cards, ...deck.usedCards];
    if (cards.map((card) => card.id).toSet().length != cards.length) return false;
    final counts = <String, int>{};
    for (final card in cards) {
      final valueKey = '${card.suit.name}-${card.rank.name}';
      counts.update(valueKey, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts.length == standardDeckSize &&
        counts.values.every((count) => count == deckCount);
  }

  static int _nextDeckNumber = 0;

  static String _newDeckId() => 'deck-${_nextDeckNumber++}';

  List<Card> _standardCards(int deckCount, String deckId) => List.unmodifiable([
        for (var deckIndex = 0; deckIndex < deckCount; deckIndex++)
          for (final suit in Suit.values)
            for (final rank in Rank.values) Card(id: '$deckId-$deckIndex-${suit.name}-${rank.name}', suit: suit, rank: rank),
      ]);
}
