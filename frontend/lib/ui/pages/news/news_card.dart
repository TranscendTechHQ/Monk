import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/news/provider/news_provider.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.metaData});

  final ThreadMetaData metaData;

  void launchThread(BuildContext context) {
    Navigator.push(context,
        ThreadPage.launchRoute(title: metaData.title, type: metaData.type));
  }

  @override
  Widget build(BuildContext context) {
    final title = metaData.title;
    final headline = metaData.headline ?? "";
    final creator = metaData.creator;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.only(
                  bottom: 22.0, top: 24, left: 24, right: 24),
              decoration: BoxDecorations.cardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              creator.picture!.startsWith('https')
                                  ? creator.picture!
                                  : "https://api.dicebear.com/7.x/identicon/png?seed=${creator.name ?? "UN"}",
                              width: 35,
                              height: 35,
                              cacheHeight: 35,
                              cacheWidth: 35,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                creator.name!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM yyyy').format(
                                    DateTime.tryParse(metaData.createdAt)!
                                        .toLocal()),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.open_in_new_rounded,
                            color:
                                context.colorScheme.onSurface.withOpacity(.9),
                            size: 16,
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        headline,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: context.colorScheme.onSurface.withOpacity(.6),
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],
                  ).onPressed(() => launchThread(context)),
                  NewsBottomActions(metaData: metaData),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NewsBottomActions extends ConsumerWidget {
  const NewsBottomActions({super.key, required this.metaData});
  final ThreadMetaData metaData;
  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = newsCardPodProvider(metaData);
    final watchProvider = ref.watch(provider);
    final readProvider = ref.read(provider.notifier);

    ref.listen(provider, (prev, next) {
      if (next.estate == ENewsCardState.upVoted) {
        showMessage(context, "Upvoted successfully");
      } else if (next.estate == ENewsCardState.bookmarked) {
        showMessage(context, "Bookmark added successfully");
      } else if (next.estate == ENewsCardState.dismissed) {
        showMessage(context, "Dismissed successfully");
        final newsFeed = ref.read(newsFeedProvider.notifier);
        newsFeed.remove(metaData.id);
      }
    });

    return Row(
      children: [
        if (watchProvider.estate == ENewsCardState.upVoting)
          const CircularProgressIndicator.adaptive()
        else
          TextButton.icon(
            onPressed: () async {
              await readProvider.createTfThreadFlagPost(
                metaData.id,
                upvote: true,
              );
            },
            icon: const Icon(
              Icons.arrow_upward,
              size: 18,
            ),
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.onSurface.withOpacity(.9),
            ),
            label: Text(
              "Upvote",
              style: TextStyle(
                fontSize: 14,
                color: context.colorScheme.onSurface.withOpacity(.9),
              ),
            ),
          ),
        const SizedBox(width: 16),
        if (watchProvider.estate == ENewsCardState.bookmarking)
          const CircularProgressIndicator.adaptive()
        else
          TextButton.icon(
            onPressed: () async {
              await readProvider.createTfThreadFlagPost(
                metaData.id,
                bookmark: true,
              );
            },
            icon: const Icon(
              Icons.bookmark_add_outlined,
              size: 18,
            ),
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.onSurface.withOpacity(.9),
            ),
            label: Text(
              "Bookmark",
              style: TextStyle(
                fontSize: 14,
                color: context.colorScheme.onSurface.withOpacity(.9),
              ),
            ),
          ),
        const Spacer(),
        SizedBox(
          width: 30,
          child: watchProvider.estate == ENewsCardState.dismissing
              ? const CircularProgressIndicator.adaptive()
              : Tooltip(
                  message: 'Dismiss',
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor:
                            context.colorScheme.onSurface.withOpacity(.9),
                        padding: const EdgeInsets.all(0)),
                    onPressed: () async {
                      await readProvider.createTfThreadFlagPost(
                        metaData.id,
                        unfollow: true,
                      );
                    },
                    child: const Icon(Icons.clear),
                  ),
                ),
        )
      ],
    );
  }
}
