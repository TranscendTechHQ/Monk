import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/search.dart';
import 'package:frontend/repo/thread.dart';
import 'package:frontend/screens/commandbox.dart';

class SearchInput extends ConsumerWidget {
  final FocusNode focusNode;
  const SearchInput({super.key, required this.focusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      child: SearchBar(
        focusNode: focusNode,
        onSubmitted: (value) async {
          final List<String> queryResults =
              await ref.watch(queryMatchingThreadsProvider.call(value).future);
          ref.read(queryResultsProvider.notifier).setResults(queryResults);
        },
        controller: searchController,
        hintText: 'Search for a thread',
      ),
    );
  }
}

class SearchResults extends ConsumerWidget {
  SearchResults({super.key});
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(queryResultsProvider);
    final threadList = ref.watch(fetchThreadsInfoProvider);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          selectedTileColor: Theme.of(context).colorScheme.shadow,
          selected: selectedIndex == index,
          onTap: () {
            selectedIndex = index;
            //print('Selected index: $selectedIndex');
            final newThreadTitle = results[index];
            final newThreadType = threadList.value![newThreadTitle]!;
            switchThread(ref, context, newThreadTitle, newThreadType);
          },
          title: Text(results[index]),
        );
      },
    );
  }
}

class SearchModal extends StatelessWidget {
  final FocusNode focusNode;
  const SearchModal({super.key, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchInput(focusNode: focusNode),
        SearchResults(),
      ],
    );
  }
}
