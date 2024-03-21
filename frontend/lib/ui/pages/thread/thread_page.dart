import 'dart:convert';

import 'package:frontend/main.dart';
import 'package:frontend/ui/pages/thread/provider/thread_detail_provider.dart';
import 'package:frontend/ui/pages/thread/thread_detail_page.dart';
import 'package:frontend/ui/pages/widgets/commandbox.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/repo/thread.dart';

import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:openapi/openapi.dart';

enum ThreadType { thread, reply }

class ThreadPage extends ConsumerWidget {
  final String title;
  final String type;
  final ThreadType threadType;
  const ThreadPage({
    super.key,
    required this.title,
    required this.type,
    this.threadType = ThreadType.thread,
  });

  static String route = "/journal";
  static Route launchRoute(
      {required String title,
      required String type,
      ThreadType threadType = ThreadType.thread}) {
    return MaterialPageRoute<void>(
      builder: (_) =>
          ThreadPage(title: title, type: type, threadType: threadType),
    );
  }

  String get formatType {
    if (type.contains('-')) {
      return type.split('-')[1];
    } else if (type.contains('/')) {
      return type.split('/')[1];
    }
    return type;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThread =
        ref.watch(currentThreadProvider.call(title: title, type: type));
    final blockInput = CommandBox(title: title, type: type);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$formatType -: $title',
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: PageScaffold(
        body: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                  child: currentThread.when(
                data: (state) => threadType == ThreadType.reply
                    ? RepliesListView(
                        replies: state?.content?.reversed.toList(),
                      )
                    : ChatListView(
                        currentThread: currentThread,
                        title: title,
                        type: type,
                      ),
                error: (error, stack) => Center(
                  child: Text(
                    error.toString().replaceFirst('Exception: ', ''),
                    style: context.textTheme.bodySmall,
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              )),
              blockInput,
            ],
          ),
        ),
      ),
    );
  }
}

class ChatListView extends ConsumerWidget {
  ChatListView({
    super.key,
    required this.currentThread,
    required this.title,
    required this.type,
  });
  final AsyncValue<ThreadModel?> currentThread;
  final String type;
  final String title;

  final scrollController = ScrollController();
  scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  final emojiParser = EmojiParser(init: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = currentThread.value?.content?.reversed.toList();
    final parentThreadId = currentThread.value?.id;
    return SizedBox(
      width: containerWidth,
      child: ListView.builder(
        reverse: true,
        controller: scrollController,
        itemCount: blocks?.length ?? 0,
        padding: const EdgeInsets.only(bottom: 30),
        itemBuilder: (context, index) {
          final block = blocks?[index];
          return ThreadCard(
            block: block!,
            emojiParser: emojiParser,
            title: title,
            type: type,
            parentThreadId: parentThreadId,
          );
        },
      ),
    );
  }
}

class ThreadCard extends ConsumerWidget {
  const ThreadCard({
    super.key,
    required this.block,
    required this.emojiParser,
    required this.title,
    required this.type,
    required this.parentThreadId,
  });
  final BlockModel block;
  final String type;
  final String title;
  final EmojiParser emojiParser;
  final String? parentThreadId;

  Future<void> onReplyClick(BuildContext context, WidgetRef ref,
      ThreadDetailProvider replyProvider) async {
    if (block.id.isNullOrEmpty || parentThreadId.isNullOrEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thread Id or Block Id is missing'),
        ),
      );
      return;
    }
    try {
      if (block.childId.isNullOrEmpty) {
        final createChildThreadModel = CreateChildThreadModel(
          title: title,
          type: type,
          parentBlockId: block.id!,
          parentThreadId: parentThreadId!,
        );
        loader.showLoader(context, message: 'Creating Thread');
        final state = await ref
            .read(replyProvider.notifier)
            .createOrFetchReplyThread(
                createChildThreadModel:
                    block.childId.isNullOrEmpty ? createChildThreadModel : null,
                childThreadId:
                    block.childId.isNullOrEmpty ? '' : block.childId!);

        // final provider = threadDetailProvider.call();

        // final state = await ref.read(provider.future);
        if (state.thread != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thread created successfully'),
            ),
          );
          // Navigator.push(
          //     context,
          //     ThreadPage.launchRoute(
          //       title: ("Reply$title${block.id?.substring(0, 9)}")
          //           .replaceAll('-', ''),
          //       type: type,
          //     ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create thread'),
            ),
          );
        }
      } else {
        Navigator.push(
          context,
          ThreadPage.launchRoute(
            title:
                ("Reply$title${block.id?.substring(0, 9)}").replaceAll('-', ''),
            type: type,
            threadType: ThreadType.reply,
          ),
        );
      }
      // Navigator.push(
      //   context,
      //   ThreadDetailPage.launchRoute(
      //     title: ("Reply$title${block.id?.substring(0, 9)}")
      //         .replaceAll('-', ''),
      //     type: type,
      //     parentBlockId: block.id!,
      //     block: block,
      //     parentThreadId: parentThreadId!,
      //   ),
      // );
    } catch (e) {
      logger.e('Error onReplyClick: $e');
    } finally {
      loader.hideLoader();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replyProvider = threadDetailProvider.call();

    // final replyThread = ref.watch(replyProvider);
    // replyThread.maybeWhen(
    //   orElse: () {},
    //   data: (state) {
    //     print(
    //         'Initiating Adding childThreadId ${state.thread?.id} to blockId ${block.id}');
    //     if (state.thread != null && state.thread!.id.isNotNullEmpty) {
    //       ref
    //           .read(
    //               currentThreadProvider.call(title: title, type: type).notifier)
    //           .addChildThreadIdToBlock(
    //             state.thread!.id!,
    //             block.id!,
    //           );
    //     }
    //   },
    // );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecorations.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      block.creatorPicture!.startsWith('https')
                          ? block.creatorPicture!
                          : "https://api.dicebear.com/7.x/identicon/png?seed=${block.createdBy ?? "UN"}",
                      width: 25,
                      height: 25,
                      cacheHeight: 30,
                      cacheWidth: 30,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${block.createdBy}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (block.createdAt != null)
                        Text(
                          DateFormat('dd MMM yyyy')
                              .format(block.createdAt!.toLocal()),
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.6),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            emojiParser.emojify(block.content.toString()).trimRight(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async => onReplyClick(context, ref, replyProvider),
            child: Text(
              block.childId.isNotNullEmpty ? "Replies" : 'Reply in Thread',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.customColors.sourceMonkBlue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
