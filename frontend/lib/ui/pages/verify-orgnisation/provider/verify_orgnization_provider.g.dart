// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_orgnization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$verifyOrganizationHash() =>
    r'1c5d0738d28c1b5165f3fa731e3a8055ff70ceaf';

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

abstract class _$VerifyOrganization
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String email;

  FutureOr<bool> build({
    required String email,
  });
}

/// See also [VerifyOrganization].
@ProviderFor(VerifyOrganization)
const verifyOrganizationProvider = VerifyOrganizationFamily();

/// See also [VerifyOrganization].
class VerifyOrganizationFamily extends Family<AsyncValue<bool>> {
  /// See also [VerifyOrganization].
  const VerifyOrganizationFamily();

  /// See also [VerifyOrganization].
  VerifyOrganizationProvider call({
    required String email,
  }) {
    return VerifyOrganizationProvider(
      email: email,
    );
  }

  @override
  VerifyOrganizationProvider getProviderOverride(
    covariant VerifyOrganizationProvider provider,
  ) {
    return call(
      email: provider.email,
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
  String? get name => r'verifyOrganizationProvider';
}

/// See also [VerifyOrganization].
class VerifyOrganizationProvider
    extends AutoDisposeAsyncNotifierProviderImpl<VerifyOrganization, bool> {
  /// See also [VerifyOrganization].
  VerifyOrganizationProvider({
    required String email,
  }) : this._internal(
          () => VerifyOrganization()..email = email,
          from: verifyOrganizationProvider,
          name: r'verifyOrganizationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$verifyOrganizationHash,
          dependencies: VerifyOrganizationFamily._dependencies,
          allTransitiveDependencies:
              VerifyOrganizationFamily._allTransitiveDependencies,
          email: email,
        );

  VerifyOrganizationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
  }) : super.internal();

  final String email;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant VerifyOrganization notifier,
  ) {
    return notifier.build(
      email: email,
    );
  }

  @override
  Override overrideWith(VerifyOrganization Function() create) {
    return ProviderOverride(
      origin: this,
      override: VerifyOrganizationProvider._internal(
        () => create()..email = email,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<VerifyOrganization, bool>
      createElement() {
    return _VerifyOrganizationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VerifyOrganizationProvider && other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin VerifyOrganizationRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `email` of this provider.
  String get email;
}

class _VerifyOrganizationProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<VerifyOrganization, bool>
    with VerifyOrganizationRef {
  _VerifyOrganizationProviderElement(super.provider);

  @override
  String get email => (origin as VerifyOrganizationProvider).email;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
