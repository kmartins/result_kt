import 'package:result_kt/src/result.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    group('encapsulate', () {
      test(
          'given a value, '
          'when passed this value as success, '
          'then the result is the encapsulated value', () {
        final result = Result.success(0);
        expect(
          result,
          isA<Result<int>>()
              .having((result) => result.getOrNull(), 'value', 0)
              .having((result) => result.failureOrNull(), 'failure', isNull),
        );
      });

      test(
          'given an error and a stack trace, '
          'when passed as failure, '
          'then the result is the encapsulated stack trace and error', () {
        final stackTrace = StackTrace.fromString('stack');
        final result = Result<int>.failure('error', stackTrace);
        expect(
          result,
          isA<Result<int>>()
              .having((result) => result.getOrNull(), 'value', isNull)
              .having(
                (result) => result.failureOrNull()?.error,
                'error',
                'error',
              )
              .having(
                (result) => result.failureOrNull()?.stackTrace.toString(),
                'stackTrace',
                'stack',
              ),
        );
      });
    });
    group('toString', () {
      test(
          'given that the result is Success, '
          'when called toString, '
          'then the result is Success(value)', () {
        final result = Result.success('success o/');
        expect(result.toString(), 'Success(success o/)');
      });

      test(
          'given that the result is Failure, '
          'when called toString, '
          'then the result is '
          'Failure(error: error, stackTrace: stackTrace)', () {
        final stackTrace = StackTrace.fromString('stack');
        final result = Result<int>.failure('error', stackTrace);
        expect(
          result.toString(),
          'Failure(error: error, stackTrace: stack)',
        );
      });
    });

    group('equals and hashCode', () {
      test(
          'given a Result, '
          'when compared with other identical Result, '
          'then the result is true', () {
        final success1 = Result.success(0);
        final success2 = Result.success(0);
        final failure1 = Result<int>.failure(0);
        final failure2 = Result<int>.failure(0);

        expect(success1, success2);
        expect(failure1, failure2);
      });

      test(
          'given a Result, '
          'when compared with other different Result, '
          'then the result is false', () {
        final success1 = Result.success(0);
        final success2 = Result.success(1);
        final success3 = Result.success('0');
        final failure1 = Result<int>.failure(0);
        final failure2 = Result<int>.failure(1);
        final failure3 = Result<int>.failure('0');

        expect(success1, isNot(success2));
        expect(success1, isNot(success3));
        expect(success3, isNot(failure1));
        expect(failure1, isNot(failure2));
        expect(failure1, isNot(failure3));
      });

      test(
          'given a hash code of the Result, '
          'when compared with other identical Result, '
          'then the result is the same', () {
        final success1 = Result.success(0);
        final success2 = Result.success(0);
        final failure1 = Result<int>.failure(0);
        final failure2 = Result<int>.failure(0);

        expect(success1.hashCode, success2.hashCode);
        expect(failure1.hashCode, failure2.hashCode);
      });

      test(
          'given a hash code of the Result, '
          'when compared with other different Result, '
          'then the result is different', () {
        final success1 = Result.success(0);
        final success2 = Result.success(1);
        final success3 = Result.success('0');
        final failure1 = Result<int>.failure(0);
        final failure2 = Result<int>.failure(1);
        final failure3 = Result<int>.failure('0');

        expect(success1, isNot(success2.hashCode));
        expect(success1, isNot(success3.hashCode));
        expect(success3, isNot(failure1.hashCode));
        expect(failure1, isNot(failure2.hashCode));
        expect(failure1, isNot(failure3.hashCode));
      });
    });

    group('success or failure', () {
      test(
          'given that the result is Success, '
          'when to get if it is a success, '
          'then the result is true', () {
        final result = Result.success('success o/');
        expect(result.isSuccess, isTrue);
      });

      test(
          'given that the result is Success, '
          'when to get if it is a failure, '
          'then the result is false', () {
        final result = Result.success('success o/');
        expect(result.isFailure, isFalse);
      });

      test(
          'given that the result is Failure, '
          'when to get if it is a success, '
          'then the result is false', () {
        final result = Result<int>.failure('failure :/');
        expect(result.isSuccess, isFalse);
      });

      test(
          'given that the result is Failure, '
          'when to get if it is a failure, '
          'then the result is true', () {
        final result = Result<int>.failure('failure :/');
        expect(result.isFailure, isTrue);
      });
    });

    group('get', () {
      test(
          'given that the result is Success, '
          'when to get the value, '
          'then the result is the value', () {
        const value = 'success o/';
        final result = Result.success(value);
        expect(result.getOrThrow(), value);
      });

      test(
          'given that the result is Success, '
          'when to get the value or null, '
          'then the result is the value', () {
        const value = 'success o/';
        final result = Result.success(value);
        expect(result.getOrNull(), value);
      });

      test(
          'given that the result is Failure, '
          'when to get the value or null, '
          'then the result is null', () {
        const exception = 'failure :/';
        final result = Result<int>.failure(exception);
        expect(result.getOrNull(), isNull);
      });

      test(
          'given that the result is Failure, '
          'when to get the value or throw an error, '
          'then the result is an exception', () {
        const exception = 'failure :/';
        final result = Result<int>.failure(exception);
        expect(
          result.getOrThrow,
          throwsA(
            isA<String>().having((value) => value, 'exception', exception),
          ),
        );
      });

      test(
          'given that the result is Success, '
          'when to get the value or default, '
          'then the result is the value', () {
        const value = 'success o/';
        final result = Result.success(value);
        expect(result.getOrDefault('default'), value);
      });

      test(
          'given that the result is Failure, '
          'when to get the value or default, '
          'then the result is the default', () {
        const exception = 'failure :/';
        final result = Result<int>.failure(exception);
        expect(result.getOrDefault(0), 0);
      });

      test(
          'given that the result is Success, '
          'when to get the value or else, '
          'then the result is the value', () {
        const value = 'success o/';
        final result = Result.success(value);
        expect(result.getOrElse(onFailure: (_) => 'default'), value);
      });

      test(
          'given that the result is Failure, '
          'when to get the value or else, '
          'then the result is the value '
          'of the onFailure function', () {
        const exception = 'failure :/';
        final result = Result<int>.failure(exception);
        expect(result.getOrElse(onFailure: (_) => 0), 0);
      });
    });

    group('on', () {
      test(
          'given that the result is Success, '
          'when to perform a function in on success, '
          'then the result is only to call function '
          'without to change the original Result', () {
        final result = Result.success('success o/');
        String? value;
        final sameResult = result.onSuccess(
          action: (result) => value = result,
        );
        expect(sameResult, result);
        expect(value, 'success o/');
      });

      test(
          'given that the result is Failure, '
          'when to perform a function in on success, '
          'then the result is that function is not called '
          'and the Result is the same', () {
        const exception = 'failure :/';
        final result = Result<int>.failure(exception);
        var value = 0;
        final sameResult = result.onSuccess(
          action: (result) => value = result,
        );
        expect(sameResult, result);
        expect(value, 0);
      });

      test(
          'given that the result is Failure, '
          'when to perform a function in on failure, '
          'then the result is only to call function '
          'without to change the original Result', () {
        final stackTrace = StackTrace.fromString('stack');
        const exception = 'failure :/';
        final result = Result<int>.failure(exception, stackTrace);
        String? value;
        String? stack;
        final sameResult = result.onFailure(
          action: (failure) {
            value = failure.error as String;
            stack = failure.stackTrace.toString();
          },
        );
        expect(sameResult, result);
        expect(value, 'failure :/');
        expect(stack, 'stack');
      });

      test(
          'given that the result is Success, '
          'when to perform a function in on failure, '
          'then the result is only to call function '
          'without to change the original Result', () {
        final result = Result.success('success o/');
        String? value;
        final sameResult = result.onFailure(
          action: (failure) => value = failure.error as String,
        );
        expect(sameResult, result);
        expect(value, isNull);
      });
    });

    group('map', () {
      test(
          'given that the result is Success, '
          'when mapping the result value, '
          'then the result is a new Result with the transformation value', () {
        final result = Result.success('success o/');
        final newResult = result.map(
          transform: (value) => value.length,
        );
        expect(newResult, Result.success('success o/'.length));
      });

      test(
          'given that the result is Failure, '
          'when mapping the result value, '
          'then the result is the same Result with Failure', () {
        const exception = 'failure :/';
        final result = Result<String>.failure(exception);
        final newResult = result.map(
          transform: (value) => value.length,
        );
        expect(newResult, Result<int>.failure(exception));
      });

      test(
          'given that the result is Success, '
          'when mapping the result value and an exception to occur '
          'then the result is to throw this exception', () {
        final result = Result.success('success o/');
        expect(
          () => result.map(
            transform: (_) => throw Exception(),
          ),
          throwsException,
        );
      });
    });

    group('mapCatching', () {
      test(
          'given that the result is Success, '
          'when mapping the result value, '
          'then the result is a new Result with the transformation value', () {
        final result = Result.success('success o/');
        final newResult = result.mapCatching(
          transform: (value) => value.length,
        );
        expect(newResult, Result.success(10));
      });

      test(
          'given that the result is Failure, '
          'when mapping the result value, '
          'then the result is the same Result with Failure', () {
        const exception = 'failure :/';
        final result = Result<String>.failure(exception);
        final newResult = result.mapCatching(
          transform: (value) => value.length,
        );

        expect(newResult, Result<int>.failure(exception));
      });

      test(
          'given that the result is Success, '
          'when mapping the result value, capturing any exception '
          'and an exception to occur '
          'then the result is a Result with the error and the '
          'stack trace encapsulated in Failure', () {
        final result = Result.success('success o/');
        final newResult = result.mapCatching<int>(
          transform: (_) => throw Exception(),
          test: (error) => error is Exception,
        );
        expect(
          newResult,
          isA<Result<int>>()
              .having(
                (result) => result.failureOrNull()?.error,
                'error',
                isException,
              )
              .having(
                (result) => result.failureOrNull()?.stackTrace,
                'stackTrace',
                isNotNull,
              ),
        );
      });

      test(
          'given that the result is Success, '
          'when mapping the result value, capturing a specific exception '
          'and a different exception occur '
          'then the result is to throw this exception', () {
        final result = Result.success('success o/');
        expect(
          () => result.mapCatching<int>(
            transform: (_) => throw Exception(),
            test: (error) => error is String,
          ),
          throwsException,
        );
      });
    });

    group('fold', () {
      test(
          'given that the result is Success, '
          'when folding the result, '
          'then the result is the value of onSuccess function', () {
        final result = Result.success('success o/');
        final value = result.fold(
          onSuccess: (_) => 10,
          onFailure: (_) => 0,
        );
        expect(value, 10);
      });

      test(
          'given that the result is Success, '
          'when folding the result, '
          'then the result is the value of onFailure function', () {
        const exception = 'failure :/';
        final result = Result<String>.failure(exception);
        final value = result.fold(
          onSuccess: (_) => 10,
          onFailure: (_) => 0,
        );
        expect(value, 0);
      });
    });

    group('recover', () {
      test(
          'given that the result is Success, '
          'when transforming the failure in success, '
          'then the result is the same Result with the value', () {
        final result = Result.success('success o/');
        final newResult = result.recover(
          transform: (_) => 'new success',
        );
        expect(newResult, result);
      });

      test(
          'given that the result is Failure, '
          'when transforming the failure in success, '
          'then the result is a success with the '
          'value of the transforming ', () {
        const exception = 'failure :/';
        final result = Result<String>.failure(exception);
        final newResult = result.recover(
          transform: (_) => 'new success',
        );
        expect(newResult, Result.success('new success'));
      });

      test(
          'given that the result is Failure, '
          'when transforming the failure in success and an exception to occur '
          'then the result is to throw this exception', () {
        const exception = 'failure :/';
        final result = Result<String>.failure(exception);
        expect(
          () => result.recover(
            transform: (_) => throw Exception(),
          ),
          throwsException,
        );
      });
    });

    group('recoverCatching', () {
      test(
          'given that the result is Success, '
          'when transforming the failure in success, '
          'then the result is the same Result with the value', () {
        final result = Result.success('success o/');
        final newResult = result.recoverCatching(
          transform: (_) => 'new success',
        );
        expect(newResult, result);
      });

      test(
          'given that the result is Failure, '
          'when transforming the failure in success, '
          'then the result is a success with the '
          'value of the transforming ', () {
        const exception = 'failure :/';
        final result = Result<String>.failure(exception);
        final newResult = result.recoverCatching(
          transform: (_) => 'new success',
        );
        expect(newResult, Result.success('new success'));
      });

      test(
          'given that the result is Failure, '
          'when transforming the failure in success, '
          'capturing any exception and an exception to occur '
          'then the result is a Result with the error and the '
          'stack trace encapsulated in Failure', () {
        const exception = 'failure :/';
        final result = Result<String>.failure(exception);
        final newResult = result.recoverCatching(
          transform: (_) => throw Exception(),
          test: (error) => error is Exception,
        );
        expect(
          newResult,
          isA<Result<String>>()
              .having(
                (result) => result.failureOrNull()?.error,
                'error',
                isException,
              )
              .having(
                (result) => result.failureOrNull()?.stackTrace,
                'stackTrace',
                isNotNull,
              ),
        );
      });

      test(
          'given that the result is Failure, '
          'when transforming the failure in success, '
          'capturing a specific exception and a different exception occur '
          'then the result is to throw this exception', () {
        const exception = 'failure :/';
        final result = Result<String>.failure(exception);
        expect(
          () => result.recoverCatching(
            transform: (_) => throw Exception(),
            test: (error) => error is String,
          ),
          throwsException,
        );
      });
    });

    group('runCatching', () {
      test(
          'given the execution of the code block, '
          'when no exception occurs, '
          'then the is result is a success', () async {
        final result = runCatching(() => 1);
        expect(result, Result.success(1));
      });

      test(
          'given the execution of the code block, '
          'when capturing any exception and an '
          'exception occur in this block '
          'then the is result is a failure', () {
        final result = runCatching<int>(() => throw Exception());
        expect(
          result,
          isA<Result<int>>()
              .having(
                (result) => result.failureOrNull()?.error,
                'error',
                isException,
              )
              .having(
                (result) => result.failureOrNull()?.stackTrace,
                'stackTrace',
                isNotNull,
              ),
        );
      });

      test(
          'given the execution of the code block, '
          'when capturing a specific exception and this '
          'exception occur in this block '
          'then the is result is failure', () {
        final result = runCatching<int>(
          () => throw Exception(),
          test: (error) => error is Exception,
        );
        expect(
          result,
          isA<Result<int>>()
              .having(
                (result) => result.failureOrNull()?.error,
                'error',
                isException,
              )
              .having(
                (result) => result.failureOrNull()?.stackTrace,
                'stackTrace',
                isNotNull,
              ),
        );
      });

      test(
          'given the execution of the code block, '
          'when capturing a specific exception and an '
          'exception different occurs in this block '
          'then the result is to throw this exception', () {
        expect(
          () => runCatching<int>(
            // ignore: only_throw_errors
            () => throw 'exception',
            test: (error) => error is Exception,
          ),
          throwsA(
            isA<String>()
                .having((exception) => exception, 'exception', 'exception'),
          ),
        );
      });
    });
  });
}
