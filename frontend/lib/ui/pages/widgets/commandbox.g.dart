// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commandbox.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$screenVisibilityHash() => r'981a55e98792035080bab830cd862393d8940737';

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

abstract class _$ScreenVisibility
    extends BuildlessAutoDisposeNotifier<InputBoxType> {
  late final InputBoxType visibility;

  InputBoxType build({
    InputBoxType visibility = InputBoxType.thread,
  });
}

/// See also [ScreenVisibility].
@ProviderFor(ScreenVisibility)
const screenVisibilityProvider = ScreenVisibilityFamily();

/// See also [ScreenVisibility].
class ScreenVisibilityFamily extends Family<InputBoxType> {
  /// See also [ScreenVisibility].
  const ScreenVisibilityFamily();

  /// See also [ScreenVisibility].
  ScreenVisibilityProvider call({
    InputBoxType visibility = InputBoxType.thread,
  }) {
    return ScreenVisibilityProvider(
      visibility: visibility,
    );
  }

  @override
  ScreenVisibilityProvider getProviderOverride(
    covariant ScreenVisibilityProvider provider,
  ) {
    return call(
      visibility: provider.visibility,
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
  String? get name => r'screenVisibilityProvider';
}

/// See also [ScreenVisibility].
class ScreenVisibilityProvider
    extends AutoDisposeNotifierProviderImpl<ScreenVisibility, InputBoxType> {
  /// See also [ScreenVisibility].
  ScreenVisibilityProvider({
    InputBoxType visibility = InputBoxType.thread,
  }) : this._internal(
          () => ScreenVisibility()..visibility = visibility,
          from: screenVisibilityProvider,
          name: r'screenVisibilityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$screenVisibilityHash,
          dependencies: ScreenVisibilityFamily._dependencies,
          allTransitiveDependencies:
              ScreenVisibilityFamily._allTransitiveDependencies,
          visibility: visibility,
        );

  ScreenVisibilityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.visibility,
  }) : super.internal();

  final InputBoxType visibility;

  @override
  InputBoxType runNotifierBuild(
    covariant ScreenVisibility notifier,
  ) {
    return notifier.build(
      visibility: visibility,
    );
  }

  @override
  Override overrideWith(ScreenVisibility Function() create) {
    return ProviderOverride(
      origin: this,
      override: ScreenVisibilityProvider._internal(
        () => create()..visibility = visibility,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        visibility: visibility,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ScreenVisibility, InputBoxType>
      createElement() {
    return _ScreenVisibilityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScreenVisibilityProvider && other.visibility == visibility;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, visibility.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ScreenVisibilityRef on AutoDisposeNotifierProviderRef<InputBoxType> {
  /// The parameter `visibility` of this provider.
  InputBoxType get visibility;
}

class _ScreenVisibilityProviderElement
    extends AutoDisposeNotifierProviderElement<ScreenVisibility, InputBoxType>
    with ScreenVisibilityRef {
  _ScreenVisibilityProviderElement(super.provider);

  @override
  InputBoxType get visibility =>
      (origin as ScreenVisibilityProvider).visibility;
}

String _$blockAttachmentHash() => r'fab5522092afc4c0d373d04a93b9f90dbcc6145d';

/// See also [BlockAttachment].
@ProviderFor(BlockAttachment)
final blockAttachmentProvider =
    AutoDisposeNotifierProvider<BlockAttachment, File?>.internal(
  BlockAttachment.new,
  name: r'blockAttachmentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$blockAttachmentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BlockAttachment = AutoDisposeNotifier<File?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
