import 'package:test/test.dart';

import '../../lib/game/game.dart';

void main() {
  final ownedCard = Card(suit: Suit.hearts, rank: Rank.ace);
  final otherCard = Card(suit: Suit.spades, rank: Rank.king);
  final validator = RuleValidator();

  GameState state({
    String currentPlayerId = 'p1',
    TurnState turnState = TurnState.active,
    Map<String, Iterable<Card>>? hands,
    Round? round,
  }) => GameState(
        room: Room(
          id: 'room',
          players: [Player(id: 'p1', name: 'One'), Player(id: 'p2', name: 'Two')],
        ),
        deck: Deck(),
        currentPlayerId: currentPlayerId,
        turnState: turnState,
        hands: hands ?? {'p1': [ownedCard], 'p2': [otherCard]},
        round: round,
      );

  test('rejects a move by a player whose turn it is not', () {
    final result = validator.validateMove(
      gameState: state(),
      playerId: 'p2',
      card: otherCard,
    );

    expect(result.isValid, isFalse);
    expect(result.violations, [RuleViolation.notPlayersTurn]);
  });

  test('rejects a card not owned by the current player', () {
    final result = validator.validateMove(
      gameState: state(),
      playerId: 'p1',
      card: otherCard,
    );

    expect(result.violations, [RuleViolation.cardNotOwned]);
  });

  test('rejects a card already recorded as played', () {
    final result = validator.validateMove(
      gameState: state(
        round: Round(
          number: 1,
          startingPlayerId: 'p1',
          tricks: [
            Trick(
              leaderId: 'p1',
              plays: [TrickPlay(playerId: 'p1', card: ownedCard)],
            ),
          ],
        ),
      ),
      playerId: 'p1',
      card: ownedCard,
    );

    expect(result.violations, [RuleViolation.cardAlreadyPlayed]);
  });

  test('does not treat another physical copy as already played', () {
    final playedCopy = Card(id: 'deck-1-ace', suit: Suit.hearts, rank: Rank.ace);
    final heldCopy = Card(id: 'deck-2-ace', suit: Suit.hearts, rank: Rank.ace);
    final result = validator.validateMove(
      gameState: state(
        hands: {'p1': [heldCopy], 'p2': [otherCard]},
        round: Round(
          number: 1,
          startingPlayerId: 'p1',
          tricks: [
            Trick(
              leaderId: 'p2',
              plays: [TrickPlay(playerId: 'p2', card: playedCopy)],
            ),
          ],
        ),
      ),
      playerId: 'p1',
      card: heldCopy,
    );

    expect(result.isValid, isTrue);
  });

  test('rejects a player with an empty hand', () {
    final result = validator.validateMove(
      gameState: state(hands: {'p1': [], 'p2': [otherCard]}),
      playerId: 'p1',
      card: ownedCard,
    );

    expect(result.violations, [RuleViolation.emptyHand]);
  });

  test('accepts a basic legal move', () {
    final result = validator.validateMove(
      gameState: state(),
      playerId: 'p1',
      card: ownedCard,
    );

    expect(result, MoveValidationResult.valid());
    expect(result.isValid, isTrue);
  });

  test('rejects an unknown or inactive player', () {
    final unknown = validator.validateMove(
      gameState: state(),
      playerId: 'unknown',
      card: ownedCard,
    );
    final inactiveState = GameState(
      room: Room(
        id: 'room',
        players: [Player(id: 'p1', name: 'One', state: PlayerState.left)],
      ),
      deck: Deck(),
      currentPlayerId: 'p1',
      turnState: TurnState.active,
      hands: {'p1': [ownedCard]},
    );
    final inactive = validator.validateMove(
      gameState: inactiveState,
      playerId: 'p1',
      card: ownedCard,
    );

    expect(unknown.violations, [RuleViolation.invalidPlayer]);
    expect(inactive.violations, [RuleViolation.invalidPlayer]);
  });
}
