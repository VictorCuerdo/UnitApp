// ignore_for_file: library_private_types_in_public_api
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unitapp/controllers/navigation_utils.dart';

class TemperatureUnitConverter extends StatefulWidget {
  const TemperatureUnitConverter({super.key});

  @override
  _TemperatureUnitConverterState createState() =>
      _TemperatureUnitConverterState();
}

class _TemperatureUnitConverterState extends State<TemperatureUnitConverter> {
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 17.0;
  static const double largeFontSize = 20.0;
  Locale _selectedLocale = const Locale('en', 'US');
  double fontSize = mediumFontSize;

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
  String fromPrefix = '°C';
  String toPrefix = 'K';
  final ScreenshotController screenshotController = ScreenshotController();
  String _conversionFormula = '';

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
          text: 'Check out my temperature result!'.tr());
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

  String _formatWithCommas(String integerPart) {
    // Use a buffer to build the formatted string for the integer part with commas.
    StringBuffer formattedInt = StringBuffer();
    int commaPosition = 3;

    for (int i = 0; i < integerPart.length; i++) {
      if (i % commaPosition == 0 && i > 0) {
        formattedInt.write(',');
      }
      formattedInt.write(integerPart[i]);
    }
    return formattedInt.toString();
  }

  void _handleInputFormatting(TextEditingController controller,
      {bool forDisplay = false}) {
    String text = controller.text;
    if (text.isNotEmpty) {
      // Allow for a single decimal point or comma in the input
      if ((text.contains('.') && text.indexOf('.') != text.length - 1) ||
          (text.contains(',') && text.indexOf(',') != text.length - 1)) {
        try {
          String normalizedText = text.replaceAll(',', '.');
          double value = double.parse(normalizedText);
          _isUserInput = false;
          String formattedText = _formatNumber(value, forDisplay: forDisplay);
          controller.value = TextEditingValue(
            text: formattedText,
            selection: TextSelection.collapsed(offset: formattedText.length),
          );
        } catch (e) {
          // Handle parsing error, if any.
        } finally {
          _isUserInput = true;
        }
      }
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
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor:
            // isDarkMode ? const Color(0xFF2C3A47) : const Color(0xFF9A3B3B),
            isDarkMode ? const Color(0xFF2C3A47) : const Color(0xFFF0F0F0),
        resizeToAvoidBottomInset:
            true, // Adjust the body size when the keyboard is visible
        body: SingleChildScrollView(
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
                      onPressed: () {
                        context.navigateTo('/unit');
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 40,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF2C3A47),
                      ),
                    ),
                    Expanded(
                      // This will take all available space, pushing the IconButton to the left and centering the text
                      child: Text(
                        'Convert Temperature',
                        textAlign: TextAlign
                            .center, // This centers the text within the available space
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700, // Medium weight
                          fontSize: 28,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF2C3A47),
                        ),
                      ).tr(),
                    ),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.arrow_back,
                          size: 40, color: Colors.transparent),
                    ), // You can place an invisible IconButton here to balance the row if necessary
                  ],
                ),

                const SizedBox(height: 150),
                SwitchListTile(
                  title: Text(
                    'Exponential Format',
                    style: TextStyle(
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF2C3A47),
                        fontSize: 18),
                  ).tr(),
                  value: _isExponentialFormat,
                  onChanged: (bool value) {
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
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 0.125, right: 0.125),
                  width: double.infinity,
                  child: _buildUnitColumn(
                      'From'.tr(), fromController, fromUnit, fromPrefix, true),
                ),
                IconButton(
                  icon: Icon(
                    Icons.swap_vert,
                    color: isDarkMode ? Colors.grey : const Color(0xFF374259),
                    size: 40,
                  ),
                  onPressed: swapUnits,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 0.125, right: 0.125),
                  width: double.infinity,
                  child: _buildUnitColumn(
                      'To'.tr(), toController, toUnit, toPrefix, false),
                ),
                const SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
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
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                highlightElevation:
                    BouncingScrollSimulation.maxSpringTransferVelocity,
                enableFeedback: true,
                splashColor: Colors.lightGreen,
                tooltip: 'Reset default settings'.tr(),
                heroTag: 'resetButton'.tr(),
                onPressed: _resetToDefault,
                backgroundColor:
                    isDarkMode ? Colors.white : const Color(0xFF2C3A47),
                child: Icon(Icons.restart_alt,
                    size: 36, color: isDarkMode ? Colors.black : Colors.white),
              ),
              FloatingActionButton(
                tooltip: 'Share a screenshot of your results!'.tr(),
                heroTag: 'shareButton'.tr(),
                onPressed: _takeScreenshotAndShare,
                backgroundColor:
                    isDarkMode ? Colors.white : const Color(0xFF2C3A47),
                child: Icon(Icons.share,
                    size: 36, color: isDarkMode ? Colors.black : Colors.white),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                      color: Colors.grey, size: 23),
                  onPressed: () => copyToClipboard(controller.text, context),
                ),
              ),
            )
          else
            TextFormField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              enabled: false, // This disables the field
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
                disabledBorder: const OutlineInputBorder(
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
                      color: Colors.grey, size: 23),
                  onPressed: () => copyToClipboard(controller.text, context),
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

  Widget _buildDropdownButton(String type, String currentValue, bool isFrom) {
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
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _getPrefix(value), // Prefix part
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Make prefix bold
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 23,
                  ),
                ),
                TextSpan(
                  text: ' - $translatedValue', // The rest of the text
                  style: TextStyle(
                    fontWeight: FontWeight.normal, // Normal weight for the rest
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
            overflow: TextOverflow.visible,
          ));
    }).toList();

    items.insert(
      0,
      DropdownMenuItem<String>(
        value: '',
        enabled: false,
        child: Text(
          'Choose a conversion unit'.tr(),
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black, fontSize: 20),
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
      hint: Text(
        'Choose a conversion unit'.tr(),
        style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF374259),
            fontSize: 20),
        textAlign: TextAlign.center,
      ),
      onChanged: (String? newValue) {
        if (newValue != null && newValue.isNotEmpty) {
          setState(() {
            if (isFrom) {
              fromUnit = newValue;
              fromPrefix = _getPrefix(newValue);
            } else {
              toUnit = newValue;
              toPrefix = _getPrefix(newValue);
            }
            // Do not clear the text fields here to retain the input value
            // Trigger the conversion logic if needed with the new unit but same value
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
            child: Text(
              item.value == '' ? 'Choose a conversion unit' : item.value!,
              style: TextStyle(
                color: isDarkMode ? const Color(0xFF9CC0C5) : Colors.black,
                fontSize: 20,
              ),
            ).tr(),
          );
        }).toList();
      },
    );
  }
}
