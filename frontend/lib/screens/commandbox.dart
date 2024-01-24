import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/blocks.dart';
import 'package:frontend/repo/thread.dart';

import '../constants.dart';

enum Commands {
  plan('plan'),
  news('news'),
  report('report');

  const Commands(this.name);

  final String name;
}

final List<String> commandList = Commands.values.map((e) => e.name).toList();

class AlphanumericWord {
  final String _value;

  AlphanumericWord(String value)
      : assert(RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)),
        _value = value;

  String get value => _value;
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
      child: RawKeyboardListener(
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
              // show a popup with the list of commands and allow the user to
              // select one
              // or delete the / and treat it as a normal text
              String? command = await _showPopupMenu(context, commandList);
              if (command != null) {
                print(command);
              }

              // Handle command logic here
              /* String command = text.substring(1);
              switch (command) {
                case 'plan':
                  // Handle /plan command
                  break;
                case 'news':
                  // Handle /news command
                  break;
                case 'report':
                  // Handle /report command
                  break;
                default:
                  // Handle unknown command
                  break;
              }*/
            }
          },
        ),
      ),
    );
  }
}
