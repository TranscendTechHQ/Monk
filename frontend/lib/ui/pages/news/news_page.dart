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
import 'package:frontend/ui/pages/news/widget/semantic-filter/sematic_filter.dart';
import 'package:frontend/ui/pages/news/widget/team-task-model/team-task-model.dart';
import 'package:frontend/ui/pages/thread/provider/thread.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';

class NewsPage extends ConsumerWidget {
  final String topic;
  final String type;
  const NewsPage({super.key, required this.topic, required this.type});

  static String route = "/news";

  static Route launchRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const NewsPage(topic: "News", type: "/news"),
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
            updateFilter: true,
          );
      final state = ref.read(newsFeedFilterProvider.notifier);
      await state.updateFilter(
        bookmarked: map['bookmarked'],
        dismissed: map['dismissed'],
        unRead: map['unRead'] as bool,
        upvoted: map['upvoted'],
        mentioned: map['mention'] as bool,
      );
    }
  }

  Future<void> onPersonalisClicked(BuildContext context, WidgetRef ref) async {
    final map = await SemanticFilter.show<Map<String, dynamic>?>(context);
    if (map != null) {
      ref.read(newsFeedProvider.notifier).getFilteredFeed(
            searchQuery: map['searchQuery'],
            updateSemanticFilter: true,
          );
      final state = ref.read(newsFeedFilterProvider.notifier);
      await state.updateSemanticQuery(
        semanticQuery: map['searchQuery'],
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadList = ref.watch(fetchThreadsInfoProvider);
    final filtersState = ref.watch(newsFeedFilterProvider);

    final List<String> titlesList = threadList.value?.keys.toList() ?? [];
    final newsFeed = ref.watch(newsFeedProvider);

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
                  constraints:
                      BoxConstraints(maxWidth: context.scale(170, 160, 155)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CREATE CHAT THREAD
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
                      // CREATE TODO THREAD
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
                      // const SizedBox(height: 10),
                      Divider(
                        color: context.colorScheme.onSurface,
                        height: 30,
                      ),
                      // SEARCH
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
                      // FILTER
                      OutlineIconButton(
                        wrapped: false,
                        svgPath: 'filter.svg',
                        label: 'Filter',
                        borderColor: anyFilterApplied(filtersState.value)
                            ? context.colorScheme.onSecondaryContainer
                            : null,
                        onPressed: () {
                          onFilterPressed(context, ref);
                        },
                      ),
                      const SizedBox(height: 10),

                      // MENTIONS
                      Stack(
                        children: [
                          OutlineIconButton(
                            wrapped: false,
                            svgPath: 'filter.svg',
                            label: 'Mentions',
                            borderColor:
                                onlyMentionedFilterApplied(filtersState.value)
                                    ? context.colorScheme.onSecondaryContainer
                                    : null,
                            onPressed: () async {
                              final state =
                                  ref.read(newsFeedFilterProvider.notifier);

                              if (onlyMentionedFilterApplied(
                                  filtersState.value!)) {
                                await state.updateFilter(
                                  bookmarked: false,
                                  dismissed: false,
                                  unRead: false,
                                  upvoted: false,
                                  mentioned: false,
                                  semanticQuery: null,
                                );
                                ref.invalidate(newsFeedProvider);
                                // ref.read(newsFeedProvider.future);
                                await ref
                                    .read(newsFeedProvider.notifier)
                                    .getFilteredFeed(updateFilter: false);
                                showMessage(context, 'Displaying all threads');
                              } else {
                                ref
                                    .read(newsFeedProvider.notifier)
                                    .displayMentionedThreads();
                                await state.updateFilter(
                                  bookmarked: false,
                                  dismissed: false,
                                  unRead: false,
                                  upvoted: false,
                                  mentioned: true,
                                  semanticQuery: null,
                                );
                                showMessage(
                                    context, 'Displaying mentioned threads');
                              }
                            },
                          ),
                          newsFeed.maybeWhen(
                            orElse: () => const SizedBox(),
                            data: (threads) {
                              final mentionedThreads = threads
                                  .where((element) =>
                                      element.mention == true &&
                                      element.unread == true)
                                  .toList(growable: false);
                              if (mentionedThreads.isEmpty) {
                                return const SizedBox();
                              }
                              return Positioned(
                                top: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 3,
                                  backgroundColor:
                                      context.customColors.sourceAlert,
                                ).p(3),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // MY TASK
                      OutlineIconButton(
                        wrapped: false,
                        svgPath: 'todo.svg',
                        label: 'Task',
                        iconSize: 16,
                        onPressed: () async {
                          TeamTaskModal.show(context);
                        },
                      ),
                      const SizedBox(height: 10),
                      // UNREAD
                      OutlineIconButton(
                        wrapped: false,
                        svgPath: 'filter.svg',
                        label: 'Unread',
                        iconSize: 16,
                        borderColor: onlyUnReadFilterApplied(filtersState.value)
                            ? context.colorScheme.onSecondaryContainer
                            : null,
                        onPressed: () async {
                          final state =
                              ref.read(newsFeedFilterProvider.notifier);

                          if (onlyUnReadFilterApplied(filtersState.value!)) {
                            await state.updateFilter(
                              bookmarked: false,
                              dismissed: false,
                              unRead: false,
                              upvoted: false,
                              mentioned: false,
                              semanticQuery: null,
                            );
                            ref.invalidate(newsFeedProvider);
                            // ref.read(newsFeedProvider.future);
                            await ref
                                .read(newsFeedProvider.notifier)
                                .getFilteredFeed(updateFilter: false);
                            showMessage(context, 'Displaying all threads');
                          } else {
                            ref
                                .read(newsFeedProvider.notifier)
                                .displayUnReadThreads();
                            await state.updateFilter(
                              bookmarked: false,
                              dismissed: false,
                              unRead: true,
                              upvoted: false,
                              mentioned: false,
                              semanticQuery: null,
                            );
                            showMessage(context, 'Displaying unread threads');
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      // PERSONALIZE
                      OutlineIconButton(
                        wrapped: false,
                        svgPath: 'filter.svg',
                        label: 'Personalize',
                        borderColor:
                            isSemanticSearchFilterApplied(filtersState.value)
                                ? context.colorScheme.onSecondaryContainer
                                : null,
                        iconSize: 16,
                        onPressed: () async =>
                            onPersonalisClicked(context, ref),
                      ),
                    ],
                  ).hP8,
                ),
                SizedBox(width: context.scale(20, 10, 5)),
                Column(
                  children: [
                    Expanded(child: ChatListView()),
                    const Padding(padding: EdgeInsets.all(8))
                  ],
                ),
                if (!context.isMobile)
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
                          .getFilteredFeed(updateFilter: false);
                    },
                  ),
                if (context.isDesktop)
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
        width: context.scale(
          500.00,
          500,
          400,
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
            width: context.scale(
              500.00,
              500,
              400,
            ),
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  // width: constraints.maxWidth / 2,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: threadHeadlineList.length,
                    padding:
                        const EdgeInsets.only(bottom: 30, left: 4, right: 4),
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
