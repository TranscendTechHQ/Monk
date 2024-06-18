import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  Future<void> addDueDate(DateTime date) async {
    state = state.copyWith(addingDueDate: true);
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final blockId = state.block.id;
    final res = await AsyncRequest.handle<BlockWithCreator>(() async {
      final res = await threadApi.updateBlockDueDateBlocksIdDueDatePut(
        id: blockId!,
        body: date.toIso8601String(),
      );
      return res.data!;
    });
    state = state.copyWith(addingDueDate: false);
    res.fold((l) {
      throw Exception('Failed to update due date');
    }, (r) {
      final map = state.block.toJson();
      if (map.keys.contains('due_date')) {
        map.update('due_date', (value) => date.toIso8601String());
      } else {
        map.putIfAbsent('due_date', () => date.toIso8601String());
      }
      map.putIfAbsent('due_date', () => date.toIso8601String());
      state = state.copyWith(block: BlockWithCreator.fromJson(map));
    });
  }

  Future<void> assignTodoToUser(String assignedUserId) async {
    state = state.copyWith(assigningTask: true);
    final threadApi = NetworkManager.instance.openApi.getThreadsApi();
    final blockId = state.block.id;
    final res = await AsyncRequest.handle<BlockWithCreator>(() async {
      final res = await threadApi.updateBlockAssignedUserBlocksIdAssignPut(
        id: blockId!,
        body: assignedUserId,
      );
      return res.data!;
    });
    state = state.copyWith(assigningTask: false);
    res.fold((l) {
      throw Exception('Failed to update assigned');
    }, (r) {
      final map = state.block.toJson();
      if (map.keys.contains('assigned_to_id')) {
        map.update('assigned_to_id', (value) => assignedUserId);
      } else {
        map.putIfAbsent('assigned_to_id', () => assignedUserId);
      }
      if (map.keys.contains('assigned_to')) {
        map.update('assigned_to', (value) => r.assignedTo?.toJson());
      } else {
        map.putIfAbsent('assigned_to', () => r.assignedTo?.toJson());
      }
      map.putIfAbsent('assigned_to', () => r.assignedTo?.toJson());
      state = state.copyWith(block: BlockWithCreator.fromJson(map));
    });
  }
}

@freezed
class ThreadCardState with _$ThreadCardState {
  const factory ThreadCardState({
    required BlockWithCreator block,
    required String type,
    @Default(false) bool addingDueDate,
    @Default(false) bool assigningTask,
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
    'todo.svg',
    Colors.blue,
    Colors.white,
  ),
  inProgress(
    'In Progress',
    'Mark as In Done',
    'in-progress.svg',
    Colors.amber,
    Colors.white,
  ),
  done(
    'Completed',
    'Mark as In progress',
    'check-fill.svg',
    Colors.green,
    Colors.white,
  ),

  loading(
    'Updating',
    'Loading',
    '',
    Colors.green,
    Colors.white,
  );

  final String name;
  final String tooltip;
  final String svgIcon;
  final Color bgColor;
  final Color fgColor;

  const ETaskStatus(
      this.name, this.tooltip, this.svgIcon, this.bgColor, this.fgColor);
}
