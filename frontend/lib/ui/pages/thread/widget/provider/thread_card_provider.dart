import 'package:flutter/material.dart';
import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'thread_card_provider.freezed.dart';
part 'thread_card_provider.g.dart';

@riverpod
class ThreadCard extends _$ThreadCard {
  @override
  ThreadCardState build(BlockWithCreator block, String type) {
    return ThreadCardState.initial(
      block,
      type,
      block.taskStatus == "done"
          ? ETaskStatus.done
          : block.taskStatus == "inprogress"
              ? ETaskStatus.inProgress
              : ETaskStatus.todo,
    );
  }

  void toggleEdit() {
    state = state.copyWith(
      eState: state.eState == EThreadCardState.idle
          ? EThreadCardState.edit
          : EThreadCardState.idle,
    );
  }

  void onHoverEnter() {
    state = state.copyWith(hoverEnabled: true);
  }

  void onHoverExit() {
    state = state.copyWith(hoverEnabled: false);
  }

  Future<void> setTaskStatus(ETaskStatus status) async {
    state = state.copyWith(taskStatus: ETaskStatus.loading);
    // await Future.delayed(const Duration(seconds: 1), () {
    //   state = state.copyWith(taskStatus: status);
    // });
    // state = state.copyWith(taskStatus: status);

    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final blockId = state.block.id;
    final body = status == ETaskStatus.todo
        ? 'todo'
        : status == ETaskStatus.inProgress
            ? 'inprogress'
            : 'done';
    final res = await AsyncRequest.handle<BlockWithCreator>(() async {
      final res = await threadApi.updateBlockTaskStatusBlocksIdTaskStatusPut(
          id: blockId!, body: body);
      return res.data!;
    });

    res.fold((l) {
      state = state.copyWith(taskStatus: status);
      throw Exception('Failed to update task status');
    }, (r) {
      print('Setting task status to $status');
      state = state.copyWith(taskStatus: status);
    });
  }
}

@freezed
class ThreadCardState with _$ThreadCardState {
  const factory ThreadCardState({
    required BlockWithCreator block,
    required String type,
    @Default(EThreadCardState.idle) EThreadCardState eState,
    @Default(false) hoverEnabled,
    @Default(ETaskStatus.todo) ETaskStatus taskStatus,
  }) = _ThreadCardState;
  factory ThreadCardState.initial(
          BlockWithCreator block, String type, ETaskStatus taskStatus) =>
      ThreadCardState(block: block, type: type, taskStatus: taskStatus);
}

enum EThreadCardState { edit, idle }

enum ETaskStatus {
  todo(
    'Todo',
    'Mark as In Progress',
    Icons.playlist_add_rounded,
    Colors.blue,
    Colors.white,
  ),
  inProgress(
    'In Progress',
    'Mark as In Done',
    Icons.construction,
    Colors.amber,
    Colors.white,
  ),
  done(
    'Done',
    'Mark as In progress',
    Icons.check_circle_outline,
    Colors.green,
    Colors.white,
  ),

  loading(
    'Updating',
    'Loading',
    Icons.check_circle_outline,
    Colors.green,
    Colors.white,
  );

  final String name;
  final String tooltip;
  final IconData icon;
  final Color bgColor;
  final Color fgColor;

  const ETaskStatus(
      this.name, this.tooltip, this.icon, this.bgColor, this.fgColor);
}
