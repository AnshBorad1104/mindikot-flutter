import 'package:test/test.dart';
import '../../lib/game/game.dart';

void main() {
  final factory = DeckFactory();
  final deckEngine = DeckEngine();

  group('DeckFactory', () {
    test('creates a complete standard deck', () {
      final deck = factory.createStandard();

      expect(deck.cards, hasLength(DeckFactory.standardDeckSize));
      expect(factory.isValidStandardDeck(deck), isTrue);
      expect(deck.cards.toSet(), hasLength(DeckFactory.standardDeckSize));
    });

    test('creates and validates multiple complete decks', () {
      final deck = factory.createStandard(deckCount: 2);

      expect(deck.totalCards, 104);
      expect(factory.isValidStandardDeck(deck, deckCount: 2), isTrue);
      expect(deck.cards.where((card) => card.suit == Suit.hearts && card.rank == Rank.ace), hasLength(2));
      expect(deck.cards.map((card) => card.id).toSet(), hasLength(104));
    });

    test('rejects an invalid deck count', () {
      expect(() => factory.createStandard(deckCount: 0), throwsArgumentError);
    });

    test('detects an incomplete standard deck', () {
      final deck = Deck(cards: factory.createStandard().cards.skip(1));
      expect(factory.isValidStandardDeck(deck), isFalse);
    });
  });

  group('shuffle strategies', () {
    test('deterministic shuffle gives the same result for the same input', () {
      final deck = factory.createStandard();
      final strategy = DeterministicShuffleStrategy(42);

      expect(strategy.shuffle(deck.cards), strategy.shuffle(deck.cards));
    });

    test('shuffle preserves cards and used cards', () {
      final card = Card(suit: Suit.clubs, rank: Rank.two);
      final validDeck = Deck(cards: factory.createStandard().cards.skip(1), usedCards: [card]);
      final shuffled = deckEngine.shuffle(validDeck, DeterministicShuffleStrategy(7));

      expect(shuffled.cards.toSet(), validDeck.cards.toSet());
      expect(shuffled.usedCards, [card]);
    });

    test('random strategy preserves all cards', () {
      final deck = factory.createStandard();
      expect(RandomShuffleStrategy().shuffle(deck.cards).toSet(), deck.cards.toSet());
    });
  });

  group('DeckEngine', () {
    test('removes cards into the used pile and restores selected cards', () {
      final deck = factory.createStandard();
      final cards = [deck.cards.first, deck.cards[1]];
      final removed = deckEngine.removeCards(deck, cards);
      final restored = deckEngine.restoreCards(removed, [cards.first]);

      expect(removed.cards, isNot(contains(cards.first)));
      expect(removed.usedCards, cards);
      expect(restored.cards.last, cards.first);
      expect(restored.usedCards, [cards.last]);
    });

    test('restores every used card when no selection is provided', () {
      final source = factory.createStandard();
      final deck = deckEngine.removeCards(source, source.cards.take(2));
      final restored = deckEngine.restoreCards(deck);

      expect(restored.usedCards, isEmpty);
      expect(restored.totalCards, DeckFactory.standardDeckSize);
    });

    test('rejects unavailable card removals', () {
      final deck = Deck();
      expect(
        () => deckEngine.removeCards(deck, [Card(suit: Suit.spades, rank: Rank.ace)]),
        throwsStateError,
      );
    });
  });

  group('DealManager', () {
    final manager = DealManager();

    test('deals cards round-robin evenly to every player', () {
      final result = manager.dealEvenly(
        factory.createStandard(),
        ['p1', 'p2', 'p3', 'p4'],
      );

      expect(result.hands.values.every((hand) => hand.length == 13), isTrue);
      expect(result.hands['p1']!.first.suit, Suit.clubs);
      expect(result.hands['p1']!.first.rank, Rank.two);
      expect(result.hands['p2']!.first.rank, Rank.three);
      expect(result.remainingDeck.cards, isEmpty);
    });

    test('retains undealt cards when a hand size is requested', () {
      final result = manager.dealEvenly(factory.createStandard(), ['p1', 'p2'], cardsPerPlayer: 5);
      expect(result.hands['p1'], hasLength(5));
      expect(result.hands['p2'], hasLength(5));
      expect(result.remainingDeck.cards, hasLength(42));
    });

    test('rejects non-even and duplicate-player deals', () {
      expect(
        () => manager.dealEvenly(factory.createStandard(), ['p1', 'p2', 'p3']),
        throwsStateError,
      );
      expect(
        () => manager.dealEvenly(factory.createStandard(), ['p1', 'p1']),
        throwsArgumentError,
      );
    });
  });
}
