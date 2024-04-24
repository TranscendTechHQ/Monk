import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'thread_card_provider.freezed.dart';
part 'thread_card_provider.g.dart';

@riverpod
class ThreadCard extends _$ThreadCard {
  @override
  ThreadCardState build(BlockWithCreator block, String type) {
    return ThreadCardState.initial(block, type);
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
    await Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(taskStatus: status);
    });
    state = state.copyWith(taskStatus: status);
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
  factory ThreadCardState.initial(BlockWithCreator block, String type) =>
      ThreadCardState(block: block, type: type);
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
    'Mark as In Todo',
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
