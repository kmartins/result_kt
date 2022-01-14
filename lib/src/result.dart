import 'package:result_kt/src/failure.dart';

/// [runCatching] function
typedef Block<R> = R Function();

/// {@template result}
/// A discriminated union that encapsulates a successful outcome
/// with a value of type [T] or a failure with an
/// arbitrary `error` and `stack trace`.
///
/// For encapsulating a `value`:
///
/// ```dart
/// final result = Result.success('success o/');
/// ```
///
/// For encapsulating an `error` and a `stackTrace`:
///
/// ```dart
///  Result<int>.failure('failure :/', stackTrace);
/// ```
/// {@endtemplate}
class Result<T> {
  /// {@macro result}
  const Result._(this._value);

  /// Returns an instance that encapsulated
  /// the given [value] as successful value.
  factory Result.success(T value) => Result._(value);

  /// Returns an instance that encapsulated the
  /// [Error] and [StackTrace] as [Failure].
  factory Result.failure(
    Object error, [
    StackTrace? stackTrace,
  ]) =>
      Result._(
        Failure(error: error, stackTrace: stackTrace),
      );

  /// Represents the value if success [Result.success]
  /// or [Failure] if failure [Result.failure].
  final Object? _value;

  /// Returns `true` if this instance represents a successful outcome.
  /// In this case [isFailure] returns `false`.
  bool get isSuccess => !isFailure;

  /// Returns `true` if this instance represents a failed outcome.
  /// In this case [isSuccess] returns `false`.
  bool get isFailure => _value is Failure;

  /// Returns the encapsulated value if this instance represents
  /// [success][Result.isSuccess] or `null`
  /// if it is [failure][Result.isFailure].
  T? getOrNull() => isFailure ? null : _value as T;

  /// Returns the encapsulated [Failure] exception if
  /// this instance represents [failure][Result.isFailure] or `null`
  /// if it is [success][Result.isSuccess].
  Failure? failureOrNull() => isFailure ? _value! as Failure : null;

  /// Returns the encapsulated value if this instance represents
  /// [success][Result.isSuccess] or throws the encapsulated in [Failure]
  /// exception if it is [failure][Result.isFailure].
  T? getOrThrow() =>
      // ignore: only_throw_errors
      isFailure ? throw (_value! as Failure).error : _value as T;

  /// Returns the encapsulated value if this instance
  /// represents [success][Result.isSuccess] or the
  /// [defaultValue] if it is [failure][Result.isFailure].
  T getOrDefault(T defaultValue) {
    if (isFailure) return defaultValue;
    return _value as T;
  }

  /// Returns the encapsulated value if this
  /// instance represents [success][Result.isSuccess] or the
  /// result of [onFailure] function for the encapsulated [Failure]
  /// exception if it is [failure][Result.isFailure].
  ///
  /// Note, that this function rethrows any `error`
  /// thrown by [onFailure] function.
  T getOrElse({
    required T Function(Failure failure) onFailure,
  }) {
    if (isFailure) return onFailure(_value! as Failure);
    return _value as T;
  }

  /// Performs the given [action] on the encapsulated value
  /// if this instance represents [success][Result.isSuccess].
  /// Returns the original [Result] unchanged.
  Result<T> onSuccess({required void Function(T value) action}) =>
      this.._actionIfSuccess(action: action);

  /// Performs the given [action] on the encapsulated
  /// `error` and `stackTrace` in [Failure] if this
  /// instance represents [failure][Result.isFailure]
  /// Returns the original [Result] unchanged.
  Result<T> onFailure({required void Function(Failure failure) action}) =>
      this.._actionIfFailure(action: action);

  void _actionIfFailure({required void Function(Failure failure) action}) =>
      isFailure ? action(_value! as Failure) : null;

  void _actionIfSuccess({required void Function(T value) action}) =>
      isSuccess ? action(_value as T) : null;

