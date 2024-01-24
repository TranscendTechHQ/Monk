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
final popupMenuEntryList = commandList.map((e) => PopupMenuItem<String>(
      value: e,
      child: Text(e),
    ));

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
              if (!context.mounted) return;
              showModalBottomSheet(
                context: context,
                builder: (context) => PopupMenuButton<String>(
                  child: Text('Select an option'),
                  itemBuilder: (context) => commandList
                      .map((item) => PopupMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onSelected: (value) => print('Selected: $value'),
                ),
              );
              // show a popup with the list of commands and allow the user to
              // select one
              // or delete the / and treat it as a normal text
              /*
              final int _cursorPosition = _controller.selection.baseOffset;
              final RenderBox box = context.findRenderObject() as RenderBox;
              final Offset localPosition = box.globalToLocal(Offset.zero);
              final RelativeRect position = RelativeRect.fromSize(
                Rect.fromLTWH(localPosition.dx + _cursorPosition * 10,
                    localPosition.dy + 20, 100, 100),
                box.size,
              );

              final RelativeRect position2 = RelativeRect.fromSize(
                  Rect.fromLTWH(400, 600, 200, 400), Size(600, 1000));

              final RelativeRect position3 =
                  RelativeRect.fromLTRB(400, 600, 100, 100);
              String? command = await showMenu<String>(
                  useRootNavigator: true,
                  context: context,
                  position: position3,
                  items: popupMenuEntryList.toList());
              if (!context.mounted) return;
              if (command != null) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: EdgeInsets.all(20),
                    child: Text('You selected: $command'),
                  ),
                );
              }
              */

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
