import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/helper/monk-exception.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/main.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_thread_provider.freezed.dart';
part 'create_thread_provider.g.dart';

@riverpod
class CreateThreadPod extends _$CreateThreadPod {
  @override
  CreateThreadState build() {
    return CreateThreadState.initial();
  }

  Future<FullThreadInfo?> createThread(
      {required String topic, required String type}) async {
    state = state.copyWith(eState: ECreateThreadState.creatingThread);

    final res = await AsyncRequest.handle<FullThreadInfo>(() async {
      final threadApi = NetworkManager.instance.openApi.getThreadsApi();

      final response = await threadApi.createThThreadsPost(
          createThreadModel: CreateThreadModel(topic: topic, type: type));

      return response.data!;
    });

    return res.fold((l) {
      state = state.copyWith(eState: ECreateThreadState.threadError);
      if (l.response?.statusCode == 500) {
        throw Exception("Something went wrong, please try again later.");
      }
      throw Exception(l.message);
    }, (r) {
      state = state.copyWith(eState: ECreateThreadState.threadCreated);
      logger.i("Thread created");
      return r;
    });
  }

  Future<BlockWithCreator?> createBlock(
      BuildContext context, content, String threadTitle, String mainThreadId,
      {DateTime? dueDate, File? image}) async {
    final res = await AsyncRequest.handle<BlockWithCreator>(() async {
      logger.d("creating new Thread topic $content");
      if (image != null) {
        loader.showLoader(context, message: 'Uploading image');
      }
      final imageUrl = await uploadFile(image);
      loader.hideLoader();
      final blockApi = NetworkManager.instance.openApi.getThreadsApi();

      loader.showLoader(context, message: 'creating block');
      final newThreadState = await blockApi.createBlocksPost(
        threadTopic: threadTitle,
        createBlockModel: CreateBlockModel(
            content: content,
            mainThreadId: mainThreadId,
            dueDate: dueDate,
            image: imageUrl),
      );
      loader.hideLoader();
      return newThreadState.data!;
    });

    return res.fold((l) {
      state = state.copyWith(eState: ECreateThreadState.blockError);
      if (l.response?.statusCode == 500) {
        throw Exception("Something went wrong, please try again later.");
      }
      throw Exception(l.message);
    }, (r) {
      state = state.copyWith(eState: ECreateThreadState.blockCreated);
      logger.i("Block created");
      return r;
    });
  }

  Future<String?> uploadFile(File? file) async {
    if (file == null) {
      return null;
    }
    final res = await AsyncRequest.handle<FilesResponseModel>(() async {
      final response = await NetworkManager.instance.client.post(
        "/uploadFiles/",
        data: FormData.fromMap(
          {
            "files": await MultipartFile.fromFile(file.path,
                filename: file.path.split("/").last),
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to upload image");
      }

      return FilesResponseModel.fromJson(response.data);
    });
    return res.fold((l) {
      return null;
    }, (r) => r.urls?.first);
  }
}

@freezed
class CreateThreadState with _$CreateThreadState {
  const factory CreateThreadState({
    FullThreadInfo? thread,
    @Default(ECreateThreadState.initial) ECreateThreadState? eState,
  }) = _CreateThreadState;
  factory CreateThreadState.initial() => const CreateThreadState();
  factory CreateThreadState.result(
    FullThreadInfo thread,
    ECreateThreadState eState,
  ) =>
      CreateThreadState(
        thread: thread,
        eState: eState,
      );
}

enum ECreateThreadState {
  initial,
  creatingThread,
  creatingBlock,
  threadError,
  blockError,
  threadCreated,
  blockCreated,
}
