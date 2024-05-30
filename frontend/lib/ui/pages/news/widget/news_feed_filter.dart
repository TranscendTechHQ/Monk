import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/dismiss_button.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';

class NewsFeedFilter extends ConsumerStatefulWidget {
  const NewsFeedFilter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsFeedFilterState createState() => _NewsFeedFilterState();
}

class _NewsFeedFilterState extends ConsumerState<NewsFeedFilter> {
  bool unRead = false,
      bookmarked = false,
      upvoted = false,
      dismissed = false,
      mention = false;
  @override
  Widget build(BuildContext context) {
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
              value: unRead,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                setState(() {
                  unRead = val!;
                });
              },
              title: const Text('Unread')),
          CheckboxListTile(
              value: bookmarked,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                setState(() {
                  bookmarked = val!;
                });
              },
              title: const Text('Bookmarked')),
          CheckboxListTile(
              value: upvoted,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                setState(() {
                  upvoted = val!;
                });
              },
              title: const Text('Upvoted')),
          CheckboxListTile(
              value: mention,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                setState(() {
                  mention = val!;
                });
              },
              title: const Text('Mentioned')),
          CheckboxListTile(
              value: dismissed,
              side: const BorderSide(color: monkBlue700, width: 2),
              onChanged: (val) {
                setState(() {
                  dismissed = val!;
                });
              },
              title: const Text('Dismissed')),
          const Padding(padding: EdgeInsets.all(8)),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              OutlineIconButton(
                label: 'Reset',
                onPressed: () {
                  setState(() {
                    unRead = false;
                    bookmarked = false;
                    upvoted = false;
                    dismissed = false;
                  });
                },
                horizontalPadding: 36,
                verticalPadding: 16,
              ),
              OutlineIconButton(
                label: 'Apply',
                onPressed: () {
                  Navigator.pop(context, {
                    'unRead': unRead,
                    'bookmarked': bookmarked,
                    'Upvoted': upvoted,
                    'dismissed': dismissed,
                    'mention': mention
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
