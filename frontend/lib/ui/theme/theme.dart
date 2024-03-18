import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/color/custom_color.g.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/text_styles.dart';

// import 'color/color_schemes.g.dart';
// import 'color/custom_color.g.dart';
// part 'color_scheme.dart';
part 'theme_extensions.dart';

class Breakpoints {
  const Breakpoints._();

  static const int small = 320;
  static const int medium = 600;
  static const int large = 1200;
  static const extraLarges = 1920;
}

// class AppTheme {
//   static ThemeData lightTheme(ColorScheme lightColorScheme) {
//     return ThemeData.light().copyWith(
//       colorScheme: lightColorScheme,
//       inputDecorationTheme: BoxDecorations.inputDecorationTheme(
//           ThemeData.light(), lightColorScheme),
//       cardColor: const Color(0xff182F61),
//       dividerColor: lightCustomColors.monkBlue,
//       extensions: [lightCustomColors],
//     );
//   }

//   static ThemeData darkTheme(ColorScheme darkColorScheme) {
//     return ThemeData.dark().copyWith(
//       colorScheme: darkColorScheme,
//       inputDecorationTheme: BoxDecorations.inputDecorationTheme(
//           ThemeData.dark(), darkColorScheme),
//       cardColor: const Color(0xff182F61),
//       dividerColor: lightCustomColors.monkBlueContainer,
//       extensions: [darkCustomColors],
//     );
//   }
// }

class ResponsiveTheme {
  const ResponsiveTheme._();

  static ThemeData small(ColorScheme scheme, CustomColors customColors) =>
      _baseTheme(AppThemes.small, scheme, customColors);
  static ThemeData medium(ColorScheme scheme, CustomColors customColors) =>
      _baseTheme(AppThemes.medium, scheme, customColors);
  static ThemeData large(ColorScheme scheme, CustomColors customColors) =>
      _baseTheme(AppThemes.large, scheme, customColors);

  static ThemeData _baseTheme(
      AppThemes appThemes, ColorScheme scheme, CustomColors customColors) {
    final textStyles = appThemes.appTextStyles;

    return ThemeData(
      colorScheme: scheme,
      extensions: [appThemes, customColors],
      inputDecorationTheme: BoxDecorations.inputDecorationTheme(
        ThemeData.dark(),
        scheme,
      ),
      cardColor: const Color(0xff182F61),
      dividerColor: lightCustomColors.monkBlueContainer,
      textTheme: TextTheme(
        displayLarge: textStyles.displayLarge,
        displayMedium: textStyles.displayMedium,
        displaySmall: textStyles.displaySmall,
        headlineLarge: textStyles.headlineLarge,
        headlineMedium: textStyles.headlineMedium,
        headlineSmall: textStyles.headlineSmall,
        titleLarge: textStyles.titleLarge,
        titleMedium: textStyles.titleMedium,
        titleSmall: textStyles.titleSmall,
        bodyLarge: textStyles.bodyLarge,
        bodyMedium: textStyles.bodyMedium,
        bodySmall: textStyles.bodySmall,
        labelLarge: textStyles.labelLarge,
        labelMedium: textStyles.labelMedium,
        labelSmall: textStyles.labelSmall,
      ),
    );
  }
}

class AppThemes extends ThemeExtension<AppThemes> {
  const AppThemes({
    // required this.appSpacings,
    required this.appTextStyles,
  });

  // final AppSpacings appSpacings;
  final AppTextStyles appTextStyles;

  static const AppThemes small = AppThemes(
    // appSpacings: AppSpacings.small,
    appTextStyles: AppTextStyles.small,
  );

  static const AppThemes medium = AppThemes(
    // appSpacings: AppSpacings.medium,
    appTextStyles: AppTextStyles.medium,
  );

  static const AppThemes large = AppThemes(
    // appSpacings: AppSpacings.large,
    appTextStyles: AppTextStyles.large,
  );

  @override
  ThemeExtension<AppThemes> copyWith({
    AppTextStyles? appTextStyles,
    // AppSpacings? appSpacings,
  }) {
    return AppThemes(
      appTextStyles: appTextStyles ?? this.appTextStyles,
      // appSpacings: appSpacings ?? this.appSpacings,
    );
  }

  @override
  ThemeExtension<AppThemes> lerp(
    ThemeExtension<AppThemes>? other,
    double t,
  ) {
    if (other is! AppThemes) {
      return this;
    }
    return AppThemes(
      // appSpacings: other.appSpacings,
      appTextStyles: other.appTextStyles,
    );
  }
}
