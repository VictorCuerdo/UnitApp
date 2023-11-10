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

class PressureUnitConverter extends StatefulWidget {
  const PressureUnitConverter({super.key});

  @override
  _PressureUnitConverterState createState() => _PressureUnitConverterState();
}

class _PressureUnitConverterState extends State<PressureUnitConverter> {
  String fromUnit = 'Micropascals';
  String toUnit = 'Millipascals';
  // Removed duplicate declarations of TextEditingController
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  bool _isExponentialFormat = false;
  // Flag to indicate if the change is due to user input
  bool _isUserInput = true;
  // Using string variables for prefixes
  String fromPrefix = 'μPa';
  String toPrefix = 'mPa';
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
          text: 'Check out my pressure result!');
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here
// Base unit for pressure is Pascal (Pa)
    const double pascalToMicropascal = 1e6;
    const double pascalToMillipascal = 1e3;
// Pascals to itself is 1 (omitted because it's trivial)
    const double pascalToHectopascal = 1e-2;
    const double pascalToKilopascal = 1e-3;
    const double pascalToMegapascal = 1e-6;
    const double pascalToGigapascal = 1e-9;
    const double pascalToPascal = 1.0;
// Standard atmosphere is 101325 Pa
    const double pascalToAtmospheres = 1 / 101325.0;

// Bar is 100000 Pa
    const double pascalToMicrobar = 1e1;
    const double pascalToMillibar = 1e-2;
    const double pascalToBar = 1e-5;

// Torr is (101325 / 760) Pa
    const double pascalToMillitorr = 760 / 101325.0 * 1e3;
    const double pascalToTorr = 760 / 101325.0;

// Technical atmosphere is 98066.5 Pa
    const double pascalToTechnicalAtmosphere = 1 / 98066.5;

// Kilogram-force per square centimeter is 98066.5 Pa
    const double pascalToKilogramForcePerSquareCentimeter = 1 / 98066.5;

// Kilogram-force per square meter is 9.80665 Pa
    const double pascalToKilogramForcePerSquareMeter = 1 / 9.80665;

// Kiloponds per square centimeter is the same as kilogram-force per square centimeter
// Kiloponds per square meter is the same as kilogram-force per square meter

// Pound per square inch is 6894.75729 Pa
    const double pascalToPoundsPerSquareInch = 1 / 6894.75729;

// Kilopound per square inch is 6894757.29 Pa
    const double pascalToKilopoundsPerSquareInch = 1 / 6894757.29;

// Megapound per square inch is 6894757290 Pa
    const double pascalToMegapoundsPerSquareInch = 1 / 6894757290.0;

// Pound per square foot is 47.88025898 Pa
    const double pascalToPoundsPerSquareFoot = 1 / 47.88025898;

// Kilopound per square foot is 47880.25898 Pa
    const double pascalToKilopoundsPerSquareFoot = 1 / 47880.25898;

// Megapound per square foot is 47880258980 Pa
    const double pascalToMegapoundsPerSquareFoot = 1 / 47880258980.0;

// Millimeters of mercury (0°C) is 133.3223684 Pa
    const double pascalToMillimetersOfMercury = 1 / 133.3223684;

// Inches of mercury (0°C) is 3386.38815789 Pa
    const double pascalToInchesOfMercury = 1 / 3386.38815789;

// Millimeters of water column is 9.80665 Pa
    const double pascalToMillimetersOfWaterColumn = 1 / 9.80665;

