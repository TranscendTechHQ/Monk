import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/repo/thread.dart';
import 'package:frontend/screens/commandbox.dart';

import 'package:flutter_emoji/flutter_emoji.dart';

class ThreadScreen extends ConsumerWidget {
  final emojiParser = EmojiParser(init: true);
  final String title;
  final String type;
  ThreadScreen({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final scrollController = ScrollController();
    scrollToBottom() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }

    final currentThread =
        ref.watch(currentThreadProvider.call(title: title, type: type));

    final blocks = currentThread.value?.content?.reversed
        .toList()
        .map((e) => e.content)
        .toList();

    // chat display widget
    final blockDisplay = SizedBox(
        width: containerWidth,
        child: ListView.builder(
          reverse: true,
          controller: scrollController,
          itemCount: blocks?.length ?? 0,
          itemBuilder: (context, index) {
            final block = blocks?[index];
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: SelectableText(
                emojiParser.emojify(block?.toString() ?? ''),
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'NotoEmoji',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          },
        ));

    final blockInput = CommandBox(title: title, type: type);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ThreadType:$type Title:$title',
            style: TextStyle(
                fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        body: Align(
            alignment: Alignment.center,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: blockDisplay,
                ),
                blockInput,
                const Padding(padding: EdgeInsets.all(30))
              ],
            )));
  }
}
