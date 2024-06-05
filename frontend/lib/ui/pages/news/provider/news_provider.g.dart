// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newsFeedHash() => r'1660f35fd7f6f343826bf83083e24ea8102dd571';

/// See also [NewsFeed].
@ProviderFor(NewsFeed)
final newsFeedProvider =
    AutoDisposeAsyncNotifierProvider<NewsFeed, List<ThreadMetaData>>.internal(
  NewsFeed.new,
  name: r'newsFeedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$newsFeedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NewsFeed = AutoDisposeAsyncNotifier<List<ThreadMetaData>>;
String _$newsCardPodHash() => r'55a7520eefc84adb9ade9b4f90b372eddd8c110a';

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

abstract class _$NewsCardPod
    extends BuildlessAutoDisposeNotifier<NewsCardState> {
  late final ThreadMetaData threadMetaData;

  NewsCardState build(
    ThreadMetaData threadMetaData,
  );
}

/// See also [NewsCardPod].
@ProviderFor(NewsCardPod)
const newsCardPodProvider = NewsCardPodFamily();

/// See also [NewsCardPod].
class NewsCardPodFamily extends Family<NewsCardState> {
  /// See also [NewsCardPod].
  const NewsCardPodFamily();

  /// See also [NewsCardPod].
  NewsCardPodProvider call(
    ThreadMetaData threadMetaData,
  ) {
    return NewsCardPodProvider(
      threadMetaData,
    );
  }

  @override
  NewsCardPodProvider getProviderOverride(
    covariant NewsCardPodProvider provider,
  ) {
    return call(
      provider.threadMetaData,
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
  String? get name => r'newsCardPodProvider';
}

/// See also [NewsCardPod].
class NewsCardPodProvider
    extends AutoDisposeNotifierProviderImpl<NewsCardPod, NewsCardState> {
  /// See also [NewsCardPod].
  NewsCardPodProvider(
    ThreadMetaData threadMetaData,
  ) : this._internal(
          () => NewsCardPod()..threadMetaData = threadMetaData,
          from: newsCardPodProvider,
          name: r'newsCardPodProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$newsCardPodHash,
          dependencies: NewsCardPodFamily._dependencies,
          allTransitiveDependencies:
              NewsCardPodFamily._allTransitiveDependencies,
          threadMetaData: threadMetaData,
        );

  NewsCardPodProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadMetaData,
  }) : super.internal();

  final ThreadMetaData threadMetaData;

  @override
  NewsCardState runNotifierBuild(
    covariant NewsCardPod notifier,
  ) {
    return notifier.build(
      threadMetaData,
    );
  }

  @override
  Override overrideWith(NewsCardPod Function() create) {
    return ProviderOverride(
      origin: this,
      override: NewsCardPodProvider._internal(
        () => create()..threadMetaData = threadMetaData,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threadMetaData: threadMetaData,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<NewsCardPod, NewsCardState>
      createElement() {
    return _NewsCardPodProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NewsCardPodProvider &&
        other.threadMetaData == threadMetaData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadMetaData.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NewsCardPodRef on AutoDisposeNotifierProviderRef<NewsCardState> {
  /// The parameter `threadMetaData` of this provider.
  ThreadMetaData get threadMetaData;
}

class _NewsCardPodProviderElement
    extends AutoDisposeNotifierProviderElement<NewsCardPod, NewsCardState>
    with NewsCardPodRef {
  _NewsCardPodProviderElement(super.provider);

  @override
  ThreadMetaData get threadMetaData =>
      (origin as NewsCardPodProvider).threadMetaData;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
