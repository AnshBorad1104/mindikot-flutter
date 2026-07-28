/// The four suits in a standard playing-card deck.
enum Suit { clubs, diamonds, hearts, spades }

/// The ranks in a standard 52-card deck, ordered from low to high.
enum Rank {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace,
}

/// A player's participation status in a room.
enum PlayerState { active, disconnected, left }

/// The lifecycle status of a room.
enum RoomState { waiting, ready, inProgress, completed, closed }

/// The lifecycle status of a turn.
enum TurnState { notStarted, active, completed, timedOut }

/// The outcome of a completed match.
enum MatchResult { undecided, teamOneWon, teamTwoWon, draw }
