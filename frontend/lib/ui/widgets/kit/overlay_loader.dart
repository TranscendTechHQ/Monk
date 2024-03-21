import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/theme.dart';

abstract class LoaderService {
  static final LoaderService _instance = CustomLoader();

  /// access to the Singleton instance of LoaderService
  static LoaderService get instance => _instance;

  /// Short form to access the instance of LoaderService
  static LoaderService get I => _instance;

  void showLoader(BuildContext context,
      {String message, Stream<String> progress});

  void hideLoader();
}

class CustomLoader implements LoaderService {
//  static CustomLoader _customLoader;

//   CustomLoader._createObject();

//  factory CustomLoader() {
//     if (_customLoader != null) {
//       return _customLoader;
//     } else {
//       _customLoader = CustomLoader._createObject();
//       return _customLoader;
//     }
//   }

  //static OverlayEntry _overlayEntry;
  // ignore: use_late_for_private_fields_and_variables
  OverlayState? _overlayState; //= new OverlayState();
  OverlayEntry? _overlayEntry;

  @override
  void showLoader(BuildContext context,
      {String? message, Stream<String>? progress}) {
    _overlayState = Overlay.of(context);
    _buildLoader(message: message, progress: progress);
    _overlayState!.insert(_overlayEntry!);
  }

  @override
  void hideLoader() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      print("Exception: $e");
    }
  }

  void _buildLoader({String? message, Stream<String>? progress}) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return SizedBox(
          height: context.height,
          width: context.width,
          child: buildLoader(context, message: message, progress: progress),
        );
      },
    );
  }

  Scaffold buildLoader(BuildContext context,
      {Color? backgroundColor, String? message, Stream<String>? progress}) {
    backgroundColor ??= const Color(0xffa8a8a8).withOpacity(.5);
    const height = 150.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _CustomScreenLoader(
          height: height,
          width: height,
          backgroundColor: backgroundColor,
          message: message,
          progress: progress,
          onTap: () {
            hideLoader();
          }),
    );
  }
}

class _CustomScreenLoader extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final double width;
  final GestureTapCallback? onTap;
  final String? message;
  final Stream<String>? progress;
  const _CustomScreenLoader({
    this.backgroundColor = const Color(0xfff8f8f8),
    this.height = 40,
    this.width = 40,
    this.onTap,
    this.message,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        alignment: Alignment.center,
        child: Container(
          height: height,
          width: height,
          alignment: Alignment.center,
          child: Container(
            height: height,
            width: height,
            // padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height - 70,
                  width: height - 70,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: <Widget>[
                      if (Platform.isIOS)
                        const CupertinoActivityIndicator(
                          radius: 15,
                        )
                      else
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            theme.colorScheme.primary,
                          ),
                        ),
                      if (Platform.isAndroid)
                        Center(
                          child: Image.asset(
                            'assets/logo.png',
                            height: 30,
                            width: 30,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                    ],
                  ),
                ),
                if (message != null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: progress,
                        initialData: "",
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (!snapshot.data.isNotNullEmpty) {
                            return const SizedBox(height: 8);
                          }
                          return Text(
                            "${snapshot.data} ",
                            // style: TextStyles.subtitle14(context),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      Text(
                        message ?? "",
                        // style: TextStyles.subtitle14(context),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ).pT(10).hP8,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
