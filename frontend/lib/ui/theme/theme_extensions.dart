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
}
