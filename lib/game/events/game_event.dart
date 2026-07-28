/// Immutable event types emitted by the pure MindiKot game engine.
library;

import '../models/card.dart';

/// Base class for all events emitted by a match.
///
/// Events are ordered first by [sequence], then by [occurredAt]. The owning
/// application assigns sequence values; the engine does not generate them.
abstract class GameEvent implements Comparable<GameEvent> {
  /// Creates an event for a non-empty [matchId] at a non-negative [sequence].
  GameEvent({
    required this.matchId,
    required this.sequence,
    required this.occurredAt,
  }) {
    if (matchId.isEmpty) {
      throw ArgumentError.value(matchId, 'matchId', 'must not be empty');
    }
    if (sequence < 0) {
      throw ArgumentError.value(sequence, 'sequence', 'must not be negative');
    }
  }

  /// Identifier of the match that emitted this event.
  final String matchId;

  /// Monotonic event position within [matchId].
  final int sequence;

  /// Time at which the event was emitted.
  final DateTime occurredAt;

  @override
  int compareTo(GameEvent other) {
    final sequenceComparison = sequence.compareTo(other.sequence);
    return sequenceComparison != 0
        ? sequenceComparison
        : occurredAt.compareTo(other.occurredAt);
  }

  /// Compares common metadata for value equality.
  bool sameMetadata(GameEvent other) =>
      runtimeType == other.runtimeType &&
      matchId == other.matchId &&
      sequence == other.sequence &&
      occurredAt == other.occurredAt;

  /// Hash code for common event metadata.
  int get metadataHashCode => Object.hash(runtimeType, matchId, sequence, occurredAt);
}

/// Event emitted when a match begins.
class MatchStartedEvent extends GameEvent {
  /// Creates a match-started event.
  MatchStartedEvent({required super.matchId, required super.sequence, required super.occurredAt});

  @override
  bool operator ==(Object other) => other is MatchStartedEvent && sameMetadata(other);

  @override
  int get hashCode => metadataHashCode;
}

/// Event emitted when a match ends.
class MatchEndedEvent extends GameEvent {
  /// Creates a match-ended event.
  MatchEndedEvent({required super.matchId, required super.sequence, required super.occurredAt});

  @override
  bool operator ==(Object other) => other is MatchEndedEvent && sameMetadata(other);

  @override
  int get hashCode => metadataHashCode;
}

/// Event emitted when a positive-numbered round begins.
class RoundStartedEvent extends GameEvent {
  /// Creates a round-started event for [roundNumber].
  RoundStartedEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required this.roundNumber,
  }) {
    _validateRoundNumber(roundNumber);
  }

  /// One-based round number within the match.
  final int roundNumber;

  @override
  bool operator ==(Object other) =>
      other is RoundStartedEvent && sameMetadata(other) && roundNumber == other.roundNumber;

  @override
  int get hashCode => Object.hash(metadataHashCode, roundNumber);
}

/// Event emitted when a positive-numbered round ends.
class RoundEndedEvent extends GameEvent {
  /// Creates a round-ended event for [roundNumber].
  RoundEndedEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required this.roundNumber,
  }) {
    _validateRoundNumber(roundNumber);
  }

  /// One-based round number within the match.
  final int roundNumber;

  @override
  bool operator ==(Object other) =>
      other is RoundEndedEvent && sameMetadata(other) && roundNumber == other.roundNumber;

  @override
  int get hashCode => Object.hash(metadataHashCode, roundNumber);
}

/// Event emitted when a player's turn starts.
class TurnStartedEvent extends GameEvent {
  /// Creates a turn-started event for [playerId].
  TurnStartedEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required this.playerId,
  }) {
    _validatePlayerId(playerId);
  }

  /// Identity of the player whose turn started.
  final String playerId;

  @override
  bool operator ==(Object other) =>
      other is TurnStartedEvent && sameMetadata(other) && playerId == other.playerId;

  @override
  int get hashCode => Object.hash(metadataHashCode, playerId);
}

/// Event emitted when a player's turn ends.
class TurnEndedEvent extends GameEvent {
  /// Creates a turn-ended event for [playerId].
  TurnEndedEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required this.playerId,
  }) {
    _validatePlayerId(playerId);
  }

  /// Identity of the player whose turn ended.
  final String playerId;

  @override
  bool operator ==(Object other) =>
      other is TurnEndedEvent && sameMetadata(other) && playerId == other.playerId;

  @override
  int get hashCode => Object.hash(metadataHashCode, playerId);
}

/// Event emitted when [playerId] plays [card].
class CardPlayedEvent extends GameEvent {
  /// Creates a card-played event.
  CardPlayedEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required this.playerId,
    required this.card,
  }) {
    _validatePlayerId(playerId);
  }

  /// Identity of the player that played the card.
  final String playerId;

  /// Card played by [playerId].
  final Card card;

  @override
  bool operator ==(Object other) =>
      other is CardPlayedEvent &&
      sameMetadata(other) &&
      playerId == other.playerId &&
      card == other.card;

  @override
  int get hashCode => Object.hash(metadataHashCode, playerId, card);
}

/// Base class for events concerning a player joining, leaving, or connecting.
abstract class PlayerEvent extends GameEvent {
  /// Creates a player event for a non-empty [playerId].
  PlayerEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required this.playerId,
  }) {
    _validatePlayerId(playerId);
  }

  /// Identity of the player associated with this event.
  final String playerId;

  /// Compares player-event metadata and player identity.
  bool samePlayerEvent(PlayerEvent other) => sameMetadata(other) && playerId == other.playerId;

  /// Hash code for player-event metadata and player identity.
  int get playerEventHashCode => Object.hash(metadataHashCode, playerId);
}

/// Event emitted when a player joins a match.
class PlayerJoinedEvent extends PlayerEvent {
  /// Creates a player-joined event.
  PlayerJoinedEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required super.playerId,
  });

  @override
  bool operator ==(Object other) => other is PlayerJoinedEvent && samePlayerEvent(other);

  @override
  int get hashCode => playerEventHashCode;
}

/// Event emitted when a player leaves a match.
class PlayerLeftEvent extends PlayerEvent {
  /// Creates a player-left event.
  PlayerLeftEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required super.playerId,
  });

  @override
  bool operator ==(Object other) => other is PlayerLeftEvent && samePlayerEvent(other);

  @override
  int get hashCode => playerEventHashCode;
}

/// Event emitted when a player disconnects from a match.
class PlayerDisconnectedEvent extends PlayerEvent {
  /// Creates a player-disconnected event.
  PlayerDisconnectedEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required super.playerId,
  });

  @override
  bool operator ==(Object other) => other is PlayerDisconnectedEvent && samePlayerEvent(other);

  @override
  int get hashCode => playerEventHashCode;
}

/// Event emitted when a player reconnects to a match.
class PlayerReconnectedEvent extends PlayerEvent {
  /// Creates a player-reconnected event.
  PlayerReconnectedEvent({
    required super.matchId,
    required super.sequence,
    required super.occurredAt,
    required super.playerId,
  });

  @override
  bool operator ==(Object other) => other is PlayerReconnectedEvent && samePlayerEvent(other);

  @override
  int get hashCode => playerEventHashCode;
}

void _validatePlayerId(String playerId) {
  if (playerId.isEmpty) {
    throw ArgumentError.value(playerId, 'playerId', 'must not be empty');
  }
}

void _validateRoundNumber(int roundNumber) {
  if (roundNumber < 1) {
    throw ArgumentError.value(roundNumber, 'roundNumber', 'must be positive');
  }
}
