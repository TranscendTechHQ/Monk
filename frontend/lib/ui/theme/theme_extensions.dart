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
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1200;
  bool get isDesktop => width >= 1200;
  bool get isLargeDesktop => width >= 1920;
}
