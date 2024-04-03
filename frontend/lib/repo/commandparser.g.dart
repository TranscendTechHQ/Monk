// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commandparser.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commandHintTextHash() => r'fbcabe6f16a1687f7f16950a515ac67290798c09';

/// See also [CommandHintText].
@ProviderFor(CommandHintText)
final commandHintTextProvider =
    AutoDisposeNotifierProvider<CommandHintText, String>.internal(
  CommandHintText.new,
  name: r'commandHintTextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$commandHintTextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CommandHintText = AutoDisposeNotifier<String>;
String _$mainCommandTextHash() => r'ee0612554e7d33abbf0f8289dd5d71c751037282';

/// See also [MainCommandText].
@ProviderFor(MainCommandText)
final mainCommandTextProvider =
    AutoDisposeNotifierProvider<MainCommandText, String>.internal(
  MainCommandText.new,
  name: r'mainCommandTextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mainCommandTextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MainCommandText = AutoDisposeNotifier<String>;
String _$customCommandInputHash() =>
    r'357bb5ce37d0d5406b541d293ae25d8a28ff795d';

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

abstract class _$CustomCommandInput
    extends BuildlessAutoDisposeNotifier<CustomCommandInputState> {
  late final List<String> list;
  late final List<String> filtered;
  late final String? selected;
  late final String query;

  CustomCommandInputState build(
    List<String> list,
    List<String> filtered,
    String? selected,
    String query,
  );
}

/// See also [CustomCommandInput].
@ProviderFor(CustomCommandInput)
const customCommandInputProvider = CustomCommandInputFamily();

/// See also [CustomCommandInput].
class CustomCommandInputFamily extends Family<CustomCommandInputState> {
  /// See also [CustomCommandInput].
  const CustomCommandInputFamily();

  /// See also [CustomCommandInput].
  CustomCommandInputProvider call(
    List<String> list,
    List<String> filtered,
    String? selected,
    String query,
  ) {
    return CustomCommandInputProvider(
      list,
      filtered,
      selected,
      query,
    );
  }

  @override
  CustomCommandInputProvider getProviderOverride(
    covariant CustomCommandInputProvider provider,
  ) {
    return call(
      provider.list,
      provider.filtered,
      provider.selected,
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
  String? get name => r'customCommandInputProvider';
}

/// See also [CustomCommandInput].
class CustomCommandInputProvider extends AutoDisposeNotifierProviderImpl<
    CustomCommandInput, CustomCommandInputState> {
  /// See also [CustomCommandInput].
  CustomCommandInputProvider(
    List<String> list,
    List<String> filtered,
    String? selected,
    String query,
  ) : this._internal(
          () => CustomCommandInput()
            ..list = list
            ..filtered = filtered
            ..selected = selected
            ..query = query,
          from: customCommandInputProvider,
          name: r'customCommandInputProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customCommandInputHash,
          dependencies: CustomCommandInputFamily._dependencies,
          allTransitiveDependencies:
              CustomCommandInputFamily._allTransitiveDependencies,
          list: list,
          filtered: filtered,
          selected: selected,
          query: query,
        );

  CustomCommandInputProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.list,
    required this.filtered,
    required this.selected,
    required this.query,
  }) : super.internal();

  final List<String> list;
  final List<String> filtered;
  final String? selected;
  final String query;

  @override
  CustomCommandInputState runNotifierBuild(
    covariant CustomCommandInput notifier,
  ) {
    return notifier.build(
      list,
      filtered,
      selected,
      query,
    );
  }

  @override
  Override overrideWith(CustomCommandInput Function() create) {
    return ProviderOverride(
      origin: this,
      override: CustomCommandInputProvider._internal(
        () => create()
          ..list = list
          ..filtered = filtered
          ..selected = selected
          ..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        list: list,
        filtered: filtered,
        selected: selected,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CustomCommandInput,
      CustomCommandInputState> createElement() {
    return _CustomCommandInputProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomCommandInputProvider &&
        other.list == list &&
        other.filtered == filtered &&
        other.selected == selected &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, list.hashCode);
    hash = _SystemHash.combine(hash, filtered.hashCode);
    hash = _SystemHash.combine(hash, selected.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CustomCommandInputRef
    on AutoDisposeNotifierProviderRef<CustomCommandInputState> {
  /// The parameter `list` of this provider.
  List<String> get list;

  /// The parameter `filtered` of this provider.
  List<String> get filtered;

  /// The parameter `selected` of this provider.
  String? get selected;

  /// The parameter `query` of this provider.
  String get query;
}

class _CustomCommandInputProviderElement
    extends AutoDisposeNotifierProviderElement<CustomCommandInput,
        CustomCommandInputState> with CustomCommandInputRef {
  _CustomCommandInputProviderElement(super.provider);

  @override
  List<String> get list => (origin as CustomCommandInputProvider).list;
  @override
  List<String> get filtered => (origin as CustomCommandInputProvider).filtered;
  @override
  String? get selected => (origin as CustomCommandInputProvider).selected;
  @override
  String get query => (origin as CustomCommandInputProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
