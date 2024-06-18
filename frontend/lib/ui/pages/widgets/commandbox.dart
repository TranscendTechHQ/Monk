import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/helper/file_utils.dart';
import 'package:frontend/main.dart';
import 'package:frontend/repo/commandparser.dart';
import 'package:frontend/ui/pages/news/news_page.dart';
import 'package:frontend/ui/pages/thread/provider/thread.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/pages/widgets/search.dart';
import 'package:frontend/ui/pages/widgets/user-mention/users.provider.dart';
import 'package:frontend/ui/pages/widgets/zefyr_editor.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/cache_image.dart';
// import 'package:markdown_quill/markdown_quill.dart' as mdq;
import 'package:notus/convert.dart';
import 'package:openapi/openapi.dart';
// import 'package:quill_delta/quill_delta.dart' as qD;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zefyr/zefyr.dart';

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

@riverpod
class BlockAttachment extends _$BlockAttachment {
  @override
  File? build() {
    return null;
  }

  void setAttachment(File file) {
    state = file;
  }

  void clearAttachment() {
    state = null;
  }
}

void switchThread(WidgetRef ref, BuildContext context, String newThreadTitle,
    String newThreadType) {
  final screenVisibility = ref.read(screenVisibilityProvider().notifier);
  screenVisibility.setVisibility(InputBoxType.thread);
  // logger.v('Switching to thread $newThreadTitle of type $newThreadType');
  Navigator.push(
    context,
    ThreadPage.launchRoute(topic: newThreadTitle, type: newThreadType),
  );
}

class CommandBox extends ConsumerWidget {
  // final _blockController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _commandFocusNode = FocusNode();
  final _blockFocusNode = FocusNode();
  final String topic;
  final String type;
  final List<InputBoxType> allowedInputTypes;

  CommandBox({
    super.key,
    required this.topic,
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
        ref.read(currentThreadProvider.call(topic: topic, type: type).notifier);

    final screenVisibilityProviderVal =
        screenVisibilityProvider(visibility: allowedInputTypes.first);
    InputBoxType commandVisibility = ref.watch(screenVisibilityProviderVal);

    final attachment = ref.watch(blockAttachmentProvider);
    // final quillController = QuillController.basic();
    final zefyrController = ZefyrController();

    final filterProvider = filteredUserProvider;
    final filteredUsersNotifier = ref.read(filterProvider.notifier);

    // final threadInput = RichEditor(
    //   controller: quillController,
    //   focusNode: _blockFocusNode,
    // );
    final threadInput = ZefyrRichEditor(
        controller: zefyrController,
        focusNode: _blockFocusNode,
        filteredUsersNotifier: filteredUsersNotifier);

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
          const SingleActivator(LogicalKeyboardKey.enter, meta: false):
              () async {
            print('Converting to markdown');

            // final encoder = NotusMarkdownCodec();
            // late NotusMarkdownCodec notusMarkdown;
            // notusMarkdown = const NotusMarkdownCodec();

            // final deltaToMd = mdq.DeltaToMarkdown();

            final delta = zefyrController.document.toDelta();
            // final encoded = encoder.encode(qD.Delta.fromJson(delta.toJson()));
            final markdown =
                notusMarkdown.encode(zefyrController.document.toDelta());
            // print('Delta: $delta');
            // final markdown = deltaToMd.convert(delta);
            // final markdown2 = deltaToMd.convert(delta);
            await threadNotifier.createBlock(
              context,
              markdown,
              customTitle: topic,
              image: attachment,
            );
            ref.read(blockAttachmentProvider.notifier).clearAttachment();
            // _blockController.clear();
          },
      };

      return CallbackShortcuts(
        bindings: bindings,
        child: child,
      );
    }

    _blockFocusNode.requestFocus();
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
            }
          },
          child: callbackShortcutWrapper(
            child: Stack(children: [
              Visibility(
                  visible: (commandVisibility == InputBoxType.thread),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          if (attachment != null)
                            Image.file(
                              attachment,
                              height: 300,
                              // width: containerWidth,
                            ).p(20),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              onPressed: () {
                                ref
                                    .read(blockAttachmentProvider.notifier)
                                    .clearAttachment();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          FilteredUsersList(
                            onUserSelect: (user) {
                              final description =
                                  zefyrController.document.toPlainText();
                              List<String> words = description.split(' ');
                              final name = words.last.split('@')[1].trim();

                              zefyrController.replaceText(
                                description.length - name.length - 1,
                                name.length,
                                user.name!,
                              );

                              zefyrController.formatText(
                                description.length - name.length - 2,
                                user.name!.length + 1,
                                NotusAttribute.link
                                    .fromString('@mention?user=${user.id}'),
                              );

                              zefyrController.updateSelection(
                                TextSelection.collapsed(
                                  offset: description.length -
                                      name.length -
                                      2 +
                                      user.name!.length +
                                      1,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                context.colorScheme.onSurface.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final attachmentProvider =
                                    ref.read(blockAttachmentProvider.notifier);
                                attachmentProvider.clearAttachment();

                                final file = await FileUtility.pickImage();
                                file.fold(
                                  (value) {
                                    attachmentProvider.setAttachment(value);
                                  },
                                  () => null,
                                );
                              },
                              icon: const Icon(Icons.image_outlined),
                            ),
                            threadInput.extended,
                          ],
                        ),
                      ),
                    ],
                  )
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
            ]),
          ),
        ),
      ),
    );
  }
}

