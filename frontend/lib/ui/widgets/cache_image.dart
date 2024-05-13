import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/ui/widgets/image-viewer.dart';

class CacheImage extends StatelessWidget {
  const CacheImage(
      {super.key,
      this.path,
      this.onPressed,
      this.fit = BoxFit.contain,
      this.errorWidget,
      this.tag = 'image'});
  final String? path;
  final BoxFit fit;
  final VoidCallback? onPressed;
  final Widget? errorWidget;
  final Object tag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ??
          () {
            if (onPressed != null) {
              onPressed!();
            } else {
              Navigator.push(
                  context, ImageViewer.getRoute(path!, heroTag: tag));
            }
          },
      child: Hero(
        tag: tag,
        child: CachedNetworkImage(
          imageUrl: path!,
          fit: fit,
          maxWidthDiskCache: 800,
          placeholder: (context, url) => Container(
            color: Theme.of(context).disabledColor,
          ),
          cacheKey: path,
          errorWidget: (context, url, dym) {
            return errorWidget ??
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .2,
                    maxWidth: MediaQuery.of(context).size.width * 9,
                  ),
                  color: Theme.of(context).disabledColor,
                );
          },
        ),
      ),
    );
  }
}
