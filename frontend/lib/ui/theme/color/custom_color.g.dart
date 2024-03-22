import 'package:flutter/material.dart';

const alert = Color(0xFFFF3333);
const warning = Color(0xFFFFB906);
const success = Color(0xFF07C932);
const monkBlue = Color(0xFF6892F5);

CustomColors lightCustomColors = const CustomColors(
  sourceAlert: Color(0xFFFF3333),
  alert: Color(0xFFC00015),
  onAlert: Color(0xFFFFFFFF),
  alertContainer: Color(0xFFFFDAD6),
  onAlertContainer: Color(0xFF410002),
  sourceWarning: Color(0xFFFFB906),
  warning: Color(0xFF7C5800),
  onWarning: Color(0xFFFFFFFF),
  warningContainer: Color(0xFFFFDEA7),
  onWarningContainer: Color(0xFF271900),
  sourceSuccess: Color(0xFF07C932),
  success: Color(0xFF006E16),
  onSuccess: Color(0xFFFFFFFF),
  successContainer: Color(0xFF72FF71),
  onSuccessContainer: Color(0xFF002203),
  sourceMonkBlue: Color(0xFF6892F5),
  monkBlue: Color(0xFF2A5AB9),
  onMonkBlue: Color(0xFFFFFFFF),
  monkBlueContainer: Color(0xFFDAE2FF),
  onMonkBlueContainer: Color(0xFF001946),
);

CustomColors darkCustomColors = const CustomColors(
  sourceAlert: Color(0xFFFF3333),
  alert: Color(0xFFFFB4AC),
  onAlert: Color(0xFF690006),
  alertContainer: Color(0xFF93000D),
  onAlertContainer: Color(0xFFFFDAD6),
  sourceWarning: Color(0xFFFFB906),
  warning: Color(0xFFFFBB1B),
  onWarning: Color(0xFF412D00),
  warningContainer: Color(0xFF5E4200),
  onWarningContainer: Color(0xFFFFDEA7),
  sourceSuccess: Color(0xFF07C932),
  success: Color(0xFF3CE44A),
  onSuccess: Color(0xFF003907),
  successContainer: Color(0xFF00530E),
  onSuccessContainer: Color(0xFF72FF71),
  sourceMonkBlue: Color(0xFF6892F5),
  monkBlue: Color(0xFFB1C5FF),
  onMonkBlue: Color(0xFF002C71),
  monkBlueContainer: Color(0xFF00419E),
  onMonkBlueContainer: Color(0xFFDAE2FF),
);

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourceAlert,
    required this.alert,
    required this.onAlert,
    required this.alertContainer,
    required this.onAlertContainer,
    required this.sourceWarning,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.sourceSuccess,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.sourceMonkBlue,
    required this.monkBlue,
    required this.onMonkBlue,
    required this.monkBlueContainer,
    required this.onMonkBlueContainer,
  });

  final Color? sourceAlert;
  final Color? alert;
  final Color? onAlert;
  final Color? alertContainer;
  final Color? onAlertContainer;
  final Color? sourceWarning;
  final Color? warning;
  final Color? onWarning;
  final Color? warningContainer;
  final Color? onWarningContainer;
  final Color? sourceSuccess;
  final Color? success;
  final Color? onSuccess;
  final Color? successContainer;
  final Color? onSuccessContainer;
  final Color? sourceMonkBlue;
  final Color? monkBlue;
  final Color? onMonkBlue;
  final Color? monkBlueContainer;
  final Color? onMonkBlueContainer;

  @override
  CustomColors copyWith({
    Color? sourceAlert,
    Color? alert,
    Color? onAlert,
    Color? alertContainer,
    Color? onAlertContainer,
    Color? sourceWarning,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? sourceSuccess,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? sourceMonkBlue,
    Color? monkBlue,
    Color? onMonkBlue,
    Color? monkBlueContainer,
    Color? onMonkBlueContainer,
  }) {
    return CustomColors(
      sourceAlert: sourceAlert ?? this.sourceAlert,
      alert: alert ?? this.alert,
      onAlert: onAlert ?? this.onAlert,
      alertContainer: alertContainer ?? this.alertContainer,
      onAlertContainer: onAlertContainer ?? this.onAlertContainer,
      sourceWarning: sourceWarning ?? this.sourceWarning,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      sourceSuccess: sourceSuccess ?? this.sourceSuccess,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      sourceMonkBlue: sourceMonkBlue ?? this.sourceMonkBlue,
      monkBlue: monkBlue ?? this.monkBlue,
      onMonkBlue: onMonkBlue ?? this.onMonkBlue,
      monkBlueContainer: monkBlueContainer ?? this.monkBlueContainer,
      onMonkBlueContainer: onMonkBlueContainer ?? this.onMonkBlueContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourceAlert: Color.lerp(sourceAlert, other.sourceAlert, t),
      alert: Color.lerp(alert, other.alert, t),
      onAlert: Color.lerp(onAlert, other.onAlert, t),
      alertContainer: Color.lerp(alertContainer, other.alertContainer, t),
      onAlertContainer: Color.lerp(onAlertContainer, other.onAlertContainer, t),
      sourceWarning: Color.lerp(sourceWarning, other.sourceWarning, t),
      warning: Color.lerp(warning, other.warning, t),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t),
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t),
      sourceSuccess: Color.lerp(sourceSuccess, other.sourceSuccess, t),
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t),
      sourceMonkBlue: Color.lerp(sourceMonkBlue, other.sourceMonkBlue, t),
      monkBlue: Color.lerp(monkBlue, other.monkBlue, t),
      onMonkBlue: Color.lerp(onMonkBlue, other.onMonkBlue, t),
      monkBlueContainer:
          Color.lerp(monkBlueContainer, other.monkBlueContainer, t),
      onMonkBlueContainer:
          Color.lerp(onMonkBlueContainer, other.onMonkBlueContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
