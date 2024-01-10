import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal.g.dart';

// a riverpod provider that stores the content of a single day's journal entry
// this entry can be accessed from anywhere in the app and also be sent to the
// backend.
//  - the backend will store the journal entry in the database

@riverpod
class JournalText extends _$JournalText {
  @override
  String build() => '';
  void update(String text) => state += "\n" + text;
  void clear() => state = '';
}

class JournalScreen extends ConsumerWidget {
  const JournalScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final journalText = ref.watch(journalTextProvider);
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text('${today.year}-${today.month}-${today.day}'),
        ),
        body: Column(
          children: [
            Container(
              //child: SingleChildScrollView(
              child: Text(journalText,
                  style: Theme.of(context).textTheme.bodySmall),
              // ),
            ),
            RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (RawKeyEvent event) {
                if (event.isMetaPressed &&
                    event.logicalKey == LogicalKeyboardKey.enter) {
                  // Submit the text
                  ref
                      .read(journalTextProvider.notifier)
                      .update(_controller.text);
                }
              },
              child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        'Write your journal here...Press CMD+Enter to save',
                  )),
            ),
          ],
        ));
  }
}
