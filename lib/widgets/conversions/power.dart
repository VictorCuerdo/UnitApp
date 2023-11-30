// ignore_for_file: library_private_types_in_public_api
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitapp/controllers/navigation_utils.dart';

class PowerUnitConverter extends StatefulWidget {
  const PowerUnitConverter({super.key});

  @override
  _PowerUnitConverterState createState() => _PowerUnitConverterState();
}

class _PowerUnitConverterState extends State<PowerUnitConverter> {
  static const double mediumFontSize = 17.0;
  GlobalKey tooltipKey = GlobalKey();
  double fontSize = mediumFontSize;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Watts';
  String toUnit = 'Kilowatts';
  // Removed duplicate declarations of TextEditingController
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  bool _isExponentialFormat = false;
  // Flag to indicate if the change is due to user input
  bool _isUserInput = true;
  // Using string variables for prefixes
  String fromPrefix = '';
  String toPrefix = '';
  final ScreenshotController screenshotController = ScreenshotController();
  String _conversionFormula = '';
  final GlobalKey _contentKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    fromUnit = ''; // Represent unselected state with an empty string
    toUnit = ''; // Represent unselected state with an empty string

    // Add listener to fromController
    fromController.addListener(() {
      if (_isUserInput) {
        convert(fromController.text); // Pass the raw text to convert
      }
    });

    // Initialize the conversion formula text
    _conversionFormula = _getConversionFormula();
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void _resetToDefault() {
    setState(() {
      fromController.clear();
      toController.clear();
      fromUnit = ''; // Set to an empty string or a valid default value
      toUnit = ''; // Set to an empty string or a valid default value
      _isExponentialFormat = false;
      _conversionFormula = _getConversionFormula();
    });
  }

  String chooseFontFamily(Locale currentLocale) {
    // List of locales supported by 'Lato'
    const supportedLocales = [
      'en',
      'es',
      'fr',
      'de',
      'zh',
      'ja',
      'pt',
      'ru',
      'ar',
      'hi',
      'it',
      'ko',
      'th',
      'vi',
      'bg',
      'da',
      'el',
      'fi',
      'he',
      'id',
      'lv',
      'nb',
      'nl',
      'pl',
      'sr',
      'sv',
      'sw',
      'tl',
      'uk',
      'ro',
    ];

    if (supportedLocales.contains(currentLocale.languageCode)) {
      return 'Lato'; // Primary font
    } else if (currentLocale.languageCode == 'lt') {
      return 'PTSans'; // Use PT Sans for Lithuanian
    } else {
      return 'AbhayaLibre'; // Fallback to Abhaya Libre for other languages
    }
  }

