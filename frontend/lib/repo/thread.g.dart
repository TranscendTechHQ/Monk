// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentThreadHash() => r'3dcbeb034e478b98dc2c7ff8476e2a594aeb4ea6';

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
    extends BuildlessAutoDisposeAsyncNotifier<ThreadModel> {
  late final String title;
  late final String type;

  FutureOr<ThreadModel> build({
    required String title,
    required String type,
  });
}

/// See also [CurrentThread].
@ProviderFor(CurrentThread)
const currentThreadProvider = CurrentThreadFamily();

/// See also [CurrentThread].
class CurrentThreadFamily extends Family<AsyncValue<ThreadModel>> {
  /// See also [CurrentThread].
  const CurrentThreadFamily();

  /// See also [CurrentThread].
  CurrentThreadProvider call({
    required String title,
    required String type,
  }) {
    return CurrentThreadProvider(
      title: title,
      type: type,
    );
  }

  @override
  CurrentThreadProvider getProviderOverride(
    covariant CurrentThreadProvider provider,
  ) {
    return call(
      title: provider.title,
      type: provider.type,
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
    extends AutoDisposeAsyncNotifierProviderImpl<CurrentThread, ThreadModel> {
  /// See also [CurrentThread].
  CurrentThreadProvider({
    required String title,
    required String type,
  }) : this._internal(
          () => CurrentThread()
            ..title = title
            ..type = type,
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
  }) : super.internal();

  final String title;
  final String type;

  @override
  FutureOr<ThreadModel> runNotifierBuild(
    covariant CurrentThread notifier,
  ) {
    return notifier.build(
      title: title,
      type: type,
    );
  }

  @override
  Override overrideWith(CurrentThread Function() create) {
    return ProviderOverride(
      origin: this,
      override: CurrentThreadProvider._internal(
        () => create()
          ..title = title
          ..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        title: title,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CurrentThread, ThreadModel>
      createElement() {
    return _CurrentThreadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentThreadProvider &&
        other.title == title &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, title.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CurrentThreadRef on AutoDisposeAsyncNotifierProviderRef<ThreadModel> {
  /// The parameter `title` of this provider.
  String get title;

  /// The parameter `type` of this provider.
  String get type;
}

class _CurrentThreadProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CurrentThread, ThreadModel>
    with CurrentThreadRef {
  _CurrentThreadProviderElement(super.provider);

  @override
  String get title => (origin as CurrentThreadProvider).title;
  @override
  String get type => (origin as CurrentThreadProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
