import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
part 'journal.g.dart';

// a riverpod provider that stores the content of a single day's journal entry
// this entry can be accessed from anywhere in the app and also be sent to the
// backend.
//  - the backend will store the journal entry in the database

@riverpod
class JournalText extends _$JournalText {
  @override
  List<String> build() => [];

  void addString(String input) {
    state = [input, ...state];
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
    final today = DateTime.now();
    final journalText = ref.watch(journalTextProvider);
    final TextEditingController _controller = TextEditingController();
    final _scrollController = ScrollController();
    _scrollToBottom() {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }

    final blocks = journalText;
    // chat display widget
    final blockDisplay = ListView.builder(
      reverse: true,
      controller: _scrollController,
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        final block = blocks[index];
        return Container(
          width: 50,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).expansionTileTheme.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          //color: Color.fromARGB(255, 47, 46, 46)),
          padding: EdgeInsets.all(16),
          child: Text(
            emojiParser.emojify(block),
            softWrap: true,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      },
    );

    final blockInput = Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.scrim,
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
              border: OutlineInputBorder(),
              hintText: 'Write your journal here...Press SHIFT+Enter to save',
            )),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('${today.year}-${today.month}-${today.day}'),
        ),
        body: Column(
          children: [
            Expanded(
              child: blockDisplay,
            ),
            blockInput,
          ],
        ));
  }
}
