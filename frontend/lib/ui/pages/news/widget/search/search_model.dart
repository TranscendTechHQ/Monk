import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/network.dart';
import 'package:frontend/helper/utils.dart';
import 'package:frontend/repo/search.dart';
import 'package:frontend/ui/pages/news/widget/provider/create_thread_provider.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/theme/theme.dart';

class SearchModal2 extends ConsumerStatefulWidget {
  const SearchModal2({
    super.key,
    required this.threadsMap,
  });
  final Map<String, String> threadsMap;

  static Future<void> show(
    BuildContext context, {
    required Map<String, String> threadsMap,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.center,
          elevation: 0.0,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          backgroundColor: Colors.transparent,
          child: SearchModal2(threadsMap: threadsMap),
        );
      },
    );
  }

  @override
  _SearchModal2State createState() => _SearchModal2State();
}

class _SearchModal2State extends ConsumerState<SearchModal2> {
  late TextEditingController titleController;
  String searchType = '';
  late List<String> filtered;
  double tileHeight = 50;

  int? selectedIndex;
  late FocusNode keyboardFocusNode;
  late FocusNode? inputFocusNode;
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    filtered = widget.threadsMap.keys.toList();

    keyboardFocusNode = FocusNode();
    inputFocusNode = FocusNode();
    scrollController = ScrollController();
    titleController = TextEditingController();
    //     ..addListener(() {

