import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/repo/user_provider.dart';
import 'package:frontend/ui/pages/thread/page/provider/thread_detail_provider.dart';
import 'package:frontend/ui/pages/widgets/commandbox.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart';

class ThreadDetailPage extends ConsumerWidget {
  final BlockWithCreator? block;
  final String parentBlockId;
  final String type;
  final String mainThreadId;
  final String title;
  const ThreadDetailPage({
    super.key,
    required this.title,
    required this.type,
    this.block,
    required this.parentBlockId,
    required this.mainThreadId,
  });

  static String route = "/thread-detail";
  static Route launchRoute(
      {required String title,
      required String type,
      required String parentBlockId,
      required String mainThreadId,
      BlockWithCreator? block}) {
    return MaterialPageRoute<void>(
      builder: (_) => ThreadDetailPage(
        title: title,
        type: type,
        parentBlockId: parentBlockId,
        block: block,
        mainThreadId: mainThreadId,
      ),
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
    CreateChildThreadModel(
      title: title,
      type: type,
      parentBlockId: parentBlockId,
      mainThreadId: mainThreadId,
    );
    final provider = threadDetailProvider.call();
    // provider.fetchThreadFromIdAsync(parentBlockId);createChildThreadModel:

    // ref.read(provider.notifier).createOrFetchReplyThread({});
    final currentThread = ref.watch(provider);

    final blockInput = CommandBox(title: title, type: type);

    return Scaffold(
      appBar: AppBar(
        title: Text('$formatType -: $title',
            style: TextStyle(
                fontSize: 20, color: Theme.of(context).colorScheme.onSurface)),
      ),
      body: PageScaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                  child: currentThread.when(
                data: (state) => RepliesListView(
                  replies: state.thread?.content?.reversed.toList(),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    error.toString().replaceFirst('Exception: ', ''),
                    style: context.textTheme.bodySmall,
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              )),
              blockInput,
            ],
          ),
        ),
      ),
    );
  }
}

class RepliesListView extends ConsumerWidget {
  RepliesListView({super.key, required this.replies});

  final List<BlockWithCreator>? replies;

  final scrollController = ScrollController();
  scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  final emojiParser = EmojiParser(init: true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: containerWidth,
      alignment: Alignment.topLeft,
      child: ListView.builder(
        controller: scrollController,
        itemCount: replies?.length ?? 0,
        reverse: true,
        padding: const EdgeInsets.only(bottom: 30),
        itemBuilder: (context, index) {
          final block = replies?[index];
          return ReplyCard(block: block!, emojiParser: emojiParser);
        },
      ),
    );
  }
}

class ReplyCard extends ConsumerWidget {
  const ReplyCard({super.key, required this.block, required this.emojiParser});
  final BlockWithCreator block;
  final EmojiParser emojiParser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = block.creator;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecorations.cardDecoration(context),
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
                      userInfo.picture!.startsWith('https')
                          ? userInfo.picture!
                          : "https://api.dicebear.com/7.x/identicon/png?seed=${userInfo.name ?? "UN"}",
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
                        '${userInfo.name}',
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
