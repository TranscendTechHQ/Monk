import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/combine_async.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/repo/news_provider.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/pages/widgets/commandbox.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';
import 'package:intl/intl.dart';
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
      // appBar: AppBar(
      //   title: Text(
      //     'News',
      //     style: TextStyle(fontSize: 20, color: context.colorScheme.onSurface),
      //   ),
      // ),
      body: PageScaffold(
        body: WithMonkAppbar(
          child: Container(
            padding: const EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(child: ChatListView()),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: containerWidth / 1.5,
                  child: blockInput,
                ),
                const Padding(padding: EdgeInsets.all(8))
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
        return Container(
          width: containerWidth,
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                width: constraints.maxWidth / 2,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: threadHeadlineList.length,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemBuilder: (context, index) {
                    final headlineModel = threadHeadlineList[index];
                    if (threadMetaDataList.isEmpty) return const SizedBox();
                    final metaData = threadMetaDataList.firstWhereOrNull(
                        (element) => element.id == headlineModel.id);
                    if (metaData == null) return const SizedBox();
                    return NewsCard(
                      headlineModel: headlineModel,
                      metaData: metaData,
                    );
                  },
                ),
              );
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
    final creator = metaData.creator;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              ThreadPage.launchRoute(
                  title: metaData.title, type: metaData.type));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24) +
              const EdgeInsets.only(bottom: 22.0),
          decoration: BoxDecorations.cardDecoration(context),
          child: Column(
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
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (metaData.createdDate != null)
                        Text(
                          DateFormat('dd MMM yyyy').format(
                              DateTime.tryParse(metaData.createdDate)!
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
                    color: context.colorScheme.onSurface.withOpacity(.9),
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
