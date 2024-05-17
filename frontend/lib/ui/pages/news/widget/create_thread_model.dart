import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/utils.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/pages/news/widget/provider/create_thread_provider.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/theme/theme.dart';

import '../../../theme/color/custom_color.g.dart';

class CreateThreadModal extends ConsumerWidget {
  const CreateThreadModal(
      {super.key, this.type = 'chat', required this.titlesList});
  final String type;
  final List<String> titlesList;

  static Future<void> show(BuildContext context,
      {required List<String> titlesList, required String type}) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.center,
          elevation: 0.0,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: context.colorScheme.secondaryContainer,
          child: CreateThreadModal(titlesList: titlesList, type: type),
        );
      },
    );
  }

  Future<void> createThread(
      BuildContext context, WidgetRef ref, String title, String message) async {
    if (title.isNullOrEmpty) {
      showMessage(context, 'Title is required');
      return;
    }

    // final threadList =  ref.read(fetchThreadsInfoProvider);
    final createThreadNotifier = createThreadPodProvider.notifier;

    if (titlesList.contains(title)) {
      showMessage(context, 'Thread with title $title already exists');
      return;
    } else {
      loader.showLoader(context, message: 'Creating Thread');
      final thread = await ref.read(createThreadNotifier).createThread(
            title: title,
            type: type,
          );
      loader.hideLoader();
      if (thread != null && message.isNullOrEmpty) {
        print('Thread is created. No message available.');
        Navigator.of(context).pop();
        Navigator.of(context).push(
          ThreadPage.launchRoute(title: title, type: type),
        );
      }
      // If thread is not null, then create a new block
      else if (thread != null) {
        print('Thread is created. Creating first block');
        loader.showLoader(context, message: 'Creating block');
        final block = await await ref
            .read(createThreadNotifier)
            .createBlock(message, thread.title, thread.id);
        loader.hideLoader();
        if (block != null) {
          print('Block is created');
          // Close current Model
          Navigator.of(context).pop();

          // Open Thread Page
          Navigator.of(context).push(
            ThreadPage.launchRoute(title: title, type: type),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16),
      constraints:
          const BoxConstraints(maxWidth: 400, maxHeight: 400, minHeight: 200),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer.withOpacity(.5),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: context.customColors.monkBlue!,
          width: .3,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(type == "chat" ? 'New Thread' : "New Todo",
                  style: context.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w400)),
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
          const SizedBox(height: 8),
          Divider(
            color: context.customColors.monkBlue!,
            thickness: .2,
          ),
          const SizedBox(height: 16),
          Text(
            type == 'chat' ? 'Thread Title' : 'Todo Title',
            style: context.textTheme.bodySmall?.copyWith(
              color: monkBlue,
            ),
          ),
          TextField(
            maxLength: 120,
            controller: titleController,
            autofocus: true,
            onSubmitted: (value) => createThread(
              context,
              ref,
              titleController.text,
              messageController.text,
            ),
            decoration: InputDecoration(
                hintText: 'Type in ...',
                filled: false,
                hintStyle: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(.4),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: monkBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: context.colorScheme.onSurface.withOpacity(.8)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: context.colorScheme.onSurface.withOpacity(.8)),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: context.colorScheme.error.withOpacity(.8)),
                )),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          Text(
            'First Message',
            style: context.textTheme.bodySmall?.copyWith(
              color: monkBlue,
            ),
          ),
          TextFormField(
            minLines: 1,
            maxLines: 4,
            maxLength: 140,
            controller: messageController,
            decoration: InputDecoration(
              hintText: 'Type in ...',
              filled: false,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: monkBlue),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: context.colorScheme.onSurface.withOpacity(.8)),
              ),
              hintStyle: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withOpacity(.4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: FilledButton.tonal(
              onPressed: () async => createThread(
                context,
                ref,
                titleController.text,
                messageController.text,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(monkBlue700),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Create',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
