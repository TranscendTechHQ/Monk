import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/news/news_card.dart';
import 'package:frontend/ui/pages/news/provider/news_provider.dart';
import 'package:frontend/ui/pages/news/widget/create_thread_model.dart';
import 'package:frontend/ui/pages/news/widget/news_feed_filter.dart';
import 'package:frontend/ui/pages/thread/provider/thread.dart';
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
            unRead: map['unRead'],
            unfollow: map['dismissed'],
            upvote: map['upvoted'],
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadList = ref.watch(fetchThreadsInfoProvider);
    final List<String> titlesList = threadList.value?.keys.toList() ?? [];

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 16, vertical: 8),
                    //   decoration: BoxDecoration(
                    //     color: context.colorScheme.surface,
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       const Icon(Icons.search),
                    //       const SizedBox(width: 8),
                    //       Text(
                    //         'Search',
                    //         style: context.textTheme.bodyLarge?.copyWith(
                    //           color:
                    //               context.colorScheme.onSurface.withOpacity(.8),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        CreateThreadModal.show(context,
                            titlesList: titlesList, type: '/new-thread');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          context.colorScheme.secondary,
                        ),
                      ),
                      child: Text(
                        "Create thread",
                        style: context.textTheme.bodySmall!
                            .copyWith(color: context.colorScheme.onSecondary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        CreateThreadModal.show(context,
                            titlesList: titlesList, type: '/new-task');
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          context.colorScheme.secondary,
                        ),
                      ),
                      child: Text(
                        "Create todo",
                        style: context.textTheme.bodySmall!
                            .copyWith(color: context.colorScheme.onSecondary),
                      ),
                    ),
                  ],
                ).hP8.extended,
                Column(
                  children: [
                    Expanded(child: ChatListView()),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 16, vertical: 8),
                    //   width: containerWidth / 1.5,
                    //   child: blockInput,
                    // ),
                    const Padding(padding: EdgeInsets.all(8))
                  ],
                ),
                Spacer()
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
            width: 400,
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  // width: constraints.maxWidth / 2,
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
