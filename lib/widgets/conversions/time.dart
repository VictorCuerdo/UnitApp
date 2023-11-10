// ignore_for_file: library_private_types_in_public_api
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  String fromUnit = 'Microseconds';
  String toUnit = 'Milliseconds';
  // Removed duplicate declarations of TextEditingController
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  bool _isExponentialFormat = false;
  // Flag to indicate if the change is due to user input
  bool _isUserInput = true;
  // Using string variables for prefixes
  String fromPrefix = 'µs';
  String toPrefix = 'ms';
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
          text: 'Check out my area result!');
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
        formula = 'Unknown unit';
    }
    return formula;
  }

  void copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Conversion result copied to clipboard!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: const Color(0xFF464648),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20), // Adjust space as needed
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      context.navigateTo(
                          'unitapp'); // Assuming you have this route defined somewhere
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                      width: 50), // Space between the icon and the text
                  const Text(
                    'Convert Time',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 150),
              // Inserted just before the 'From' input field
              SwitchListTile(
                title: const Text(
                  'See result in exponential format',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                value: _isExponentialFormat,
                onChanged: (bool value) {
                  setState(() {
                    _isExponentialFormat = value;
                    // Force the text to update with the new formatting.
                    double? lastValue = double.tryParse(
                        fromController.text.replaceAll(',', ''));
                    if (lastValue != null) {
                      fromController.text =
                          _formatNumber(lastValue, forDisplay: true);
                    }
                    // Re-trigger conversion to update the toController with formatted text.
                    convert(fromController.text);
                  });
                },
                activeColor: Colors.lightBlue,
                activeTrackColor: Colors.lightBlue.shade200,
              ),

              const SizedBox(height: 10),
              // Adjusted layout for 'From' input and dropdown
              Container(
                padding: const EdgeInsets.only(left: 0.125, right: 0.125),
                width: double.infinity,
                child: _buildUnitColumn(
                    'From', fromController, fromUnit, fromPrefix, true),
              ),
              // Switch icon in vertical orientation
              IconButton(
                icon: const Icon(
                  Icons.swap_vert,
                  color: Color.fromARGB(255, 183, 218, 234),
                  size: 40,
                ),
                onPressed: swapUnits,
              ),
              // Adjusted layout for 'To' input and dropdown
              Container(
                padding: const EdgeInsets.only(left: 0.125, right: 0.125),
                width: double.infinity,
                child: _buildUnitColumn(
                    'To', toController, toUnit, toPrefix, false),
              ),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Formula:  ',
                      style: TextStyle(
                        color:
                            Colors.orange, // Set the color for 'Hola' to white
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          _conversionFormula, // Keep the original formula style
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Add this IconButton where you want the reset button to appear
          ),
        ),
        floatingActionButton: Container(
          margin:
              const EdgeInsets.only(bottom: 50), // Adjust the margin as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Reset button - this can be styled as needed
              FloatingActionButton(
                heroTag: 'resetButton', // Unique tag for this FAB
                onPressed: _resetToDefault,
                backgroundColor: Colors.red,
                child: const Icon(Icons.restart_alt,
                    size: 36, color: Colors.white),
              ),
              // Share button
              FloatingActionButton(
                heroTag: 'shareButton', // Unique tag for this FAB
                onPressed: _takeScreenshotAndShare,
                backgroundColor: Colors.white,
                child: const Icon(Icons.share, size: 36, color: Colors.black),
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

  // Update the _buildUnitColumn method to include padding and width requirements
  Widget _buildUnitColumn(String label, TextEditingController controller,
      String unit, String prefix, bool isFrom) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 0.125), // 12.5% padding from each side
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            onChanged: (value) {
              // Only invoke formatting when the user has stopped typing.
              // Remove the auto-formatting logic from here.
              _isUserInput =
                  true; // Set this flag to true to indicate user input.
              convert(
                  value); // Call convert directly with the current input value.
            },
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: label, // Keep the label
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 3.0),
              ),
              //floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
                  // You can add more Widgets here if you need to
                ],
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.content_copy),
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
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          '${_getPrefix(value)} - $value',
          style: const TextStyle(
            color: Color(0xFF9CC0C5),
            fontSize: 23,
          ),
          overflow: TextOverflow.visible,
        ),
      );
    }).toList();

    items.insert(
      0,
      const DropdownMenuItem<String>(
        value: '',
        enabled: false,
        child: Text(
          'Choose a conversion unit',
          style: TextStyle(color: Colors.grey, fontSize: 23),
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
        fillColor: const Color(0xFF303134),
      ),
      value: currentValue.isNotEmpty ? currentValue : null,
      hint: const Text(
        'Choose a conversion unit',
        style: TextStyle(color: Colors.grey, fontSize: 23),
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
      dropdownColor: const Color(0xFF303134),
      items: items,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      iconSize: 24,
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((DropdownMenuItem<String> item) {
          return Center(
            child: Text(
              item.value == '' ? 'Choose a conversion unit' : item.value!,
              style: const TextStyle(
                color: Color(0xFF9CC0C5),
                fontSize: 23,
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
