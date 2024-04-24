import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart';
import 'package:frontend/repo/thread.dart';

import 'package:frontend/ui/pages/thread/page/provider/thread_detail_provider.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/pages/thread/widget/provider/thread_card_provider.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart';

class ThreadCard extends ConsumerWidget {
  const ThreadCard({
    super.key,
    required this.block,
    required this.emojiParser,
    required this.title,
    required this.type,
    required this.parentThreadId,
  });
  final BlockWithCreator block;
  final String type;
  final String title;
  final EmojiParser emojiParser;
  final String? parentThreadId;

  Future<void> onReplyClick(BuildContext context, WidgetRef ref,
      ThreadDetailProvider replyProvider) async {
    if (block.id.isNullOrEmpty || parentThreadId.isNullOrEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thread Id or Block Id is missing'),
        ),
      );
      return;
    }
    try {
      final childThreadName =
          ("Reply$title${block.id?.substring(0, 4)}").replaceAll('-', '');
      if (block.childId.isNullOrEmpty) {
        final createChildThreadModel = CreateChildThreadModel(
          title: childThreadName,
          type: type,
          parentBlockId: block.id!,
          parentThreadId: parentThreadId!,
        );
        loader.showLoader(context, message: 'Creating Thread');
        final state = await ref
            .read(replyProvider.notifier)
            .createOrFetchReplyThread(
              createChildThreadModel:
                  block.childId.isNullOrEmpty ? createChildThreadModel : null,
              childThreadId: block.childId.isNullOrEmpty ? '' : block.childId!,
            );

        if (state.thread != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thread created successfully'),
            ),
          );
          Navigator.push(
              context,
              ThreadPage.launchRoute(
                title: childThreadName,
                type: type,
                threadType: ThreadType.reply,
              ));
          ref
              .read(
                  currentThreadProvider.call(title: title, type: type).notifier)
              .addChildThreadIdToBlock(
                state.thread!.id!,
                block.id!,
              );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to create thread'),
            ),
          );
        }
      } else {
        Navigator.push(
          context,
          ThreadPage.launchRoute(
            title: childThreadName,
            type: type,
            threadType: ThreadType.reply,
            threadChildId: block.childId,
          ),
        );
      }
    } catch (e) {
      logger.e('Error onReplyClick: $e');
    } finally {
      loader.hideLoader();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardProvider = threadCardProvider.call(block, type);
    final card = ref.watch(cardProvider);
    final isEdit = card.eState == EThreadCardState.edit;
    final isHovered = card.hoverEnabled;
    final controller = TextEditingController(text: block.content);

    //print(block.creatorId?.toString());
    final userInfo = block.creator;
    //print('userInfo: $userInfo');
    final replyProvider = threadDetailProvider.call();
    ref.listen(replyProvider, (previous, next) {
      if (next is AsyncData) {
        final data = next.value;

        // Add childThreadId in block when child thread is created
        if (data?.thread != null && data!.thread!.id.isNotNullEmpty) {
          ref
              .read(
                  currentThreadProvider.call(title: title, type: type).notifier)
              .addChildThreadIdToBlock(
                data.thread!.id!,
                block.id!,
              );
        }
      }
    });

    return MouseRegion(
      onEnter: (event) {
        ref.read(cardProvider.notifier).onHoverEnter();
      },
      onExit: (event) {
        ref.read(cardProvider.notifier).onHoverExit();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecorations.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        userInfo!.picture!.startsWith('https')
                            ? userInfo.picture!
                            : "https://api.dicebear.com/7.x/identicon/png?seed=${userInfo.name!}",
                        width: 25,
                        height: 25,
                        cacheHeight: 30,
                        cacheWidth: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userInfo.name!}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        if (block.createdAt != null)
                          Text(
                            DateFormat('dd MMM yyyy')
                                .format(block.createdAt!.toLocal()),
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
                  ],
                ),
                const Spacer(),

                if (!isHovered &&
                    (DateTime.now()
                            .difference(block.createdAt ?? DateTime.now())
                            .inHours) <
                        24)
                  CircleAvatar(
                    backgroundColor: Colors.yellow.shade200,
                    radius: 4,
                  ),
                // TOOLS
                Row(
                  children: [
                    if (isHovered && !isEdit)
                      InkWell(
                        onTap: () {
                          ref.read(cardProvider.notifier).toggleEdit();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isEdit ? Icons.cancel : Icons.edit,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 15,
                          ),
                        ),
                      ),
                    if (isHovered || isEdit)
                      Row(
                        children: [
                          if (isEdit)
                            IconButton(
                              onPressed: () {
                                ref.read(cardProvider.notifier).toggleEdit();
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          if (isEdit)
                            IconButton(
                              onPressed: () async {
                                await ref
                                    .read(currentThreadProvider
                                        .call(title: title, type: type)
                                        .notifier)
                                    .updateBlock(block.id!, controller.text);
                                ref.read(cardProvider.notifier).toggleEdit();
                              },
                              icon: Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                        ],
                      )
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            if (isEdit)
              TextField(
                controller: controller,
                onChanged: (val) {},
                autofocus: true,
                maxLength: null,
                maxLines: null,
                style: context.textTheme.bodySmall,
                decoration: InputDecoration(
                  hintText: 'Update your content here',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.7),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  fillColor: context.colorScheme.surface,
                ),
                // cursorHeight: 18,
              )
            else
              SelectableText(
                emojiParser.emojify(block.content.toString()).trimRight(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async => onReplyClick(context, ref, replyProvider),
              child: Text(
                block.childId.isNotNullEmpty ? "Replies" : 'Reply in Thread',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.customColors.sourceMonkBlue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
