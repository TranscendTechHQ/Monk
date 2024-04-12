import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/main.dart';
import 'package:frontend/repo/commandparser.dart';
import 'package:frontend/repo/thread.dart';
import 'package:frontend/ui/pages/news_page.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/pages/widgets/search.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'commandbox.g.dart';

enum InputBoxType {
  thread,
  commandBox,
  searchBox,
}

@riverpod
class ScreenVisibility extends _$ScreenVisibility {
  @override
  InputBoxType build({InputBoxType visibility = InputBoxType.thread}) =>
      visibility;
  void setVisibility(InputBoxType visibility) {
    state = visibility;
  }

  InputBoxType get() => state;
}

void switchThread(WidgetRef ref, BuildContext context, String newThreadTitle,
    String newThreadType) {
  final screenVisibility = ref.read(screenVisibilityProvider().notifier);
  screenVisibility.setVisibility(InputBoxType.thread);
  // logger.v('Switching to thread $newThreadTitle of type $newThreadType');
  Navigator.pushReplacement(
    context,
    ThreadPage.launchRoute(title: newThreadTitle, type: newThreadType),
  );
}

class CommandBox extends ConsumerWidget {
  final _blockController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _commandFocusNode = FocusNode();
  final _blockFocusNode = FocusNode();
  final String title;
  final String type;
  final List<InputBoxType> allowedInputTypes;

