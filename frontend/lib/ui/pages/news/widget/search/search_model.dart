import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/repo/search.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: context.colorScheme.secondaryContainer,
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
            maxHeight: context.width * .7,
            minHeight: 200,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.secondaryContainer.withOpacity(.5),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: context.customColors.monkBlue!,
              width: .3,
            ),
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
                  CloseButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      maximumSize: MaterialStateProperty.all(
                        const Size(40, 40),
                      ),
                      minimumSize: MaterialStateProperty.all(
                        const Size(20, 20),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(0),
                      ),
                      iconSize: MaterialStateProperty.all(14.0),
                      backgroundColor: MaterialStateProperty.all(
                          context.customColors.alertContainer),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: context.customColors.monkBlue!,
                thickness: .2,
              ),
              const SizedBox(height: 10),

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
                  //print('Submitted: $value');
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
              ] else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: searchType == 'Title' ? 'Title:' : "Semantic",
                            style: context.textTheme.bodyMedium!.copyWith(
                              color:
                                  context.colorScheme.onSurface.withOpacity(.9),
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: searchType == 'Title'
                                    ? ' Search by Thread titles'
                                    : " Search by Thread describing in a sentence",
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: context.colorScheme.onSurface
                                      .withOpacity(.5),
                                  fontSize: 14,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),

              if (list.isNotEmpty) ...[
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
        prefixIcon: searchType.isNotNullEmpty
            ? SizedBox(
                width: searchType == "Title" ? 60 : 100,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: context.colorScheme.onSurface.withOpacity(.65),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "$searchType:",
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.background.withOpacity(.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )
            : const Icon(Icons.search),
        hintText: 'Search',
        constraints: const BoxConstraints(
          minHeight: 40,
          maxHeight: 40,
        ),
        suffixIcon: searchType.isNullOrEmpty
            ? null
            : SizedBox(
                height: 30,
                child: IconButton(
                  constraints: const BoxConstraints(maxHeight: 20),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                    color: monkBlue700,
                  ),
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
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: monkBlue700),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: monkBlue700.withOpacity(.9)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: monkBlue700),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Search Options',
            style: context.textTheme.titleSmall,
          ),
        ),
        ListTile(
          onTap: () {
            onOptionSelect('Title');
          },
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          minVerticalPadding: 0,
          title: RichText(
            text: TextSpan(
                text: 'Title:',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(.9),
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: ' Search by Thread titles',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(.5),
                      fontSize: 12,
                    ),
                  ),
                ]),
          ),
          hoverColor: context.colorScheme.primary.withOpacity(0.8),
          focusColor: context.colorScheme.onSurface,
        ),
        ListTile(
          onTap: () {
            onOptionSelect('Semantic');
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          dense: true,
          title: RichText(
            text: TextSpan(
                text: 'Semantics:',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(.9),
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: ' Search by Thread describing in a sentence',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(.5),
                      fontSize: 12,
                    ),
                  ),
                ]),
          ),
          hoverColor: context.colorScheme.primary.withOpacity(0.8),
        ),
      ],
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
    return InkWell(
      hoverColor: context.colorScheme.primary.withOpacity(0.8),
      onTap: () => onSelectedTitle(e),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Text(
              e,
              style: context.textTheme.bodySmall!.copyWith(fontSize: 13),
            ).extended,
            SvgPicture.asset(
              'assets/svg/open_in_new.svg',
              color: context.customColors.monkBlue,
              height: 16,
              width: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 300, minHeight: 100),
      duration: Durations.medium2,
      child: filtered.isNotNullEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ListView.builder(
                controller: scrollController,
                itemCount: filtered.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final e = filtered[index];
                  final selected = false;
                  //selectedIndex == index;
                  return title(context, e, selected);
                },
              ),
            )
          : titleController.text.isEmpty
              // 5 SUGGESTIONS
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                )
              : const Center(child: Text('No results found')),
    );
  }
}
