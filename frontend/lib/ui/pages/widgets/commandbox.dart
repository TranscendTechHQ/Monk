import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/repo/commandparser.dart';
import 'package:frontend/repo/thread.dart';
import 'package:frontend/ui/pages/widgets/search.dart';
import 'package:frontend/ui/pages/thread_page.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
part 'commandbox.g.dart';

enum VisibilityEnum {
  thread,
  commandBox,
  searchBox,
}

@riverpod
class ScreenVisibility extends _$ScreenVisibility {
  @override
  VisibilityEnum build() => VisibilityEnum.thread;
  void setVisibility(VisibilityEnum visibility) {
    state = visibility;
  }

  VisibilityEnum get() => state;
}

void switchThread(WidgetRef ref, BuildContext context, String newThreadTitle,
    String newThreadType) {
  final screenVisibility = ref.read(screenVisibilityProvider.notifier);
  screenVisibility.setVisibility(VisibilityEnum.thread);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) {
        return ThreadPage(
          title: newThreadTitle,
          type: newThreadType,
        );
      },
    ),
  );
}

class CommandTypeAhead extends ConsumerWidget {
  final TextEditingController _typeAheadController =
      TextEditingController(text: "/");
  final FocusNode commandFocusNode;

  CommandTypeAhead({super.key, required this.commandFocusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commandList = ref.watch(fetchThreadTypesProvider);
    final parser = CommandParser(commandList.value ?? []);
    final threadList = ref.watch(fetchThreadsInfoProvider);
    final List<String> titlesList = threadList.value?.keys.toList() ?? [];

    final commandHintTextNotifier = ref.read(commandHintTextProvider.notifier);

    return TypeAheadField<String>(
        focusNode: commandFocusNode,
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
                  final newThread = parser.validateCommand(
                      value, titlesList, commandHintTextNotifier);
                  String newThreadType;
                  if (threadList.value!.containsKey(newThread["title"])) {
                    newThreadType = threadList.value![newThread["title"]]!;
                  } else {
                    newThreadType = newThread["type"]!;
                  }
                  switchThread(
                      ref, context, newThread["title"]!, newThreadType);
                  // only if the command was successfully validated
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                    duration: const Duration(seconds: 3),
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
            return parser.patternMatchingTitles(pattern, titlesList);
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
          } else {
            String firstHalf = _typeAheadController.text.split('#')[0];
            // this is a title
            // set the current title
            _typeAheadController.text = "$firstHalf#$suggestion";
          }
          return;
        });
  }
}

class CommandBox extends ConsumerWidget {
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _searchTextController = TextEditingController();
  final SearchController _searchController = SearchController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _commandFocusNode = FocusNode();
  final String title;
  final String type;

  CommandBox({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadNotifier =
        ref.read(currentThreadProvider.call(title: title, type: type).notifier);
    VisibilityEnum commandVisibility = ref.watch(screenVisibilityProvider);
    final commandHintText = ref.watch(commandHintTextProvider);

    final threadInput = TextField(
      autofocus: true,
      controller: _blockController,
      //keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 5,
      decoration: InputDecoration(
        filled: true,
        fillColor: context.colorScheme.tertiaryContainer.withOpacity(.3),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: context.colorScheme.tertiaryContainer,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.disabledColor)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: context.disabledColor,
        )),
        hintText:
            'Write your text block here. Press SHIFT+Enter to save. Press "/" for commands',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      ),
      onChanged: (text) async {
        if (text.isNotEmpty && text.startsWith('/')) {
          if (!context.mounted) return;
          // show the popup
          _blockController.clear();
          _commandFocusNode.requestFocus();
          ref
              .read(screenVisibilityProvider.notifier)
              .setVisibility(VisibilityEnum.commandBox);
          // show a popup with the list of commands and allow the user to
          // select one
          // or delete the / and treat it as a normal text
        }
      },
    );
    return SizedBox(
      width: containerWidth,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) async {
          if (!event.repeat) {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                ref
                    .read(screenVisibilityProvider.notifier)
                    .setVisibility(VisibilityEnum.thread);
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
              visible: (commandVisibility == VisibilityEnum.thread),
              child: CallbackShortcuts(bindings: {
                const SingleActivator(LogicalKeyboardKey.keyS, meta: true): () {
                  ref
                      .read(screenVisibilityProvider.notifier)
                      .setVisibility(VisibilityEnum.searchBox);
                  _searchFocusNode.requestFocus();
                },
                const SingleActivator(LogicalKeyboardKey.enter, shift: true):
                    () {
                  String blockText = _blockController.text;
                  // Submit the text

                  threadNotifier.createBlock(blockText);
                  _blockController.clear();
                },
              }, child: threadInput)),
          Visibility(
            visible: (commandVisibility == VisibilityEnum.commandBox),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Text(commandHintText),
              CommandTypeAhead(
                commandFocusNode: _commandFocusNode,
              ),
            ]),
          ),
          Visibility(
              visible: (commandVisibility == VisibilityEnum.searchBox),
              child: SearchModal(focusNode: _searchFocusNode)),
        ]),
      ),
    );
  }
}
