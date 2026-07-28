/// Reasons a basic card-play request can be rejected.
enum RuleViolation {
  /// The player is absent from the room or is not active.
  invalidPlayer,

  /// The requested player is not the current player.
  notPlayersTurn,

  /// The game does not have an active turn.
  turnNotActive,

  /// The player has no cards available to play.
  emptyHand,

  /// The requested card is not in the player's hand.
  cardNotOwned,

  /// The requested card has already been recorded as played.
  cardAlreadyPlayed,
}
