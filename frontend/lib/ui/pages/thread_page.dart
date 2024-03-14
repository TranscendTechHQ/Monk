import 'package:frontend/ui/pages/widgets/commandbox.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/repo/thread.dart';

import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:openapi/openapi.dart';

class ThreadPage extends ConsumerWidget {
  final String title;
  final String type;
  const ThreadPage({super.key, required this.title, required this.type});

  static String route = "/journal";
  static Route launchRoute({required String title, required String type}) {
    return MaterialPageRoute<void>(
      builder: (_) => ThreadPage(title: title, type: type),
    );
  }

  String get formatType {
    if (type.contains('-')) {
      return type.split('-')[1];
    } else if (type.contains('/')) {
      return type.split('/')[1];
    }
    return type;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThread =
        ref.watch(currentThreadProvider.call(title: title, type: type));
    final blockInput = CommandBox(title: title, type: type);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$formatType -: $title',
          style: TextStyle(
              fontSize: 20, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              child: currentThread.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ChatListView(currentThread: currentThread),
            ),
            blockInput,
          ],
        ),
      ),
    );
  }
}

class ChatListView extends ConsumerWidget {
  ChatListView({super.key, required this.currentThread});
  final AsyncValue<ThreadModel> currentThread;

  final scrollController = ScrollController();
  scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  final emojiParser = EmojiParser(init: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = currentThread.value?.content?.reversed.toList();
    return SizedBox(
      width: containerWidth,
      child: ListView.builder(
        reverse: true,
        controller: scrollController,
        itemCount: blocks?.length ?? 0,
        padding: const EdgeInsets.only(bottom: 30),
        itemBuilder: (context, index) {
          final block = blocks?[index];
          return ThreadCard(block: block!, emojiParser: emojiParser);
        },
      ),
    );
  }
}

class ThreadCard extends StatelessWidget {
  const ThreadCard({super.key, required this.block, required this.emojiParser});
  final BlockModel block;
  final EmojiParser emojiParser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: .3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      block.creatorPicture!.startsWith('https')
                          ? block.creatorPicture!
                          : "https://api.dicebear.com/7.x/identicon/png?seed=${block.createdBy ?? "UN"}",
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
                        '${block.createdBy}',
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
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            emojiParser.emojify(block.content.toString() ?? '').trimRight(),
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'NotoEmoji',
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
