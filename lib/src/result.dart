import 'dart:async';

import 'package:meta/meta.dart';
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
sealed class Result<T> {
  /// {@macro result}
  const Result._();

  /// Returns an instance that encapsulated
  /// the given [value] as successful value.
  factory Result.success(T value) = Success<T>;

  /// Returns an instance that encapsulated the
  /// [Error] and [StackTrace] as [Failure].
  factory Result.failure(
    Object error, [
    StackTrace? stackTrace,
  ]) =>
      FailureResult(
        Failure(error: error, stackTrace: stackTrace),
      );

  /// Returns `true` if this instance represents a successful outcome.
  /// In this case [isFailure] returns `false`.
  bool get isSuccess => switch (this) {
        Success() => true,
        FailureResult() => false,
      };

  /// Returns `true` if this instance represents a failed outcome.
  /// In this case [isSuccess] returns `false`.
  bool get isFailure => !isSuccess;

  /// Returns the encapsulated value if this instance represents
  /// [success][Result.isSuccess] or `null`
  /// if it is [failure][Result.isFailure].
  T? getOrNull() => switch (this) {
        Success(value: final value) => value,
        FailureResult() => null,
      };

  /// Returns the encapsulated [Failure] exception if
  /// this instance represents [failure][Result.isFailure] or `null`
  /// if it is [success][Result.isSuccess].
  Failure? failureOrNull() => switch (this) {
        Success() => null,
        FailureResult(failure: final failure) => failure,
      };

  /// Returns the encapsulated value if this instance represents
  /// [success][Result.isSuccess] or throws the encapsulated in [Failure]
  /// exception if it is [failure][Result.isFailure].
  T? getOrThrow() => switch (this) {
        Success(value: final value) => value,
        // Result can hold any Object as error.
        // ignore: only_throw_errors
        FailureResult(failure: final failure) => throw failure.error,
      };

  /// Returns the encapsulated value if this instance
  /// represents [success][Result.isSuccess] or the
  /// [defaultValue] if it is [failure][Result.isFailure].
  T getOrDefault(T defaultValue) => switch (this) {
        Success(value: final value) => value,
        FailureResult() => defaultValue,
      };

  /// Returns the encapsulated value if this
  /// instance represents [success][Result.isSuccess] or the
  /// result of [onFailure] function for the encapsulated [Failure]
  /// exception if it is [failure][Result.isFailure].
  ///
  /// Note, that this function rethrows any `error`
  /// thrown by [onFailure] function.
  T getOrElse({
    required T Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        Success(value: final value) => value,
        FailureResult(failure: final failure) => onFailure(failure),
      };

  /// Performs the given [action] on the encapsulated value
  /// if this instance represents [success][Result.isSuccess].
  void onSuccess({required void Function(T value) action}) {
    if (this case Success(value: final value)) {
      action(value);
    }
  }

  /// Performs the given [action] on the encapsulated
  /// `error` and `stackTrace` in [Failure] if this
  /// instance represents [failure][Result.isFailure]
  void onFailure({required void Function(Failure failure) action}) {
    if (this case FailureResult(failure: final failure)) {
      action(failure);
    }
  }

  /// Returns the result of [onSuccess] for the encapsulated
  /// value if this instance represents [success][Result.isSuccess]
  /// or the result of [onFailure] function for the encapsulated
  /// `error` and `stackTrace` in [Failure]
  /// if it is [failure][Result.isFailure].
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        Success(value: final value) => onSuccess(value),
        FailureResult(failure: final failure) => onFailure(failure),
      };

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
  }) =>
      switch (this) {
        Success(value: final value) => Result.success(transform(value)),
        FailureResult(failure: final failure) => FailureResult<R>(failure),
      };

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
  }) =>
      switch (this) {
        Success(value: final value) =>
          runCatching(() => transform(value), test: test),
        FailureResult(failure: final failure) => FailureResult<R>(failure),
      };

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
  }) =>
      switch (this) {
        Success() => this,
        FailureResult(failure: final failure) =>
          Result.success(transform(failure)),
      };

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
  }) =>
      switch (this) {
        Success() => this,
        FailureResult(failure: final failure) =>
          runCatching(() => transform(failure), test: test),
      };
}

/// A successful [Result] with a value of type [T].
@immutable
final class Success<T> extends Result<T> {
  /// Creates a success result with the given [value].
  const Success(this.value) : super._();

  /// The successful value.
  final T value;

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Success<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// A failed [Result] with a [Failure].
@immutable
final class FailureResult<T> extends Result<T> {
  /// Creates a failure result with the given [failure].
  const FailureResult(this.failure) : super._();

  /// The failure details.
  final Failure failure;

  @override
  String toString() => failure.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FailureResult<T> && other.failure == failure;
  }

  @override
  int get hashCode => failure.hashCode;
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

/// Functions for using [Stream] with the [Result].
extension StreamExtension<T> on Stream<T> {
  /// Encapsulates a `value` emitted in a [Result],
  /// if successful then the `value` is encapsulated as a `success`
  /// in [Result] using the [EventSink.add],
  /// if `error` then [test] is called with the `error value`,
  /// if [test] is `true`, the `error` and the [StackTrace] are encapsulated
  /// as a `failure` in [Result] using [EventSink.add], otherwise,
  /// if [test] is `false`, then the `error` and [StackTrace]
  /// are added using [EventSink.addError].
  ///
  /// Uses the `test` function to catch the specific errors,
  /// it's the same that the [runCatching] function.
  /// If `test` is omitted, it defaults to a function
  /// that always returns `true`.
  Stream<Result<T>> toResult({
    bool Function(Object error)? test,
  }) {
    return transform<Result<T>>(
      StreamTransformer<T, Result<T>>.fromHandlers(
        handleData: (data, sink) => sink.add(Result<T>.success(data)),
        handleError: (error, stackTrace, sink) {
          if (test?.call(error) ?? true) {
            final stack = stackTrace.toString().isEmpty ? null : stackTrace;
            sink.add(Result<T>.failure(error, stack));
          } else {
            sink.addError(error, stackTrace);
          }
        },
      ),
    );
  }
}
