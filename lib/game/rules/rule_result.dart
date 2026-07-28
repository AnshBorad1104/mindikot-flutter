import 'rule_violation.dart';

/// Immutable result of validating one or more game rules.
class RuleResult {
  /// Creates a result with unique [violations].
  RuleResult({Iterable<RuleViolation> violations = const []})
      : violations = List.unmodifiable(violations) {
    if (this.violations.toSet().length != this.violations.length) {
      throw ArgumentError.value(violations, 'violations', 'must not contain duplicates');
    }
  }

  /// Rule violations found during validation, in validation order.
  final List<RuleViolation> violations;

  /// Whether no rule violations were found.
  bool get isValid => violations.isEmpty;

  @override
  bool operator ==(Object other) =>
      other is RuleResult &&
      runtimeType == other.runtimeType &&
      _sameViolations(violations, other.violations);

  @override
  int get hashCode => Object.hash(runtimeType, Object.hashAll(violations));
}

bool _sameViolations(List<RuleViolation> left, List<RuleViolation> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}
