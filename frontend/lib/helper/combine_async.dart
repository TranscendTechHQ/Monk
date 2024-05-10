import 'package:frontend/core/touple2.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

AsyncValue<Tuple2<T, R>> combineAsync2<T, R>(
  AsyncValue<T> asyncOne,
  AsyncValue<R> asyncTwo,
) {
  if (asyncOne is AsyncError) {
    final error = asyncOne as AsyncError<T>;
    return AsyncError(error.error, error.stackTrace);
  } else if (asyncTwo is AsyncError) {
    final error = asyncTwo as AsyncError<R>;
    return AsyncError(error.error, error.stackTrace);
  } else if (asyncOne is AsyncLoading || asyncTwo is AsyncLoading) {
    return const AsyncLoading();
  } else if (asyncOne is AsyncData && asyncTwo is AsyncData) {
    return AsyncData(
        Tuple2<T, R>(asyncOne.requireValue, asyncTwo.requireValue));
  } else {
    throw 'Unsupported case';
  }
}
