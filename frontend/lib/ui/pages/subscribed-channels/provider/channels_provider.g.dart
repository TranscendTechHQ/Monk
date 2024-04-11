// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channels_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChannelImpl _$$ChannelImplFromJson(Map<String, dynamic> json) =>
    _$ChannelImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      channelId: json['channelId'] as String?,
      subscribed: json['subscribed'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChannelImplToJson(_$ChannelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'channelId': instance.channelId,
      'subscribed': instance.subscribed,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$channelsHash() => r'f14d944e1aea2a88146fe0980c02925570233b88';

/// See also [Channels].
@ProviderFor(Channels)
final channelsProvider =
    AutoDisposeAsyncNotifierProvider<Channels, ChannelsState>.internal(
  Channels.new,
  name: r'channelsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$channelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Channels = AutoDisposeAsyncNotifier<ChannelsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
