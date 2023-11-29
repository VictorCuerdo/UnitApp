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

class AngleUnitConverter extends StatefulWidget {
  const AngleUnitConverter({super.key});

  @override
  _AngleUnitConverterState createState() => _AngleUnitConverterState();
}

class _AngleUnitConverterState extends State<AngleUnitConverter> {
  GlobalKey tooltipKey = GlobalKey();
  static const double mediumFontSize = 17.0;
  double fontSize = mediumFontSize;

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Radians';
  String toUnit = 'Gradians';
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
          text: 'Check out my angle conversion result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

    switch (fromUnit) {
      case 'Degrees':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue;
            break;
          case 'Radians':
            toValue = fromValue * (pi / 180);
            break;
          case 'Gradians':
            toValue = fromValue * (200 / 180);
            break;
          case 'Minutes of arc':
            toValue = fromValue * 60;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 3600;
            break;
          case 'Turns':
            toValue = fromValue / 360;
            break;
          case 'Revolutions':
            toValue = fromValue / 360;
            break;
          case 'Circles':
            toValue = fromValue / 360;
            break;
          case 'Quadrants':
            toValue = fromValue / 90;
            break;
          case 'Sextans':
            toValue = fromValue / 60;
            break;
          case 'Octants':
            toValue = fromValue / 45;
            break;
          case 'Signs':
            toValue = fromValue / 30;
            break;
          case 'Binary degrees':
            // Binary degrees are not a standard unit of angle. Assuming it's a custom unit, you will need a conversion factor.
            break;
          case 'Milliradians':
            toValue = fromValue * (pi / 180) * 1000;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * (160 / 9);
            break;
          // Add cases for any other units here
          default:
            // Handle the default case or throw an error
            throw Exception("Unsupported unit conversion");
        }

