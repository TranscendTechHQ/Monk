import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/utils.dart';
import 'package:frontend/ui/pages/news/news_card.dart';
import 'package:frontend/ui/pages/news/provider/news_provider.dart';
import 'package:frontend/ui/pages/news/widget/create_thread_model.dart';
import 'package:frontend/ui/pages/news/widget/news_filter/news_feed_filter.dart';
import 'package:frontend/ui/pages/news/widget/news_filter/provider/news_feed_filter_provider.dart';
import 'package:frontend/ui/pages/news/widget/search/search_model.dart';
import 'package:frontend/ui/pages/thread/provider/thread.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';

class NewsPage extends ConsumerWidget {
  final String title;
  final String type;
  const NewsPage({super.key, required this.title, required this.type});

  static String route = "/news";

  static Route launchRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const NewsPage(title: "News", type: "/news"),
    );
  }

  Future<void> onFilterPressed(BuildContext context, WidgetRef ref) async {
    final map = await showDialog<Map<String, dynamic>?>(
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
          child: const NewsFeedFilterView(),
        );
      },
    );
    if (map != null) {
      ref.read(newsFeedProvider.notifier).getFilteredFeed(
            bookmark: map['bookmarked'],
            unRead: map['unRead'],
            unfollow: map['dismissed'],
            upvote: map['upvoted'],
            mention: map['mention'],
            searchQuery: map['searchQuery'],
            isFilterEnabled: true,
          );
      final state = ref.read(newsFeedFilterProvider.notifier);
      await state.updateSemanticQuery(
        bookmarked: map['bookmarked'],
        dismissed: map['dismissed'],
        unRead: map['unRead'] as bool,
        upvoted: map['upvoted'],
        mentioned: map['mention'] as bool,
        semanticQuery: map['searchQuery'],
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadList = ref.watch(fetchThreadsInfoProvider);
    ref.watch(newsFeedFilterProvider);
    final List<String> titlesList = threadList.value?.keys.toList() ?? [];

    return Scaffold(
      body: PageScaffold(
        body: WithMonkAppbar(
          child: Container(
            padding: const EdgeInsets.only(top: 36),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT TOOLBAR
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlineIconButton(
                        wrapped: false,
                        svgPath: 'search.svg',
                        label: 'Search',
                        onPressed: () {
                          SearchModal2.show(context,
                              threadsMap: threadList.value!);
                        },
                      ),
                      const SizedBox(height: 10),
                      OutlineIconButton(
                        wrapped: false,
                        svgPath: 'filter.svg',
                        label: 'Filter',
                        onPressed: () {
                          onFilterPressed(context, ref);
                        },
                      ),
                      const SizedBox(height: 10),
                      OutlineIconButton(
                        wrapped: false,
                        svgPath: 'createthread.svg',
                        label: 'Chat',
                        onPressed: () async {
                          final newThread = await CreateThreadModal.show(
                            context,
                            titlesList: titlesList,
                            type: 'chat',
                          );

                          if (newThread != null) {
                            print('Refreshing the news feed');
                            ref.invalidate(newsFeedProvider);
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      OutlineIconButton(
                        wrapped: false,
                        svgPath: 'todo.svg',
                        label: 'Todo',
                        iconSize: 16,
                        onPressed: () async {
                          final newThread = await CreateThreadModal.show(
                              context,
                              titlesList: titlesList,
                              type: 'todo');
                          if (newThread != null) {
                            print('Refreshing the news feed');
                            ref.invalidate(newsFeedProvider);
                          }
                        },
                      ),
                    ],
                  ).hP8,
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Expanded(child: ChatListView()),
                    const Padding(padding: EdgeInsets.all(8))
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: () {
                    showMessage(
                        context, 'fetching new threads and applying filters');
                    ref.invalidate(newsFeedProvider);
                    // ref.read(newsFeedProvider.future);
                    ref
                        .read(newsFeedProvider.notifier)
                        .getFilteredFeed(isFilterEnabled: false);
                  },
                ),
                SizedBox(width: context.scale(150, 50, 10)),
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
      loading: () => Container(
        width: 500.00.scale(
          800.00,
          600,
          200,
        ),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (touple) {
        final threadHeadlineList = newsFeed.asData!.value;
        return RefreshIndicator(
          onRefresh: () => Future.wait([
            ref.refresh(newsFeedProvider.future),
          ]),
          color: context.colorScheme.onSurface.withOpacity(.9),
          child: Container(
            width: 500,
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
