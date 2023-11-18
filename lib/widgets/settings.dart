// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
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
  static const double mediumFontSize = 20.0;
  static const double largeFontSize = 23.0;
  Locale _selectedLocale = const Locale('en', 'US');
  double fontSize = mediumFontSize;
  bool isDarkMode = false; // Added to handle theme changes
  static const double tileHeight = 120.0; // Example fixed height for each tile
  Future<void> _loadStatusBarVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      statusBarVisible = prefs.getBool('statusBarVisible') ?? false;
      // Update system UI mode based on the saved preference
      SystemChrome.setEnabledSystemUIMode(
        statusBarVisible ? SystemUiMode.immersiveSticky : SystemUiMode.manual,
        overlays: statusBarVisible ? [] : SystemUiOverlay.values,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadSettings();
    _loadHapticPreference();
    _loadStatusBarVisibility();
    _loadPreferences(); // Load status bar visibility setting
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      statusBarVisible = prefs.getBool('statusBarVisible') ?? false;
      hapticFeedback = prefs.getBool('hapticFeedback') ?? false;
      fontSize = prefs.getDouble('fontSize') ?? mediumFontSize;
      // ... other preferences ...
    });
    // Apply system UI mode based on the saved preference
    SystemChrome.setEnabledSystemUIMode(
      statusBarVisible ? SystemUiMode.immersiveSticky : SystemUiMode.manual,
      overlays: statusBarVisible ? [] : SystemUiOverlay.values,
    );
    // Update providers or other state management solutions here if you decide to use them
    Provider.of<FontSizeProvider>(context, listen: false).fontSize = fontSize;
    // ... other provider updates ...
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble('fontSize') ?? mediumFontSize;
      // Use null assertion operator `!` if you are sure it's never null at this point
      _selectedLocale = context.locale;
    });
    Provider.of<FontSizeProvider>(context, listen: false).fontSize = fontSize;
  }

  Future<void> _loadHapticPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hapticFeedback = prefs.getBool('hapticFeedback') ?? false;
    });
  }

  Future<void> _saveStatusBarVisibility(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('statusBarVisible', value);
  }

  Future<void> _saveHapticPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hapticFeedback', value);
  }

  _saveFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 10, // Vertical padding between each row of icons
              crossAxisSpacing: 0.5, // Horizontal padding between each icon
              children: [
                languageGridTile(
                  context,
                  const Locale('en', 'US'),
                  'EN',
                  'assets/images/usa_flag.png',
                  _selectedLocale == const Locale('en', 'US'),
                ),
                languageGridTile(
                  context,
                  const Locale('es', 'ES'),
                  'ES',
                  'assets/images/spain_flag.png',
                  _selectedLocale == const Locale('es', 'ES'),
                ),
                languageGridTile(
                  context,
                  const Locale('fr', 'FR'),
                  'FR',
                  'assets/images/france_flag.png',
                  _selectedLocale == const Locale('fr', 'FR'),
                ),
                languageGridTile(
                  context,
                  const Locale('pt', 'BR'),
                  'PT',
                  'assets/images/portugal_flag.png',
                  _selectedLocale == const Locale('pt', 'BR'),
                ),
                languageGridTile(
                  context,
                  const Locale('de', 'DE'),
                  'DE',
                  'assets/images/germany_flag.png',
                  _selectedLocale == const Locale('de', 'DE'),
                ),
                languageGridTile(
                  context,
                  const Locale('ru', 'RU'),
                  'RU',
                  'assets/images/russia_flag.png',
                  _selectedLocale == const Locale('ru', 'RU'),
                ),
                languageGridTile(
                  context,
                  const Locale('ar', 'SA'),
                  'AR',
                  'assets/images/arab_flag.png',
                  _selectedLocale == const Locale('ar', 'SA'),
                ),
                languageGridTile(
                  context,
                  const Locale('hi', 'IN'),
                  'HI',
                  'assets/images/india_flag.png',
                  _selectedLocale == const Locale('hi', 'IN'),
                ),
                languageGridTile(
                  context,
                  const Locale('ja', 'JP'),
                  'JA',
                  'assets/images/japon_flag.png',
                  _selectedLocale == const Locale('ja', 'JP'),
                ),
                languageGridTile(
                  context,
                  const Locale('zh', 'CN'),
                  'ZH',
                  'assets/images/china_flag.png',
                  _selectedLocale == const Locale('zh', 'CN'),
                ),
                languageGridTile(
                  context,
                  const Locale('it', 'IT'),
                  'IT',
                  'assets/images/italia_flag.png',
                  _selectedLocale == const Locale('it', 'IT'),
                ),
                languageGridTile(
                  context,
                  const Locale('vi', 'VN'),
                  'VI',
                  'assets/images/vietnam_flag.png',
                  _selectedLocale == const Locale('vi', 'VN'),
                ),
                languageGridTile(
                  context,
                  const Locale('tr', 'TR'),
                  'TR',
                  'assets/images/turquia_flag.png',
                  _selectedLocale == const Locale('tr', 'TR'),
                ),
                languageGridTile(
                  context,
                  const Locale('th', 'TH'),
                  'TH',
                  'assets/images/thailandia_flag.png',
                  _selectedLocale == const Locale('th', 'TH'),
                ),
                languageGridTile(
                  context,
                  const Locale('ko', 'KR'),
                  'KO',
                  'assets/images/corea_flag.png',
                  _selectedLocale == const Locale('ko', 'KR'),
                ),
                languageGridTile(
                  context,
                  const Locale('bg', 'BG'),
                  'BG',
                  'assets/images/bulgarian_flag.png',
                  _selectedLocale == const Locale('bg', 'BG'),
                ),
                languageGridTile(
                  context,
                  const Locale('cs', 'CZ'),
                  'CZ',
                  'assets/images/checa_flag.png',
                  _selectedLocale == const Locale('cs', 'CZ'),
                ),
                languageGridTile(
                  context,
                  const Locale('da', 'DK'),
                  'DK',
                  'assets/images/dinamarca_flag.png',
                  _selectedLocale == const Locale('da', 'DK'),
                ),
                languageGridTile(
                  context,
                  const Locale('el', 'GR'),
                  'GR',
                  'assets/images/grecia_flag.png',
                  _selectedLocale == const Locale('el', 'GR'),
                ),
                languageGridTile(
                  context,
                  const Locale('fi', 'FI'),
                  'FI',
                  'assets/images/finlandia_flag.png',
                  _selectedLocale == const Locale('fi', 'FI'),
                ),
                languageGridTile(
                  context,
                  const Locale('he', 'IL'),
                  'IL',
                  'assets/images/israel_flag.png',
                  _selectedLocale == const Locale('he', 'IL'),
                ),
                languageGridTile(
                  context,
                  const Locale('hu', 'HU'),
                  'HU',
                  'assets/images/hungria_flag.png',
                  _selectedLocale == const Locale('hu', 'HU'),
                ),
                languageGridTile(
                  context,
                  const Locale('id', 'ID'),
                  'ID',
                  'assets/images/indonesia_flag.png',
                  _selectedLocale == const Locale('id', 'ID'),
                ),
                languageGridTile(
                  context,
                  const Locale('lt', 'LT'),
                  'LT',
                  'assets/images/lithuania_flag.png',
                  _selectedLocale == const Locale('lt', 'LT'),
                ),
                languageGridTile(
                  context,
                  const Locale('lv', 'LV'),
                  'LV',
                  'assets/images/latvia_flag.png',
                  _selectedLocale == const Locale('lv', 'LV'),
                ),
                languageGridTile(
                  context,
                  const Locale('nb', 'NO'),
                  'NO',
                  'assets/images/noruega_flag.png',
                  _selectedLocale == const Locale('nb', 'NO'),
                ),
                languageGridTile(
                  context,
                  const Locale('nl', 'NL'),
                  'NL',
                  'assets/images/holanda_flag.png',
                  _selectedLocale == const Locale('nl', 'NL'),
                ),
                languageGridTile(
                  context,
                  const Locale('pl', 'PL'),
                  'PL',
                  'assets/images/polonia_flag.png',
                  _selectedLocale == const Locale('pl', 'PL'),
                ),
                languageGridTile(
                  context,
                  const Locale('ro', 'RO'),
                  'RO',
                  'assets/images/romania_flag.png',
                  _selectedLocale == const Locale('ro', 'RO'),
                ),
                languageGridTile(
                  context,
                  const Locale('sk', 'SK'),
                  'SK',
                  'assets/images/slovakia_flag.png',
                  _selectedLocale == const Locale('sk', 'SK'),
                ),
                languageGridTile(
                  context,
                  const Locale('sl', 'SL'),
                  'SL',
                  'assets/images/slovenia_flag.png',
                  _selectedLocale == const Locale('sl', 'SL'),
                ),
                languageGridTile(
                  context,
                  const Locale('sr', 'RS'),
                  'RS',
                  'assets/images/serbia_flag.png',
                  _selectedLocale == const Locale('sr', 'RS'),
                ),
                languageGridTile(
                  context,
                  const Locale('sv', 'SE'),
                  'SE',
                  'assets/images/suecia_flag.png',
                  _selectedLocale == const Locale('sv', 'SE'),
                ),
                languageGridTile(
                  context,
                  const Locale('sw', 'SW'),
                  'SW',
                  'assets/images/swahili_flag.png',
                  _selectedLocale == const Locale('sw', 'SW'),
                ),
                languageGridTile(
                  context,
                  const Locale('tl', 'PH'),
                  'PH',
                  'assets/images/filipinas_flag.png',
                  _selectedLocale == const Locale('tl', 'PH'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget languageGridTile(BuildContext context, Locale locale,
      String languageCode, String flagImage, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLocale = locale;
          // Make sure this method exists and sets the new locale correctly
          context.setLocale(locale);
        });
        Navigator.of(context).pop();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Image.asset(flagImage, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // Padding above the label
            child: Text(
              languageCode,
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make font weight bold
                color: isSelected
                    ? Colors.blue
                    : null, // Blue color for active locale
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getFlagImagePath(Locale locale) {
    // Add all your locales and corresponding flag image paths here
    Map<Locale, String> flagPaths = {
      const Locale('en', 'US'): 'assets/images/usa_flag.png',
      const Locale('es', 'ES'): 'assets/images/spain_flag.png',
      const Locale('fr', 'FR'): 'assets/images/france_flag.png',
      const Locale('pt', 'BR'): 'assets/images/portugal_flag.png',
      const Locale('de', 'DE'): 'assets/images/germany_flag.png',
      const Locale('ru', 'RU'): 'assets/images/russia_flag.png',
      const Locale('ar', 'SA'): 'assets/images/arab_flag.png',
      const Locale('hi', 'IN'): 'assets/images/india_flag.png',
      const Locale('ja', 'JP'): 'assets/images/japon_flag.png',
      const Locale('zh', 'CN'): 'assets/images/china_flag.png',
      const Locale('it', 'IT'): 'assets/images/italia_flag.png',
      const Locale('vi', 'VN'): 'assets/images/vietnam_flag.png',
      const Locale('tr', 'TR'): 'assets/images/turquia_flag.png',
      const Locale('th', 'TH'): 'assets/images/thailandia_flag.png',
      const Locale('ko', 'KR'): 'assets/images/corea_flag.png',
      const Locale('bg', 'BG'): 'assets/images/bulgarian_flag.png',
      const Locale('cs', 'CZ'): 'assets/images/checa_flag.png',
      const Locale('da', 'DK'): 'assets/images/dinamarca_flag.png',
      const Locale('el', 'GR'): 'assets/images/grecia_flag.png',
      const Locale('fi', 'FI'): 'assets/images/finlandia_flag.png',
      const Locale('he', 'IL'): 'assets/images/israel_flag.png',
      const Locale('hu', 'HU'): 'assets/images/hungria_flag.png',
      const Locale('id', 'ID'): 'assets/images/indonesia_flag.png',
      const Locale('lt', 'LT'): 'assets/images/lithuania_flag.png',
      const Locale('lv', 'LV'): 'assets/images/latvia_flag.png',
      const Locale('nb', 'NO'): 'assets/images/noruega_flag.png',
      const Locale('nl', 'NL'): 'assets/images/holanda_flag.png',
      const Locale('pl', 'PL'): 'assets/images/polonia_flag.png',
      const Locale('ro', 'RO'): 'assets/images/romania_flag.png',
      const Locale('sk', 'SK'): 'assets/images/slovakia_flag.png',
      const Locale('sl', 'SL'): 'assets/images/slovenia_flag.png',
      const Locale('sr', 'RS'): 'assets/images/serbia_flag.png',
      const Locale('sv', 'SE'): 'assets/images/suecia_flag.png',
      const Locale('sw', 'SW'): 'assets/images/swahili_flag.png',
      const Locale('tl', 'PH'): 'assets/images/filipinas_flag.png',
    };

    // Return the corresponding flag image path or a default one if not found
    return flagPaths[locale] ?? 'assets/images/usa_flag.png';
  }

  String getLanguageCode(Locale locale) {
    // Add all your locales and corresponding language codes here
    Map<Locale, String> languageCodes = {
      const Locale('en', 'US'): 'EN',
      const Locale('es', 'ES'): 'ES',
      const Locale('fr', 'FR'): 'FR',
      const Locale('pt', 'BR'): 'PT',
      const Locale('de', 'DE'): 'DE',
      const Locale('ru', 'RU'): 'RU',
      const Locale('ar', 'SA'): 'AR',
      const Locale('hi', 'IN'): 'HI',
      const Locale('ja', 'JP'): 'JA',
      const Locale('zh', 'CN'): 'ZH',
      const Locale('it', 'IT'): 'IT',
      const Locale('vi', 'VN'): 'VI',
      const Locale('tr', 'TR'): 'TR',
      const Locale('th', 'TH'): 'TH',
      const Locale('ko', 'KR'): 'KO',
      const Locale('bg', 'BG'): 'BG',
      const Locale('cs', 'CZ'): 'CZ',
      const Locale('da', 'DK'): 'DK',
      const Locale('el', 'GR'): 'GR',
      const Locale('fi', 'FI'): 'FI',
      const Locale('he', 'IL'): 'IL',
      const Locale('hu', 'HU'): 'HU',
      const Locale('id', 'ID'): 'ID',
      const Locale('lt', 'LT'): 'LT',
      const Locale('lv', 'LV'): 'LV',
      const Locale('nb', 'NO'): 'NO',
      const Locale('nl', 'NL'): 'NL',
      const Locale('pl', 'PL'): 'PL',
      const Locale('ro', 'RO'): 'RO',
      const Locale('sk', 'SK'): 'SK',
      const Locale('sl', 'SL'): 'SL',
      const Locale('sr', 'RS'): 'RS',
      const Locale('sv', 'SE'): 'SE',
      const Locale('sw', 'SW'): 'SW',
      const Locale('tl', 'PH'): 'PH',
    };

    // Return the corresponding language code or a default one if not found
    return languageCodes[locale] ?? 'DEFAULT';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth =
        MediaQuery.of(context).size.width; // Get the screen width

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
          SizedBox(
            height: tileHeight, // Set the fixed height
            child: Align(
              alignment: Alignment.center,
              child: SwitchListTile(
                secondary: Icon(Icons.brightness_6,
                    size: 30,
                    color: isDarkMode ? Colors.lightBlue : Colors.grey[800]),
                //color: isDarkMode ? const Color(0xFF6E85B7) : Colors.grey[800]),
                isThreeLine: false,
                dense: false,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: screenWidth * 0.05,
                ),
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
                  // Save the preference
                  _saveThemePreference(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Divider(
            color: isDarkMode ? Colors.white : Colors.grey[800],
            thickness: 2,
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: tileHeight, // Set the fixed height
            child: Align(
              alignment: Alignment.center,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: screenWidth * 0.05,
                ),
                leading: Image.asset(
                  getFlagImagePath(
                      _selectedLocale), // function to get the image path based on locale
                  width: 30, // Adjust the size as needed
                  height: 30, // Adjust the size as needed
                  fit: BoxFit.cover,
                ),
                title: Text(
                  "Language".tr(),
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: fontSize),
                ),
                trailing: Text(
                  getLanguageCode(
                      _selectedLocale), // function to get the language code based on locale
                  style: TextStyle(
                      fontWeight: FontWeight.bold, // Make the text bold
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: fontSize),
                ),
                onTap: _showLanguageDialog, // Open language selection dialog
              ),
            ),
          ),

          const SizedBox(height: 5),
          Divider(
            color: isDarkMode ? Colors.white : Colors.grey[800],
            thickness: 2,
          ),
          const SizedBox(height: 5),

          //FONT SIZE  ROW
          SizedBox(
            height: tileHeight, // Set the fixed height
            child: Align(
              alignment: Alignment.center,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: screenWidth * 0.05,
                ),
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
                tileColor: Colors.transparent,
              ),
            ),
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
          SizedBox(
            height: tileHeight, // Set the fixed height
            child: Align(
              alignment: Alignment.center,
              child: SwitchListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: screenWidth * 0.05,
                ),
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
                      value
                          ? SystemUiMode.immersiveSticky
                          : SystemUiMode.manual,
                      overlays: value ? [] : SystemUiOverlay.values,
                    );
                  });
                  _saveStatusBarVisibility(value); // Save the preference
                },
                secondary: const Icon(Icons.sim_card, size: 38),
                subtitle: Consumer<FontSizeProvider>(
                  builder: (context, fontSizeProvider, child) {
                    return Text(
                      'Enable or disable visibility of status bar',
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: smallFontSize),
                    ).tr();
                  },
                ),
                isThreeLine: true,
                dense: false,
                activeColor: Colors.lightBlue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(0.5),
                activeTrackColor: Colors.lightBlue.withOpacity(0.5),
                tileColor: Colors.transparent,
                selected: statusBarVisible,
                selectedTileColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                autofocus: false,
                visualDensity: VisualDensity.comfortable,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Divider(
            color: isDarkMode ? Colors.white : Colors.grey[800],
            thickness: 2,
          ),
          const SizedBox(height: 5),

          // Haptic Button SwitchListTile
          SizedBox(
            height: tileHeight, // Set the fixed height
            child: Align(
              alignment: Alignment.center,
              child: SwitchListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: screenWidth * 0.05,
                ),
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
                onChanged: (bool value) async {
                  setState(() {
                    hapticFeedback = value;
                  });
                  await _saveHapticPreference(value);
                  // Apply haptic feedback immediately to give instant feedback
                  if (value) {
                    Vibrate.feedback(FeedbackType.light);
                  }
                },
                secondary: const Icon(Icons.touch_app, size: 38),
                subtitle: Consumer<FontSizeProvider>(
                  builder: (context, fontSizeProvider, child) {
                    return Text(
                      'Enable or disable haptic feedback for the buttons',
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: smallFontSize),
                    ).tr();
                  },
                ),
                isThreeLine: true,
                dense: false,
                activeColor: Colors.lightBlue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(0.5),
                activeTrackColor: Colors.lightBlue.withOpacity(0.5),
                tileColor: Colors.transparent,
                selected: hapticFeedback,
                selectedTileColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                autofocus: false,
                visualDensity: VisualDensity.comfortable,
              ),
            ),
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