        break;
      case 'Radians':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * (180 / pi);
            break;
          case 'Radians':
            toValue = fromValue;
            break;
          case 'Gradians':
            toValue = fromValue * 63.66197723677;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 1145.9155902616;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 68974.9346157;
            break;
          case 'Turns':
            toValue = fromValue * 0.15915494309;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.15915494309;
            break;
          case 'Circles':
            toValue = fromValue * 0.15915494309;
            break;
          case 'Quadrants':
            toValue = fromValue * 4.0;
            break;
          case 'Sextants':
            toValue = fromValue * 6.0;
            break;
          case 'Octants':
            toValue = fromValue * 8.0;
            break;
          case 'Signs':
            toValue = fromValue * 12.0;
            break;
          case 'Binary degrees':
            toValue = fromValue * 101.25;
            break;
          case 'Milliradians':
            toValue = fromValue * 1000.0;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 101.25;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Gradians':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * (180 / 200);
            break;
          case 'Radians':
            toValue = fromValue * 0.01570796327;
            break;
          case 'Gradians':
            toValue = fromValue;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 17.777777777778;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 1066.6666666667;
            break;
          case 'Turns':
            toValue = fromValue * 0.0025;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.0025;
            break;
          case 'Circles':
            toValue = fromValue * 0.0025;
            break;
          case 'Quadrants':
            toValue = fromValue * 0.25;
            break;
          case 'Sextants':
            toValue = fromValue * 0.375;
            break;
          case 'Octants':
            toValue = fromValue * 0.5;
            break;
          case 'Signs':
            toValue = fromValue * 0.75;
            break;
          case 'Binary degrees':
            toValue = fromValue * 6.75;
            break;
          case 'Milliradians':
            toValue = fromValue * 16.0;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 6.75;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Minutes of arc':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue / 60;
            break;
          case 'Radians':
            toValue = fromValue * 0.00029088820867;
            break;
          case 'Gradians':
            toValue = fromValue * 0.0011111111111;
            break;
          case 'Minutes of arc':
            toValue = fromValue;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 60.0;
            break;
          case 'Turns':
            toValue = fromValue * 0.0000048481368;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.0000048481368;
            break;
          case 'Circles':
            toValue = fromValue * 0.0000048481368;
            break;
          case 'Quadrants':
            toValue = fromValue * 0.00027777777778;
            break;
          case 'Sextants':
            toValue = fromValue * 0.00041666666667;
            break;
          case 'Octants':
            toValue = fromValue * 0.00055555555556;
            break;
          case 'Signs':
            toValue = fromValue * 0.00083333333333;
            break;
          case 'Binary degrees':
            toValue = fromValue * 0.0075;
            break;
          case 'Milliradians':
            toValue = fromValue * 5.1444444444;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 0.3;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Seconds of arc':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue / 3600;
            break;
          case 'Radians':
            toValue = fromValue * 0.0000048481368;
            break;
          case 'Gradians':
            toValue = fromValue * 0.0000185185185;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 0.016666666667;
            break;
          case 'Seconds of arc':
            toValue = fromValue;
            break;
          case 'Turns':
            toValue = fromValue * 0.0000000808022;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.0000000808022;
            break;
          case 'Circles':
            toValue = fromValue * 0.0000000808022;
            break;
          case 'Quadrants':
            toValue = fromValue * 0.0000046296296;
            break;
          case 'Sextants':
            toValue = fromValue * 0.0000069444444;
            break;
          case 'Octants':
            toValue = fromValue * 0.0000092592593;
            break;
          case 'Signs':
            toValue = fromValue * 0.0000138888889;
            break;
          case 'Binary degrees':
            toValue = fromValue * 0.000125;
            break;
          case 'Milliradians':
            toValue = fromValue * 0.086666666667;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 0.005;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Turns':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * 360;
            break;
          case 'Radians':
            toValue = fromValue * 6.2831853072;
            break;
          case 'Gradians':
            toValue = fromValue * 40.0;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 360.0;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 21600.0;
            break;
          case 'Turns':
            toValue = fromValue;
            break;
          case 'Revolutions':
            toValue = fromValue * 1.0;
            break;
          case 'Circles':
            toValue = fromValue * 1.0;
            break;
          case 'Quadrants':
            toValue = fromValue * 4.0;
            break;
          case 'Sextants':
            toValue = fromValue * 6.0;
            break;
          case 'Octants':
            toValue = fromValue * 8.0;
            break;
          case 'Signs':
            toValue = fromValue * 12.0;
            break;
          case 'Binary degrees':
            toValue = fromValue * 90.0;
            break;
          case 'Milliradians':
            toValue = fromValue * 6283.1853072;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 360.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Revolutions':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * 360;
            break;
          case 'Radians':
            toValue = fromValue * 6.2831853072;
            break;
          case 'Gradians':
            toValue = fromValue * 400.0;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 360.0;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 21600.0;
            break;
          case 'Turns':
            toValue = fromValue * 1.0;
            break;
          case 'Revolutions':
            toValue = fromValue;
            break;
          case 'Circles':
            toValue = fromValue * 1.0;
            break;
          case 'Quadrants':
            toValue = fromValue * 4.0;
            break;
          case 'Sextants':
            toValue = fromValue * 6.0;
            break;
          case 'Octants':
            toValue = fromValue * 8.0;
            break;
          case 'Signs':
            toValue = fromValue * 12.0;
            break;
          case 'Binary degrees':
            toValue = fromValue * 90.0;
            break;
          case 'Milliradians':
            toValue = fromValue * 6283.1853072;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 360.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Circles':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * 360;
            break;
          case 'Radians':
            toValue = fromValue * 6.2831853072;
            break;
          case 'Gradians':
            toValue = fromValue * 40.0;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 360.0;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 21600.0;
            break;
          case 'Turns':
            toValue = fromValue * 1.0;
            break;
          case 'Revolutions':
            toValue = fromValue * 1.0;
            break;
          case 'Circles':
            toValue = fromValue;
            break;
          case 'Quadrants':
            toValue = fromValue * 4.0;
            break;
          case 'Sextants':
            toValue = fromValue * 6.0;
            break;
          case 'Octants':
            toValue = fromValue * 8.0;
            break;
          case 'Signs':
            toValue = fromValue * 12.0;
            break;
          case 'Binary degrees':
            toValue = fromValue * 90.0;
            break;
          case 'Milliradians':
            toValue = fromValue * 6283.1853072;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 360.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Quadrants':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * (360 / 4);
            break;
          case 'Radians':
            toValue = fromValue * 1.5707963268;
            break;
          case 'Gradians':
            toValue = fromValue * 100.0;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 90.0;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 5400.0;
            break;
          case 'Turns':
            toValue = fromValue * 0.25;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.25;
            break;
          case 'Circles':
            toValue = fromValue * 0.25;
            break;
          case 'Quadrants':
            toValue = fromValue;
            break;
          case 'Sextants':
            toValue = fromValue * 1.5;
            break;
          case 'Octants':
            toValue = fromValue * 2.0;
            break;
          case 'Signs':
            toValue = fromValue * 3.0;
            break;
          case 'Binary degrees':
            toValue = fromValue * 22.5;
            break;
          case 'Milliradians':
            toValue = fromValue * 1570.7963268;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 90.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Sextants':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * 60;
            break;
          case 'Radians':
            toValue = fromValue * 1.0471975512;
            break;
          case 'Gradians':
            toValue = fromValue * 66.6666666667;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 60.0;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 3600.0;
            break;
          case 'Turns':
            toValue = fromValue * 0.1666666667;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.1666666667;
            break;
          case 'Circles':
            toValue = fromValue * 0.1666666667;
            break;
          case 'Quadrants':
            toValue = fromValue * 0.5;
            break;
          case 'Sextants':
            toValue = fromValue;
            break;
          case 'Octants':
            toValue = fromValue * 1.3333333333;
            break;
          case 'Signs':
            toValue = fromValue * 2.0;
            break;
          case 'Binary degrees':
            toValue = fromValue * 15.0;
            break;
          case 'Milliradians':
            toValue = fromValue * 1047.1975512;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 60.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Octants':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * 80;
            break;
          case 'Radians':
            toValue = fromValue * 0.7853981634;
            break;
          case 'Gradians':
            toValue = fromValue * 50.0;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 45.0;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 2700.0;
            break;
          case 'Turns':
            toValue = fromValue * 0.125;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.125;
            break;
          case 'Circles':
            toValue = fromValue * 0.125;
            break;
          case 'Quadrants':
            toValue = fromValue * 0.375;
            break;
          case 'Sextants':
            toValue = fromValue * 0.75;
            break;
          case 'Octants':
            toValue = fromValue;
            break;
          case 'Signs':
            toValue = fromValue * 1.5;
            break;
          case 'Binary degrees':
            toValue = fromValue * 11.25;
            break;
          case 'Milliradians':
            toValue = fromValue * 785.3981634;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 45.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Signs':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * 30;
            break;
          case 'Radians':
            toValue = fromValue * 0.3926990817;
            break;
          case 'Gradians':
            toValue = fromValue * 25.0;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 22.5;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 1350.0;
            break;
          case 'Turns':
            toValue = fromValue * 0.0625;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.0625;
            break;
          case 'Circles':
            toValue = fromValue * 0.0625;
            break;
          case 'Quadrants':
            toValue = fromValue * 0.1875;
            break;
          case 'Sextants':
            toValue = fromValue * 0.375;
            break;
          case 'Octants':
            toValue = fromValue * 0.75;
            break;
          case 'Signs':
            toValue = fromValue;
            break;
          case 'Binary degrees':
            toValue = fromValue * 7.5;
            break;
          case 'Milliradians':
            toValue = fromValue * 392.6990817;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 22.5;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Binary degrees':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * 0.1111111111;
            break;
          case 'Radians':
            toValue = fromValue * 0.0523598776;
            break;
          case 'Gradians':
            toValue = fromValue * 3.3333333333;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 3.0;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 180.0;
            break;
          case 'Turns':
            toValue = fromValue * 0.0083333333;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.0083333333;
            break;
          case 'Circles':
            toValue = fromValue * 0.0083333333;
            break;
          case 'Quadrants':
            toValue = fromValue * 0.025;
            break;
          case 'Sextants':
            toValue = fromValue * 0.05;
            break;
          case 'Octants':
            toValue = fromValue * 0.1;
            break;
          case 'Signs':
            toValue = fromValue * 0.1333333333;
            break;
          case 'Binary degrees':
            toValue = fromValue;
            break;
          case 'Milliradians':
            toValue = fromValue * 52.3598776;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 3.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Milliradians':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * (180 / pi) * 0.001;
            break;
          case 'Radians':
            toValue = fromValue * 0.001;
            break;
          case 'Gradians':
            toValue = fromValue * 0.0636619772;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 0.0572957795;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 3.4377467708;
            break;
          case 'Turns':
            toValue = fromValue * 0.0001591549;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.0001591549;
            break;
          case 'Circles':
            toValue = fromValue * 0.0001591549;
            break;
          case 'Quadrants':
            toValue = fromValue * 0.0004774647;
            break;
          case 'Sextants':
            toValue = fromValue * 0.0009549295;
            break;
          case 'Octants':
            toValue = fromValue * 0.0019098591;
            break;
          case 'Signs':
            toValue = fromValue * 0.0025464788;
            break;
          case 'Binary degrees':
            toValue = fromValue * 20.0;
            break;
          case 'Milliradians':
            toValue = fromValue;
            break;
          case 'Mils (NATO)':
            toValue = fromValue * 17.7777777778;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Mils (NATO)':
        switch (toUnit) {
          case 'Degrees':
            toValue = fromValue * (180 / pi) * 0.001;
            break;
          case 'Radians':
            toValue = fromValue * 0.0000888889;
            break;
          case 'Gradians':
            toValue = fromValue * 0.005;
            break;
          case 'Minutes of arc':
            toValue = fromValue * 0.0047746487;
            break;
          case 'Seconds of arc':
            toValue = fromValue * 0.2864789244;
            break;
          case 'Turns':
            toValue = fromValue * 0.0000134908;
            break;
          case 'Revolutions':
            toValue = fromValue * 0.0000134908;
            break;
          case 'Circles':
            toValue = fromValue * 0.0000134908;
            break;
          case 'Quadrants':
            toValue = fromValue * 0.0000404723;
            break;
          case 'Sextants':
            toValue = fromValue * 0.0000809446;
            break;
          case 'Octants':
            toValue = fromValue * 0.0001618892;
            break;
          case 'Signs':
            toValue = fromValue * 0.0002158523;
            break;
          case 'Binary degrees':
            toValue = fromValue * 1.125;
            break;
          case 'Milliradians':
            toValue = fromValue * 0.05625;
            break;
          case 'Mils (NATO)':
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
// DEGREES
      case 'Degrees':
        switch (toUnit) {
          case 'Radians':
            formula = 'Multiply the angle value by (π/180)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by (10/9)';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 60';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 3600';
            break;
          case 'Turns':
            formula = 'Divide the angle value by 360';
            break;
          case 'Revolutions':
            formula = 'Divide the angle value by 360';
            break;
          case 'Circles':
            formula = 'Divide the angle value by 360';
            break;
          case 'Quadrants':
            formula = 'Divide the angle value by 90';
            break;
          case 'Sextants':
            formula = 'Divide the angle value by 60';
            break;
          case 'Octants':
            formula = 'Divide the angle value by 45';
            break;
          case 'Signs':
            formula = 'Divide the angle value by 30';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 5120';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by (π/180) * 1000';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 17.7778';
            break;
          case 'Degrees':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// RADIANS
      case 'Radians':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by (180/π)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by (180/π) * (10/9)';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by (180/π) * 60';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by (180/π) * 3600';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by (1/2π)';
            break;
          case 'Revolutions':
            formula = 'Multiply the angle value by (1/2π)';
            break;
          case 'Circles':
            formula = 'Multiply the angle value by (1/2π)';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by (1/π) * 2';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by (1/π) * 3';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by (1/π) * 4';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by (1/π) * 6';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by (180/π) * 5120';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 1000';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by (180/π) * 17.7778';
            break;
          case 'Radians':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// GRADIANS
      case 'Gradians':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by (9/10)';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by (π/200)';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 100';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 6000';
            break;
          case 'Turns':
            formula = 'Divide the angle value by 400';
            break;
          case 'Revolutions':
            formula = 'Divide the angle value by 400';
            break;
          case 'Circles':
            formula = 'Divide the angle value by 400';
            break;
          case 'Quadrants':
            formula = 'Divide the angle value by 100';
            break;
          case 'Sextants':
            formula = 'Divide the angle value by 66.6667';
            break;
          case 'Octants':
            formula = 'Divide the angle value by 50';
            break;
          case 'Signs':
            formula = 'Divide the angle value by 33.3333';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 512';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by (π/200) * 1000';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 16';
            break;
          case 'Gradians':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// MINUTES OF ARC
      case 'Minutes of arc':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Divide the angle value by 60';
            break;
          case 'Radians':
            formula = 'Divide the angle value by 60 * (180/π)';
            break;
          case 'Gradians':
            formula = 'Divide the angle value by 100';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 60';
            break;
          case 'Turns':
            formula = 'Divide the angle value by 216000';
            break;
          case 'Revolutions':
            formula = 'Divide the angle value by 216000';
            break;
          case 'Circles':
            formula = 'Divide the angle value by 216000';
            break;
          case 'Quadrants':
            formula = 'Divide the angle value by 1440';
            break;
          case 'Sextants':
            formula = 'Divide the angle value by 240';
            break;
          case 'Octants':
            formula = 'Divide the angle value by 180';
            break;
          case 'Signs':
            formula = 'Divide the angle value by 120';
            break;
          case 'Binary degrees':
            formula = 'Divide the angle value by 3600';
            break;
          case 'Milliradians':
            formula = 'Divide the angle value by 60 * (π/180) * 1000';
            break;
          case 'Mils (NATO)':
            formula = 'Divide the angle value by 0.9';
            break;
          case 'Minutes of arc':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// SECONDS OF ARC
      case 'Seconds of arc':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Divide the angle value by 3600';
            break;
          case 'Radians':
            formula = 'Divide the angle value by 3600 * (π/180)';
            break;
          case 'Gradians':
            formula = 'Divide the angle value by 10000';
            break;
          case 'Minutes of arc':
            formula = 'Divide the angle value by 60';
            break;
          case 'Turns':
            formula = 'Divide the angle value by 1296000';
            break;
          case 'Revolutions':
            formula = 'Divide the angle value by 1296000';
            break;
          case 'Circles':
            formula = 'Divide the angle value by 1296000';
            break;
          case 'Quadrants':
            formula = 'Divide the angle value by 3600';
            break;
          case 'Sextants':
            formula = 'Divide the angle value by 600';
            break;
          case 'Octants':
            formula = 'Divide the angle value by 450';
            break;
          case 'Signs':
            formula = 'Divide the angle value by 300';
            break;
          case 'Binary degrees':
            formula = 'Divide the angle value by 36000';
            break;
          case 'Milliradians':
            formula = 'Divide the angle value by 60 * (π/180) * 1000';
            break;
          case 'Mils (NATO)':
            formula = 'Divide the angle value by 0.09';
            break;
          case 'Seconds of arc':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// TURNS
      case 'Turns':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 360';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 360 * (π/180)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 400';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 21600';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 1296000';
            break;
          case 'Revolutions':
            formula = 'Divide the angle value by 1';
            break;
          case 'Circles':
            formula = 'Divide the angle value by 1';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by 4';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by 6';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by 8';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by 12';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 36000';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 1000 * (π/180)';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 6400';
            break;
          case 'Turns':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// REVOLUTIONS
      case 'Revolutions':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 360';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 360 * (π/180)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 400';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 21600';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 1296000';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by 1';
            break;
          case 'Circles':
            formula = 'Multiply the angle value by 1';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by 4';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by 6';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by 8';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by 12';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 36000';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 1000 * (π/180)';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 6400';
            break;
          case 'Revolutions':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// CIRCLES
      case 'Circles':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 360';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 360 * (π/180)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 400';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 21600';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 1296000';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by 1';
            break;
          case 'Revolutions':
            formula = 'Multiply the angle value by 1';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by 4';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by 6';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by 8';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by 12';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 36000';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 1000 * (π/180)';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 6400';
            break;
          case 'Circles':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// QUADRANTS
      case 'Quadrants':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 90';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 90 * (π/180)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 100';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 5400';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 324000';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by 1/4';
            break;
          case 'Revolutions':
            formula = 'Multiply the angle value by 1/4';
            break;
          case 'Circles':
            formula = 'Multiply the angle value by 1/4';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by 1.5';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by 2';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by 3';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 22500';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 250 * (π/180)';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 1600';
            break;
          case 'Quadrants':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// SEXTANTS
      case 'Sextants':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 60';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 60 * (π/180)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 66.6667';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 3600';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 216000';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by 1/6';
            break;
          case 'Revolutions':
            formula = 'Multiply the angle value by 1/6';
            break;
          case 'Circles':
            formula = 'Multiply the angle value by 1/6';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by 0.5';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by 1.3333';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by 2';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 15000';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 166.667 * (π/180)';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 1000';
            break;
          case 'Sextants':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// OCTANTS
      case 'Octants':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 45';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 45 * (π/180)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 50';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 2700';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 162000';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by 1/8';
            break;
          case 'Revolutions':
            formula = 'Multiply the angle value by 1/8';
            break;
          case 'Circles':
            formula = 'Multiply the angle value by 1/8';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by 0.25';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by 0.75';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by 2';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 11250';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 125 * (π/180)';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 800';
            break;
          case 'Octants':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// SIGNS
      case 'Signs':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 22.5';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 22.5 * (π/180)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 25';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 1350';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 81000';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by 1/16';
            break;
          case 'Revolutions':
            formula = 'Multiply the angle value by 1/16';
            break;
          case 'Circles':
            formula = 'Multiply the angle value by 1/16';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by 0.0625';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by 0.125';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by 0.25';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 5625';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 62.5 * (π/180)';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 400';
            break;
          case 'Signs':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// BINARY DEGREES
      case 'Binary degrees':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 0.025';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 0.025 * (π/180)';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 0.0277778';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 1.5';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 90';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by 1/360';
            break;
          case 'Revolutions':
            formula = 'Multiply the angle value by 1/360';
            break;
          case 'Circles':
            formula = 'Multiply the angle value by 1/360';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by 0.00625';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by 0.0125';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by 0.025';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by 0.0444444';
            break;
          case 'Binary degrees':
            formula = 'The value remains unchanged';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 17.7778 * (π/180)';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 11.25';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// MILLIRADIANS
      case 'Milliradians':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 180/π * 1000';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 1000';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 180/π * 1000 / 9';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 180/π * 60 * 1000';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 180/π * 3600 * 1000';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by 180/π * 2π * 1000';
            break;
          case 'Revolutions':
            formula = 'Multiply the angle value by 180/π * 1000 / 360';
            break;
          case 'Circles':
            formula = 'Multiply the angle value by 180/π * 1000 / 360';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by 180/π * 1000 / 90';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by 180/π * 1000 / 60';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by 180/π * 1000 / 45';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by 180/π * 1000 / 22.5';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 180/π * 1000 / 0.025';
            break;
          case 'Milliradians':
            formula = 'The value remains unchanged';
            break;
          case 'Mils (NATO)':
            formula = 'Multiply the angle value by 180/π * 1000 / 0.0111111';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// MILS (NATO)
      case 'Mils (NATO)':
        switch (toUnit) {
          case 'Degrees':
            formula = 'Multiply the angle value by 0.05625';
            break;
          case 'Radians':
            formula = 'Multiply the angle value by 0.0015708';
            break;
          case 'Gradians':
            formula = 'Multiply the angle value by 0.0625';
            break;
          case 'Minutes of arc':
            formula = 'Multiply the angle value by 3.375';
            break;
          case 'Seconds of arc':
            formula = 'Multiply the angle value by 202.5';
            break;
          case 'Turns':
            formula = 'Multiply the angle value by 0.00015625';
            break;
          case 'Revolutions':
            formula = 'Multiply the angle value by 0.00015625';
            break;
          case 'Circles':
            formula = 'Multiply the angle value by 0.00015625';
            break;
          case 'Quadrants':
            formula = 'Multiply the angle value by 0.003125';
            break;
          case 'Sextants':
            formula = 'Multiply the angle value by 0.00625';
            break;
          case 'Octants':
            formula = 'Multiply the angle value by 0.0125';
            break;
          case 'Signs':
            formula = 'Multiply the angle value by 0.0222222';
            break;
          case 'Binary degrees':
            formula = 'Multiply the angle value by 0.09';
            break;
          case 'Milliradians':
            formula = 'Multiply the angle value by 0.0111111';
            break;
          case 'Mils (NATO)':
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
                          child: AutoSizeText('Convert Angle'.tr(),
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
      case 'Degrees':
        return '°';
      case 'Radians':
        return 'rad';
      case 'Gradians':
        return 'grad';
      case 'Minutes of arc':
        return '′'; // Unicode character for minute of arc
      case 'Seconds of arc':
        return '″'; // Unicode character for second of arc
      case 'Turns':
        return 'turn';
      case 'Revolutions':
        return 'rev';
      case 'Circles':
        return 'circ';
      case 'Quadrants':
        return '';
      case 'Sextants':
        return '';
      case 'Octants':
        return '';
      case 'Signs':
        return '';
      case 'Binary degrees':
        return '';
      case 'Milliradians':
        return 'mrad';
      case 'Mils (NATO)':
        return 'mil'; // This may be 'mil' or 'mil (NATO)' depending on the context
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
      'Degrees',
      'Radians',
      'Gradians',
      'Minutes of arc',
      'Seconds of arc',
      'Turns',
      'Revolutions',
      'Circles',
      'Quadrants',
      'Sextants',
      'Octants',
      'Signs',
      'Binary degrees',
      'Milliradians',
      'Mils (NATO)',
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
              item.value == '' ? 'Choose a conversion unit'.tr() : item.value!,
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
