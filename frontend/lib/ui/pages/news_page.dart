import 'package:frontend/helper/combine_async.dart';
import 'package:frontend/repo/news_provider.dart';
import 'package:frontend/ui/pages/thread_page.dart';
import 'package:frontend/ui/pages/widgets/commandbox.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/repo/thread.dart';

import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:openapi/openapi.dart';

class NewsPage extends StatelessWidget {
  final String title;
  final String type;
  const NewsPage({super.key, required this.title, required this.type});

  static String route = "/news";

  static Route launchRoute() {
    return MaterialPageRoute<void>(
        builder: (_) => const NewsPage(title: "News", type: "/news"));
  }

  @override
  Widget build(BuildContext context) {
    final blockInput = CommandBox(
      title: title,
      type: type,
      allowedInputTypes: const [
        InputBoxType.commandBox,
        InputBoxType.searchBox,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News',
          style: TextStyle(fontSize: 20, color: context.colorScheme.onSurface),
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(child: ChatListView()),
            blockInput,
            const Padding(padding: EdgeInsets.all(8))
          ],
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
    final threadHeadlineListAsync =
        ref.watch(fetchThreadsHeadlinesAsyncProvider);
    final threadHeadlineMetaDataAsync =
        ref.watch(fetchThreadsMdMetaDataAsyncProvider);

    final combo =
        combineAsync2(threadHeadlineListAsync, threadHeadlineMetaDataAsync);

    return combo.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (tuple) {
        final threadHeadlineList = tuple.item1;
        final threadMetaDataList = tuple.item2;
        return SizedBox(
          width: containerWidth,
          child: ListView.builder(
            reverse: true,
            controller: scrollController,
            itemCount: threadHeadlineList.length,
            padding: const EdgeInsets.only(bottom: 30),
            itemBuilder: (context, index) {
              final headlineModel = threadHeadlineList[index];
              final metaData = threadMetaDataList
                  .firstWhere((element) => element.id == headlineModel.id);
              return NewsCard(headlineModel: headlineModel, metaData: metaData);
            },
          ),
        );
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard(
      {super.key, required this.headlineModel, required this.metaData});

  final ThreadHeadlineModel headlineModel;
  final ThreadMetaData metaData;

  @override
  Widget build(BuildContext context) {
    final title = headlineModel.title;
    final headline = headlineModel.headline;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
              context,
              ThreadPage.launchRoute(
                  title: metaData.title, type: metaData.type));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.colorScheme.primary,
              width: .3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'NotoEmoji',
                  fontWeight: FontWeight.w400,
                  color: context.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                headline,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'NotoEmoji',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: context.colorScheme.onSurface.withOpacity(.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