  CommandBox({
    super.key,
    required this.title,
    required this.type,
    this.allowedInputTypes = const [
      InputBoxType.thread,
      InputBoxType.searchBox,
      InputBoxType.commandBox
    ],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadNotifier =
        ref.read(currentThreadProvider.call(title: title, type: type).notifier);

    final screenVisibilityProviderVal =
        screenVisibilityProvider(visibility: allowedInputTypes.first);
    InputBoxType commandVisibility = ref.watch(screenVisibilityProviderVal);

    final threadInput = TextField(
      autofocus: true,
      controller: _blockController,
      minLines: 2,
      maxLines: 5,
      focusNode: _blockFocusNode,
      decoration: InputDecoration(
          hintText:
              'Write your text block here. Press Meta+Enter to save. Press "/" for commands',
          hintStyle: context.textTheme.bodyMedium),
      onChanged: (text) async {
        if (text.isNotEmpty && text.startsWith('/')) {
          if (!context.mounted) return;
          // show the popup
          _blockController.clear();
          _commandFocusNode.requestFocus();
          ref
              .read(screenVisibilityProviderVal.notifier)
              .setVisibility(InputBoxType.commandBox);
          // show a popup with the list of commands and allow the user to
          // select one
          // or delete the / and treat it as a normal text
        }
      },
    );

    Widget callbackShortcutWrapper({required Widget child}) {
      Map<ShortcutActivator, VoidCallback> bindings = {
        if (allowedInputTypes.contains(InputBoxType.commandBox))
          const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () {
            ref
                .read(screenVisibilityProviderVal.notifier)
                .setVisibility(InputBoxType.searchBox);
            _searchFocusNode.requestFocus();
          },
        if (allowedInputTypes.contains(InputBoxType.thread))
          const SingleActivator(LogicalKeyboardKey.enter, meta: true): () {
            String blockText = _blockController.text;
            threadNotifier.createBlock(blockText, customTitle: title);
            _blockController.clear();
          },
      };

      return CallbackShortcuts(
        bindings: bindings,
        child: child,
      );
    }

    return SizedBox(
      width: containerWidth,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (KeyEvent event) async {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                ref
                    .read(screenVisibilityProviderVal.notifier)
                    .setVisibility(allowedInputTypes.first);
                if (allowedInputTypes.first == InputBoxType.thread) {
                  _blockFocusNode.requestFocus();
                }
              }
              // Handle key down
            } else if (event is KeyUpEvent) {
              // Handle key up
              // just chill
            }
          },
          child: callbackShortcutWrapper(
            child: Stack(children: [
              Visibility(
                visible: (commandVisibility == InputBoxType.thread),
                child: threadInput,
                //  CallbackShortcuts(
                //   bindings: {
                //     const SingleActivator(LogicalKeyboardKey.keyK, meta: true):
                //         () {
                //       ref
                //           .read(screenVisibilityProvider().notifier)
                //           .setVisibility(InputBoxType.searchBox);
                //       _searchFocusNode.requestFocus();
                //     },
                //     const SingleActivator(LogicalKeyboardKey.enter, shift: true):
                //         () {
                //       String blockText = _blockController.text;
                //       // Submit the text

                //       threadNotifier.createBlock(blockText);
                //       _blockController.clear();
                //     },
                //   },
                //   child: threadInput,
                // ),
              ),
              // COMMAND BOX
              Visibility(
                visible: (commandVisibility == InputBoxType.commandBox),
                maintainState: true,
                child: CommandTypeAhead(commandFocusNode: _commandFocusNode),
              ),
              // SEARCH BOX
              Visibility(
                visible: (commandVisibility == InputBoxType.searchBox),
                child: SearchModal(focusNode: _searchFocusNode),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class CommandTypeAhead extends ConsumerWidget {
  final _typeAheadController = TextEditingController();
  final FocusNode commandFocusNode;

  CommandTypeAhead({super.key, required this.commandFocusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commandList = ref.watch(fetchThreadTypesProvider);
    final parser = CommandParser(commandList.value ?? []);
    final threadList = ref.watch(fetchThreadsInfoProvider);
    final List<String> titlesList = threadList.value?.keys.toList() ?? [];

    final commandHintTextNotifier = ref.read(commandHintTextProvider.notifier);
    // final mainCommandText = ref.watch(mainCommandTextProvider);
    // final mainCommandTextNotifier = ref.read(mainCommandTextProvider.notifier);

    return Column(
      children: [
        // SearchField(
        //   controller: _typeAheadController,

        //   hint: 'press "/" for commands',
        //   itemHeight: 50,
        //   scrollbarDecoration: ScrollbarDecoration(),
        //   suggestionStyle: const TextStyle(fontSize: 24, color: Colors.white),
        //   suggestions: titlesList
        //       .map((e) => SearchFieldListItem<String>(e, child: Text(e)))
        //       .toList(),
        //   // offset: const Offset(0, -250),
        //   focusNode: commandFocusNode,
        //   suggestionState: Suggestion.expand,
        //   suggestionDirection: SuggestionDirection.up,
        //   onSearchTextChanged: (pattern) {
        //     if (pattern.isEmpty) {
        //       //suggestions.add('');
        //       // return suggestions;
        //       return titlesList
        //           .map((e) => SearchFieldListItem<String>(e, child: Text(e)))
        //           .toList();
        //     }
        //     List<String> parts = pattern.split(' ');
        //     if (parts.length == 1) {
        //       // we are displaying a list of commands now
        //       ref.read(mainCommandTextProvider.notifier).set('$pattern ');
        //       return parser
        //           .patternMatchingCommands(pattern)
        //           .map((e) => SearchFieldListItem<String>(e, child: Text(e)))
        //           .toList();
        //     }
        //     if (parts.length == 2) {
        //       return parser
        //           .patternMatchingTitles(pattern, titlesList)
        //           .map((e) => SearchFieldListItem<String>(e, child: Text(e)))
        //           .toList();
        //     }
        //     return titlesList
        //         .map((e) => SearchFieldListItem<String>(e, child: Text(e)))
        //         .toList();
        //   },

        //   onSuggestionTap: (SearchFieldListItem<String> x) {
        //     commandFocusNode.unfocus();
        //     final suggestion = x.searchKey;
        //     ref.watch(mainCommandTextProvider);
        //     String firstHalf = ref.read(mainCommandTextProvider);

        //     print('-------------------- START ---------------- ');
        //     print(
        //         'searchKey [$suggestion], main command:[$firstHalf], text:[${_typeAheadController.text}]');

        //     if (suggestion.startsWith('/')) {
        //       // this suggestion contains a command
        //       if (suggestion.contains(' ')) {
        //         final command = suggestion.split(' ')[0];
        //         final title = suggestion.split(' ')[1];
        //         _typeAheadController.text = '$suggestion ';
        //         ref.read(mainCommandTextProvider.notifier).set('$command ');
        //         print('command:[ $command], title:[$title');
        //         return;
        //       }
        //       // this is a command
        //       _typeAheadController.text = '$suggestion ';
        //       ref.read(mainCommandTextProvider.notifier).set('$suggestion ');

        //       print('command $suggestion');
        //     } else {
        //       //  _typeAheadController.text.split('#')[0];
        //       // this is a title
        //       // set the current title
        //       _typeAheadController.text = "$firstHalf#$suggestion";

        //       print('Sub command ${"$firstHalf#$suggestion"}');
        //     }
        //     print('-------------------- END ---------------- ');
        //     return;
        //   },
        //   onSubmit: (value) {
        //     print('Submitted $value');

        //     // if value is present in the commandList,
        //     //then set the current command to value
        //     // and set the visibility to false
        //     ref.read(mainCommandTextProvider.notifier).set('');
        //     _typeAheadController.text = '';
        //     try {
        //       // if the command is /news, then navigate to the news feed page
        //       if (value == '/news') {
        //         // Navigator.pushAndRemoveUntil(
        //         //     context, NewsPage.launchRoute(), (route) => false);
        //         Navigator.push(context, NewsPage.launchRoute());
        //         return;
        //       }
        //       final newThread = parser.validateCommand(
        //           value, titlesList, commandHintTextNotifier);
        //       String newThreadType;
        //       if (threadList.value!.containsKey(newThread["title"])) {
        //         newThreadType = threadList.value![newThread["title"]]!;
        //       } else {
        //         newThreadType = newThread["type"]!;
        //       }
        //       // switchThread(ref, context, newThread["title"]!, newThreadType);
        //       print(
        //           'Switching to thread ${newThread["title"]} of type $newThreadType');
        //       // only iommand was successfully validated
        //     } catch (e) {
        //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //         content:
        //             Text(e.toString().replaceAll('Invalid argument(s):', '')),
        //         duration: const Duration(seconds: 2),
        //       ));
        //       return;
        //     }
        //   },
        // ),
        // TypeAheadField<String>(
        //   focusNode: commandFocusNode,
        //   hideOnEmpty: true,
        //   direction: VerticalDirection.up,
        //   controller: _typeAheadController,
        //   builder: (context, controller, focusNode) => TextField(
        //     controller: controller,
        //     onSubmitted: (value) {
        // // if value is present in the commandList,
        // //then set the current command to value
        // // and set the visibility to false
        // try {
        //   // if the command is /news, then navigate to the news feed page
        //   if (value == '/news') {
        //     // Navigator.pushAndRemoveUntil(
        //     //     context, NewsPage.launchRoute(), (route) => false);
        //     Navigator.push(context, NewsPage.launchRoute());
        //     return;
        //   }
        //   final newThread = parser.validateCommand(
        //       value, titlesList, commandHintTextNotifier);
        //   String newThreadType;
        //   if (threadList.value!.containsKey(newThread["title"])) {
        //     newThreadType = threadList.value![newThread["title"]]!;
        //   } else {
        //     newThreadType = newThread["type"]!;
        //   }
        //   switchThread(ref, context, newThread["title"]!, newThreadType);
        //   // only iommand was successfully validated
        // } catch (e) {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content:
        //         Text(e.toString().replaceAll('Invalid argument(s):', '')),
        //     duration: const Duration(seconds: 2),
        //   ));
        //   return;
        // }
        //     },
        //     focusNode: focusNode,
        //     autofocus: true,
        //     onChanged: (text) {},
        //     decoration: const InputDecoration(
        //       hintText: 'press "/" for commands',
        //     ),
        //   ),
        //   suggestionsCallback: (pattern) async {
        // List<String> suggestions = [];
        // if (pattern.isEmpty) {
        //   //suggestions.add('');
        //   return suggestions;
        // }
        // List<String> parts = pattern.split(' ');
        // if (parts.length == 1) {
        //   // we are displaying a list of commands now
        //   return parser.patternMatchingCommands(pattern);
        // }
        // if (parts.length == 2) {
        //   return parser.patternMatchingTitles(pattern, titlesList);
        // }
        // return suggestions;
        // },
        // itemBuilder: (context, suggestion) {
        //   return ListTile(
        //     title: Text(suggestion),
        //   );
        //   },
        //   onSelected: (suggestion) {
        // print(
        //     '---------------------------------------------------------------- START ----------------------------------------------------------------');
        // print(suggestion);
        // if (suggestion.startsWith('/')) {
        //   // this is a command
        //   _typeAheadController.text = suggestion;

        //   print('command $suggestion');
        //   SuggestionsController.of(context).refresh();
        // } else {
        //   // SuggestionsController.of(context).refresh();
        //   String firstHalf = _typeAheadController.text.split('#')[0];
        //   // this is a title
        //   // set the current title
        //   String? fullCommand =
        //       ("$firstHalf #$suggestion").replaceAll(RegExp(r"\s+"), ' ');
        //   _typeAheadController.text = fullCommand;

        //   print('Sub command $fullCommand');
        // }
        // print(
        //     '---------------------------------------------------------------- END ---------------------------------------------------------------- \n');
        // return;
        //   },
        //   errorBuilder: (context, error) => Text(error.toString()),
        // ),
        CustomCommandInput2(
          controller: _typeAheadController,
          suggestions: titlesList,
          onSuggestionTap: (suggestion) {},
          focusNode: commandFocusNode,
          onSearchTextChanged: (text) {},
          parser: parser,
          titlesList: titlesList,
          onSubmit: (value) {
            // if value is present in the commandList,
            //then set the current command to value
            // and set the visibility to false
            try {
              // if the command is /news, then navigate to the news feed page
              if (value == '/news') {
                // Navigator.pushAndRemoveUntil(
                //     context, NewsPage.launchRoute(), (route) => false);
                Navigator.push(context, NewsPage.launchRoute());
                return;
              }
              final newThread = parser.validateCommand(
                  value, titlesList, commandHintTextNotifier);
              String newThreadType;
              if (threadList.value!.containsKey(newThread["title"])) {
                newThreadType = threadList.value![newThread["title"]]!;
              } else {
                newThreadType = newThread["type"]!;
              }
              logger.e(
                  'Switching to thread ${newThread["title"]} of type $newThreadType');
              switchThread(ref, context, newThread["title"]!, newThreadType);
              // only iommand was successfully validated
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text(e.toString().replaceAll('Invalid argument(s):', '')),
                duration: const Duration(seconds: 2),
              ));
              return;
            }
          },
        ),
      ],
    );
  }
}

class CustomCommandInput2 extends StatefulWidget {
  const CustomCommandInput2(
      {super.key,
      this.suggestions = const [],
      this.onSuggestionTap,
      this.onSearchTextChanged,
      this.onSubmit,
      this.onChanged,
      this.focusNode,
      required this.controller,
      required this.parser,
      required this.titlesList});
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionTap;
  final ValueChanged<String>? onSearchTextChanged;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextEditingController controller;
  final CommandParser parser;
  final List<String> titlesList;

  @override
  State<CustomCommandInput2> createState() => _CustomCommandInputState2();
}

class _CustomCommandInputState2 extends State<CustomCommandInput2> {
  late ValueChanged<String>? onSearchTextChanged;

  late List<String> filtered;
  CommandParser get parser => widget.parser;
  List<String> get titlesList => widget.titlesList;
  List<String> get suggestions => widget.suggestions;
  FocusNode? get inputFocusNode => widget.focusNode;
  late FocusNode keyboardFocusNode;
  int? selectedIndex;
  late ScrollController scrollController;

  double get tileHeight => 50;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    keyboardFocusNode = FocusNode();
    onSearchTextChanged = widget.onSearchTextChanged;
    filtered = [];
  }

  Widget Wrapper({required Widget child}) {
    return (KeyboardListener(
        focusNode: keyboardFocusNode,
        autofocus: true,
        onKeyEvent: (value) {
          if (value.logicalKey == LogicalKeyboardKey.escape) {
            keyboardFocusNode.unfocus();
            setState(() {
              filtered = [];
            });
            //print('Escape');
          } else if (value.logicalKey == LogicalKeyboardKey.enter) {
            // onSubmit!(controller.text);
            // ref.read(provider.notifier).setList([]);
            //print('Enter: text: ${widget.controller.text}');
          } else if (value.logicalKey == LogicalKeyboardKey.arrowUp) {
            //print('Arrow up');
            setState(() {
              if (selectedIndex == null) {
                selectedIndex = filtered.length - 1;
              } else {
                selectedIndex = (selectedIndex! - 1) % filtered.length;
              }
            });

            // inputFocusNode?.requestFocus();
          } else if (value.logicalKey == LogicalKeyboardKey.arrowDown) {
            //print('Arrow down');
            setState(() {
              if (selectedIndex == null) {
                selectedIndex = 0;
              } else {
                selectedIndex = (selectedIndex! + 1) % filtered.length;
              }
            });
          } else if (value.logicalKey == LogicalKeyboardKey.arrowLeft) {
            //print('Arrow left');
          } else if (value.logicalKey == LogicalKeyboardKey.arrowRight) {
            //print('Arrow right');
          } else {
            // print('Key: ${value.logicalKey.keyLabel}');
          }
        },
        child: child));
  }

  Widget callbackShortcutWrapper({required Widget child}) {
    Map<ShortcutActivator, VoidCallback> bindings = {
      const SingleActivator(LogicalKeyboardKey.keyA, meta: true): () {
        //print('Meta + A');
        widget.controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.controller.text.length,
        );
      },
      const SingleActivator(LogicalKeyboardKey.arrowUp, meta: false): () {
        //print('Arrow up');
        if (filtered.isNullOrEmpty) {
          return;
        }
        final hasFirstCommand = widget.controller.text.contains(' #');
        final firstCommand =
            hasFirstCommand ? '${widget.controller.text.split(' #')[0]} #' : '';
        setState(() {
          if (selectedIndex == null) {
            selectedIndex = filtered.length - 1;

            // widget.controller.text = '$firstCommand${filtered[selectedIndex!]}';
          } else {
            selectedIndex = (selectedIndex! - 1) % filtered.length;
            // widget.controller.text = filtered[selectedIndex!];
          }
          widget.controller.text = '$firstCommand${filtered[selectedIndex!]}';
          final selectIndexOutOfListViewPort =
              selectedIndex! * tileHeight < scrollController.position.pixels;
          if (selectIndexOutOfListViewPort) {
            scrollController.animateTo(
              selectedIndex! * tileHeight,
              duration: Durations.long1,
              curve: Curves.linear,
            );
          }
          // scrollController.animateTo(
          //   selectedIndex! *tileHeight,
          //   duration: Durations.long1,
          //   curve: Curves.linear,
          // );
          // scrollController.jumpTo(scrollController.position.maxScrollExtent /
          //     (filtered.length - 1) *
          //     selectedIndex!);
        });
      },
      const SingleActivator(LogicalKeyboardKey.arrowDown, meta: false): () {
        //print('Arrow down');
        if (filtered.isNullOrEmpty) {
          return;
        }
        final hasFirstCommand = widget.controller.text.contains(' #');
        final firstCommand =
            hasFirstCommand ? '${widget.controller.text.split(' #')[0]} #' : '';
        setState(() {
          if (selectedIndex == null) {
            selectedIndex = 0;
            // widget.controller.text = filtered[selectedIndex!];
          } else {
            selectedIndex = (selectedIndex! + 1) % filtered.length;
          }

          widget.controller.text = '$firstCommand${filtered[selectedIndex!]}';
          final selectIndexOutOfListViewPort = selectedIndex! * tileHeight >
              scrollController.position.pixels + context.height * 0.5;

          if (selectIndexOutOfListViewPort) {
            scrollController.animateTo(
              selectedIndex! * tileHeight,
              duration: Durations.long1,
              curve: Curves.linear,
            );
          }
          // scrollController.jumpTo(scrollController.position.maxScrollExtent /
          //     (filtered.length - 1) *
          //     selectedIndex!);
        });
      },
      const SingleActivator(LogicalKeyboardKey.enter, meta: false): () {
        if (widget.controller.text.isEmpty) {
          widget.controller.text = '/';
          return;
        }
        if (!widget.controller.text.contains('#') && filtered.isNotEmpty) {
          widget.controller.text = '${widget.controller.text} #';
          setState(() {
            filtered = [];
            selectedIndex = null;
          });
          return;
        } else if (widget.controller.text.contains((' #'))) {
          widget.onSubmit!(widget.controller.text);
          print('Submitted ${widget.controller.text}');
        }
      },
    };

    return CallbackShortcuts(
      bindings: bindings,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return callbackShortcutWrapper(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          TextFormField(
            autofocus: true,
            onFieldSubmitted: (val) {
              logger.f('Submitted $val');
              widget.onSubmit!(val);
            },
            focusNode: inputFocusNode,
            controller: widget.controller,
            decoration: const InputDecoration(
              hintText: 'press "/" for commands',
            ),
            onChanged: (pattern) {
              if (pattern.isEmpty) {
                setState(() {
                  // filtered = suggestions;
                  filtered = [];
                });
                return;
              }
              List<String> parts = pattern.split(' ');
              if (parts.length == 1) {
                // we are displaying a list of commands now
                final list = parser.patternMatchingCommands(pattern);
                setState(() {
                  filtered = list;
                  // print(
                  //     'Setting Part 1 suggestions, ${list.length}, titleList: ${titlesList.length}');
                });
                return;
              }
              if (parts.length == 2) {
                final list = parser.patternMatchingTitles(pattern, titlesList);
                setState(() {
                  filtered = list;
                  // print(
                  //     'Setting Part 1 suggestions, ${list.length}, titleList: ${titlesList.length}');
                });
                return;
              }
              // return suggestions;
              setState(() {
                // print('Setting All suggestions, ${suggestions.length}');
                filtered = suggestions;
              });
            },
          ),
          if (filtered.isNotNullEmpty)
            AnimatedContainer(
              constraints: BoxConstraints(
                maxHeight:
                    min(context.height * 0.5, filtered.length * tileHeight),
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                  right: Radius.circular(10),
                ),
              ),
              margin: const EdgeInsets.only(bottom: 75),
              duration: Durations.short1,
              child: ListView.separated(
                controller: scrollController,
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final title = filtered[index];
                  final selected = selectedIndex == index;
                  return Material(
                    color: selected
                        ? context.colorScheme.onSurface.withOpacity(.2)
                        : context.colorScheme.surface,
                    child: ListTile(
                      title: Text(title),
                      tileColor:
                          selected ? Colors.red : context.colorScheme.surface,
                      selected: selected,
                      selectedColor: Colors.blue,
                      // dense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      hoverColor: context.colorScheme.primary.withOpacity(0.2),
                      onTap: () {
                        widget.onSuggestionTap!(title);
                        setState(() {
                          filtered = [];
                        });

                        print(
                            '---------------------------------------------------------------- START ----------------------------------------------------------------');
                        print(title);
                        if (title.startsWith('/')) {
                          // this is a command
                          widget.controller.text = title;

                          print('command $title');
                        } else {
                          String firstHalf =
                              widget.controller.text.split('#')[0];
                          // this is a title
                          // set the current title
                          String? fullCommand = ("$firstHalf #$title")
                              .replaceAll(RegExp(r"\s+"), ' ');
                          widget.controller.text = fullCommand;

                          print('Sub command $fullCommand');
                        }
                        print(
                            '---------------------------------------------------------------- END ---------------------------------------------------------------- \n');
                        inputFocusNode?.requestFocus();
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 1,
                    color: context.colorScheme.onSurface.withOpacity(.2),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class CustomCommandInput extends ConsumerWidget {
  const CustomCommandInput(
      {super.key,
      this.suggestions = const [],
      this.onSuggestionTap,
      this.onSearchTextChanged,
      this.onSubmit,
      this.onChanged,
      this.focusNode,
      required this.controller,
      required this.parser,
      required this.titlesList});
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionTap;
  final ValueChanged<String>? onSearchTextChanged;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  final TextEditingController controller;
  final CommandParser parser;
  final List<String> titlesList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = customCommandInputProvider.call(
      suggestions,
      suggestions,
      null,
      '',
    );

    final state = ref.watch(provider);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        TextFormField(
          onFieldSubmitted: (val) {
            onSubmit!(val);
            logger.e('Submitted $val');
            // ref.read(provider.notifier).setList([]);
          },
          focusNode: focusNode,
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'press "/" for commands',
          ),
          onChanged: (pattern) {
            if (pattern.isEmpty) {
              //suggestions.add('');
              // return suggestions;
              ref.read(provider.notifier).setList(suggestions);
              return;
            }
            List<String> parts = pattern.split(' ');
            if (parts.length == 1) {
              // we are displaying a list of commands now
              final list = parser.patternMatchingCommands(pattern);
              ref.read(provider.notifier).setList(list);
              return;
            }
            if (parts.length == 2) {
              final list = parser.patternMatchingTitles(pattern, titlesList);
              ref.read(provider.notifier).setList(list);
              return;
            }
            // return suggestions;
            ref.read(provider.notifier).setList(suggestions);
          },
        ),
        if (state.filtered.isNotNullEmpty)
          AnimatedContainer(
            constraints: BoxConstraints(
              maxHeight:
                  min(context.height * 0.5, state.filtered.length * 50.0),
            ),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(10),
                right: Radius.circular(10),
              ),
            ),
            margin: const EdgeInsets.only(bottom: 65),
            duration: Durations.short1,
            child: ListView.separated(
              itemCount: state.filtered.length,
              itemBuilder: (context, index) {
                final title = state.filtered[index];
                return ListTile(
                  autofocus: true,
                  title: Text(title),
                  onTap: () {
                    onSuggestionTap!(title);
                    ref.read(provider.notifier).setList([]);

                    print(
                        '---------------------------------------------------------------- START ----------------------------------------------------------------');
                    print(title);
                    if (title.startsWith('/')) {
                      // this is a command
                      controller.text = title;

                      print('command $title');
                    } else {
                      // SuggestionsController.of(context).refresh();
                      String firstHalf = controller.text.split('#')[0];
                      // this is a title
                      // set the current title
                      String? fullCommand = ("$firstHalf #$title")
                          .replaceAll(RegExp(r"\s+"), ' ');
                      controller.text = fullCommand;

                      print('Sub command $fullCommand');
                    }
                    print(
                        '---------------------------------------------------------------- END ---------------------------------------------------------------- \n');
                    focusNode?.requestFocus();
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
      ],
    );
  }
}
