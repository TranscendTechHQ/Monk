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
  journal('journal'),
  thread('thread'),
  plan('plan'),
  news('news'),
  report('report'),
  project('project'),
  task('task'),
  note('note'),
  idea('idea'),
  event('event'),
  blocker('blocker'),
  think('think'),
  strategy('strategy'),
  private('private'),
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

void _showMenu(BuildContext context, List<String> items, WidgetRef ref) {
  final renderBox = context.findRenderObject() as RenderBox;
  final top = renderBox.localToGlobal(Offset.zero).dy; // Adjust for menu height
  final left = MediaQuery.of(context).size.width / 4; // Center horizontally

  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      left,
      top,
      400,
      200,
    ),
    items: items
        .map((item) => PopupMenuItem(
              value: item,
              child: Text(item),
            ))
        .toList(),
  ).then((value) {
    // Handle selected item
    // go to the command screen to get additional command parameters from the user
    // using the textformfield widget. Then create a new thread and corresponding screen
    // The parameter for most commands right now is just a 21 character alphanumeric string
    // word that is used to identify the threadname. The threadname can be used
    // to retrieve the thread from the database later. The threadname is also used
    // to create a new screen for the thread.
    final prevCommand = ref.read(currentCommandProvider);
    ref.read(currentCommandProvider.notifier).setCommand(Commands.values
        .firstWhere((element) => element.name == value,
            orElse: () => prevCommand));
    Navigator.pushReplacementNamed(
      context,
      "/commandparam",
    );
  });
}

class AutoCompleteCommand extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Autocomplete<String>(
      optionsViewOpenDirection: OptionsViewOpenDirection.up,
      //optionsMaxHeight: 200.0,
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: containerWidth,
              child: Material(
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  height: 52.0 * options.length,
                  width: containerWidth,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ));
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return commandList.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
        ref.read(autoCompleteVisibilityProvider.notifier).setVisibility(false);
      },
    );
  }
}

class CommandBox extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool visibility = ref.watch(autoCompleteVisibilityProvider);
    return Container(
        //alignment: Alignment.center,
        width: containerWidth,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
          ),
        ),
        child: Column(children: [
          //buildCommandPopUp(context, ref),
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
            child: Stack(children: [
              Visibility(
                visible: !visibility,
                child: TextField(
                  controller: _controller,
                  //keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 188, 105, 240),
                    border: OutlineInputBorder(),
                    hintText:
                        'Write your journal here...Press SHIFT+Enter to save',
                  ),
                  onChanged: (text) async {
                    if (text.isNotEmpty && text.startsWith('/')) {
                      if (!context.mounted) return;
                      // show the popup
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
                visible: visibility,
                child: AutoCompleteCommand(),
              ),
            ]),
          ),
        ]));
  }
}
