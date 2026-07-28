import 'package:test/test.dart';
import '../../lib/game/game.dart';

void main() {
  group('Card', () {
    test('uses physical id, suit, and rank for value equality', () {
      final first = Card(id: 'first', suit: Suit.hearts, rank: Rank.ace);
      final equal = Card(id: 'first', suit: Suit.hearts, rank: Rank.ace);
      final second = Card(id: 'second', suit: Suit.hearts, rank: Rank.ace);
      expect(first, equals(equal));
      expect(first.hashCode, equal.hashCode);
      expect(first, isNot(equals(second)));
    });
  });

  group('Deck', () {
    test('supports equal-valued cards with distinct physical ids', () {
      final first = Card(id: 'deck-1', suit: Suit.spades, rank: Rank.two);
      final second = Card(id: 'deck-2', suit: Suit.spades, rank: Rank.two);
      expect(Deck(cards: [first, second]).totalCards, 2);
      expect(() => Deck(cards: [first], usedCards: [first]), throwsArgumentError);
    });
  });

  group('Room', () {
    test('rejects duplicate player identities', () {
      expect(
        () => Room(
          id: 'room',
          players: [Player(id: 'p1', name: 'One'), Player(id: 'p1', name: 'Other')],
        ),
        throwsArgumentError,
      );
    });
  });

  group('Trick', () {
    test('rejects a winner who did not play', () {
      expect(
        () => Trick(leaderId: 'p1', winnerId: 'p2'),
        throwsArgumentError,
      );
    });
  });

  group('GameState', () {
    test('defensively copies supplied hands', () {
      final suppliedHand = [Card(suit: Suit.clubs, rank: Rank.ace)];
      final state = GameState(room: Room(id: 'room'), deck: Deck(), hands: {'p1': suppliedHand});
      suppliedHand.clear();

      expect(state.handFor('p1'), hasLength(1));
      expect(() => state.handFor('p1').clear(), throwsUnsupportedError);
    });
  });

  group('Round', () {
    test('returns the last unresolved trick as active', () {
      final round = Round(
        number: 1,
        startingPlayerId: 'p1',
        tricks: [Trick(leaderId: 'p1', winnerId: null), Trick(leaderId: 'p2')],
      );
      expect(round.activeTrick?.leaderId, 'p2');
    });
  });
}