// Inches of water column is 249.088908333 Pa
    const double pascalToInchesOfWaterColumn = 1 / 249.088908333;

    switch (fromUnit) {
      // MICROPASCALS UNIT CONVERSION
      case 'Micropascals':
        switch (toUnit) {
          case 'Millipascals':
            toValue = fromValue / pascalToMillipascal;
            break;
          case 'Pascals':
            toValue = fromValue / pascalToMicropascal;
            break;
          case 'Hectopascals':
            toValue = fromValue / (pascalToMicropascal * pascalToHectopascal);
            break;
          case 'Kilopascals':
            toValue = fromValue / (pascalToMicropascal * pascalToKilopascal);
            break;
          case 'Megapascals':
            toValue = fromValue / (pascalToMicropascal * pascalToMegapascal);
            break;
          case 'Gigapascals':
            toValue = fromValue / (pascalToMicropascal * pascalToGigapascal);
            break;
          case 'Atmospheres':
            toValue = fromValue * pascalToAtmospheres / pascalToMicropascal;
            break;
          case 'Microbars':
            toValue = fromValue / (pascalToMicropascal / pascalToMicrobar);
            break;
          case 'Millibars':
            toValue = fromValue / (pascalToMicropascal / pascalToMillibar);
            break;
          case 'Bars':
            toValue = fromValue / (pascalToMicropascal / pascalToBar);
            break;
          case 'Millitorrs':
            toValue = fromValue * pascalToMillitorr / pascalToMicropascal;
            break;
          case 'Torrs':
            toValue = fromValue * pascalToTorr / pascalToMicropascal;
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue * pascalToTechnicalAtmosphere / pascalToMicropascal;
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMicropascal;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMicropascal;
            break;
          case 'Pounds per Square Inch':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToMicropascal;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                pascalToKilopoundsPerSquareInch /
                pascalToMicropascal;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                pascalToMegapoundsPerSquareInch /
                pascalToMicropascal;
            break;
          case 'Pounds per Square Foot':
            toValue =
                fromValue * pascalToPoundsPerSquareFoot / pascalToMicropascal;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                pascalToKilopoundsPerSquareFoot /
                pascalToMicropascal;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                pascalToMegapoundsPerSquareFoot /
                pascalToMicropascal;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue =
                fromValue * pascalToMillimetersOfMercury / pascalToMicropascal;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * pascalToInchesOfMercury / pascalToMicropascal;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                pascalToMillimetersOfWaterColumn /
                pascalToMicropascal;
            break;
          case 'Inches of water column':
            toValue =
                fromValue * pascalToInchesOfWaterColumn / pascalToMicropascal;
            break;
          case 'Micropascals': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // MILLIPASCALS UNIT CONVERSION
      case 'Millipascals':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * pascalToMicropascal / pascalToMillipascal;
            break;
          case 'Pascals':
            toValue = fromValue / pascalToMillipascal;
            break;
          case 'Hectopascals':
            toValue = fromValue / (pascalToMillipascal * pascalToHectopascal);
            break;
          case 'Kilopascals':
            toValue = fromValue / (pascalToMillipascal * pascalToKilopascal);
            break;
          case 'Megapascals':
            toValue = fromValue / (pascalToMillipascal * pascalToMegapascal);
            break;
          case 'Gigapascals':
            toValue = fromValue / (pascalToMillipascal * pascalToGigapascal);
            break;
          case 'Atmospheres':
            toValue = fromValue * pascalToAtmospheres / pascalToMillipascal;
            break;
          case 'Microbars':
            toValue = fromValue * pascalToMicrobar / pascalToMillipascal;
            break;
          case 'Millibars':
            toValue = fromValue * pascalToMillibar / pascalToMillipascal;
            break;
          case 'Bars':
            toValue = fromValue * pascalToBar / pascalToMillipascal;
            break;
          case 'Millitorrs':
            toValue = fromValue * pascalToMillitorr / pascalToMillipascal;
            break;
          case 'Torrs':
            toValue = fromValue * pascalToTorr / pascalToMillipascal;
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue * pascalToTechnicalAtmosphere / pascalToMillipascal;
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMillipascal;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMillipascal;
            break;
          case 'Pounds per Square Inch':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToMillipascal;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                pascalToKilopoundsPerSquareInch /
                pascalToMillipascal;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                pascalToMegapoundsPerSquareInch /
                pascalToMillipascal;
            break;
          case 'Pounds per Square Foot':
            toValue =
                fromValue * pascalToPoundsPerSquareFoot / pascalToMillipascal;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                pascalToKilopoundsPerSquareFoot /
                pascalToMillipascal;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                pascalToMegapoundsPerSquareFoot /
                pascalToMillipascal;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue =
                fromValue * pascalToMillimetersOfMercury / pascalToMillipascal;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * pascalToInchesOfMercury / pascalToMillipascal;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                pascalToMillimetersOfWaterColumn /
                pascalToMillipascal;
            break;
          case 'Inches of water column':
            toValue =
                fromValue * pascalToInchesOfWaterColumn / pascalToMillipascal;
            break;
          case 'Millipascals': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // PASCALS UNIT CONVERSION
      case 'Pascals':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * pascalToMicropascal;
            break;
          case 'Millipascals':
            toValue = fromValue * pascalToMillipascal;
            break;
          case 'Hectopascals':
            toValue = fromValue * pascalToHectopascal;
            break;
          case 'Kilopascals':
            toValue = fromValue * pascalToKilopascal;
            break;
          case 'Megapascals':
            toValue = fromValue * pascalToMegapascal;
            break;
          case 'Gigapascals':
            toValue = fromValue * pascalToGigapascal;
            break;
          case 'Atmospheres':
            toValue = fromValue * pascalToAtmospheres;
            break;
          case 'Microbars':
            toValue = fromValue * pascalToMicrobar;
            break;
          case 'Millibars':
            toValue = fromValue * pascalToMillibar;
            break;
          case 'Bars':
            toValue = fromValue * pascalToBar;
            break;
          case 'Millitorrs':
            toValue = fromValue * pascalToMillitorr;
            break;
          case 'Torrs':
            toValue = fromValue * pascalToTorr;
            break;
          case 'Technical Atmospheres':
            toValue = fromValue * pascalToTechnicalAtmosphere;
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue * pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue * pascalToKilogramForcePerSquareMeter;
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue * pascalToPoundsPerSquareInch;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue * pascalToKilopoundsPerSquareInch;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue * pascalToMegapoundsPerSquareInch;
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue * pascalToPoundsPerSquareFoot;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue * pascalToKilopoundsPerSquareFoot;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue * pascalToMegapoundsPerSquareFoot;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue * pascalToMillimetersOfMercury;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * pascalToInchesOfMercury;
            break;
          case 'Millimetres of water column':
            toValue = fromValue * pascalToMillimetersOfWaterColumn;
            break;
          case 'Inches of water column':
            toValue = fromValue * pascalToInchesOfWaterColumn;
            break;
          case 'Pascals': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // HECTOPASCALS UNIT CONVERSION
      case 'Hectopascals':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * pascalToMicropascal / pascalToHectopascal;
            break;
          case 'Millipascals':
            toValue = fromValue * pascalToMillipascal / pascalToHectopascal;
            break;
          case 'Pascals':
            toValue = fromValue / pascalToHectopascal;
            break;
          case 'Kilopascals':
            toValue = fromValue * pascalToKilopascal / pascalToHectopascal;
            break;
          case 'Megapascals':
            toValue = fromValue * pascalToMegapascal / pascalToHectopascal;
            break;
          case 'Gigapascals':
            toValue = fromValue * pascalToGigapascal / pascalToHectopascal;
            break;
          case 'Atmospheres':
            toValue = fromValue * pascalToAtmospheres / pascalToHectopascal;
            break;
          case 'Microbars':
            toValue = fromValue * pascalToMicrobar / pascalToHectopascal;
            break;
          case 'Millibars':
            toValue = fromValue * pascalToMillibar / pascalToHectopascal;
            break;
          case 'Bars':
            toValue = fromValue * pascalToBar / pascalToHectopascal;
            break;
          case 'Millitorrs':
            toValue = fromValue * pascalToMillitorr / pascalToHectopascal;
            break;
          case 'Torrs':
            toValue = fromValue * pascalToTorr / pascalToHectopascal;
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue * pascalToTechnicalAtmosphere / pascalToHectopascal;
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToHectopascal;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToHectopascal;
            break;
          case 'Pounds per Square Inch':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToHectopascal;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                pascalToKilopoundsPerSquareInch /
                pascalToHectopascal;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                pascalToMegapoundsPerSquareInch /
                pascalToHectopascal;
            break;
          case 'Pounds per Square Foot':
            toValue =
                fromValue * pascalToPoundsPerSquareFoot / pascalToHectopascal;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                pascalToKilopoundsPerSquareFoot /
                pascalToHectopascal;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                pascalToMegapoundsPerSquareFoot /
                pascalToHectopascal;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue =
                fromValue * pascalToMillimetersOfMercury / pascalToHectopascal;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * pascalToInchesOfMercury / pascalToHectopascal;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                pascalToMillimetersOfWaterColumn /
                pascalToHectopascal;
            break;
          case 'Inches of water column':
            toValue =
                fromValue * pascalToInchesOfWaterColumn / pascalToHectopascal;
            break;
          case 'Hectopascals': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // KILOPASCALS UNIT CONVERSION
      case 'Kilopascals':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * pascalToMicropascal / pascalToKilopascal;
            break;
          case 'Millipascals':
            toValue = fromValue * pascalToMillipascal / pascalToKilopascal;
            break;
          case 'Pascals':
            toValue = fromValue / pascalToKilopascal;
            break;
          case 'Hectopascals':
            toValue = fromValue * pascalToHectopascal / pascalToKilopascal;
            break;
          case 'Megapascals':
            toValue = fromValue * pascalToMegapascal / pascalToKilopascal;
            break;
          case 'Gigapascals':
            toValue = fromValue * pascalToGigapascal / pascalToKilopascal;
            break;
          case 'Atmospheres':
            toValue = fromValue * pascalToAtmospheres / pascalToKilopascal;
            break;
          case 'Microbars':
            toValue = fromValue * pascalToMicrobar / pascalToKilopascal;
            break;
          case 'Millibars':
            toValue = fromValue * pascalToMillibar / pascalToKilopascal;
            break;
          case 'Bars':
            toValue = fromValue * pascalToBar / pascalToKilopascal;
            break;
          case 'Millitorrs':
            toValue = fromValue * pascalToMillitorr / pascalToKilopascal;
            break;
          case 'Torrs':
            toValue = fromValue * pascalToTorr / pascalToKilopascal;
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue * pascalToTechnicalAtmosphere / pascalToKilopascal;
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToKilopascal;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToKilopascal;
            break;
          case 'Pounds per Square Inch':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToKilopascal;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                pascalToKilopoundsPerSquareInch /
                pascalToKilopascal;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                pascalToMegapoundsPerSquareInch /
                pascalToKilopascal;
            break;
          case 'Pounds per Square Foot':
            toValue =
                fromValue * pascalToPoundsPerSquareFoot / pascalToKilopascal;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                pascalToKilopoundsPerSquareFoot /
                pascalToKilopascal;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                pascalToMegapoundsPerSquareFoot /
                pascalToKilopascal;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue =
                fromValue * pascalToMillimetersOfMercury / pascalToKilopascal;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * pascalToInchesOfMercury / pascalToKilopascal;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                pascalToMillimetersOfWaterColumn /
                pascalToKilopascal;
            break;
          case 'Inches of water column':
            toValue =
                fromValue * pascalToInchesOfWaterColumn / pascalToKilopascal;
            break;
          case 'Kilopascals': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // MEGAPASCALS UNIT CONVERSION
      case 'Megapascals':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * pascalToMicropascal / pascalToMegapascal;
            break;
          case 'Millipascals':
            toValue = fromValue * pascalToMillipascal / pascalToMegapascal;
            break;
          case 'Pascals':
            toValue = fromValue / pascalToMegapascal;
            break;
          case 'Hectopascals':
            toValue = fromValue * pascalToHectopascal / pascalToMegapascal;
            break;
          case 'Kilopascals':
            toValue = fromValue * pascalToKilopascal / pascalToMegapascal;
            break;
          case 'Gigapascals':
            toValue = fromValue * pascalToGigapascal / pascalToMegapascal;
            break;
          case 'Atmospheres':
            toValue = fromValue * pascalToAtmospheres / pascalToMegapascal;
            break;
          case 'Microbars':
            toValue = fromValue * pascalToMicrobar / pascalToMegapascal;
            break;
          case 'Millibars':
            toValue = fromValue * pascalToMillibar / pascalToMegapascal;
            break;
          case 'Bars':
            toValue = fromValue * pascalToBar / pascalToMegapascal;
            break;
          case 'Millitorrs':
            toValue = fromValue * pascalToMillitorr / pascalToMegapascal;
            break;
          case 'Torrs':
            toValue = fromValue * pascalToTorr / pascalToMegapascal;
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue * pascalToTechnicalAtmosphere / pascalToMegapascal;
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMegapascal;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMegapascal;
            break;
          case 'Pounds per Square Inch':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToMegapascal;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                pascalToKilopoundsPerSquareInch /
                pascalToMegapascal;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                pascalToMegapoundsPerSquareInch /
                pascalToMegapascal;
            break;
          case 'Pounds per Square Foot':
            toValue =
                fromValue * pascalToPoundsPerSquareFoot / pascalToMegapascal;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                pascalToKilopoundsPerSquareFoot /
                pascalToMegapascal;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                pascalToMegapoundsPerSquareFoot /
                pascalToMegapascal;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue =
                fromValue * pascalToMillimetersOfMercury / pascalToMegapascal;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * pascalToInchesOfMercury / pascalToMegapascal;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                pascalToMillimetersOfWaterColumn /
                pascalToMegapascal;
            break;
          case 'Inches of water column':
            toValue =
                fromValue * pascalToInchesOfWaterColumn / pascalToMegapascal;
            break;
          case 'Megapascals': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // GIGAPASCALS UNIT CONVERSION
      case 'Gigapascals':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * pascalToMicropascal / pascalToGigapascal;
            break;
          case 'Millipascals':
            toValue = fromValue * pascalToMillipascal / pascalToGigapascal;
            break;
          case 'Pascals':
            toValue = fromValue / pascalToGigapascal;
            break;
          case 'Hectopascals':
            toValue = fromValue * pascalToHectopascal / pascalToGigapascal;
            break;
          case 'Kilopascals':
            toValue = fromValue * pascalToKilopascal / pascalToGigapascal;
            break;
          case 'Megapascals':
            toValue = fromValue * pascalToMegapascal / pascalToGigapascal;
            break;
          case 'Atmospheres':
            toValue = fromValue * pascalToAtmospheres / pascalToGigapascal;
            break;
          case 'Microbars':
            toValue = fromValue * pascalToMicrobar / pascalToGigapascal;
            break;
          case 'Millibars':
            toValue = fromValue * pascalToMillibar / pascalToGigapascal;
            break;
          case 'Bars':
            toValue = fromValue * pascalToBar / pascalToGigapascal;
            break;
          case 'Millitorrs':
            toValue = fromValue * pascalToMillitorr / pascalToGigapascal;
            break;
          case 'Torrs':
            toValue = fromValue * pascalToTorr / pascalToGigapascal;
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue * pascalToTechnicalAtmosphere / pascalToGigapascal;
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToGigapascal;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToGigapascal;
            break;
          case 'Pounds per Square Inch':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToGigapascal;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                pascalToKilopoundsPerSquareInch /
                pascalToGigapascal;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                pascalToMegapoundsPerSquareInch /
                pascalToGigapascal;
            break;
          case 'Pounds per Square Foot':
            toValue =
                fromValue * pascalToPoundsPerSquareFoot / pascalToGigapascal;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                pascalToKilopoundsPerSquareFoot /
                pascalToGigapascal;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                pascalToMegapoundsPerSquareFoot /
                pascalToGigapascal;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue =
                fromValue * pascalToMillimetersOfMercury / pascalToGigapascal;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * pascalToInchesOfMercury / pascalToGigapascal;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                pascalToMillimetersOfWaterColumn /
                pascalToGigapascal;
            break;
          case 'Inches of water column':
            toValue =
                fromValue * pascalToInchesOfWaterColumn / pascalToGigapascal;
            break;
          case 'Gigapascals': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // ATMOSPHERES UNIT CONVERSION
      case 'Atmospheres':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * pascalToMicropascal * 101325.0;
            break;
          case 'Millipascals':
            toValue = fromValue * pascalToMillipascal * 101325.0;
            break;
          case 'Pascals':
            toValue = fromValue * 101325.0;
            break;
          case 'Hectopascals':
            toValue = fromValue * pascalToHectopascal * 101325.0;
            break;
          case 'Kilopascals':
            toValue = fromValue * pascalToKilopascal * 101325.0;
            break;
          case 'Megapascals':
            toValue = fromValue * pascalToMegapascal * 101325.0;
            break;
          case 'Gigapascals':
            toValue = fromValue * pascalToGigapascal * 101325.0;
            break;
          case 'Microbars':
            toValue = fromValue * pascalToMicrobar * 101325.0;
            break;
          case 'Millibars':
            toValue = fromValue * pascalToMillibar * 101325.0;
            break;
          case 'Bars':
            toValue = fromValue * pascalToBar * 101325.0;
            break;
          case 'Millitorrs':
            toValue = fromValue * pascalToMillitorr * 101325.0;
            break;
          case 'Torrs':
            toValue = fromValue * pascalToTorr * 101325.0;
            break;
          case 'Technical Atmospheres':
            toValue = fromValue * pascalToTechnicalAtmosphere * 101325.0;
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue =
                fromValue * pascalToKilogramForcePerSquareCentimeter * 101325.0;
            break;
          case 'Kilogram-force per Square Meter':
            toValue =
                fromValue * pascalToKilogramForcePerSquareMeter * 101325.0;
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue * pascalToPoundsPerSquareInch * 101325.0;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue * pascalToKilopoundsPerSquareInch * 101325.0;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue * pascalToMegapoundsPerSquareInch * 101325.0;
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue * pascalToPoundsPerSquareFoot * 101325.0;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue * pascalToKilopoundsPerSquareFoot * 101325.0;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue * pascalToMegapoundsPerSquareFoot * 101325.0;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue * pascalToMillimetersOfMercury * 101325.0;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * pascalToInchesOfMercury * 101325.0;
            break;
          case 'Millimetres of water column':
            toValue = fromValue * pascalToMillimetersOfWaterColumn * 101325.0;
            break;
          case 'Inches of water column':
            toValue = fromValue * pascalToInchesOfWaterColumn * 101325.0;
            break;
          case 'Atmospheres': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // MICROBARS UNIT CONVERSION
      case 'Microbars':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * (pascalToMicropascal / pascalToMicrobar);
            break;
          case 'Millipascals':
            toValue = fromValue * (pascalToMillipascal / pascalToMicrobar);
            break;
          case 'Pascals':
            toValue = fromValue / pascalToMicrobar;
            break;
          case 'Hectopascals':
            toValue = fromValue * (pascalToHectopascal / pascalToMicrobar);
            break;
          case 'Kilopascals':
            toValue = fromValue * (pascalToKilopascal / pascalToMicrobar);
            break;
          case 'Megapascals':
            toValue = fromValue * (pascalToMegapascal / pascalToMicrobar);
            break;
          case 'Gigapascals':
            toValue = fromValue * (pascalToGigapascal / pascalToMicrobar);
            break;
          case 'Atmospheres':
            toValue = fromValue * (pascalToAtmospheres / pascalToMicrobar);
            break;
          case 'Millibars':
            toValue = fromValue / 1000.0;
            break;
          case 'Bars':
            toValue = fromValue * (pascalToBar / pascalToMicrobar);
            break;
          case 'Millitorrs':
            toValue = fromValue * (pascalToMillitorr / pascalToMicrobar);
            break;
          case 'Torrs':
            toValue = fromValue * (pascalToTorr / pascalToMicrobar);
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue * (pascalToTechnicalAtmosphere / pascalToMicrobar);
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToKilogramForcePerSquareCentimeter / pascalToMicrobar);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToKilogramForcePerSquareMeter / pascalToMicrobar);
            break;
          case 'Pounds per Square Inch':
            toValue =
                fromValue * (pascalToPoundsPerSquareInch / pascalToMicrobar);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareInch / pascalToMicrobar);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareInch / pascalToMicrobar);
            break;
          case 'Pounds per Square Foot':
            toValue =
                fromValue * (pascalToPoundsPerSquareFoot / pascalToMicrobar);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToMicrobar);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToMicrobar);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue =
                fromValue * (pascalToMillimetersOfMercury / pascalToMicrobar);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * (pascalToInchesOfMercury / pascalToMicrobar);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToMicrobar);
            break;
          case 'Inches of water column':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToMicrobar);
            break;
          case 'Microbars': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // MILLIBARS UNIT CONVERSION
      case 'Millibars':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * (pascalToMicropascal / pascalToMillibar);
            break;
          case 'Millipascals':
            toValue = fromValue * (pascalToMillipascal / pascalToMillibar);
            break;
          case 'Pascals':
            toValue = fromValue / pascalToMillibar;
            break;
          case 'Hectopascals':
            toValue = fromValue * (pascalToHectopascal / pascalToMillibar);
            break;
          case 'Kilopascals':
            toValue = fromValue * (pascalToKilopascal / pascalToMillibar);
            break;
          case 'Megapascals':
            toValue = fromValue * (pascalToMegapascal / pascalToMillibar);
            break;
          case 'Gigapascals':
            toValue = fromValue * (pascalToGigapascal / pascalToMillibar);
            break;
          case 'Atmospheres':
            toValue = fromValue * (pascalToAtmospheres / pascalToMillibar);
            break;
          case 'Microbars':
            toValue = fromValue * 1000.0;
            break;
          case 'Bars':
            toValue = fromValue * (pascalToBar / pascalToMillibar);
            break;
          case 'Millitorrs':
            toValue = fromValue * (pascalToMillitorr / pascalToMillibar);
            break;
          case 'Torrs':
            toValue = fromValue * (pascalToTorr / pascalToMillibar);
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue * (pascalToTechnicalAtmosphere / pascalToMillibar);
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToKilogramForcePerSquareCentimeter / pascalToMillibar);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToKilogramForcePerSquareMeter / pascalToMillibar);
            break;
          case 'Pounds per Square Inch':
            toValue =
                fromValue * (pascalToPoundsPerSquareInch / pascalToMillibar);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareInch / pascalToMillibar);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareInch / pascalToMillibar);
            break;
          case 'Pounds per Square Foot':
            toValue =
                fromValue * (pascalToPoundsPerSquareFoot / pascalToMillibar);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToMillibar);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToMillibar);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue =
                fromValue * (pascalToMillimetersOfMercury / pascalToMillibar);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * (pascalToInchesOfMercury / pascalToMillibar);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToMillibar);
            break;
          case 'Inches of water column':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToMillibar);
            break;
          case 'Millibars': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // BARS UNIT CONVERSION
      case 'Bars':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * pascalToMicropascal / pascalToBar;
            break;
          case 'Millipascals':
            toValue = fromValue * pascalToMillipascal / pascalToBar;
            break;
          case 'Pascals':
            toValue = fromValue / pascalToBar;
            break;
          case 'Hectopascals':
            toValue = fromValue * pascalToHectopascal / pascalToBar;
            break;
          case 'Kilopascals':
            toValue = fromValue * pascalToKilopascal / pascalToBar;
            break;
          case 'Megapascals':
            toValue = fromValue * pascalToMegapascal / pascalToBar;
            break;
          case 'Gigapascals':
            toValue = fromValue * pascalToGigapascal / pascalToBar;
            break;
          case 'Atmospheres':
            toValue = fromValue * pascalToAtmospheres / pascalToBar;
            break;
          case 'Microbars':
            toValue = fromValue * pascalToMicrobar / pascalToBar;
            break;
          case 'Millibars':
            toValue = fromValue * pascalToMillibar / pascalToBar;
            break;
          // Case 'Bars' to 'Bars' is trivial, 1:1 conversion
          case 'Millitorrs':
            toValue = fromValue * pascalToMillitorr / pascalToBar;
            break;
          case 'Torrs':
            toValue = fromValue * pascalToTorr / pascalToBar;
            break;
          case 'Technical Atmospheres':
            toValue = fromValue * pascalToTechnicalAtmosphere / pascalToBar;
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToBar;
            break;
          case 'Kilogram-force per Square Meter':
            toValue =
                fromValue * pascalToKilogramForcePerSquareMeter / pascalToBar;
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue * pascalToPoundsPerSquareInch / pascalToBar;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue * pascalToKilopoundsPerSquareInch / pascalToBar;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue * pascalToMegapoundsPerSquareInch / pascalToBar;
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue * pascalToPoundsPerSquareFoot / pascalToBar;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue * pascalToKilopoundsPerSquareFoot / pascalToBar;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue * pascalToMegapoundsPerSquareFoot / pascalToBar;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue * pascalToMillimetersOfMercury / pascalToBar;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * pascalToInchesOfMercury / pascalToBar;
            break;
          case 'Millimetres of water column':
            toValue =
                fromValue * pascalToMillimetersOfWaterColumn / pascalToBar;
            break;
          case 'Inches of water column':
            toValue = fromValue * pascalToInchesOfWaterColumn / pascalToBar;
            break;
          case 'Bars': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // MILLITORRS UNIT CONVERSION
      case 'Millitorrs':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * (pascalToMicropascal / pascalToMillitorr);
            break;
          case 'Millipascals':
            toValue = fromValue * (pascalToMillipascal / pascalToMillitorr);
            break;
          case 'Pascals':
            toValue = fromValue / pascalToMillitorr;
            break;
          case 'Hectopascals':
            toValue = fromValue * (pascalToHectopascal / pascalToMillitorr);
            break;
          case 'Kilopascals':
            toValue = fromValue * (pascalToKilopascal / pascalToMillitorr);
            break;
          case 'Megapascals':
            toValue = fromValue * (pascalToMegapascal / pascalToMillitorr);
            break;
          case 'Gigapascals':
            toValue = fromValue * (pascalToGigapascal / pascalToMillitorr);
            break;
          case 'Atmospheres':
            toValue = fromValue * (pascalToAtmospheres / pascalToMillitorr);
            break;
          case 'Microbars':
            toValue = fromValue * (pascalToMicrobar / pascalToMillitorr);
            break;
          case 'Millibars':
            toValue = fromValue * (pascalToMillibar / pascalToMillitorr);
            break;
          case 'Bars':
            toValue = fromValue * (pascalToBar / pascalToMillitorr);
            break;
          case 'Torrs':
            toValue = fromValue * (pascalToTorr / pascalToMillitorr);
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue * (pascalToTechnicalAtmosphere / pascalToMillitorr);
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToKilogramForcePerSquareCentimeter / pascalToMillitorr);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToKilogramForcePerSquareMeter / pascalToMillitorr);
            break;
          case 'Pounds per Square Inch':
            toValue =
                fromValue * (pascalToPoundsPerSquareInch / pascalToMillitorr);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareInch / pascalToMillitorr);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareInch / pascalToMillitorr);
            break;
          case 'Pounds per Square Foot':
            toValue =
                fromValue * (pascalToPoundsPerSquareFoot / pascalToMillitorr);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToMillitorr);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToMillitorr);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue =
                fromValue * (pascalToMillimetersOfMercury / pascalToMillitorr);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * (pascalToInchesOfMercury / pascalToMillitorr);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToMillitorr);
            break;
          case 'Inches of water column':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToMillitorr);
            break;
          case 'Millitorrs': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // TORRS UNIT CONVERSION
      case 'Torrs':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * (pascalToMicropascal / pascalToTorr);
            break;
          case 'Millipascals':
            toValue = fromValue * (pascalToMillipascal / pascalToTorr);
            break;
          case 'Pascals':
            toValue = fromValue / pascalToTorr;
            break;
          case 'Hectopascals':
            toValue = fromValue * (pascalToHectopascal / pascalToTorr);
            break;
          case 'Kilopascals':
            toValue = fromValue * (pascalToKilopascal / pascalToTorr);
            break;
          case 'Megapascals':
            toValue = fromValue * (pascalToMegapascal / pascalToTorr);
            break;
          case 'Gigapascals':
            toValue = fromValue * (pascalToGigapascal / pascalToTorr);
            break;
          case 'Atmospheres':
            toValue = fromValue * (pascalToAtmospheres / pascalToTorr);
            break;
          case 'Microbars':
            toValue = fromValue * (pascalToMicrobar / pascalToTorr);
            break;
          case 'Millibars':
            toValue = fromValue * (pascalToMillibar / pascalToTorr);
            break;
          case 'Bars':
            toValue = fromValue * (pascalToBar / pascalToTorr);
            break;
          case 'Millitorrs':
            toValue = fromValue * 1000.0;
            break;
          case 'Technical Atmospheres':
            toValue = fromValue * (pascalToTechnicalAtmosphere / pascalToTorr);
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToKilogramForcePerSquareCentimeter / pascalToTorr);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToKilogramForcePerSquareMeter / pascalToTorr);
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue * (pascalToPoundsPerSquareInch / pascalToTorr);
            break;
          case 'Kilopounds per Square Inch':
            toValue =
                fromValue * (pascalToKilopoundsPerSquareInch / pascalToTorr);
            break;
          case 'Megapounds per Square Inch':
            toValue =
                fromValue * (pascalToMegapoundsPerSquareInch / pascalToTorr);
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue * (pascalToPoundsPerSquareFoot / pascalToTorr);
            break;
          case 'Kilopounds per Square Foot':
            toValue =
                fromValue * (pascalToKilopoundsPerSquareFoot / pascalToTorr);
            break;
          case 'Megapounds per Square Foot':
            toValue =
                fromValue * (pascalToMegapoundsPerSquareFoot / pascalToTorr);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue * (pascalToMillimetersOfMercury / pascalToTorr);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * (pascalToInchesOfMercury / pascalToTorr);
            break;
          case 'Millimetres of water column':
            toValue =
                fromValue * (pascalToMillimetersOfWaterColumn / pascalToTorr);
            break;
          case 'Inches of water column':
            toValue = fromValue * (pascalToInchesOfWaterColumn / pascalToTorr);
            break;
          case 'Torrs': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // TECHNICAL ATMOSPHERES UNIT CONVERSION
      case 'Technical Atmospheres':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue * (pascalToMicropascal * 98066.5);
            break;
          case 'Millipascals':
            toValue = fromValue * (pascalToMillipascal * 98066.5);
            break;
          case 'Pascals':
            toValue = fromValue * 98066.5;
            break;
          case 'Hectopascals':
            toValue = fromValue * (pascalToHectopascal * 98066.5);
            break;
          case 'Kilopascals':
            toValue = fromValue * (pascalToKilopascal * 98066.5);
            break;
          case 'Megapascals':
            toValue = fromValue * (pascalToMegapascal * 98066.5);
            break;
          case 'Gigapascals':
            toValue = fromValue * (pascalToGigapascal * 98066.5);
            break;
          case 'Atmospheres':
            toValue = fromValue * (pascalToAtmospheres * 98066.5);
            break;
          case 'Microbars':
            toValue = fromValue * (pascalToMicrobar * 98066.5);
            break;
          case 'Millibars':
            toValue = fromValue * (pascalToMillibar * 98066.5);
            break;
          case 'Bars':
            toValue = fromValue * (pascalToBar * 98066.5);
            break;
          case 'Millitorrs':
            toValue = fromValue * (pascalToMillitorr * 98066.5);
            break;
          case 'Torrs':
            toValue = fromValue * (pascalToTorr * 98066.5);
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue; // 1 technical atmosphere = 1 kgf/cm²
            break;
          case 'Kilogram-force per Square Meter':
            toValue =
                fromValue * (pascalToKilogramForcePerSquareMeter * 98066.5);
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue * (pascalToPoundsPerSquareInch * 98066.5);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue * (pascalToKilopoundsPerSquareInch * 98066.5);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue * (pascalToMegapoundsPerSquareInch * 98066.5);
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue * (pascalToPoundsPerSquareFoot * 98066.5);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue * (pascalToKilopoundsPerSquareFoot * 98066.5);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue * (pascalToMegapoundsPerSquareFoot * 98066.5);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue * (pascalToMillimetersOfMercury * 98066.5);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue * (pascalToInchesOfMercury * 98066.5);
            break;
          case 'Millimetres of water column':
            toValue = fromValue * (pascalToMillimetersOfWaterColumn * 98066.5);
            break;
          case 'Inches of water column':
            toValue = fromValue * (pascalToInchesOfWaterColumn * 98066.5);
            break;
          case 'Technical Atmospheres': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // KILOGRAM-FORCE PER SQUARE CENTIMETER UNIT CONVERSION
      case 'Kilogram-force per Square Centimeter':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                pascalToMicropascal /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Millipascals':
            toValue = fromValue *
                pascalToMillipascal /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Pascals':
            toValue = fromValue / pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Hectopascals':
            toValue = fromValue *
                pascalToHectopascal /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Kilopascals':
            toValue = fromValue *
                pascalToKilopascal /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Megapascals':
            toValue = fromValue *
                pascalToMegapascal /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Gigapascals':
            toValue = fromValue *
                pascalToGigapascal /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Atmospheres':
            toValue = fromValue *
                pascalToAtmospheres /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Microbars':
            toValue = fromValue *
                pascalToMicrobar /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Millibars':
            toValue = fromValue *
                pascalToMillibar /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Bars':
            toValue = fromValue *
                pascalToBar /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Millitorrs':
            toValue = fromValue *
                pascalToMillitorr /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Torrs':
            toValue = fromValue *
                pascalToTorr /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Technical Atmospheres':
            toValue = fromValue; // 1 kgf/cm² is equal to 1 technical atmosphere
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue * 10000.0; // 1 kgf/cm² = 10000 kgf/m²
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                pascalToPoundsPerSquareInch /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                pascalToKilopoundsPerSquareInch /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                pascalToMegapoundsPerSquareInch /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                pascalToPoundsPerSquareFoot /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                pascalToKilopoundsPerSquareFoot /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                pascalToMegapoundsPerSquareFoot /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                pascalToMillimetersOfMercury /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                pascalToInchesOfMercury /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                pascalToMillimetersOfWaterColumn /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Inches of water column':
            toValue = fromValue *
                pascalToInchesOfWaterColumn /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Kilogram-force per Square Centimeter': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // KILOGRAM-FORCE PER SQUARE METER UNIT CONVERSION
      case 'Kilogram-force per Square Meter':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                (pascalToMicropascal / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Millipascals':
            toValue = fromValue *
                (pascalToMillipascal / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Pascals':
            toValue = fromValue / pascalToKilogramForcePerSquareMeter;
            break;
          case 'Hectopascals':
            toValue = fromValue *
                (pascalToHectopascal / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Kilopascals':
            toValue = fromValue *
                (pascalToKilopascal / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Megapascals':
            toValue = fromValue *
                (pascalToMegapascal / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Gigapascals':
            toValue = fromValue *
                (pascalToGigapascal / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Atmospheres':
            toValue = fromValue *
                (pascalToAtmospheres / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToMicrobar / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToMillibar / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Bars':
            toValue =
                fromValue * (pascalToBar / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToMillitorr / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToTorr / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Technical Atmospheres':
            toValue =
                fromValue / 10000.0; // 1 kgf/m² = 1e-4 technical atmospheres
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue / 10000.0; // 1 kgf/m² = 1e-4 kgf/cm²
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareInch /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareInch /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Kilogram-force per Square Meter': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

// Kiloponds per Square Centimeter UNIT CONVERSION
      case 'Kiloponds per Square Centimeter':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMicropascal;
            break;
          case 'Millipascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMillipascal;
            break;
          case 'Pascals':
            toValue = fromValue * pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Hectopascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToHectopascal;
            break;
          case 'Kilopascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToKilopascal;
            break;
          case 'Megapascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMegapascal;
            break;
          case 'Gigapascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToGigapascal;
            break;
          case 'Atmospheres':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToAtmospheres;
            break;
          case 'Microbars':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                (pascalToMicrobar);
            break;
          case 'Millibars':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                (pascalToMillibar);
            break;
          case 'Bars':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                (pascalToBar);
            break;
          case 'Millitorrs':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                (pascalToMillitorr);
            break;
          case 'Torrs':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                (pascalToTorr);
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                (pascalToTechnicalAtmosphere);
            break;
          case 'Kilogram-force per Square Centimeter': // No conversion needed
            toValue = fromValue;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToKilogramForcePerSquareMeter;
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToPoundsPerSquareInch;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToKilopoundsPerSquareInch;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMegapoundsPerSquareInch;
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToPoundsPerSquareFoot;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToKilopoundsPerSquareFoot;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMegapoundsPerSquareFoot;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMillimetersOfMercury;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToInchesOfMercury;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToMillimetersOfWaterColumn;
            break;
          case 'Inches of water column':
            toValue = fromValue *
                pascalToKilogramForcePerSquareCentimeter /
                pascalToInchesOfWaterColumn;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // Kiloponds per Square Meter UNIT CONVERSION
      case 'Kiloponds per Square Meter':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMicropascal;
            break;
          case 'Millipascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMillipascal;
            break;
          case 'Pascals':
            toValue = fromValue * pascalToKilogramForcePerSquareMeter;
            break;
          case 'Hectopascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToHectopascal;
            break;
          case 'Kilopascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToKilopascal;
            break;
          case 'Megapascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMegapascal;
            break;
          case 'Gigapascals':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToGigapascal;
            break;
          case 'Atmospheres':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToAtmospheres;
            break;
          case 'Microbars':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                (pascalToMicrobar / pascalToPascal);
            break;
          case 'Millibars':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                (pascalToMillibar / pascalToPascal);
            break;
          case 'Bars':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                (pascalToBar / pascalToPascal);
            break;
          case 'Millitorrs':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                (pascalToMillitorr / pascalToPascal);
            break;
          case 'Torrs':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                (pascalToTorr / pascalToPascal);
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                (pascalToTechnicalAtmosphere / pascalToPascal);
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Kilogram-force per Square Meter': // No conversion needed
            toValue = fromValue;
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToPoundsPerSquareInch;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToKilopoundsPerSquareInch;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMegapoundsPerSquareInch;
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToPoundsPerSquareFoot;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToKilopoundsPerSquareFoot;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMegapoundsPerSquareFoot;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMillimetersOfMercury;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToInchesOfMercury;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToMillimetersOfWaterColumn;
            break;
          case 'Inches of water column':
            toValue = fromValue *
                pascalToKilogramForcePerSquareMeter /
                pascalToInchesOfWaterColumn;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

// Pounds per Square Inch UNIT CONVERSION
      case 'Pounds per Square Inch':
        switch (toUnit) {
          case 'Micropascals':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToMicropascal;
            break;
          case 'Millipascals':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToMillipascal;
            break;
          case 'Pascals':
            toValue = fromValue * pascalToPoundsPerSquareInch;
            break;
          case 'Hectopascals':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToHectopascal;
            break;
          case 'Kilopascals':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToKilopascal;
            break;
          case 'Megapascals':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToMegapascal;
            break;
          case 'Gigapascals':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToGigapascal;
            break;
          case 'Atmospheres':
            toValue =
                fromValue * pascalToPoundsPerSquareInch / pascalToAtmospheres;
            break;
          case 'Microbars':
            toValue = fromValue *
                pascalToPoundsPerSquareInch /
                (pascalToMicrobar / pascalToPascal);
            break;
          case 'Millibars':
            toValue = fromValue *
                pascalToPoundsPerSquareInch /
                (pascalToMillibar / pascalToPascal);
            break;
          case 'Bars':
            toValue = fromValue *
                pascalToPoundsPerSquareInch /
                (pascalToBar / pascalToPascal);
            break;
          case 'Millitorrs':
            toValue = fromValue *
                pascalToPoundsPerSquareInch /
                (pascalToMillitorr / pascalToPascal);
            break;
          case 'Torrs':
            toValue = fromValue *
                pascalToPoundsPerSquareInch /
                (pascalToTorr / pascalToPascal);
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                pascalToPoundsPerSquareInch /
                (pascalToTechnicalAtmosphere / pascalToPascal);
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                pascalToPoundsPerSquareInch /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                pascalToPoundsPerSquareInch /
                pascalToKilogramForcePerSquareMeter;
            break;
          case 'Pounds per Square Inch': // No conversion needed
            toValue = fromValue;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToKilopoundsPerSquareInch);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToMegapoundsPerSquareInch);
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToPoundsPerSquareFoot);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToKilopoundsPerSquareFoot);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToMegapoundsPerSquareFoot);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToMillimetersOfMercury);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToInchesOfMercury);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMillimetersOfWaterColumn);
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToInchesOfWaterColumn);
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;
      // Kilopounds per Square Inch UNIT CONVERSION
      case 'Kilopounds per Square Inch':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToMicropascal;
            break;
          case 'Millipascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToMillipascal;
            break;
          case 'Pascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToKilopoundsPerSquareInch);
            break;
          case 'Hectopascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToHectopascal;
            break;
          case 'Kilopascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToKilopascal;
            break;
          case 'Megapascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToMegapascal;
            break;
          case 'Gigapascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToGigapascal;
            break;
          case 'Atmospheres':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToAtmospheres;
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                (pascalToMicrobar / pascalToPascal);
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                (pascalToMillibar / pascalToPascal);
            break;
          case 'Bars':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                (pascalToBar / pascalToPascal);
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                (pascalToMillitorr / pascalToPascal);
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                (pascalToTorr / pascalToPascal);
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                (pascalToTechnicalAtmosphere / pascalToPascal);
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToKilogramForcePerSquareMeter;
            break;
          case 'Pounds per Square Inch': // No conversion needed
            toValue = fromValue;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToMegapoundsPerSquareInch;
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToPoundsPerSquareFoot;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToKilopoundsPerSquareFoot;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToMegapoundsPerSquareFoot;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToMillimetersOfMercury;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToInchesOfMercury;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToMillimetersOfWaterColumn;
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToKilopoundsPerSquareInch) /
                pascalToInchesOfWaterColumn;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // Megapounds per Square Inch UNIT CONVERSION
      case 'Megapounds per Square Inch':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToMicropascal;
            break;
          case 'Millipascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToMillipascal;
            break;
          case 'Pascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch / pascalToMegapoundsPerSquareInch);
            break;
          case 'Hectopascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToHectopascal;
            break;
          case 'Kilopascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToKilopascal;
            break;
          case 'Megapascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToMegapascal;
            break;
          case 'Gigapascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToGigapascal;
            break;
          case 'Atmospheres':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToAtmospheres;
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                (pascalToMicrobar / pascalToPascal);
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                (pascalToMillibar / pascalToPascal);
            break;
          case 'Bars':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                (pascalToBar / pascalToPascal);
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                (pascalToMillitorr / pascalToPascal);
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                (pascalToTorr / pascalToPascal);
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                (pascalToTechnicalAtmosphere / pascalToPascal);
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToKilogramForcePerSquareCentimeter;
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToKilogramForcePerSquareMeter;
            break;
          case 'Pounds per Square Inch': // No conversion needed
            toValue = fromValue;
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToKilopoundsPerSquareInch;
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue;
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToPoundsPerSquareFoot;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToKilopoundsPerSquareFoot;
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToMegapoundsPerSquareFoot;
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToMillimetersOfMercury;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToInchesOfMercury;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToMillimetersOfWaterColumn;
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToPoundsPerSquareInch /
                    pascalToMegapoundsPerSquareInch) /
                pascalToInchesOfWaterColumn;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;
      // Pounds per Square Foot UNIT CONVERSION
      case 'Pounds per Square Foot':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareFoot) /
                pascalToMicropascal;
            break;
          case 'Millipascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareFoot) /
                pascalToMillipascal;
            break;
          case 'Pascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / pascalToMegapoundsPerSquareFoot);
            break;
          case 'Hectopascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareFoot) /
                pascalToHectopascal;
            break;
          case 'Kilopascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareFoot) /
                pascalToKilopascal;
            break;
          case 'Megapascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareFoot) /
                pascalToMegapascal;
            break;
          case 'Gigapascals':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareFoot) /
                pascalToGigapascal;
            break;
          case 'Atmospheres':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareFoot) /
                pascalToAtmospheres;
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    (pascalToMicrobar / pascalToPascal));
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    (pascalToMillibar / pascalToPascal));
            break;
          case 'Bars':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / (pascalToBar / pascalToPascal));
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    (pascalToMillitorr / pascalToPascal));
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / (pascalToTorr / pascalToPascal));
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    (pascalToTechnicalAtmosphere / pascalToPascal));
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToKilogramForcePerSquareCentimeter);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / pascalToPoundsPerSquareInch);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / pascalToKilopoundsPerSquareInch);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / pascalToMegapoundsPerSquareInch);
            break;
          case 'Pounds per Square Foot': // No conversion needed
            toValue = fromValue;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / pascalToKilopoundsPerSquareFoot);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / pascalToMegapoundsPerSquareFoot);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / pascalToMillimetersOfMercury);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / pascalToInchesOfMercury);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot /
                    pascalToMillimetersOfWaterColumn);
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToPoundsPerSquareFoot / pascalToInchesOfWaterColumn);
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

