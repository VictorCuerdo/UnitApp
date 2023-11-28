// ignore_for_file: library_private_types_in_public_api
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unitapp/controllers/navigation_utils.dart';

class TimeUnitConverter extends StatefulWidget {
  const TimeUnitConverter({super.key});

  @override
  _TimeUnitConverterState createState() => _TimeUnitConverterState();
}

class _TimeUnitConverterState extends State<TimeUnitConverter> {
  static const double mediumFontSize = 17.0;

  double fontSize = mediumFontSize;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Microseconds';
  String toUnit = 'Milliseconds';
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
          text: 'Check out my area result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

    // Conversion constants for different time units
    const double microsecondsToMilliseconds = 0.001;
    const double microsecondsToSeconds = 1e-6;
    const double microsecondsToMinutes = 1.66667e-8;
    const double microsecondsToHours = 2.77778e-10;
    const double microsecondsToDays = 1.15741e-11;
    const double microsecondsToWeeks = 1.65344e-12;
    const double microsecondsToYears = 3.17098e-14;

    const double millisecondsToMicroseconds = 1000;
    const double millisecondsToSeconds = 0.001;
    const double millisecondsToMinutes = 1.66667e-5;
    const double millisecondsToHours = 2.77778e-7;
    const double millisecondsToDays = 1.15741e-8;
    const double millisecondsToWeeks = 1.65344e-9;
    const double millisecondsToYears = 3.17098e-11;

    const double secondsToMicroseconds = 1e6;
    const double secondsToMilliseconds = 1000;
    const double secondsToMinutes = 0.0166667;
    const double secondsToHours = 0.000277778;
    const double secondsToDays = 1.15741e-5;
    const double secondsToWeeks = 1.65344e-6;
    const double secondsToYears = 3.17098e-8;

    const double minutesToMicroseconds = 6e7;
    const double minutesToMilliseconds = 60000;
    const double minutesToSeconds = 60;
    const double minutesToHours = 0.0166667;
    const double minutesToDays = 0.000694444;
    const double minutesToWeeks = 9.92063e-5;
    const double minutesToYears = 1.90259e-6;

    const double hoursToMicroseconds = 3.6e9;
    const double hoursToMilliseconds = 3.6e6;
    const double hoursToSeconds = 3600;
    const double hoursToMinutes = 60;
    const double hoursToDays = 0.0416667;
    const double hoursToWeeks = 0.00595238;
    const double hoursToYears = 0.000114155;

    const double daysToMicroseconds = 8.64e10;
    const double daysToMilliseconds = 8.64e7;
    const double daysToSeconds = 86400;
    const double daysToMinutes = 1440;
    const double daysToHours = 24;
    const double daysToWeeks = 0.142857;
    const double daysToYears = 0.00273973;

    const double weeksToMicroseconds = 6.048e11;
    const double weeksToMilliseconds = 6.048e8;
    const double weeksToSeconds = 604800;
    const double weeksToMinutes = 10080;
    const double weeksToHours = 168;
    const double weeksToDays = 7;
    const double weeksToYears = 0.0191781;

    const double yearsToMicroseconds = 3.1536e13;
    const double yearsToMilliseconds = 3.1536e10;
    const double yearsToSeconds = 3.1536e7;
    const double yearsToMinutes = 525600;
    const double yearsToHours = 8760;
    const double yearsToDays = 365;
    const double yearsToWeeks = 52.1429;

