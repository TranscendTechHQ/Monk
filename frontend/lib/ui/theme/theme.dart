import 'package:flutter/material.dart';
part 'color_scheme.dart';
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
  static ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: lightColorScheme,
    inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
          filled: true,
          fillColor: lightColorScheme.tertiaryContainer.withOpacity(.3),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: lightColorScheme.tertiaryContainer,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeData.light().disabledColor)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ThemeData.light().disabledColor,
            ),
          ),
          hintStyle: TextStyle(
            color: lightColorScheme.onTertiaryContainer,
          ),
        ),
  );
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: darkColorScheme,
    inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
          filled: true,
          fillColor: darkColorScheme.tertiaryContainer.withOpacity(.3),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: darkColorScheme.tertiaryContainer,
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
            color: darkColorScheme.onTertiaryContainer,
          ),
        ),
  );
}
