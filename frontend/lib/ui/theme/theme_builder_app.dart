import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/color/color_schemes.g.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/theme.dart';

typedef Builder = Widget Function(
    BuildContext context, ThemeData darkTheme, ThemeData lightTheme);

class ThemeBuilderApp extends StatelessWidget {
  const ThemeBuilderApp({super.key, required this.builder});
  final Builder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ThemeData darkTheme, lightTheme;
        if (constraints.maxWidth > 1200) {
          darkTheme = ResponsiveTheme.large(darkColorScheme, darkCustomColors);
          lightTheme =
              ResponsiveTheme.large(lightColorScheme, lightCustomColors);
        } else if (constraints.maxWidth > 600 && constraints.maxWidth < 1200) {
          // print('medium ${constraints.maxWidth}:${Breakpoints.small}');
          darkTheme = ResponsiveTheme.medium(darkColorScheme, darkCustomColors);
          lightTheme =
              ResponsiveTheme.medium(lightColorScheme, lightCustomColors);
        } else {
          darkTheme = ResponsiveTheme.small(darkColorScheme, darkCustomColors);
          lightTheme =
              ResponsiveTheme.small(lightColorScheme, lightCustomColors);
        }

        return builder(context, darkTheme, lightTheme);
      },
    );
  }
}
