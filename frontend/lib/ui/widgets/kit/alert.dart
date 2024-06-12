import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/dismiss_button.dart';
import 'package:frontend/ui/widgets/outline_icon_button.dart';

enum AlertType {
  success,
  danger,
  primary,
}

class Alert {
  static Future<T?> dialog<T>(BuildContext context,
      {String topic = "Message",
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
          alignment: Alignment.center,
          elevation: 0.0,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Wrap(
            children: [
              Container(
                padding: childParentPadding,
                width: MediaQuery.of(context).size.width,
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
                              child: Text(topic, style: titleStyle),
                            ).vP8.extended,
                            const Spacer(),
                            DismissButton(
                              onPressed: () {
                                if (enableCrossButton!) Navigator.pop(context);
                              },
                              tooltip: 'Close',
                            )
                          ],
                        )),
                    child,
                    if (buttonText != null) ...[
                      const SizedBox(height: 12),
                      OutlineIconButton(
                        label: buttonText,
                        onPressed: onPressed,
                        wrapped: false,
                      )
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

  // ignore: avoid_void_async
  static void confirm(
    BuildContext context, {
    required String message,
    String topic = "Message",
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmLabel = "Confirm",
    String cancelLabel = "Cancel",
    bool barrierDismissible = true,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.center,
          elevation: 0.0,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            width: MediaQuery.of(context).size.width * .75,
            decoration: BoxDecoration(
              color: context.colorScheme.secondaryContainer.withOpacity(.5),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: context.customColors.monkBlue!,
                width: .3,
              ),
            ),
            constraints: const BoxConstraints(
              minWidth: 150,
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  topic,
                  style: context.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: context.customColors.monkBlue!.withOpacity(.5),
                  thickness: .5,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: context.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 26),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonAlignedDropdown: true,
                  buttonPadding: const EdgeInsets.all(0),
                  children: <Widget>[
                    OutlineIconButton(
                      label: cancelLabel,
                      horizontalPadding: 26,
                      verticalPadding: 16,
                      onPressed: () {
                        Navigator.pop(context);
                        onCancel?.call();
                      },
                    ),
                    const SizedBox(
                      width: 24,
                      height: 16,
                    ),
                    OutlineIconButton(
                      label: confirmLabel,
                      isFilled: true,
                      horizontalPadding: 26,
                      verticalPadding: 16,
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