  void _takeScreenshotAndShare() async {
    // Capture the screenshot using the screenshotController
    final Uint8List? imageBytes = await screenshotController.capture();
    if (imageBytes != null) {
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/screenshot.png').create();
      await imagePath.writeAsBytes(imageBytes);
      // Using shareXFiles
      await Share.shareXFiles([XFile(imagePath.path)],
          text: 'Check out my power result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

    switch (fromUnit) {
      case 'Watts':
        switch (toUnit) {
          case 'Kilowatts':
            toValue = fromValue / 1000.0;
            break;
          case 'Megawatts':
            toValue = fromValue / 1000000.0;
            break;
          case 'Gigawatts':
            toValue = fromValue / 1000000000.0;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600.0;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3.6;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.23884589663; // Calories per second
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859.84522785899; // Calories per hour
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.00023884590; // Kilocalories per second
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 0.85984522786; // Kilocalories per hour
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.00134102209; // Mechanical horsepower
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.00135962162; // Metric horsepower
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3.412142;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737.5621;
            break;
          case 'Watts': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilowatts':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1000.0;
            break;
          case 'Megawatts':
            toValue = fromValue / 1000.0;
            break;
          case 'Gigawatts':
            toValue = fromValue / 1000000.0;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000.0;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600.0;
            break;
          case 'Calories per Second':
            toValue = fromValue * 238.84589663; // Calories per second
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859845.22785899; // Calories per hour
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.23884590; // Kilocalories per second
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 859.84522786; // Kilocalories per hour
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 1.34102209; // Mechanical horsepower
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 1.35962162; // Metric horsepower
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3412.142;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737562.1;
            break;
          case 'Kilowatts': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Megawatts':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1000000;
            break;
          case 'Kilowatts':
            toValue = fromValue * 1000;
            break;
          case 'Gigawatts':
            toValue = fromValue / 1000;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000000;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600000;
            break;
          case 'Calories per Second':
            toValue = fromValue * 239005.7361377;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859845227.2961;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 239.0057361;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 859845.2272961;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 1341.0220896;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 1359.6216173;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3412142;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737562149.277;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Gigawatts':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1000000000;
            break;
          case 'Kilowatts':
            toValue = fromValue * 1000000;
            break;
          case 'Megawatts':
            toValue = fromValue * 1000;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000000000;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600000000;
            break;
          case 'Calories per Second':
            toValue = fromValue * 239005736137.7;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859845227296.1;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 239005736.1377;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 859845227.2961;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 1341022.0896;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 1359621.6173;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3412142000;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737562149277;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Joules per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue / 3600;
            break;
          case 'Kilowatts':
            toValue = fromValue / 3.6;
            break;
          case 'Megawatts':
            toValue = fromValue / 3.6e6;
            break;
          case 'Gigawatts':
            toValue = fromValue / 3.6e9;
            break;
          case 'Joules per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue / 1000;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.000239006;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 0.859845227;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 2.39006e-7;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 0.859845227;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 3.725062e-4;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 3.776726e-4;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 0.947817;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 0.737562;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilojoules per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 3600;
            break;
          case 'Kilowatts':
            toValue = fromValue * 3.6;
            break;
          case 'Megawatts':
            toValue = fromValue / 3.6e3;
            break;
          case 'Gigawatts':
            toValue = fromValue / 3.6e6;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 1000;
            break;
          case 'Kilojoules per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.239006;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859.845227;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 2.39006e-4;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 0.859845227;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.3725062e-3;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.3776726e-3;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 947.817;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737.562;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Calories per Second':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 4186.8;
            break;
          case 'Kilowatts':
            toValue = fromValue * 4.1868;
            break;
          case 'Megawatts':
            toValue = fromValue * 4.1868e-3;
            break;
          case 'Gigawatts':
            toValue = fromValue * 4.1868e-6;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600;
            break;
          case 'Calories per Second': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 3600;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.001;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 3.6;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.002650286;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.002684519;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3.96832;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 3088.025206;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Calories per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1.163;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.001163;
            break;
          case 'Megawatts':
            toValue = fromValue * 1.163e-6;
            break;
          case 'Gigawatts':
            toValue = fromValue * 1.163e-9;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 4186800;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 4186.8;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.000277778;
            break;
          case 'Calories per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.000000277778;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 0.001;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.0000007457;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.00000075302;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 0.001;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 0.737562;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilocalories per Second':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 4186.8;
            break;
          case 'Kilowatts':
            toValue = fromValue * 4.1868;
            break;
          case 'Megawatts':
            toValue = fromValue * 4.1868e-3;
            break;
          case 'Gigawatts':
            toValue = fromValue * 4.1868e-6;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600;
            break;
          case 'Calories per Second':
            toValue = fromValue * 1000;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 3600000;
            break;
          case 'Kilocalories per Second': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 3600;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.002650286;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.002684519;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3.96832;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 3088.025206;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilocalories per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1.163;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.001163;
            break;
          case 'Megawatts':
            toValue = fromValue * 1.163e-6;
            break;
          case 'Gigawatts':
            toValue = fromValue * 1.163e-9;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 4186800;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 4186.8;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.000277778;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 1000;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.000000277778;
            break;
          case 'Kilocalories per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.0000007457;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.00000075302;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 0.001;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 0.737562;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
      case 'Horsepowers (Mechanical)':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 745.7;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.7457;
            break;
          case 'Megawatts':
            toValue = fromValue * 7.457e-4;
            break;
          case 'Gigawatts':
            toValue = fromValue * 7.457e-7;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 2684519.52;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 2684.51952;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.17787814;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 640.361304;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.00017787814;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 640.361304;
            break;
          case 'Horsepowers (Mechanical)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.9863201;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 2544.433588;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 550.98416;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Horsepowers (Metric)':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 735.49875;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.73549875;
            break;
          case 'Megawatts':
            toValue = fromValue * 7.3549875e-4;
            break;
          case 'Gigawatts':
            toValue = fromValue * 7.3549875e-7;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 2655223.7374;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 2655.2237374;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.17657312;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 636.8628136;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.00017657312;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 636.8628136;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 1.014;
            break;
          case 'Horsepowers (Metric)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 2604.277961;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 560.98709;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'British Thermal Units per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 0.29307107;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.00029307107;
            break;
          case 'Megawatts':
            toValue = fromValue * 2.9307107e-7;
            break;
          case 'Gigawatts':
            toValue = fromValue * 2.9307107e-10;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 1055.05585262;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 1.05505585262;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.00027777778;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 1000.0;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 2.7777778e-7;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 1000.0;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.00039301477;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.00039849016;
            break;
          case 'British Thermal Units per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 2.6552237;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Foot-pounds Force Per Second':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 0.73756215;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.00073756215;
            break;
          case 'Megawatts':
            toValue = fromValue * 7.3756215e-7;
            break;
          case 'Gigawatts':
            toValue = fromValue * 7.3756215e-10;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 2655.2237374;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 2.6552237374;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.000698075;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 2513.47;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 6.98075e-7;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 2513.47;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.0009863201;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.001;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 0.37792981;
            break;
          case 'Foot-pounds Force Per Second': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      default:
        // Optionally handle unknown unit conversions
        toValue = 0;
        break;
    }

    // Update toController text and conversion formula only if necessary.
    if (_isUserInput) {
      setState(() {
        // Update the display with formatted or exponential number as needed.
        toController.text = _formatNumber(toValue, forDisplay: true);
        _conversionFormula = _getConversionFormula();
      });
    }
  }

  String _formatNumber(double value, {bool forDisplay = false}) {
    if (_isExponentialFormat && forDisplay) {
      // Return the number in exponential format.
      return value.toStringAsExponential(2);
    } else if (forDisplay) {
      // Format the number for display with commas and a sensible number of decimal places.
      NumberFormat numberFormat = NumberFormat.decimalPattern();
      return numberFormat.format(value);
    } else {
      // Return a plain string representation of the number for internal use.
      return value.toString();
    }
  }

  void swapUnits() {
    setState(() {
      String tempUnit = fromUnit;
      String tempPrefix = fromPrefix;

      // Swap only the units and prefixes, not the values in the TextFields.
      fromUnit = toUnit;
      fromPrefix = toPrefix;

      toUnit = tempUnit;
      toPrefix = tempPrefix;

      // We do not switch the text values of the controllers anymore.
      // fromController.text and toController.text remain unchanged.

      String unformattedText = fromController.text.replaceAll(',', '');
      convert(unformattedText);
      _conversionFormula =
          _getConversionFormula(); // Update formula text if needed
    });
  }

  String _getConversionFormula() {
    String formula;
    switch (fromUnit) {
// WATTS
      case 'Watts':
        switch (toUnit) {
          case 'Watts':
            formula = 'The value remains unchanged';
            break;
          case 'Kilowatts':
            formula = 'Divide the power value by 1000';
            break;
          case 'Megawatts':
            formula = 'Divide the power value by 1e+6';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 1e+9';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 0.239';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 860.421';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.000239';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 0.860421';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.001341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.001359';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412142';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 737.5621';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOWATTS
      case 'Kilowatts':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1000';
            break;
          case 'Kilowatts':
            formula = 'The value remains unchanged';
            break;
          case 'Megawatts':
            formula = 'Divide the power value by 1000';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 1e+6';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3.6e+6';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 239';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 860421';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.239';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 860421';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 1.341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1.359';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3412.142';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 737562.1';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// MEGAWATTS
      case 'Megawatts':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1e+6';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 1000';
            break;
          case 'Megawatts':
            formula = 'The value remains unchanged';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 1000';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3.6e+9';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6e+6';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 2.39e+5';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 8.604e+8';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 239';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 8.604e+5';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 1341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1359';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412e+6';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 7.376e+8';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// GIGAWATTS
      case 'Gigawatts':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1e+9';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 1e+6';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 1000';
            break;
          case 'Gigawatts':
            formula = 'The value remains unchanged';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3.6e+12';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6e+9';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 2.39e+8';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 8.604e+11';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 2.39e+5';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 8.604e+8';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 1.341e+6';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1.359e+6';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412e+9';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 7.376e+11';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// JOULES PER HOUR
      case 'Joules per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Divide the power value by 3600';
            break;
          case 'Kilowatts':
            formula = 'Divide the power value by 3.6e+6';
            break;
          case 'Megawatts':
            formula = 'Divide the power value by 3.6e+9';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 3.6e+12';
            break;
          case 'Joules per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Kilojoules per Hour':
            formula = 'Divide the power value by 3600';
            break;
          case 'Calories per Second':
            formula = 'Divide the power value by 860420.65';
            break;
          case 'Calories per Hour':
            formula = 'Divide the power value by 3.096e+9';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 860.42';
            break;
          case 'Kilocalories per Hour':
            formula = 'Divide the power value by 3.096e+6';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Divide the power value by 745699.87';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Divide the power value by 735498.75';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Divide the power value by 1055.06';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Divide the power value by 2260000';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOJOULES PER HOUR
      case 'Kilojoules per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 3600000';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 1000';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilojoules per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 239.005736';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 860.42185';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 3600';
            break;
          case 'Kilocalories per Hour':
            formula = 'Divide the power value by 3.6';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Divide the power value by 745.699872';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Divide the power value by 735.49875';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Divide the power value by 1.055056';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 737.562149';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// CALORIES PER SECOND
      case 'Calories per Second':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 4184';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 4.184';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 4.184e-6';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 4.184e-9';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600000';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Calories per Second':
            formula = 'The value remains unchanged';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 1000';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.001';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.00101387';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412142';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3088.025207';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// CALORIES PER HOUR
      case 'Calories per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1.162222';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.001162222';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 1.162222e-9';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 1.162222e-12';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Calories per Second':
            formula = 'Divide the power value by 3600';
            break;
          case 'Calories per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 3.6e+6';
            break;
          case 'Kilocalories per Hour':
            formula = 'Divide the power value by 3600';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.000001341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.0000013596';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 0.00396832';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3.0841';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// KILOCALORIES PER SECOND
      case 'Kilocalories per Second':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 4184';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 4.184';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 4.184e-6';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 4.184e-9';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600000';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 1000';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 3600000';
            break;
          case 'Kilocalories per Second':
            formula = 'The value remains unchanged';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 1.341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1.359621617';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412142';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3088.025207';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOCALORIES PER HOUR
      case 'Kilocalories per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1.162222';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.001162222';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 1.162222e-9';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 1.162222e-12';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Calories per Second':
            formula = 'Divide the power value by 3600';
            break;
          case 'Calories per Hour':
            formula = 'Divide the power value by 3600';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 3600';
            break;
          case 'Kilocalories per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.000001341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.0000013596';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 0.00396832';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3.0841';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// HORSEPOWERS (MECHANICAL)
      case 'Horsepowers (Mechanical)':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 745.7';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.7457';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 0.0007457';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 7.457e-7';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 2684519.5';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 2684.5195';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 178.097245';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 641.149682';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.178097245';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 641.149682';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'The value remains unchanged';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1.0139';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 2544.433595';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 550.547868';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// HORSEPOWERS (METRIC)
      case 'Horsepowers (Metric)':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 735.5';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.7355';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 0.0007355';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 7.355e-7';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 2655223.7';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 2655.2237';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 176.726789';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 636.216441';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.176726789';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 636.216441';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.9863';
            break;
          case 'Horsepowers (Metric)':
            formula = 'The value remains unchanged';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 2519.92893';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 542.476045';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// BRITISH THERMAL UNITS PER HOUR
      case 'British Thermal Units per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 0.29307107';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.00029307107';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 2.9307107e-7';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 2.9307107e-10';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 1055.0559';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 1.0550559';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 0.06996026';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 251.05694';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.00006996026';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 251.05694';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.00039301478';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.00037712213';
            break;
          case 'British Thermal Units per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3600';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// FOOT-POUNDS FORCE PER SECOND
      case 'Foot-pounds Force Per Second':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1.35581795';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.00135581795';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 1.35581795e-6';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 1.35581795e-9';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 4882.434';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 4.882434';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 0.32404842';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 1166.5747';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.00032404842';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 1166.5747';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.00018181818';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.00017461921';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 0.00027777778';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

      default:
        formula = 'Pick units to start';
    }
    return formula;
  }

  void copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Conversion result copied to clipboard!").tr(),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
        controller: screenshotController,
        child: Scaffold(
          backgroundColor:
              isDarkMode ? const Color(0xFF2C3A47) : const Color(0xFFF0F0F0),
          resizeToAvoidBottomInset:
              true, // Adjust the body size when the keyboard is visible
          body: SafeArea(
            child: SingleChildScrollView(
              // Allow the body to be scrollable
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20), // Adjust space as needed
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // This centers the children horizontally
                      mainAxisSize: MainAxisSize
                          .max, // This makes the row take up all available horizontal space
                      children: [
                        IconButton(
                          onPressed: () async {
                            // Haptic feedback logic
                            final prefs = await SharedPreferences.getInstance();
                            final hapticFeedbackEnabled =
                                prefs.getBool('hapticFeedback') ?? false;
                            if (hapticFeedbackEnabled) {
                              bool canVibrate = await Vibrate.canVibrate;
                              if (canVibrate) {
                                Vibrate.feedback(FeedbackType.medium);
                              }
                            }

                            context.navigateTo('/unit');
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 40,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF2C3A47),
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText('Convert Power'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: chooseFontFamily(
                                    Localizations.localeOf(context)),
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF2C3A47),
                              ),
                              maxLines:
                                  1, // Change this to 2 if you want to allow text to take up two lines
                              minFontSize: 15),
                        ),
                        const IconButton(
                          onPressed: null,
                          icon: Icon(Icons.arrow_back,
                              size: 40, color: Colors.transparent),
                        ), // You can place an invisible IconButton here to balance the row if necessary
                      ],
                    ),

                    const SizedBox(height: 150),

                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Tooltip(
                            message:
                                'If the displayed result is 0, change the format'
                                    .tr(), // Add your tooltip text here
                            child: IconButton(
                              icon: Icon(Icons.info_outline,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.grey[
                                          800]), // Use an appropriate icon
                              onPressed: () {
                                // Add action if needed, or leave empty for a simple tooltip
                              },
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              'Exponential Format'.tr(),
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF2C3A47),
                                fontSize: 18,
                              ),
                              maxLines: 1, // You can adjust this as needed
                              minFontSize:
                                  14, // Set the minimum font size you allow (optional)
                            ),
                          ),
                        ],
                      ),
                      trailing: Switch(
                        value: _isExponentialFormat,
                        onChanged: (bool value) async {
                          // Haptic feedback logic
                          final prefs = await SharedPreferences.getInstance();
                          final hapticFeedbackEnabled =
                              prefs.getBool('hapticFeedback') ?? false;
                          if (hapticFeedbackEnabled) {
                            bool canVibrate = await Vibrate.canVibrate;
                            if (canVibrate) {
                              Vibrate.feedback(FeedbackType.light);
                            }
                          }

                          // Existing switch logic
                          setState(() {
                            _isExponentialFormat = value;
                            double? lastValue = double.tryParse(
                                fromController.text.replaceAll(',', ''));
                            if (lastValue != null) {
                              fromController.text =
                                  _formatNumber(lastValue, forDisplay: true);
                            }
                            convert(fromController.text);
                          });
                        },
                        activeColor: Colors.lightBlue,
                        activeTrackColor: Colors.lightBlue.shade200,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 0.125, right: 0.125),
                      width: double.infinity,
                      child: _buildUnitColumn('From'.tr(), fromController,
                          fromUnit, fromPrefix, true),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.swap_vert,
                        color:
                            isDarkMode ? Colors.grey : const Color(0xFF374259),
                        size: 40,
                      ),
                      onPressed: () async {
                        // Call your swapUnits function.
                        swapUnits();

                        // Haptic feedback logic
                        final prefs = await SharedPreferences.getInstance();
                        final hapticFeedbackEnabled =
                            prefs.getBool('hapticFeedback') ?? false;
                        if (hapticFeedbackEnabled) {
                          bool canVibrate = await Vibrate.canVibrate;
                          if (canVibrate) {
                            Vibrate.feedback(FeedbackType.heavy);
                          }
                        }
                      },
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 0.125, right: 0.125),
                      width: double.infinity,
                      child: _buildUnitColumn(
                          'To'.tr(), toController, toUnit, toPrefix, false),
                    ),
                    const SizedBox(height: 30),
                    AutoSizeText.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Formula:  '.tr(),
                            style: TextStyle(
                              color: isDarkMode ? Colors.orange : Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: _conversionFormula.tr(),
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF2C3A47),
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      minFontSize:
                          10, // The minimum text size you want to allow
                      stepGranularity:
                          1, // The step size for downscaling the font
                      maxLines:
                          3, // The max number of lines for the text to span, can be set to null
                      overflow: TextOverflow
                          .ellipsis, // How to handle text that doesn't fit
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          floatingActionButton: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // Check if the contentKey is attached to an existing widget and obtain its size
              final RenderBox? contentBox =
                  _contentKey.currentContext?.findRenderObject() as RenderBox?;
              // The height of the content will be used to adjust the padding dynamically
              final contentHeight = contentBox?.size.height ?? 0;
              // The available height for the buttons is the total height minus the content's height
              final availableHeight =
                  MediaQuery.of(context).size.height - contentHeight;

              // Ensure there is always some space between the content and the buttons
              final bottomPadding =
                  max(MediaQuery.of(context).padding.bottom + 20, 20.0);

              // If the available height is less than a certain threshold, add additional padding
              final extraPadding = availableHeight < 600 ? 50.0 : 0.0;

              return Container(
                margin: EdgeInsets.only(
                  bottom: bottomPadding + extraPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      highlightElevation:
                          BouncingScrollSimulation.maxSpringTransferVelocity,
                      enableFeedback: true,
                      splashColor: Colors.red,
                      tooltip: 'Reset default settings'.tr(),
                      heroTag: 'resetButton',
                      onPressed: () async {
                        // Haptic feedback logic
                        final prefs = await SharedPreferences.getInstance();
                        final hapticFeedbackEnabled =
                            prefs.getBool('hapticFeedback') ?? false;
                        if (hapticFeedbackEnabled) {
                          bool canVibrate = await Vibrate.canVibrate;
                          if (canVibrate) {
                            Vibrate.feedback(FeedbackType.medium);
                          }
                        }

                        // Original reset logic
                        _resetToDefault();
                      },
                      backgroundColor:
                          isDarkMode ? Colors.white : const Color(0xFF2C3A47),
                      child: Icon(Icons.restart_alt,
                          size: 36,
                          color: isDarkMode ? Colors.black : Colors.white),
                    ),
                    FloatingActionButton(
                      tooltip: 'Share a screenshot of your results!'.tr(),
                      heroTag: 'shareButton',
                      onPressed: () async {
                        // Haptic feedback logic
                        final prefs = await SharedPreferences.getInstance();
                        final hapticFeedbackEnabled =
                            prefs.getBool('hapticFeedback') ?? false;
                        if (hapticFeedbackEnabled) {
                          bool canVibrate = await Vibrate.canVibrate;
                          if (canVibrate) {
                            Vibrate.feedback(FeedbackType.medium);
                          }
                        }

                        // Original share logic
                        _takeScreenshotAndShare();
                      },
                      backgroundColor:
                          isDarkMode ? Colors.white : const Color(0xFF2C3A47),
                      child: Icon(Icons.share,
                          size: 36,
                          color: isDarkMode ? Colors.black : Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }

  String _getPrefix(String unit) {
    switch (unit) {
      case 'Watts':
        return 'W';
      case 'Kilowatts':
        return 'kW';
      case 'Megawatts':
        return 'MW';
      case 'Gigawatts':
        return 'GW';
      case 'Joules per Hour':
        return 'J/h';
      case 'Kilojoules per Hour':
        return 'kJ/h';
      case 'Calories per Second':
        return 'cal/s';
      case 'Calories per Hour':
        return 'cal/h';
      case 'Kilocalories per Second':
        return 'kcal/s';
      case 'Kilocalories per Hour':
        return 'kcal/h';
      case 'Horsepowers (Mechanical)':
        return 'hp';
      case 'Horsepowers (Metric)':
        return 'hp(M)';
      case 'British Thermal Units per Hour':
        return 'BTU/h';
      case 'Foot-pounds Force Per Second':
        return 'ft·lbf/s';
      default:
        return ''; // In case the unit is not recognized
    }
  }

  Widget _buildUnitColumn(String label, TextEditingController controller,
      String unit, String prefix, bool isFrom) {
    // Define text color based on the theme.
    Color inputTextColor = isDarkMode ? Colors.white : Colors.black;
    Color inputFillColor = isDarkMode
        ? const Color(0xFF2C3A47)
        : Colors.white; // This should be light in both themes
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.125),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isFrom)
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              onChanged: (value) {
                _isUserInput =
                    true; // Set this flag to true to indicate user input.
                convert(
                    value); // Call convert directly with the current input value.
              },
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: inputTextColor, // Adjust text color based on the theme
              ),
              decoration: InputDecoration(
                labelText: label,
                filled: true,
                fillColor:
                    inputFillColor, // Use a fill color that contrasts with the text color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 3.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                isDense: true,
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      '$prefix ',
                      style: const TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.content_copy,
                      color: Colors.transparent, size: 23),
                  onPressed: () => copyToClipboard(controller.text, context),
                ),
              ),
            )
          else
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              readOnly: true, // Make it read-only instead of disabled
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: inputTextColor, // Adjust text color based on the theme
              ),
              decoration: InputDecoration(
                labelText: label.tr(),
                filled: true,
                fillColor:
                    inputFillColor, // Use a fill color that contrasts with the text color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                isDense: true,
                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      '$prefix ',
                      style: const TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.content_copy, size: 23),
                  onPressed: () async {
                    // Call your copyToClipboard function.
                    copyToClipboard(controller.text, context);

                    // Haptic feedback logic
                    final prefs = await SharedPreferences.getInstance();
                    final hapticFeedbackEnabled =
                        prefs.getBool('hapticFeedback') ?? false;
                    if (hapticFeedbackEnabled) {
                      bool canVibrate = await Vibrate.canVibrate;
                      if (canVibrate) {
                        Vibrate.feedback(FeedbackType.selection);
                      }
                    }
                  },
                ),
              ),
            ),
          const SizedBox(
              height: 10), // Space between the TextField and dropdown
          _buildDropdownButton(label.toLowerCase(), unit, isFrom),
        ],
      ),
    );
  }

  // Correct the method signature by adding the isFrom parameter
  Widget _buildDropdownButton(String type, String currentValue, bool isFrom) {
    List<DropdownMenuItem<String>> items = <String>[
      'Watts',
      'Kilowatts',
      'Megawatts',
      'Gigawatts',
      'Joules per Hour',
      'Kilojoules per Hour',
      'Calories per Second',
      'Calories per Hour',
      'Kilocalories per Second',
      'Kilocalories per Hour',
      'Horsepowers (Mechanical)',
      'Horsepowers (Metric)',
      'British Thermal Units per Hour',
      'Foot-pounds Force Per Second',
    ].map<DropdownMenuItem<String>>((String value) {
      String translatedValue = value.tr();
      return DropdownMenuItem<String>(
        value: value,
        child: AutoSizeText.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${_getPrefix(value)} - ', // Prefix part with the dash
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Make prefix bold
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              TextSpan(
                text: translatedValue, // The translated value
                style: TextStyle(
                  fontWeight: FontWeight.normal, // Normal weight for the rest
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.left,
          minFontSize: 10, // The minimum text size you want to allow
          stepGranularity: 1, // The step size for downscaling the font
          maxLines: 1, // The max number of lines for the text to span
          overflow:
              TextOverflow.ellipsis, // How to handle text that doesn't fit
          style: const TextStyle(
            fontSize: 23, // This is the starting font size
          ),
        ),
      );
    }).toList();

    items.insert(
      0,
      DropdownMenuItem<String>(
        value: '',
        enabled: false,
        child: AutoSizeText(
          'Choose a conversion unit'.tr(),
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black, fontSize: 20),
          minFontSize: 12,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor:
            //isDarkMode ? const Color(0xFF303134) : const Color(0xFFADC4CE),
            //DBE6FD
            //isDarkMode ? const Color(0xFF303134) : const Color(0xFFF5F5F5),
            isDarkMode ? const Color(0xFF303134) : const Color(0xFFDBE6FD),
      ),
      value: currentValue.isNotEmpty ? currentValue : null,
      hint: AutoSizeText(
        'Choose a conversion unit'.tr(),
        style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF374259),
            fontSize: 20),
        textAlign: TextAlign.center,
        minFontSize: 12,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onChanged: (String? newValue) async {
        // Haptic feedback logic
        final prefs = await SharedPreferences.getInstance();
        final hapticFeedbackEnabled = prefs.getBool('hapticFeedback') ?? false;
        if (hapticFeedbackEnabled && newValue != null && newValue.isNotEmpty) {
          bool canVibrate = await Vibrate.canVibrate;
          if (canVibrate) {
            Vibrate.feedback(FeedbackType.medium);
          }
        }

        // Original onChanged logic
        if (newValue != null && newValue.isNotEmpty) {
          setState(() {
            if (isFrom) {
              fromUnit = newValue;
              fromPrefix = _getPrefix(newValue);
            } else {
              toUnit = newValue;
              toPrefix = _getPrefix(newValue);
            }
            convert(fromController.text);
          });
        }
      },
      dropdownColor:
          isDarkMode ? const Color(0xFF303134) : const Color(0xFFDBE6FD),
      items: items,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down,
          color: isDarkMode ? Colors.white : Colors.black),
      iconSize: 26,
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((DropdownMenuItem<String> item) {
          return Center(
            child: AutoSizeText(
              item.value == ''
                  ? 'Choose a conversion unit'.tr()
                  : item.value!.tr(),
              style: TextStyle(
                color: isDarkMode ? const Color(0xFF9CC0C5) : Colors.black,
                fontSize: 20,
              ),
              minFontSize: 12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
    );
  }
}
