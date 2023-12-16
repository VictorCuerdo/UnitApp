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

class AreaUnitConverter extends StatefulWidget {
  const AreaUnitConverter({super.key});

  @override
  _AreaUnitConverterState createState() => _AreaUnitConverterState();
}

class _AreaUnitConverterState extends State<AreaUnitConverter> {
  GlobalKey tooltipKey = GlobalKey();
  static const double mediumFontSize = 17.0;
  double fontSize = mediumFontSize;
  bool isTyping = false;

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
          text: 'Check out my area conversion result!'.tr());
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
                              child: AutoSizeText('Convert Area'.tr(),
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
          // Unique label for accessibility
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
