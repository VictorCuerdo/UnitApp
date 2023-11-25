import 'dart:async';

import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitapp/controllers/font_size_provider.dart';
import 'package:unitapp/controllers/theme_provider.dart'; // Your ThemeProvider file
import 'package:unitapp/widgets/conversions/angle.dart';
import 'package:unitapp/widgets/conversions/area.dart';
import 'package:unitapp/widgets/conversions/datasizes.dart';
import 'package:unitapp/widgets/conversions/distance.dart';
import 'package:unitapp/widgets/conversions/energy.dart';
import 'package:unitapp/widgets/conversions/force.dart';
import 'package:unitapp/widgets/conversions/frequency.dart';
import 'package:unitapp/widgets/conversions/fuel.dart';
import 'package:unitapp/widgets/conversions/mass.dart';
import 'package:unitapp/widgets/conversions/power.dart';
import 'package:unitapp/widgets/conversions/pressure.dart';
import 'package:unitapp/widgets/conversions/speed.dart';
import 'package:unitapp/widgets/conversions/temperature.dart';
import 'package:unitapp/widgets/conversions/time.dart';
import 'package:unitapp/widgets/conversions/torque.dart';
import 'package:unitapp/widgets/conversions/volume.dart';
import 'package:unitapp/widgets/loading_screen.dart';
import 'package:unitapp/widgets/settings.dart';
import 'package:unitapp/widgets/unit_conversion.dart';

// Import the generated file
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Google Mobile Ads SDK
  unawaited(MobileAds.instance.initialize());
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();

  bool hapticFeedback = await loadHapticPreference();

  FirebaseAnalytics analytics =
      FirebaseAnalytics.instance; // Instantiate FirebaseAnalytics

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('de', 'DE'),
        Locale('zh', 'CN'),
        Locale('ja', 'JP'),
        Locale('pt', 'BR'),
        Locale('ru', 'RU'),
        Locale('ar', 'SA'),
        Locale('hi', 'IN'),
        Locale('it', 'IT'),
        Locale('ko', 'KR'),
        Locale('th', 'TH'),
        Locale('tr', 'TR'),
        Locale('vi', 'VN'),
        Locale('bg', 'BG'),
        Locale('cs', 'CZ'),
        Locale('da', 'DK'),
        Locale('el', 'GR'),
        Locale('fi', 'FI'),
        Locale('he', 'IL'),
        Locale('hu', 'HU'),
        Locale('id', 'ID'),
        Locale('lt', 'LT'),
        Locale('lv', 'LV'),
        Locale('nb', 'NO'),
        Locale('nl', 'NL'),
        Locale('pl', 'PL'),
        Locale('ro', 'RO'),
        Locale('sk', 'SK'),
        Locale('sl', 'SL'),
        Locale('sr', 'RS'),
        Locale('sv', 'SE'),
        Locale('sw', 'SW'),
        Locale('tl', 'PH'),
        Locale('uk', 'UA'),
      ],
      path: 'assets/translations', // Path to translation files
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FontSizeProvider()),
          ChangeNotifierProvider(create: (context) => themeProvider),
          Provider<bool>.value(value: hapticFeedback),
        ],
        child: UnitApp(analytics: analytics),
      ),
    ),
  );
}

Future<bool> loadHapticPreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hapticFeedback') ?? false;
}

class UnitApp extends StatelessWidget {
  final FirebaseAnalytics analytics; // Add analytics as a member variable

  const UnitApp({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    analytics.logEvent(
      name: 'app_open',
      parameters: <String, dynamic>{
        'string_parameter': 'UnitApp Started',
        'int_parameter': 1,
      },
    );

    return MaterialApp(
      title: 'UnitApp'.tr(),
      theme: themeProvider.currentTheme,
      home: const LoadingScreen(),
      routes: {
        '/unit': (context) => const UnitConversion(),
        '/settings': (context) => const SettingsScreen(),
        '/distance': (context) => const DistanceUnitConverter(),
        '/area': (context) => const AreaUnitConverter(),
        '/volume': (context) => const VolumeUnitConverter(),
        '/mass': (context) => const MassUnitConverter(),
        '/time': (context) => const TimeUnitConverter(),
        '/speed': (context) => const SpeedUnitConverter(),
        '/frequency': (context) => const FrequencyUnitConverter(),
        '/force': (context) => const ForceUnitConverter(),
        '/torque': (context) => const TorqueUnitConverter(),
        '/pressure': (context) => const PressureUnitConverter(),
        '/energy': (context) => const EnergyUnitConverter(),
        '/power': (context) => const PowerUnitConverter(),
        '/temperature': (context) => const TemperatureUnitConverter(),
        '/angle': (context) => const AngleUnitConverter(),
        '/fuel': (context) => const FuelUnitConverter(),
        '/datas': (context) => const DatasUnitConverter(),
      },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
