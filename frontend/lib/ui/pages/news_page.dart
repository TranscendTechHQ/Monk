import 'package:frontend/ui/pages/thread_page.dart';
import 'package:frontend/ui/pages/widgets/commandbox.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/repo/thread.dart';

import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:openapi/openapi.dart';

class NewsPage extends ConsumerWidget {
  final String title;
  final String type;
  const NewsPage({super.key, required this.title, required this.type});

  static String route = "/news";

  static Route launchRoute() {
    return MaterialPageRoute<void>(
        builder: (_) => const NewsPage(title: "News", type: "/new-thread"));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // _searchFocusNode.requestFocus();

    final currentThread =
        ref.watch(currentThreadProvider.call(title: title, type: type));
    final blockInput = CommandBox(
      title: title,
      type: type,
      allowedInputTypes: const [
        InputBoxType.commandBox,
        InputBoxType.searchBox,
        // InputBoxType.thread,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${type.split('-')[1]} -: $title',
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: currentThread.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ChatListView(currentThread: currentThread),
            ),
            blockInput,
            const Padding(padding: EdgeInsets.all(8))
          ],
        ),
      ),
    );
  }
}

class ChatListView extends ConsumerWidget {
  ChatListView({super.key, required this.currentThread});
  final AsyncValue<ThreadModel> currentThread;

  final scrollController = ScrollController();

  final emojiParser = EmojiParser(init: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadListAsync = ref.watch(fetchThreadsInfoProvider);
    // final isLoading = threadListAsync.when(
    //   data: (thread) => false,
    //   loading: () => true,
    //   error: (error, stack) => false,
    // );
    // final List<String> titlesList = threadListAsync.value?.keys.toList() ?? [];
    return threadListAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (thread) => SizedBox(
        width: containerWidth,
        child: ListView.builder(
          reverse: true,
          controller: scrollController,
          itemCount: thread.length,
          padding: const EdgeInsets.only(bottom: 30),
          itemBuilder: (context, index) {
            return NewsCard(thread: {
              thread.keys.elementAt(index): thread.values.elementAt(index),
            });
          },
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.thread});

  final Map<String, String> thread;

  @override
  Widget build(BuildContext context) {
    final type = thread.values.first.trimRight();
    final title = thread.keys.first.trimRight();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
              context, ThreadPage.launchRoute(title: title, type: type));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: .3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoEmoji',
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SelectableText(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'NotoEmoji',
                  fontWeight: FontWeight.w400,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThreadCard extends StatelessWidget {
  const ThreadCard({super.key, required this.block, required this.emojiParser});
  final BlockModel block;
  final EmojiParser emojiParser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: .3,
        ),
      ),
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
            emojiParser.emojify(block.content.toString() ?? '').trimRight(),
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'NotoEmoji',
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
