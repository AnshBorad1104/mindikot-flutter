import 'package:test/test.dart';

import '../../lib/game/game.dart';

void main() {
  final timestamp = DateTime.utc(2026, 7, 28);

  MatchStartedEvent matchStarted({int sequence = 0}) => MatchStartedEvent(
        matchId: 'match-1',
        sequence: sequence,
        occurredAt: timestamp,
      );

  group('game events', () {
    test('create immutable event values', () {
      final card = Card(suit: Suit.hearts, rank: Rank.ace);
      final event = CardPlayedEvent(
        matchId: 'match-1',
        sequence: 2,
        occurredAt: timestamp,
        playerId: 'player-1',
        card: card,
      );

      expect(event.matchId, 'match-1');
      expect(event.sequence, 2);
      expect(event.playerId, 'player-1');
      expect(event.card, card);
    });

    test('use value equality for matching events', () {
      expect(matchStarted(), equals(matchStarted()));
      expect(matchStarted(), isNot(equals(matchStarted(sequence: 1))));
      expect(
        PlayerJoinedEvent(
          matchId: 'match-1', sequence: 0, occurredAt: timestamp, playerId: 'player-1',
        ),
        isNot(equals(matchStarted())),
      );
    });

    test('order events by sequence and then occurrence time', () {
      final events = [
        matchStarted(sequence: 2),
        MatchEndedEvent(
          matchId: 'match-1', sequence: 1, occurredAt: timestamp.add(const Duration(seconds: 1)),
        ),
        matchStarted(sequence: 1),
      ]..sort();

      expect(events.map((event) => event.sequence), [1, 1, 2]);
      expect(events.first, matchStarted());
    });

    test('reject invalid common and domain constructor parameters', () {
      expect(
        () => MatchStartedEvent(matchId: '', sequence: 0, occurredAt: timestamp),
        throwsArgumentError,
      );
      expect(
        () => MatchStartedEvent(matchId: 'match', sequence: -1, occurredAt: timestamp),
        throwsArgumentError,
      );
      expect(
        () => RoundStartedEvent(matchId: 'match', sequence: 0, occurredAt: timestamp, roundNumber: 0),
        throwsArgumentError,
      );
      expect(
        () => TurnStartedEvent(matchId: 'match', sequence: 0, occurredAt: timestamp, playerId: ''),
        throwsArgumentError,
      );
    });

    test('constructs every concrete event type', () {
      final events = <GameEvent>[
        matchStarted(),
        MatchEndedEvent(matchId: 'match-1', sequence: 1, occurredAt: timestamp),
        RoundStartedEvent(matchId: 'match-1', sequence: 2, occurredAt: timestamp, roundNumber: 1),
        RoundEndedEvent(matchId: 'match-1', sequence: 3, occurredAt: timestamp, roundNumber: 1),
        TurnStartedEvent(matchId: 'match-1', sequence: 4, occurredAt: timestamp, playerId: 'player-1'),
        TurnEndedEvent(matchId: 'match-1', sequence: 5, occurredAt: timestamp, playerId: 'player-1'),
        CardPlayedEvent(
          matchId: 'match-1', sequence: 6, occurredAt: timestamp, playerId: 'player-1',
          card: Card(suit: Suit.clubs, rank: Rank.two),
        ),
        PlayerJoinedEvent(matchId: 'match-1', sequence: 7, occurredAt: timestamp, playerId: 'player-1'),
        PlayerLeftEvent(matchId: 'match-1', sequence: 8, occurredAt: timestamp, playerId: 'player-1'),
        PlayerDisconnectedEvent(matchId: 'match-1', sequence: 9, occurredAt: timestamp, playerId: 'player-1'),
        PlayerReconnectedEvent(matchId: 'match-1', sequence: 10, occurredAt: timestamp, playerId: 'player-1'),
      ];

      expect(events, hasLength(11));
    });
  });
}