    switch (fromUnit) {
      case 'Microseconds':
        switch (toUnit) {
          case 'Milliseconds':
            toValue = fromValue * microsecondsToMilliseconds;
            break;
          case 'Seconds':
            toValue = fromValue * microsecondsToSeconds;
            break;
          case 'Minutes':
            toValue = fromValue * microsecondsToMinutes;
            break;
          case 'Hours':
            toValue = fromValue * microsecondsToHours;
            break;
          case 'Days':
            toValue = fromValue * microsecondsToDays;
            break;
          case 'Weeks':
            toValue = fromValue * microsecondsToWeeks;
            break;
          case 'Years':
            toValue = fromValue * microsecondsToYears;
            break;
          case 'Microseconds': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
    }

// MILLISECONDS UNIT CONVERSION
    switch (fromUnit) {
      case 'Milliseconds':
        switch (toUnit) {
          case 'Microseconds':
            toValue = fromValue * millisecondsToMicroseconds;
            break;
          case 'Seconds':
            toValue = fromValue * millisecondsToSeconds;
            break;
          case 'Minutes':
            toValue = fromValue * millisecondsToMinutes;
            break;
          case 'Hours':
            toValue = fromValue * millisecondsToHours;
            break;
          case 'Days':
            toValue = fromValue * millisecondsToDays;
            break;
          case 'Weeks':
            toValue = fromValue * millisecondsToWeeks;
            break;
          case 'Years':
            toValue = fromValue * millisecondsToYears;
            break;
          case 'Milliseconds': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// SECONDS UNIT CONVERSION
      case 'Seconds':
        switch (toUnit) {
          case 'Microseconds':
            toValue = fromValue * secondsToMicroseconds;
            break;
          case 'Milliseconds':
            toValue = fromValue * secondsToMilliseconds;
            break;
          case 'Minutes':
            toValue = fromValue * secondsToMinutes;
            break;
          case 'Hours':
            toValue = fromValue * secondsToHours;
            break;
          case 'Days':
            toValue = fromValue * secondsToDays;
            break;
          case 'Weeks':
            toValue = fromValue * secondsToWeeks;
            break;
          case 'Years':
            toValue = fromValue * secondsToYears;
            break;
          case 'Seconds': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Minutes':
        switch (toUnit) {
          case 'Microseconds':
            toValue = fromValue * minutesToMicroseconds;
            break;
          case 'Milliseconds':
            toValue = fromValue * minutesToMilliseconds;
            break;
          case 'Seconds':
            toValue = fromValue * minutesToSeconds;
            break;
          case 'Hours':
            toValue = fromValue * minutesToHours;
            break;
          case 'Days':
            toValue = fromValue * minutesToDays;
            break;
          case 'Weeks':
            toValue = fromValue * minutesToWeeks;
            break;
          case 'Years':
            toValue = fromValue * minutesToYears;
            break;
          case 'Minutes': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      // HOURS UNIT CONVERSION

      case 'Hours':
        switch (toUnit) {
          case 'Microseconds':
            toValue = fromValue * hoursToMicroseconds;
            break;
          case 'Milliseconds':
            toValue = fromValue * hoursToMilliseconds;
            break;
          case 'Seconds':
            toValue = fromValue * hoursToSeconds;
            break;
          case 'Minutes':
            toValue = fromValue * hoursToMinutes;
            break;
          case 'Days':
            toValue = fromValue * hoursToDays;
            break;
          case 'Weeks':
            toValue = fromValue * hoursToWeeks;
            break;
          case 'Years':
            toValue = fromValue * hoursToYears;
            break;
          case 'Hours': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// DAYS UNIT CONVERSION

      case 'Days':
        switch (toUnit) {
          case 'Microseconds':
            toValue = fromValue * daysToMicroseconds;
            break;
          case 'Milliseconds':
            toValue = fromValue * daysToMilliseconds;
            break;
          case 'Seconds':
            toValue = fromValue * daysToSeconds;
            break;
          case 'Minutes':
            toValue = fromValue * daysToMinutes;
            break;
          case 'Hours':
            toValue = fromValue * daysToHours;
            break;
          case 'Weeks':
            toValue = fromValue * daysToWeeks;
            break;
          case 'Years':
            toValue = fromValue * daysToYears;
            break;
          case 'Days': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
      // ... additional cases for other 'from' units ...

// WEEKS UNIT CONVERSION
      case 'Weeks':
        switch (toUnit) {
          case 'Microseconds':
            toValue = fromValue * weeksToMicroseconds;
            break;
          case 'Milliseconds':
            toValue = fromValue * weeksToMilliseconds;
            break;
          case 'Seconds':
            toValue = fromValue * weeksToSeconds;
            break;
          case 'Minutes':
            toValue = fromValue * weeksToMinutes;
            break;
          case 'Hours':
            toValue = fromValue * weeksToHours;
            break;
          case 'Days':
            toValue = fromValue * weeksToDays;
            break;
          case 'Years':
            toValue = fromValue * weeksToYears;
            break;
          case 'Weeks': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
      // ... additional cases for other 'from' units ...

// YEARS UNIT CONVERSION
      case 'Years':
        switch (toUnit) {
          case 'Microseconds':
            toValue = fromValue * yearsToMicroseconds;
            break;
          case 'Milliseconds':
            toValue = fromValue * yearsToMilliseconds;
            break;
          case 'Seconds':
            toValue = fromValue * yearsToSeconds;
            break;
          case 'Minutes':
            toValue = fromValue * yearsToMinutes;
            break;
          case 'Hours':
            toValue = fromValue * yearsToHours;
            break;
          case 'Days':
            toValue = fromValue * yearsToDays;
            break;
          case 'Weeks':
            toValue = fromValue * yearsToWeeks;
            break;
          case 'Years': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
      // ... additional cases for other 'from' units ...
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
      case 'Microseconds':
        switch (toUnit) {
          case 'Milliseconds':
            formula = 'Divide the time value by 1,000';
            break;
          case 'Seconds':
            formula = 'Divide the time value by 1,000,000';
            break;
          case 'Minutes':
            formula = 'Divide the time value by 60,000,000';
            break;
          case 'Hours':
            formula = 'Divide the time value by 3,600,000,000';
            break;
          case 'Days':
            formula = 'Divide the time value by 86,400,000,000';
            break;
          case 'Weeks':
            formula = 'Divide the time value by 604,800,000,000';
            break;
          case 'Years':
            formula = 'Divide the time value by 31,536,000,000,000';
            break;
          case 'Microseconds': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Milliseconds':
        switch (toUnit) {
          case 'Microseconds':
            formula = 'Multiply the time value by 1,000';
            break;
          case 'Seconds':
            formula = 'Divide the time value by 1,000';
            break;
          case 'Minutes':
            formula = 'Divide the time value by 60,000';
            break;
          case 'Hours':
            formula = 'Divide the time value by 3,600,000';
            break;
          case 'Days':
            formula = 'Divide the time value by 86,400,000';
            break;
          case 'Weeks':
            formula = 'Divide the time value by 604,800,000';
            break;
          case 'Years':
            formula = 'Divide the time value by 31,536,000,000';
            break;
          case 'Milliseconds': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Seconds':
        switch (toUnit) {
          case 'Microseconds':
            formula = 'Multiply the time value by 1,000,000';
            break;
          case 'Milliseconds':
            formula = 'Multiply the time value by 1,000';
            break;
          case 'Minutes':
            formula = 'Divide the time value by 60';
            break;
          case 'Hours':
            formula = 'Divide the time value by 3,600';
            break;
          case 'Days':
            formula = 'Divide the time value by 86,400';
            break;
          case 'Weeks':
            formula = 'Divide the time value by 604,800';
            break;
          case 'Years':
            formula = 'Divide the time value by 31,536,000';
            break;
          case 'Seconds': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Minutes':
        switch (toUnit) {
          case 'Microseconds':
            formula = 'Multiply the time value by 60,000,000';
            break;
          case 'Milliseconds':
            formula = 'Multiply the time value by 60,000';
            break;
          case 'Seconds':
            formula = 'Multiply the time value by 60';
            break;
          case 'Hours':
            formula = 'Divide the time value by 60';
            break;
          case 'Days':
            formula = 'Divide the time value by 1,440';
            break;
          case 'Weeks':
            formula = 'Divide the time value by 10,080';
            break;
          case 'Years':
            formula = 'Divide the time value by 525,600';
            break;
          case 'Minutes': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Hours':
        switch (toUnit) {
          case 'Microseconds':
            formula = 'Multiply the time value by 3,600,000,000';
            break;
          case 'Milliseconds':
            formula = 'Multiply the time value by 3,600,000';
            break;
          case 'Seconds':
            formula = 'Multiply the time value by 3,600';
            break;
          case 'Minutes':
            formula = 'Multiply the time value by 60';
            break;
          case 'Days':
            formula = 'Divide the time value by 24';
            break;
          case 'Weeks':
            formula = 'Divide the time value by 168';
            break;
          case 'Years':
            formula = 'Divide the time value by 8,760';
            break;
          case 'Hours': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Days':
        switch (toUnit) {
          case 'Microseconds':
            formula = 'Multiply the time value by 86,400,000,000';
            break;
          case 'Milliseconds':
            formula = 'Multiply the time value by 86,400,000';
            break;
          case 'Seconds':
            formula = 'Multiply the time value by 86,400';
            break;
          case 'Minutes':
            formula = 'Multiply the time value by 1,440';
            break;
          case 'Hours':
            formula = 'Multiply the time value by 24';
            break;
          case 'Weeks':
            formula = 'Divide the time value by 7';
            break;
          case 'Years':
            formula = 'Divide the time value by 365';
            break;
          case 'Days': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Weeks':
        switch (toUnit) {
          case 'Microseconds':
            formula = 'Multiply the time value by 604,800,000,000';
            break;
          case 'Milliseconds':
            formula = 'Multiply the time value by 604,800,000';
            break;
          case 'Seconds':
            formula = 'Multiply the time value by 604,800';
            break;
          case 'Minutes':
            formula = 'Multiply the time value by 10,080';
            break;
          case 'Hours':
            formula = 'Multiply the time value by 168';
            break;
          case 'Days':
            formula = 'Multiply the time value by 7';
            break;
          case 'Years':
            formula =
                'Divide the time value by 52.1775'; // Average weeks in a year
            break;
          case 'Weeks': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Years':
        switch (toUnit) {
          case 'Microseconds':
            formula = 'Multiply the time value by 31,536,000,000,000';
            break;
          case 'Milliseconds':
            formula = 'Multiply the time value by 31,536,000,000';
            break;
          case 'Seconds':
            formula = 'Multiply the time value by 31,536,000';
            break;
          case 'Minutes':
            formula = 'Multiply the time value by 525,600';
            break;
          case 'Hours':
            formula = 'Multiply the time value by 8,760';
            break;
          case 'Days':
            formula = 'Multiply the time value by 365'; // or 366 for leap years
            break;
          case 'Weeks':
            formula =
                'Multiply the time value by 52.1775'; // Average weeks in a year
            break;
          case 'Years': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      // ... additional cases for other 'from' units ...
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
                          onPressed: () {
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
                          child: AutoSizeText('Convert Time'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Lato',
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
                    SwitchListTile(
                      title: AutoSizeText(
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
                      onPressed: swapUnits,
                    ),
                    Container(
                      key: _contentKey,
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
                      onPressed: _resetToDefault,
                      backgroundColor:
                          isDarkMode ? Colors.white : const Color(0xFF2C3A47),
                      child: Icon(Icons.restart_alt,
                          size: 36,
                          color: isDarkMode ? Colors.black : Colors.white),
                    ),
                    FloatingActionButton(
                      tooltip: 'Share a screenshot of your results!'.tr(),
                      heroTag: 'shareButton',
                      onPressed: _takeScreenshotAndShare,
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
      case 'Microseconds':
        return 'µs'; // Time equivalent to 1e-6 seconds
      case 'Milliseconds':
        return 'ms'; // Time equivalent to 1e-3 seconds
      case 'Seconds':
        return 's'; // Base unit of time in the International System of Units
      case 'Minutes':
        return 'min'; // Time equivalent to 60 seconds
      case 'Hours':
        return 'h'; // Time equivalent to 60 minutes
      case 'Days':
        return 'd'; // Time equivalent to 24 hours
      case 'Weeks':
        return 'wk'; // Time equivalent to 7 days
      case 'Years':
        return 'yr'; // Time equivalent to 365 or 366 days
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

  // Correct the method signature by adding the isFrom parameter
  Widget _buildDropdownButton(String type, String currentValue, bool isFrom) {
    List<DropdownMenuItem<String>> items = <String>[
      'Microseconds',
      'Milliseconds',
      'Seconds',
      'Minutes',
      'Hours',
      'Days',
      'Weeks',
      'Years',
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
