import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  ThemeData get light => _themeFor(Brightness.light);

  ThemeData get dark => _themeFor(Brightness.dark);

  ThemeData _themeFor(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blueAccent,
      brightness: brightness,
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
