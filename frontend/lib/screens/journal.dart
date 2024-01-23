import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/repo/blocks.dart';
import 'package:frontend/repo/thread.dart';
import 'package:frontend/screens/commandbox.dart';

import 'package:flutter_emoji/flutter_emoji.dart';

class JournalScreen extends ConsumerWidget {
  final emojiParser = EmojiParser(init: true);
  JournalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final _scrollController = ScrollController();
    _scrollToBottom() {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    //final blockText = ref.watch(blockProvider);
    final blocks = ref.watch(threadProvider);

    // chat display widget
    final blockDisplay = Container(
        width: containerWidth,
        child: ListView.builder(
          reverse: true,
          controller: _scrollController,
          itemCount: blocks.value?.length ?? 0,
          itemBuilder: (context, index) {
            final block = blocks.value?[index];
            return Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
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

    final blockInput = CommandBox();

    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Journal (YYYY-MM-DD) ${today.year}-${today.month}-${today.day}'),
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
                Padding(padding: EdgeInsets.all(30))
              ],
            )));
  }
}
