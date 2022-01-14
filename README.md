# Result Kt

[![pub][package]][package_link]
[![License: MIT][license_badge]][license_link]
[![result_kt][workflow_badge]][workflow_link]
[![codecov][codecov_badge]][codecov_link]

A Dart package with the type `Result` and the `runCatching` function that are similar to those found in [Kotlin][kotlin_result]. 

## Why?

I needed something as is done in `Kotlin` and did not want to add other functions that not are used in my projects.

## Usage

Add it in your `pubspec.yaml`:

```yaml
dependencies:
  result_kt:
```

Import it where you want to use it e.g, in your main file.

```dart
import 'package:result_kt/result_kt.dart';
```

## Overview

### Result

You can encapsulate a successful outcome
with a value or a failure with an  `error` and stack trace
It is similar to an `Either` that you see in other packages as [dartz][dartz], [fpdart][fpdart]...

```dart
Result.success(0)
    .onSuccess(
        action: print,
    )
    .onFailure(
    action: (failure) => print(
            failure.error.toString(),
        ),
    );

Result<int>.failure(Exception(), StackTrace.current)
    .onSuccess(
        action: print,
    )
    .onFailure(
        action: (failure) => print(
            failure.error.toString(),
        ),
    );
```

**Methods available:**

- `isSuccess`
- `isFailure`
- `getOrNull`
- `failureOrNull`
- `getOrThrow`
- `getOrDefault`
- `getOrElse`
- `onSuccess`
- `onFailure`
- `fold`
- `map`
- `mapCatching`
- `recover`
- `recoverCatching`

See the [API documentation][api_documentation].

### runCatching

Execute a passed function and catches any `error` that is thrown from this execution, if the invocation is successful, then returns your `value` encapsulated in the `Result`, otherwise,  returns your `error` and `stack trace` encapsulated in the `Result`.

```dart
final result = runCatching(() => 1);
result
    .onSuccess(
        action: print,
    )
    .onFailure(
        action: (failure) => print(
            failure.error.toString(),
        ),
    );
```

**Note: You can be passed what `error` type you want catching, if the same, then return the `Result`, otherwise, the error is rethrown.**

```dart
final result = runCatching<int>(
    () => throw 'exception',
    test: (error) => error is Exception,
),
// `onFailure` is never called
result
    .onFailure(
        action: (failure) => print(
            failure.error.toString(),
        ),
    );
```

## Other similar packages

The [dartz][dartz] package offers many functional programming helpers, including the Either type, which is similar to Result, with the difference being that it represents any two types of values.

The [fpdart][fpdart] similar to the package [dartz][dartz], however with a better documentation. Do you desire to use all the power of functional programming? If yes, then use it.

The [either_option][either_option] package has Either and Option and supports all of the typical functional operations.

The [result][result] package offers a few basic operations and may be adequate for simple cases
(This package has been two years without any updates). 

The [rust_like_result][rust_like_result] offers a simple Result type similar to the one in Rust.

The [simple_result][simple_result] package provides a Result type based on the type of the same name in Swift.

The [oxidized][oxidized] with types similar to those found in Rust, such as the Result which represents either a value or an error, and Option which either contains Some value or None.

## 📝 Maintainers

[Kauê Martins](https://github.com/kmartins)

## 🤝 Support

You liked this package? Then give it a ⭐️. If you want to help then:

- Fork this repository
- Send a Pull Request with new features
- Share this package
- Create issues if you find a bug or want to suggest a new extension

**Pull Request title follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). </br>**

## 📝 License

Copyright © 2022 [Kauê Martins](https://github.com/kmartins).<br />
This project is [MIT](https://opensource.org/licenses/MIT) licensed.

[package_badge]: https://img.shields.io/pub/v/result_kt_crashlytics.svg
[package_link]: https://pub.dev/packages/result_kt_crashlytics
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[codecov_badge]: https://codecov.io/gh/kmartins/result_kt/branch/main/graph/badge.svg
[codecov_link]: https://codecov.io/gh/kmartins/result_kt
[workflow_badge]: https://github.com/kmartins/result_kt/actions/workflows/build.yaml/badge.svg
[workflow_link]: https://github.com/kmartins/result_kt/actions/workflows/build.yaml
[package]: https://pub.dev/packages/result_kt
[kotlin_result]: https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-result/
[api_documentation]: https://pub.dev/documentation/result_kt/latest/
[dartz]: https://pub.dev/packages/dartz
[fpdart]: https://pub.dev/packages/fpdart
[either_option]: https://pub.dev/packages/either_option
[result]: https://pub.dev/packages/result
[rust_like_result]: https://pub.dev/packages/rust_like_result
[simple_result]: https://pub.dev/packages/simple_result
[oxidized]: https://pub.dev/packages/oxidized