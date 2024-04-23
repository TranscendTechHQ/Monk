import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/ui/pages/news/news_card.dart';
import 'package:frontend/ui/pages/news/provider/news_provider.dart';
import 'package:frontend/ui/pages/news/widget/news_feed_filter.dart';
import 'package:frontend/ui/pages/widgets/commandbox.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';

class NewsPage extends ConsumerWidget {
  final String title;
  final String type;
  const NewsPage({super.key, required this.title, required this.type});

  static String route = "/news";

  static Route launchRoute() {
    return MaterialPageRoute<void>(
        builder: (_) => const NewsPage(title: "News", type: "/news"));
  }

  Future<void> onFilterPressed(BuildContext context, WidgetRef ref) async {
    final map = await showDialog<Map<String, bool>?>(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          elevation: 0.0,
          insetPadding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          backgroundColor: Colors.transparent,
          child: NewsFeedFilter(),
        );
      },
    );
    if (map != null) {
      ref.read(newsFeedProvider.notifier).getFilteredFeed(
            bookmark: map['bookmarked'],
            read: map['read'],
            unfollow: map['dismissed'],
            upvote: map['upvoted'],
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockInput = CommandBox(
      title: title,
      type: type,
      allowedInputTypes: const [
        InputBoxType.commandBox,
        InputBoxType.searchBox,
      ],
    );
    return Scaffold(
      body: PageScaffold(
        body: WithMonkAppbar(
          actions: IconButton(
            tooltip: 'Filter',
            onPressed: () async => onFilterPressed(context, ref),
            icon: const Icon(Icons.filter_alt_outlined),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(child: ChatListView()),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: containerWidth / 1.5,
                  child: blockInput,
                ),
                const Padding(padding: EdgeInsets.all(8))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatListView extends ConsumerWidget {
  ChatListView({super.key});

  final scrollController = ScrollController();

  final emojiParser = EmojiParser(init: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsFeed = ref.watch(newsFeedProvider);

    return newsFeed.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (tuple) {
        final threadHeadlineList = newsFeed.asData!.value;
        return RefreshIndicator(
          onRefresh: () => Future.wait([
            ref.refresh(newsFeedProvider.future),
          ]),
          color: context.colorScheme.onSurface.withOpacity(.9),
          child: Container(
            width: containerWidth,
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  width: constraints.maxWidth / 2,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: threadHeadlineList.length,
                    padding: const EdgeInsets.only(bottom: 30),
                    itemBuilder: (context, index) {
                      final metaData = threadHeadlineList[index];
                      return NewsCard(metaData: metaData);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
