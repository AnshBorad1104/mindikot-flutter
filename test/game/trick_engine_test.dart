import 'package:test/test.dart';

import '../../lib/game/game.dart';

void main() {
  CurrentPlayer player(String id, int seat) => CurrentPlayer(playerId: id, seatIndex: seat);

  group('TrickEngine', () {
    test('starts an empty trick with the turn-manager leader', () {
      final engine = TrickEngine(playerCount: 2);
      final trick = engine.startTrick(player('p1', 0));

      expect(trick.leaderId, 'p1');
      expect(engine.currentTrick, trick);
      expect(engine.playedCards, isEmpty);
      expect(engine.isTrickComplete, isFalse);
    });

    test('preserves physical cards and play order', () {
      final engine = TrickEngine(playerCount: 3)..startTrick(player('p1', 0));
      final first = Card(id: 'first', suit: Suit.clubs, rank: Rank.two);
      final second = Card(id: 'second', suit: Suit.hearts, rank: Rank.ace);

      engine.playCard(player: player('p1', 0), card: first);
      engine.playCard(player: player('p2', 1), card: second);

      expect(engine.playedCards, [first, second]);
      expect(engine.currentTrick!.plays.map((play) => play.playerId), ['p1', 'p2']);
    });

    test('rejects duplicate physical cards in the same trick', () {
      final engine = TrickEngine(playerCount: 3)..startTrick(player('p1', 0));
      final card = Card(id: 'physical-card', suit: Suit.spades, rank: Rank.ace);
      engine.playCard(player: player('p1', 0), card: card);

      expect(
        () => engine.playCard(player: player('p2', 1), card: card),
        throwsStateError,
      );
    });

    test('detects completion and rejects additional plays', () {
      final engine = TrickEngine(playerCount: 2)..startTrick(player('p1', 0));
      engine.playCard(
        player: player('p1', 0),
        card: Card(id: 'first', suit: Suit.clubs, rank: Rank.two),
      );
      engine.playCard(
        player: player('p2', 1),
        card: Card(id: 'second', suit: Suit.clubs, rank: Rank.three),
      );

      expect(engine.isTrickComplete, isTrue);
      expect(
        () => engine.playCard(
          player: player('p3', 2),
          card: Card(id: 'third', suit: Suit.clubs, rank: Rank.four),
        ),
        throwsStateError,
      );
    });

    test('rejects invalid play operations', () {
      final engine = TrickEngine(playerCount: 2);
      final card = Card(id: 'card', suit: Suit.diamonds, rank: Rank.queen);
      expect(() => engine.playCard(player: player('p1', 0), card: card), throwsStateError);
      expect(() => engine.endTrick(), throwsStateError);

      engine.startTrick(player('p1', 0));
      engine.playCard(player: player('p1', 0), card: card);
      expect(
        () => engine.playCard(
          player: player('p1', 0),
          card: Card(id: 'other', suit: Suit.diamonds, rank: Rank.king),
        ),
        throwsStateError,
      );
    });

    test('ends a trick and allows the next trick to start', () {
      final engine = TrickEngine(playerCount: 2);
      engine.startTrick(player('p1', 0));
      final ended = engine.endTrick();

      expect(ended.plays, isEmpty);
      expect(engine.currentTrick, isNull);
      expect(engine.playedCards, isEmpty);
      expect(() => engine.startTrick(player('p2', 1)), returnsNormally);
    });
  });
}
