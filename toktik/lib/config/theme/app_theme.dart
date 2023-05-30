import 'package:flutter/material.dart' show Brightness, ThemeData;

class AppTheme {

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark
    );
  }
}