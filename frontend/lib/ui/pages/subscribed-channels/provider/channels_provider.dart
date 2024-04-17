import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channels_provider.freezed.dart';
part 'channels_provider.g.dart';

@riverpod
class Channels extends _$Channels {
  @override
  Future<ChannelsState> build() async {
    final slackApi = NetworkManager.instance.openApi.getSlackApi();
    final res = await slackApi.chChannelListGet();
    if (res.data != null) {
      final composite = res.data!;
      return ChannelsState.result(
        publicChannels: composite.publicChannels,
        // selectedChannels: composite.subscribedChannels,
        subscribedChannels: composite.subscribedChannels,
      );
    }
    return ChannelsState.initial();
  }

  void addToSubscribedChannels(ChannelModel channel) {
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
      final slackApi = NetworkManager.instance.openApi.getSlackApi();
      final res = await slackApi.subscribeChannelSubscribeChannelPost(
        subscribeChannelRequest: SubscribeChannelRequest(
        channelIds: selectedChannels.map((e) => e.id).toList(),
      ),);
      if (res.data != null) {
        state = AsyncData(dd.copyWith(
          subscribedChannels: res.data!.subscribedChannels,
        ));
      }
    }
  }
}

@freezed
class ChannelsState with _$ChannelsState {
  const factory ChannelsState({
    @Default([]) List<ChannelModel> publicChannels,
    @Default([]) List<ChannelModel> subscribedChannels,
    @Default([]) List<ChannelModel> selectedChannels,
    String? message,
  }) = _ChannelsState;
  factory ChannelsState.initial() => const ChannelsState();
  factory ChannelsState.result({
    required List<ChannelModel> publicChannels,
    List<ChannelModel> subscribedChannels = const [],
    List<ChannelModel> selectedChannels = const [],
  }) =>
      ChannelsState(
          publicChannels: publicChannels,
          subscribedChannels: subscribedChannels,
          selectedChannels: selectedChannels);
}
