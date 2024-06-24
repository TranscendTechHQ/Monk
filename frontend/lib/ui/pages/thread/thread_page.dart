import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/helper/utils.dart';

import 'package:frontend/ui/pages/news/provider/news_provider.dart';
import 'package:frontend/ui/pages/news/widget/search/search_model.dart';
import 'package:frontend/ui/pages/thread/provider/thread.dart';
import 'package:frontend/ui/pages/thread/widget/thread_card.dart';
import 'package:frontend/ui/pages/widgets/commandbox.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
import 'package:frontend/ui/widgets/kit/alert.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';
import 'package:frontend/ui/widgets/title_action_widget.dart';

enum ThreadType { thread, reply }

class ThreadPage extends ConsumerWidget {
  final String topic;
  final String type;
  final String? threadChildId;
  final ThreadType threadType;
  const ThreadPage({
    super.key,
    required this.topic,
    required this.type,
    this.threadChildId,
    this.threadType = ThreadType.thread,
  });

  static String route = "/journal";
  static Route launchRoute({
    required String topic,
    required String type,
    String? threadChildId,
    ThreadType threadType = ThreadType.thread,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ThreadPage(
        topic: topic,
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

  Future<void> confirmDelete(
      BuildContext context, CurrentThread provider, WidgetRef ref) async {
    Alert.confirm(
      context,
      barrierDismissible: true,
      topic: "Delete",
      onConfirm: () async {
        final isDeleted = await provider.deleteThreadAsync(context);
        ref.invalidate(newsFeedProvider);
        ref.read(newsFeedProvider);
        if (isDeleted) {
          Navigator.pop(context);
        }
      },
      message: 'Are you sure you want to delete this thread forever?',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = currentThreadProvider.call(
      topic: topic,
      type: type,
    );
    final currentThread = ref.watch(provider);
    final currentThreadNotifier = ref.read(provider.notifier);
    final threadTitle = currentThread.maybeWhen(
      data: (state) => state.thread?.topic ?? topic,
      orElse: () => topic,
    );
    final blockInput = CommandBox(topic: topic, type: type);

    final isThreadCreator = currentThread.maybeWhen(
      data: (state) => state.thread?.creator == state.thread?.creator.id,
      orElse: () => false,
    );

    ref.listen(provider, (prev, next) {
      if (next is AsyncError) {
        final data = next.value;
        showMessage(context, data.toString().replaceFirst('Exception: ', ''));
      }
    });

    final threadList = ref.watch(fetchThreadsInfoProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$formatType: $threadTitle',
              style: TextStyle(
                fontSize: 20,
                color: context.customColors.sourceMonkBlue,
              ),
            ),
            IconButton(
              // tooltip: 'Edit topic',
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final controller = TextEditingController(text: topic);
                      return AlertDialog(
                        // context: context,
                        title: const Text('Edit topic'),
                        content: TextField(
                          controller: controller,
                          maxLength: 60,
                          decoration: const InputDecoration(
                            hintText: 'Enter topic',
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
                              loader.showLoader(context,
                                  message: 'Updating topic');
                              await ref
                                  .read(provider.notifier)
                                  .updateThreadTitle(controller.text);
                              ref.refresh(currentThreadProvider.call(
                                topic: controller.text,
                                type: type,
                              ));
                              loader.hideLoader();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Save'),
                          )
                        ],
                      );
                    });
              },
              icon: SvgPicture.asset(
                'assets/svg/edit.svg',
                height: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              ref.invalidate(currentThreadProvider);
              ref.read(provider);
            },
          ),
          // if (!isThreadCreator)
          SizedBox(
            width: 25,
            child: TileActionWidget(
              onDelete: () async =>
                  confirmDelete(context, currentThreadNotifier, ref),
            ),
          ),
        ],
      ),
      body: PageScaffold(
        body: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  OutlineIconButton(
                    svgPath: 'search.svg',
                    label: 'Search',
                    onPressed: () {
                      SearchModal2.show(context, threadsMap: threadList.value!);
                    },
                  ),
                ],
              ),
              currentThread.when(
                data: (state) => Column(
                  children: [
                    ChatListView(
                      currentThread: currentThread,
                      topic: topic,
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
    required this.topic,
    required this.type,
    required this.threadType,
  });
  final AsyncValue<CurrentTreadState?> currentThread;
  final String type;
  final String topic;
  final ThreadType threadType;

  final scrollController = ScrollController();
  scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  final emojiParser = EmojiParser(init: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = currentThread.value?.blocks;
    final mainThreadId = currentThread.value?.thread?.id;
    final defaultBlock = currentThread.value?.thread?.defaultBlock;
    return SizedBox(
      width: containerWidth,
      child: type == 'todo'
          ? Column(
              children: [
                ReorderableListView(
                  reverse: true,
                  footer: defaultBlock != null && defaultBlock.id != null
                      ? ThreadCard(
                          key: ValueKey(defaultBlock.id),
                          block: defaultBlock,
                          emojiParser: emojiParser,
                          topic: topic,
                          type: type,
                          mainThreadId: mainThreadId,
                          threadType: threadType,
                        )
                      : null,
                  padding: const EdgeInsets.only(bottom: 30),
                  onReorder: (int oldIndex, int newIndex) async {
                    loader.showLoader(context, message: 'Saving..');
                    await ref
                        .read(currentThreadProvider
                            .call(
                              topic: topic,
                              type: type,
                            )
                            .notifier)
                        .reorderBlocks(oldIndex, newIndex);

                    loader.hideLoader();
                  },
                  children: [
                    ...blocks?.reversed.map((block) {
                          return ThreadCard(
                            // key: ValueKey(block.id),
                            key: UniqueKey(),
                            block: block,
                            emojiParser: emojiParser,
                            topic: topic,
                            type: type,
                            mainThreadId: mainThreadId,
                            threadType: threadType,
                          );
                        }).toList() ??
                        [],
                  ],
                ).extended,
              ],
            )
          : Column(
              children: [
                ListView(
                  reverse: true,
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 30),
                  children: [
                    ...blocks?.reversed.map((block) {
                          return ThreadCard(
                            key: ValueKey(block.id),
                            block: block,
                            emojiParser: emojiParser,
                            topic: topic,
                            type: type,
                            mainThreadId: mainThreadId,
                            threadType: threadType,
                          );
                        }).toList() ??
                        [
                          const SizedBox(),
                        ],
                    if (defaultBlock != null)
                      ThreadCard(
                        key: ValueKey(defaultBlock.id),
                        block: defaultBlock,
                        emojiParser: emojiParser,
                        topic: topic,
                        type: type,
                        mainThreadId: mainThreadId,
                        threadType: threadType,
                      ),
                  ],
                ).extended,
              ],
            ),
    );
  }
}
