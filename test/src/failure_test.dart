import 'package:result_kt/src/failure.dart';
import 'package:test/test.dart';

void main() {
  group('Failure', () {
    test(
        'given a Failure, '
        'when compared with other identical Failure, '
        'then the result is true', () {
      final stackTrace = StackTrace.fromString('stack');
      final failure1 = Failure(error: 'error');
      final failure2 = Failure(error: 'error');
      final failure3 = Failure(error: 'error', stackTrace: stackTrace);
      final failure4 = Failure(error: 'error', stackTrace: stackTrace);

      expect(failure1, failure2);
      expect(failure3, failure4);
    });

    test(
        'given a Failure, '
        'when compared with other different Failure, '
        'then the result is false', () {
      final failure1 = Failure(error: 'error1');
      final failure2 = Failure(error: 'error2');
      final failure3 = Failure(
        error: 'error',
        stackTrace: StackTrace.fromString('stack1'),
      );
      final failure4 = Failure(
        error: 'error',
        stackTrace: StackTrace.fromString('stack2'),
      );

      expect(failure1, isNot(failure2));
      expect(failure3, isNot(failure4));
    });

    test(
        'given a hash code of the Failure, '
        'when compared with other identical Failure, '
        'then the result is the same', () {
      final stackTrace = StackTrace.fromString('stack');
      final failure1 = Failure(error: 'error');
      final failure2 = Failure(error: 'error');
      final failure3 = Failure(error: 'error', stackTrace: stackTrace);
      final failure4 = Failure(error: 'error', stackTrace: stackTrace);

      expect(failure1.hashCode, failure2.hashCode);
      expect(failure3.hashCode, failure4.hashCode);
    });

    test(
        'given a hash code of the Failure, '
        'when compared with other different Failure, '
        'then the result is different', () {
      final failure1 = Failure(error: 'error1');
      final failure2 = Failure(error: 'error2');
      final failure3 = Failure(
        error: 'error',
        stackTrace: StackTrace.fromString('stack1'),
      );
      final failure4 = Failure(
        error: 'error',
        stackTrace: StackTrace.fromString('stack2'),
      );

      expect(failure1.hashCode, isNot(failure2.hashCode));
      expect(failure3.hashCode, isNot(failure4.hashCode));
    });

    test(
        'given a Failure with error, '
        'when called toString, '
        'then the result is Failure(error: error, stackTrace: null)', () {
      final failure = Failure(error: 'error');
      expect(failure.toString(), 'Failure(error: error, stackTrace: null)');
    });

    test(
        'given a Failure with error and stack trace, '
        'when called toString, '
        'then the result is Failure(error: error, stackTrace: stackTrace)', () {
      final failure = Failure(
        error: 'error',
        stackTrace: StackTrace.fromString('stack'),
      );
      expect(failure.toString(), 'Failure(error: error, stackTrace: stack)');
    });
  });
}
