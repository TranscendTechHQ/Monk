import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.desktop,
    this.tablet,
    this.mobile,
  });
  final Widget desktop;
  final Widget? tablet;
  final Widget? mobile;

  bool get isMobile => false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > 1200) {
        return desktop;
      } else if (constraints.maxWidth > 600 && constraints.maxWidth < 1200) {
        return tablet ?? const SizedBox();
      } else {
        return mobile ?? const SizedBox();
      }
    });
  }
}
