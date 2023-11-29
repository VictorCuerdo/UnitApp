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

class DatasUnitConverter extends StatefulWidget {
  const DatasUnitConverter({super.key});

  @override
  _DatasUnitConverterState createState() => _DatasUnitConverterState();
}

class _DatasUnitConverterState extends State<DatasUnitConverter> {
  static const double mediumFontSize = 17.0;
  GlobalKey tooltipKey = GlobalKey();
  double fontSize = mediumFontSize;

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Bytes';
  String toUnit = 'Kibibytes';
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
          text: 'Check out my data size result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

    switch (fromUnit) {
      case 'Bytes':
        switch (toUnit) {
          case 'Kibibytes':
            toValue = fromValue * 0.0009765625;
            break;
          case 'Mebibytes':
            toValue = fromValue * 9.5367431641e-7;
            break;
          case 'Gigibytes':
            toValue = fromValue * 9.3132257462e-10;
            break;
          case 'Tebibytes':
            toValue = fromValue * 9.0949470177e-13;
            break;
          case 'Pebibytes':
            toValue = fromValue * 8.881784197e-16;
            break;
          case 'Kilobytes':
            toValue = fromValue * 0.001;
            break;
          case 'Megabytes':
            toValue = fromValue * 1.0e-6;
            break;
          case 'Gigabytes':
            toValue = fromValue * 1.0e-9;
            break;
          case 'Terabytes':
            toValue = fromValue * 1.0e-12;
            break;
          case 'Petabytes':
            toValue = fromValue * 1.0e-15;
            break;
          case 'Bits':
            toValue = fromValue * 8.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 0.0078125;
            break;
          case 'Mebibits':
            toValue = fromValue * 7.6293945313e-6;
            break;
          case 'Gigibits':
            toValue = fromValue * 7.4505805969e-9;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kibibytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Mebibytes':
            toValue = fromValue * 0.0009765625;
            break;
          case 'Gigibytes':
            toValue = fromValue * 9.5367431641e-7;
            break;
          case 'Tebibytes':
            toValue = fromValue * 9.3132257462e-10;
            break;
          case 'Pebibytes':
            toValue = fromValue * 9.0949470177e-13;
            break;
          case 'Kilobytes':
            toValue = fromValue * 0.0009765625;
            break;
          case 'Megabytes':
            toValue = fromValue * 9.5367431641e-7;
            break;
          case 'Gigabytes':
            toValue = fromValue * 9.3132257462e-10;
            break;
          case 'Terabytes':
            toValue = fromValue * 9.0949470177e-13;
            break;
          case 'Petabytes':
            toValue = fromValue * 8.881784197e-16;
            break;
          case 'Bits':
            toValue = fromValue * 8192.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 0.0078125;
            break;
          case 'Gigibits':
            toValue = fromValue * 7.6293945313e-6;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Mebibytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Gigibytes':
            toValue = fromValue * 9.5367431641e-7;
            break;
          case 'Tebibytes':
            toValue = fromValue * 9.3132257462e-10;
            break;
          case 'Pebibytes':
            toValue = fromValue * 9.0949470177e-13;
            break;
          case 'Kilobytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Megabytes':
            toValue = fromValue * 1.0;
            break;
          case 'Gigabytes':
            toValue = fromValue * 9.5367431641e-7;
            break;
          case 'Terabytes':
            toValue = fromValue * 9.3132257462e-10;
            break;
          case 'Petabytes':
            toValue = fromValue * 9.0949470177e-13;
            break;
          case 'Bits':
            toValue = fromValue * 8388608.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8192.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 8.0;
            break;
          case 'Gigibits':
            toValue = fromValue * 7.6293945313e-6;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Gigibytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1073741824.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Mebibytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Tebibytes':
            toValue = fromValue * 9.3132257462e-10;
            break;
          case 'Pebibytes':
            toValue = fromValue * 9.0949470177e-13;
            break;
          case 'Kilobytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Megabytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Gigabytes':
            toValue = fromValue * 1.0;
            break;
          case 'Terabytes':
            toValue = fromValue * 9.3132257462e-10;
            break;
          case 'Petabytes':
            toValue = fromValue * 9.0949470177e-13;
            break;
          case 'Bits':
            toValue = fromValue * 8589934592.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8388608.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 8192.0;
            break;
          case 'Gigibits':
            toValue = fromValue * 8.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Tebibytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1099511627776.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 1073741824.0;
            break;
          case 'Mebibytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Gigibytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Pebibytes':
            toValue = fromValue * 0.0009765625;
            break;
          case 'Kilobytes':
            toValue = fromValue * 1073741824.0;
            break;
          case 'Megabytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Gigabytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Tebibytes':
            toValue = fromValue * 1.0;
            break;
          case 'Petabytes':
            toValue = fromValue * 0.0009765625;
            break;
          case 'Bits':
            toValue = fromValue * 8796093022208.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8589934592.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 8388608.0;
            break;
          case 'Gigibits':
            toValue = fromValue * 8192.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Pebibytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1125899906842624.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 1099511627776.0;
            break;
          case 'Mebibytes':
            toValue = fromValue * 1073741824.0;
            break;
          case 'Gigibytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Tebibytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Kilobytes':
            toValue = fromValue * 1099511627776.0;
            break;
          case 'Megabytes':
            toValue = fromValue * 1073741824.0;
            break;
          case 'Gigabytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Petabytes':
            toValue = fromValue * 1.0;
            break;
          case 'Bits':
            toValue = fromValue * 9007199254740992.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8796093022208.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 8589934592.0;
            break;
          case 'Gigibits':
            toValue = fromValue * 8388608.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilobytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 0.976563;
            break;
          case 'Mebibytes':
            toValue = fromValue * 0.000954;
            break;
          case 'Gigibytes':
            toValue = fromValue * 0.0000009313225746;
            break;
          case 'Tebibytes':
            toValue = fromValue * 0.0000000009094947;
            break;
          case 'Pebibytes':
            toValue = fromValue * 0.0000000000008881784;
            break;
          case 'Kilobytes': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Megabytes':
            toValue = fromValue * 0.000976563;
            break;
          case 'Gigabytes':
            toValue = fromValue * 0.0000009536743164;
            break;
          case 'Terabytes':
            toValue = fromValue * 0.0000000009313225746;
            break;
          case 'Petabytes':
            toValue = fromValue * 0.0000000000009094947;
            break;
          case 'Bits':
            toValue = fromValue * 8192.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 7812.5;
            break;
          case 'Mebibits':
            toValue = fromValue * 7.62939453125;
            break;
          case 'Gigibits':
            toValue = fromValue * 0.0074505805969238;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Megabytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Mebibytes':
            toValue = fromValue * 0.976563;
            break;
          case 'Gigibytes':
            toValue = fromValue * 0.000976563;
            break;
          case 'Tebibytes':
            toValue = fromValue * 0.0000009536743164;
            break;
          case 'Pebibytes':
            toValue = fromValue * 0.0000000009313225746;
            break;
          case 'Kilobytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Megabytes': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Gigabytes':
            toValue = fromValue * 0.000976563;
            break;
          case 'Terabytes':
            toValue = fromValue * 0.0000009536743164;
            break;
          case 'Petabytes':
            toValue = fromValue * 0.0000000009313225746;
            break;
          case 'Bits':
            toValue = fromValue * 8388608.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8192.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 7.62939453125;
            break;
          case 'Gigibits':
            toValue = fromValue * 0.0074505805969238;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Gigabytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1073741824.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Mebibytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Terabytes':
            toValue = fromValue * 0.001;
            break;
          case 'Petabytes':
            toValue = fromValue * 0.000001;
            break;
          case 'Bits':
            toValue = fromValue * 8589934592.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8388608.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 8192.0;
            break;
          case 'Gigibits':
            toValue = fromValue * 8.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Terabytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1099511627776.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 1073741824.0;
            break;
          case 'Mebibytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Gigabytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Petabytes':
            toValue = fromValue * 0.001;
            break;
          case 'Bits':
            toValue = fromValue * 8796093022208.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8589934592.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 8388608.0;
            break;
          case 'Gigibits':
            toValue = fromValue * 8192.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Petabytes':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 1125899906842624.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 1099511627776.0;
            break;
          case 'Mebibytes':
            toValue = fromValue * 1073741824.0;
            break;
          case 'Gigabytes':
            toValue = fromValue * 1048576.0;
            break;
          case 'Terabytes':
            toValue = fromValue * 1024.0;
            break;
          case 'Bits':
            toValue = fromValue * 9007199254740992000.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8796093022208000.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 8589934592000.0;
            break;
          case 'Gigibits':
            toValue = fromValue * 8388608000.0;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Bits':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 0.125;
            break;
          case 'Kibibytes':
            toValue = fromValue * 0.0001220703125;
            break;
          case 'Mebibytes':
            toValue = fromValue * 1.1920928955078125e-7;
            break;
          case 'Gigabytes':
            toValue = fromValue * 1.1641532182693481e-10;
            break;
          case 'Terabytes':
            toValue = fromValue * 1.1368683772161603e-13;
            break;
          case 'Petabytes':
            toValue = fromValue * 1.1102230246251565e-16;
            break;
          case 'Kibibits':
            toValue = fromValue * 0.0078125;
            break;
          case 'Mebibits':
            toValue = fromValue * 7.62939453125e-6;
            break;
          case 'Gigibits':
            toValue = fromValue * 0.000007450580596923828;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kibibits':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 128.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 0.125;
            break;
          case 'Mebibytes':
            toValue = fromValue * 0.0001220703125;
            break;
          case 'Gigibytes':
            toValue = fromValue * 1.1920928955078125e-7;
            break;
          case 'Terabytes':
            toValue = fromValue * 1.1641532182693481e-10;
            break;
          case 'Petabytes':
            toValue = fromValue * 1.1368683772161603e-13;
            break;
          case 'Bits':
            toValue = fromValue * 8192.0;
            break;
          case 'Kibibits': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Mebibits':
            toValue = fromValue * 0.0078125;
            break;
          case 'Gigibits':
            toValue = fromValue * 7.62939453125e-6;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Mebibits':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 16384.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 0.015625;
            break;
          case 'Mebibytes':
            toValue = fromValue * 0.0000152587890625;
            break;
          case 'Gigibytes':
            toValue = fromValue * 1.4901161193847656e-8;
            break;
          case 'Terabytes':
            toValue = fromValue * 1.4551915228366852e-11;
            break;
          case 'Petabytes':
            toValue = fromValue * 1.4210854715202004e-14;
            break;
          case 'Bits':
            toValue = fromValue * 16384.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 128.0;
            break;
          case 'Mebibits': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Gigibits':
            toValue = fromValue * 0.0009765625;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Gigibits':
        switch (toUnit) {
          case 'Bytes':
            toValue = fromValue * 134217728.0;
            break;
          case 'Kibibytes':
            toValue = fromValue * 131072.0;
            break;
          case 'Mebibytes':
            toValue = fromValue * 128.0;
            break;
          case 'Gigibytes':
            toValue = fromValue * 0.125;
            break;
          case 'Terabytes':
            toValue = fromValue * 0.0001220703125;
            break;
          case 'Petabytes':
            toValue = fromValue * 1.1920928955078125e-7;
            break;
          case 'Bits':
            toValue = fromValue * 8589934592.0;
            break;
          case 'Kibibits':
            toValue = fromValue * 8388608.0;
            break;
          case 'Mebibits':
            toValue = fromValue * 8192.0;
            break;
          case 'Gigibits': // No conversion needed if from and to units are the same
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
      // Bytes
      case 'Bytes':
        switch (toUnit) {
          case 'Kibibytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Mebibytes':
            formula = 'Divide the Data value by 1048576';
            break;
          case 'Gigibytes':
            formula = 'Divide the Data value by 1073741824';
            break;
          case 'Tebibytes':
            formula = 'Divide the Data value by 1099511627776';
            break;
          case 'Pebibytes':
            formula = 'Divide the Data value by 1125899906842624';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 0.001';
            break;
          case 'Megabytes':
            formula = 'Multiply the Data value by 0.000001';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 1e-9';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 1e-12';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 1e-15';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 8';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8 / 1024';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 8 / 1048576';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 8 / 1073741824';
            break;
          case 'Bytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Kibibytes
      case 'Kibibytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Mebibytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Gigibytes':
            formula = 'Divide the Data value by 1048576';
            break;
          case 'Tebibytes':
            formula = 'Divide the Data value by 1073741824';
            break;
          case 'Pebibytes':
            formula = 'Divide the Data value by 1099511627776';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 0.000976563';
            break;
          case 'Megabytes':
            formula = 'Multiply the Data value by 0.000000953674';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 9.31323e-10';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 9.09495e-13';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 8.88178e-16';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 8192';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8';
            break;
          case 'Mebibits':
            formula = 'Divide the Data value by 128';
            break;
          case 'Gigibits':
            formula = 'Divide the Data value by 131072';
            break;
          case 'Kibibytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Mebibytes
      case 'Mebibytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Gigibytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Tebibytes':
            formula = 'Divide the Data value by 1048576';
            break;
          case 'Pebibytes':
            formula = 'Divide the Data value by 1073741824';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Megabytes':
            formula = 'Multiply the Data value by 1';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 0.000976563';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 9.53674e-7';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 9.31323e-10';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 8388608';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8192';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 8';
            break;
          case 'Gigibits':
            formula = 'Divide the Data value by 128';
            break;
          case 'Mebibytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Gigibytes
      case 'Gigibytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Mebibytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Tebibytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Pebibytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Megabytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 1';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 0.000976563';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 9.53674e-7';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 8589934592';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8388608';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 8192';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 8';
            break;
          case 'Gigibytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Tebibytes
      case 'Tebibytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1099511627776';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Mebibytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Gigibytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Pebibytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 1099511627776';
            break;
          case 'Megabytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Petabytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 8796093022208';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8589934592';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 8388608';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 8192';
            break;
          case 'Tebibytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Pebibytes
      case 'Pebibytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1125899906842624';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 1099511627776';
            break;
          case 'Mebibytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Gigibytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Tebibytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 1125899906842624';
            break;
          case 'Megabytes':
            formula = 'Multiply the Data value by 1099511627776';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 9007199254740992';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8796093022208';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 8589934592';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 8388608';
            break;
          case 'Pebibytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Kilobytes
      case 'Kilobytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 0.9765625';
            break;
          case 'Mebibytes':
            formula = 'Multiply the Data value by 0.0009765625';
            break;
          case 'Gigibytes':
            formula = 'Multiply the Data value by 9.5367431640625e-7';
            break;
          case 'Tebibytes':
            formula = 'Multiply the Data value by 9.3132257461548e-10';
            break;
          case 'Pebibytes':
            formula = 'Multiply the Data value by 9.0949470177293e-13';
            break;
          case 'Megabytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 0.0009765625';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 9.5367431640625e-7';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 9.3132257461548e-10';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 8192';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 7.8125';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 0.0078125';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 7.62939453125e-6';
            break;
          case 'Kilobytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Megabytes
      case 'Megabytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Mebibytes':
            formula = 'Multiply the Data value by 0.9765625';
            break;
          case 'Gigibytes':
            formula = 'Multiply the Data value by 0.0009765625';
            break;
          case 'Tebibytes':
            formula = 'Multiply the Data value by 9.5367431640625e-7';
            break;
          case 'Pebibytes':
            formula = 'Multiply the Data value by 9.3132257461548e-10';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 0.0009765625';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 9.5367431640625e-7';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 9.3132257461548e-10';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 8388608';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8192';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 7.8125';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 0.0078125';
            break;
          case 'Megabytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Gigabytes
      case 'Gigabytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Mebibytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Gigibytes':
            formula = 'Multiply the Data value by 0.9765625';
            break;
          case 'Tebibytes':
            formula = 'Multiply the Data value by 0.0009765625';
            break;
          case 'Pebibytes':
            formula = 'Multiply the Data value by 9.5367431640625e-7';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Megabytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 0.0009765625';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 9.5367431640625e-7';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 8589934592';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8388608';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 8192';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 8';
            break;
          case 'Gigabytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Terabytes
      case 'Terabytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1099511627776';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Mebibytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Gigibytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Tebibytes':
            formula = 'Multiply the Data value by 0.9765625';
            break;
          case 'Pebibytes':
            formula = 'Multiply the Data value by 0.0009765625';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Megabytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 0.0009765625';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 8796093022208';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8589934592';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 8388608';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 8192';
            break;
          case 'Terabytes':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Petabytes
      case 'Petabytes':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 1125899906842624';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 1099511627776';
            break;
          case 'Mebibytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Gigibytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Tebibytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Pebibytes':
            formula = 'Multiply the Data value by 0.9765625';
            break;
          case 'Kilobytes':
            formula = 'Multiply the Data value by 1099511627776';
            break;
          case 'Megabytes':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Gigabytes':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Terabytes':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Petabytes':
            formula = 'Multiply the Data value by 0.9765625';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 9007199254740992';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 8796093022208';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 8589934592';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 8388608';
            break;
          case 'Petabits':
            formula = 'Multiply the Data value by 8';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Bits
      case 'Bits':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Divide the Data value by 8';
            break;
          case 'Kibibytes':
            formula = 'Divide the Data value by 8192';
            break;
          case 'Mebibytes':
            formula = 'Divide the Data value by 8388608';
            break;
          case 'Gigibytes':
            formula = 'Divide the Data value by 8589934592';
            break;
          case 'Tebibytes':
            formula = 'Divide the Data value by 8796093022208';
            break;
          case 'Pebibytes':
            formula = 'Divide the Data value by 9007199254740992';
            break;
          case 'Kilobytes':
            formula = 'Divide the Data value by 8000000';
            break;
          case 'Megabytes':
            formula = 'Divide the Data value by 8000000000';
            break;
          case 'Gigabytes':
            formula = 'Divide the Data value by 8000000000000';
            break;
          case 'Terabytes':
            formula = 'Divide the Data value by 8000000000000000';
            break;
          case 'Petabytes':
            formula = 'Divide the Data value by 8000000000000000000';
            break;
          case 'Bits':
            formula = 'The value remains unchanged';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 1048576';
            break;
          case 'Gigibits':
            formula = 'Multiply the Data value by 1073741824';
            break;
          case 'Petabits':
            formula = 'Multiply the Data value by 1125899906842624';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Kibibits
      case 'Kibibits':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Divide the Data value by 8';
            break;
          case 'Kibibytes':
            formula = 'Divide the Data value by 8192';
            break;
          case 'Mebibytes':
            formula = 'Divide the Data value by 8388608';
            break;
          case 'Gibibytes':
            formula = 'Divide the Data value by 8589934592';
            break;
          case 'Tebibytes':
            formula = 'Divide the Data value by 8796093022208';
            break;
          case 'Pebibytes':
            formula = 'Divide the Data value by 9007199254740992';
            break;
          case 'Kilobits':
            formula = 'Divide the Data value by 1000';
            break;
          case 'Megabits':
            formula = 'Divide the Data value by 1000000';
            break;
          case 'Gigabits':
            formula = 'Divide the Data value by 1000000000';
            break;
          case 'Terabits':
            formula = 'Divide the Data value by 1000000000000';
            break;
          case 'Petabits':
            formula = 'Divide the Data value by 1000000000000000';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Kibibits':
            formula = 'The value remains unchanged';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 1024';
            break;
          case 'Gibibits':
            formula = 'Multiply the Data value by 1048576';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// Mebibits
      case 'Mebibits':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 131072';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 128';
            break;
          case 'Mebibytes':
            formula = 'Divide the Data value by 8';
            break;
          case 'Gibibytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Tebibytes':
            formula = 'Divide the Data value by 1048576';
            break;
          case 'Pebibytes':
            formula = 'Divide the Data value by 1073741824';
            break;
          case 'Kilobits':
            formula = 'Multiply the Data value by 128';
            break;
          case 'Megabits':
            formula = 'Divide the Data value by 8';
            break;
          case 'Gigabits':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Terabits':
            formula = 'Divide the Data value by 1048576';
            break;
          case 'Petabits':
            formula = 'Divide the Data value by 1073741824';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 131072';
            break;
          case 'Kibibits':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Mebibits':
            formula = 'The value remains unchanged';
            break;
          case 'Gibibits':
            formula = 'Multiply the Data value by 1024';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// Gigibits
      case 'Gigibits':
        switch (toUnit) {
          case 'Bytes':
            formula = 'Multiply the Data value by 134217728';
            break;
          case 'Kibibytes':
            formula = 'Multiply the Data value by 131072';
            break;
          case 'Mebibytes':
            formula = 'Multiply the Data value by 128';
            break;
          case 'Gibibytes':
            formula = 'Divide the Data value by 8';
            break;
          case 'Tebibytes':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Pebibytes':
            formula = 'Divide the Data value by 1048576';
            break;
          case 'Kilobits':
            formula = 'Multiply the Data value by 134217728';
            break;
          case 'Megabits':
            formula = 'Multiply the Data value by 131072';
            break;
          case 'Gigabits':
            formula = 'Multiply the Data value by 128';
            break;
          case 'Terabits':
            formula = 'Divide the Data value by 8';
            break;
          case 'Petabits':
            formula = 'Divide the Data value by 1024';
            break;
          case 'Bits':
            formula = 'Multiply the Data value by 137438953472';
            break;
          case 'Kibibits':
            formula = 'Multiply the Data value by 134217728';
            break;
          case 'Mebibits':
            formula = 'Multiply the Data value by 131072';
            break;
          case 'Gibibits':
            formula = 'Multiply the Data value by 128';
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
                          child: AutoSizeText('Convert Data Sizes'.tr(),
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
      case 'Bytes':
        return 'B';
      case 'Kibibytes':
        return 'KiB';
      case 'Mebibytes':
        return 'MiB';
      case 'Gigibytes':
        return 'GiB';
      case 'Tebibytes':
        return 'TiB';
      case 'Pebibytes':
        return 'PiB';
      case 'Kilobytes':
        return 'KB';
      case 'Megabytes':
        return 'MB';
      case 'Gigabytes':
        return 'GB';
      case 'Terabytes':
        return 'TB';
      case 'Petabytes':
        return 'PB';
      case 'Bits':
        return 'b';
      case 'Kibibits':
        return 'Kib';
      case 'Mebibits':
        return 'Mib';
      case 'Gigibits':
        return 'Gib';
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
      'Bytes',
      'Kibibytes',
      'Mebibytes',
      'Gigibytes',
      'Tebibytes',
      'Pebibytes',
      'Kilobytes',
      'Megabytes',
      'Gigabytes',
      'Terabytes',
      'Petabytes',
      'Bits',
      'Kibibits',
      'Mebibits',
      'Gigibits',
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
