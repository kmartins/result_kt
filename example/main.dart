// ignore_for_file: avoid_print
import 'dart:io';

import 'package:result_kt/result_kt.dart';

void main() {
  stdout.writeln('Type an email:');
  final email = stdin.readLineSync()!;
  final result = runCatching(() => validadeEmailAddress(email));
  result
      .onSuccess(action: print)
      .onFailure(action: (value) => print(value.error.toString()));
}

String validadeEmailAddress(String email) {
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(email)) {
    return '$email is a valid email address';
  } else {
    throw FormatException('$email is not a valid email address');
  }
}
