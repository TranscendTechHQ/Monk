import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/theme.dart';

class Alert {
  static Future<T?> dialog<T>(BuildContext context,
      {String title = "Message",
      required Widget child,
      VoidCallback? onPressed,
      Color? titleBackGround,
      String? buttonText = "Ok",
      bool? enableCrossButton = true,
      bool barrierDismissible = false,
      TextStyle? titleStyle,
      EdgeInsets insetPadding =
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      EdgeInsets? childParentPadding = const EdgeInsets.only(bottom: 16),
      Color? crossButtonIconColor}) {
    return showDialog<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0.0,
          insetPadding: insetPadding,
          backgroundColor: Colors.transparent,
          child: Wrap(
            children: [
              Container(
                padding: childParentPadding,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color:
                              titleBackGround ?? context.colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(title, style: titleStyle
                                  // TextStyles.headline16(context).copyWith(
                                  //   color: context.colorScheme.onSecondary,
                                  // ),
                                  ),
                            ).vP8.extended,
                            // Spacer(),
                            // TextButton(
                            //   onPressed: () {
                            //     if (enableCrossButton!) Navigator.pop(context);
                            //   },
                            //   child: Image.asset(Images.cross,
                            //       height: 30,
                            //       color: crossButtonIconColor ??
                            //           context.onPrimary),
                            // )
                          ],
                        )),
                    child,
                    if (buttonText != null) ...[
                      const SizedBox(height: 12),
                      // PFlatButton(
                      //   label: buttonText,
                      //   onPressed: onPressed,
                      // ).hP16
                      FilledButton(onPressed: onPressed, child: child).hP16
                    ]
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
