// theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = darkTheme; // Default to light theme

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme(bool isDarkMode) {
    _currentTheme = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
    _saveThemePreference(isDarkMode);
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode =
        prefs.getBool('isDarkMode') ?? false; // Default to light theme
    _currentTheme = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  static final ThemeData lightTheme = ThemeData(
    // Define light theme properties
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      // Add other custom colors if needed
      background: Color(
          0xFFD2E0FB), //isDarkMode ? const Color(0xFF2C3A47) : const Color(0xFF9A3B3B),
      // ... other colors
    ),
    // Additional ThemeData properties specific to light theme
  );

  static final ThemeData darkTheme = ThemeData(
    // Define dark theme properties
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      // Add other custom colors if needed
      background: Colors.black,
      // ... other colors
    ),
    // Additional ThemeData properties specific to dark theme
  );
}
