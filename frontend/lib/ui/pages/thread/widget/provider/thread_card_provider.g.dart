// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_card_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$threadCardHash() => r'a58747d7513e14dddc833f48b0afa099dfcac22c';

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

abstract class _$ThreadCard
    extends BuildlessAutoDisposeNotifier<ThreadCardState> {
  late final BlockWithCreator block;
  late final String type;

  ThreadCardState build(
    BlockWithCreator block,
    String type,
  );
}

/// See also [ThreadCard].
@ProviderFor(ThreadCard)
const threadCardProvider = ThreadCardFamily();

/// See also [ThreadCard].
class ThreadCardFamily extends Family<ThreadCardState> {
  /// See also [ThreadCard].
  const ThreadCardFamily();

  /// See also [ThreadCard].
  ThreadCardProvider call(
    BlockWithCreator block,
    String type,
  ) {
    return ThreadCardProvider(
      block,
      type,
    );
  }

  @override
  ThreadCardProvider getProviderOverride(
    covariant ThreadCardProvider provider,
  ) {
    return call(
      provider.block,
      provider.type,
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
  String? get name => r'threadCardProvider';
}

/// See also [ThreadCard].
class ThreadCardProvider
    extends AutoDisposeNotifierProviderImpl<ThreadCard, ThreadCardState> {
  /// See also [ThreadCard].
  ThreadCardProvider(
    BlockWithCreator block,
    String type,
  ) : this._internal(
          () => ThreadCard()
            ..block = block
            ..type = type,
          from: threadCardProvider,
          name: r'threadCardProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$threadCardHash,
          dependencies: ThreadCardFamily._dependencies,
          allTransitiveDependencies:
              ThreadCardFamily._allTransitiveDependencies,
          block: block,
          type: type,
        );

  ThreadCardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.block,
    required this.type,
  }) : super.internal();

  final BlockWithCreator block;
  final String type;

  @override
  ThreadCardState runNotifierBuild(
    covariant ThreadCard notifier,
  ) {
    return notifier.build(
      block,
      type,
    );
  }

  @override
  Override overrideWith(ThreadCard Function() create) {
    return ProviderOverride(
      origin: this,
      override: ThreadCardProvider._internal(
        () => create()
          ..block = block
          ..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        block: block,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ThreadCard, ThreadCardState>
      createElement() {
    return _ThreadCardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThreadCardProvider &&
        other.block == block &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, block.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ThreadCardRef on AutoDisposeNotifierProviderRef<ThreadCardState> {
  /// The parameter `block` of this provider.
  BlockWithCreator get block;

  /// The parameter `type` of this provider.
  String get type;
}

class _ThreadCardProviderElement
    extends AutoDisposeNotifierProviderElement<ThreadCard, ThreadCardState>
    with ThreadCardRef {
  _ThreadCardProviderElement(super.provider);

  @override
  BlockWithCreator get block => (origin as ThreadCardProvider).block;
  @override
  String get type => (origin as ThreadCardProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
