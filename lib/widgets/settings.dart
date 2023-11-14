// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitapp/controllers/font_size_provider.dart';
import 'package:unitapp/controllers/navigation_utils.dart';
import 'package:unitapp/controllers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool hapticFeedback = false;
  bool pointSelected = true;
  bool commaSelected = false;
  bool statusBarVisible = false;
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 17.0;
  static const double largeFontSize = 20.0;
  Locale _selectedLocale =
      const Locale('en', 'US'); // Set default selected locale
  double fontSize = mediumFontSize;
  // Added to handle theme changes and load the theme preference
  bool isDarkMode = false;
// Add a method to load the theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadSettings();
    _loadHapticPreference(); // Load haptic feedback setting
  }

  Future<void> _loadHapticPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hapticFeedback = prefs.getBool('hapticFeedback') ?? false;
    });
  }

  Future<void> _saveHapticPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hapticFeedback', value);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble('fontSize') ?? mediumFontSize;
      _selectedLocale = context.locale; // Set _selectedLocale to current locale
      // Here you can load other settings like hapticFeedback, pointSelected, etc.
    });

    // Update the provider value
    Provider.of<FontSizeProvider>(context, listen: false).fontSize = fontSize;
  }

  _saveFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode
          ? Colors.black
          : const Color(0xFFFAE0E0), // Theme-aware background
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 30),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  context.navigateTo('/');
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 40,
                  color: isDarkMode ? Colors.grey : Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          ListTile(
            title: Text(
              "language".tr(),
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: fontSize),
            ),
            subtitle: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    languageButton(const Locale('en', 'US'), 'EN',
                        'assets/images/usa_flag.png'),
                    languageButton(const Locale('es', 'ES'), 'ES',
                        'assets/images/spain_flag.png'),
                    languageButton(const Locale('fr', 'FR'), 'FR',
                        'assets/images/france_flag.png'),
                    languageButton(const Locale('pt', 'BR'), 'PT',
                        'assets/images/portugal_flag.png'),
                    languageButton(const Locale('de', 'DE'), 'DE',
                        'assets/images/germany_flag.png'),
                    // ... other language buttons for the first row
                  ],
                ),
                const SizedBox(height: 5), // Space between the rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    languageButton(const Locale('ru', 'RU'), 'RU',
                        'assets/images/russia_flag.png'),
                    languageButton(const Locale('ar', 'SA'), 'AR',
                        'assets/images/arab_flag.png'),
                    languageButton(const Locale('hi', 'IN'), 'HI',
                        'assets/images/india_flag.png'),
                    languageButton(const Locale('ja', 'JP'), 'JA',
                        'assets/images/japon_flag.png'),
                    languageButton(const Locale('zh', 'CN'), 'ZH',
                        'assets/images/china_flag.png'),
                    // ... other language buttons for the second row
                  ],
                ),
                const SizedBox(height: 5), // Space between the rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    languageButton(const Locale('it', 'IT'), 'IT',
                        'assets/images/italia_flag.png'),
                    languageButton(const Locale('vi', 'VN'), 'VI',
                        'assets/images/vietnam_flag.png'),
                    languageButton(const Locale('tr', 'TR'), 'TR',
                        'assets/images/turquia_flag.png'),
                    languageButton(const Locale('th', 'TH'), 'TH',
                        'assets/images/thailandia_flag.png'),
                    languageButton(const Locale('ko', 'KR'), 'KR',
                        'assets/images/corea_flag.png'),
                    // ... other language buttons for the second row
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),
          Divider(
            color: isDarkMode ? Colors.white : Colors.grey[800],
            thickness: 2,
          ),
          const SizedBox(height: 5),
          SwitchListTile(
            secondary: Icon(Icons.brightness_6,
                size: 30,
                color: isDarkMode ? Colors.lightBlue : Colors.grey[800]),
            //color: isDarkMode ? const Color(0xFF6E85B7) : Colors.grey[800]),
            isThreeLine: false,
            dense: false,
            contentPadding: const EdgeInsets.all(8),
            activeColor: Colors.lightBlue,
            inactiveThumbColor: Colors.grey[800],
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
            activeTrackColor: Colors.lightBlue.withOpacity(0.5),
            tileColor: Colors.transparent,

            selectedTileColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            autofocus: false,
            visualDensity: VisualDensity.comfortable,
            title: Text('Dark Mode',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: fontSize))
                .tr(),
            value: isDarkMode,
            onChanged: (bool value) {
              setState(() {
                isDarkMode = value;
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(value);
              });
            },
          ),
          const SizedBox(height: 5),
          Divider(
            color: isDarkMode ? Colors.white : Colors.grey[800],
            thickness: 2,
          ),
          const SizedBox(height: 5),

          //FONT SIZE  ROW
          ListTile(
            title: Text(
              'Pick Font Size',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: fontSize, // Use the dynamic font size here
              ),
            ).tr(),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // This centers the row
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0), // Added horizontal padding
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.text_fields, size: 23),
                              color: fontSize == smallFontSize
                                  ? Colors.lightBlue
                                  : Colors.grey[850],
                              onPressed: () {
                                setState(() {
                                  fontSize = smallFontSize;
                                  _saveFontSize();
                                });
                                // Update the provider value
                                Provider.of<FontSizeProvider>(context,
                                        listen: false)
                                    .fontSize = smallFontSize;
                              },
                            ),
                            Text(
                              'S',
                              style: TextStyle(
                                fontSize: fontSize, // Dynamic font size
                                color: fontSize == smallFontSize
                                    ? Colors.lightBlue
                                    : Colors.grey[850],
                                fontWeight: FontWeight.bold,
                              ),
                            ).tr(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0), // Added horizontal padding
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.text_fields, size: 33),
                              color: fontSize == mediumFontSize
                                  ? Colors.lightBlue
                                  : Colors.grey[850],
                              onPressed: () {
                                setState(() {
                                  fontSize = mediumFontSize;
                                  _saveFontSize();
                                });
                                // Update the provider value
                                Provider.of<FontSizeProvider>(context,
                                        listen: false)
                                    .fontSize = mediumFontSize;
                              },
                            ),
                            Text(
                              'M',
                              style: TextStyle(
                                fontSize: fontSize, // Dynamic font size
                                color: fontSize == mediumFontSize
                                    ? Colors.lightBlue
                                    : Colors.grey[850],
                                fontWeight: FontWeight.bold,
                              ),
                            ).tr(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0), // Added horizontal padding
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.text_fields, size: 43),
                              color: fontSize == largeFontSize
                                  ? Colors.lightBlue
                                  : Colors.grey[850],
                              onPressed: () {
                                setState(() {
                                  fontSize = largeFontSize;
                                  _saveFontSize();
                                });
                                // Update the provider value
                                Provider.of<FontSizeProvider>(context,
                                        listen: false)
                                    .fontSize = largeFontSize;
                              },
                            ),
                            Text(
                              'L',
                              style: TextStyle(
                                fontSize: fontSize, // Dynamic font size
                                color: fontSize == largeFontSize
                                    ? Colors.lightBlue
                                    : Colors.grey[850],
                                fontWeight: FontWeight.bold,
                              ),
                            ).tr(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.all(8),
            tileColor: Colors.transparent,
          ),

          const SizedBox(height: 5),
          Divider(
            color: isDarkMode ? Colors.white : Colors.grey[800],
            thickness: 2,
          ),
          const SizedBox(height: 5),

          // Settings UI
          // STATUS BAR ROW
          // Status Bar SwitchListTile
          SwitchListTile(
            title: Consumer<FontSizeProvider>(
              builder: (context, fontSizeProvider, child) {
                return Text(
                  'Status bar',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: fontSizeProvider.fontSize),
                ).tr();
              },
            ),
            value: statusBarVisible,
            onChanged: (bool value) {
              setState(() {
                statusBarVisible = value;
                SystemChrome.setEnabledSystemUIMode(
                    value ? SystemUiMode.immersiveSticky : SystemUiMode.manual,
                    overlays: value ? [] : SystemUiOverlay.values);
              });
            },
            secondary: const Icon(Icons.sim_card, size: 38),
            subtitle: Consumer<FontSizeProvider>(
              builder: (context, fontSizeProvider, child) {
                return Text(
                  'Enable or disable visibility of status bar',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: fontSizeProvider.fontSize),
                ).tr();
              },
            ),
            isThreeLine: true,
            dense: false,
            contentPadding: const EdgeInsets.all(8),
            activeColor: Colors.lightBlue,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.5),
            activeTrackColor: Colors.lightBlue.withOpacity(0.5),
            tileColor: isDarkMode
                ? Colors.grey[800]
                : const Color.fromARGB(255, 152, 151, 151),
            selected: statusBarVisible,
            selectedTileColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            autofocus: false,
            visualDensity: VisualDensity.comfortable,
          ),
          const SizedBox(height: 5),
          Divider(
            color: isDarkMode ? Colors.white : Colors.grey[800],
            thickness: 2,
          ),
          const SizedBox(height: 5),

          // Haptic Button SwitchListTile
          SwitchListTile(
            title: Consumer<FontSizeProvider>(
              builder: (context, fontSizeProvider, child) {
                return Text(
                  'Button Haptic Feedback',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: fontSizeProvider.fontSize),
                ).tr();
              },
            ),
            value: hapticFeedback,
            onChanged: (bool value) {
              setState(() {
                hapticFeedback = value;
              });
              _saveHapticPreference(value); // Save haptic feedback setting
            },
            secondary: const Icon(Icons.touch_app, size: 38),
            subtitle: Consumer<FontSizeProvider>(
              builder: (context, fontSizeProvider, child) {
                return Text(
                  'Enable or disable haptic feedback for the buttons',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: fontSizeProvider.fontSize),
                ).tr();
              },
            ),
            isThreeLine: true,
            dense: false,
            contentPadding: const EdgeInsets.all(8),
            activeColor: Colors.lightBlue,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.5),
            activeTrackColor: Colors.lightBlue.withOpacity(0.5),
            tileColor: isDarkMode
                ? Colors.grey[800]
                : const Color.fromARGB(255, 152, 151, 151),
            selected: hapticFeedback,
            selectedTileColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            controlAffinity: ListTileControlAffinity.trailing,
            autofocus: false,
            visualDensity: VisualDensity.comfortable,
          ),
        ],
        // Add other UI components for different settings here
      ),
    );
  }

  Widget languageButton(Locale locale, String name, String assetPath) {
    return Padding(
      padding: const EdgeInsets.all(4.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 40,
            icon: Image.asset(assetPath),
            onPressed: () {
              setState(() {
                _selectedLocale = locale;
              });
              context.setLocale(locale);
            },
          ),
          Text(
            name,
            style: TextStyle(
              color: _selectedLocale == locale
                  ? Colors.lightBlue
                  : isDarkMode
                      ? Colors.white
                      : Colors.black, // Condition for text color based on theme
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
