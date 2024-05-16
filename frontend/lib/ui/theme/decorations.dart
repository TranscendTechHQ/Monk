import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/theme.dart';

class BoxDecorations {
  static InputDecorationTheme inputDecorationTheme(
      ThemeData theme, ColorScheme colorScheme) {
    return theme.inputDecorationTheme.copyWith(
      filled: true,
      fillColor: colorScheme.tertiaryContainer.withOpacity(.3),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.tertiaryContainer,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeData.dark().disabledColor)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ThemeData.dark().disabledColor,
        ),
      ),
      hintStyle: TextStyle(
        color: colorScheme.onTertiaryContainer,
      ),
    );
  }

  static BoxDecoration pageDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff102554),
          Color(0xff0B1836),
          Color(0xff051416),
          Color(0xff09122b),
          Color(0xff000000),
        ],
        stops: [.3, .5, 65, .75, 1],
      ),
    );
  }

  static BoxDecoration cardDecoration(BuildContext context,
      {Color? borderColor}) {
    return BoxDecoration(
      color: context.theme.cardColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: borderColor ?? context.customColors.sourceMonkBlue!,
        width: 1,
      ),
    );
  }
}
