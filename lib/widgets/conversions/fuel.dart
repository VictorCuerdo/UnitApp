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

class FuelUnitConverter extends StatefulWidget {
  const FuelUnitConverter({super.key});

  @override
  _FuelUnitConverterState createState() => _FuelUnitConverterState();
}

class _FuelUnitConverterState extends State<FuelUnitConverter> {
  static const double mediumFontSize = 17.0;
  GlobalKey tooltipKey = GlobalKey();
  double fontSize = mediumFontSize;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Litres per 100 km';
  String toUnit = 'Litres per 100 miles';
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
          text: 'Check out my fuel consumption result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

    switch (fromUnit) {
      case 'Litres per 100 km':
        switch (toUnit) {
          case 'Litres per 100 miles':
            toValue = fromValue / 1.609344;
            break;
          case 'Kilometres per Litre':
            toValue = 100.0 / fromValue;
            break;
          case 'Kilometres per Gallon (US)':
            toValue = 235.214583 / fromValue;
            break;
          case 'Miles per Litre':
            toValue = 62.1371192 / fromValue;
            break;
          case 'Miles per Gallon (Imp)':
            toValue = 282.480936 / fromValue;
            break;
          case 'Miles per Gallon (US)':
            toValue = 235.214583 / fromValue;
            break;
          case 'Nautical Miles per Litre':
            toValue = 86.8988259 / fromValue;
            break;
          case 'Litres per 100 km': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Litres per 100 miles':
        switch (toUnit) {
          case 'Litres per 100 km':
            toValue = fromValue * 1.609344;
            break;
          case 'Kilometres per Litre':
            toValue = 62.1371192 / fromValue;
            break;
          case 'Kilometres per Gallon (US)':
            toValue = 378.541178 / fromValue;
            break;
          case 'Miles per Litre':
            toValue = 100.0 / fromValue;
            break;
          case 'Miles per Gallon (Imp)':
            toValue = 453.59237 / fromValue;
            break;
          case 'Miles per Gallon (US)':
            toValue = 378.541178 / fromValue;
            break;
          case 'Nautical Miles per Litre':
            toValue = 139.273462 / fromValue;
            break;
          case 'Litres per 100 miles': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilometres per Litre':
        switch (toUnit) {
          case 'Kilometres per Gallon (US)':
            toValue = fromValue / 0.2641720524;
            break;
          case 'Litres per 100 km':
            toValue = 100.0 / fromValue;
            break;
          case 'Litres per 100 miles':
            toValue = 62.1371192 / fromValue;
            break;
          case 'Miles per Litre':
            toValue = 0.621371192 / fromValue;
            break;
          case 'Miles per Gallon (Imp)':
            toValue = 2.824809364 / fromValue;
            break;
          case 'Miles per Gallon (US)':
            toValue = 3.785411784 / fromValue;
            break;
          case 'Nautical Miles per Litre':
            toValue = 0.539956803 / fromValue;
            break;
          case 'Kilometres per Litre': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilometres per Gallon (US)':
        switch (toUnit) {
          case 'Kilometres per Litre':
            toValue = fromValue * 0.2641720524;
            break;
          case 'Litres per 100 km':
            toValue = 235.214583 / fromValue;
            break;
          case 'Litres per 100 miles':
            toValue = 147.0068379 / fromValue;
            break;
          case 'Miles per Litre':
            toValue = 100.0 / fromValue;
            break;
          case 'Miles per Gallon (Imp)':
            toValue = 453.59237 / fromValue;
            break;
          case 'Miles per Gallon (US)':
            toValue = 378.541178 / fromValue;
            break;
          case 'Nautical Miles per Litre':
            toValue = 173.5297946 / fromValue;
            break;
          case 'Kilometres per Gallon (US)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Miles per Litre':
        switch (toUnit) {
          case 'Miles per Gallon (Imp)':
            toValue = fromValue * 2.824809364;
            break;
          case 'Kilometres per Litre':
            toValue = fromValue / 0.621371192;
            break;
          case 'Kilometres per Gallon (US)':
            toValue = fromValue / 0.621371192 * 3.785411784;
            break;
          case 'Litres per 100 km':
            toValue = 100.0 / (fromValue * 0.621371192);
            break;
          case 'Litres per 100 miles':
            toValue = 62.1371192 / fromValue;
            break;
          case 'Miles per Gallon (US)':
            toValue = 3.785411784 / (fromValue * 0.621371192);
            break;
          case 'Nautical Miles per Litre':
            toValue = 0.539956803 / (fromValue * 0.621371192);
            break;
          case 'Miles per Litre': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Miles per Gallon (Imp)':
        switch (toUnit) {
          case 'Miles per Litre':
            toValue = fromValue / 2.824809364;
            break;
          case 'Kilometres per Litre':
            toValue = fromValue / 0.2199692483;
            break;
          case 'Kilometres per Gallon (US)':
            toValue = fromValue / 0.2199692483 * 3.785411784;
            break;
          case 'Litres per 100 km':
            toValue = 100.0 / (fromValue * 0.2199692483);
            break;
          case 'Litres per 100 miles':
            toValue = 62.1371192 / (fromValue * 2.824809364);
            break;
          case 'Miles per Gallon (US)':
            toValue = 3.785411784 / (fromValue * 0.2199692483);
            break;
          case 'Nautical Miles per Litre':
            toValue = 0.539956803 / (fromValue * 0.2199692483);
            break;
          case 'Miles per Gallon (Imp)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Miles per Gallon (US)':
        switch (toUnit) {
          case 'Nautical Miles per Litre':
            toValue = fromValue * 0.00153816462;
            break;
          case 'Miles per Litre':
            toValue = fromValue / 0.425143707;
            break;
          case 'Miles per Gallon (Imp)':
            toValue = fromValue * 0.832674185;
            break;
          case 'Kilometres per Litre':
            toValue = fromValue / 0.621371192;
            break;
          case 'Kilometres per Gallon (US)':
            toValue = fromValue / 0.621371192 * 3.785411784;
            break;
          case 'Litres per 100 km':
            toValue = 100.0 / (fromValue * 0.621371192);
            break;
          case 'Litres per 100 miles':
            toValue = 62.1371192 / fromValue;
            break;
          case 'Miles per Gallon (US)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Nautical Miles per Litre':
        switch (toUnit) {
          case 'Miles per Gallon (US)':
            toValue = fromValue / 0.00153816462;
            break;
          case 'Miles per Litre':
            toValue = fromValue / 0.269978947;
            break;
          case 'Miles per Gallon (Imp)':
            toValue = fromValue * 0.556798828;
            break;
          case 'Kilometres per Litre':
            toValue = fromValue / 0.539956803;
            break;
          case 'Kilometres per Gallon (US)':
            toValue = fromValue / 0.539956803 * 3.785411784;
            break;
          case 'Litres per 100 km':
            toValue = 100.0 / (fromValue * 0.539956803);
            break;
          case 'Litres per 100 miles':
            toValue = 62.1371192 / (fromValue * 0.00153816462);
            break;
          case 'Nautical Miles per Litre': // No conversion needed if from and to units are the same
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
      // Litres per 100 km
      case 'Litres per 100 km':
        switch (toUnit) {
          case 'Litres per 100 miles':
            formula = 'Multiply the value by 2.35215';
            break;
          case 'Kilometres per Litre':
            formula = 'Divide 100 by the value';
            break;
          case 'Kilometres per Gallon (US)':
            formula = 'Divide 235.215 by the value';
            break;
          case 'Miles per Litre':
            formula = 'Divide 62.1371 by the value';
            break;
          case 'Miles per Gallon (Imp)':
            formula = 'Divide 282.481 by the value';
            break;
          case 'Miles per Gallon (US)':
            formula = 'Divide 235.215 by the value';
            break;
          case 'Nautical Miles per Litre':
            formula = 'Divide 54.0551 by the value';
            break;
          case 'Litres per 100 km':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Litres per 100 miles
      case 'Litres per 100 miles':
        switch (toUnit) {
          case 'Litres per 100 km':
            formula = 'Multiply the value by 0.425144';
            break;
          case 'Kilometres per Litre':
            formula = 'Multiply the value by 2.35215';
            break;
          case 'Kilometres per Gallon (US)':
            formula = 'Multiply the value by 59.7052';
            break;
          case 'Miles per Litre':
            formula = 'Multiply the value by 15.68';
            break;
          case 'Miles per Gallon (Imp)':
            formula = 'Multiply the value by 3.78541';
            break;
          case 'Miles per Gallon (US)':
            formula = 'Multiply the value by 2.35215';
            break;
          case 'Nautical Miles per Litre':
            formula = 'Multiply the value by 4.80266';
            break;
          case 'Litres per 100 miles':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Kilometres per Litre
      case 'Kilometres per Litre':
        switch (toUnit) {
          case 'Litres per 100 km':
            formula = 'Divide 100 by the value';
            break;
          case 'Litres per 100 miles':
            formula = 'Multiply the value by 0.425144';
            break;
          case 'Kilometres per Gallon (US)':
            formula = 'Multiply the value by 3.78541';
            break;
          case 'Miles per Litre':
            formula = 'Divide 1.60934 by the value';
            break;
          case 'Miles per Gallon (Imp)':
            formula = 'Divide 4.54609 by the value';
            break;
          case 'Miles per Gallon (US)':
            formula = 'Divide 3.78541 by the value';
            break;
          case 'Nautical Miles per Litre':
            formula = 'Divide 1.852 by the value';
            break;
          case 'Kilometres per Litre':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Kilometres per Gallon (US)
      case 'Kilometres per Gallon (US)':
        switch (toUnit) {
          case 'Litres per 100 km':
            formula = 'Divide 235.215 by the value';
            break;
          case 'Litres per 100 miles':
            formula = 'Divide 59.7052 by the value';
            break;
          case 'Kilometres per Litre':
            formula = 'Divide 3.78541 by the value';
            break;
          case 'Miles per Litre':
            formula = 'Multiply the value by 0.621371';
            break;
          case 'Miles per Gallon (Imp)':
            formula = 'Multiply the value by 1.20095';
            break;
          case 'Miles per Gallon (US)':
            formula = 'The value remains unchanged';
            break;
          case 'Nautical Miles per Litre':
            formula = 'Divide 1.15078 by the value';
            break;
          case 'Kilometres per Gallon (US)':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Miles per Litre
      case 'Miles per Litre':
        switch (toUnit) {
          case 'Litres per 100 km':
            formula = 'Divide 62.1371 by the value';
            break;
          case 'Litres per 100 miles':
            formula = 'Multiply the value by 100';
            break;
          case 'Kilometres per Litre':
            formula = 'Multiply the value by 1.60934';
            break;
          case 'Kilometres per Gallon (US)':
            formula = 'Divide 2.35215 by the value';
            break;
          case 'Miles per Gallon (Imp)':
            formula = 'Multiply the value by 1.20095';
            break;
          case 'Miles per Gallon (US)':
            formula = 'Multiply the value by 0.832674';
            break;
          case 'Nautical Miles per Litre':
            formula = 'Divide 54.6881 by the value';
            break;
          case 'Miles per Litre':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Miles per Gallon (Imp)
      case 'Miles per Gallon (Imp)':
        switch (toUnit) {
          case 'Litres per 100 km':
            formula = 'Divide 41.4022 by the value';
            break;
          case 'Litres per 100 miles':
            formula = 'Multiply the value by 62.1371';
            break;
          case 'Kilometres per Litre':
            formula = 'Divide 1.20095 by the value';
            break;
          case 'Kilometres per Gallon (US)':
            formula = 'Divide 0.832674 by the value';
            break;
          case 'Miles per Litre':
            formula = 'Divide 1.20095 by the value';
            break;
          case 'Miles per Gallon (US)':
            formula = 'Multiply the value by 1.20095';
            break;
          case 'Nautical Miles per Litre':
            formula = 'Divide 0.998214 by the value';
            break;
          case 'Miles per Gallon (Imp)':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Miles per Gallon (US)
      case 'Miles per Gallon (US)':
        switch (toUnit) {
          case 'Litres per 100 km':
            formula = 'Divide 235.215 by the value';
            break;
          case 'Litres per 100 miles':
            formula = 'Divide 100 by the value';
            break;
          case 'Kilometres per Litre':
            formula = 'Divide 0.621371 by the value';
            break;
          case 'Kilometres per Gallon (US)':
            formula = 'Divide 0.832674 by the value';
            break;
          case 'Miles per Litre':
            formula = 'Divide 1.20095 by the value';
            break;
          case 'Miles per Gallon (Imp)':
            formula = 'Divide 1.20095 by the value';
            break;
          case 'Nautical Miles per Litre':
            formula = 'Divide 1.15078 by the value';
            break;
          case 'Miles per Gallon (US)':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Nautical Miles per Litre
      case 'Nautical Miles per Litre':
        switch (toUnit) {
          case 'Litres per 100 km':
            formula = 'Divide 206.185 by the value';
            break;
          case 'Litres per 100 miles':
            formula = 'Multiply the value by 100';
            break;
          case 'Kilometres per Litre':
            formula = 'Divide 0.539956 by the value';
            break;
          case 'Kilometres per Gallon (US)':
            formula = 'Multiply the value by 0.868976';
            break;
          case 'Miles per Litre':
            formula = 'Multiply the value by 1.15078';
            break;
          case 'Miles per Gallon (Imp)':
            formula = 'Multiply the value by 0.998214';
            break;
          case 'Nautical Miles per Litre':
            formula = 'The value remains unchanged';
            break;
          case 'Miles per Gallon (US)':
            formula = 'Multiply the value by 0.868976';
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
                          child: AutoSizeText('Convert Fuel Consumption'.tr(),
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
      case 'Litres per 100 km':
        return 'L/100 km';
      case 'Litres per 100 miles':
        return 'L/100 mi';
      case 'Kilometres per Litre':
        return 'km/L';
      case 'Kilometres per Gallon (US)':
        return 'km/gal (US)';
      case 'Miles per Litre':
        return 'mi/L';
      case 'Miles per Gallon (Imp)':
        return 'mpg (Imp)';
      case 'Miles per Gallon (US)':
        return 'mpg (US)';
      case 'Nautical Miles per Litre':
        return 'nmi/L';
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
      'Litres per 100 km',
      'Litres per 100 miles',
      'Kilometres per Litre',
      'Kilometres per Gallon (US)',
      'Miles per Litre',
      'Miles per Gallon (Imp)',
      'Miles per Gallon (US)',
      'Nautical Miles per Litre',
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
