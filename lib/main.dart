import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitapp/controllers/font_size_provider.dart';
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
  WidgetsFlutterBinding.ensureInitialized(); // Ensure everything is initialized
  await EasyLocalization.ensureInitialized(); // Initialize EasyLocalization
  runApp(
    EasyLocalization(
      // Wrap your app with EasyLocalization
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
      path: 'assets/translations', // Path to your translations folder
      fallbackLocale: const Locale('en',
          'US'), // Fallback locale in case the system locale is not supported
      child: const unitapp(),
    ),
  );
}

class unitapp extends StatelessWidget {
  const unitapp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = FontSizeProvider();
        // Adding a listener to print the font size whenever it changes
        provider.addListener(() {
          print('Font Size Updated: ${provider.fontSize}');
        });
        return provider;
      },
      child: MaterialApp(
        title: 'unitapp'.tr(), // Use .tr() to translate the app title
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
        localizationsDelegates:
            context.localizationDelegates, // Add localization delegates
        supportedLocales: context.supportedLocales, // Add supported locales
        locale: context.locale, // Add locale
      ),
    );
  }
}
