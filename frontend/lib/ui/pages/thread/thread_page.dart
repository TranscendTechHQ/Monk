import 'package:frontend/main.dart';
import 'package:frontend/ui/pages/thread/page/provider/thread_detail_provider.dart';
import 'package:frontend/ui/pages/thread/page/thread_detail_page.dart';
import 'package:frontend/ui/pages/thread/widget/thread_card.dart';
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
  final String? threadChildId;
  final ThreadType threadType;
  const ThreadPage({
    super.key,
    required this.title,
    required this.type,
    this.threadChildId,
    this.threadType = ThreadType.thread,
  });

  static String route = "/journal";
  static Route launchRoute({
    required String title,
    required String type,
    String? threadChildId,
    ThreadType threadType = ThreadType.thread,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ThreadPage(
        title: title,
        type: type,
        threadType: threadType,
        threadChildId: threadChildId,
      ),
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
    final currentThread = ref.watch(currentThreadProvider.call(
      title: title,
      type: type,
      // threadType: threadType,
      // threadChildId: threadChildId,
    ));
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
