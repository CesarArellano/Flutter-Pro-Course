
import 'package:flutter/material.dart' show ThemeData, Color, Colors;

const Color _customColor = Color(0xFF5C11D4);

const List<Color> _colorThemes = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.redAccent,
  Colors.orange,
  Colors.pink,
];

class AppTheme {
  final int selectedColor;
  
  const AppTheme({
    this.selectedColor = 0,
  }): assert( selectedColor >= 0 && selectedColor <= _colorThemes.length - 1, 'Colors must be between 0 and ${ _colorThemes.length }');
  
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
      // brightness: Brightness.dark
    );
  }
}