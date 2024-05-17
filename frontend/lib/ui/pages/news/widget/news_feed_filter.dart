import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/theme/theme.dart';

class NewsFeedFilter extends ConsumerStatefulWidget {
  const NewsFeedFilter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsFeedFilterState createState() => _NewsFeedFilterState();
}

class _NewsFeedFilterState extends ConsumerState<NewsFeedFilter> {
  bool unRead = false, bookmarked = false, upvoted = false, dismissed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      constraints: const BoxConstraints(
        maxWidth: 400,
        maxHeight: 400,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: context.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 16,
                      color: context.colorScheme.onSecondary,
                    ),
                  ),
                ).pH(8),
                CloseButton(
                  style: ButtonStyle(
                    maximumSize: MaterialStateProperty.all(
                      const Size(40, 40),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      const Size(20, 20),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(0),
                    ),
                    iconSize: MaterialStateProperty.all(14.0),
                    backgroundColor: MaterialStateProperty.all(
                        context.customColors.alertContainer),
                  ),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          CheckboxListTile(
              value: unRead,
              onChanged: (val) {
                setState(() {
                  unRead = val!;
                });
              },
              title: const Text('Unread')),
          CheckboxListTile(
              value: bookmarked,
              onChanged: (val) {
                setState(() {
                  bookmarked = val!;
                });
              },
              title: const Text('Bookmarked')),
          CheckboxListTile(
              value: upvoted,
              onChanged: (val) {
                setState(() {
                  upvoted = val!;
                });
              },
              title: const Text('Upvoted')),
          CheckboxListTile(
              value: dismissed,
              onChanged: (val) {
                setState(() {
                  dismissed = val!;
                });
              },
              title: const Text('Dismissed')),
          const Padding(padding: EdgeInsets.all(8)),
          FilledButton.tonal(
            onPressed: () async {
              Navigator.pop(context, {
                'unRead': unRead,
                'bookmarked': bookmarked,
                'Upvoted': upvoted,
                'dismissed': dismissed,
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: context.colorScheme.onSurface,
            ),
            child: const Text('Apply Filter'),
          ),
        ],
      ),
    );
  }
}