  /// Returns the result of [onSuccess] for the encapsulated
  /// value if this instance represents [success][Result.isSuccess]
  /// or the result of [onFailure] function for the encapsulated
  /// `error` and `stackTrace` in [Failure]
  /// if it is [failure][Result.isFailure].
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    final failure = failureOrNull();
    if (failure == null) {
      return onSuccess(_value as T);
    }
    return onFailure(failure);
  }

  /// Returns the encapsulated result of the given [transform] functions
  /// applied to the encapsulated value if this instance
  /// represents [success][Result.isSuccess] or the original encapsulated
  /// `error` and `stackTrace` in [Failure]
  /// if it is [failure][Result.isFailure].
  ///
  /// Note, that this function rethrows
  /// any `error` thrown by [transform] function.
  /// See [mapCatching] for an alternative that encapsulates erros.
  Result<R> map<R>({
    required R Function(T value) transform,
  }) {
    if (isSuccess) {
      return Result.success(transform(_value as T));
    }
    return Result._(_value);
  }

  /// Returns the encapsulated result of the given [transform]
  /// function applied to the encapsulated value
  /// if this instance represents [success][Result.isSuccess] or the
  /// original encapsulated error` and `stackTrace` in [Failure]
  /// if it is [failure][Result.isFailure].
  ///
  /// This function catches any `error` thrown
  /// by [transform] function, then [test] is called with
  /// the error value, if [test] is `true`,
  /// the `error` and the [StackTrace] are encapsulating it as a failure,
  /// otherwise, the `error` is thrown
  ///
  /// If `test` is omitted, it defaults to a
  /// function that always returns `true`.
  ///
  /// The [transform] function is called inside [runCatching].
  ///
  /// See [map] for an alternative that
  /// rethrows exceptions from `transform` function.
  Result<R> mapCatching<R>({
    required R Function(T value) transform,
    bool Function(Object error)? test,
  }) {
    if (isSuccess) {
      return runCatching(() => transform(_value as T), test: test);
    }
    return Result._(_value);
  }

  /// Returns the encapsulated result of the given [transform] function applied
  /// to the encapsulated `error` and `stackTrace` in [Failure]
  /// if this instance represents [failure][Result.isFailure] or the
  ///original encapsulated value if it is [success][Result.isSuccess].
  ///
  /// Note, that this function rethrows
  /// any `error` thrown by [transform] function.
  /// See [recoverCatching] for an alternative that encapsulates erros.
  Result<T> recover({
    required T Function(Failure failure) transform,
  }) {
    final failure = failureOrNull();
    if (failure == null) {
      return this;
    }
    return Result.success(transform(failure));
  }

  /// Returns the encapsulated result of the given [transform] function applied
  /// to the encapsulated `error` and `stackTrace` in [Failure]
  /// if this instance represents [failure][Result.isFailure] or the
  /// original encapsulated value if it is [success][Result.isSuccess].
  ///
  /// This function catches any `error` thrown
  /// by [transform] function, then [test] is called with
  /// the error value, if [test] is `true`,
  /// the `error` and the [StackTrace] are encapsulating it as a failure,
  /// otherwise, the `error` is thrown
  ///
  /// If `test` is omitted, it defaults to a
  /// function that always returns `true`.
  ///
  /// The [transform] function is called inside [runCatching].
  ///
  /// See [recover] for an alternative that rethrows error.
  Result<T> recoverCatching({
    required T Function(Failure failure) transform,
    bool Function(Object error)? test,
  }) {
    final failure = failureOrNull();
    if (failure == null) {
      return this;
    }
    return runCatching(() => transform(failure), test: test);
  }

  @override
  String toString() => isFailure ? _value.toString() : 'Success($_value)';

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Result<T> && other._value == _value;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _value.hashCode;
}

/// Calls the specified function [block] and returns
/// your value encapsulated in the [Result] if invocation is successful,
/// catches any `error` that is thrown from the [block] function execution,
/// then [test] is called with the error value, if [test] is `true`,
/// the `error` and the [StackTrace] are encapsulating it as a failure
/// in [Result], otherwise, if [test] is false, then the `error` is rethrow.
///
/// If `test` is omitted, it defaults to a function that always returns `true`.
///
/// It's very similar with [Future.catchError].
///
/// Note, that this function rethrows
/// any `error` thrown by [test] function.
Result<R> runCatching<R>(
  Block<R> block, {
  bool Function(Object error)? test,
}) {
  try {
    return Result.success(block());
  } catch (error, stackTrace) {
    if (test?.call(error) ?? true) {
      return Result.failure(error, stackTrace);
    }
    rethrow;
  }
}
