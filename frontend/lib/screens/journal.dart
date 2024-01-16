import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import '../network.dart';
import 'package:built_value/json_object.dart';

part 'journal.g.dart';

Future<void> createBlock(String text) async {
  final blockApi = NetworkManager.instance.openApi.getBlocksApi();

  await blockApi.createBlockBlockBlocksPost(
      blockModel: BlockModel(content: text));
}

// a riverpod provider that stores the content of a single day's journal entry
// this entry can be accessed from anywhere in the app and also be sent to the
// backend.
//  - the backend will store the journal entry in the database

@riverpod
class JournalText extends _$JournalText {
  @override
  List<String> build() => [];

  void addString(String input) async {
    state = [input, ...state];
    await createBlock(input);
  }

  void updateStringAt(int index, String input) {
    state = [
      ...state.sublist(0, index),
      input,
      ...state.sublist(index + 1),
    ];
  }
}

class JournalScreen extends ConsumerWidget {
  JournalScreen({Key? key}) : super(key: key);

  var emojiParser = EmojiParser(init: true);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final containerWidth = 800.0;
    final today = DateTime.now();
    final journalText = ref.watch(journalTextProvider);
    final TextEditingController _controller = TextEditingController();
    final _scrollController = ScrollController();
    _scrollToBottom() {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    final blocks = journalText;
    // chat display widget
    final blockDisplay = Container(
        width: containerWidth,
        child: ListView.builder(
          reverse: true,
          controller: _scrollController,
          itemCount: blocks.length,
          itemBuilder: (context, index) {
            final block = blocks[index];
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
                emojiParser.emojify(block),
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

    final blockInput = Container(
      //alignment: Alignment.center,
      width: containerWidth,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
        ),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (!event.repeat) {
            if (event is RawKeyDownEvent) {
              if (event.isShiftPressed &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                // Submit the text
                ref
                    .read(journalTextProvider.notifier)
                    .addString(_controller.text);
                _controller.clear();
              }
              // Handle key down
            } else if (event is RawKeyUpEvent) {
              // Handle key up
              // just chill
            }
          }
        },
        child: TextField(
            controller: _controller,
            //keyboardType: TextInputType.multiline,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 188, 105, 240),
              border: OutlineInputBorder(),
              hintText: 'Write your journal here...Press SHIFT+Enter to save',
            )),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('${today.year}-${today.month}-${today.day}'),
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
