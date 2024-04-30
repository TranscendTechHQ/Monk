import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/helper/utils.dart';
import 'package:frontend/repo/thread.dart';
import 'package:frontend/ui/pages/thread/page/thread_detail_page.dart';
import 'package:frontend/ui/pages/thread/widget/thread_card.dart';
import 'package:frontend/ui/pages/widgets/commandbox.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
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
    final provider = currentThreadProvider.call(
      title: title,
      type: type,
    );
    final currentThread = ref.watch(provider);
    final threadTitle = currentThread.maybeWhen(
      data: (state) => state?.title ?? title,
      orElse: () => title,
    );
    final blockInput = CommandBox(title: title, type: type);

    ref.listen(provider, (prev, next) {
      if (next is AsyncError) {
        final data = next.value;
        showMessage(context, data.toString().replaceFirst('Exception: ', ''));
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$formatType -: $threadTitle',
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(width: 16),
            IconButton(
              tooltip: 'Edit title',
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final controller = TextEditingController(text: title);
                      return AlertDialog(
                        // context: context,
                        title: const Text('Edit title'),
                        content: TextField(
                          controller: controller,
                          maxLength: 60,
                          decoration: const InputDecoration(
                            hintText: 'Enter title',
                          ),
                        ),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await ref
                                  .read(provider.notifier)
                                  .updateThreadTitle(controller.text);
                              ref.refresh(currentThreadProvider.call(
                                title: title,
                                type: type,
                              ));
                              Navigator.of(context).pop();
                            },
                            child: const Text('Save'),
                          )
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.edit, size: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              ref.refresh(currentThreadProvider.call(
                title: title,
                type: type,
              ));
            },
          ),
        ],
      ),
      body: PageScaffold(
        body: Align(
          alignment: Alignment.center,
          child: currentThread.when(
            data: (state) => Column(
              children: [
                ChatListView(
                  currentThread: currentThread,
                  title: title,
                  type: type,
                  threadType: threadType,
                ).extended,
                blockInput,
              ],
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
    required this.threadType,
  });
  final AsyncValue<FullThreadInfo?> currentThread;
  final String type;
  final String title;
  final ThreadType threadType;

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
      child: type == '/new-task'
          ? ReorderableListView(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 30),
              onReorder: (int oldIndex, int newIndex) {
                ref
                    .read(currentThreadProvider
                        .call(
                          title: title,
                          type: type,
                        )
                        .notifier)
                    .reorderBlocks(oldIndex, newIndex);
              },
              children: [
                ...blocks?.reversed.map((block) {
                      return ThreadCard(
                        key: ValueKey(block.id),
                        block: block,
                        emojiParser: emojiParser,
                        title: title,
                        type: type,
                        parentThreadId: parentThreadId,
                        threadType: threadType,
                      );
                    }).toList() ??
                    [],
              ],
            )
          : ListView.builder(
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
                  threadType: threadType,
                );
              },
            ),
    );
  }
}
