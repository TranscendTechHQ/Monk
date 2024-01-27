import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/blocks.dart';
import 'package:frontend/repo/thread.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../constants.dart';
part 'commandbox.g.dart';

enum Commands {
  journal('/new-journal'),
  thread('/new-thread'),
  plan('/new-plan'),
  news('/news'),
  report('/new-report'),
  project('/new-project'),
  task('/new-task'),
  note('/new-note'),
  idea('/new-idea'),
  event('/new-event'),
  blocker('/new-blocker'),
  think('/new-thought'),
  strategy('/new-strategy'),
  private('/new-private'),
  go('/go'),
  ;

  const Commands(this.name);

  final String name;
}

@riverpod
class AutoCompleteVisibility extends _$AutoCompleteVisibility {
  @override
  bool build() => false;
  void setVisibility(bool visibility) {
    state = visibility;
  }

  bool get() => state;
}

@riverpod
class CurrentCommand extends _$CurrentCommand {
  @override
  Commands build() => Commands.journal;
  void setCommand(Commands command) {
    state = command;
  }

  Commands get() => state;
}

final List<String> commandList = Commands.values.map((e) => e.name).toList();
final popupMenuEntryList = commandList.map((e) => PopupMenuItem<String>(
      value: e,
      child: Text(e),
    ));

class CommandTypeAhead extends ConsumerWidget {
  final TextEditingController _typeAheadController =
      TextEditingController(text: "/");
  void onCommandSelected(String command, WidgetRef ref, BuildContext context) {
    //print("Command is " + command);
    _typeAheadController.text = command;

    ref
        .read(currentCommandProvider.notifier)
        .setCommand(Commands.values[commandList.indexOf(command)]);
    FocusScope.of(context).requestFocus(FocusNode());
    // ref.read(autoCompleteVisibilityProvider.notifier).setVisibility(false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ...

    return TypeAheadField<String>(
        hideOnEmpty: true,
        direction: VerticalDirection.up,
        controller: _typeAheadController,
        builder: (context, controller, focusNode) => TextField(
              controller: controller,
              onSubmitted: (value) {
                // if value is present in the commandList,
                //then set the current command to value
                // and set the visibility to false

                if (commandList.contains(value)) {
                  onCommandSelected(value, ref, context);
                }
              },
              focusNode: focusNode,
              autofocus: true,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 74, 21, 107),
                border: OutlineInputBorder(),
                hintText: 'press "/" for commands',
              ),
            ),
        suggestionsCallback: (pattern) async {
          return commandList.where((String option) {
            return option.contains(pattern.toLowerCase());
          }).toList();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        onSelected: (suggestion) {
          onCommandSelected(suggestion, ref, context);
        });
  }
}

class CommandBox extends ConsumerWidget {
  final TextEditingController _blockController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool commandVisibility = ref.watch(autoCompleteVisibilityProvider);
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
                  event.logicalKey == LogicalKeyboardKey.enter &&
                  !commandVisibility) {
                String blockText = _blockController.text;
                // Submit the text
                //blockProvider is not really being watched. Need to see what
                // to do about it when block is properly formed
                // right now it is just a String object.

                ref.read(blockProvider.notifier).setState(blockText);
                ref.read(threadProvider.notifier).addString(blockText);
                _blockController.clear();
              }
              if ((event.logicalKey == LogicalKeyboardKey.escape) &&
                  commandVisibility) {
                ref
                    .read(autoCompleteVisibilityProvider.notifier)
                    .setVisibility(false);
              }
              // Handle key down
            } else if (event is RawKeyUpEvent) {
              // Handle key up
              // just chill
            }
          }
        },
        child: Stack(children: [
          Visibility(
            visible: !commandVisibility,
            child: TextField(
              autofocus: true,
              controller: _blockController,
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
                  _blockController.clear();

                  ref
                      .read(autoCompleteVisibilityProvider.notifier)
                      .setVisibility(true);
                  // show a popup with the list of commands and allow the user to
                  // select one
                  // or delete the / and treat it as a normal text
                }
              },
            ),
          ),
          Visibility(
            visible: commandVisibility,
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(child: CommandTypeAhead()),
              Expanded(
                  child: TextFormField(
                focusNode: FocusNode(),
                autofocus: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 52, 29, 66),
                  border: OutlineInputBorder(),
                  hintText:
                      'Write your journal here...Press SHIFT+Enter to save',
                ),
                onFieldSubmitted: (value) {
                  // if value is present in the commandList,
                  //then set the current command to value
                  // and set the visibility to false

                  print("Value is " + value);
                },
              ))
            ]),
          ),
        ]),
      ),
    );
  }
}
