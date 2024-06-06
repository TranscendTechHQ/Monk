import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/ui/widgets/cache_image.dart';
// ignore: depend_on_referenced_packages
import 'package:markdown/markdown.dart' as md;

class MarkdownViewer extends StatelessWidget {
  const MarkdownViewer(
      {super.key, required this.markdownData, required this.onTapLink});
  final String markdownData;
  final void Function(String?, String?, String?) onTapLink;

  MarkdownStyleSheet _getStyleSheet(BuildContext context) {
    final MarkdownStyleSheet markdownStyleSheet =
        MarkdownStyleSheet.fromTheme(Theme.of(context));
    return markdownStyleSheet.copyWith(
      codeblockDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
          width: 0.3,
        ),
      ),
      // listIndent: 22,
      listBullet: Theme.of(context).textTheme.bodyLarge,
      code: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
      blockquoteDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).disabledColor,
          width: 0.3,
        ),
      ),
      // blockquote: TextStyles.subtitle14(context),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _getImageBuilder(Uri? uri) {
    return uri != null && !uri.path.contains("svg")
        ? CacheImage(
            path: uri.toString(),
          )
        : uri!.path.contains("svg")
            ? SvgPicture.network(
                uri.toString(),
                semanticsLabel: 'Image',
                placeholderBuilder: (BuildContext context) => Container(
                  padding: const EdgeInsets.all(30.0),
                  height: 20,
                  child: const CircularProgressIndicator(),
                ),
              )
            : const Text("Loading image");
  }

  @override
  Widget build(BuildContext context) {
    String markdown = markdownData;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MarkdownBody(
          data: markdown,
          styleSheet: _getStyleSheet(context),
          imageBuilder: (uri, text, val) => _getImageBuilder(uri),
          onTapLink: onTapLink,
          inlineSyntaxes: [md.InlineHtmlSyntax()],
          extensionSet: md.ExtensionSet(
            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            [
              md.EmojiSyntax(),
              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
            ],
          ),
        ),
      ],
    );
  }
}