class FilteredUsersList extends ConsumerWidget {
  const FilteredUsersList({super.key, required this.onUserSelect});
  final ValueChanged<UserModel> onUserSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allUsers = ref.watch(usersProvider);
    var filteredUsers = ref.watch(filteredUserProvider);

    return filteredUsers.maybeWhen(
        orElse: () => const SizedBox(),
        data: (list) {
          if (list.isEmpty) {
            return const SizedBox();
          }
          return Positioned(
            child: AnimatedContainer(
              height: min(400, list.length * 55),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: context.colorScheme.secondaryContainer.withOpacity(.99),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: context.customColors.monkBlue!,
                  width: .3,
                ),
              ),
              duration: const Duration(milliseconds: 300),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final User = list[index];
                  final name = User.name ?? '';
                  return ListTile(
                    title: Text(
                      name,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CacheImage(
                        path: User.picture!.startsWith('https')
                            ? User.picture!
                            : "https://api.dicebear.com/7.x/identicon/png?seed=${User.name ?? "UN"}",
                        width: 35,
                        height: 35,
                        fit: BoxFit.fill,
                      ),
                    ),
                    onTap: () {
                      onUserSelect(User);
                      // we have to provide this username to the text field;
                      // insertUsernameMention(username);
                      // // clear the filtered users
                      // ref
                      //     .read(filteredUsersNotifierProvider.notifier)
                      //     .clear();
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: context.colorScheme.onSurface,
                    height: 8,
                    thickness: .2,
                    endIndent: 16,
                    indent: 16,
                  );
                },
              ),
            ),
          );
        });
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
        //         final topic = suggestion.split(' ')[1];
        //         _typeAheadController.text = '$suggestion ';
        //         ref.read(mainCommandTextProvider.notifier).set('$command ');
        //         print('command:[ $command], topic:[$topic');
        //         return;
        //       }
        //       // this is a command
        //       _typeAheadController.text = '$suggestion ';
        //       ref.read(mainCommandTextProvider.notifier).set('$suggestion ');

        //       print('command $suggestion');
        //     } else {
        //       //  _typeAheadController.text.split('#')[0];
        //       // this is a topic
        //       // set the current topic
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
        //       if (threadList.value!.containsKey(newThread["topic"])) {
        //         newThreadType = threadList.value![newThread["topic"]]!;
        //       } else {
        //         newThreadType = newThread["type"]!;
        //       }
        //       // switchThread(ref, context, newThread["topic"]!, newThreadType);
        //       print(
        //           'Switching to thread ${newThread["topic"]} of type $newThreadType');
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
        //   if (threadList.value!.containsKey(newThread["topic"])) {
        //     newThreadType = threadList.value![newThread["topic"]]!;
        //   } else {
        //     newThreadType = newThread["type"]!;
        //   }
        //   switchThread(ref, context, newThread["topic"]!, newThreadType);
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
        //     topic: Text(suggestion),
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
        //   // this is a topic
        //   // set the current topic
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
              if (threadList.value!.containsKey(newThread["topic"])) {
                newThreadType = threadList.value![newThread["topic"]]!;
              } else {
                newThreadType = newThread["type"]!;
              }
              logger.e(
                  'Switching to thread ${newThread["topic"]} of type $newThreadType');
              switchThread(ref, context, newThread["topic"]!, newThreadType);
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

  Widget listenerWrapper({required Widget child}) {
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
        if (widget.controller.text == '/news') {
          // Navigator.pushAndRemoveUntil(
          //     context, NewsPage.launchRoute(), (route) => false);
          Navigator.pushReplacement(context, NewsPage.launchRoute());
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
          setState(() {
            filtered = [];
            selectedIndex = null;
          });
          widget.controller.clear();
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
                  final topic = filtered[index];
                  final selected = selectedIndex == index;
                  return Material(
                    color: selected
                        ? context.colorScheme.onSurface.withOpacity(.2)
                        : context.colorScheme.surface,
                    child: ListTile(
                      title: Text(topic),
                      tileColor:
                          selected ? Colors.red : context.colorScheme.surface,
                      selected: selected,
                      selectedColor: Colors.blue,
                      // dense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      hoverColor: context.colorScheme.primary.withOpacity(0.2),
                      onTap: () {
                        widget.onSuggestionTap!(topic);
                        setState(() {
                          filtered = [];
                        });

                        print(
                            '---------------------------------------------------------------- START ----------------------------------------------------------------');
                        print(topic);
                        if (topic.startsWith('/')) {
                          // this is a command
                          widget.controller.text = topic;

                          print('command $topic');
                        } else {
                          String firstHalf =
                              widget.controller.text.split('#')[0];
                          // this is a topic
                          // set the current topic
                          String? fullCommand = ("$firstHalf #$topic")
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
                final topic = state.filtered[index];
                return ListTile(
                  autofocus: true,
                  title: Text(topic),
                  onTap: () {
                    onSuggestionTap!(topic);
                    ref.read(provider.notifier).setList([]);

                    print(
                        '---------------------------------------------------------------- START ----------------------------------------------------------------');
                    print(topic);
                    if (topic.startsWith('/')) {
                      // this is a command
                      controller.text = topic;

                      print('command $topic');
                    } else {
                      // SuggestionsController.of(context).refresh();
                      String firstHalf = controller.text.split('#')[0];
                      // this is a topic
                      // set the current topic
                      String? fullCommand = ("$firstHalf #$topic")
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
