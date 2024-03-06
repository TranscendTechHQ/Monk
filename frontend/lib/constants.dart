import 'package:flutter/material.dart';

const apiDomain = "http://35.209.147.65:8000";
//const apiDomain = "http://0.0.0.0:8000";

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

const containerWidth = 800.0; //TODO: make this a provider