// Millimetres of Mercury (0°C) UNIT CONVERSION
      case 'Millimetres of Mercury (0°C)':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                (pascalToMillimetersOfMercury / pascalToMicropascal);
            break;
          case 'Millipascals':
            toValue = fromValue *
                (pascalToMillimetersOfMercury / pascalToMillipascal);
            break;
          case 'Pascals':
            toValue = fromValue * pascalToMillimetersOfMercury;
            break;
          case 'Hectopascals':
            toValue = fromValue *
                (pascalToMillimetersOfMercury / pascalToHectopascal);
            break;
          case 'Kilopascals':
            toValue =
                fromValue * (pascalToMillimetersOfMercury / pascalToKilopascal);
            break;
          case 'Megapascals':
            toValue =
                fromValue * (pascalToMillimetersOfMercury / pascalToMegapascal);
            break;
          case 'Gigapascals':
            toValue =
                fromValue * (pascalToMillimetersOfMercury / pascalToGigapascal);
            break;
          case 'Atmospheres':
            toValue = fromValue *
                (pascalToMillimetersOfMercury / pascalToAtmospheres);
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    (pascalToMicrobar / pascalToPascal));
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    (pascalToMillibar / pascalToPascal));
            break;
          case 'Bars':
            toValue = fromValue *
                (pascalToMillimetersOfMercury / (pascalToBar / pascalToPascal));
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    (pascalToMillitorr / pascalToPascal));
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    (pascalToTorr / pascalToPascal));
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    (pascalToTechnicalAtmosphere / pascalToPascal));
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    pascalToKilogramForcePerSquareCentimeter);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                (pascalToMillimetersOfMercury / pascalToPoundsPerSquareInch);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    pascalToKilopoundsPerSquareInch);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    pascalToMegapoundsPerSquareInch);
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                (pascalToMillimetersOfMercury / pascalToPoundsPerSquareFoot);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    pascalToKilopoundsPerSquareFoot);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    pascalToMegapoundsPerSquareFoot);
            break;
          case 'Millimetres of Mercury (0°C)': // No conversion needed
            toValue = fromValue;
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToMillimetersOfMercury / pascalToInchesOfMercury);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToMillimetersOfMercury /
                    pascalToMillimetersOfWaterColumn);
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToMillimetersOfMercury / pascalToInchesOfWaterColumn);
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;
      // Inches of Mercury (0°C) UNIT CONVERSION
      case 'Inches of Mercury (0°C)':
        switch (toUnit) {
          case 'Micropascals':
            toValue =
                fromValue * (pascalToInchesOfMercury / pascalToMicropascal);
            break;
          case 'Millipascals':
            toValue =
                fromValue * (pascalToInchesOfMercury / pascalToMillipascal);
            break;
          case 'Pascals':
            toValue = fromValue * pascalToInchesOfMercury;
            break;
          case 'Hectopascals':
            toValue =
                fromValue * (pascalToInchesOfMercury / pascalToHectopascal);
            break;
          case 'Kilopascals':
            toValue =
                fromValue * (pascalToInchesOfMercury / pascalToKilopascal);
            break;
          case 'Megapascals':
            toValue =
                fromValue * (pascalToInchesOfMercury / pascalToMegapascal);
            break;
          case 'Gigapascals':
            toValue =
                fromValue * (pascalToInchesOfMercury / pascalToGigapascal);
            break;
          case 'Atmospheres':
            toValue =
                fromValue * (pascalToInchesOfMercury / pascalToAtmospheres);
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToInchesOfMercury / (pascalToMicrobar / pascalToPascal));
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToInchesOfMercury / (pascalToMillibar / pascalToPascal));
            break;
          case 'Bars':
            toValue = fromValue *
                (pascalToInchesOfMercury / (pascalToBar / pascalToPascal));
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToInchesOfMercury /
                    (pascalToMillitorr / pascalToPascal));
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToInchesOfMercury / (pascalToTorr / pascalToPascal));
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                (pascalToInchesOfMercury /
                    (pascalToTechnicalAtmosphere / pascalToPascal));
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToInchesOfMercury /
                    pascalToKilogramForcePerSquareCentimeter);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToKilogramForcePerSquareMeter);
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToPoundsPerSquareInch);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToKilopoundsPerSquareInch);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToMegapoundsPerSquareInch);
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToPoundsPerSquareFoot);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToKilopoundsPerSquareFoot);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToMegapoundsPerSquareFoot);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToMillimetersOfMercury);
            break;
          case 'Inches of Mercury (0°C)': // No conversion needed
            toValue = fromValue;
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToMillimetersOfWaterColumn);
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToInchesOfMercury / pascalToInchesOfWaterColumn);
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // Kilopounds per Square Foot UNIT CONVERSION
      case 'Kilopounds per Square Foot':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToMicropascal);
            break;
          case 'Millipascals':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToMillipascal);
            break;
          case 'Pascals':
            toValue = fromValue * pascalToKilopoundsPerSquareFoot;
            break;
          case 'Hectopascals':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToHectopascal);
            break;
          case 'Kilopascals':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToKilopascal);
            break;
          case 'Megapascals':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToMegapascal);
            break;
          case 'Gigapascals':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToGigapascal);
            break;
          case 'Atmospheres':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToAtmospheres);
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    (pascalToMicrobar / pascalToPascal));
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    (pascalToMillibar / pascalToPascal));
            break;
          case 'Bars':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    (pascalToBar / pascalToPascal));
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    (pascalToMillitorr / pascalToPascal));
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    (pascalToTorr / pascalToPascal));
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    (pascalToTechnicalAtmosphere / pascalToPascal));
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    pascalToKilogramForcePerSquareCentimeter);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToPoundsPerSquareInch);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    pascalToKilopoundsPerSquareInch);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareInch);
            break;
          case 'Pounds per Square Foot': // No conversion needed
            toValue = fromValue;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    pascalToKilopoundsPerSquareFoot);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareFoot);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    pascalToMillimetersOfMercury);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToInchesOfMercury);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot /
                    pascalToMillimetersOfWaterColumn);
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToKilopoundsPerSquareFoot / pascalToInchesOfWaterColumn);
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;
      // Megapounds per Square Foot UNIT CONVERSION
      case 'Megapounds per Square Foot':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToMicropascal);
            break;
          case 'Millipascals':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToMillipascal);
            break;
          case 'Pascals':
            toValue = fromValue * pascalToMegapoundsPerSquareFoot;
            break;
          case 'Hectopascals':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToHectopascal);
            break;
          case 'Kilopascals':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToKilopascal);
            break;
          case 'Megapascals':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToMegapascal);
            break;
          case 'Gigapascals':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToGigapascal);
            break;
          case 'Atmospheres':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToAtmospheres);
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    (pascalToMicrobar / pascalToPascal));
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    (pascalToMillibar / pascalToPascal));
            break;
          case 'Bars':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    (pascalToBar / pascalToPascal));
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    (pascalToMillitorr / pascalToPascal));
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    (pascalToTorr / pascalToPascal));
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    (pascalToTechnicalAtmosphere / pascalToPascal));
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    pascalToKilogramForcePerSquareCentimeter);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToPoundsPerSquareInch);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    pascalToKilopoundsPerSquareInch);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareInch);
            break;
          case 'Pounds per Square Foot': // No conversion needed
            toValue = fromValue;
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    pascalToKilopoundsPerSquareFoot);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    pascalToMegapoundsPerSquareFoot);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    pascalToMillimetersOfMercury);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToInchesOfMercury);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot /
                    pascalToMillimetersOfWaterColumn);
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToMegapoundsPerSquareFoot / pascalToInchesOfWaterColumn);
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;

      // Millimetres of water column UNIT CONVERSION
      case 'Millimetres of water column':
        switch (toUnit) {
          case 'Micropascals':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToMicropascal);
            break;
          case 'Millipascals':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToMillipascal);
            break;
          case 'Pascals':
            toValue = fromValue * pascalToMillimetersOfWaterColumn;
            break;
          case 'Hectopascals':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToHectopascal);
            break;
          case 'Kilopascals':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToKilopascal);
            break;
          case 'Megapascals':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToMegapascal);
            break;
          case 'Gigapascals':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToGigapascal);
            break;
          case 'Atmospheres':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToAtmospheres);
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    (pascalToMicrobar / pascalToPascal));
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    (pascalToMillibar / pascalToPascal));
            break;
          case 'Bars':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    (pascalToBar / pascalToPascal));
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    (pascalToMillitorr / pascalToPascal));
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    (pascalToTorr / pascalToPascal));
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    (pascalToTechnicalAtmosphere / pascalToPascal));
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToKilogramForcePerSquareCentimeter);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToPoundsPerSquareInch);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToKilopoundsPerSquareInch);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToMegapoundsPerSquareInch);
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToPoundsPerSquareFoot);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToKilopoundsPerSquareFoot);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToMegapoundsPerSquareFoot);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToMillimetersOfMercury);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn / pascalToInchesOfMercury);
            break;
          case 'Millimetres of water column': // No conversion needed
            toValue = fromValue;
            break;
          case 'Inches of water column':
            toValue = fromValue *
                (pascalToMillimetersOfWaterColumn /
                    pascalToInchesOfWaterColumn);
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
        }
        break;
      // Inches of water column UNIT CONVERSION
      case 'Inches of water column':
        switch (toUnit) {
          case 'Micropascals':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToMicropascal);
            break;
          case 'Millipascals':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToMillipascal);
            break;
          case 'Pascals':
            toValue = fromValue * pascalToInchesOfWaterColumn;
            break;
          case 'Hectopascals':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToHectopascal);
            break;
          case 'Kilopascals':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToKilopascal);
            break;
          case 'Megapascals':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToMegapascal);
            break;
          case 'Gigapascals':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToGigapascal);
            break;
          case 'Atmospheres':
            toValue =
                fromValue * (pascalToInchesOfWaterColumn / pascalToAtmospheres);
            break;
          case 'Microbars':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn /
                    (pascalToMicrobar / pascalToPascal));
            break;
          case 'Millibars':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn /
                    (pascalToMillibar / pascalToPascal));
            break;
          case 'Bars':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / (pascalToBar / pascalToPascal));
            break;
          case 'Millitorrs':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn /
                    (pascalToMillitorr / pascalToPascal));
            break;
          case 'Torrs':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / (pascalToTorr / pascalToPascal));
            break;
          case 'Technical Atmospheres':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn /
                    (pascalToTechnicalAtmosphere / pascalToPascal));
            break;
          case 'Kilogram-force per Square Centimeter':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn /
                    pascalToKilogramForcePerSquareCentimeter);
            break;
          case 'Kilogram-force per Square Meter':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn /
                    pascalToKilogramForcePerSquareMeter);
            break;
          case 'Pounds per Square Inch':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / pascalToPoundsPerSquareInch);
            break;
          case 'Kilopounds per Square Inch':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / pascalToKilopoundsPerSquareInch);
            break;
          case 'Megapounds per Square Inch':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / pascalToMegapoundsPerSquareInch);
            break;
          case 'Pounds per Square Foot':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / pascalToPoundsPerSquareFoot);
            break;
          case 'Kilopounds per Square Foot':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / pascalToKilopoundsPerSquareFoot);
            break;
          case 'Megapounds per Square Foot':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / pascalToMegapoundsPerSquareFoot);
            break;
          case 'Millimetres of Mercury (0°C)':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / pascalToMillimetersOfMercury);
            break;
          case 'Inches of Mercury (0°C)':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn / pascalToInchesOfMercury);
            break;
          case 'Millimetres of water column':
            toValue = fromValue *
                (pascalToInchesOfWaterColumn /
                    pascalToMillimetersOfWaterColumn);
            break;
          case 'Inches of water column': // No conversion needed
            toValue = fromValue;
            break;
          default:
            throw ArgumentError('Unsupported unit for conversion: $toUnit');
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
      case 'Micropascals':
        switch (toUnit) {
          case 'Millipascals':
            formula = 'Divide the pressure value by 1,000';
            break;
          case 'Pascals':
            formula = 'Divide the pressure value by 1,000,000';
            break;
          case 'Hectopascals':
            formula = 'Divide the pressure value by 10,000,000';
            break;
          case 'Kilopascals':
            formula = 'Divide the pressure value by 1,000,000,000';
            break;
          case 'Megapascals':
            formula = 'Divide the pressure value by 1,000,000,000,000';
            break;
          case 'Gigapascals':
            formula = 'Divide the pressure value by 1,000,000,000,000,000';
            break;
          case 'Atmospheres':
            formula = 'Divide the pressure value by 101,325';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 10';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 1,000,000';
            break;
          case 'Millitorrs':
            formula = 'Divide the pressure value by 0.00750062';
            break;
          case 'Torrs':
            formula = 'Divide the pressure value by 0.00750062';
            break;
          case 'Technical Atmospheres':
            formula = 'Divide the pressure value by 0.986923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Divide the pressure value by 9.80665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Divide the pressure value by 0.00000980665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Divide the pressure value by 980.665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Divide the pressure value by 0.00980665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Divide the pressure value by 0.0001450377';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Divide the pressure value by 145.0377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Divide the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Divide the pressure value by 0.0000208854';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Divide the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Divide the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Divide the pressure value by 133.3223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Divide the pressure value by 3,386.389';
            break;
          case 'Millimetres of water column':
            formula = 'Divide the pressure value by 9.80665';
            break;
          case 'Inches of water column':
            formula = 'Divide the pressure value by 0.3860885844';
            break;
          case 'Micropascals': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Millipascals':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Pascals':
            formula = 'Divide the pressure value by 1,000';
            break;
          case 'Hectopascals':
            formula = 'Divide the pressure value by 10';
            break;
          case 'Kilopascals':
            formula = 'Divide the pressure value by 1,000';
            break;
          case 'Megapascals':
            formula = 'Divide the pressure value by 1,000,000';
            break;
          case 'Gigapascals':
            formula = 'Divide the pressure value by 1,000,000,000';
            break;
          case 'Atmospheres':
            formula = 'Divide the pressure value by 101,325';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 0.01';
            break;
          case 'Millibars':
            formula = 'Divide the pressure value by 100';
            break;
          case 'Bars':
            formula = 'Divide the pressure value by 100,000';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7.50062';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7.50062';
            break;
          case 'Technical Atmospheres':
            formula = 'Divide the pressure value by 0.986923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Divide the pressure value by 9.80665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Divide the pressure value by 0.00980665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Divide the pressure value by 980.665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Divide the pressure value by 0.00000980665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Divide the pressure value by 0.0001450377';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Divide the pressure value by 145.0377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Divide the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Divide the pressure value by 0.0000208854';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Divide the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Divide the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Divide the pressure value by 133.3223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Divide the pressure value by 3,386.389';
            break;
          case 'Millimetres of water column':
            formula = 'Divide the pressure value by 9.80665';
            break;
          case 'Inches of water column':
            formula = 'Divide the pressure value by 0.3860885844';
            break;
          case 'Millipascals': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Pascals':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 1,000,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Hectopascals':
            formula = 'Divide the pressure value by 10';
            break;
          case 'Kilopascals':
            formula = 'Divide the pressure value by 1,000';
            break;
          case 'Megapascals':
            formula = 'Divide the pressure value by 1,000,000';
            break;
          case 'Gigapascals':
            formula = 'Divide the pressure value by 1,000,000,000';
            break;
          case 'Atmospheres':
            formula = 'Divide the pressure value by 101,325';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 10';
            break;
          case 'Millibars':
            formula = 'Divide the pressure value by 100';
            break;
          case 'Bars':
            formula = 'Divide the pressure value by 100,000';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7.50062';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7.50062';
            break;
          case 'Technical Atmospheres':
            formula = 'Divide the pressure value by 0.986923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Divide the pressure value by 9.80665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Divide the pressure value by 0.00980665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Divide the pressure value by 980.665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Divide the pressure value by 0.00000980665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Divide the pressure value by 0.0001450377';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Divide the pressure value by 145.0377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Divide the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Divide the pressure value by 0.0000208854';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Divide the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Divide the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Divide the pressure value by 133.3223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Divide the pressure value by 3,386.389';
            break;
          case 'Millimetres of water column':
            formula = 'Divide the pressure value by 9.80665';
            break;
          case 'Inches of water column':
            formula = 'Divide the pressure value by 0.3860885844';
            break;
          case 'Pascals': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Hectopascals':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 10,000,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 10,000';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 100';
            break;
          case 'Kilopascals':
            formula = 'Divide the pressure value by 10';
            break;
          case 'Megapascals':
            formula = 'Divide the pressure value by 10,000';
            break;
          case 'Gigapascals':
            formula = 'Divide the pressure value by 10,000,000';
            break;
          case 'Atmospheres':
            formula = 'Divide the pressure value by 1,013.25';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 10';
            break;
          case 'Bars':
            formula = 'Divide the pressure value by 10,000';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 75.0062';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 75.0062';
            break;
          case 'Technical Atmospheres':
            formula = 'Divide the pressure value by 98.6923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Divide the pressure value by 980.665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Divide the pressure value by 0.00980665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Divide the pressure value by 98.0665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Divide the pressure value by 0.000980665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Divide the pressure value by 0.01450377';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Divide the pressure value by 14.5037738';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Divide the pressure value by 14,503.7738';
            break;
          case 'Pounds per Square Foot':
            formula = 'Divide the pressure value by 0.00208854';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Divide the pressure value by 2,088.54342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Divide the pressure value by 2,088,543.42';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Divide the pressure value by 13.33223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Divide the pressure value by 338.6389';
            break;
          case 'Millimetres of water column':
            formula = 'Divide the pressure value by 98.0665';
            break;
          case 'Inches of water column':
            formula = 'Divide the pressure value by 3.860885844';
            break;
          case 'Hectopascals': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kilopascals':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 1,000,000,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 1,000,000';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 10';
            break;
          case 'Megapascals':
            formula = 'Divide the pressure value by 1,000';
            break;
          case 'Gigapascals':
            formula = 'Divide the pressure value by 1,000,000';
            break;
          case 'Atmospheres':
            formula = 'Divide the pressure value by 101.325';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 100';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Bars':
            formula = 'Divide the pressure value by 100';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 750.062';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 750.062';
            break;
          case 'Technical Atmospheres':
            formula = 'Divide the pressure value by 9.86923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Divide the pressure value by 98.0665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Divide the pressure value by 0.0980665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Divide the pressure value by 9.80665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Divide the pressure value by 0.00980665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Divide the pressure value by 0.1450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Divide the pressure value by 145.0377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Divide the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Divide the pressure value by 0.0208854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Divide the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Divide the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Divide the pressure value by 133.3223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Divide the pressure value by 3,386.389';
            break;
          case 'Millimetres of water column':
            formula = 'Divide the pressure value by 98.0665';
            break;
          case 'Inches of water column':
            formula = 'Divide the pressure value by 3.860885844';
            break;
          case 'Kilopascals': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Megapascals':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 1,000,000,000,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 1,000,000,000';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 1,000,000';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 10,000';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Gigapascals':
            formula = 'Divide the pressure value by 1,000';
            break;
          case 'Atmospheres':
            formula = 'Divide the pressure value by 0.101325';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 100,000';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 1,000,000';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 1,000,000,000';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Technical Atmospheres':
            formula = 'Divide the pressure value by 0.00986923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Divide the pressure value by 0.0980665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Divide the pressure value by 0.0000980665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Divide the pressure value by 0.00980665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Divide the pressure value by 0.00000980665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Divide the pressure value by 0.0001450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Divide the pressure value by 145.0377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Divide the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Divide the pressure value by 0.0000208854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Divide the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Divide the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Divide the pressure value by 133.3223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Divide the pressure value by 3,386.389';
            break;
          case 'Millimetres of water column':
            formula = 'Divide the pressure value by 98.0665';
            break;
          case 'Inches of water column':
            formula = 'Divide the pressure value by 3.860885844';
            break;
          case 'Megapascals': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Gigapascals':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 1,000,000,000,000,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 1,000,000,000,000';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 1,000,000,000';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 10,000,000';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 1,000,000';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Atmospheres':
            formula = 'Divide the pressure value by 0.00000986923';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 100,000,000';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 1,000,000,000';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 1,000,000,000,000';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7,500,620,000';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7,500,620,000';
            break;
          case 'Technical Atmospheres':
            formula = 'Divide the pressure value by 0.0000986923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Divide the pressure value by 0.000980665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Divide the pressure value by 0.000000980665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Divide the pressure value by 0.0000980665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Divide the pressure value by 0.0000000980665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Divide the pressure value by 0.000001450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Divide the pressure value by 0.1450377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Divide the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Divide the pressure value by 0.000000208854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Divide the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Divide the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Divide the pressure value by 0.000001333223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Divide the pressure value by 0.00003386389';
            break;
          case 'Millimetres of water column':
            formula = 'Divide the pressure value by 0.00000980665';
            break;
          case 'Inches of water column':
            formula = 'Divide the pressure value by 0.0003860885844';
            break;
          case 'Gigapascals': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Atmospheres':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 101,325,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 101,325';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 1,013.25';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 10,132.5';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 101.325';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.101325';
            break;
          case 'Gigapascals':
            formula = 'Multiply the pressure value by 0.00000986923';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 1,013,250';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 10,132,500';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 1,013,250,000';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Technical Atmospheres':
            formula = 'Divide the pressure value by 0.0000986923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 1.033227';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 10,332.27';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.033227';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 1,033.227';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 14.696';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 1,469.6';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 1,469,600';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 2048.16';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 2,048,160';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 2,048,160,000';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 13.5951';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 345.3';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 10';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.3937';
            break;
          case 'Atmospheres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Microbars':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 100';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 0.1';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 0.0001';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 0.001';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 0.000001';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.000000001';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.000000986923';
            break;
          case 'Microbars':
            formula = 'The value remains unchanged';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 0.001';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 0.000001';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 0.00750062';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 0.00750062';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.00000986923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 0.0000980665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 0.0000000980665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.00000980665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 0.00000000980665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.0000001450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 0.0001450377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 0.0000000208854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.000001333223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.00003386389';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 0.00000980665';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.0003860885844';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Millibars':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 100,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 100';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 0.1';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 0.001';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 0.0001';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.0000001';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.00000986923';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Millibars':
            formula = 'The value remains unchanged';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 0.001';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7.50062';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7.50062';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.0000986923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 0.000980665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 0.000000980665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.00000980665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 0.00000000980665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.0000001450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 0.0001450377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 0.0000000208854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.000001333223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.00003386389';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 0.00000980665';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.0003860885844';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Bars':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 100,000,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 100,000';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 100';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 100';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.1';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.986923';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 10,000,000';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 100,000';
            break;
          case 'Bars':
            formula = 'The value remains unchanged';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.0986923';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 1.0000665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 10,000.665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.10000665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 1,000.0665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.01450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 14.50377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 14,503.77378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 2.08854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 2,088,543.42';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 2,088,543,420';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.001333223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.03386389';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 10';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.3937007874';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Millitorrs':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 133.3223874';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 0.1333223874';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 0.0001333223874';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 0.001333223874';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 0.0001333223874';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.0000001333223874';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.000001315789474';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 0.0001333223874';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 0.001333223874';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 0.0001333223874';
            break;
          case 'Millitorrs':
            formula = 'The value remains unchanged';
            break;
          case 'Torrs':
            formula = 'The value remains unchanged';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.000001315789474';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 0.00001322773523';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 0.1332273523';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.000001322773523';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 0.01322773523';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.0000001934006471';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 0.1934006471';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 193.4006471';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 0.00002788900749';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 27.88900749';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 27,889.00749';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.00001333333333';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.000336';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 0.00009704661104';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.003812726962';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Torrs':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 133,322.3874';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 133.3223874';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 0.1333223874';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 1.333223874';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 0.1333223874';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.0001333223874';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.001315789474';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 133.3223874';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 1,333.223874';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 133.3223874';
            break;
          case 'Millitorrs':
            formula = 'The value remains unchanged';
            break;
          case 'Torrs':
            formula = 'The value remains unchanged';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.001315789474';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 0.01322773523';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 133.2273523';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.001322773523';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 13.22773523';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.0001934006471';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 193.4006471';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 193,400.6471';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 0.02788900749';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 27.88900749';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 27,889.00749';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.01333333333';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.336';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 0.09704661104';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 3.812726962';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Technical Atmospheres':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 10,133,223.874';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 10,133.223874';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 10.133223874';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 101.33223874';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 10.133223874';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.010133223874';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.000009566007928';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 10,133,223.874';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 101,332.23874';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 10,133.223874';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Technical Atmospheres':
            formula = 'The value remains unchanged';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 0.1000665';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 1,000.665';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.01000665';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 100.0665';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.001450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 1.450377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 1,450.377378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 0.000208854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 208.854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 208,854.342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.001333223874';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.03386389';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 9.704661104';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.3812726962';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kilogram-force per Square Centimeter':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 980,665,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 980,665';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 980.665';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 9,806.65';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 9.80665';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.00980665';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.009677419354';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 980,665';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 9,806.65';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 0.980665';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.009677419354';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'The value remains unchanged';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 10,000';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.01';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 100';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.0001450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 145.0377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 0.0208854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 20,885.4342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 20,885,434.2';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.01333333333';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.336';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 9.704661104';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.3812726962';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kilogram-force per Square Meter':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 9,806,650';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 9,806.65';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 9.80665';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 98.0665';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 0.0980665';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.0000980665';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.00009765625';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 9,806.65';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 98.0665';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 0.00980665';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.00009765625';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 0.0001';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'The value remains unchanged';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.0000001';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 0.01';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.0000001450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 0.1450377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 145,037.7378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 0.0000208854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.00001333333333';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.000336';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 0.000009704661104';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.0003812726962';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kiloponds per Square Centimeter':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 9,806,650,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 9,806,650';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 9,806.65';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 98,066.5';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 980.665';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.980665';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.96875';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 9,806,650';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 98,066.5';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 9.80665';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.96875';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 10';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 100,000';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'The value remains unchanged';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 10,000';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.01450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 14.50377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 14,503.77378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 2.08854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 2,088,543.42';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 2,088,543,420';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.01333333333';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.336';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 9.704661104';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.3812726962';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kiloponds per Square Meter':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 980,665,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 980,665';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 980.665';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 9,806.65';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 0.980665';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.000980665';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.00096875';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 980,665';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 9,806.65';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 0.980665';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 7,500,620';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.00096875';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 0.0001';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 10,000';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.00001';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'The value remains unchanged';
            break;
          case 'Pounds per Square Inch':
            formula = 'Multiply the pressure value by 0.00001450377378';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 0.1450377378';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 145.0377378';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 0.0000208854342';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 20.8854342';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 20,885.4342';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.00001333333333';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.000336';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 0.000009704661104';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 0.0003812726962';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Pounds per Square Inch':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 6,894,757.293';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 6,894,757.293';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 6,894.757293';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 68.94757293';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 0.06894757293';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.00006894757293';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 0.06804596386';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 6,894,757.293';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 68,947.57293';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 6.894757293';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 5,171,494.539';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 5,171,494.539';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 0.06804596386';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 0.070307';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 703.06958';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 0.0070307';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 70.307';
            break;
          case 'Pounds per Square Inch':
            formula = 'The value remains unchanged';
            break;
          case 'Kilopounds per Square Inch':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 1,000,000';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 144';
            break;
          case 'Kilopounds per Square Foot':
            formula = 'Multiply the pressure value by 144,000';
            break;
          case 'Megapounds per Square Foot':
            formula = 'Multiply the pressure value by 144,000,000';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 0.06894757293';
            break;
          case 'Inches of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 2.036019'; // Rounded for brevity
            break;
          case 'Millimetres of water column':
            formula =
                'Multiply the pressure value by 0.01973729354'; // Rounded for brevity
            break;
          case 'Inches of water column':
            formula =
                'Multiply the pressure value by 0.073557361'; // Rounded for brevity
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kilopounds per Square Inch':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 6,894,757,293';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 6,894,757,293';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 6,894,757.293';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 68,947,572.93';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 68,947.57293';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 68.94757293';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 68.04596386';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 6,894,757,293';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 68,947,572.93';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 6,894,757.293';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 5,171,494,539';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 5,171,494,539';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 68.04596386';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula = 'Multiply the pressure value by 70,307';
            break;
          case 'Kilogram-force per Square Meter':
            formula = 'Multiply the pressure value by 703,069.58';
            break;
          case 'Kiloponds per Square Centimeter':
            formula = 'Multiply the pressure value by 7.0307';
            break;
          case 'Kiloponds per Square Meter':
            formula = 'Multiply the pressure value by 70,307';
            break;
          case 'Pounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.001'; // 1 Kilopound per Square Inch equals 1,000 Pounds per Square Inch
            break;
          case 'Kilopounds per Square Inch':
            formula = 'The value remains unchanged';
            break;
          case 'Megapounds per Square Inch':
            formula = 'Multiply the pressure value by 1,000';
            break;
          case 'Pounds per Square Foot':
            formula = 'Multiply the pressure value by 144,000';
            break;
          case 'Kilopounds per Square Foot':
            formula =
                'Multiply the pressure value by 144'; // 1 Kilopound per Square Foot equals 144 Pounds per Square Foot
            break;
          case 'Megapounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.001'; // 1 Megapound per Square Foot equals 1,000 Kilopounds per Square Foot
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 68,947.57293';
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'Multiply the pressure value by 2,036.019';
            break;
          case 'Millimetres of water column':
            formula = 'Multiply the pressure value by 19,737.29354';
            break;
          case 'Inches of water column':
            formula = 'Multiply the pressure value by 73,557.361';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Megapounds per Square Inch':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 6,894,757,293,000';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 6,894,757,293,000';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 6,894,757,293';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 68,947,572,930';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 68,947,572.93';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 68,947.57293';
            break;
          case 'Atmospheres':
            formula = 'Multiply the pressure value by 68,045.96386';
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 6,894,757,293,000';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 68,947,572,930';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 6,894,757,293';
            break;
          case 'Millitorrs':
            formula = 'Multiply the pressure value by 5,171,494,539,000';
            break;
          case 'Torrs':
            formula = 'Multiply the pressure value by 5,171,494,539,000';
            break;
          case 'Technical Atmospheres':
            formula = 'Multiply the pressure value by 68,045.96386';
            break;
          case 'Kilogram-force per Square Centimeter':
            formula =
                'Multiply the pressure value by 703,070.30696'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Meter':
            formula =
                'Multiply the pressure value by 7,030,703,069.6'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Centimeter':
            formula =
                'Multiply the pressure value by 70,307.030696'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Meter':
            formula =
                'Multiply the pressure value by 703,070,306.96'; // Rounded for brevity
            break;
          case 'Pounds per Square Inch':
            formula =
                'Multiply the pressure value by 1,000,000'; // 1 Megapound per Square Inch equals 1,000,000 Pounds per Square Inch
            break;
          case 'Kilopounds per Square Inch':
            formula =
                'Multiply the pressure value by 1,000'; // 1 Megapound per Square Inch equals 1,000 Kilopounds per Square Inch
            break;
          case 'Megapounds per Square Inch':
            formula = 'The value remains unchanged';
            break;
          case 'Pounds per Square Foot':
            formula =
                'Multiply the pressure value by 144,000,000'; // 1 Megapound per Square Foot equals 144,000,000 Pounds per Square Foot
            break;
          case 'Kilopounds per Square Foot':
            formula =
                'Multiply the pressure value by 144,000'; // 1 Megapound per Square Foot equals 144,000 Kilopounds per Square Foot
            break;
          case 'Megapounds per Square Foot':
            formula =
                'Multiply the pressure value by 1,000'; // 1 Megapound per Square Foot equals 1,000 Kilopounds per Square Foot
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'Multiply the pressure value by 68,947.57293';
            break;
          case 'Inches of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 2,036,019'; // Rounded for brevity
            break;
          case 'Millimetres of water column':
            formula =
                'Multiply the pressure value by 19,737,293.54'; // Rounded for brevity
            break;
          case 'Inches of water column':
            formula =
                'Multiply the pressure value by 73,557.361'; // Rounded for brevity
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Pounds per Square Foot':
        switch (toUnit) {
          case 'Micropascals':
            formula =
                'Multiply the pressure value by 47,880.26'; // Rounded for brevity
            break;
          case 'Millipascals':
            formula =
                'Multiply the pressure value by 47,880,260'; // Rounded for brevity
            break;
          case 'Pascals':
            formula =
                'Multiply the pressure value by 47,880.26'; // Rounded for brevity
            break;
          case 'Hectopascals':
            formula =
                'Multiply the pressure value by 478.8026'; // Rounded for brevity
            break;
          case 'Kilopascals':
            formula =
                'Multiply the pressure value by 0.4788026'; // Rounded for brevity
            break;
          case 'Megapascals':
            formula =
                'Multiply the pressure value by 0.0004788026'; // Rounded for brevity
            break;
          case 'Atmospheres':
            formula =
                'Multiply the pressure value by 0.000472537509'; // Rounded for brevity
            break;
          case 'Microbars':
            formula =
                'Multiply the pressure value by 47,880,260'; // Rounded for brevity
            break;
          case 'Millibars':
            formula =
                'Multiply the pressure value by 478,802.6'; // Rounded for brevity
            break;
          case 'Bars':
            formula =
                'Multiply the pressure value by 47.88026'; // Rounded for brevity
            break;
          case 'Millitorrs':
            formula =
                'Multiply the pressure value by 35,975,428.64'; // Rounded for brevity
            break;
          case 'Torrs':
            formula =
                'Multiply the pressure value by 35,975,428.64'; // Rounded for brevity
            break;
          case 'Technical Atmospheres':
            formula =
                'Multiply the pressure value by 0.000472537509'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.0488279966'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Meter':
            formula =
                'Multiply the pressure value by 488.2799656'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.0048827997'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Meter':
            formula =
                'Multiply the pressure value by 48.82799656'; // Rounded for brevity
            break;
          case 'Pounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.00694444444'; // 1 Pound per Square Foot equals 0.00694444444 Pounds per Square Inch
            break;
          case 'Kilopounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.00000694444444'; // 1 Pound per Square Foot equals 0.00000694444444 Kilopounds per Square Inch
            break;
          case 'Megapounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.00000000694444444'; // 1 Pound per Square Foot equals 0.00000000694444444 Megapounds per Square Inch
            break;
          case 'Pounds per Square Foot':
            formula = 'The value remains unchanged';
            break;
          case 'Kilopounds per Square Foot':
            formula =
                'Multiply the pressure value by 1,000'; // 1 Pound per Square Foot equals 1,000 Kilopounds per Square Foot
            break;
          case 'Megapounds per Square Foot':
            formula =
                'Multiply the pressure value by 1,000,000'; // 1 Pound per Square Foot equals 1,000,000 Megapounds per Square Foot
            break;
          case 'Millimetres of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 0.4788026'; // Rounded for brevity
            break;
          case 'Inches of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 14.14826333'; // Rounded for brevity
            break;
          case 'Millimetres of water column':
            formula =
                'Multiply the pressure value by 0.137893931'; // Rounded for brevity
            break;
          case 'Inches of water column':
            formula =
                'Multiply the pressure value by 0.539267152'; // Rounded for brevity
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kilopounds per Square Foot':
        switch (toUnit) {
          case 'Micropascals':
            formula =
                'Multiply the pressure value by 47,880,260,000'; // Rounded for brevity
            break;
          case 'Millipascals':
            formula =
                'Multiply the pressure value by 47,880,260,000'; // Rounded for brevity
            break;
          case 'Pascals':
            formula =
                'Multiply the pressure value by 47,880,260'; // Rounded for brevity
            break;
          case 'Hectopascals':
            formula =
                'Multiply the pressure value by 478,802.6'; // Rounded for brevity
            break;
          case 'Kilopascals':
            formula =
                'Multiply the pressure value by 478.8026'; // Rounded for brevity
            break;
          case 'Megapascals':
            formula =
                'Multiply the pressure value by 0.4788026'; // Rounded for brevity
            break;
          case 'Atmospheres':
            formula =
                'Multiply the pressure value by 0.472537509'; // Rounded for brevity
            break;
          case 'Microbars':
            formula =
                'Multiply the pressure value by 47,880,260,000'; // Rounded for brevity
            break;
          case 'Millibars':
            formula =
                'Multiply the pressure value by 478,802,600'; // Rounded for brevity
            break;
          case 'Bars':
            formula =
                'Multiply the pressure value by 47,880.26'; // Rounded for brevity
            break;
          case 'Millitorrs':
            formula =
                'Multiply the pressure value by 35,975,428,640'; // Rounded for brevity
            break;
          case 'Torrs':
            formula =
                'Multiply the pressure value by 35,975,428,640'; // Rounded for brevity
            break;
          case 'Technical Atmospheres':
            formula =
                'Multiply the pressure value by 0.472537509'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Centimeter':
            formula =
                'Multiply the pressure value by 48,827.9966'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Meter':
            formula =
                'Multiply the pressure value by 488,279.9656'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Centimeter':
            formula =
                'Multiply the pressure value by 4.88279966'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Meter':
            formula =
                'Multiply the pressure value by 48,827.99656'; // Rounded for brevity
            break;
          case 'Pounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.00000694444444'; // 1 Kilopound per Square Foot equals 0.00000694444444 Pounds per Square Inch
            break;
          case 'Kilopounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.001'; // 1 Kilopound per Square Foot equals 0.001 Kilopounds per Square Inch
            break;
          case 'Megapounds per Square Inch':
            formula =
                'Multiply the pressure value by 1,000'; // 1 Kilopound per Square Foot equals 1,000 Megapounds per Square Inch
            break;
          case 'Pounds per Square Foot':
            formula =
                'Multiply the pressure value by 1,000'; // 1 Kilopound per Square Foot equals 1,000 Pounds per Square Foot
            break;
          case 'Kilopounds per Square Foot':
            formula = 'The value remains unchanged';
            break;
          case 'Megapounds per Square Foot':
            formula =
                'Multiply the pressure value by 1,000,000'; // 1 Kilopound per Square Foot equals 1,000,000 Megapounds per Square Foot
            break;
          case 'Millimetres of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 478,802.6'; // Rounded for brevity
            break;
          case 'Inches of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 14,148.26333'; // Rounded for brevity
            break;
          case 'Millimetres of water column':
            formula =
                'Multiply the pressure value by 137,893.931'; // Rounded for brevity
            break;
          case 'Inches of water column':
            formula =
                'Multiply the pressure value by 539,267.152'; // Rounded for brevity
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Megapounds per Square Foot':
        switch (toUnit) {
          case 'Micropascals':
            formula =
                'Multiply the pressure value by 47,880,260,000,000'; // Rounded for brevity
            break;
          case 'Millipascals':
            formula =
                'Multiply the pressure value by 47,880,260,000,000'; // Rounded for brevity
            break;
          case 'Pascals':
            formula =
                'Multiply the pressure value by 47,880,260,000'; // Rounded for brevity
            break;
          case 'Hectopascals':
            formula =
                'Multiply the pressure value by 478,802,600,000'; // Rounded for brevity
            break;
          case 'Kilopascals':
            formula =
                'Multiply the pressure value by 478,802,600'; // Rounded for brevity
            break;
          case 'Megapascals':
            formula =
                'Multiply the pressure value by 478,802.6'; // Rounded for brevity
            break;
          case 'Atmospheres':
            formula =
                'Multiply the pressure value by 472,537.509'; // Rounded for brevity
            break;
          case 'Microbars':
            formula =
                'Multiply the pressure value by 47,880,260,000,000'; // Rounded for brevity
            break;
          case 'Millibars':
            formula =
                'Multiply the pressure value by 478,802,600,000'; // Rounded for brevity
            break;
          case 'Bars':
            formula =
                'Multiply the pressure value by 47,880,260,000'; // Rounded for brevity
            break;
          case 'Millitorrs':
            formula =
                'Multiply the pressure value by 35,975,428,640,000'; // Rounded for brevity
            break;
          case 'Torrs':
            formula =
                'Multiply the pressure value by 35,975,428,640,000'; // Rounded for brevity
            break;
          case 'Technical Atmospheres':
            formula =
                'Multiply the pressure value by 472,537.509'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Centimeter':
            formula =
                'Multiply the pressure value by 48,827,996.6'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Meter':
            formula =
                'Multiply the pressure value by 488,279,965.6'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Centimeter':
            formula =
                'Multiply the pressure value by 4,882,799.66'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Meter':
            formula =
                'Multiply the pressure value by 48,827,996.56'; // Rounded for brevity
            break;
          case 'Pounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.0000006944444444'; // 1 Megapound per Square Foot equals 0.0000006944444444 Pounds per Square Inch
            break;
          case 'Kilopounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.000001'; // 1 Megapound per Square Foot equals 0.000001 Kilopounds per Square Inch
            break;
          case 'Megapounds per Square Inch':
            formula =
                'Multiply the pressure value by 1,000'; // 1 Megapound per Square Foot equals 1,000 Megapounds per Square Inch
            break;
          case 'Pounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.000001'; // 1 Megapound per Square Foot equals 0.000001 Pounds per Square Foot
            break;
          case 'Kilopounds per Square Foot':
            formula =
                'Multiply the pressure value by 1,000,000'; // 1 Megapound per Square Foot equals 1,000,000 Kilopounds per Square Foot
            break;
          case 'Megapounds per Square Foot':
            formula = 'The value remains unchanged';
            break;
          case 'Millimetres of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 478,802.6'; // Rounded for brevity
            break;
          case 'Inches of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 14,148.26333'; // Rounded for brevity
            break;
          case 'Millimetres of water column':
            formula =
                'Multiply the pressure value by 137,893.931'; // Rounded for brevity
            break;
          case 'Inches of water column':
            formula =
                'Multiply the pressure value by 539,267.152'; // Rounded for brevity
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Millimetres of Mercury (0°C)':
        switch (toUnit) {
          case 'Micropascals':
            formula = 'Multiply the pressure value by 1,359,511.632';
            break;
          case 'Millipascals':
            formula = 'Multiply the pressure value by 1,359,511,632';
            break;
          case 'Pascals':
            formula = 'Multiply the pressure value by 1,359,511.632';
            break;
          case 'Hectopascals':
            formula = 'Multiply the pressure value by 13.59511632';
            break;
          case 'Kilopascals':
            formula = 'Multiply the pressure value by 0.01359511632';
            break;
          case 'Megapascals':
            formula = 'Multiply the pressure value by 0.00001359511632';
            break;
          case 'Atmospheres':
            formula =
                'Multiply the pressure value by 0.00001333223753'; // Rounded for brevity
            break;
          case 'Microbars':
            formula = 'Multiply the pressure value by 1,359,511,632';
            break;
          case 'Millibars':
            formula = 'Multiply the pressure value by 13,595.11632';
            break;
          case 'Bars':
            formula = 'Multiply the pressure value by 0.01359511632';
            break;
          case 'Millitorrs':
            formula =
                'Multiply the pressure value by 10,197.17617168'; // Rounded for brevity
            break;
          case 'Torrs':
            formula =
                'Multiply the pressure value by 10,197.17617168'; // Rounded for brevity
            break;
          case 'Technical Atmospheres':
            formula =
                'Multiply the pressure value by 0.00001333223753'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.001359511632'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Meter':
            formula =
                'Multiply the pressure value by 13.59511632'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.00001359511632'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Meter':
            formula =
                'Multiply the pressure value by 0.1359511632'; // Rounded for brevity
            break;
          case 'Pounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.01933677498'; // Rounded for brevity
            break;
          case 'Kilopounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.00001933677498'; // Rounded for brevity
            break;
          case 'Megapounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.00000001933677498'; // Rounded for brevity
            break;
          case 'Pounds per Square Foot':
            formula =
                'Multiply the pressure value by 13.59511632'; // Rounded for brevity
            break;
          case 'Kilopounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.01359511632'; // Rounded for brevity
            break;
          case 'Megapounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.00001359511632'; // Rounded for brevity
            break;
          case 'Millimetres of Mercury (0°C)':
            formula = 'The value remains unchanged';
            break;
          case 'Inches of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 0.03937007874'; // 1 Millimetre of Mercury (0°C) equals 0.03937007874 Inches of Mercury (0°C)
            break;
          case 'Millimetres of water column':
            formula =
                'Multiply the pressure value by 0.40146318083'; // Rounded for brevity
            break;
          case 'Inches of water column':
            formula =
                'Multiply the pressure value by 1.57828282828'; // Rounded for brevity
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Inches of Mercury (0°C)':
        switch (toUnit) {
          case 'Micropascals':
            formula =
                'Multiply the pressure value by 3,386,389.11'; // Rounded for brevity
            break;
          case 'Millipascals':
            formula =
                'Multiply the pressure value by 3,386,389,110'; // Rounded for brevity
            break;
          case 'Pascals':
            formula =
                'Multiply the pressure value by 3,386,389.11'; // Rounded for brevity
            break;
          case 'Hectopascals':
            formula =
                'Multiply the pressure value by 33.8638911'; // Rounded for brevity
            break;
          case 'Kilopascals':
            formula =
                'Multiply the pressure value by 0.0338638911'; // Rounded for brevity
            break;
          case 'Megapascals':
            formula =
                'Multiply the pressure value by 0.0000338638911'; // Rounded for brevity
            break;
          case 'Atmospheres':
            formula =
                'Multiply the pressure value by 0.00003327650879'; // Rounded for brevity
            break;
          case 'Microbars':
            formula =
                'Multiply the pressure value by 3,386,389,110'; // Rounded for brevity
            break;
          case 'Millibars':
            formula =
                'Multiply the pressure value by 33,863.8911'; // Rounded for brevity
            break;
          case 'Bars':
            formula =
                'Multiply the pressure value by 0.0338638911'; // Rounded for brevity
            break;
          case 'Millitorrs':
            formula =
                'Multiply the pressure value by 25,400.0000635'; // Rounded for brevity
            break;
          case 'Torrs':
            formula =
                'Multiply the pressure value by 25,400.0000635'; // Rounded for brevity
            break;
          case 'Technical Atmospheres':
            formula =
                'Multiply the pressure value by 0.00003327650879'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.00338638911'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Meter':
            formula =
                'Multiply the pressure value by 33.8638911'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.0000338638911'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Meter':
            formula =
                'Multiply the pressure value by 0.338638911'; // Rounded for brevity
            break;
          case 'Pounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.49115408433'; // Rounded for brevity
            break;
          case 'Kilopounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.00049115408433'; // Rounded for brevity
            break;
          case 'Megapounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.00000049115408433'; // Rounded for brevity
            break;
          case 'Pounds per Square Foot':
            formula =
                'Multiply the pressure value by 33.8638911'; // Rounded for brevity
            break;
          case 'Kilopounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.0338638911'; // Rounded for brevity
            break;
          case 'Megapounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.0000338638911'; // Rounded for brevity
            break;
          case 'Millimetres of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 25.4'; // 1 Inch of Mercury (0°C) equals 25.4 Millimetres of Mercury (0°C)
            break;
          case 'Inches of Mercury (0°C)':
            formula = 'The value remains unchanged';
            break;
          case 'Millimetres of water column':
            formula =
                'Multiply the pressure value by 10.1971621298'; // Rounded for brevity
            break;
          case 'Inches of water column':
            formula =
                'Multiply the pressure value by 40.0000635'; // Rounded for brevity
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Millimetres of water column':
        switch (toUnit) {
          case 'Micropascals':
            formula =
                'Multiply the pressure value by 9,806.65'; // Rounded for brevity
            break;
          case 'Millipascals':
            formula =
                'Multiply the pressure value by 9,806,650'; // Rounded for brevity
            break;
          case 'Pascals':
            formula =
                'Multiply the pressure value by 9,806.65'; // Rounded for brevity
            break;
          case 'Hectopascals':
            formula =
                'Multiply the pressure value by 98.0665'; // Rounded for brevity
            break;
          case 'Kilopascals':
            formula =
                'Multiply the pressure value by 0.0980665'; // Rounded for brevity
            break;
          case 'Megapascals':
            formula =
                'Multiply the pressure value by 0.0000980665'; // Rounded for brevity
            break;
          case 'Atmospheres':
            formula =
                'Multiply the pressure value by 0.00009678448352'; // Rounded for brevity
            break;
          case 'Microbars':
            formula =
                'Multiply the pressure value by 9,806,650'; // Rounded for brevity
            break;
          case 'Millibars':
            formula =
                'Multiply the pressure value by 98.0665'; // Rounded for brevity
            break;
          case 'Bars':
            formula =
                'Multiply the pressure value by 0.0980665'; // Rounded for brevity
            break;
          case 'Millitorrs':
            formula =
                'Multiply the pressure value by 74.7327'; // Rounded for brevity
            break;
          case 'Torrs':
            formula =
                'Multiply the pressure value by 74.7327'; // Rounded for brevity
            break;
          case 'Technical Atmospheres':
            formula =
                'Multiply the pressure value by 0.00009678448352'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.009980392'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Meter':
            formula =
                'Multiply the pressure value by 98.0665'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.0000980665'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Meter':
            formula =
                'Multiply the pressure value by 0.980665'; // Rounded for brevity
            break;
          case 'Pounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.014223343'; // Rounded for brevity
            break;
          case 'Kilopounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.000014223343'; // Rounded for brevity
            break;
          case 'Megapounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.000000014223343'; // Rounded for brevity
            break;
          case 'Pounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.980665'; // Rounded for brevity
            break;
          case 'Kilopounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.0980665'; // Rounded for brevity
            break;
          case 'Megapounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.0000980665'; // Rounded for brevity
            break;
          case 'Millimetres of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 0.03937007874'; // Rounded for brevity
            break;
          case 'Inches of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 1.0000000007969'; // Rounded for brevity
            break;
          case 'Millimetres of water column':
            formula = 'The value remains unchanged';
            break;
          case 'Inches of water column':
            formula =
                'Multiply the pressure value by 0.3937007874'; // 1 Millimetre of water column equals 0.3937007874 Inches of water column
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Inches of water column':
        switch (toUnit) {
          case 'Micropascals':
            formula =
                'Multiply the pressure value by 25,400'; // Rounded for brevity
            break;
          case 'Millipascals':
            formula =
                'Multiply the pressure value by 25,400,000'; // Rounded for brevity
            break;
          case 'Pascals':
            formula =
                'Multiply the pressure value by 25,400'; // Rounded for brevity
            break;
          case 'Hectopascals':
            formula =
                'Multiply the pressure value by 254'; // Rounded for brevity
            break;
          case 'Kilopascals':
            formula =
                'Multiply the pressure value by 0.254'; // Rounded for brevity
            break;
          case 'Megapascals':
            formula =
                'Multiply the pressure value by 0.000254'; // Rounded for brevity
            break;
          case 'Atmospheres':
            formula =
                'Multiply the pressure value by 0.00024908890653'; // Rounded for brevity
            break;
          case 'Microbars':
            formula =
                'Multiply the pressure value by 25,400,000'; // Rounded for brevity
            break;
          case 'Millibars':
            formula =
                'Multiply the pressure value by 254'; // Rounded for brevity
            break;
          case 'Bars':
            formula =
                'Multiply the pressure value by 0.254'; // Rounded for brevity
            break;
          case 'Millitorrs':
            formula =
                'Multiply the pressure value by 192'; // Rounded for brevity
            break;
          case 'Torrs':
            formula =
                'Multiply the pressure value by 192'; // Rounded for brevity
            break;
          case 'Technical Atmospheres':
            formula =
                'Multiply the pressure value by 0.00024908890653'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.0254'; // Rounded for brevity
            break;
          case 'Kilogram-force per Square Meter':
            formula =
                'Multiply the pressure value by 254'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Centimeter':
            formula =
                'Multiply the pressure value by 0.000254'; // Rounded for brevity
            break;
          case 'Kiloponds per Square Meter':
            formula =
                'Multiply the pressure value by 2.54'; // Rounded for brevity
            break;
          case 'Pounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.036127292'; // Rounded for brevity
            break;
          case 'Kilopounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.000036127292'; // Rounded for brevity
            break;
          case 'Megapounds per Square Inch':
            formula =
                'Multiply the pressure value by 0.000000036127292'; // Rounded for brevity
            break;
          case 'Pounds per Square Foot':
            formula =
                'Multiply the pressure value by 2.54'; // Rounded for brevity
            break;
          case 'Kilopounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.254'; // Rounded for brevity
            break;
          case 'Megapounds per Square Foot':
            formula =
                'Multiply the pressure value by 0.000254'; // Rounded for brevity
            break;
          case 'Millimetres of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 0.03937007874'; // Rounded for brevity
            break;
          case 'Inches of Mercury (0°C)':
            formula =
                'Multiply the pressure value by 1.0000000007969'; // Rounded for brevity
            break;
          case 'Millimetres of water column':
            formula =
                'Multiply the pressure value by 2.54000508001'; // Rounded for brevity
            break;
          case 'Inches of water column':
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      default:
        formula = 'No conversion formula available for the selected units';
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
                          '/ '); // Assuming you have this route defined somewhere
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
                    'Convert Pressure',
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
      case 'Micropascals':
        return 'µPa'; // Micropascals
      case 'Millipascals':
        return 'mPa'; // Millipascals
      case 'Pascals':
        return 'Pa'; // Pascals
      case 'Hectopascals':
        return 'hPa'; // Hectopascals
      case 'Kilopascals':
        return 'kPa'; // Kilopascals
      case 'Megapascals':
        return 'MPa'; // Megapascals
      case 'Gigapascals':
        return 'GPa'; // Gigapascals
      case 'Atmospheres':
        return 'atm'; // Atmospheres
      case 'Microbars':
        return 'µbar'; // Microbars
      case 'Millibars':
        return 'mbar'; // Millibars
      case 'Bars':
        return 'bar'; // Bars
      case 'Millitorrs':
        return 'mTorr'; // Millitorrs
      case 'Torrs':
        return 'Torr'; // Torrs
      case 'Technical Atmospheres':
        return 'at'; // Technical Atmospheres
      case 'Kilogram-force per Square Centimeter':
        return 'kgf/cm²'; // Kilogram-force per Square Centimeter
      case 'Kilogram-force per Square Meter':
        return 'kgf/m²'; // Kilogram-force per Square Meter
      case 'Kiloponds per Square Centimeter':
        return 'kpond/cm²'; // Kiloponds per Square Centimeter
      case 'Kiloponds per Square Meter':
        return 'kpond/m²'; // Kiloponds per Square Meter
      case 'Pounds per Square Inch':
        return 'psi'; // Pounds per Square Inch
      case 'Kilopounds per Square Inch':
        return 'kip/in²'; // Kilopounds per Square Inch
      case 'Megapounds per Square Inch':
        return 'Mkip/in²'; // Megapounds per Square Inch
      case 'Pounds per Square Foot':
        return 'psf'; // Pounds per Square Foot
      case 'Kilopounds per Square Foot':
        return 'kip/ft²'; // Kilopounds per Square Foot
      case 'Megapounds per Square Foot':
        return 'Mkip/ft²'; // Megapounds per Square Foot
      case 'Millimetres of Mercury (0°C)':
        return 'mmHg'; // Millimetres of Mercury (0°C)
      case 'Inches of Mercury (0°C)':
        return 'inHg'; // Inches of Mercury (0°C)
      case 'Millimetres of water column':
        return 'mmH₂O'; // Millimetres of water column
      case 'Inches of water column':
        return 'inH₂O'; // Inches of water column
      default:
        return '';
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
      'Micropascals',
      'Millipascals',
      'Pascals',
      'Hectopascals',
      'Kilopascals',
      'Megapascals',
      'Gigapascals',
      'Atmospheres',
      'Microbars',
      'Millibars',
      'Bars',
      'Millitorrs',
      'Torrs',
      'Technical Atmospheres',
      'Kilogram-force per Square Centimeter',
      'Kilogram-force per Square Meter',
      'Kiloponds per Square Centimeter',
      'Kiloponds per Square Meter',
      'Pounds per Square Inch',
      'Kilopounds per Square Inch',
      'Megapounds per Square Inch',
      'Pounds per Square Foot',
      'Kilopounds per Square Foot',
      'Megapounds per Square Foot',
      'Millimetres of Mercury (0°C)',
      'Inches of Mercury (0°C)',
      'Millimetres of water column',
      'Inches of water column',
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
