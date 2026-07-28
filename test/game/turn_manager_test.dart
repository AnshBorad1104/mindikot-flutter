import 'package:test/test.dart';
import '../../lib/game/game.dart';

void main() {
  final manager = TurnManager();
  final order = PlayerOrder(['p1', 'p2', 'p3', 'p4']);
  final activePlayers = [
    Player(id: 'p1', name: 'One'),
    Player(id: 'p2', name: 'Two'),
    Player(id: 'p3', name: 'Three'),
    Player(id: 'p4', name: 'Four'),
  ];

  group('PlayerOrder', () {
    test('wraps seat lookup and rejects invalid ids', () {
      expect(order.playerAt(5), 'p2');
      expect(() => order.indexOf('unknown'), throwsArgumentError);
      expect(() => PlayerOrder(['p1', 'p1']), throwsArgumentError);
    });
  });

  group('TurnManager current, next, and previous player', () {
    test('returns player positions in circular seating order', () {
      expect(manager.currentPlayer(order, 'p2'), const CurrentPlayer(playerId: 'p2', seatIndex: 1));
      expect(
        manager.nextPlayer(order: order, players: activePlayers, playerId: 'p4'),
        const NextPlayer(playerId: 'p1', seatIndex: 0),
      );
      expect(
        manager.previousPlayer(order: order, players: activePlayers, playerId: 'p1'),
        const PreviousPlayer(playerId: 'p4', seatIndex: 3),
      );
    });
  });

  group('TurnManager inactive-player handling', () {
    final playersWithInactiveSeats = [
      Player(id: 'p1', name: 'One'),
      Player(id: 'p2', name: 'Two', state: PlayerState.disconnected),
      Player(id: 'p3', name: 'Three', state: PlayerState.left),
      Player(id: 'p4', name: 'Four'),
    ];

    test('skips inactive players and reports them', () {
      final result = manager.skipInactivePlayers(
        order: order,
        players: playersWithInactiveSeats,
        fromPlayerId: 'p1',
      );

      expect(result.playerIds, ['p2', 'p3']);
      expect(result.selectedPlayer, const CurrentPlayer(playerId: 'p4', seatIndex: 3));
    });

    test('throws when every player is inactive', () {
      final inactive = activePlayers
          .map((player) => player.copyWith(state: PlayerState.disconnected))
          .toList();
      expect(
        () => manager.nextPlayer(order: order, players: inactive, playerId: 'p1'),
        throwsStateError,
      );
    });
  });

  group('round lifecycle', () {
    test('starts at an active starting player and ends at a validated final player', () {
      final start = manager.startRound(
        order: order,
        players: activePlayers,
        startingPlayerId: 'p3',
      );
      final end = manager.endRound(order, 'p2');

      expect(start.currentPlayer, const CurrentPlayer(playerId: 'p3', seatIndex: 2));
      expect(end.lastPlayer, const CurrentPlayer(playerId: 'p2', seatIndex: 1));
    });

    test('starts at the next active player when the starter is inactive', () {
      final players = [
        Player(id: 'p1', name: 'One', state: PlayerState.left),
        ...activePlayers.skip(1),
      ];
      final start = manager.startRound(order: order, players: players, startingPlayerId: 'p1');
      expect(start.currentPlayer, const CurrentPlayer(playerId: 'p2', seatIndex: 1));
    });
  });
}
