// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchThreadsInfoHash() => r'2f19f66379d9c9d60759ef7bf34ac062de6baaab';

/// See also [fetchThreadsInfo].
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
String _$currentThreadHash() => r'6121d9748c9817a7d2fa0d58ef508974f4a37cac';

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
    extends BuildlessAutoDisposeAsyncNotifier<ThreadModel?> {
  late final String title;
  late final String type;
  late final ThreadType threadType;
  late final String? threadChildId;

  FutureOr<ThreadModel?> build({
    required String title,
    required String type,
    ThreadType threadType = ThreadType.thread,
    String? threadChildId,
  });
}

/// See also [CurrentThread].
@ProviderFor(CurrentThread)
const currentThreadProvider = CurrentThreadFamily();

/// See also [CurrentThread].
class CurrentThreadFamily extends Family<AsyncValue<ThreadModel?>> {
  /// See also [CurrentThread].
  const CurrentThreadFamily();

  /// See also [CurrentThread].
  CurrentThreadProvider call({
    required String title,
    required String type,
    ThreadType threadType = ThreadType.thread,
    String? threadChildId,
  }) {
    return CurrentThreadProvider(
      title: title,
      type: type,
      threadType: threadType,
      threadChildId: threadChildId,
    );
  }

  @override
  CurrentThreadProvider getProviderOverride(
    covariant CurrentThreadProvider provider,
  ) {
    return call(
      title: provider.title,
      type: provider.type,
      threadType: provider.threadType,
      threadChildId: provider.threadChildId,
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
class CurrentThreadProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CurrentThread, ThreadModel?> {
  /// See also [CurrentThread].
  CurrentThreadProvider({
    required String title,
    required String type,
    ThreadType threadType = ThreadType.thread,
    String? threadChildId,
  }) : this._internal(
          () => CurrentThread()
            ..title = title
            ..type = type
            ..threadType = threadType
            ..threadChildId = threadChildId,
          from: currentThreadProvider,
          name: r'currentThreadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentThreadHash,
          dependencies: CurrentThreadFamily._dependencies,
          allTransitiveDependencies:
              CurrentThreadFamily._allTransitiveDependencies,
          title: title,
          type: type,
          threadType: threadType,
          threadChildId: threadChildId,
        );

  CurrentThreadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.title,
    required this.type,
    required this.threadType,
    required this.threadChildId,
  }) : super.internal();

  final String title;
  final String type;
  final ThreadType threadType;
  final String? threadChildId;

  @override
  FutureOr<ThreadModel?> runNotifierBuild(
    covariant CurrentThread notifier,
  ) {
    return notifier.build(
      title: title,
      type: type,
      threadType: threadType,
      threadChildId: threadChildId,
    );
  }

  @override
  Override overrideWith(CurrentThread Function() create) {
    return ProviderOverride(
      origin: this,
      override: CurrentThreadProvider._internal(
        () => create()
          ..title = title
          ..type = type
          ..threadType = threadType
          ..threadChildId = threadChildId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        title: title,
        type: type,
        threadType: threadType,
        threadChildId: threadChildId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CurrentThread, ThreadModel?>
      createElement() {
    return _CurrentThreadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentThreadProvider &&
        other.title == title &&
        other.type == type &&
        other.threadType == threadType &&
        other.threadChildId == threadChildId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, threadType.hashCode);
    hash = _SystemHash.combine(hash, threadChildId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CurrentThreadRef on AutoDisposeAsyncNotifierProviderRef<ThreadModel?> {
  /// The parameter `title` of this provider.
  String get title;

  /// The parameter `type` of this provider.
  String get type;

  /// The parameter `threadType` of this provider.
  ThreadType get threadType;

  /// The parameter `threadChildId` of this provider.
  String? get threadChildId;
}

class _CurrentThreadProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CurrentThread, ThreadModel?>
    with CurrentThreadRef {
  _CurrentThreadProviderElement(super.provider);

  @override
  String get title => (origin as CurrentThreadProvider).title;
  @override
  String get type => (origin as CurrentThreadProvider).type;
  @override
  ThreadType get threadType => (origin as CurrentThreadProvider).threadType;
  @override
  String? get threadChildId => (origin as CurrentThreadProvider).threadChildId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
