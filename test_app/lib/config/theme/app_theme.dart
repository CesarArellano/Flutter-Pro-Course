import 'package:flutter/material.dart';

class AppTheme {
  
  static const Color primaryColor = Colors.blue;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: primaryColor,
    splashFactory: InkSparkle.splashFactory
  );
}