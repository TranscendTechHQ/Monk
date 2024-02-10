import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/repo/search.dart';

class SearchBar extends ConsumerWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        onSubmitted: (value) async {
          final List<String> queryResults =
              await ref.watch(queryMatchingThreadsProvider.call(value).future);
          ref.read(queryResultsProvider.notifier).setResults(queryResults);
        },
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search',
        ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: const Column(
        children: [
          SearchBar(),
          SearchResults(),
        ],
      ),
    );
  }
}
