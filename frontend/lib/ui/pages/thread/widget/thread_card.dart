import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/helper/utils.dart';
import 'package:frontend/main.dart';
import 'package:frontend/repo/auth/auth_provider.dart';
import 'package:frontend/ui/pages/thread/provider/thread.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/pages/thread/widget/provider/thread_card_provider.dart';
import 'package:frontend/ui/pages/thread/widget/todo-assign-view.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/cache_image.dart';
import 'package:frontend/ui/widgets/kit/alert.dart';
import 'package:frontend/ui/widgets/link_meta_card.dart';
import 'package:frontend/ui/widgets/markdown/markdown_viewer.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart';

class ThreadCard extends ConsumerWidget {
  const ThreadCard({
    super.key,
    required this.block,
    required this.emojiParser,
    required this.topic,
    required this.type,
    required this.mainThreadId,
    required this.threadType,
  });
  final BlockWithCreator block;
  final String type;
  final String topic;
  final EmojiParser emojiParser;
  final String? mainThreadId;
  final ThreadType threadType;

  Future<void> assignTodo(BuildContext context, WidgetRef ref,
      ThreadCardProvider cardProvider) async {
    final user = await Alert.dialog<UserModel?>(
      context,
      barrierDismissible: true,
      constraints: BoxConstraints(
        maxWidth: context.width * .5,
        minWidth: 200,
        maxHeight: 300,
        minHeight: 200,
      ),
      child: const TodoAssignView(),
    );

    if (user != null) {
      final threadNotifier = ref
          .read(currentThreadProvider.call(topic: topic, type: type).notifier);
      // final assignTodoModel = AssignTodoModel(
      //   blockId: block.id!,
      //   userId: user.id!,
      // );
      // await threadNotifier.assignTodoToUser(block.id!, user.id);
      await ref.read(cardProvider.notifier).assignTodoToUser(user.id);
    }
  }

