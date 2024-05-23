import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/repo/auth/auth_provider.dart';
import 'package:frontend/ui/pages/news/provider/news_provider.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/cache_image.dart';
import 'package:frontend/ui/widgets/dismiss_button.dart';
import 'package:frontend/ui/widgets/kit/alert.dart';
import 'package:frontend/ui/widgets/link_meta_card.dart';
import 'package:frontend/ui/widgets/title_action_widget.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart';

class NewsCard extends ConsumerWidget {
  const NewsCard({super.key, required this.metaData});

  final ThreadMetaData metaData;

  void launchThread(BuildContext context, WidgetRef ref) {
    ref.read(newsFeedProvider.notifier).markAsRead(metaData.id);
    Navigator.push(
      context,
      ThreadPage.launchRoute(
        title: metaData.title,
        type: metaData.type,
      ),
    );
  }

  Future<void> confirmDelete(BuildContext context, WidgetRef ref) async {
    Alert.confirm(
      context,
      barrierDismissible: true,
      title: "Delete",
      onConfirm: () async {
        final newsFeed = ref.read(newsFeedProvider.notifier);
        newsFeed.deleteThreadAsync(context, metaData.id);
      },
      message: 'Are you sure you want to delete this thread forever?',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = newsCardPodProvider(metaData);
    final watchProvider = ref.watch(provider);
    final readProvider = ref.read(provider.notifier);

    final title = metaData.title;
    final headline = metaData.headline ?? "";
    final creator = metaData.creator;

    final authState = ref.watch(authProvider);
    final authUserId = authState.value?.session?.userId;
    final creatorId = creator.id;
    final isCreator = creatorId == authUserId;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecorations.cardDecoration(context).copyWith(
                border: Border.all(
                  color: metaData.unread == true
                      ? monkBlue
                      : monkBlue700.withOpacity(.5),
                  width: metaData.unread == true ? 2 : .7,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: [
                          // profile picture
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CacheImage(
                              path: creator.picture!.startsWith('https')
                                  ? creator.picture!
                                  : "https://api.dicebear.com/7.x/identicon/png?seed=${creator.name ?? "UN"}",
                              width: 35,
                              height: 35,
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
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(.5),
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

                          if (watchProvider.estate == ENewsCardState.dismissing)
                            const CircularProgressIndicator.adaptive()
                          else
                            DismissButton(
                              onPressed: () async {
                                await readProvider.createTfThreadFlagPost(
                                  metaData.id,
                                  unfollow: true,
                                );
                              },
                              tooltip: 'Dismiss',
                            ),
                          if (isCreator)
                            SizedBox(
                              width: 25,
                              child: TileActionWidget(
                                onDelete: () async =>
                                    confirmDelete(context, ref),
                              ),
                            ),
                        ],
                      ),
                      // const SizedBox(height: 16),
                      Divider(
                        color: context.customColors.monkBlue!.withOpacity(.5),
                        thickness: .5,
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            metaData.type == 'todo'
                                ? 'assets/svg/todo.svg'
                                : "assets/svg/createthread.svg",
                            height: metaData.type == 'todo' ? 18 : 24,
                            color:
                                context.customColors.monkBlue!.withOpacity(.7),
                          ).pT(metaData.type == 'todo' ? 10 : 5),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              color: context.colorScheme.onPrimary,
                            ),
                          ).extended,
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (metaData.block == null)
                        Text(
                          headline,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color:
                                context.colorScheme.onSurface.withOpacity(.6),
                          ),
                        )
                      else ...[
                        SelectableText(
                          metaData.block!.content,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (metaData.block!.image != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * .3,
                              maxWidth: MediaQuery.of(context).size.width,
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            child: CacheImage(
                              path: metaData.block!.image!,
                              fit: BoxFit.fitHeight,
                              tag: UniqueKey().toString(),
                            ),
                          ),
                        ],
                        LinkMetaCard(linkMeta: metaData.block!.linkMeta),
                      ],
                      const SizedBox(height: 22),
                    ],
                  ).onPressed(() => launchThread(context, ref)),
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

  Widget textIconButton(
    BuildContext context, {
    VoidCallback? onPressed,
    IconData? icon,
    String? svgPath,
    bool isHighlighted = false,
    required String text,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: svgPath.isNotNullEmpty
          ? SvgPicture.asset(
              'assets/svg/$svgPath',
              height: 16,
              color: isHighlighted
                  ? context.colorScheme.surface
                  : context.colorScheme.primary.withOpacity(.9),
            )
          : Icon(
              icon,
              size: 18,
              color: isHighlighted
                  ? context.colorScheme.onSurface
                  : context.colorScheme.primary.withOpacity(.9),
            ),
      style: TextButton.styleFrom(
        foregroundColor: isHighlighted
            ? context.colorScheme.surface
            : context.colorScheme.onSurface,
        // backgroundColor: isHighlighted ? context.colorScheme.surfaceTint : null,
      ),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isHighlighted
              ? context.colorScheme.onSurface
              : context.customColors.sourceMonkBlue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = newsCardPodProvider(metaData);
    final watchProvider = ref.watch(provider);
    final readProvider = ref.read(provider.notifier);
    final isVoted =
        watchProvider.threadMetaData.upvote ?? metaData.upvote == true;
    final isBookmarked =
        watchProvider.threadMetaData.bookmark ?? metaData.bookmark == true;

    ref.listen(provider, (prev, next) {
      if (next.estate == ENewsCardState.upVoted) {
        showMessage(
            context,
            next.threadMetaData.upvote == true
                ? "Upvoted successfully"
                : "Upvote removed successfully");
      } else if (next.estate == ENewsCardState.bookmarked) {
        showMessage(
            context,
            next.threadMetaData.bookmark == true
                ? "Bookmark added successfully"
                : "Bookmark removed successfully");
      } else if (next.estate == ENewsCardState.dismissed) {
        showMessage(context, "Dismissed successfully");
        final newsFeed = ref.read(newsFeedProvider.notifier);
        newsFeed.remove(metaData.id);
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (watchProvider.estate == ENewsCardState.upVoting)
          const CircularProgressIndicator.adaptive()
        else
          textIconButton(
            context,
            onPressed: () async {
              await readProvider.createTfThreadFlagPost(
                metaData.id,
                upvote: !isVoted,
              );
            },
            icon: Icons.arrow_upward,
            text: "Upvote",
            isHighlighted: isVoted,
          ),
        if (watchProvider.estate == ENewsCardState.bookmarking)
          const CircularProgressIndicator.adaptive()
        else
          textIconButton(
            context,
            onPressed: () async {
              await readProvider.createTfThreadFlagPost(
                metaData.id,
                bookmark: !isBookmarked,
              );
            },
            isHighlighted: isBookmarked,
            icon: isBookmarked ? Icons.bookmark : Icons.bookmark_outlined,
            text: "Bookmark",
          ),
        textIconButton(
          context,
          onPressed: () async {
            ref.read(newsFeedProvider.notifier).markAsRead(metaData.id);
            Navigator.push(
              context,
              ThreadPage.launchRoute(
                title: metaData.title,
                type: metaData.type,
              ),
            );
          },
          svgPath: 'open_in_new.svg',
          text: "View Details",
        ),
      ],
    );
  }
}
