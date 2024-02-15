import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/search.dart';

class SearchInput extends ConsumerWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      child: SearchBar(
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
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(queryResultsProvider);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
        );
      },
    );
  }
}

class SearchModal extends StatelessWidget {
  const SearchModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchInput(),
        SearchResults(),
      ],
    );
  }
}
