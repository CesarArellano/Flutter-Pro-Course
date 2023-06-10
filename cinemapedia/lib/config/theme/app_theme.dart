import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blueAccent
    );
  }
}