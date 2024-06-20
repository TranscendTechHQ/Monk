import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/ui/pages/news/widget/news_filter/provider/news_feed_filter_provider.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/kit/alert.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';

class SemanticFilter extends ConsumerStatefulWidget {
  const SemanticFilter({
    super.key,
  });

  static Future<T?> show<T>(BuildContext context) async {
    return await Alert.dialog<T>(
      context,
      child: const SemanticFilter(),
      barrierDismissible: true,
    );
  }

  @override
  SemanticFilterState createState() => SemanticFilterState();
}

class SemanticFilterState extends ConsumerState<SemanticFilter> {
  late TextEditingController textEditorController;
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    final readState = ref.read(newsFeedFilterProvider.notifier);
    textEditorController =
        TextEditingController(text: readState.state.value!.semanticQuery);
  }

  @override
  void dispose() {
    textEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxWidth: 500,
        minWidth: 300,
        maxHeight: context.width * .7,
        minHeight: 200,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Semantic Filter',
                style: context.textTheme.bodyLarge,
              ),
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
          const SizedBox(height: 10),
          Divider(
            color: context.customColors.monkBlue!,
            thickness: .2,
          ),
          const SizedBox(height: 10),

          // SEARCH INPUT
          SearchInput(
            onClear: () {},
            textEditorController: textEditorController,
            onSubmitted: (value) {},
            onChanged: (value) {},
          ),

          const Padding(padding: EdgeInsets.all(8)),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              OutlineIconButton(
                label: 'Reset',
                onPressed: () async {
                  textEditorController.clear();
                },
                horizontalPadding: 36,
                verticalPadding: 16,
              ),
              OutlineIconButton(
                label: 'Apply',
                onPressed: () {
                  Navigator.pop(context, {
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
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    required this.textEditorController,
    this.inputFocusNode,
    this.onChanged,
    required this.onClear,
    required this.onSubmitted,
  });
  final TextEditingController textEditorController;
  final FocusNode? inputFocusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('search_input'),
      controller: textEditorController,
      focusNode: inputFocusNode,
      autofocus: true,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      maxLines: 5,
      decoration: InputDecoration(
        constraints: const BoxConstraints(
          minHeight: 40,
          maxHeight: 250,
        ),
        prefixStyle: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurface,
        ),
        hintText:
            'Describe in plain english the kind of threads you want to see in the newsfeed.',
        fillColor: context.colorScheme.scrim,
        hintStyle: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurface.withOpacity(.4),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: monkBlue700),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: monkBlue700.withOpacity(.9)),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: monkBlue700),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: context.colorScheme.error.withOpacity(.8),
          ),
        ),
      ),
    );
  }
}
