// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchThreadsInfoHash() => r'1e4b8b4b6d6b7cee77c1fc8b6a15c7b9873f6230';

/// This is a provider that maintains the list of all threads topic
///
/// Copied from [fetchThreadsInfo].
@ProviderFor(fetchThreadsInfo)
final fetchThreadsInfoProvider =
    AutoDisposeFutureProvider<Map<String, String>>.internal(
  fetchThreadsInfo,
  name: r'fetchThreadsInfoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchThreadsInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchThreadsInfoRef = AutoDisposeFutureProviderRef<Map<String, String>>;
String _$fetchThreadTypesHash() => r'732745883f982e5fc4a4791f7ac1c4fa5e0af7bb';

/// See also [fetchThreadTypes].
@ProviderFor(fetchThreadTypes)
final fetchThreadTypesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  fetchThreadTypes,
  name: r'fetchThreadTypesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchThreadTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchThreadTypesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$currentThreadHash() => r'3d2e7305b2f6dba360a3e2b0d9d2f51acebc8284';

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

abstract class _$CurrentThread
    extends BuildlessAutoDisposeAsyncNotifier<CurrentTreadState> {
  late final String topic;
  late final String type;
  late final String? threadChildId;
  late final String? mainThreadId;

  FutureOr<CurrentTreadState> build({
    required String topic,
    required String type,
    String? threadChildId,
    String? mainThreadId,
  });
}

/// See also [CurrentThread].
@ProviderFor(CurrentThread)
const currentThreadProvider = CurrentThreadFamily();

/// See also [CurrentThread].
class CurrentThreadFamily extends Family<AsyncValue<CurrentTreadState>> {
  /// See also [CurrentThread].
  const CurrentThreadFamily();

  /// See also [CurrentThread].
  CurrentThreadProvider call({
    required String topic,
    required String type,
    String? threadChildId,
    String? mainThreadId,
  }) {
    return CurrentThreadProvider(
      topic: topic,
      type: type,
      threadChildId: threadChildId,
      mainThreadId: mainThreadId,
    );
  }

  @override
  CurrentThreadProvider getProviderOverride(
    covariant CurrentThreadProvider provider,
  ) {
    return call(
      topic: provider.topic,
      type: provider.type,
      threadChildId: provider.threadChildId,
      mainThreadId: provider.mainThreadId,
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
  String? get name => r'currentThreadProvider';
}

/// See also [CurrentThread].
class CurrentThreadProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CurrentThread, CurrentTreadState> {
  /// See also [CurrentThread].
  CurrentThreadProvider({
    required String topic,
    required String type,
    String? threadChildId,
    String? mainThreadId,
  }) : this._internal(
          () => CurrentThread()
            ..topic = topic
            ..type = type
            ..threadChildId = threadChildId
            ..mainThreadId = mainThreadId,
          from: currentThreadProvider,
          name: r'currentThreadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentThreadHash,
          dependencies: CurrentThreadFamily._dependencies,
          allTransitiveDependencies:
              CurrentThreadFamily._allTransitiveDependencies,
          topic: topic,
          type: type,
          threadChildId: threadChildId,
          mainThreadId: mainThreadId,
        );

  CurrentThreadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topic,
    required this.type,
    required this.threadChildId,
    required this.mainThreadId,
  }) : super.internal();

  final String topic;
  final String type;
  final String? threadChildId;
  final String? mainThreadId;

  @override
  FutureOr<CurrentTreadState> runNotifierBuild(
    covariant CurrentThread notifier,
  ) {
    return notifier.build(
      topic: topic,
      type: type,
      threadChildId: threadChildId,
      mainThreadId: mainThreadId,
    );
  }

  @override
  Override overrideWith(CurrentThread Function() create) {
    return ProviderOverride(
      origin: this,
      override: CurrentThreadProvider._internal(
        () => create()
          ..topic = topic
          ..type = type
          ..threadChildId = threadChildId
          ..mainThreadId = mainThreadId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topic: topic,
        type: type,
        threadChildId: threadChildId,
        mainThreadId: mainThreadId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CurrentThread, CurrentTreadState>
      createElement() {
    return _CurrentThreadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentThreadProvider &&
        other.topic == topic &&
        other.type == type &&
        other.threadChildId == threadChildId &&
        other.mainThreadId == mainThreadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topic.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, threadChildId.hashCode);
    hash = _SystemHash.combine(hash, mainThreadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CurrentThreadRef
    on AutoDisposeAsyncNotifierProviderRef<CurrentTreadState> {
  /// The parameter `topic` of this provider.
  String get topic;

  /// The parameter `type` of this provider.
  String get type;

  /// The parameter `threadChildId` of this provider.
  String? get threadChildId;

  /// The parameter `mainThreadId` of this provider.
  String? get mainThreadId;
}

class _CurrentThreadProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CurrentThread,
        CurrentTreadState> with CurrentThreadRef {
  _CurrentThreadProviderElement(super.provider);

  @override
  String get topic => (origin as CurrentThreadProvider).topic;
  @override
  String get type => (origin as CurrentThreadProvider).type;
  @override
  String? get threadChildId => (origin as CurrentThreadProvider).threadChildId;
  @override
  String? get mainThreadId => (origin as CurrentThreadProvider).mainThreadId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
