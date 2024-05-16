import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

void printPretty(Map<String, dynamic>? map) {
  if (kDebugMode) {
    print(const JsonEncoder.withIndent(' ').convert(map));
  }
}

Future<void> launch(String? url) async {
  if (url.isNullOrEmpty) {
    return;
  }
  final uri = Uri.parse(url!);
  launchUrl(uri, mode: LaunchMode.externalApplication);
}
