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

class AreaUnitConverter extends StatefulWidget {
  const AreaUnitConverter({super.key});

  @override
  _AreaUnitConverterState createState() => _AreaUnitConverterState();
}

class _AreaUnitConverterState extends State<AreaUnitConverter> {
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 17.0;
  static const double largeFontSize = 20.0;
  Locale _selectedLocale = const Locale('en', 'US');
  double fontSize = mediumFontSize;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Square Metres';
  String toUnit = 'Square Kilometres';
  // Removed duplicate declarations of TextEditingController
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  bool _isExponentialFormat = false;
  // Flag to indicate if the change is due to user input
  bool _isUserInput = true;
  // Using string variables for prefixes
  String fromPrefix = 'm²';
  String toPrefix = 'km²';
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
          text: 'Check out my area result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here
// Conversion constants for Square Metres to other units
    const double squareMeterToSquareMillimeter = 1e6;
    const double squareMeterToSquareCentimeter = 1e4;
    const double squareMeterToAre = 0.01;
    const double squareMeterToHectare = 0.0001;
    const double squareMeterToSquareKilometer = 1e-6;
    const double squareMeterToSquareInch = 1550.0031;
    const double squareMeterToSquareFoot = 10.7639104;
    const double squareMeterToSquareYard = 1.19599005;
    const double squareMeterToAcre = 0.000247105;
    const double squareMeterToSquareMile = 3.86102159e-7;

// Conversion constants for Square Millimetres to other units
    const double squareMillimeterToSquareMeter = 1e-6;
    const double squareMillimeterToSquareCentimeter = 0.01;
    const double squareMillimeterToAre = 1e-8;
    const double squareMillimeterToHectare = 1e-10;
    const double squareMillimeterToSquareKilometer = 1e-12;
    const double squareMillimeterToSquareInch = 0.0015500031;
    const double squareMillimeterToSquareFoot = 1.07639104e-5;
    const double squareMillimeterToSquareYard = 1.19599005e-6;
    const double squareMillimeterToAcre = 2.47105381e-10;
    const double squareMillimeterToSquareMile = 3.86102159e-13;

// Conversion constants for Square Centimetres to other units
    const double squareCentimeterToSquareMeter = 0.0001;
    const double squareCentimeterToSquareMillimeter = 100;
    const double squareCentimeterToAre = 1e-6;
    const double squareCentimeterToHectare = 1e-8;
    const double squareCentimeterToSquareKilometer = 1e-10;
    const double squareCentimeterToSquareInch = 0.15500031;
    const double squareCentimeterToSquareFoot = 0.00107639104;
    const double squareCentimeterToSquareYard = 0.000119599005;
    const double squareCentimeterToAcre = 2.47105381e-8;
    const double squareCentimeterToSquareMile = 3.86102159e-11;

// Conversion constants for Ares to other units
    const double areToSquareMeter = 100;
    const double areToSquareMillimeter = 1e8;
    const double areToSquareCentimeter = 1e6;
    const double areToHectare = 0.01;
    const double areToSquareKilometer = 1e-4;
    const double areToSquareInch = 155000.31;
    const double areToSquareFoot = 1076.39104;
    const double areToSquareYard = 119.599005;
    const double areToAcre = 0.0247105381;
    const double areToSquareMile = 3.86102159e-5;

// Conversion constants for Hectares to other units
    const double hectareToSquareMeter = 10000;
    const double hectareToSquareMillimeter = 1e10;
    const double hectareToSquareCentimeter = 1e8;
    const double hectareToAre = 100;
    const double hectareToSquareKilometer = 0.01;
    const double hectareToSquareInch = 15500031;
    const double hectareToSquareFoot = 107639.104;
    const double hectareToSquareYard = 11959.9005;
    const double hectareToAcre = 2.47105381;
    const double hectareToSquareMile = 0.00386102159;

// Conversion constants for Square Kilometres to other units
    const double squareKilometerToSquareMeter = 1e6;
    const double squareKilometerToSquareMillimeter = 1e12;
    const double squareKilometerToSquareCentimeter = 1e10;
    const double squareKilometerToAre = 10000;
    const double squareKilometerToHectare = 100;
    const double squareKilometerToSquareInch = 1.55e9;
    const double squareKilometerToSquareFoot = 1.076e7;
    const double squareKilometerToSquareYard = 1.196e6;
    const double squareKilometerToAcre = 247.105381;
    const double squareKilometerToSquareMile = 0.386102159;

// Conversion constants for Square Inches to other units
    const double squareInchToSquareMeter = 0.00064516;
    const double squareInchToSquareMillimeter = 645.16;
    const double squareInchToSquareCentimeter = 6.4516;
    const double squareInchToAre = 6.4516e-6;
    const double squareInchToHectare = 6.4516e-8;
    const double squareInchToSquareKilometer = 6.4516e-10;
    const double squareInchToSquareFoot = 0.00694444;
    const double squareInchToSquareYard = 0.000771605;
    const double squareInchToAcre = 1.59422508e-7;
    const double squareInchToSquareMile = 2.49097669e-10;

// Conversion constants for Square Feet to other units
    const double squareFootToSquareMeter = 0.09290304;
    const double squareFootToSquareMillimeter = 92903.04;
    const double squareFootToSquareCentimeter = 929.0304;
    const double squareFootToAre = 0.0009290304;
    const double squareFootToHectare = 9.290304e-6;
    const double squareFootToSquareKilometer = 9.290304e-8;
    const double squareFootToSquareInch = 144;
    const double squareFootToSquareYard = 0.111111111;
    const double squareFootToAcre = 2.29568411e-5;
    const double squareFootToSquareMile = 3.58700642791549e-8;

// Conversion constants for Square Yards to other units
    const double squareYardToSquareMeter = 0.83612736;
    const double squareYardToSquareMillimeter = 836127.36;
    const double squareYardToSquareCentimeter = 8361.2736;
    const double squareYardToAre = 0.0083612736;
    const double squareYardToHectare = 8.3612736e-5;
    const double squareYardToSquareKilometer = 8.3612736e-7;
    const double squareYardToSquareInch = 1296;
    const double squareYardToSquareFoot = 9;
    const double squareYardToAcre = 0.00020661157;
    const double squareYardToSquareMile = 3.228305785e-7;

// Conversion constants for Acres to other units
    const double acreToSquareMeter = 4046.8564224;
    const double acreToSquareMillimeter = 4.0468564224e9;
    const double acreToSquareCentimeter = 4.0468564224e7;
    const double acreToAre = 40.468564224;
    const double acreToHectare = 0.40468564224;
    const double acreToSquareKilometer = 0.0040468564224;
    const double acreToSquareInch = 6.273e6;
    const double acreToSquareFoot = 43560;
    const double acreToSquareYard = 4840;
    const double acreToSquareMile = 0.0015625;

// Conversion constants for Square Miles to other units
    const double squareMileToSquareMeter = 2.589988110336e6;
    const double squareMileToSquareMillimeter = 2.589988110336e12;
    const double squareMileToSquareCentimeter = 2.589988110336e10;
    const double squareMileToAre = 25899.88110336;
    const double squareMileToHectare = 258.9988110336;
    const double squareMileToSquareKilometer = 2.589988110336;
    const double squareMileToSquareInch = 4.0144896e9;
    const double squareMileToSquareFoot = 2.788e7;
    const double squareMileToSquareYard = 3.098e6;
    const double squareMileToAcre = 640;

