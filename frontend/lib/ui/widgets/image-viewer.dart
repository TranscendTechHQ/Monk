import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/ui/theme/theme.dart';

class ImageViewer extends StatelessWidget {
  static MaterialPageRoute getRoute(String path, {Object heroTag = 'image'}) {
    return MaterialPageRoute(
      builder: (_) => ImageViewer(
        path: path,
        heroTag: heroTag,
      ),
    );
  }

  const ImageViewer({super.key, this.path, this.heroTag = 'image'});
  final String? path;
  final Object heroTag;

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
            child: Hero(
              tag: heroTag,
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
