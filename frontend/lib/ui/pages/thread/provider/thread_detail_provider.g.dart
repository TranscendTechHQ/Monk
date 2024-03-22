// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$threadDetailHash() => r'bd8b570dc567dc5e50442255a2295bc5bbca46b5';

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

abstract class _$ThreadDetail
    extends BuildlessAutoDisposeAsyncNotifier<ThreadDetailState> {
  late final String? childThreadId;

  FutureOr<ThreadDetailState> build({
    String? childThreadId,
  });
}

/// See also [ThreadDetail].
@ProviderFor(ThreadDetail)
const threadDetailProvider = ThreadDetailFamily();

/// See also [ThreadDetail].
class ThreadDetailFamily extends Family<AsyncValue<ThreadDetailState>> {
  /// See also [ThreadDetail].
  const ThreadDetailFamily();

  /// See also [ThreadDetail].
  ThreadDetailProvider call({
    String? childThreadId,
  }) {
    return ThreadDetailProvider(
      childThreadId: childThreadId,
    );
  }

  @override
  ThreadDetailProvider getProviderOverride(
    covariant ThreadDetailProvider provider,
  ) {
    return call(
      childThreadId: provider.childThreadId,
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
  String? get name => r'threadDetailProvider';
}

/// See also [ThreadDetail].
class ThreadDetailProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ThreadDetail, ThreadDetailState> {
  /// See also [ThreadDetail].
  ThreadDetailProvider({
    String? childThreadId,
  }) : this._internal(
          () => ThreadDetail()..childThreadId = childThreadId,
          from: threadDetailProvider,
          name: r'threadDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$threadDetailHash,
          dependencies: ThreadDetailFamily._dependencies,
          allTransitiveDependencies:
              ThreadDetailFamily._allTransitiveDependencies,
          childThreadId: childThreadId,
        );

  ThreadDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.childThreadId,
  }) : super.internal();

  final String? childThreadId;

  @override
  FutureOr<ThreadDetailState> runNotifierBuild(
    covariant ThreadDetail notifier,
  ) {
    return notifier.build(
      childThreadId: childThreadId,
    );
  }

  @override
  Override overrideWith(ThreadDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: ThreadDetailProvider._internal(
        () => create()..childThreadId = childThreadId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        childThreadId: childThreadId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ThreadDetail, ThreadDetailState>
      createElement() {
    return _ThreadDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThreadDetailProvider &&
        other.childThreadId == childThreadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, childThreadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ThreadDetailRef
    on AutoDisposeAsyncNotifierProviderRef<ThreadDetailState> {
  /// The parameter `childThreadId` of this provider.
  String? get childThreadId;
}

class _ThreadDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ThreadDetail,
        ThreadDetailState> with ThreadDetailRef {
  _ThreadDetailProviderElement(super.provider);

  @override
  String? get childThreadId => (origin as ThreadDetailProvider).childThreadId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