    switch (fromUnit) {
      // Square Metres UNIT CONVERSION
      // SQUARE METRES UNIT CONVERSION
      case 'Square Metres':
        switch (toUnit) {
          case 'Square Millimetres':
            toValue = fromValue * squareMeterToSquareMillimeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * squareMeterToSquareCentimeter;
            break;
          case 'Ares':
            toValue = fromValue * squareMeterToAre;
            break;
          case 'Hectares':
            toValue = fromValue * squareMeterToHectare;
            break;
          case 'Square Kilometres':
            toValue = fromValue * squareMeterToSquareKilometer;
            break;
          case 'Square Inches':
            toValue = fromValue * squareMeterToSquareInch;
            break;
          case 'Square Feet':
            toValue = fromValue * squareMeterToSquareFoot;
            break;
          case 'Square Yards':
            toValue = fromValue * squareMeterToSquareYard;
            break;
          case 'Acres':
            toValue = fromValue * squareMeterToAcre;
            break;
          case 'Square Miles':
            toValue = fromValue * squareMeterToSquareMile;
            break;
          case 'Square Metres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
// SQUARE MILLIMETRES UNIT CONVERSION
      case 'Square Millimetres':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * squareMillimeterToSquareMeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * squareMillimeterToSquareCentimeter;
            break;
          case 'Ares':
            toValue = fromValue * squareMillimeterToAre;
            break;
          case 'Hectares':
            toValue = fromValue * squareMillimeterToHectare;
            break;
          case 'Square Kilometres':
            toValue = fromValue * squareMillimeterToSquareKilometer;
            break;
          case 'Square Inches':
            toValue = fromValue * squareMillimeterToSquareInch;
            break;
          case 'Square Feet':
            toValue = fromValue * squareMillimeterToSquareFoot;
            break;
          case 'Square Yards':
            toValue = fromValue * squareMillimeterToSquareYard;
            break;
          case 'Acres':
            toValue = fromValue * squareMillimeterToAcre;
            break;
          case 'Square Miles':
            toValue = fromValue * squareMillimeterToSquareMile;
            break;
          case 'Square Millimetres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// SQUARE CENTIMETRES UNIT CONVERSION
      case 'Square Centimetres':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * squareCentimeterToSquareMeter;
            break;
          case 'Square Millimetres':
            toValue = fromValue * squareCentimeterToSquareMillimeter;
            break;
          case 'Ares':
            toValue = fromValue * squareCentimeterToAre;
            break;
          case 'Hectares':
            toValue = fromValue * squareCentimeterToHectare;
            break;
          case 'Square Kilometres':
            toValue = fromValue * squareCentimeterToSquareKilometer;
            break;
          case 'Square Inches':
            toValue = fromValue * squareCentimeterToSquareInch;
            break;
          case 'Square Feet':
            toValue = fromValue * squareCentimeterToSquareFoot;
            break;
          case 'Square Yards':
            toValue = fromValue * squareCentimeterToSquareYard;
            break;
          case 'Acres':
            toValue = fromValue * squareCentimeterToAcre;
            break;
          case 'Square Miles':
            toValue = fromValue * squareCentimeterToSquareMile;
            break;
          case 'Square Centimetres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
// ARES UNIT CONVERSION
      case 'Ares':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * areToSquareMeter;
            break;
          case 'Square Millimetres':
            toValue = fromValue * areToSquareMillimeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * areToSquareCentimeter;
            break;
          case 'Hectares':
            toValue = fromValue * areToHectare;
            break;
          case 'Square Kilometres':
            toValue = fromValue * areToSquareKilometer;
            break;
          case 'Square Inches':
            toValue = fromValue * areToSquareInch;
            break;
          case 'Square Feet':
            toValue = fromValue * areToSquareFoot;
            break;
          case 'Square Yards':
            toValue = fromValue * areToSquareYard;
            break;
          case 'Acres':
            toValue = fromValue * areToAcre;
            break;
          case 'Square Miles':
            toValue = fromValue * areToSquareMile;
            break;
          case 'Ares': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// HECTARES UNIT CONVERSION
      case 'Hectares':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * hectareToSquareMeter;
            break;
          case 'Square Millimetres':
            toValue = fromValue * hectareToSquareMillimeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * hectareToSquareCentimeter;
            break;
          case 'Ares':
            toValue = fromValue * hectareToAre;
            break;
          case 'Square Kilometres':
            toValue = fromValue * hectareToSquareKilometer;
            break;
          case 'Square Inches':
            toValue = fromValue * hectareToSquareInch;
            break;
          case 'Square Feet':
            toValue = fromValue * hectareToSquareFoot;
            break;
          case 'Square Yards':
            toValue = fromValue * hectareToSquareYard;
            break;
          case 'Acres':
            toValue = fromValue * hectareToAcre;
            break;
          case 'Square Miles':
            toValue = fromValue * hectareToSquareMile;
            break;
          case 'Hectares': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// SQUARE KILOMETRES UNIT CONVERSION
      case 'Square Kilometres':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * squareKilometerToSquareMeter;
            break;
          case 'Square Millimetres':
            toValue = fromValue * squareKilometerToSquareMillimeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * squareKilometerToSquareCentimeter;
            break;
          case 'Ares':
            toValue = fromValue * squareKilometerToAre;
            break;
          case 'Hectares':
            toValue = fromValue * squareKilometerToHectare;
            break;
          case 'Square Inches':
            toValue = fromValue * squareKilometerToSquareInch;
            break;
          case 'Square Feet':
            toValue = fromValue * squareKilometerToSquareFoot;
            break;
          case 'Square Yards':
            toValue = fromValue * squareKilometerToSquareYard;
            break;
          case 'Acres':
            toValue = fromValue * squareKilometerToAcre;
            break;
          case 'Square Miles':
            toValue = fromValue * squareKilometerToSquareMile;
            break;
          case 'Square Kilometres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// SQUARE INCHES UNIT CONVERSION
      case 'Square Inches':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * squareInchToSquareMeter;
            break;
          case 'Square Millimetres':
            toValue = fromValue * squareInchToSquareMillimeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * squareInchToSquareCentimeter;
            break;
          case 'Ares':
            toValue = fromValue * squareInchToAre;
            break;
          case 'Hectares':
            toValue = fromValue * squareInchToHectare;
            break;
          case 'Square Kilometres':
            toValue = fromValue * squareInchToSquareKilometer;
            break;
          case 'Square Feet':
            toValue = fromValue * squareInchToSquareFoot;
            break;
          case 'Square Yards':
            toValue = fromValue * squareInchToSquareYard;
            break;
          case 'Acres':
            toValue = fromValue * squareInchToAcre;
            break;
          case 'Square Miles':
            toValue = fromValue * squareInchToSquareMile;
            break;
          case 'Square Inches': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// SQUARE FEET UNIT CONVERSION
      case 'Square Feet':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * squareFootToSquareMeter;
            break;
          case 'Square Millimetres':
            toValue = fromValue * squareFootToSquareMillimeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * squareFootToSquareCentimeter;
            break;
          case 'Ares':
            toValue = fromValue * squareFootToAre;
            break;
          case 'Hectares':
            toValue = fromValue * squareFootToHectare;
            break;
          case 'Square Kilometres':
            toValue = fromValue * squareFootToSquareKilometer;
            break;
          case 'Square Inches':
            toValue = fromValue * squareFootToSquareInch;
            break;
          case 'Square Yards':
            toValue = fromValue * squareFootToSquareYard;
            break;
          case 'Acres':
            toValue = fromValue * squareFootToAcre;
            break;
          case 'Square Miles':
            toValue = fromValue * squareFootToSquareMile;
            break;
          case 'Square Feet': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// SQUARE YARDS UNIT CONVERSION
      case 'Square Yards':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * squareYardToSquareMeter;
            break;
          case 'Square Millimetres':
            toValue = fromValue * squareYardToSquareMillimeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * squareYardToSquareCentimeter;
            break;
          case 'Ares':
            toValue = fromValue * squareYardToAre;
            break;
          case 'Hectares':
            toValue = fromValue * squareYardToHectare;
            break;
          case 'Square Kilometres':
            toValue = fromValue * squareYardToSquareKilometer;
            break;
          case 'Square Inches':
            toValue = fromValue * squareYardToSquareInch;
            break;
          case 'Square Feet':
            toValue = fromValue * squareYardToSquareFoot;
            break;
          case 'Acres':
            toValue = fromValue * squareYardToAcre;
            break;
          case 'Square Miles':
            toValue = fromValue * squareYardToSquareMile;
            break;
          case 'Square Yards': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
// ACRES UNIT CONVERSION
      case 'Acres':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * acreToSquareMeter;
            break;
          case 'Square Millimetres':
            toValue = fromValue * acreToSquareMillimeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * acreToSquareCentimeter;
            break;
          case 'Ares':
            toValue = fromValue * acreToAre;
            break;
          case 'Hectares':
            toValue = fromValue * acreToHectare;
            break;
          case 'Square Kilometres':
            toValue = fromValue * acreToSquareKilometer;
            break;
          case 'Square Inches':
            toValue = fromValue * acreToSquareInch;
            break;
          case 'Square Feet':
            toValue = fromValue * acreToSquareFoot;
            break;
          case 'Square Yards':
            toValue = fromValue * acreToSquareYard;
            break;
          case 'Square Miles':
            toValue = fromValue * acreToSquareMile;
            break;
          case 'Acres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// SQUARE MILES UNIT CONVERSION
      case 'Square Miles':
        switch (toUnit) {
          case 'Square Metres':
            toValue = fromValue * squareMileToSquareMeter;
            break;
          case 'Square Millimetres':
            toValue = fromValue * squareMileToSquareMillimeter;
            break;
          case 'Square Centimetres':
            toValue = fromValue * squareMileToSquareCentimeter;
            break;
          case 'Ares':
            toValue = fromValue * squareMileToAre;
            break;
          case 'Hectares':
            toValue = fromValue * squareMileToHectare;
            break;
          case 'Square Kilometres':
            toValue = fromValue * squareMileToSquareKilometer;
            break;
          case 'Square Inches':
            toValue = fromValue * squareMileToSquareInch;
            break;
          case 'Square Feet':
            toValue = fromValue * squareMileToSquareFoot;
            break;
          case 'Square Yards':
            toValue = fromValue * squareMileToSquareYard;
            break;
          case 'Acres':
            toValue = fromValue * squareMileToAcre;
            break;
          case 'Square Miles': // No conversion needed if from and to units are the same
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
      case 'Square Metres':
        switch (toUnit) {
          case 'Square Millimetres':
            formula = 'Multiply the area value by 1,000,000';
            break;
          case 'Square Centimetres':
            formula = 'Multiply the area value by 10,000';
            break;
          case 'Ares':
            formula = 'Divide the area value by 100';
            break;
          case 'Hectares':
            formula = 'Divide the area value by 10,000';
            break;
          case 'Square Kilometres':
            formula = 'Divide the area value by 1,000,000';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 1,550.0031';
            break;
          case 'Square Feet':
            formula = 'Multiply the area value by 10.7639104';
            break;
          case 'Square Yards':
            formula = 'Multiply the area value by 1.19599005';
            break;
          case 'Acres':
            formula = 'Divide the area value by 4,046.85642';
            break;
          case 'Square Miles':
            formula = 'Divide the area value by 2,589,988.11';
            break;
          case 'Square Metres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Square Millimetres':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Divide the area value by 1,000,000';
            break;
          case 'Square Centimetres':
            formula = 'Divide the area value by 100';
            break;
          case 'Ares':
            formula = 'Divide the area value by 100,000,000';
            break;
          case 'Hectares':
            formula = 'Divide the area value by 10,000,000,000';
            break;
          case 'Square Kilometres':
            formula = 'Divide the area value by 1,000,000,000,000';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 0.00155';
            break;
          case 'Square Feet':
            formula = 'Divide the area value by 92,903';
            break;
          case 'Square Yards':
            formula = 'Divide the area value by 836,127';
            break;
          case 'Acres':
            formula = 'Divide the area value by 4,046,856,422';
            break;
          case 'Square Miles':
            formula = 'Divide the area value by 2,589,988,110,000';
            break;
          case 'Square Millimetres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Square Centimetres':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Divide the area value by 10,000';
            break;
          case 'Square Millimetres':
            formula = 'Multiply the area value by 100';
            break;
          case 'Ares':
            formula = 'Divide the area value by 1,000,000';
            break;
          case 'Hectares':
            formula = 'Divide the area value by 100,000,000';
            break;
          case 'Square Kilometres':
            formula = 'Divide the area value by 10,000,000,000';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 0.155';
            break;
          case 'Square Feet':
            formula = 'Divide the area value by 929.03';
            break;
          case 'Square Yards':
            formula = 'Divide the area value by 8,361.27';
            break;
          case 'Acres':
            formula = 'Divide the area value by 40,468,564.224';
            break;
          case 'Square Miles':
            formula = 'Divide the area value by 25,899,881,103.36';
            break;
          case 'Square Centimetres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Ares':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Multiply the area value by 100';
            break;
          case 'Square Millimetres':
            formula = 'Multiply the area value by 100,000,000';
            break;
          case 'Square Centimetres':
            formula = 'Multiply the area value by 1,000,000';
            break;
          case 'Hectares':
            formula = 'Divide the area value by 100';
            break;
          case 'Square Kilometres':
            formula = 'Divide the area value by 10,000';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 15,500.031';
            break;
          case 'Square Feet':
            formula = 'Multiply the area value by 1,076.39104';
            break;
          case 'Square Yards':
            formula = 'Multiply the area value by 119.599005';
            break;
          case 'Acres':
            formula = 'Divide the area value by 40.468564224';
            break;
          case 'Square Miles':
            formula = 'Divide the area value by 2,589.98811';
            break;
          case 'Ares': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Hectares':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Multiply the area value by 10,000';
            break;
          case 'Square Millimetres':
            formula = 'Multiply the area value by 10,000,000,000';
            break;
          case 'Square Centimetres':
            formula = 'Multiply the area value by 100,000,000';
            break;
          case 'Ares':
            formula = 'Multiply the area value by 100';
            break;
          case 'Square Kilometres':
            formula = 'Divide the area value by 100';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 15,500,003.1';
            break;
          case 'Square Feet':
            formula = 'Multiply the area value by 107,639.104';
            break;
          case 'Square Yards':
            formula = 'Multiply the area value by 11,959.9005';
            break;
          case 'Acres':
            formula = 'Multiply the area value by 2.47105381';
            break;
          case 'Square Miles':
            formula = 'Divide the area value by 258.9988110336';
            break;
          case 'Hectares': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Square Kilometres':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Multiply the area value by 1,000,000';
            break;
          case 'Square Millimetres':
            formula = 'Multiply the area value by 1,000,000,000,000';
            break;
          case 'Square Centimetres':
            formula = 'Multiply the area value by 10,000,000,000';
            break;
          case 'Ares':
            formula = 'Multiply the area value by 100,000';
            break;
          case 'Hectares':
            formula = 'Multiply the area value by 100';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 1,550,003,100';
            break;
          case 'Square Feet':
            formula = 'Multiply the area value by 10,763,910.4';
            break;
          case 'Square Yards':
            formula = 'Multiply the area value by 1,195,990.05';
            break;
          case 'Acres':
            formula = 'Multiply the area value by 247.105381';
            break;
          case 'Square Miles':
            formula = 'Multiply the area value by 0.386102159';
            break;
          case 'Square Kilometres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Square Inches':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Divide the area value by 1,550.0031';
            break;
          case 'Square Millimetres':
            formula = 'Multiply the area value by 645.16';
            break;
          case 'Square Centimetres':
            formula = 'Multiply the area value by 6.4516';
            break;
          case 'Ares':
            formula = 'Divide the area value by 155,000.31';
            break;
          case 'Hectares':
            formula = 'Divide the area value by 15,500,003.1';
            break;
          case 'Square Kilometres':
            formula = 'Divide the area value by 1,550,003,100';
            break;
          case 'Square Feet':
            formula = 'Divide the area value by 144';
            break;
          case 'Square Yards':
            formula = 'Divide the area value by 1,296';
            break;
          case 'Acres':
            formula = 'Divide the area value by 6,272,640';
            break;
          case 'Square Miles':
            formula = 'Divide the area value by 4,014,489,600';
            break;
          case 'Square Inches': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Square Feet':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Multiply the area value by 0.092903';
            break;
          case 'Square Millimetres':
            formula = 'Multiply the area value by 92,903';
            break;
          case 'Square Centimetres':
            formula = 'Multiply the area value by 929.0304';
            break;
          case 'Ares':
            formula = 'Multiply the area value by 0.0009290304';
            break;
          case 'Hectares':
            formula = 'Multiply the area value by 0.000009290304';
            break;
          case 'Square Kilometres':
            formula = 'Multiply the area value by 0.00000009290304';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 144';
            break;
          case 'Square Yards':
            formula = 'Multiply the area value by 0.111111';
            break;
          case 'Acres':
            formula = 'Multiply the area value by 0.000022957';
            break;
          case 'Square Miles':
            formula = 'Multiply the area value by 0.000000035870';
            break;
          case 'Square Feet': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Square Yards':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Multiply the area value by 0.836127';
            break;
          case 'Square Millimetres':
            formula = 'Multiply the area value by 836,127';
            break;
          case 'Square Centimetres':
            formula = 'Multiply the area value by 8,361.27';
            break;
          case 'Ares':
            formula = 'Multiply the area value by 0.0083612736';
            break;
          case 'Hectares':
            formula = 'Multiply the area value by 0.000083612736';
            break;
          case 'Square Kilometres':
            formula = 'Multiply the area value by 0.00000083612736';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 1,296';
            break;
          case 'Square Feet':
            formula = 'Multiply the area value by 9';
            break;
          case 'Acres':
            formula = 'Multiply the area value by 0.000206612';
            break;
          case 'Square Miles':
            formula = 'Multiply the area value by 0.000000322831';
            break;
          case 'Square Yards': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Acres':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Multiply the area value by 4,046.86';
            break;
          case 'Square Millimetres':
            formula = 'Multiply the area value by 4,046,856,422';
            break;
          case 'Square Centimetres':
            formula = 'Multiply the area value by 40,468,564.224';
            break;
          case 'Ares':
            formula = 'Multiply the area value by 40.4686';
            break;
          case 'Hectares':
            formula = 'Multiply the area value by 0.404686';
            break;
          case 'Square Kilometres':
            formula = 'Multiply the area value by 0.00404686';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 6,272,640';
            break;
          case 'Square Feet':
            formula = 'Multiply the area value by 43,560';
            break;
          case 'Square Yards':
            formula = 'Multiply the area value by 4,840';
            break;
          case 'Square Miles':
            formula = 'Multiply the area value by 0.0015625';
            break;
          case 'Acres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Square Miles':
        switch (toUnit) {
          case 'Square Metres':
            formula = 'Multiply the area value by 2,589,988.11';
            break;
          case 'Square Millimetres':
            formula = 'Multiply the area value by 2,589,988,110,000';
            break;
          case 'Square Centimetres':
            formula = 'Multiply the area value by 25,899,881,103.36';
            break;
          case 'Ares':
            formula = 'Multiply the area value by 258,998.811';
            break;
          case 'Hectares':
            formula = 'Multiply the area value by 25,899.8811';
            break;
          case 'Square Kilometres':
            formula = 'Multiply the area value by 2.58998811';
            break;
          case 'Square Inches':
            formula = 'Multiply the area value by 4,014,489,600';
            break;
          case 'Square Feet':
            formula = 'Multiply the area value by 27,878,400';
            break;
          case 'Square Yards':
            formula = 'Multiply the area value by 3,097,600';
            break;
          case 'Acres':
            formula = 'Multiply the area value by 640';
            break;
          case 'Square Miles': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
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
                        'Convert Area',
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
      case 'Square Metres':
        return 'm²';
      case 'Square Millimetres':
        return 'mm²';
      case 'Square Centimetres':
        return 'cm²';
      case 'Ares':
        return 'a'; // Area equivalent to 100 square metres
      case 'Hectares':
        return 'ha'; // Area equivalent to 10,000 square metres
      case 'Square Kilometres':
        return 'km²';
      case 'Square Inches':
        return 'in²';
      case 'Square Feet':
        return 'ft²';
      case 'Square Yards':
        return 'yd²';
      case 'Acres':
        return 'ac'; // Area equivalent to 4,046.86 square metres
      case 'Square Miles':
        return 'mi²';
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

  // Correct the method signature by adding the isFrom parameter
  Widget _buildDropdownButton(String type, String currentValue, bool isFrom) {
    List<DropdownMenuItem<String>> items = <String>[
      'Square Metres',
      'Square Millimetres',
      'Square Centimetres',
      'Ares',
      'Hectares',
      'Square Kilometres',
      'Square Inches',
      'Square Feet',
      'Square Yards',
      'Acres',
      'Square Miles',
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
