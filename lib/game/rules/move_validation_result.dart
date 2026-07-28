import 'rule_result.dart';
import 'rule_violation.dart';

/// Immutable validation result for a requested card play.
class MoveValidationResult extends RuleResult {
  /// Creates a card-play validation result.
  MoveValidationResult({Iterable<RuleViolation> violations = const []})
      : super(violations: violations);

  /// Creates a successful move-validation result.
  factory MoveValidationResult.valid() => MoveValidationResult();
}
