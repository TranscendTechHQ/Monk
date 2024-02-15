// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$queryMatchingThreadsHash() =>
    r'dbb1a0ee4b44ad0894ed99b469ebd7ac5585265d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [queryMatchingThreads].
@ProviderFor(queryMatchingThreads)
const queryMatchingThreadsProvider = QueryMatchingThreadsFamily();

/// See also [queryMatchingThreads].
class QueryMatchingThreadsFamily extends Family<AsyncValue<List<String>>> {
  /// See also [queryMatchingThreads].
  const QueryMatchingThreadsFamily();

  /// See also [queryMatchingThreads].
  QueryMatchingThreadsProvider call(
    String query,
  ) {
    return QueryMatchingThreadsProvider(
      query,
    );
  }

  @override
  QueryMatchingThreadsProvider getProviderOverride(
    covariant QueryMatchingThreadsProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'queryMatchingThreadsProvider';
}

/// See also [queryMatchingThreads].
class QueryMatchingThreadsProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [queryMatchingThreads].
  QueryMatchingThreadsProvider(
    String query,
  ) : this._internal(
          (ref) => queryMatchingThreads(
            ref as QueryMatchingThreadsRef,
            query,
          ),
          from: queryMatchingThreadsProvider,
          name: r'queryMatchingThreadsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$queryMatchingThreadsHash,
          dependencies: QueryMatchingThreadsFamily._dependencies,
          allTransitiveDependencies:
              QueryMatchingThreadsFamily._allTransitiveDependencies,
          query: query,
        );

  QueryMatchingThreadsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(QueryMatchingThreadsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QueryMatchingThreadsProvider._internal(
        (ref) => create(ref as QueryMatchingThreadsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _QueryMatchingThreadsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QueryMatchingThreadsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QueryMatchingThreadsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _QueryMatchingThreadsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with QueryMatchingThreadsRef {
  _QueryMatchingThreadsProviderElement(super.provider);

  @override
  String get query => (origin as QueryMatchingThreadsProvider).query;
}

String _$queryResultsHash() => r'c17499a6329391e1966e4b8f3ac1a8db1bd5fe02';

/// See also [QueryResults].
@ProviderFor(QueryResults)
final queryResultsProvider =
    AutoDisposeNotifierProvider<QueryResults, List<String>>.internal(
  QueryResults.new,
  name: r'queryResultsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$queryResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QueryResults = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
