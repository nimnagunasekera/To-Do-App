import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

enum ThemeType {
  light,
  dark,
}

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkTheme; // Set the default theme to lightTheme

  ThemeData getTheme() => _themeData;

  void setTheme(ThemeType themeType) {
    switch (themeType) {
      case ThemeType.light:
        _themeData = lightTheme;
        break;
      case ThemeType.dark:
        _themeData = darkTheme;
        break;
    }
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      setTheme(ThemeType.dark);
    } else {
      setTheme(ThemeType.light);
    }
  }
}
