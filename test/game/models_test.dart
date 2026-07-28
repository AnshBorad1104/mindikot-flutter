import 'package:test/test.dart';
import '../../lib/game/game.dart';

void main() {
  group('Card', () {
    test('uses suit and rank for value equality', () {
      expect(
        const Card(suit: Suit.hearts, rank: Rank.ace),
        equals(const Card(suit: Suit.hearts, rank: Rank.ace)),
      );
    });
  });

  group('Deck', () {
    test('supports duplicate card values for multi-deck games', () {
      const card = Card(suit: Suit.spades, rank: Rank.two);
      expect(Deck(cards: [card], usedCards: [card]).totalCards, 2);
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
      final suppliedHand = [const Card(suit: Suit.clubs, rank: Rank.ace)];
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
