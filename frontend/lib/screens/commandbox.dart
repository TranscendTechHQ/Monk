import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/thread.dart';
import 'package:frontend/repo/titles.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../constants.dart';
import '../repo/commandparser.dart';
part 'commandbox.g.dart';

final popupMenuEntryList = commandList.map((e) => PopupMenuItem<String>(
      value: e,
      child: Text(e),
    ));

@riverpod
class AutoCompleteVisibility extends _$AutoCompleteVisibility {
  @override
  bool build() => false;
  void setVisibility(bool visibility) {
    state = visibility;
  }

  bool get() => state;
}

class CommandTypeAhead extends ConsumerWidget {
  final TextEditingController _typeAheadController =
      TextEditingController(text: "/");
  final FocusNode _commandFocusNode = FocusNode();

  CommandTypeAhead({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parser = CommandParser();
    final titlesNotifier = ref.read(titlesProvider.notifier);
    final currentCommandNotifier = ref.read(currentCommandProvider.notifier);
    final commandHintTextNotifier = ref.read(commandHintTextProvider.notifier);

    return TypeAheadField<String>(
        focusNode: _commandFocusNode,
        hideOnEmpty: true,
        direction: VerticalDirection.up,
        controller: _typeAheadController,
        builder: (context, controller, focusNode) => TextField(
              controller: controller,
              onSubmitted: (value) {
                // if value is present in the commandList,
                //then set the current command to value
                // and set the visibility to false
                try {
                  parser.validateCommand(value, currentCommandNotifier,
                      titlesNotifier, commandHintTextNotifier);
                  // only if the command was successfully validated
                  ref
                      .read(autoCompleteVisibilityProvider.notifier)
                      .setVisibility(false);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                    duration: const Duration(seconds: 10),
                  ));
                  return;
                }
              },
              focusNode: focusNode,
              autofocus: true,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 74, 21, 107),
                border: InputBorder.none,
                hintText: 'press "/" for commands',
              ),
            ),
        suggestionsCallback: (pattern) async {
          List<String> suggestions = [];
          if (pattern.isEmpty) {
            //suggestions.add('');
            return suggestions;
          }
          List<String> parts = pattern.split(' ');
          if (parts.length == 1) {
            // we are displaying a list of commands now
            return parser.patternMatchingCommands(pattern);
          }
          if (parts.length == 2) {
            return parser.patternMatchingTitles(pattern, titlesNotifier);
          }
          return suggestions;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        onSelected: (suggestion) {
          if (suggestion.startsWith('/')) {
            // this is a command
            _typeAheadController.text = suggestion;
            currentCommandNotifier
                .setCommand(Commands.values[commandList.indexOf(suggestion)]);
          } else {
            // this is a title
            // set the current title
            String currentCommand = currentCommandNotifier.get().name;
            _typeAheadController.text = currentCommand + " #" + suggestion;
          }
          return;
        });
  }
}

class CommandBox extends ConsumerWidget {
  final TextEditingController _blockController = TextEditingController();
  final FocusNode _optionFocusNode = FocusNode();

  CommandBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadNotifier = ref.read(currentThreadProvider
        .call(title: 'journal', type: '/new-thread')
        .notifier);
    bool commandVisibility = ref.watch(autoCompleteVisibilityProvider);
    final commandHintText = ref.watch(commandHintTextProvider);
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

                //ref.read(currentThreadProvider.getProviderOverride(provider)).addString(blockText);
                threadNotifier.createBlock(blockText);
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
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Text(commandHintText),
              CommandTypeAhead(),
            ]),
          ),
        ]),
      ),
    );
  }
}
