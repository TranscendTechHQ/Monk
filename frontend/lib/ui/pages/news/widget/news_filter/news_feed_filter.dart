import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/news/widget/news_filter/provider/news_feed_filter_provider.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/dismiss_button.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';

class NewsFeedFilterView extends ConsumerStatefulWidget {
  const NewsFeedFilterView({super.key});

  @override
  NewsFeedFilterViewState createState() => NewsFeedFilterViewState();
}

class NewsFeedFilterViewState extends ConsumerState<NewsFeedFilterView> {
  late TextEditingController textEditorController;

  @override
  void initState() {
    final readState = ref.read(newsFeedFilterProvider.notifier);
    textEditorController =
        TextEditingController(text: readState.state.value!.semanticQuery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final watchState = ref.watch(newsFeedFilterProvider);

    final readState = ref.read(newsFeedFilterProvider.notifier);
    // final textEditorController =
    //     TextEditingController(text: readState.state.semanticQuery);
    return watchState.maybeWhen(
        orElse: () => Container(),
        data: (state) => Container(
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
                  // CheckboxListTile(
                  //     value: state.unRead,
                  //     side: const BorderSide(color: monkBlue700, width: 2),
                  //     onChanged: (val) async {
                  //       await readState.updateFilter(unRead: val);
                  //     },
                  //     title: const Text('Unread')),
                  CheckboxListTile(
                      value: state.bookmarked,
                      side: const BorderSide(color: monkBlue700, width: 2),
                      onChanged: (val) async {
                        await readState.updateFilter(bookmarked: val);
                      },
                      title: const Text('Bookmarked')),
                  CheckboxListTile(
                      value: state.upvoted,
                      side: const BorderSide(color: monkBlue700, width: 2),
                      onChanged: (val) async {
                        await readState.updateFilter(upvoted: val);
                      },
                      title: const Text('Upvoted')),
                  CheckboxListTile(
                      value: state.mentioned,
                      side: const BorderSide(color: monkBlue700, width: 2),
                      onChanged: (val) async {
                        await readState.updateFilter(mentioned: val);
                      },
                      title: const Text('Mentioned')),
                  CheckboxListTile(
                      value: state.dismissed,
                      side: const BorderSide(color: monkBlue700, width: 2),
                      onChanged: (val) async {
                        await readState.updateFilter(dismissed: val);
                      },
                      title: const Text('Dismissed')),
                  // const Padding(padding: EdgeInsets.all(8)),
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //   alignment: Alignment.centerLeft,
                  //   child: const Text(
                  //     'Semantic Filter.',
                  //     style:
                  //         TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // TextFormField(
                  //   // initialValue: state.semanticQuery,
                  //   controller: textEditorController,
                  //   onChanged: (val) async {
                  //     // await readState.updateSemanticQuery(val);
                  //   },
                  //   maxLines: null,
                  //   decoration: InputDecoration(
                  //     hintText:
                  //         'Describe in plain english the kind of threads you want to see in the newsfeed.',
                  //     hintStyle: context.textTheme.bodyMedium?.copyWith(
                  //       color: context.colorScheme.onSurface.withOpacity(.4),
                  //     ),
                  //     constraints: const BoxConstraints(
                  //       minHeight: 40,
                  //       maxHeight: 150,
                  //     ),
                  //     enabledBorder: const OutlineInputBorder(
                  //       borderSide: BorderSide(color: monkBlue700),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide:
                  //           BorderSide(color: monkBlue700.withOpacity(.9)),
                  //     ),
                  //     border: const OutlineInputBorder(
                  //       borderSide: BorderSide(color: monkBlue700),
                  //     ),
                  //     fillColor: context.colorScheme.background,
                  //   ),
                  // ).hP16,
                  const Padding(padding: EdgeInsets.all(8)),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      OutlineIconButton(
                        label: 'Reset',
                        onPressed: () async {
                          await readState.updateFilter(
                            unRead: false,
                            bookmarked: false,
                            upvoted: false,
                            dismissed: false,
                            mentioned: false,
                          );
                          textEditorController.clear();
                        },
                        horizontalPadding: 36,
                        verticalPadding: 16,
                      ),
                      OutlineIconButton(
                        label: 'Apply',
                        onPressed: () {
                          // final state = ref.read(newsFeedFilterProvider.notifier);

                          Navigator.pop(context, {
                            'unRead': state.unRead,
                            'bookmarked': state.bookmarked,
                            'upvoted': state.upvoted,
                            'dismissed': state.dismissed,
                            'mention': state.mentioned,
                            'searchQuery': textEditorController.text,
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
            ));
  }
}
