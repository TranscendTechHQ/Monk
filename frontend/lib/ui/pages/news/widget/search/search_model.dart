import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/search.dart';
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
  double tileHeight = 70;

  int selectedIndex = 0;
  late List<String> titleList;
  late FocusNode keyboardFocusNode;
  late FocusNode? inputFocusNode;
  late ScrollController scrollController;
  late ValueNotifier<List<String>> filteredTitleNotifier;
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    titleList = widget.threadsMap.keys.toList();
    filteredTitleNotifier = ValueNotifier([]);
    keyboardFocusNode = FocusNode();
    inputFocusNode = FocusNode();
    scrollController = ScrollController();
    titleController = TextEditingController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    titleController.dispose();
    keyboardFocusNode.dispose();
    inputFocusNode!.dispose();
    super.dispose();
  }

  Future<void> handleSemanticSearch() async {
    filteredTitleNotifier.value = [];
    setState(() {
      isSearching = true;
    });
    final value = titleController.text;

    final List<String> queryResults =
        await ref.watch(queryMatchingThreadsProvider.call(value).future);
    ref.read(queryResultsProvider.notifier).setResults(queryResults);
    titleList = queryResults;
    filteredTitleNotifier.value = queryResults;
    setState(() {
      isSearching = false;
    });
  }

  void launchThread(BuildContext context, String title, String type) {
    Navigator.pop(context);
    Navigator.push(
      context,
      ThreadPage.launchRoute(title: title, type: type),
    );
  }

  Widget callbackShortcutWrapper(
      {required Widget child, List<String> filtered = const []}) {
    if (searchType != 'Title' || titleController.text.isEmpty) {
      return child;
    }
    Map<ShortcutActivator, VoidCallback> bindings = {
      const SingleActivator(LogicalKeyboardKey.arrowUp, meta: false): () {
        //print('Arrow up');
        if (filtered.isNullOrEmpty) {
          return;
        }

        setState(() {
          titleController.text = filtered[selectedIndex];

          final selectIndexOutOfListViewPort =
              selectedIndex * tileHeight < scrollController.position.pixels;
          if (selectIndexOutOfListViewPort) {
            scrollController.animateTo(
              selectedIndex * tileHeight,
              duration: Durations.long1,
              curve: Curves.linear,
            );
          }
          // scrollController.animateTo(
          //   selectedIndex *tileHeight,
          //   duration: Durations.long1,
          //   curve: Curves.linear,
          // );
          // scrollController.jumpTo(scrollController.position.maxScrollExtent /
          //     (filtered.length - 1) *
          //     selectedIndex);
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
            // titleController.text = filtered[selectedIndex];
          } else {
            selectedIndex = (selectedIndex + 1) % filtered.length;
          }

          titleController.text = filtered[selectedIndex];
          final selectIndexOutOfListViewPort = selectedIndex * tileHeight >
              scrollController.position.pixels + context.height * 0.5;

          if (selectIndexOutOfListViewPort) {
            scrollController.animateTo(
              selectedIndex * tileHeight,
              duration: Durations.long1,
              curve: Curves.linear,
            );
          }
          // scrollController.jumpTo(scrollController.position.maxScrollExtent /
          //     (filtered.length - 1) *
          //     selectedIndex);
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
      key: const Key('callback_shortcut_wrapper'),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: filteredTitleNotifier,
      builder: (BuildContext context, List<String> list, Widget? child) {
        return Container(
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
              SearchInput(
                inputFocusNode: inputFocusNode!,
                onClear: () {
                  setState(() {
                    searchType = '';
                    filteredTitleNotifier.value = [];
                  });
                },
                searchType: searchType,
                threadsMap: widget.threadsMap,
                titleController: titleController,
                onSubmitted: (value) {
                  if (value.isNotNullEmpty && searchType == "Semantic") {
                    handleSemanticSearch();
                    return;
                  }
                  print('Submitted: $value');
                  if (value.isNotEmpty) {
                    if (widget.threadsMap.values.contains(value)) {
                      launchThread(
                          context,
                          value,
                          widget.threadsMap.keys.firstWhere((element) =>
                              widget.threadsMap[element] == value));
                    }
                  }
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    filteredTitleNotifier.value = titleList;
                  } else {
                    filteredTitleNotifier.value = titleList.where((element) {
                      return element
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  }
                  Future.delayed(Durations.short4, () {
                    setState(() {
                      selectedIndex = 0;
                    });
                    inputFocusNode!.requestFocus();
                    print('Focus requested');
                  });
                },
              ),
              const Padding(padding: EdgeInsets.all(8)),

              // SEARCH OPTIONS
              if (searchType == '') ...[
                SearchOptions(
                  onOptionSelect: (option) {
                    setState(() {
                      searchType = option;
                      if (option == 'Title') {
                        titleList = widget.threadsMap.keys.toList();
                        filteredTitleNotifier.value = titleList;
                      } else {
                        titleList = [];
                        filteredTitleNotifier.value = [];
                      }
                    });
                    inputFocusNode!.requestFocus();
                  },
                ),
                const SizedBox(height: 30),
              ] else if (list.isNotEmpty) ...[
                // SUGGESTIONS AND SEARCH RESULTS
                callbackShortcutWrapper(
                  filtered: list,
                  child: ThreadTitleList(
                    filtered: list,
                    onSelectedIndex: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    onSelectedTitle: (title) {
                      launchThread(context, title, widget.threadsMap[title]!);
                    },
                    scrollController: scrollController,
                    threadsMap: widget.threadsMap,
                    titleController: titleController,
                    selectedIndex: selectedIndex,
                  ),
                ),
                const SizedBox(height: 30),
              ] else
                const SizedBox(height: 100),
              if (searchType == 'Semantic')
                // SEARCH BUTTON
                FilledButton.tonal(
                  onPressed:
                      isSearching ? null : () async => handleSemanticSearch(),
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
                  child: isSearching
                      ? CircularProgressIndicator.adaptive(
                          backgroundColor: context.colorScheme.onSecondary,
                        ).pH(18)
                      : Text(
                          'Search',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSecondary,
                          ),
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    required this.titleController,
    required this.inputFocusNode,
    required this.threadsMap,
    this.onChanged,
    required this.onClear,
    required this.searchType,
    required this.onSubmitted,
  });
  final TextEditingController titleController;
  final FocusNode inputFocusNode;
  final Map<String, String> threadsMap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback onClear;
  final String searchType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('search_input'),
      controller: titleController,
      focusNode: inputFocusNode,
      autofocus: true,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixStyle: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurface,
        ),
        // prefix: Text(searchType),
        prefixIcon: searchType.isNotNullEmpty
            ? SizedBox(
                width: searchType == "Title" ? 50 : 100,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: context.colorScheme.onSurface.withOpacity(.35),
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
                    onClear();
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
    );
  }
}

class SearchOptions extends StatelessWidget {
  const SearchOptions({super.key, required this.onOptionSelect});
  final Function(String option) onOptionSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colorScheme.onSurface.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Search Options',
              style: context.textTheme.titleSmall,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            onTap: () {
              onOptionSelect('Title');
              // setState(() {
              //   searchType = 'title';
              // });
              // inputFocusNode!.requestFocus();
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
              onOptionSelect('Semantic');
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
    );
  }
}

class ThreadTitleList extends StatelessWidget {
  const ThreadTitleList(
      {super.key,
      required this.threadsMap,
      required this.filtered,
      required this.titleController,
      required this.scrollController,
      this.selectedIndex,
      required this.onSelectedIndex,
      required this.onSelectedTitle});
  final Map<String, String> threadsMap;
  final List<String> filtered;
  final TextEditingController titleController;
  final ScrollController scrollController;
  final int? selectedIndex;
  final Function(int) onSelectedIndex;
  final Function(String) onSelectedTitle;

  Widget title(
    BuildContext context,
    String e,
    bool selected,
  ) {
    return Material(
      color: selected
          ? context.colorScheme.onSurface.withOpacity(.2)
          : context.colorScheme.surface.withOpacity(.3),
      child: ListTile(
        onTap: () {
          onSelectedTitle(e);
        },
        title: Text(e),
        focusColor: context.colorScheme.onSurface,
        tileColor:
            selected ? Colors.red : context.colorScheme.scrim.withOpacity(.5),
        selected: selected,
        selectedColor: Colors.blue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        hoverColor: context.colorScheme.primary.withOpacity(0.2),
        trailing: Icon(
          Icons.open_in_new_rounded,
          size: 16,
          color: context.colorScheme.onSurface.withOpacity(.7),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
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
                  final selected = false;
                  //selectedIndex == index;
                  return title(context, e, selected);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 1,
                    color: context.colorScheme.onSurface.withOpacity(.2),
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
                          children: threadsMap.keys
                              .take(5)
                              .map(
                                (e) => title(context, e, false),
                              )
                              .toList(),
                        ).extended,
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('No results found')),
    );
  }
}
