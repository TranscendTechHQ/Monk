import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/repo/thread.dart';
import 'package:frontend/screens/commandbox.dart';

import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:openapi/openapi.dart';

class ThreadScreen extends ConsumerWidget {
  final String title;
  final String type;
  const ThreadScreen({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThread =
        ref.watch(currentThreadProvider.call(title: title, type: type));
    final blockInput = CommandBox(title: title, type: type);
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
            // const Padding(padding: EdgeInsets.all(16))
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
  scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  final emojiParser = EmojiParser(init: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = currentThread.value?.content?.reversed.toList();
    return SizedBox(
      width: containerWidth,
      child: ListView.builder(
        reverse: true,
        controller: scrollController,
        itemCount: blocks?.length ?? 0,
        padding: const EdgeInsets.only(bottom: 30),
        itemBuilder: (context, index) {
          final block = blocks?[index];
          return ThreadCard(block: block!, emojiParser: emojiParser);
        },
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
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            emojiParser.emojify(block.content.toString() ?? '').trimRight(),
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'NotoEmoji',
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (block.createdAt != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(block.createdAt!.toLocal()),
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.6),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
