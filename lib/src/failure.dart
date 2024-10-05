/// {@template failure}
/// Class that encapsulates `error`[Object] and [StackTrace].
/// The `stackTrace` is optional.
///
/// ```dart
/// Failure(error: Exception(), stackTrace: stackTrace);
/// ```
/// {@endtemplate}
final class Failure {
  /// {@macro failure}
  Failure({
    required this.error,
    this.stackTrace,
  });

  /// The error captured.
  final Object error;

  /// The stacktrace associated with [error].
  final StackTrace? stackTrace;

  @override
  String toString() => 'Failure(error: $error, stackTrace: $stackTrace)';

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure &&
        other.error == error &&
        other.stackTrace == stackTrace;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => error.hashCode ^ stackTrace.hashCode;
}
