// Option is a type from the dartz package. It is used to represent a value that may or may not be present.
// Option implements the Maybe monad, which is a type that can represent a value that may or may not be present.
abstract class Option<T> {
  const Option();

  factory Option.some(T value) = Some<T>;
  factory Option.none() = None<T>;

  R fold<R>(R Function(T value) some, R Function() none);
  T getOrThrow();
  T getOrElse(T defaultValue);
  bool isSome();
  bool isNone();
}

class Some<T> extends Option<T> {
  final T value;

  const Some(this.value);

  @override
  R fold<R>(R Function(T value) some, R Function() none) {
    return some(value);
  }

  @override
  T getOrThrow() {
    return value;
  }

  @override
  T getOrElse(T defaultValue) {
    return value;
  }

  @override
  bool isSome() {
    return true;
  }

  @override
  bool isNone() {
    return false;
  }
}

class None<T> extends Option<T> {
  const None();

  @override
  R fold<R>(R Function(T value) some, R Function() none) {
    return none();
  }

  @override
  T getOrThrow() {
    throw Exception("Value is not present");
  }

  @override
  T getOrElse(T defaultValue) {
    return defaultValue;
  }

  @override
  bool isSome() {
    return false;
  }

  @override
  bool isNone() {
    return true;
  }
}
