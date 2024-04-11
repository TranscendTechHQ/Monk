import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channels_provider.freezed.dart';
part 'channels_provider.g.dart';

@riverpod
class Channels extends _$Channels {
  @override
  Future<ChannelsState> build() async {
    return await Future.delayed(
      const Duration(seconds: 1),
      () {
        return ChannelsState.result(
          publicChannels: List.generate(
            25,
            (index) => Channel(
              id: index.toString(),
              name: '#Channel ${index + 1}',
              channelId: 'channel-${index + 1}',
              subscribed: true,
            ),
          ),
          subscribedChannels: [],
        );
      },
    );
  }

  void addToSubscribedChannels(Channel channel) {
    final dd = state.value;
    final selectedChannels = dd!.selectedChannels.getAbsoluteOrNull ?? [];

    if (selectedChannels.isNotNullEmpty && selectedChannels.contains(channel)) {
      selectedChannels.remove(channel);
    } else {
      selectedChannels.add(channel);
    }
    state = AsyncData(dd.copyWith(
      selectedChannels: selectedChannels,
    ));
  }

  Future<void> subscribedChannelsAsync() async {
    final dd = state.value;
    final selectedChannels = dd!.selectedChannels.getAbsoluteOrNull ?? [];

    if (selectedChannels.isNotNullEmpty) {
      await Future.delayed(const Duration(seconds: 1), () {
        state = AsyncData(dd.copyWith(
          subscribedChannels: selectedChannels,
          selectedChannels: [],
        ));
      });
    }
  }
}

@freezed
class ChannelsState with _$ChannelsState {
  const factory ChannelsState({
    @Default([]) List<Channel> publicChannels,
    @Default([]) List<Channel> subscribedChannels,
    @Default([]) List<Channel> selectedChannels,
    String? message,
  }) = _ChannelsState;
  factory ChannelsState.initial() => const ChannelsState();
  factory ChannelsState.result(
          {required List<Channel> publicChannels,
          List<Channel> subscribedChannels = const []}) =>
      ChannelsState(
        publicChannels: publicChannels,
        subscribedChannels: subscribedChannels,
      );
}

@freezed
class Channel with _$Channel {
  const factory Channel({
    String? id,
    String? name,
    String? channelId,
    @Default(false) bool subscribed,
  }) = _Channel;
  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
}

const publicChannels = [
  Channel(
    id: '1',
    name: '#Channel 1',
    channelId: 'channel-1',
    subscribed: false,
  ),
  Channel(
    id: '2',
    name: '#Channel 2',
    channelId: 'channel-2',
    subscribed: false,
  ),
  Channel(
    id: '3',
    name: '#Channel 3',
    channelId: 'channel-3',
    subscribed: false,
  ),
];

const subscribedChannels = [
  Channel(
    id: '4',
    name: '#Channel 4',
    channelId: 'channel-4',
    subscribed: true,
  ),
  Channel(
    id: '5',
    name: '#Channel 5',
    channelId: 'channel-5',
    subscribed: true,
  ),
  Channel(
    id: '6',
    name: '#Channel 6',
    channelId: 'channel-6',
    subscribed: true,
  ),
];
