import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/decorations.dart';
// import 'color/color_schemes.g.dart';
// import 'color/custom_color.g.dart';
// part 'color_scheme.dart';
part 'theme_extensions.dart';

// enum ColorSeed {
//   baseColor('M3 Baseline', Color(0xff6750a4)),
//   indigo('Indigo', Colors.indigo),
//   blue('Blue', Colors.blue),
//   teal('Teal', Colors.teal),
//   green('Green', Colors.green),
//   yellow('Yellow', Colors.yellow),
//   orange('Orange', Colors.orange),
//   deepOrange('Deep Orange', Colors.deepOrange),
//   pink('Pink', Colors.pink);

//   const ColorSeed(this.label, this.color);
//   final String label;
//   final Color color;
// }

class AppTheme {
  static ThemeData lightTheme(ColorScheme lightColorScheme) {
    return ThemeData.light().copyWith(
      colorScheme: lightColorScheme,
      inputDecorationTheme: BoxDecorations.inputDecorationTheme(
          ThemeData.light(), lightColorScheme),
      cardColor: const Color(0xff182F61),
      dividerColor: lightCustomColors.monkBlue,
      extensions: [lightCustomColors],
    );
  }

  static ThemeData darkTheme(ColorScheme darkColorScheme) {
    return ThemeData.dark().copyWith(
      colorScheme: darkColorScheme,
      inputDecorationTheme: BoxDecorations.inputDecorationTheme(
          ThemeData.dark(), darkColorScheme),
      cardColor: const Color(0xff182F61),
      dividerColor: lightCustomColors.monkBlueContainer,
      extensions: [darkCustomColors],
    );
  }
}
