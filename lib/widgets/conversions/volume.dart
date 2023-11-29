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

class VolumeUnitConverter extends StatefulWidget {
  const VolumeUnitConverter({super.key});

  @override
  _VolumeUnitConverterState createState() => _VolumeUnitConverterState();
}

class _VolumeUnitConverterState extends State<VolumeUnitConverter> {
  static const double mediumFontSize = 17.0;
  GlobalKey tooltipKey = GlobalKey();
  double fontSize = mediumFontSize;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Cubic Metres';
  String toUnit = 'Cubic Inches';
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
          text: 'Check out my volume result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

    switch (fromUnit) {
      // Litres (L) UNIT CONVERSION
      case 'Litres':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue * 1000; // 1 Litre = 1000 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 1000; // 1 Litre = 1000 Millilitres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue * 1; // 1 Litre = 1 Cubic Decimetre
            break;
          case 'Hectolitres':
            toValue = fromValue * 0.01; // 1 Litre = 0.01 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue * 0.001; // 1 Litre = 0.001 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue * 61.0237; // 1 Litre = 61.0237 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue * 0.0353147; // 1 Litre = 0.0353147 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue =
                fromValue * 0.00130795; // 1 Litre = 0.00130795 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue =
                fromValue * 168.936; // 1 Litre = 168.936 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue =
                fromValue * 56.3121; // 1 Litre = 56.3121 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue =
                fromValue * 35.1951; // 1 Litre = 35.1951 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue = fromValue * 3.51951; // 1 Litre = 3.51951 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue * 1.75975; // 1 Litre = 1.75975 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue =
                fromValue * 0.879877; // 1 Litre = 0.879877 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue =
                fromValue * 0.219969; // 1 Litre = 0.219969 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue = fromValue * 202.884; // 1 Litre = 202.884 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue * 67.628; // 1 Litre = 67.628 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue * 33.814; // 1 Litre = 33.814 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 4.22675; // 1 Litre = 4.22675 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue * 2.11338; // 1 Litre = 2.11338 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue * 1.05669; // 1 Litre = 1.05669 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue * 0.264172; // 1 Litre = 0.264172 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue * 0.00838641; // 1 Litre = 0.00838641 Barrels
            break;
          case 'Litres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      // MILLILITRES UNIT CONVERSION
      case 'Millilitres':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue * 1; // 1 Millilitre = 1 Cubic Centimetre
            break;
          case 'Litres':
            toValue = fromValue * 0.001; // 1,000 Millilitres = 1 Litre
            break;
          case 'Cubic Decimetres':
            toValue =
                fromValue * 0.001; // 1,000 Millilitres = 1 Cubic Decimetre
            break;
          case 'Hectolitres':
            toValue = fromValue * 0.00001; // 100,000 Millilitres = 1 Hectolitre
            break;
          case 'Cubic Metres':
            toValue = fromValue * 1e-6; // 1,000,000 Millilitres = 1 Cubic Metre
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 0.0610237; // 1 Millilitre = 0.0610237 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                3.53147e-5; // 1 Millilitre = 0.0000353147 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                1.30795e-6; // 1 Millilitre = 0.00000130795 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue *
                0.168936; // 1 Millilitre = 0.168936 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                0.0563121; // 1 Millilitre = 0.0563121 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                0.0351951; // 1 Millilitre = 0.0351951 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue = fromValue *
                0.00422675; // 1 Millilitre = 0.00422675 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue *
                0.00211338; // 1 Millilitre = 0.00211338 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue = fromValue *
                0.00105669; // 1 Millilitre = 0.00105669 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue = fromValue *
                0.000264172; // 1 Millilitre = 0.000264172 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 0.202884; // 1 Millilitre = 0.202884 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue =
                fromValue * 0.067628; // 1 Millilitre = 0.067628 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue =
                fromValue * 0.033814; // 1 Millilitre = 0.033814 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue =
                fromValue * 0.00416667; // 1 Millilitre = 0.00416667 US Cups
            break;
          case 'Pints (US)':
            toValue =
                fromValue * 0.00211338; // 1 Millilitre = 0.00211338 US Pints
            break;
          case 'Quarts (US)':
            toValue =
                fromValue * 0.00105669; // 1 Millilitre = 0.00105669 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue *
                0.000264172; // 1 Millilitre = 0.000264172 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue *
                0.00000838641; // 1 Millilitre = 0.00000838641 Barrels
            break;
          case 'Millilitres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// CUBIC DECIMETRES UNIT CONVERSION
      case 'Cubic Decimetres':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue =
                fromValue * 1000; // 1 Cubic Decimetre = 1000 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 1000; // 1 Cubic Decimetre = 1000 Millilitres
            break;
          case 'Litres':
            toValue = fromValue; // 1 Cubic Decimetre = 1 Litre (by definition)
            break;
          case 'Hectolitres':
            toValue = fromValue * 0.01; // 100 Cubic Decimetres = 1 Hectolitre
            break;
          case 'Cubic Metres':
            toValue =
                fromValue * 0.001; // 1000 Cubic Decimetres = 1 Cubic Metre
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 61.0237; // 1 Cubic Decimetre = 61.0237 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                0.0353147; // 1 Cubic Decimetre = 0.0353147 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                0.00130795; // 1 Cubic Decimetre = 0.00130795 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue *
                168.936; // 1 Cubic Decimetre = 168.936 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                56.3121; // 1 Cubic Decimetre = 56.3121 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                35.1951; // 1 Cubic Decimetre = 35.1951 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue = fromValue *
                4.39938; // 1 Cubic Decimetre = 4.39938 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue *
                1.75975; // 1 Cubic Decimetre = 1.75975 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue = fromValue *
                0.879877; // 1 Cubic Decimetre = 0.879877 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue = fromValue *
                0.219969; // 1 Cubic Decimetre = 0.219969 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 202.884; // 1 Cubic Decimetre = 202.884 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue =
                fromValue * 67.628; // 1 Cubic Decimetre = 67.628 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue *
                33.814; // 1 Cubic Decimetre = 33.814 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue =
                fromValue * 4.22675; // 1 Cubic Decimetre = 4.22675 US Cups
            break;
          case 'Pints (US)':
            toValue =
                fromValue * 2.11338; // 1 Cubic Decimetre = 2.11338 US Pints
            break;
          case 'Quarts (US)':
            toValue =
                fromValue * 1.05669; // 1 Cubic Decimetre = 1.05669 US Quarts
            break;
          case 'Gallons (US)':
            toValue =
                fromValue * 0.264172; // 1 Cubic Decimetre = 0.264172 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue *
                0.00838641; // 1 Cubic Decimetre = 0.00838641 Barrels
            break;
          case 'Cubic Decimetres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// HECTOLITRES UNIT CONVERSION
      case 'Hectolitres':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue =
                fromValue * 100000; // 1 Hectolitre = 100,000 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 100000; // 1 Hectolitre = 100,000 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 100; // 1 Hectolitre = 100 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue * 100; // 1 Hectolitre = 100 Cubic Decimetres
            break;
          case 'Cubic Metres':
            toValue = fromValue * 0.1; // 10 Hectolitres = 1 Cubic Metre
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 6102.37; // 1 Hectolitre = 6,102.37 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue * 3.53147; // 1 Hectolitre = 3.53147 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue =
                fromValue * 0.130795; // 1 Hectolitre = 0.130795 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue *
                16893.6; // 1 Hectolitre = 16,893.6 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                5631.21; // 1 Hectolitre = 5,631.21 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                3519.51; // 1 Hectolitre = 3,519.51 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue =
                fromValue * 439.938; // 1 Hectolitre = 439.938 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue =
                fromValue * 175.975; // 1 Hectolitre = 175.975 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue =
                fromValue * 87.9877; // 1 Hectolitre = 87.9877 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue =
                fromValue * 21.9969; // 1 Hectolitre = 21.9969 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 20288.4; // 1 Hectolitre = 20,288.4 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue =
                fromValue * 6762.8; // 1 Hectolitre = 6,762.8 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue =
                fromValue * 3381.4; // 1 Hectolitre = 3,381.4 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 422.675; // 1 Hectolitre = 422.675 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue * 211.338; // 1 Hectolitre = 211.338 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue * 105.669; // 1 Hectolitre = 105.669 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue * 26.4172; // 1 Hectolitre = 26.4172 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue * 0.838641; // 1 Hectolitre = 0.838641 Barrels
            break;
          case 'Hectolitres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// CUBIC METRES UNIT CONVERSION
      case 'Cubic Metres':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue =
                fromValue * 1e6; // 1 Cubic Metre = 1,000,000 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 1e6; // 1 Cubic Metre = 1,000,000 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 1000; // 1 Cubic Metre = 1,000 Litres
            break;
          case 'Cubic Decimetres':
            toValue =
                fromValue * 1000; // 1 Cubic Metre = 1,000 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue * 10; // 1 Cubic Metre = 10 Hectolitres
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 61023.7; // 1 Cubic Metre = 61,023.7 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue * 35.3147; // 1 Cubic Metre = 35.3147 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue =
                fromValue * 1.30795; // 1 Cubic Metre = 1.30795 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue *
                168936; // 1 Cubic Metre = 168,936 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                56312.1; // 1 Cubic Metre = 56,312.1 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                35195.1; // 1 Cubic Metre = 35,195.1 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue =
                fromValue * 4399.38; // 1 Cubic Metre = 4,399.38 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue =
                fromValue * 1759.75; // 1 Cubic Metre = 1,759.75 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue =
                fromValue * 879.877; // 1 Cubic Metre = 879.877 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue =
                fromValue * 219.969; // 1 Cubic Metre = 219.969 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 202884; // 1 Cubic Metre = 202,884 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue =
                fromValue * 67628; // 1 Cubic Metre = 67,628 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue =
                fromValue * 33814; // 1 Cubic Metre = 33,814 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 4166.67; // 1 Cubic Metre = 4,166.67 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue * 2113.38; // 1 Cubic Metre = 2,113.38 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue * 1056.69; // 1 Cubic Metre = 1,056.69 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue * 264.172; // 1 Cubic Metre = 264.172 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue *
                6.28981; // 1 Cubic Metre = 6.28981 Barrels (Oil barrels)
            break;
          case 'Cubic Metres': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// CUBIC INCHES UNIT CONVERSION
      case 'Cubic Inches':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue =
                fromValue * 16.3871; // 1 Cubic Inch = 16.3871 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 16.3871; // 1 Cubic Inch = 16.3871 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 0.0163871; // 1 Cubic Inch = 0.0163871 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                0.0163871; // 1 Cubic Inch = 0.0163871 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.000163871; // 1 Cubic Inch = 0.000163871 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                1.63871e-5; // 1 Cubic Inch = 0.0000163871 Cubic Metres
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                0.000578704; // 1 Cubic Inch = 0.000578704 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                2.14335e-5; // 1 Cubic Inch = 0.0000214335 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue *
                2.76837; // 1 Cubic Inch = 2.76837 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                0.92279; // 1 Cubic Inch = 0.92279 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                0.576744; // 1 Cubic Inch = 0.576744 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue =
                fromValue * 0.072093; // 1 Cubic Inch = 0.072093 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue *
                0.0360465; // 1 Cubic Inch = 0.0360465 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue = fromValue *
                0.0180233; // 1 Cubic Inch = 0.0180233 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue = fromValue *
                0.00450582; // 1 Cubic Inch = 0.00450582 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 3.32468; // 1 Cubic Inch = 3.32468 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue =
                fromValue * 1.10823; // 1 Cubic Inch = 1.10823 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue =
                fromValue * 0.554113; // 1 Cubic Inch = 0.554113 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 0.0692641; // 1 Cubic Inch = 0.0692641 US Cups
            break;
          case 'Pints (US)':
            toValue =
                fromValue * 0.0346321; // 1 Cubic Inch = 0.0346321 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue * 0.017316; // 1 Cubic Inch = 0.017316 US Quarts
            break;
          case 'Gallons (US)':
            toValue =
                fromValue * 0.004329; // 1 Cubic Inch = 0.004329 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue * 0.000103072;
            break;
          case 'Cubic Inches': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;

          default:
            // Handle the default case or throw an error
            break;
        }
        break;
// CUBIC FEET UNIT CONVERSION
      case 'Cubic Feet':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                28316.8466; // 1 Cubic Foot = 28,316.8466 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue *
                28316.8466; // 1 Cubic Foot = 28,316.8466 Millilitres
            break;
          case 'Litres':
            toValue =
                fromValue * 28.3168466; // 1 Cubic Foot = 28.3168466 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                28.3168466; // 1 Cubic Foot = 28.3168466 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.283168466; // 1 Cubic Foot = 0.283168466 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                0.0283168466; // 1 Cubic Foot = 0.0283168466 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue * 1728; // 1 Cubic Foot = 1,728 Cubic Inches
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                0.037037037; // 1 Cubic Foot = 0.037037037 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue *
                4783.74; // 1 Cubic Foot = 4,783.74 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                1594.58; // 1 Cubic Foot = 1,594.58 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                996.613; // 1 Cubic Foot = 996.613 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue =
                fromValue * 124.577; // 1 Cubic Foot = 124.577 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue =
                fromValue * 62.2882; // 1 Cubic Foot = 62.2882 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue =
                fromValue * 31.1441; // 1 Cubic Foot = 31.1441 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue =
                fromValue * 7.78602; // 1 Cubic Foot = 7.78602 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 5745.41; // 1 Cubic Foot = 5,745.41 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue =
                fromValue * 1915.14; // 1 Cubic Foot = 1,915.14 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue =
                fromValue * 957.506; // 1 Cubic Foot = 957.506 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 119.688; // 1 Cubic Foot = 119.688 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue * 59.8442; // 1 Cubic Foot = 59.8442 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue * 29.9221; // 1 Cubic Foot = 29.9221 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue * 7.48052; // 1 Cubic Foot = 7.48052 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue *
                0.178107607; // 1 Cubic Foot = 0.178107607 Barrels (Oil barrels)
            break;
          case 'Cubic Feet': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// CUBIC YARDS UNIT CONVERSION
      case 'Cubic Yards':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                764554.858; // 1 Cubic Yard = 764,554.858 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue *
                764554.858; // 1 Cubic Yard = 764,554.858 Millilitres
            break;
          case 'Litres':
            toValue =
                fromValue * 764.554858; // 1 Cubic Yard = 764.554858 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                764.554858; // 1 Cubic Yard = 764.554858 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue =
                fromValue * 7.64554858; // 1 Cubic Yard = 7.64554858 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                0.764554858; // 1 Cubic Yard = 0.764554858 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue * 46656; // 1 Cubic Yard = 46,656 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue * 27; // 1 Cubic Yard = 27 Cubic Feet
            break;
          case 'Teaspoons (lmp)':
            toValue =
                fromValue * 129960; // 1 Cubic Yard = 129,960 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue =
                fromValue * 43320; // 1 Cubic Yard = 43,320 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                27075; // 1 Cubic Yard = 27,075 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue =
                fromValue * 3384.375; // 1 Cubic Yard = 3,384.375 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue *
                1692.1875; // 1 Cubic Yard = 1,692.1875 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue = fromValue *
                846.09375; // 1 Cubic Yard = 846.09375 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue = fromValue *
                211.523438; // 1 Cubic Yard = 211.523438 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue = fromValue *
                155116.052; // 1 Cubic Yard = 155,116.052 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue *
                51705.3507; // 1 Cubic Yard = 51,705.3507 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue *
                25852.6753; // 1 Cubic Yard = 25,852.6753 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue =
                fromValue * 3231.58441; // 1 Cubic Yard = 3,231.58441 US Cups
            break;
          case 'Pints (US)':
            toValue =
                fromValue * 1615.79221; // 1 Cubic Yard = 1,615.79221 US Pints
            break;
          case 'Quarts (US)':
            toValue =
                fromValue * 807.896104; // 1 Cubic Yard = 807.896104 US Quarts
            break;
          case 'Gallons (US)':
            toValue =
                fromValue * 201.974026; // 1 Cubic Yard = 201.974026 US Gallons
            break;
          case 'Barrels':
            toValue =
                fromValue * 4.80890538; // 1 Cubic Yard = 4.80890538 Oil Barrels
            break;
          case 'Cubic Yards': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// TEASPOONS (IMPERIAL) UNIT CONVERSION
      case 'Teaspoons (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                5.91939; // 1 Imperial Teaspoon = 5.91939 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue *
                5.91939; // 1 Imperial Teaspoon = 5.91939 Millilitres
            break;
          case 'Litres':
            toValue = fromValue *
                0.00591939; // 1 Imperial Teaspoon = 0.00591939 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                0.00591939; // 1 Imperial Teaspoon = 0.00591939 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                5.91939e-5; // 1 Imperial Teaspoon = 0.0000591939 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                5.91939e-6; // 1 Imperial Teaspoon = 0.00000591939 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue *
                0.361223; // 1 Imperial Teaspoon = 0.361223 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                0.000208168; // 1 Imperial Teaspoon = 0.000208168 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                7.64555e-6; // 1 Imperial Teaspoon = 0.00000764555 Cubic Yards
            break;
          case 'Teaspoons (US)':
            toValue = fromValue *
                1.20095; // 1 Imperial Teaspoon = 1.20095 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue *
                0.400317; // 1 Imperial Teaspoon = 0.400317 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue *
                0.200158; // 1 Imperial Teaspoon = 0.200158 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue *
                0.0250198; // 1 Imperial Teaspoon = 0.0250198 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue *
                0.0125099; // 1 Imperial Teaspoon = 0.0125099 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue *
                0.00625496; // 1 Imperial Teaspoon = 0.00625496 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue *
                0.00156374; // 1 Imperial Teaspoon = 0.00156374 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue *
                3.69669e-5; // 1 Imperial Teaspoon = 0.0000369669 Barrels
            break;
          case 'Teaspoons (lmp)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// TABLESPOONS (IMPERIAL) UNIT CONVERSION
      case 'Tablespoons (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                17.7582; // 1 Imperial Tablespoon = 17.7582 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue *
                17.7582; // 1 Imperial Tablespoon = 17.7582 Millilitres
            break;
          case 'Litres':
            toValue = fromValue *
                0.0177582; // 1 Imperial Tablespoon = 0.0177582 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                0.0177582; // 1 Imperial Tablespoon = 0.0177582 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.000177582; // 1 Imperial Tablespoon = 0.000177582 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                1.77582e-5; // 1 Imperial Tablespoon = 0.0000177582 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue *
                1.08367; // 1 Imperial Tablespoon = 1.08367 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                0.000624505; // 1 Imperial Tablespoon = 0.000624505 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                2.29295e-5; // 1 Imperial Tablespoon = 0.0000229295 Cubic Yards
            break;
          case 'Teaspoons (US)':
            toValue = fromValue *
                3.60285; // 1 Imperial Tablespoon = 3.60285 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue *
                1.20095; // 1 Imperial Tablespoon = 1.20095 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue *
                0.600475; // 1 Imperial Tablespoon = 0.600475 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue *
                0.0750594; // 1 Imperial Tablespoon = 0.0750594 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue *
                0.0375297; // 1 Imperial Tablespoon = 0.0375297 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue *
                0.0187649; // 1 Imperial Tablespoon = 0.0187649 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue *
                0.00469122; // 1 Imperial Tablespoon = 0.00469122 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue *
                0.00011109; // 1 Imperial Tablespoon = 0.00011109 Barrels
            break;
          case 'Tablespoons (lmp)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// FLUID OUNCES (IMPERIAL) UNIT CONVERSION
      case 'Fluid Ounces (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                28.4131; // 1 Imperial Fluid Ounce = 28.4131 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue *
                28.4131; // 1 Imperial Fluid Ounce = 28.4131 Millilitres
            break;
          case 'Litres':
            toValue = fromValue *
                0.0284131; // 1 Imperial Fluid Ounce = 0.0284131 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                0.0284131; // 1 Imperial Fluid Ounce = 0.0284131 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.000284131; // 1 Imperial Fluid Ounce = 0.000284131 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                2.84131e-5; // 1 Imperial Fluid Ounce = 0.0000284131 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue *
                1.73387; // 1 Imperial Fluid Ounce = 1.73387 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                0.0010034; // 1 Imperial Fluid Ounce = 0.0010034 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                3.7037e-5; // 1 Imperial Fluid Ounce = 0.000037037 Cubic Yards
            break;
          case 'Teaspoons (US)':
            toValue = fromValue *
                6.00721; // 1 Imperial Fluid Ounce = 6.00721 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue *
                2.0024; // 1 Imperial Fluid Ounce = 2.0024 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue *
                1.04084; // 1 Imperial Fluid Ounce = 1.04084 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue *
                0.130105; // 1 Imperial Fluid Ounce = 0.130105 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue *
                0.0650522; // 1 Imperial Fluid Ounce = 0.0650522 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue *
                0.0325261; // 1 Imperial Fluid Ounce = 0.0325261 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue *
                0.00813152; // 1 Imperial Fluid Ounce = 0.00813152 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue *
                0.000178107; // 1 Imperial Fluid Ounce = 0.000178107 Barrels
            break;
          case 'Fluid Ounces (lmp)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// CUPS (IMPERIAL) UNIT CONVERSION
      case 'Cups (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                284.131; // 1 Imperial Cup = 284.131 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue =
                fromValue * 284.131; // 1 Imperial Cup = 284.131 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 0.284131; // 1 Imperial Cup = 0.284131 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                0.284131; // 1 Imperial Cup = 0.284131 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.00284131; // 1 Imperial Cup = 0.00284131 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                0.000284131; // 1 Imperial Cup = 0.000284131 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 17.3387; // 1 Imperial Cup = 17.3387 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue =
                fromValue * 0.0100342; // 1 Imperial Cup = 0.0100342 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                0.00037037; // 1 Imperial Cup = 0.00037037 Cubic Yards
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 48.6922; // 1 Imperial Cup = 48.6922 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue =
                fromValue * 16.2307; // 1 Imperial Cup = 16.2307 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue =
                fromValue * 8.11537; // 1 Imperial Cup = 8.11537 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 1.01442; // 1 Imperial Cup = 1.01442 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue * 0.50721; // 1 Imperial Cup = 0.50721 US Pints
            break;
          case 'Quarts (US)':
            toValue =
                fromValue * 0.253605; // 1 Imperial Cup = 0.253605 US Quarts
            break;
          case 'Gallons (US)':
            toValue =
                fromValue * 0.0634013; // 1 Imperial Cup = 0.0634013 US Gallons
            break;
          case 'Barrels':
            toValue =
                fromValue * 0.00178107; // 1 Imperial Cup = 0.00178107 Barrels
            break;
          case 'Cups (lmp)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// PINTS (IMPERIAL) UNIT CONVERSION
      case 'Pints (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                568.261; // 1 Imperial Pint = 568.261 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue =
                fromValue * 568.261; // 1 Imperial Pint = 568.261 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 0.568261; // 1 Imperial Pint = 0.568261 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                0.568261; // 1 Imperial Pint = 0.568261 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.00568261; // 1 Imperial Pint = 0.00568261 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                0.000568261; // 1 Imperial Pint = 0.000568261 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 34.6774; // 1 Imperial Pint = 34.6774 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue =
                fromValue * 0.0200682; // 1 Imperial Pint = 0.0200682 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                0.000740741; // 1 Imperial Pint = 0.000740741 Cubic Yards
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 97.3844; // 1 Imperial Pint = 97.3844 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue =
                fromValue * 32.4615; // 1 Imperial Pint = 32.4615 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue *
                16.2307; // 1 Imperial Pint = 16.2307 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 2.02884; // 1 Imperial Pint = 2.02884 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue * 1.01442; // 1 Imperial Pint = 1.01442 US Pints
            break;
          case 'Quarts (US)':
            toValue =
                fromValue * 0.50721; // 1 Imperial Pint = 0.50721 US Quarts
            break;
          case 'Gallons (US)':
            toValue =
                fromValue * 0.126802; // 1 Imperial Pint = 0.126802 US Gallons
            break;
          case 'Barrels':
            toValue =
                fromValue * 0.00356214; // 1 Imperial Pint = 0.00356214 Barrels
            break;
          case 'Pints (lmp)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// QUARTS (IMPERIAL) UNIT CONVERSION
      case 'Quarts (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                1136.52; // 1 Imperial Quart = 1136.52 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue =
                fromValue * 1136.52; // 1 Imperial Quart = 1136.52 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 1.13652; // 1 Imperial Quart = 1.13652 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                1.13652; // 1 Imperial Quart = 1.13652 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.0113652; // 1 Imperial Quart = 0.0113652 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                0.00113652; // 1 Imperial Quart = 0.00113652 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 69.3549; // 1 Imperial Quart = 69.3549 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                0.0401359; // 1 Imperial Quart = 0.0401359 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                0.00148148; // 1 Imperial Quart = 0.00148148 Cubic Yards
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 194.768; // 1 Imperial Quart = 194.768 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue *
                64.9227; // 1 Imperial Quart = 64.9227 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue *
                32.4614; // 1 Imperial Quart = 32.4614 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 4.05768; // 1 Imperial Quart = 4.05768 US Cups
            break;
          case 'Pints (US)':
            toValue =
                fromValue * 2.02884; // 1 Imperial Quart = 2.02884 US Pints
            break;
          case 'Quarts (US)':
            toValue =
                fromValue * 1.01442; // 1 Imperial Quart = 1.01442 US Quarts
            break;
          case 'Gallons (US)':
            toValue =
                fromValue * 0.253605; // 1 Imperial Quart = 0.253605 US Gallons
            break;
          case 'Barrels':
            toValue =
                fromValue * 0.00712429; // 1 Imperial Quart = 0.00712429 Barrels
            break;
          case 'Quarts (lmp)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// GALLONS (IMPERIAL) UNIT CONVERSION
      case 'Gallons (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                4546.09; // 1 Imperial Gallon = 4546.09 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue =
                fromValue * 4546.09; // 1 Imperial Gallon = 4546.09 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 4.54609; // 1 Imperial Gallon = 4.54609 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                4.54609; // 1 Imperial Gallon = 4.54609 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.0454609; // 1 Imperial Gallon = 0.0454609 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                0.00454609; // 1 Imperial Gallon = 0.00454609 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 277.419; // 1 Imperial Gallon = 277.419 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue =
                fromValue * 0.160544; // 1 Imperial Gallon = 0.160544 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                0.00594606; // 1 Imperial Gallon = 0.00594606 Cubic Yards
            break;
          case 'Teaspoons (US)':
            toValue =
                fromValue * 779.076; // 1 Imperial Gallon = 779.076 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue *
                259.692; // 1 Imperial Gallon = 259.692 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue *
                153.722; // 1 Imperial Gallon = 153.722 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue =
                fromValue * 16.2307; // 1 Imperial Gallon = 16.2307 US Cups
            break;
          case 'Pints (US)':
            toValue =
                fromValue * 8.11537; // 1 Imperial Gallon = 8.11537 US Pints
            break;
          case 'Quarts (US)':
            toValue =
                fromValue * 4.05768; // 1 Imperial Gallon = 4.05768 US Quarts
            break;
          case 'Gallons (US)':
            toValue =
                fromValue * 1.20095; // 1 Imperial Gallon = 1.20095 US Gallons
            break;
          case 'Barrels':
            toValue =
                fromValue * 0.0285941; // 1 Imperial Gallon = 0.0285941 Barrels
            break;
          case 'Gallons (lmp)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// TEASPOONS (US) UNIT CONVERSION
      case 'Teaspoons (US)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                4.92892; // 1 US Teaspoon = 4.92892 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue =
                fromValue * 4.92892; // 1 US Teaspoon = 4.92892 Millilitres
            break;
          case 'Litres':
            toValue =
                fromValue * 0.00492892; // 1 US Teaspoon = 0.00492892 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                0.00492892; // 1 US Teaspoon = 0.00492892 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                4.92892e-5; // 1 US Teaspoon = 0.0000492892 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                4.92892e-6; // 1 US Teaspoon = 0.00000492892 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 0.300781; // 1 US Teaspoon = 0.300781 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                0.000174063; // 1 US Teaspoon = 0.000174063 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                6.4082e-6; // 1 US Teaspoon = 0.0000064082 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue *
                0.832674; // 1 US Teaspoon = 0.832674 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                0.277558; // 1 US Teaspoon = 0.277558 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                0.173474; // 1 US Teaspoon = 0.173474 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue = fromValue *
                0.0206731; // 1 US Teaspoon = 0.0206731 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue *
                0.0103365; // 1 US Teaspoon = 0.0103365 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue = fromValue *
                0.00516827; // 1 US Teaspoon = 0.00516827 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue = fromValue *
                0.00129207; // 1 US Teaspoon = 0.00129207 Imperial Gallons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue / 3; // 1 US Teaspoon = 1/3 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue / 6; // 1 US Teaspoon = 1/6 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue / 48; // 1 US Teaspoon = 1/48 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue / 96; // 1 US Teaspoon = 1/96 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue / 192; // 1 US Teaspoon = 1/192 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue / 768; // 1 US Teaspoon = 1/768 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue / 32256; // 1 US Teaspoon = 1/32256 Barrels
            break;
          case 'Teaspoons (US)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// TABLESPOONS (US) UNIT CONVERSION
      case 'Tablespoons (US)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                14.7868; // 1 US Tablespoon = 14.7868 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue =
                fromValue * 14.7868; // 1 US Tablespoon = 14.7868 Millilitres
            break;
          case 'Litres':
            toValue =
                fromValue * 0.0147868; // 1 US Tablespoon = 0.0147868 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                0.0147868; // 1 US Tablespoon = 0.0147868 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.000147868; // 1 US Tablespoon = 0.000147868 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                1.47868e-5; // 1 US Tablespoon = 0.0000147868 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 0.902344; // 1 US Tablespoon = 0.902344 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                0.00052219; // 1 US Tablespoon = 0.00052219 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                1.92242e-5; // 1 US Tablespoon = 0.0000192242 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue *
                2.49802; // 1 US Tablespoon = 2.49802 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                0.832674; // 1 US Tablespoon = 0.832674 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                0.520421; // 1 US Tablespoon = 0.520421 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue = fromValue *
                0.0620194; // 1 US Tablespoon = 0.0620194 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue *
                0.0310097; // 1 US Tablespoon = 0.0310097 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue = fromValue *
                0.0155049; // 1 US Tablespoon = 0.0155049 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue = fromValue *
                0.00387622; // 1 US Tablespoon = 0.00387622 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue = fromValue * 3; // 1 US Tablespoon = 3 US Teaspoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue / 2; // 1 US Tablespoon = 1/2 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue / 16; // 1 US Tablespoon = 1/16 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue / 32; // 1 US Tablespoon = 1/32 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue / 64; // 1 US Tablespoon = 1/64 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue / 256; // 1 US Tablespoon = 1/256 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue / 10752; // 1 US Tablespoon = 1/10752 Barrels
            break;
          case 'Tablespoons (US)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// FLUID OUNCES (US) UNIT CONVERSION
      case 'Fluid Ounces (US)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue *
                29.5735; // 1 US Fluid Ounce = 29.5735 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue =
                fromValue * 29.5735; // 1 US Fluid Ounce = 29.5735 Millilitres
            break;
          case 'Litres':
            toValue =
                fromValue * 0.0295735; // 1 US Fluid Ounce = 0.0295735 Litres
            break;
          case 'Cubic Decimetres':
            toValue = fromValue *
                0.0295735; // 1 US Fluid Ounce = 0.0295735 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue *
                0.000295735; // 1 US Fluid Ounce = 0.000295735 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                2.95735e-5; // 1 US Fluid Ounce = 0.0000295735 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue =
                fromValue * 1.80469; // 1 US Fluid Ounce = 1.80469 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue *
                0.00104438; // 1 US Fluid Ounce = 0.00104438 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue *
                3.86807e-5; // 1 US Fluid Ounce = 0.0000386807 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue *
                1.66535; // 1 US Fluid Ounce = 1.66535 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                0.555117; // 1 US Fluid Ounce = 0.555117 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                0.96076; // 1 US Fluid Ounce = 0.96076 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue = fromValue *
                0.120095; // 1 US Fluid Ounce = 0.120095 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue *
                0.0600475; // 1 US Fluid Ounce = 0.0600475 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue = fromValue *
                0.0300238; // 1 US Fluid Ounce = 0.0300238 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue = fromValue *
                0.00750594; // 1 US Fluid Ounce = 0.00750594 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue = fromValue * 6; // 1 US Fluid Ounce = 6 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue * 2; // 1 US Fluid Ounce = 2 US Tablespoons
            break;
          case 'Cups (US)':
            toValue = fromValue / 8; // 1 US Fluid Ounce = 1/8 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue / 16; // 1 US Fluid Ounce = 1/16 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue / 32; // 1 US Fluid Ounce = 1/32 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue / 128; // 1 US Fluid Ounce = 1/128 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue / 5376; // 1 US Fluid Ounce = 1/5376 Barrels
            break;
          case 'Fluid Ounces (US)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// CUPS (US) UNIT CONVERSION
      case 'Cups (US)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue =
                fromValue * 236.588; // 1 US Cup = 236.588 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 236.588; // 1 US Cup = 236.588 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 0.236588; // 1 US Cup = 0.236588 Litres
            break;
          case 'Cubic Decimetres':
            toValue =
                fromValue * 0.236588; // 1 US Cup = 0.236588 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue =
                fromValue * 0.00236588; // 1 US Cup = 0.00236588 Hectolitres
            break;
          case 'Cubic Metres':
            toValue =
                fromValue * 0.000236588; // 1 US Cup = 0.000236588 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue * 14.4375; // 1 US Cup = 14.4375 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue =
                fromValue * 0.00835503; // 1 US Cup = 0.00835503 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue =
                fromValue * 0.000309445; // 1 US Cup = 0.000309445 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue =
                fromValue * 13.3228; // 1 US Cup = 13.3228 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue =
                fromValue * 4.44093; // 1 US Cup = 4.44093 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue =
                fromValue * 2.84131; // 1 US Cup = 2.84131 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue = fromValue * 0.96076; // 1 US Cup = 0.96076 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue * 0.48038; // 1 US Cup = 0.48038 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue = fromValue * 0.24019; // 1 US Cup = 0.24019 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue =
                fromValue * 0.0600475; // 1 US Cup = 0.0600475 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue = fromValue * 48; // 1 US Cup = 48 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue * 16; // 1 US Cup = 16 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue * 8; // 1 US Cup = 8 US Fluid Ounces
            break;
          case 'Pints (US)':
            toValue = fromValue / 2; // 1 US Cup = 1/2 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue / 4; // 1 US Cup = 1/4 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue / 16; // 1 US Cup = 1/16 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue / 672; // 1 US Cup = 1/672 Barrels
            break;
          case 'Cups (US)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// PINTS (US) UNIT CONVERSION
      case 'Pints (US)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue =
                fromValue * 473.176; // 1 US Pint = 473.176 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 473.176; // 1 US Pint = 473.176 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 0.473176; // 1 US Pint = 0.473176 Litres
            break;
          case 'Cubic Decimetres':
            toValue =
                fromValue * 0.473176; // 1 US Pint = 0.473176 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue =
                fromValue * 0.00473176; // 1 US Pint = 0.00473176 Hectolitres
            break;
          case 'Cubic Metres':
            toValue =
                fromValue * 0.000473176; // 1 US Pint = 0.000473176 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue * 28.875; // 1 US Pint = 28.875 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue * 0.0167101; // 1 US Pint = 0.0167101 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue =
                fromValue * 0.000618891; // 1 US Pint = 0.000618891 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue =
                fromValue * 26.6456; // 1 US Pint = 26.6456 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue =
                fromValue * 8.88187; // 1 US Pint = 8.88187 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                5.68261; // 1 US Pint = 5.68261 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue =
                fromValue * 0.710327; // 1 US Pint = 0.710327 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue =
                fromValue * 0.355164; // 1 US Pint = 0.355164 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue =
                fromValue * 0.177582; // 1 US Pint = 0.177582 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue =
                fromValue * 0.0443955; // 1 US Pint = 0.0443955 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue = fromValue * 96; // 1 US Pint = 96 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue * 32; // 1 US Pint = 32 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue * 16; // 1 US Pint = 16 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 2; // 1 US Pint = 2 US Cups
            break;
          case 'Quarts (US)':
            toValue = fromValue / 2; // 1 US Pint = 1/2 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue / 8; // 1 US Pint = 1/8 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue / 336; // 1 US Pint = 1/336 Barrels
            break;
          case 'Pints (US)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// QUARTS (US) UNIT CONVERSION
      case 'Quarts (US)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue =
                fromValue * 946.353; // 1 US Quart = 946.353 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 946.353; // 1 US Quart = 946.353 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 0.946353; // 1 US Quart = 0.946353 Litres
            break;
          case 'Cubic Decimetres':
            toValue =
                fromValue * 0.946353; // 1 US Quart = 0.946353 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue =
                fromValue * 0.00946353; // 1 US Quart = 0.00946353 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue *
                0.000946353; // 1 US Quart = 0.000946353 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue * 57.75; // 1 US Quart = 57.75 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue =
                fromValue * 0.0334201; // 1 US Quart = 0.0334201 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue =
                fromValue * 0.00123778; // 1 US Quart = 0.00123778 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue =
                fromValue * 53.2911; // 1 US Quart = 53.2911 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                17.7637; // 1 US Quart = 17.7637 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                11.1635; // 1 US Quart = 11.1635 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue = fromValue * 1.42065; // 1 US Quart = 1.42065 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue =
                fromValue * 0.710327; // 1 US Quart = 0.710327 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue =
                fromValue * 0.355164; // 1 US Quart = 0.355164 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue = fromValue *
                0.0887905; // 1 US Quart = 0.0887905 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue = fromValue * 192; // 1 US Quart = 192 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue * 64; // 1 US Quart = 64 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue * 32; // 1 US Quart = 32 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 4; // 1 US Quart = 4 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue * 2; // 1 US Quart = 2 US Pints
            break;
          case 'Gallons (US)':
            toValue = fromValue / 4; // 1 US Quart = 1/4 US Gallons
            break;
          case 'Barrels':
            toValue = fromValue / 168; // 1 US Quart = 1/168 Barrels
            break;
          case 'Quarts (US)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// GALLONS (US) UNIT CONVERSION
      case 'Gallons (US)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue =
                fromValue * 3785.41; // 1 US Gallon = 3785.41 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 3785.41; // 1 US Gallon = 3785.41 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 3.78541; // 1 US Gallon = 3.78541 Litres
            break;
          case 'Cubic Decimetres':
            toValue =
                fromValue * 3.78541; // 1 US Gallon = 3.78541 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue =
                fromValue * 0.0378541; // 1 US Gallon = 0.0378541 Hectolitres
            break;
          case 'Cubic Metres':
            toValue =
                fromValue * 0.00378541; // 1 US Gallon = 0.00378541 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue * 231; // 1 US Gallon = 231 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue * 0.133681; // 1 US Gallon = 0.133681 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue =
                fromValue * 0.00495113; // 1 US Gallon = 0.00495113 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue =
                fromValue * 213.165; // 1 US Gallon = 213.165 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue = fromValue *
                71.0551; // 1 US Gallon = 71.0551 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue = fromValue *
                44.6916; // 1 US Gallon = 44.6916 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue =
                fromValue * 5.56849; // 1 US Gallon = 5.56849 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue =
                fromValue * 2.84131; // 1 US Gallon = 2.84131 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue =
                fromValue * 1.42065; // 1 US Gallon = 1.42065 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue =
                fromValue * 0.355164; // 1 US Gallon = 0.355164 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue = fromValue * 768; // 1 US Gallon = 768 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue * 256; // 1 US Gallon = 256 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue * 128; // 1 US Gallon = 128 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 16; // 1 US Gallon = 16 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue * 8; // 1 US Gallon = 8 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue * 4; // 1 US Gallon = 4 US Quarts
            break;
          case 'Barrels':
            toValue = fromValue / 42; // 1 US Gallon = 1/42 Barrels
            break;
          case 'Gallons (US)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

// BARRELS UNIT CONVERSION
      case 'Barrels':
        switch (toUnit) {
          case 'Cubic Centimetres':
            toValue = fromValue * 158987; // 1 Barrel = 158987 Cubic Centimetres
            break;
          case 'Millilitres':
            toValue = fromValue * 158987; // 1 Barrel = 158987 Millilitres
            break;
          case 'Litres':
            toValue = fromValue * 158.987; // 1 Barrel = 158.987 Litres
            break;
          case 'Cubic Decimetres':
            toValue =
                fromValue * 158.987; // 1 Barrel = 158.987 Cubic Decimetres
            break;
          case 'Hectolitres':
            toValue = fromValue * 1.58987; // 1 Barrel = 1.58987 Hectolitres
            break;
          case 'Cubic Metres':
            toValue = fromValue * 0.158987; // 1 Barrel = 0.158987 Cubic Metres
            break;
          case 'Cubic Inches':
            toValue = fromValue * 9702; // 1 Barrel = 9702 Cubic Inches
            break;
          case 'Cubic Feet':
            toValue = fromValue * 5.61458; // 1 Barrel = 5.61458 Cubic Feet
            break;
          case 'Cubic Yards':
            toValue = fromValue * 0.207949; // 1 Barrel = 0.207949 Cubic Yards
            break;
          case 'Teaspoons (lmp)':
            toValue = fromValue * 30720; // 1 Barrel = 30720 Imperial Teaspoons
            break;
          case 'Tablespoons (lmp)':
            toValue =
                fromValue * 10240; // 1 Barrel = 10240 Imperial Tablespoons
            break;
          case 'Fluid Ounces (lmp)':
            toValue =
                fromValue * 6396.26; // 1 Barrel = 6396.26 Imperial Fluid Ounces
            break;
          case 'Cups (lmp)':
            toValue = fromValue * 799.532; // 1 Barrel = 799.532 Imperial Cups
            break;
          case 'Pints (lmp)':
            toValue = fromValue * 399.766; // 1 Barrel = 399.766 Imperial Pints
            break;
          case 'Quarts (lmp)':
            toValue = fromValue * 199.883; // 1 Barrel = 199.883 Imperial Quarts
            break;
          case 'Gallons (lmp)':
            toValue =
                fromValue * 49.9708; // 1 Barrel = 49.9708 Imperial Gallons
            break;
          case 'Teaspoons (US)':
            toValue = fromValue * 32256; // 1 Barrel = 32256 US Teaspoons
            break;
          case 'Tablespoons (US)':
            toValue = fromValue * 10752; // 1 Barrel = 10752 US Tablespoons
            break;
          case 'Fluid Ounces (US)':
            toValue = fromValue * 5376; // 1 Barrel = 5376 US Fluid Ounces
            break;
          case 'Cups (US)':
            toValue = fromValue * 672; // 1 Barrel = 672 US Cups
            break;
          case 'Pints (US)':
            toValue = fromValue * 336; // 1 Barrel = 336 US Pints
            break;
          case 'Quarts (US)':
            toValue = fromValue * 168; // 1 Barrel = 168 US Quarts
            break;
          case 'Gallons (US)':
            toValue = fromValue * 42; // 1 Barrel = 42 US Gallons
            break;
          case 'Barrels': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      // Additional case statements for other fromUnits can be added following the same pattern

      default:
        // Handle the case where fromUnit is not recognized
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
      case 'Cubic Centimetres':
        switch (toUnit) {
          case 'Millilitres':
            formula =
                'The volume value remains unchanged (1 cubic centimetre = 1 millilitre)';
            break;
          case 'Litres':
            formula = 'Divide the volume value by 1,000';
            break;
          case 'Cubic Decimetres':
            formula =
                'Divide the volume value by 1,000 (since 1 cubic decimetre = 1 litre)';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 100,000';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 1,000,000';
            break;
          case 'Cubic Inches':
            formula =
                'Multiply the volume value by 0.0610237 (since 1 cubic centimetre = 0.0610237 cubic inches)';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 28,316.8466';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 764,554.858';
            break;
          case 'Teaspoons (US)':
            formula =
                'Multiply the volume value by 0.202884 (since 1 cubic centimetre = approximately 0.202884 US teaspoons)';
            break;
          case 'Tablespoons (US)':
            formula =
                'Multiply the volume value by 0.067628 (since 1 cubic centimetre = approximately 0.067628 US tablespoons)';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Divide the volume value by 29.5735';
            break;
          case 'Cups (US)':
            formula = 'Divide the volume value by 236.588';
            break;
          case 'Pints (US)':
            formula = 'Divide the volume value by 473.176';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 946.353';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 3,785.41';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 158,987.3';
            break;
          case 'Cubic Centimetres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Millilitres':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula =
                'The volume value remains unchanged (1 millilitre = 1 cubic centimetre)';
            break;
          case 'Litres':
            formula = 'Divide the volume value by 1,000';
            break;
          case 'Cubic Decimetres':
            formula =
                'Divide the volume value by 1,000 (since 1 cubic decimetre = 1 litre)';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 100,000';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 1,000,000';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 0.0610237';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 28,316.8466';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 764,554.858';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 0.202884';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 0.067628';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Divide the volume value by 29.5735';
            break;
          case 'Cups (US)':
            formula = 'Divide the volume value by 236.588';
            break;
          case 'Pints (US)':
            formula = 'Divide the volume value by 473.176';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 946.353';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 3,785.41';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 158,987.3';
            break;
          case 'Millilitres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Litres':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 1,000';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 1,000';
            break;
          case 'Cubic Decimetres':
            formula =
                'The volume value remains unchanged (since 1 litre = 1 cubic decimetre)';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 100';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 1,000';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 61.0237';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 28.3168466';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 764.554858';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 202.884';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 67.628';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 33.814';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 4.22675';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 2.11338';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 1.05669';
            break;
          case 'Gallons (US)':
            formula = 'Multiply the volume value by 0.264172';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 119.24';
            break;
          case 'Litres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Cubic Decimetres': // Note: 1 cubic decimetre = 1 litre
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 1,000';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 1,000';
            break;
          case 'Litres':
            formula = 'The volume value remains unchanged';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 100';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 1,000';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 61.0237';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 28.3168466';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 764.554858';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 202.884';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 67.628';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 33.814';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 4.22675';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 2.11338';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 1.05669';
            break;
          case 'Gallons (US)':
            formula = 'Multiply the volume value by 0.264172';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 119.24';
            break;
          case 'Cubic Decimetres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Hectolitres': // Note: 1 hectolitre = 100 litres
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 100,000';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 100,000';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 100';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 100';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.1';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 6,102.37';
            break;
          case 'Cubic Feet':
            formula = 'Multiply the volume value by 3.53147';
            break;
          case 'Cubic Yards':
            formula = 'Multiply the volume value by 0.130795';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 20,288.4';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 6,762.8';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 3,381.4';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 422.675';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 211.338';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 105.669';
            break;
          case 'Gallons (US)':
            formula = 'Multiply the volume value by 26.4172';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 1.1924';
            break;
          case 'Hectolitres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Cubic Metres':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 1,000,000';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 1,000,000';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 1,000';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 1,000';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 10';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 61,023.7441';
            break;
          case 'Cubic Feet':
            formula = 'Multiply the volume value by 35.3146667';
            break;
          case 'Cubic Yards':
            formula = 'Multiply the volume value by 1.30795062';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 202,884';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 67,628';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 33,814';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 4,226.75284';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 2,113.37642';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 1,056.68821';
            break;
          case 'Gallons (US)':
            formula = 'Multiply the volume value by 264.172052';
            break;
          case 'Barrels':
            formula = 'Multiply the volume value by 6.28981077';
            break;
          case 'Cubic Metres': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Cubic Inches':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 16.387064';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 16.387064';
            break;
          case 'Litres':
            formula = 'Divide the volume value by 61.0237441';
            break;
          case 'Cubic Decimetres':
            formula = 'Divide the volume value by 61.0237441';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 61,023.7441';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 61,023.7441';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 1,728';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 46,656';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 3.32468';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 1.10823';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 0.554113';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 0.0692641';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 0.0346321';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 0.017316';
            break;
          case 'Gallons (US)':
            formula = 'Multiply the volume value by 0.004329';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 7,200 (approximate)';
            break;
          case 'Cubic Inches': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Cubic Feet':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 28,316.8466';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 28,316.8466';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 28.3168466';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 28.3168466';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 0.283168466';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.0283168466';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 1,728';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 27';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 5,751.76897';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 1,917.22299';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 957.506494';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 119.688311';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 59.8441558';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 29.9220779';
            break;
          case 'Gallons (US)':
            formula = 'Multiply the volume value by 7.48051948';
            break;
          case 'Barrels':
            formula = 'Multiply the volume value by 0.178107607';
            break;
          case 'Cubic Feet': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Cubic Yards':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 764,554.858';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 764,554.858';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 764.554858';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 764.554858';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 7.64554858';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.764554858';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 46,656';
            break;
          case 'Cubic Feet':
            formula = 'Multiply the volume value by 27';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 155,116.052';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 51,705.3507';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 25,852.6753';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 3,231.58466';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 1,615.79233';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 807.896165';
            break;
          case 'Gallons (US)':
            formula = 'Multiply the volume value by 201.974041';
            break;
          case 'Barrels':
            formula = 'Multiply the volume value by 4.80890538';
            break;
          case 'Cubic Yards': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Teaspoons (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 5.91939';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 5.91939';
            break;
          case 'Litres':
            formula = 'Divide the volume value by 168.936';
            break;
          case 'Cubic Decimetres':
            formula = 'Divide the volume value by 168.936';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 16893.6';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 168936';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 0.361223';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 3,375.75';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 91,025.9';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 1.20095';
            break;
          case 'Tablespoons (US)':
            formula = 'Divide the volume value by 2.40231';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Divide the volume value by 6';
            break;
          case 'Cups (US)':
            formula = 'Divide the volume value by 48.6922';
            break;
          case 'Pints (US)':
            formula = 'Divide the volume value by 97.3845';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 194.769';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 779.076';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 32,970.3';
            break;
          case 'Teaspoons (lmp)': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Tablespoons (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 17.7582';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 17.7582';
            break;
          case 'Litres':
            formula = 'Divide the volume value by 56.3121';
            break;
          case 'Cubic Decimetres':
            formula = 'Divide the volume value by 56.3121';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 5,631.21';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 56,312.1';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 1.08367';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 1,125.25';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 30,342.7';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 3.60285';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 1.20095';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Divide the volume value by 2.02884';
            break;
          case 'Cups (US)':
            formula = 'Divide the volume value by 16.2307';
            break;
          case 'Pints (US)':
            formula = 'Divide the volume value by 32.4614';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 64.9228';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 259.691';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 10,990.1';
            break;
          case 'Tablespoons (lmp)': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Fluid Ounces (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 28.4131';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 28.4131';
            break;
          case 'Litres':
            formula = 'Divide the volume value by 35.1951';
            break;
          case 'Cubic Decimetres':
            formula = 'Divide the volume value by 35.1951';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 3,519.51';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 35,195.1';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 1.73387';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 996.614';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 26,798.5';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 6';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 2';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 1.04084';
            break;
          case 'Cups (US)':
            formula = 'Divide the volume value by 8.32674';
            break;
          case 'Pints (US)':
            formula = 'Divide the volume value by 16.6535';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 33.307';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 133.228';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 5,614.61';
            break;
          case 'Fluid Ounces (lmp)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Cups (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 284.131';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 284.131';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 0.284131';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 0.284131';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 0.00284131';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.000284131';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 17.3387';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 59.8442';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 1,607.3';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 48';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 16';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 9.6076';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 1.20095';
            break;
          case 'Pints (US)':
            formula = 'Divide the volume value by 1.75975';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 3.51951';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 14.078';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 187.5';
            break;
          case 'Cups (lmp)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Pints (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 568.261';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 568.261';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 0.568261';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 0.568261';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 0.00568261';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.000568261';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 34.6774';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 34.6788';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 970.920';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 115.291';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 38.4304';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 19.2152';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 2.4019';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 1.20095';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 1.75975';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 7.03901';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 336.405';
            break;
          case 'Pints (lmp)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Quarts (lmp)':
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 1136.52';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 1136.52';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 1.13652';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 1.13652';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 0.0113652';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.00113652';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 69.3549';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 57.374';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 1,941.84';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 230.582';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 76.8607';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 38.4304';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 4.8038';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 2.4019';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 1.20095';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 3.51951';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 168.202';
            break;
          case 'Quarts (lmp)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Gallons (lmp)': // Imperial Gallons
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 4,546.09';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 4,546.09';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 4.54609';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 4.54609';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 0.0454609';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.00454609';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 277.419';
            break;
          case 'Cubic Feet':
            formula = 'Multiply the volume value by 0.160544';
            break;
          case 'Cubic Yards':
            formula = 'Multiply the volume value by 0.00594606';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 922.33';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 307.443';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 153.722';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 19.2152';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 9.6076';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 4.8038';
            break;
          case 'Gallons (US)':
            formula = 'Multiply the volume value by 1.20095';
            break;
          case 'Barrels':
            formula = 'Multiply the volume value by 0.0295735';
            break;
          case 'Gallons (lmp)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Teaspoons (US)': // U.S. Teaspoons
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 4.92892';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 4.92892';
            break;
          case 'Litres':
            formula = 'Divide the volume value by 202.884';
            break;
          case 'Cubic Decimetres':
            formula = 'Divide the volume value by 202.884';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 20,288.4';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 202,884';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 0.300781';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 5745.04';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 155,116';
            break;
          case 'Teaspoons (lmp)':
            formula = 'Multiply the volume value by 0.832674';
            break;
          case 'Tablespoons (lmp)':
            formula = 'Multiply the volume value by 0.277558';
            break;
          case 'Fluid Ounces (lmp)':
            formula = 'Multiply the volume value by 0.173474';
            break;
          case 'Cups (lmp)':
            formula = 'Divide the volume value by 76.8608';
            break;
          case 'Pints (lmp)':
            formula = 'Divide the volume value by 96.6076';
            break;
          case 'Quarts (lmp)':
            formula = 'Divide the volume value by 192.307';
            break;
          case 'Gallons (lmp)':
            formula = 'Divide the volume value by 768';
            break;
          case 'Teaspoons (US)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Tablespoons (US)': // U.S. Tablespoons
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 14.7868';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 14.7868';
            break;
          case 'Litres':
            formula = 'Divide the volume value by 67.628';
            break;
          case 'Cubic Decimetres':
            formula = 'Divide the volume value by 67.628';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 67,628';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 67,628';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 0.902344';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 1,917.22';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 51,705.4';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 3';
            break;
          case 'Tablespoons (lmp)':
            formula = 'Multiply the volume value by 0.832674';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Divide the volume value by 2';
            break;
          case 'Cups (US)':
            formula = 'Divide the volume value by 16';
            break;
          case 'Pints (US)':
            formula = 'Divide the volume value by 32';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 64';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 256';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 10,240';
            break;
          case 'Tablespoons (US)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Fluid Ounces (US)': // U.S. Fluid Ounces
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 29.5735';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 29.5735';
            break;
          case 'Litres':
            formula = 'Divide the volume value by 33.814';
            break;
          case 'Cubic Decimetres':
            formula = 'Divide the volume value by 33.814';
            break;
          case 'Hectolitres':
            formula = 'Divide the volume value by 33,814';
            break;
          case 'Cubic Metres':
            formula = 'Divide the volume value by 33,814';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 1.80469';
            break;
          case 'Cubic Feet':
            formula = 'Divide the volume value by 957.506';
            break;
          case 'Cubic Yards':
            formula = 'Divide the volume value by 25,852.7';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 6';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 2';
            break;
          case 'Tablespoons (lmp)':
            formula = 'Multiply the volume value by 1.66535';
            break;
          case 'Fluid Ounces (lmp)':
            formula = 'Multiply the volume value by 0.96076';
            break;
          case 'Cups (US)':
            formula = 'Divide the volume value by 8';
            break;
          case 'Pints (US)':
            formula = 'Divide the volume value by 16';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 32';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 128';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 5,120';
            break;
          case 'Fluid Ounces (US)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Cups (US)': // U.S. Cups
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 236.588';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 236.588';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 0.236588';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 0.236588';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 0.00236588';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.000236588';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 14.4375';
            break;
          case 'Cubic Feet':
            formula = 'Multiply the volume value by 0.00835503';
            break;
          case 'Cubic Yards':
            formula = 'Multiply the volume value by 0.000309445';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 48';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 16';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 8';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 0.5';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 0.25';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 16';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 672';
            break;
          case 'Cups (US)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Pints (US)': // U.S. Pints
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 473.176';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 473.176';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 0.473176';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 0.473176';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 0.00473176';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.000473176';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 28.875';
            break;
          case 'Cubic Feet':
            formula = 'Multiply the volume value by 0.0167101';
            break;
          case 'Cubic Yards':
            formula = 'Multiply the volume value by 0.000618891';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 96';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 32';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 16';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 2';
            break;
          case 'Quarts (US)':
            formula = 'Divide the volume value by 2';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 8';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 336';
            break;
          case 'Pints (US)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Quarts (US)': // U.S. Quarts
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 946.353';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 946.353';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 0.946353';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 0.946353';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 0.00946353';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.000946353';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 57.75';
            break;
          case 'Cubic Feet':
            formula = 'Multiply the volume value by 0.0334201';
            break;
          case 'Cubic Yards':
            formula = 'Multiply the volume value by 0.00123778';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 192';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 64';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 32';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 4';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 2';
            break;
          case 'Gallons (US)':
            formula = 'Divide the volume value by 4';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 168';
            break;
          case 'Quarts (US)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Gallons (US)': // U.S. Gallons
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 3785.41';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 3785.41';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 3.78541';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 3.78541';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 0.0378541';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.00378541';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 231';
            break;
          case 'Cubic Feet':
            formula = 'Multiply the volume value by 0.133681';
            break;
          case 'Cubic Yards':
            formula = 'Multiply the volume value by 0.00495113';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 768';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 256';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 128';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 16';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 8';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 4';
            break;
          case 'Barrels':
            formula = 'Divide the volume value by 42';
            break;
          case 'Gallons (US)': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Barrels': // Assuming this is the U.S. liquid barrel
        switch (toUnit) {
          case 'Cubic Centimetres':
            formula = 'Multiply the volume value by 158,987';
            break;
          case 'Millilitres':
            formula = 'Multiply the volume value by 158,987';
            break;
          case 'Litres':
            formula = 'Multiply the volume value by 158.987';
            break;
          case 'Cubic Decimetres':
            formula = 'Multiply the volume value by 158.987';
            break;
          case 'Hectolitres':
            formula = 'Multiply the volume value by 1.58987';
            break;
          case 'Cubic Metres':
            formula = 'Multiply the volume value by 0.158987';
            break;
          case 'Cubic Inches':
            formula = 'Multiply the volume value by 9702';
            break;
          case 'Cubic Feet':
            formula = 'Multiply the volume value by 5.61458';
            break;
          case 'Cubic Yards':
            formula = 'Multiply the volume value by 0.207947';
            break;
          case 'Teaspoons (US)':
            formula = 'Multiply the volume value by 32,000';
            break;
          case 'Tablespoons (US)':
            formula = 'Multiply the volume value by 10,666.7';
            break;
          case 'Fluid Ounces (US)':
            formula = 'Multiply the volume value by 5376';
            break;
          case 'Cups (US)':
            formula = 'Multiply the volume value by 672';
            break;
          case 'Pints (US)':
            formula = 'Multiply the volume value by 336';
            break;
          case 'Quarts (US)':
            formula = 'Multiply the volume value by 168';
            break;
          case 'Gallons (US)':
            formula = 'Multiply the volume value by 42';
            break;
          case 'Barrels': // No conversion needed if from and to units are the same
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
                          child: AutoSizeText('Convert Volume'.tr(),
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
      case 'Cubic Centimetres':
        return 'cm³';
      case 'Millilitres':
        return 'mL'; // Millilitre is equivalent to a cubic centimetre
      case 'Litres':
        return 'L';
      case 'Cubic Decimetres':
        return 'dm³'; // Cubic decimetre is equivalent to a litre
      case 'Hectolitres':
        return 'hL'; // Hectolitre is equivalent to 100 litres
      case 'Cubic Metres':
        return 'm³';
      case 'Cubic Inches':
        return 'in³';
      case 'Cubic Feet':
        return 'ft³';
      case 'Cubic Yards':
        return 'yd³';
      case 'Teaspoons (lmp)':
        return 'tsp (lmp)'; // Imperial teaspoons
      case 'Tablespoons (lmp)':
        return 'tbsp (lmp)'; // Imperial tablespoons
      case 'Fluid Ounces (lmp)':
        return 'fl oz (lmp)'; // Imperial fluid ounces
      case 'Cups (lmp)':
        return 'cup (lmp)'; // Imperial cups
      case 'Pints (lmp)':
        return 'pt (lmp)'; // Imperial pints
      case 'Quarts (lmp)':
        return 'qt (lmp)'; // Imperial quarts
      case 'Gallons (lmp)':
        return 'gal (lmp)'; // Imperial gallons
      case 'Teaspoons (US)':
        return 'tsp (US)'; // U.S. teaspoons
      case 'Tablespoons (US)':
        return 'tbsp (US)'; // U.S. tablespoons
      case 'Fluid Ounces (US)':
        return 'fl oz (US)'; // U.S. fluid ounces
      case 'Cups (US)':
        return 'cup (US)'; // U.S. cups
      case 'Pints (US)':
        return 'pt (US)'; // U.S. pints
      case 'Quarts (US)':
        return 'qt (US)'; // U.S. quarts
      case 'Gallons (US)':
        return 'gal (US)'; // U.S. gallons
      case 'Barrels':
        return 'bbl'; // Barrels, typically used for oil or other commodities
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
      'Cubic Centimetres',
      'Millilitres',
      'Litres',
      'Cubic Decimetres',
      'Hectolitres',
      'Cubic Metres',
      'Cubic Inches',
      'Cubic Feet',
      'Cubic Yards',
      'Teaspoons (lmp)',
      'Tablespoons (lmp)',
      'Fluid Ounces (lmp)',
      'Cups (lmp)',
      'Pints (lmp)',
      'Quarts (lmp)',
      'Gallons (lmp)',
      'Teaspoons (US)',
      'Tablespoons (US)',
      'Fluid Ounces (US)',
      'Cups (US)',
      'Pints (US)',
      'Quarts (US)',
      'Gallons (US)',
      'Barrels',
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
