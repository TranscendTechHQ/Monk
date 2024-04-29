import 'dart:convert';

import 'package:flutter/material.dart';

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

void printPretty(Map<String, dynamic> map) {
  print(JsonEncoder.withIndent(' ').convert(map));
}
