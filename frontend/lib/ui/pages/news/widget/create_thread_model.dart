import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/utils.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/pages/news/widget/provider/create_thread_provider.dart';
import 'package:frontend/ui/pages/thread/thread_page.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart';

import '../../../theme/color/custom_color.g.dart';

class CreateThreadModal extends ConsumerStatefulWidget {
  const CreateThreadModal(
      {super.key, this.type = 'chat', required this.titlesList});
  final String type;
  final List<String> titlesList;

  static Future<FullThreadInfo?> show(BuildContext context,
      {required List<String> titlesList, required String type}) async {
    return await showDialog<FullThreadInfo?>(
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

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateThreadModal();
}

class _CreateThreadModal extends ConsumerState<CreateThreadModal> {
  List<String> get titlesList => widget.titlesList;
  String get type => widget.type;

  DateTime? dueDate;
  late TextEditingController titleController;
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> createThread(BuildContext context, WidgetRef ref, String title,
      {String? blockContent, DateTime? dueDate}) async {
    if (title.isNullOrEmpty) {
      showMessage(context, 'Title is required');
      return;
    }

    // final threadList =  ref.read(fetchThreadsInfoProvider);
    final createThreadNotifier = createThreadPodProvider.notifier;

    if (widget.titlesList.contains(title)) {
      showMessage(context, 'Thread with title $title already exists');
      return;
    } else {
      loader.showLoader(context, message: 'Creating Thread');
      final thread = await ref.read(createThreadNotifier).createThread(
            title: title,
            type: type,
          );
      loader.hideLoader();
      if (thread != null && blockContent.isNullOrEmpty) {
        print('Thread is created. No message available.');
        Navigator.of(context).pop(thread);
        Navigator.of(context).push(
          ThreadPage.launchRoute(title: title, type: type),
        );
      }
      // Create block if blockContent is available and thread is not null
      else if (thread != null) {
        print('Thread is created. Creating first block');
        loader.showLoader(context, message: 'Creating block');
        final block = await await ref.read(createThreadNotifier).createBlock(
            blockContent!, thread.title, thread.id,
            dueDate: dueDate);
        loader.hideLoader();
        if (block != null) {
          print('Block is created');
          // Close current Model
          Navigator.of(context).pop(thread);

          // Open Thread Page
          Navigator.of(context).push(
            ThreadPage.launchRoute(title: title, type: type),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints:
          const BoxConstraints(maxWidth: 400, maxHeight: 600, minHeight: 200),
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
            maxLength: 60,
            controller: titleController,
            autofocus: true,
            onSubmitted: (value) => createThread(
              context,
              ref,
              titleController.text,
              blockContent: messageController.text,
              dueDate: dueDate,
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
          if (type == 'todo') ...[
            const SizedBox(height: 16),
            Text('Due Date',
                style: context.textTheme.bodySmall?.copyWith(color: monkBlue)),
            Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: dueDate != null
                        ? Text(
                            DateFormat('dd MMM yyyy')
                                .format(dueDate ?? DateTime.now()),
                            style: context.textTheme.bodySmall?.copyWith(
                              color:
                                  context.colorScheme.onSurface.withOpacity(.8),
                            ),
                          )
                        : Text(
                            'dd MMM yyyy',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.disabledColor.withOpacity(.4),
                            ),
                          ))
                .onPressed(() async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2025),
              );
              if (date != null) {
                setState(() {
                  dueDate = date;
                });
              }
            }),
            Divider(
              height: 0,
              color: monkBlue.withOpacity(.7),
              thickness: 1.4,
            ),
          ],
          const SizedBox(height: 16),
          Center(
            child: FilledButton.tonal(
              onPressed: () async => createThread(
                context,
                ref,
                titleController.text,
                blockContent: messageController.text,
                dueDate: dueDate,
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
