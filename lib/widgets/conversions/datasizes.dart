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

class DatasUnitConverter extends StatefulWidget {
  const DatasUnitConverter({super.key});

  @override
  _DatasUnitConverterState createState() => _DatasUnitConverterState();
}

class _DatasUnitConverterState extends State<DatasUnitConverter> {
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
  String fromPrefix = 'B';
  String toPrefix = 'KiB';
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
          text: 'Check out my data size result!');
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
          case 'Tebibytes':
            toValue = fromValue * 1024.0;
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

  String _formatWithCommas(String integerPart) {
    // Use a buffer to build the formatted string for the integer part with commas.
    StringBuffer formattedInt = StringBuffer();
    int commaPosition = 3;
    int offset = integerPart.length % commaPosition;
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
          case 'Petabytes':
            formula = 'The value remains unchanged';
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
        backgroundColor:
            isDarkMode ? const Color(0xFF2C3A47) : const Color(0xFFA1CCD1),
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
                        context.navigateTo('/');
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 40,
                        color:
                            isDarkMode ? Colors.grey : const Color(0xFF2C3A47),
                      ),
                    ),
                    Expanded(
                      // This will take all available space, pushing the IconButton to the left and centering the text
                      child: Text(
                        'Convert Data Sizes',
                        textAlign: TextAlign
                            .center, // This centers the text within the available space
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.grey
                              : const Color(0xFF2C3A47),
                        ),
                      ),
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
                    'See result in exponential format',
                    style: TextStyle(
                        color:
                            isDarkMode ? Colors.grey : const Color(0xFF2C3A47),
                        fontSize: 18),
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
                  child: _buildUnitColumn(
                      'From', fromController, fromUnit, fromPrefix, true),
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
                      'To', toController, toUnit, toPrefix, false),
                ),
                const SizedBox(height: 30),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Formula:  ',
                        style: TextStyle(
                          color: isDarkMode ? Colors.orange : Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: _conversionFormula,
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey
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
                tooltip: 'Reset default settings',
                heroTag: 'resetButton',
                onPressed: _resetToDefault,
                backgroundColor: Colors.red,
                child: const Icon(Icons.restart_alt,
                    size: 36, color: Colors.white),
              ),
              FloatingActionButton(
                tooltip: 'Share a screenshot of your results!',
                heroTag: 'shareButton',
                onPressed: _takeScreenshotAndShare,
                backgroundColor:
                    isDarkMode ? Colors.white : const Color(0xFF3876BF),
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
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          '${_getPrefix(value)} - $value',
          style: TextStyle(
            color: isDarkMode ? const Color(0xFF9CC0C5) : Colors.black,
            fontSize: 23,
          ),
          overflow: TextOverflow.visible,
        ),
      );
    }).toList();

    items.insert(
      0,
      DropdownMenuItem<String>(
        value: '',
        enabled: false,
        child: Text(
          'Choose a conversion unit',
          style: TextStyle(
              color: isDarkMode ? const Color(0xFF9CC0C5) : Colors.black,
              fontSize: 23),
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
            isDarkMode ? const Color(0xFF303134) : const Color(0xFFADC4CE),
      ),
      value: currentValue.isNotEmpty ? currentValue : null,
      hint: Text(
        'Choose a conversion unit',
        style: TextStyle(
            color: isDarkMode ? Colors.grey : const Color(0xFF374259),
            fontSize: 23),
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
          isDarkMode ? const Color(0xFF303134) : const Color(0xFFADC4CE),
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
                fontSize: 23,
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
