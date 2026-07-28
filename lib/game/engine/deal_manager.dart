import '../models/card.dart';
import '../models/deck.dart';

/// Result of an immutable card dealing operation.
class DealResult {
  /// Creates a deal result. Hands are copied and immutable.
  DealResult({required Map<String, Iterable<Card>> hands, required this.remainingDeck})
      : hands = Map.unmodifiable({
          for (final entry in hands.entries) entry.key: List<Card>.unmodifiable(entry.value),
        });

  /// Cards assigned to each player, in round-robin dealing order.
  final Map<String, List<Card>> hands;

  /// Deck cards that were not dealt. Its used pile is unchanged.
  final Deck remainingDeck;
}

/// Deals cards from a deck without mutating the supplied deck.
class DealManager {
  /// Deals equal numbers of cards to uniquely identified [playerIds].
  ///
  /// With no [cardsPerPlayer], every available card must be distributable
  /// evenly. Otherwise exactly [cardsPerPlayer] cards are dealt to each player
  /// and any remaining available cards are retained in the result's deck.
  DealResult dealEvenly(
    Deck deck,
    Iterable<String> playerIds, {
    int? cardsPerPlayer,
  }) {
    final players = List<String>.unmodifiable(playerIds);
    if (players.isEmpty) {
      throw ArgumentError.value(playerIds, 'playerIds', 'must not be empty');
    }
    if (players.any((id) => id.isEmpty) || players.toSet().length != players.length) {
      throw ArgumentError.value(playerIds, 'playerIds', 'must be unique non-empty ids');
    }
    if (cardsPerPlayer != null && cardsPerPlayer < 0) {
      throw ArgumentError.value(cardsPerPlayer, 'cardsPerPlayer', 'must not be negative');
    }

    final perPlayer = cardsPerPlayer ?? deck.cards.length ~/ players.length;
    final totalToDeal = perPlayer * players.length;
    if (cardsPerPlayer == null && totalToDeal != deck.cards.length) {
      throw StateError('Available cards cannot be dealt evenly to all players.');
    }
    if (totalToDeal > deck.cards.length) {
      throw StateError('Not enough cards to deal $perPlayer cards to each player.');
    }

    final hands = {for (final player in players) player: <Card>[]};
    for (var index = 0; index < totalToDeal; index++) {
      hands[players[index % players.length]]!.add(deck.cards[index]);
    }
    return DealResult(
      hands: hands,
      remainingDeck: Deck(cards: deck.cards.skip(totalToDeal), usedCards: deck.usedCards),
    );
  }
}
