import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'thread_card_provider.freezed.dart';
part 'thread_card_provider.g.dart';

@riverpod
class ThreadCard extends _$ThreadCard {
  @override
  ThreadCardState build(BlockModel block, String type) {
    return ThreadCardState.initial(block, type);
  }

  void toggleEdit() {
    state = state.copyWith(
      eState: state.eState == EThreadCardState.idle
          ? EThreadCardState.edit
          : EThreadCardState.idle,
    );

    print(state.eState);
  }

  void onHoverEnter() {
    state = state.copyWith(hoverEnabled: true);
  }

  void onHoverExit() {
    state = state.copyWith(hoverEnabled: false);
  }
}

@freezed
class ThreadCardState with _$ThreadCardState {
  const factory ThreadCardState({
    required BlockModel block,
    required String type,
    @Default(EThreadCardState.idle) EThreadCardState eState,
    @Default(false) hoverEnabled,
  }) = _ThreadCardState;
  factory ThreadCardState.initial(BlockModel block, String type) =>
      ThreadCardState(block: block, type: type);
}

enum EThreadCardState { edit, idle }
