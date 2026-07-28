import 'dart:math';

import '../models/card.dart';

/// Defines how a deck's available cards are reordered.
abstract interface class ShuffleStrategy {
  /// Returns a shuffled copy of [cards], without changing [cards].
  List<Card> shuffle(Iterable<Card> cards);
}

/// A repeatable Fisher-Yates shuffle using the same [seed] for every call.
class DeterministicShuffleStrategy implements ShuffleStrategy {
  /// Creates a deterministic strategy with [seed].
  const DeterministicShuffleStrategy(this.seed);

  /// Seed used to initialize the pseudo-random generator for each shuffle.
  final int seed;

  @override
  List<Card> shuffle(Iterable<Card> cards) =>
      _fisherYates(cards.toList(), Random(seed));
}

/// A Fisher-Yates shuffle backed by a random source.
class RandomShuffleStrategy implements ShuffleStrategy {
  /// Creates a random strategy using [random], or a new random source if omitted.
  RandomShuffleStrategy({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  List<Card> shuffle(Iterable<Card> cards) => _fisherYates(cards.toList(), _random);
}

List<Card> _fisherYates(List<Card> cards, Random random) {
  for (var index = cards.length - 1; index > 0; index--) {
    final swapIndex = random.nextInt(index + 1);
    final card = cards[index];
    cards[index] = cards[swapIndex];
    cards[swapIndex] = card;
  }
  return List.unmodifiable(cards);
}
