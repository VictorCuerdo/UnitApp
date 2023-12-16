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

class TimeUnitConverter extends StatefulWidget {
  const TimeUnitConverter({super.key});

  @override
  _TimeUnitConverterState createState() => _TimeUnitConverterState();
}

class _TimeUnitConverterState extends State<TimeUnitConverter> {
  GlobalKey tooltipKey = GlobalKey();
  static const double mediumFontSize = 17.0;
  double fontSize = mediumFontSize;
  bool isTyping = false;

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
          text: 'Check out my time conversion result!'.tr());
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
                              child: AutoSizeText('Convert Time'.tr(),
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
