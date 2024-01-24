import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/blocks.dart';
import 'package:frontend/repo/thread.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../constants.dart';
part 'commandbox.g.dart';

enum Commands {
  plan('plan'),
  news('news'),
  report('report');

  const Commands(this.name);

  final String name;
}

final List<String> commandList = Commands.values.map((e) => e.name).toList();
final popupMenuEntryList = commandList.map((e) => PopupMenuItem<String>(
      value: e,
      child: Text(e),
    ));

@riverpod
class CommandMenuVisibility extends _$CommandMenuVisibility {
  @override
  bool build() => false;
  void on() => state = true;
  void off() => state = false;
}

Future<String?> _showPopupMenu(
    BuildContext context, List<String> elements) async {
  String? selectedElement = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(0, 100, 0, 0),
    items: elements.map((element) {
      return PopupMenuItem<String>(
        value: element,
        child: Text(element),
      );
    }).toList(),
  );

  return selectedElement;
}

void do_some_action(BuildContext context, String action) {
  print("doing $action");
}

Visibility buildCommandPopUp(BuildContext context, WidgetRef ref) {
  final box = SizedBox(
    height: 400.0,
    child: ListView.builder(
      itemCount: commandList.length,
      itemBuilder: (context, index) {
        final command = commandList[index];
        return PopupMenuItem<String>(
          onTap: () {
            do_some_action(context, command);
            ref.read(commandMenuVisibilityProvider.notifier).off();
          },
          value: command,
          child: Text(command),
        );
      },
    ),
  );
  final visible = ref.watch(commandMenuVisibilityProvider);
  print("visible: $visible");
  return Visibility(visible: visible, child: box);
}

class AlphanumericWord {
  final String _value;

  AlphanumericWord(String value)
      : assert(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)),
        _value = value;

  String get value => _value;
}

class CommandBox extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        //alignment: Alignment.center,
        width: containerWidth,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
          ),
        ),
        child: Column(children: [
          buildCommandPopUp(context, ref),
          RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (RawKeyEvent event) async {
              if (!event.repeat) {
                if (event is RawKeyDownEvent) {
                  if (event.isShiftPressed &&
                      event.logicalKey == LogicalKeyboardKey.enter) {
                    String blockText = _controller.text;
                    // Submit the text
                    //blockProvider is not really being watched. Need to see what
                    // to do about it when block is properly formed
                    // right now it is just a String object.

                    ref.read(blockProvider.notifier).setState(blockText);
                    ref.read(threadProvider.notifier).addString(blockText);
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
              ),
              onChanged: (text) async {
                if (text.isNotEmpty && text.startsWith('/')) {
                  if (!context.mounted) return;
                  // show the popup
                  ref.read(commandMenuVisibilityProvider.notifier).on();
                  // show a popup with the list of commands and allow the user to
                  // select one
                  // or delete the / and treat it as a normal text
                }
              },
            ),
          ),
        ]));
  }
}
