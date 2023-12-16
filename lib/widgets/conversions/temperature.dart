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

import '../action_row_button.dart';

class TemperatureUnitConverter extends StatefulWidget {
  const TemperatureUnitConverter({super.key});

  @override
  _TemperatureUnitConverterState createState() =>
      _TemperatureUnitConverterState();
}

class _TemperatureUnitConverterState extends State<TemperatureUnitConverter> {
  GlobalKey tooltipKey = GlobalKey();
  static const double mediumFontSize = 17.0;
  double fontSize = mediumFontSize;
  bool isTyping = false;

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Degrees Celsius';
  String toUnit = 'Kelvins';

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

  Future<void> _handleActionButtonPress({
    required FeedbackType hapticFeedback,
    required VoidCallback actionLogic,
  }) async {
    // Haptic feedback logic
    final prefs = await SharedPreferences.getInstance();
    final hapticFeedbackEnabled = prefs.getBool('hapticFeedback') ?? false;
    if (hapticFeedbackEnabled) {
      bool canVibrate = await Vibrate.canVibrate;
      if (canVibrate) {
        Vibrate.feedback(hapticFeedback);
      }
    }

    // Execute the provided action logic
    actionLogic();
  }

  String chooseFontFamily(Locale currentLocale) {
    // List of locales supported by 'Lato'
    const supportedLocales = [
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
      'nb',
      'nl',
      'pl',
      'sr',
      'sv',
      'sw',
      'tl',
      'uk',
    ];

    if (supportedLocales.contains(currentLocale.languageCode)) {
      return 'Lato'; // Primary font
    } else if (currentLocale.languageCode == 'lt') {
      return 'PTSans'; // Use PT Sans for Lithuanian
    } else {
      return 'AbhayaLibre'; // Fallback to Abhaya Libre for other languages
    }
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
          text: 'Check out my temperature conversion result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

    switch (fromUnit) {
      case 'Degrees Celsius':
        switch (toUnit) {
          case 'Kelvins':
            toValue = fromValue + 273.15;
            break;
          case 'Degrees Fahrenheit':
            toValue = fromValue * 9 / 5 + 32;
            break;
          case 'Degrees Rankine':
            toValue = (fromValue + 273.15) * 9 / 5;
            break;
          case 'Degrees Newton':
            toValue = fromValue * 33 / 100;
            break;
          case 'Degrees Réaumur':
            toValue = fromValue * 4 / 5;
            break;
          case 'Degrees Rømer':
            toValue = (fromValue - 0) * 21 / 40 + 7.5;
            break;
          case 'Degrees Delisle':
            toValue = (100 - fromValue) * 3 / 2;
            break;
          case 'Degrees Celsius': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kelvins':
        switch (toUnit) {
          case 'Degrees Celsius':
            toValue = fromValue - 273.15;
            break;
          case 'Degrees Fahrenheit':
            toValue = (fromValue - 273.15) * 9 / 5 + 32;
            break;
          case 'Degrees Rankine':
            toValue = fromValue * 9 / 5;
            break;
          case 'Degrees Newton':
            toValue = (fromValue - 273.15) * 33 / 100;
            break;
          case 'Degrees Réaumur':
            toValue = (fromValue - 273.15) * 4 / 5;
            break;
          case 'Degrees Rømer':
            toValue = (fromValue - 273.15) * 21 / 40 + 7.5;
            break;
          case 'Degrees Delisle':
            toValue = (373.15 - fromValue) * 3 / 2;
            break;
          case 'Kelvins': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Degrees Fahrenheit':
        switch (toUnit) {
          case 'Degrees Celsius':
            toValue = (fromValue - 32) * 5 / 9;
            break;
          case 'Kelvins':
            toValue = (fromValue + 459.67) * 5 / 9;
            break;
          case 'Degrees Rankine':
            toValue = fromValue + 459.67;
            break;
          case 'Degrees Newton':
            toValue = (fromValue - 32) * 11 / 60;
            break;
          case 'Degrees Réaumur':
            toValue = (fromValue - 32) * 4 / 9;
            break;
          case 'Degrees Rømer':
            toValue = (fromValue - 32) * 7 / 24 + 7.5;
            break;
          case 'Degrees Delisle':
            toValue = (212 - fromValue) * 5 / 6;
            break;
          case 'Degrees Fahrenheit': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Degrees Rankine':
        switch (toUnit) {
          case 'Degrees Fahrenheit':
            toValue = fromValue - 459.67;
            break;
          case 'Degrees Celsius':
            toValue = (fromValue - 491.67) * 5 / 9;
            break;
          case 'Kelvins':
            toValue = fromValue * 5 / 9;
            break;
          case 'Degrees Newton':
            toValue = (fromValue - 491.67) * 11 / 60;
            break;
          case 'Degrees Réaumur':
            toValue = (fromValue - 491.67) * 4 / 9;
            break;
          case 'Degrees Rømer':
            toValue = (fromValue - 491.67) * 7 / 24 + 7.5;
            break;
          case 'Degrees Delisle':
            toValue = (671.67 - fromValue) * 5 / 6;
            break;
          case 'Degrees Rankine': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Degrees Newton':
        switch (toUnit) {
          case 'Degrees Réaumur':
            toValue = fromValue * 80 / 33;
            break;
          case 'Degrees Fahrenheit':
            toValue = fromValue * 60 / 11 + 32;
            break;
          case 'Degrees Rankine':
            toValue = (fromValue * 60 / 11 + 32) + 459.67;
            break;
          case 'Degrees Celsius':
            toValue = fromValue * 100 / 33;
            break;
          case 'Kelvins':
            toValue = fromValue * 100 / 33 + 273.15;
            break;
          case 'Degrees Rømer':
            toValue = (fromValue * 35 / 22 + 7.5);
            break;
          case 'Degrees Delisle':
            toValue = 100 - (fromValue * 22 / 35);
            break;
          case 'Degrees Newton': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Degrees Réaumur':
        switch (toUnit) {
          case 'Degrees Newton':
            toValue = fromValue * 33 / 80;
            break;
          case 'Degrees Fahrenheit':
            toValue = fromValue * 9 / 4 + 32;
            break;
          case 'Degrees Rankine':
            toValue = (fromValue * 9 / 4 + 32) + 459.67;
            break;
          case 'Degrees Celsius':
            toValue = fromValue * 5 / 4;
            break;
          case 'Kelvins':
            toValue = (fromValue * 5 / 4) + 273.15;
            break;
          case 'Degrees Rømer':
            toValue = (fromValue * 21 / 32 + 7.5);
            break;
          case 'Degrees Delisle':
            toValue = 80 - (fromValue * 8 / 15);
            break;
          case 'Degrees Réaumur': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
      case 'Degrees Rømer':
        switch (toUnit) {
          case 'Degrees Delisle':
            toValue = 60 - fromValue * 7 / 20;
            break;
          case 'Degrees Fahrenheit':
            toValue = fromValue * 21 / 40 + 7.5;
            break;
          case 'Degrees Rankine':
            toValue = (fromValue * 21 / 40 + 7.5) + 459.67;
            break;
          case 'Degrees Celsius':
            toValue = fromValue * 7 / 24 + 7.5;
            break;
          case 'Kelvins':
            toValue = (fromValue * 7 / 24 + 7.5) + 273.15;
            break;
          case 'Degrees Newton':
            toValue = fromValue * 22 / 35;
            break;
          case 'Degrees Réaumur':
            toValue = fromValue * 32 / 21;
            break;
          case 'Degrees Rømer': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Degrees Delisle':
        switch (toUnit) {
          case 'Degrees Rømer':
            toValue = (60 - fromValue) * 20 / 7;
            break;
          case 'Degrees Fahrenheit':
            toValue = (60 - fromValue) * 7 / 20 + 7.5;
            break;
          case 'Degrees Rankine':
            toValue = ((60 - fromValue) * 7 / 20 + 7.5) + 459.67;
            break;
          case 'Degrees Celsius':
            toValue = (60 - fromValue) * 24 / 7 + 7.5;
            break;
          case 'Kelvins':
            toValue = ((60 - fromValue) * 24 / 7 + 7.5) + 273.15;
            break;
          case 'Degrees Newton':
            toValue = (60 - fromValue) * 22 / 35;
            break;
          case 'Degrees Réaumur':
            toValue = (60 - fromValue) * 32 / 21;
            break;
          case 'Degrees Delisle': // No conversion needed if from and to units are the same
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
      // DEGREES CELSIUS
      case 'Degrees Celsius':
        switch (toUnit) {
          case 'Kelvins':
            formula = 'Add 273.15 to the temperature value';
            break;
          case 'Degrees Fahrenheit':
            formula = 'Multiply the temperature value by 1.8 and then add 32';
            break;
          case 'Degrees Rankine':
            formula =
                'Multiply the temperature value by 1.8 and then add 491.67';
            break;
          case 'Degrees Newton':
            formula = 'Multiply the temperature value by 0.33';
            break;
          case 'Degrees Réaumur':
            formula = 'Multiply the temperature value by 0.8';
            break;
          case 'Degrees Rømer':
            formula =
                'Multiply the temperature value by 21/40 and then add 7.5';
            break;
          case 'Degrees Delisle':
            formula =
                'Subtract the temperature value from 100 and then multiply by 3/2';
            break;
          case 'Degrees Celsius':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KELVINS
      case 'Kelvins':
        switch (toUnit) {
          case 'Degrees Celsius':
            formula = 'Subtract 273.15 from the temperature value';
            break;
          case 'Degrees Fahrenheit':
            formula =
                'Multiply the temperature value by 1.8 and then subtract 459.67';
            break;
          case 'Degrees Rankine':
            formula = 'Multiply the temperature value by 1.8';
            break;
          case 'Degrees Newton':
            formula =
                'Subtract 273.15 from the temperature value and then multiply by 33/100';
            break;
          case 'Degrees Réaumur':
            formula =
                'Subtract 273.15 from the temperature value and then multiply by 4/5';
            break;
          case 'Degrees Rømer':
            formula =
                'Subtract 273.15 from the temperature value, then multiply by 21/40, and finally add 7.5';
            break;
          case 'Degrees Delisle':
            formula =
                'Subtract 273.15 from the temperature value, then subtract it from 100, and finally multiply by 3/2';
            break;
          case 'Kelvins':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// DEGREES FAHRENHEIT
      case 'Degrees Fahrenheit':
        switch (toUnit) {
          case 'Degrees Celsius':
            formula =
                'Subtract 32 from the temperature value and then divide by 1.8';
            break;
          case 'Kelvins':
            formula =
                'Subtract 32 from the temperature value, then divide by 1.8, and finally add 273.15';
            break;
          case 'Degrees Rankine':
            formula = 'Add 459.67 to the temperature value';
            break;
          case 'Degrees Newton':
            formula =
                'Subtract 32 from the temperature value, then multiply by 11/60';
            break;
          case 'Degrees Réaumur':
            formula =
                'Subtract 32 from the temperature value, then multiply by 4/9';
            break;
          case 'Degrees Rømer':
            formula =
                'Subtract 32 from the temperature value, then multiply by 7/24, and finally add 7.5';
            break;
          case 'Degrees Delisle':
            formula =
                'Subtract 32 from the temperature value, then subtract it from 212, and finally multiply by 5/6';
            break;
          case 'Degrees Fahrenheit':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// DEGREES RANKINE
      case 'Degrees Rankine':
        switch (toUnit) {
          case 'Degrees Celsius':
            formula =
                'Subtract 491.67 from the temperature value, then multiply by 5/9';
            break;
          case 'Kelvins':
            formula = 'Multiply the temperature value by 5/9';
            break;
          case 'Degrees Fahrenheit':
            formula = 'Subtract 459.67 from the temperature value';
            break;
          case 'Degrees Newton':
            formula =
                'Subtract 491.67 from the temperature value, then multiply by 11/60';
            break;
          case 'Degrees Réaumur':
            formula =
                'Subtract 491.67 from the temperature value, then multiply by 4/9';
            break;
          case 'Degrees Rømer':
            formula =
                'Subtract 491.67 from the temperature value, then multiply by 7/24, and finally add 7.5';
            break;
          case 'Degrees Delisle':
            formula =
                'Subtract 491.67 from the temperature value, then subtract it from 671.67, and finally multiply by 5/6';
            break;
          case 'Degrees Rankine':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// DEGREES NEWTON
      case 'Degrees Newton':
        switch (toUnit) {
          case 'Degrees Celsius':
            formula = 'Multiply the temperature value by 100/33';
            break;
          case 'Kelvins':
            formula =
                'Multiply the temperature value by 100/33 and then add 273.15';
            break;
          case 'Degrees Fahrenheit':
            formula = 'Multiply the temperature value by 60/11 and then add 32';
            break;
          case 'Degrees Rankine':
            formula =
                'Multiply the temperature value by 60/11 and then add 491.67';
            break;
          case 'Degrees Réaumur':
            formula = 'Multiply the temperature value by 80/33';
            break;
          case 'Degrees Rømer':
            formula =
                'Multiply the temperature value by 35/22 and then add 7.5';
            break;
          case 'Degrees Delisle':
            formula =
                'Multiply the temperature value by 5/6 and then subtract it from 150';
            break;
          case 'Degrees Newton':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// DEGREES RÉAUMUR
      case 'Degrees Réaumur':
        switch (toUnit) {
          case 'Degrees Celsius':
            formula = 'Multiply the temperature value by 5/4';
            break;
          case 'Kelvins':
            formula =
                'Multiply the temperature value by 5/4 and then add 273.15';
            break;
          case 'Degrees Fahrenheit':
            formula = 'Multiply the temperature value by 9/4 and then add 32';
            break;
          case 'Degrees Rankine':
            formula =
                'Multiply the temperature value by 9/4 and then add 491.67';
            break;
          case 'Degrees Newton':
            formula = 'Multiply the temperature value by 33/80';
            break;
          case 'Degrees Rømer':
            formula =
                'Multiply the temperature value by 21/32 and then add 7.5';
            break;
          case 'Degrees Delisle':
            formula =
                'Multiply the temperature value by -5/4 and then subtract it from 150';
            break;
          case 'Degrees Réaumur':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// DEGREES RØMER
      case 'Degrees Rømer':
        switch (toUnit) {
          case 'Degrees Celsius':
            formula =
                'Subtract 7.5 from the temperature value and then multiply by 40/21';
            break;
          case 'Kelvins':
            formula =
                'Subtract 7.5 from the temperature value, multiply by 40/21, and then add 273.15';
            break;
          case 'Degrees Fahrenheit':
            formula =
                'Subtract 7.5 from the temperature value and then multiply by 24/7, and finally add 32';
            break;
          case 'Degrees Rankine':
            formula =
                'Subtract 7.5 from the temperature value, multiply by 24/7, and then add 491.67';
            break;
          case 'Degrees Newton':
            formula =
                'Subtract 7.5 from the temperature value and then multiply by 22/35';
            break;
          case 'Degrees Réaumur':
            formula =
                'Subtract 7.5 from the temperature value and then multiply by 32/21';
            break;
          case 'Degrees Delisle':
            formula =
                'Subtract 7.5 from the temperature value, multiply by -20/7, and then add 150';
            break;
          case 'Degrees Rømer':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// DEGREES DELISLE
      case 'Degrees Delisle':
        switch (toUnit) {
          case 'Degrees Celsius':
            formula =
                'Subtract the temperature value from 150 and then multiply by 2/3';
            break;
          case 'Kelvins':
            formula =
                'Subtract the temperature value from 150, multiply by 2/3, and then add 273.15';
            break;
          case 'Degrees Fahrenheit':
            formula =
                'Subtract the temperature value from 150, multiply by 8/15, and then add 32';
            break;
          case 'Degrees Rankine':
            formula =
                'Subtract the temperature value from 150, multiply by 8/15, and then add 491.67';
            break;
          case 'Degrees Newton':
            formula =
                'Subtract the temperature value from 150 and then multiply by 33/50';
            break;
          case 'Degrees Réaumur':
            formula =
                'Subtract the temperature value from 150 and then multiply by 21/32';
            break;
          case 'Degrees Rømer':
            formula =
                'Subtract the temperature value from 60, multiply by -7/20, and then add 7.5';
            break;
          case 'Degrees Delisle':
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
    final isSmallScreen = MediaQuery.of(context).size.height < 630;

    return GestureDetector(
      onTap: () {
        // Close the keyboard when tapping outside the input fields
        FocusScope.of(context).unfocus();
      },
      child: Screenshot(
        controller: screenshotController,
        child: Scaffold(
          // Use a Stack to layer the background components
          body: Stack(
            children: [
              // Background Container with Gradient and Image
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.transparent,
                      // Change these colors according to your design
                      isDarkMode
                          ? const Color(0xFF2C3A47)
                          : const Color(0xFFF0F0F0),
                    ],
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      isDarkMode
                          ? 'assets/images/background_angle_opc1.png'
                          : 'assets/images/background_angle_opc2.png',
                    ),
                    // Adjust as needed
                    // Replace with your image asset path
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      // Adjust the opacity as needed
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: const SizedBox.expand(),
              ),

              // Rest of your UI components
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 8.0 : 16.0,
                      horizontal: isSmallScreen ? 8.0 : 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
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
                                semanticLabel:
                                    'Back Button: Navigates to the previous screen',
                                Icons.arrow_back,
                                size: isSmallScreen ? 20 : 30,
                                color: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF2C3A47),
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText('Convert Temperature'.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: chooseFontFamily(
                                        Localizations.localeOf(context)),
                                    fontWeight: FontWeight.w700,
                                    fontSize: isSmallScreen ? 20 : 28,
                                    color: isDarkMode
                                        ? Colors.white
                                        : const Color(0xFF2C3A47),
                                  ),
                                  maxLines: 1,
                                  minFontSize: isSmallScreen ? 12 : 15),
                            ),
                            const IconButton(
                              onPressed: null,
                              icon: Icon(Icons.arrow_back,
                                  size: 40, color: Colors.transparent),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 100),
                        // Adjusted value using MediaQuery
                        ListTile(
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Tooltip(
                                message:
                                    'If the displayed result is 0, change the format'
                                        .tr(),
                                child: IconButton(
                                  icon: Icon(Icons.info_outline,
                                      semanticLabel:
                                          'Tooltip, change the format if the result is 0',
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.grey[800]),
                                  onPressed: () {},
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  'Exponential Format'.tr(),
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xFF2C3A47),
                                      fontSize: isSmallScreen ? 14 : 18),
                                  maxLines: 1,
                                  minFontSize: isSmallScreen ? 8 : 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Switch(
                            value: _isExponentialFormat,
                            onChanged: (bool value) async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final hapticFeedbackEnabled =
                                  prefs.getBool('hapticFeedback') ?? false;
                              if (hapticFeedbackEnabled) {
                                bool canVibrate = await Vibrate.canVibrate;
                                if (canVibrate) {
                                  Vibrate.feedback(FeedbackType.light);
                                }
                              }
                              setState(() {
                                _isExponentialFormat = value;
                                double? lastValue = double.tryParse(
                                    fromController.text.replaceAll(',', ''));
                                if (lastValue != null) {
                                  fromController.text = _formatNumber(lastValue,
                                      forDisplay: true);
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
                          padding:
                              const EdgeInsets.only(left: 0.125, right: 0.125),
                          width: double.infinity,
                          child: _buildUnitColumn('From'.tr(), fromController,
                              fromUnit, fromPrefix, true),
                        ),
                        IconButton(
                          icon: Icon(
                            semanticLabel:
                                'Swap vertically : Switch between conversion units',
                            Icons.swap_vert,
                            color: isDarkMode
                                ? Colors.grey
                                : const Color(0xFF374259),
                            size: 40,
                          ),
                          onPressed: () async {
                            swapUnits();
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
                          padding:
                              const EdgeInsets.only(left: 0.125, right: 0.125),
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
                                  color: isDarkMode
                                      ? Colors.orange
                                      : const Color(0xFF374259),
                                  fontSize: isSmallScreen ? 16 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: _conversionFormula.tr(),
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF2C3A47),
                                  fontSize: isSmallScreen ? 14 : 18,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          minFontSize: isSmallScreen ? 8 : 10,
                          stepGranularity: 1,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final RenderBox? contentBox =
                  _contentKey.currentContext?.findRenderObject() as RenderBox?;
              final contentHeight = contentBox?.size.height ?? 0;
              final availableHeight =
                  MediaQuery.of(context).size.height - contentHeight;
              final bottomPadding =
                  max(MediaQuery.of(context).padding.bottom + 20, 20.0);
              final extraPadding = availableHeight < 600 ? 50.0 : 0.0;

              final buttonHeight = availableHeight * 0.09;

              return SizedBox(
                height: buttonHeight,
                child: Container(
                  margin: EdgeInsets.only(bottom: bottomPadding + extraPadding),
                  child: ActionButtonRow(
                    onResetPressed: () async {
                      await _handleActionButtonPress(
                        hapticFeedback: FeedbackType.medium,
                        actionLogic: _resetToDefault,
                      );
                    },
                    onScreenshotPressed: () async {
                      await _handleActionButtonPress(
                        hapticFeedback: FeedbackType.medium,
                        actionLogic: _takeScreenshotAndShare,
                      );
                    },
                    showButtons: !isTyping,
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  String _getPrefix(String unit) {
    switch (unit) {
      case 'Degrees Celsius':
        return '°C';
      case 'Kelvins':
        return 'K';
      case 'Degrees Fahrenheit':
        return '°F';
      case 'Degrees Rankine':
        return '°R';
      case 'Degrees Newton':
        return '°N';
      case 'Degrees Réaumur':
        return '°Ré';
      case 'Degrees Rømer':
        return '°Rø';
      case 'Degrees Delisle':
        return '°De';
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
              onTap: () {
                _isUserInput =
                    true; // Set this flag to true when the user taps the TextField.
              },
              onChanged: (value) {
                convert(value);
              },
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: inputTextColor,
              ),
              decoration: InputDecoration(
                labelText: label,
                filled: true,
                fillColor: inputFillColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
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
              ),
            )
          else
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              readOnly: true,
              onTap: () {
                _isUserInput =
                    true; // Set this flag to true when the user taps the TextField.
              },
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: inputTextColor,
              ),
              decoration: InputDecoration(
                labelText: label.tr(),
                filled: true,
                fillColor: inputFillColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
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
                  icon: const Icon(Icons.content_copy, size: 23),
                  onPressed: () async {
                    copyToClipboard(controller.text, context);

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
    final isSmallScreen = MediaQuery.of(context).size.width < 630;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.04; // Adjust the factor as needed
    List<DropdownMenuItem<String>> items = <String>[
      'Degrees Celsius',
      'Kelvins',
      'Degrees Fahrenheit',
      'Degrees Rankine',
      'Degrees Newton',
      'Degrees Réaumur',
      'Degrees Rømer',
      'Degrees Delisle',
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
          minFontSize: 10,
          // The minimum text size you want to allow
          stepGranularity: 1,
          // The step size for downscaling the font
          maxLines: 1,
          // The max number of lines for the text to span
          overflow: TextOverflow.ellipsis,
          // How to handle text that doesn't fit
          style: TextStyle(
            fontSize: fontSize, // This is the starting font size
          ),
        ),
      );
    }).toList();

    items.insert(
      0,
      DropdownMenuItem<String>(
        value: '',
        enabled: false,
        child: Semantics(
          label: 'This is a dropdown menu to choose your unit',
          child: AutoSizeText(
            'Choose a conversion unit'.tr(),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black45,
              fontSize: isSmallScreen ? 14 : 18,
            ),
            minFontSize: 12,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );

    return Flexible(
      child: DropdownButtonFormField<String>(
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
          final hapticFeedbackEnabled =
              prefs.getBool('hapticFeedback') ?? false;
          if (hapticFeedbackEnabled &&
              newValue != null &&
              newValue.isNotEmpty) {
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
      ),
    );
  }
}
