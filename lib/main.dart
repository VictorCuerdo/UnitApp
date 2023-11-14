import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import 'package:flutter/material.dart';
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
import 'package:unitapp/widgets/settings.dart';
import 'package:unitapp/widgets/unit_conversion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();

  bool hapticFeedback = await loadHapticPreference();

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
        Locale('vi', 'VN')
      ],
      path: 'assets/translations', // Path to translation files
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FontSizeProvider()),
          ChangeNotifierProvider(create: (context) => themeProvider),
          Provider<bool>.value(value: hapticFeedback),
        ], // Provide the haptic feedback value
        child: const UnitApp(),
      ),
    ),
  );
}

Future<bool> loadHapticPreference() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hapticFeedback') ?? false;
}

class UnitApp extends StatelessWidget {
  const UnitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'UnitApp'.tr(),
      theme: themeProvider.currentTheme,
      home: const UnitConversion(),
      routes: {
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
      locale: context.locale, // Add locale
    );
  }
}
