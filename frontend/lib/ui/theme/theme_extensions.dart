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
  double scale(double large, [double? medium, double? small]) =>
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

extension PaddingHelper on Widget {
  Padding get p16 => Padding(padding: const EdgeInsets.all(16), child: this);

  /// Set all side padding according to `value`
  Padding p(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Set all side padding according to `value`
  Padding pH(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  Padding pV(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  /// set padding for all sides
  Padding pOnly({double? top, double? bottom, double? left, double? right}) =>
      Padding(
          padding: EdgeInsets.only(
              top: top ?? 0,
              bottom: bottom ?? 0,
              left: left ?? 0,
              right: right ?? 0),
          child: this);

  /// Horizontal Padding 16
  Padding get hP4 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: this);
  Padding get hP8 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: this);
  Padding get hP16 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: this);

  /// Vertical Padding 16
  Padding get vP16 =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: this);
  Padding get vP8 =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: this);
  Padding get vP12 =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: this);
  Padding get vP4 =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: this);

  ///Horizontal Padding for Title
  Padding get hP30 => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0), child: this);

  /// Set right side padding according to `value`
  Padding pR(double value) =>
      Padding(padding: EdgeInsets.only(right: value), child: this);

  /// Set left side padding according to `value`
  Padding pL(double value) =>
      Padding(padding: EdgeInsets.only(left: value), child: this);

  /// Set Top side padding according to `value`
  Padding pT(double value) =>
      Padding(padding: EdgeInsets.only(top: value), child: this);

  /// Set bottom side padding according to `value`
  Padding pB(double value) =>
      Padding(padding: EdgeInsets.only(bottom: value), child: this);
}

extension Extended on Widget {
  Expanded get extended => Expanded(
        child: this,
      );
  Widget onPressed([VoidCallback? onPressed]) => GestureDetector(
        onTap: onPressed,
        child: this,
      );
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

extension StringHelper on String? {
  bool get isNotNullEmpty => this != null && this!.isNotEmpty;
  bool get isNullOrEmpty => !isNotNullEmpty;

  String orDefault(String defaultValue) =>
      isNotNullEmpty ? this! : defaultValue;

  DateTime? get toDateTime => this != null ? DateTime.tryParse(this!) : null;
}

extension ListHelper<T> on Iterable<T>? {
  bool get isNotNullEmpty => this != null && this!.isNotEmpty;

  /// Checks if the list is null or empty. If it is null or empty, it returns the true value.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  T? firstWhereOrNull(bool Function(T) test) {
    if (this == null) return null;
    try {
      return this!.firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  Widget on({
    required Widget Function() ifNull,
    required Widget Function() ifEmpty,
    required Widget Function() ifValue,
  }) {
    if (this == null) {
      return ifNull();
    } else if (this!.isEmpty) {
      return ifEmpty();
    } else {
      return ifValue();
    }
  }

  /// Returns the absolute value of the list or null value.
  /// ```dart
  /// final list1 = [1, 2, 3];
  /// final result = List<int>.from(list1);
  /// print(result); // [1, 2, 3]
  ///
  /// OR
  ///
  /// final list1 = [1, 2, 3];
  /// final result = lis1.getAbsoluteOrNull;
  /// print(result); // [1, 2, 3]
  /// ```
  /// Both above examples will return the same result.
  List<T>? get getAbsoluteOrNull => this == null ? null : List<T>.from(this!);
  // value.fold(() => null, (a) => List<T>.from(a));
}

extension on String? {
  String? limitToFirst(int m) {
    if (this == null) return null;
    if (this!.length <= m) return this;
    return this!.substring(0, m);
  }
}