    //       setState(() {
    //         final list = widget.threadsMap.keys.where((element) {
    //           return element
    //               .toLowerCase()
    //               .contains(titleController.text.toLowerCase());
    //         }).toList();
    //         if (list.isNotEmpty) {
    //           filtered = list;
    //           selectedIndex = 0;
    //         } else {
    //           filtered = [];
    //         }
    //         selectedIndex = 0;
    //       });
    //     });
  }

  @override
  void dispose() {
    scrollController.dispose();
    titleController.dispose();
    super.dispose();
  }

  // Iterable<String> get titlesList =>
  //     widget.threadsMap.keys.where((element) => titleController.text.isNotEmpty
  //         ? element.toLowerCase().contains(titleController.text.toLowerCase())
  //         : false);

  void launchThread(BuildContext context, String title, String type) {
    Navigator.pop(context);
    Navigator.push(
      context,
      ThreadPage.launchRoute(title: title, type: type),
    );
  }

  Future<void> createThread(
      BuildContext context, WidgetRef ref, String title, String message) async {
    if (title.isNullOrEmpty) {
      showMessage(context, 'Title is required');
      return;
    }

    // final threadList =  ref.read(fetchThreadsInfoProvider);
    final createThreadNotifier = createThreadPodProvider.notifier;
  }

  Widget callbackShortcutWrapper({required Widget child}) {
    if (searchType != 'title' || titleController.text.isEmpty) {
      return child;
    }
    Map<ShortcutActivator, VoidCallback> bindings = {
      const SingleActivator(LogicalKeyboardKey.arrowUp, meta: false): () {
        //print('Arrow up');
        if (filtered.isNullOrEmpty) {
          return;
        }

        setState(() {
          if (selectedIndex == null) {
            selectedIndex = filtered.length - 1;

            // titleController.text = '$firstCommand${filtered[selectedIndex!]}';
          } else {
            selectedIndex = (selectedIndex! - 1) % filtered.length;
            // titleController.text = filtered[selectedIndex!];
          }
          titleController.text = filtered[selectedIndex!];
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

        setState(() {
          if (selectedIndex == null) {
            selectedIndex = 0;
            // titleController.text = filtered[selectedIndex!];
          } else {
            selectedIndex = (selectedIndex! + 1) % filtered.length;
          }

          titleController.text = filtered[selectedIndex!];
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
        final title = titleController.text;

        if (title.isNotEmpty) {
          if (widget.threadsMap.values.contains(title)) {
            launchThread(
                context,
                title,
                widget.threadsMap.keys.firstWhere(
                    (element) => widget.threadsMap[element] == title));
          }
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
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: context.width * .6,
          minWidth: 300,
          maxHeight: context.width * .6,
          minHeight: 200,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search',
                  style: context.textTheme.bodyLarge,
                ),
                const CloseButton()
              ],
            ),
            const Divider(),
            const Padding(padding: EdgeInsets.all(8)),

            // SEARCH INPUT
            TextField(
              controller: titleController,
              focusNode: inputFocusNode,
              autofocus: true,
              onSubmitted: (value) {},
              onChanged: ((e) {
                setState(() {
                  filtered = widget.threadsMap.keys.where((element) {
                    return element
                        .toLowerCase()
                        .contains(titleController.text.toLowerCase());
                  }).toList();
                  selectedIndex = 0;
                });
              }),
              decoration: InputDecoration(
                prefixStyle: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
                // prefix: Text(searchType),
                prefixIcon: searchType.isNotNullEmpty
                    ? SizedBox(
                        width: searchType == "title" ? 50 : 100,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: context.colorScheme.onSurface
                                  .withOpacity(.35),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "$searchType:",
                              style: context.textTheme.bodySmall,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.search),
                hintText: 'Search',
                suffixIcon: searchType.isNullOrEmpty
                    ? null
                    : SizedBox(
                        height: 30,
                        child: IconButton(
                          constraints: const BoxConstraints(maxHeight: 20),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            titleController.clear();
                            setState(() {
                              searchType = '';
                            });
                          },
                        ),
                      ),
                fillColor: context.colorScheme.scrim,
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(.4),
                ),
                enabledBorder: const UnderlineInputBorder(),
                focusedBorder: const UnderlineInputBorder(),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: context.colorScheme.onSurface.withOpacity(.8),
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: context.colorScheme.error.withOpacity(.8),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),

            // SEARCH OPTIONS
            if (searchType == '') ...[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Text(
                        'Search Options',
                        style: context.textTheme.titleSmall,
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      onTap: () {
                        setState(() {
                          searchType = 'title';
                        });
                        inputFocusNode!.requestFocus();
                      },
                      title: Text(
                        'Title',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.onSurface.withOpacity(.9),
                        ),
                      ),
                      hoverColor: context.colorScheme.onSurface,
                      focusColor: context.colorScheme.onSurface,
                    ),
                    const Divider(height: 0),
                    ListTile(
                      onTap: () {
                        setState(() {
                          searchType = 'semantic';
                        });
                        inputFocusNode!.requestFocus();
                      },
                      title: Text(
                        'Semantic',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.onSurface.withOpacity(.9),
                        ),
                      ),
                      hoverColor: context.colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ] else if (searchType == 'title') ...[
              // SUGGESTIONS AND SEARCH RESULTS
              AnimatedContainer(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: Durations.medium2,
                child: filtered.isNotNullEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (BuildContext context, int index) {
                            final e = filtered[index];
                            final selected = selectedIndex == index;
                            return Material(
                              color: selected
                                  ? context.colorScheme.onSurface
                                      .withOpacity(.2)
                                  : context.colorScheme.surface.withOpacity(.3),
                              child: ListTile(
                                onTap: () {
                                  launchThread(
                                      context, e, widget.threadsMap[e]!);
                                },
                                title: Text(e),
                                focusColor: context.colorScheme.onSurface,
                                tileColor: selected
                                    ? Colors.red
                                    : context.colorScheme.scrim.withOpacity(.5),
                                selected: selected,
                                selectedColor: Colors.blue,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                hoverColor: context.colorScheme.primary
                                    .withOpacity(0.2),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 1,
                              color:
                                  context.colorScheme.onSurface.withOpacity(.2),
                            );
                          },
                        ),
                      )
                    : titleController.text.isEmpty
                        // 5 SUGGESTIONS
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ColoredBox(
                              color: context.colorScheme.scrim.withOpacity(.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Text(
                                      'Suggestions',
                                      style: context.textTheme.titleSmall,
                                    ),
                                  ),
                                  const Divider(height: 0),
                                  ListView(
                                    children: widget.threadsMap.keys
                                        .take(5)
                                        .map(
                                          (e) => Material(
                                            color: context.colorScheme.surface
                                                .withOpacity(.3),
                                            child: ListTile(
                                              onTap: () {
                                                final type =
                                                    widget.threadsMap[e];
                                                if (type.isNotNullEmpty) {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    ThreadPage.launchRoute(
                                                        title: e, type: type!),
                                                  );
                                                }
                                              },
                                              title: Text(
                                                e,
                                                style: context
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  color: context
                                                      .colorScheme.onSurface
                                                      .withOpacity(.8),
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              hoverColor: context
                                                  .colorScheme.primary
                                                  .withOpacity(0.2),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ).extended,
                                ],
                              ),
                            ),
                          )
                        : const Center(child: Text('No results found')),
              ),
              const SizedBox(height: 30),
            ] else
              const SizedBox(height: 100),
            if (searchType == 'semantic')
              // List Of Titles
              FilledButton.tonal(
                onPressed: () async {
                  final value = titleController.text;
                  print(value);
                  final List<String> queryResults = await ref
                      .watch(queryMatchingThreadsProvider.call(value).future);
                  ref
                      .read(queryResultsProvider.notifier)
                      .setResults(queryResults);
                  print(queryResults);
                  //SearchModal(focusNode: _searchFocusNode)
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    context.colorScheme.secondary,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  'Search',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
