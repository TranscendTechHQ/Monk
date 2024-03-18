part of 'theme.dart';

extension ThemeHelper on BuildContext {
  ThemeData get theme => Theme.of(this);
  Color get primaryColor => theme.primaryColor;
  Color get onPrimary => theme.colorScheme.onPrimary;
  Color get surfaceColor => theme.colorScheme.surface;
  TextTheme get textTheme => theme.textTheme;
  Color get bodyTextColor => theme.textTheme.bodyLarge!.color!;
  Color get disabledColor => theme.disabledColor;
  ColorScheme get colorScheme => theme.colorScheme;
  ThemeMode get themeType =>
      theme.brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
  bool get isDarkMode => themeType == ThemeMode.dark;
  bool get isLandscapeMode =>
      MediaQuery.of(this).orientation == Orientation.landscape;
  CustomColors get customColors => theme.extension<CustomColors>()!;
}

extension MediaExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;
  bool get isMobile => width < Breakpoints.medium;
  bool get isTablet => width >= Breakpoints.medium && width < Breakpoints.large;
  bool get isDesktop => width >= Breakpoints.large;
  bool get isLargeDesktop => width >= Breakpoints.extraLarges;
  double scale(double large, double? medium, double? small) =>
      width.scale(large, medium, small);
}

extension TextStyleExtension on TextStyle {
  TextStyle scaleFont({
    double? large,
    double? medium,
    double? small,
  }) {
    return copyWith(
      fontSize: fontSize!
          .scale(fontSize ?? large, fontSize ?? medium, fontSize ?? small),
    );
  }
}

extension DoubleExtension on double {
  double scale(double? large, double? medium, double? small) {
    if (this >= Breakpoints.large) {
      return large!;
    } else if (this >= Breakpoints.medium && this < Breakpoints.large) {
      return medium ?? large!;
    } else {
      return small ?? large!;
    }
  }
}
