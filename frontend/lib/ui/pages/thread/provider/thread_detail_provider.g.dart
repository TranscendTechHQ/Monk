// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$threadDetailHash() => r'7b66b1aeb57acba4cf9543b22e8b4ac2cc2a6e72';

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
  late final String threadId;
  late final BlockModel? block;

  FutureOr<ThreadDetailState> build({
    required String threadId,
    BlockModel? block,
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
    required String threadId,
    BlockModel? block,
  }) {
    return ThreadDetailProvider(
      threadId: threadId,
      block: block,
    );
  }

  @override
  ThreadDetailProvider getProviderOverride(
    covariant ThreadDetailProvider provider,
  ) {
    return call(
      threadId: provider.threadId,
      block: provider.block,
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
    required String threadId,
    BlockModel? block,
  }) : this._internal(
          () => ThreadDetail()
            ..threadId = threadId
            ..block = block,
          from: threadDetailProvider,
          name: r'threadDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$threadDetailHash,
          dependencies: ThreadDetailFamily._dependencies,
          allTransitiveDependencies:
              ThreadDetailFamily._allTransitiveDependencies,
          threadId: threadId,
          block: block,
        );

  ThreadDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadId,
    required this.block,
  }) : super.internal();

  final String threadId;
  final BlockModel? block;

  @override
  FutureOr<ThreadDetailState> runNotifierBuild(
    covariant ThreadDetail notifier,
  ) {
    return notifier.build(
      threadId: threadId,
      block: block,
    );
  }

  @override
  Override overrideWith(ThreadDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: ThreadDetailProvider._internal(
        () => create()
          ..threadId = threadId
          ..block = block,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threadId: threadId,
        block: block,
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
        other.threadId == threadId &&
        other.block == block;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);
    hash = _SystemHash.combine(hash, block.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ThreadDetailRef
    on AutoDisposeAsyncNotifierProviderRef<ThreadDetailState> {
  /// The parameter `threadId` of this provider.
  String get threadId;

  /// The parameter `block` of this provider.
  BlockModel? get block;
}

class _ThreadDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ThreadDetail,
        ThreadDetailState> with ThreadDetailRef {
  _ThreadDetailProviderElement(super.provider);

  @override
  String get threadId => (origin as ThreadDetailProvider).threadId;
  @override
  BlockModel? get block => (origin as ThreadDetailProvider).block;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
