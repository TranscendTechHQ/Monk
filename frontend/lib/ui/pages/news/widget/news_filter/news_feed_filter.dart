import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/news/widget/news_filter/provider/news_feed_filter_provider.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/dismiss_button.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';

class NewsFeedFilterView extends ConsumerWidget {
  const NewsFeedFilterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchState = ref.watch(newsFeedFilterProvider);

    final readState = ref.read(newsFeedFilterProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxWidth: context.width * .6,
        minWidth: 300,
        maxHeight: context.width * .7,
        minHeight: 200,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer.withOpacity(.5),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: context.customColors.monkBlue!,
          width: .3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Filter',
                  style: context.textTheme.titleLarge,
                ),
              ),
              DismissButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                tooltip: 'Close',
              ).p(8)
            ],
          ),
          Divider(
            color: context.customColors.monkBlue!.withOpacity(.5),
            thickness: .5,
          ),
          const Padding(padding: EdgeInsets.all(8)),
          CheckboxListTile(
              value: watchState.unRead,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                readState.updateFilter(unRead: val);
              },
              title: const Text('Unread')),
          CheckboxListTile(
              value: watchState.bookmarked,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                readState.updateFilter(bookmarked: val);
              },
              title: const Text('Bookmarked')),
          CheckboxListTile(
              value: watchState.upvoted,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                readState.updateFilter(upvoted: val);
              },
              title: const Text('Upvoted')),
          CheckboxListTile(
              value: watchState.mentioned,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                readState.updateFilter(mentioned: val);
              },
              title: const Text('Mentioned')),
          CheckboxListTile(
              value: watchState.dismissed,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                readState.updateFilter(dismissed: val);
              },
              title: const Text('Dismissed')),
          const Padding(padding: EdgeInsets.all(8)),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              OutlineIconButton(
                label: 'Reset',
                onPressed: () {
                  readState.updateFilter(
                    unRead: false,
                    bookmarked: false,
                    upvoted: false,
                    dismissed: false,
                    mentioned: false,
                    semanticQuery: '',
                  );
                },
                horizontalPadding: 36,
                verticalPadding: 16,
              ),
              OutlineIconButton(
                label: 'Apply',
                onPressed: () {
                  // final state = ref.read(newsFeedFilterProvider.notifier);
                  // state.updateFilter(
                  //   bookmarked: bookmarked,
                  //   unRead: unRead,
                  //   upvoted: upvoted,
                  //   mentioned: mention,
                  //   dismissed: dismissed,
                  // );
                  Navigator.pop(context, {
                    'unRead': watchState.unRead,
                    'bookmarked': watchState.bookmarked,
                    'Upvoted': watchState.upvoted,
                    'dismissed': watchState.dismissed,
                    'mention': watchState.mentioned
                  });
                },
                horizontalPadding: 36,
                verticalPadding: 16,
                isFilled: true,
              )
            ],
          )
        ],
      ),
    );
  }
}
