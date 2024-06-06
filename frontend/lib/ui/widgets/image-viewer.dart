import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/theme.dart';

class ImageViewer extends StatelessWidget {
  static MaterialPageRoute getRoute(String path, {Object? heroTag}) {
    return MaterialPageRoute(
      builder: (_) => ImageViewer(
        path: path,
        heroTag: heroTag,
      ),
    );
  }

  const ImageViewer({super.key, this.path, this.heroTag});
  final String? path;
  final Object? heroTag;

  Widget heroWrapper({required Widget child}) {
    if (heroTag == null) {
      return child;
    }
    return Hero(
      tag: heroTag!,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .9,
              maxWidth: MediaQuery.of(context).size.width,
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: heroWrapper(
              child: InteractiveViewer(
                minScale: .3,
                maxScale: 5,
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: path!,
                  placeholder: (context, url) => Container(
                    color: Theme.of(context).cardColor,
                  ),
                  maxWidthDiskCache: 800,
                  cacheKey: path!,
                  errorWidget: (context, url, dym) {
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      color: Theme.of(context).cardColor,
                    );
                  },
                ),
              ),
            ).extended,
          )
        ],
      ),
    );
  }
}