  Future<void> onReplyClick(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (block.id.isNullOrEmpty || mainThreadId.isNullOrEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thread Id or Block Id is missing'),
        ),
      );
      return;
    }
    try {
      final threadNotifier = ref
          .read(currentThreadProvider.call(topic: topic, type: type).notifier);
      final childThreadName =
          ("Reply$topic${block.id?.substring(0, 4)}").replaceAll('-', '');
      if (block.childThreadId.isNullOrEmpty) {
        final createChildThreadModel = CreateChildThreadModel(
          topic: childThreadName,
          type: type,
          parentBlockId: block.id!,
          mainThreadId: mainThreadId!,
        );
        loader.showLoader(context, message: 'Creating Thread');
        final newThread =
            await threadNotifier.createChildThread(createChildThreadModel);

        // Navigate to child thread page
        if (newThread != null && newThread.id.isNotNullEmpty) {
          showMessage(context, 'Thread created successfully');
          Navigator.push(
              context,
              ThreadPage.launchRoute(
                topic: childThreadName,
                type: type,
                threadType: ThreadType.reply,
              ));
          logger.d('Thread created successfully');
        } else {
          showMessage(context, 'Failed to create thread');
        }
      } else {
        final replyThread =
            await threadNotifier.fetchThreadFromIdAsync(block.childThreadId!);
        Navigator.push(
          context,
          ThreadPage.launchRoute(
            topic: replyThread!.topic,
            type: replyThread.type,
            threadType: ThreadType.reply,
            threadChildId: block.childThreadId,
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
    final authState = ref.watch(authProvider);
    final authUserId = authState.value?.session?.userId;
    final creatorId = block.creatorId;
    final isCreator = creatorId == authUserId;

    final cardProvider = threadCardProvider.call(block, type);
    final card = ref.watch(cardProvider);
    final isEdit = card.eState == EThreadCardState.edit;
    final isHovered = card.hoverEnabled;
    final taskStatus = card.taskStatus;
    final dueDate = card.block.dueDate ?? block.dueDate;
    final assignedTo = card.block.assignedTo ?? block.assignedTo;

    final controller = TextEditingController(text: block.content);
    // print(
    //     'ThreadCard: ${block.id}.Block status: ${block.taskStatus}  State Status: $taskStatus');
    //print(block.creatorId?.toString());
    final userInfo = block.creator;
    //print('userInfo: $userInfo');
    // final replyProvider = threadDetailProvider.call();
    final provider = currentThreadProvider.call(topic: topic, type: type);
    // final currentThread = ref.watch(provider);
    final currentThreadNotifier = ref.read(provider.notifier);

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
                      borderRadius: BorderRadius.circular(20),
                      child: CacheImage(
                        path: userInfo.picture!.startsWith('https')
                            ? userInfo.picture!
                            : "https://api.dicebear.com/7.x/identicon/png?seed=${userInfo.name!}",
                        fit: BoxFit.fitHeight,
                        tag: UniqueKey().toString(),
                        height: 25,
                        width: 25,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          userInfo.name!,
                          style: context.textTheme.bodySmall?.copyWith(
                            color:
                                context.colorScheme.onSurface.withOpacity(.6),
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 16,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  context.colorScheme.onSurface.withOpacity(.6),
                              width: 1,
                            ),
                          ),
                        ),
                        if (block.createdAt != null)
                          Text(
                            DateFormat('dd MMM yyyy')
                                .format(block.createdAt!.toLocal()),
                            style: context.textTheme.bodySmall?.copyWith(
                              color:
                                  context.colorScheme.onSurface.withOpacity(.6),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),

                // TOOLS - Update task status
                // Display task status icon only `new-task` type thread
                if (type == 'todo')
                  if (taskStatus == ETaskStatus.loading)
                    const CircularProgressIndicator.adaptive()
                  else
                    InkWell(
                      onTap: () async {
                        await ref
                            .read(cardProvider.notifier)
                            .setTaskStatus(taskStatus == ETaskStatus.done
                                ? ETaskStatus.inProgress
                                : taskStatus == ETaskStatus.todo
                                    ? ETaskStatus.inProgress
                                    : ETaskStatus.done);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/${taskStatus.svgIcon}",
                            color: taskStatus.bgColor,
                            height: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            taskStatus.name,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: taskStatus.bgColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                if ((DateTime.now()
                        .difference(block.createdAt ?? DateTime.now())
                        .inHours) <
                    24) ...[
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.yellow.shade200,
                    radius: 4,
                  ),
                ],
              ],
            ),
            Divider(
              color: context.customColors.monkBlue!.withOpacity(.5),
              thickness: .6,
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
              // SelectableText(
              //   emojiParser.emojify(block.content.toString()).trimRight(),
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.w400,
              //     color: Theme.of(context).colorScheme.onSurface,
              //   ),
              // ),
              MarkdownViewer(
                markdownData: block.content,
                onTapLink: (String? text, String? href, String? topic) {
                  launch(href);
                },
              ),
            const SizedBox(height: 8),

            if (block.image != null) ...[
              const SizedBox(height: 8),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .3,
                  maxWidth: MediaQuery.of(context).size.width,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: CacheImage(
                  path: block.image!,
                  fit: BoxFit.fitHeight,
                  tag: UniqueKey().toString(),
                ),
              ),
            ],
            LinkMetaCard(linkMeta: block.linkMeta),

            if (type == 'todo') ...[
              Divider(
                color: context.customColors.monkBlue!.withOpacity(.5),
                thickness: .2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (card.assigningTask)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  else
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: context.customColors.sourceMonkBlue,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Assigned to:',
                          style: context.textTheme.bodySmall?.copyWith(
                            color:
                                context.colorScheme.onSurface.withOpacity(.6),
                          ),
                        ),
                        if (assignedTo != null) ...[
                          const SizedBox(width: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CacheImage(
                              path: assignedTo.picture!,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            assignedTo.name ?? 'N/A',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurface,
                              fontSize: 12,
                            ),
                          ),
                        ] else
                          TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              onPressed: () =>
                                  assignTodo(context, ref, cardProvider),
                              child: Text(
                                'Please assign',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontSize: 12,
                                ),
                              ))
                      ],
                    ),
                  if (card.addingDueDate)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  else
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: context.customColors.sourceMonkBlue,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            text: 'Due Date:',
                            style: context.textTheme.bodySmall?.copyWith(
                              color:
                                  context.colorScheme.onSurface.withOpacity(.6),
                            ),
                            children: [
                              if (dueDate != null)
                                TextSpan(
                                  text:
                                      ' ${DateFormat('dd MMM yyyy').format(dueDate ?? DateTime.now())}',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: Colors.amber,
                                    fontSize: 12,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2025),
                                      );
                                      if (date != null) {
                                        logger.d('Selected Date: $date');
                                        await ref
                                            .read(cardProvider.notifier)
                                            .addDueDate(date);
                                      }
                                    },
                                )
                              else
                                TextSpan(
                                  text: ' Please add',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.onSurface,
                                    fontSize: 12,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2025),
                                      );
                                      if (date != null) {
                                        logger.d('Selected Date: $date');
                                        await ref
                                            .read(cardProvider.notifier)
                                            .addDueDate(date);
                                      }
                                    },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              )
            ],
            // Reply/Replies Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (threadType == ThreadType.thread) ...[
                  TextButton.icon(
                    icon: const Icon(
                      Icons.reply_rounded,
                      size: 15,
                    ),
                    onPressed: () async => onReplyClick(context, ref),
                    label: Text(
                      block.childThreadId.isNotNullEmpty
                          ? "Replies"
                          : 'Reply in Thread',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  )
                ] else
                  const SizedBox(height: 40),

                // TOOLS - Edit thread icon
                Row(
                  children: [
                    // Display Edit thread icon to only thread creator and on hover
                    if (isHovered && !isEdit && isCreator)
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
                                        .call(topic: topic, type: type)
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
          ],
        ),
      ),
    );
  }
}
