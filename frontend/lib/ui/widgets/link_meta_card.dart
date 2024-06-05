import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/cache_image.dart';
import 'package:openapi/openapi.dart';

import '../../helper/utils.dart';

class LinkMetaCard extends StatelessWidget {
  const LinkMetaCard({super.key, required this.linkMeta});
  final LinkMetaModel? linkMeta;

  @override
  Widget build(BuildContext context) {
    if (linkMeta == null ||
        linkMeta!.url.isNullOrEmpty ||
        (linkMeta!.description.isNullOrEmpty &&
            linkMeta!.image.isNullOrEmpty)) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () {
        launch(linkMeta!.url);
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: context.colorScheme.onSurface.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (linkMeta!.title != null)
              Text(
                linkMeta!.title!,
                style: context.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (linkMeta!.description != null) ...[
              const SizedBox(height: 8),
              Text(
                linkMeta!.description!,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(0.6),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (linkMeta!.image.isNotNullEmpty) ...[
              const SizedBox(height: 8),
              CacheImage(
                onPressed: () {
                  launch(linkMeta!.url);
                },
                path: linkMeta!.image!,
                fit: BoxFit.fitHeight,
                errorWidget: Container(
                  height: 100,
                  color: context.colorScheme.onSurface.withOpacity(0.1),
                ),
              ).extended
            ]
          ],
        ),
      ),
    );
  }
}
