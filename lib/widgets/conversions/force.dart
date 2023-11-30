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

class ForceUnitConverter extends StatefulWidget {
  const ForceUnitConverter({super.key});

  @override
  _ForceUnitConverterState createState() => _ForceUnitConverterState();
}

class _ForceUnitConverterState extends State<ForceUnitConverter> {
  static const double mediumFontSize = 17.0;

  double fontSize = mediumFontSize;
  GlobalKey tooltipKey = GlobalKey();
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Micronewton';
  String toUnit = 'Millinewton';
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

  String chooseFontFamily(Locale currentLocale) {
    // List of locales supported by 'Lato'
    const supportedLocales = [
      'en',
      'es',
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
      'lv',
      'nb',
      'nl',
      'pl',
      'sr',
      'sv',
      'sw',
      'tl',
      'uk',
      'ro',
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
          text: 'Check out my force result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

// region Force Conversion Constants from Micronewton
    const double micronewtonToNewton = 1e-6;
    const double micronewtonToKilonewton = 1e-9;
    const double micronewtonToMeganewton = 1e-12;
    const double micronewtonToPond = micronewtonToNewton / 9.80665e-3;
    const double micronewtonToKilopond = micronewtonToNewton / 9.80665;
    const double micronewtonToMegapond = micronewtonToNewton / 9.80665e6;
    const double micronewtonToGramForce = micronewtonToPond;
    const double micronewtonToKilogramForce = micronewtonToKilonewton;
    const double micronewtonToTonneForce = micronewtonToMeganewton;
    const double micronewtonToPoundForce =
        micronewtonToNewton / 4.4482216152605;
    const double micronewtonToLongTonForce =
        micronewtonToNewton / 9964.01641818352;
    const double micronewtonToShortTonForce =
        micronewtonToNewton / 8896.443230521;
    const double micronewtonToDyne = micronewtonToNewton * 1e5;
    const double micronewtonToPoundal = micronewtonToNewton / 0.138254954376;

// region Force Conversion Constants from Millinewton
    const double millinewtonToNewton = 1e-3;
    const double millinewtonToKilonewton = 1e-6;
    const double millinewtonToMeganewton = 1e-9;
    const double millinewtonToPond = millinewtonToNewton / 9.80665e-3;
    const double millinewtonToKilopond = millinewtonToNewton / 9.80665;
    const double millinewtonToMegapond = millinewtonToNewton / 9.80665e6;
    const double millinewtonToGramForce = millinewtonToPond;
    const double millinewtonToKilogramForce = millinewtonToKilonewton;
    const double millinewtonToTonneForce = millinewtonToMeganewton;
    const double millinewtonToPoundForce =
        millinewtonToNewton / 4.4482216152605;
    const double millinewtonToLongTonForce =
        millinewtonToNewton / 9964.01641818352;
    const double millinewtonToShortTonForce =
        millinewtonToNewton / 8896.443230521;
    const double millinewtonToDyne = millinewtonToNewton * 1e5;
    const double millinewtonToPoundal = millinewtonToNewton / 0.138254954376;

// region Force Conversion Constants from Newton
    const double newtonToMicronewton = 1e6;
    const double newtonToMillinewton = 1e3;
    const double newtonToKilonewton = 1e-3;
    const double newtonToMeganewton = 1e-6;
    const double newtonToPond = 1 / 9.80665e-3;
    const double newtonToKilopond = 1 / 9.80665;
    const double newtonToMegapond = 1 / 9.80665e6;
    const double newtonToGramForce = newtonToPond;
    const double newtonToKilogramForce = newtonToKilopond;
    const double newtonToTonneForce = newtonToMeganewton;
    const double newtonToPoundForce = 1 / 4.4482216152605;
    const double newtonToLongTonForce = 1 / 9964.01641818352;
    const double newtonToShortTonForce = 1 / 8896.443230521;
    const double newtonToDyne = 1e5;
    const double newtonToPoundal = 1 / 0.138254954376;

// region Force Conversion Constants from Kilonewton
    const double kilonewtonToMicronewton = 1e9;
    const double kilonewtonToMillinewton = 1e6;
    const double kilonewtonToNewton = 1e3;
    const double kilonewtonToMeganewton = 1e-3;
    const double kilonewtonToPond = 1e3 / 9.80665e-3;
    const double kilonewtonToKilopond = 1e3 / 9.80665;
    const double kilonewtonToMegapond = 1e3 / 9.80665e6;
    const double kilonewtonToGramForce = kilonewtonToPond;
    const double kilonewtonToKilogramForce = kilonewtonToKilopond;
    const double kilonewtonToTonneForce = kilonewtonToMeganewton;
    const double kilonewtonToPoundForce = 1e3 / 4.4482216152605;
    const double kilonewtonToLongTonForce = 1e3 / 9964.01641818352;
    const double kilonewtonToShortTonForce = 1e3 / 8896.443230521;
    const double kilonewtonToDyne = 1e8;
    const double kilonewtonToPoundal = 1e3 / 0.138254954376;

// region Force Conversion Constants from Meganewton
    const double meganewtonToMicronewton = 1e12;
    const double meganewtonToMillinewton = 1e9;
    const double meganewtonToNewton = 1e6;
    const double meganewtonToKilonewton = 1e3;
    const double meganewtonToPond = 1e6 / 9.80665e-3;
    const double meganewtonToKilopond = 1e6 / 9.80665;
    const double meganewtonToMegapond = 1e6 / 9.80665e6;
    const double meganewtonToGramForce = meganewtonToPond;
    const double meganewtonToKilogramForce = meganewtonToKilopond;

    const double meganewtonToPoundForce = 1e6 / 4.4482216152605;
    const double meganewtonToLongTonForce = 1e6 / 9964.01641818352;
    const double meganewtonToShortTonForce = 1e6 / 8896.443230521;
    const double meganewtonToDyne = 1e11;
    const double meganewtonToPoundal = 1e6 / 0.138254954376;

// region Force Conversion Constants from Pond
    const double pondToMicronewton = 9.80665e3;
    const double pondToMillinewton = 9.80665;
    const double pondToNewton = 9.80665e-3;
    const double pondToKilonewton = 9.80665e-6;
    const double pondToMeganewton = 9.80665e-9;
    const double pondToKilopond = 1e-3;
    const double pondToMegapond = 1e-6;
// Since Pond is the same as gram-force
    const double pondToKilogramForce = pondToKilopond;
    const double pondToTonneForce = pondToMeganewton;
    const double pondToPoundForce = 9.80665e-3 / 4.4482216152605;
    const double pondToLongTonForce = 9.80665e-3 / 9964.01641818352;
    const double pondToShortTonForce = 9.80665e-3 / 8896.443230521;
    const double pondToDyne = 9.80665e2;
    const double pondToPoundal = 9.80665e-3 / 0.138254954376;

// region Force Conversion Constants from Kilopond
    const double kilopondToMicronewton = 9.80665e9;
    const double kilopondToMillinewton = 9.80665e6;
    const double kilopondToNewton = 9.80665e3;
    const double kilopondToKilonewton = 9.80665;
    const double kilopondToMeganewton = 9.80665e-3;
    const double kilopondToPond = 1e3;
    const double kilopondToMegapond = 1e-3;
    const double kilopondToGramForce = 1e3; // Since Kilopond is 1000 gram-force

    const double kilopondToTonneForce = 9.80665e-3;
    const double kilopondToPoundForce = 9.80665 / 4.4482216152605;
    const double kilopondToLongTonForce = 9.80665 / 9964.01641818352;
    const double kilopondToShortTonForce = 9.80665 / 8896.443230521;
    const double kilopondToDyne = 9.80665e8;
    const double kilopondToPoundal = 9.80665 / 0.138254954376;

// region Force Conversion Constants from Megapond
    const double megapondToMicronewton = 9.80665e12;
    const double megapondToMillinewton = 9.80665e9;
    const double megapondToNewton = 9.80665e6;
    const double megapondToKilonewton = 9.80665e3;

    const double megapondToPond = 1e6;
    const double megapondToKilopond = 1e3;
    const double megapondToGramForce =
        1e6; // Since Megapond is 1 million gram-force
    const double megapondToKilogramForce =
        9.80665e3; // Megapond and Kilotonne-force are equivalent
    const double megapondToTonneForce = 9.80665;
    const double megapondToPoundForce = 9.80665e6 / 4.4482216152605;
    const double megapondToLongTonForce = 9.80665e6 / 9964.01641818352;
    const double megapondToShortTonForce = 9.80665e6 / 8896.443230521;
    const double megapondToDyne = 9.80665e11;
    const double megapondToPoundal = 9.80665e6 / 0.138254954376;

// region Force Conversion Constants from Gram-force
    const double gramForceToMicronewton = 9.80665e3;
    const double gramForceToMillinewton = 9.80665;
    const double gramForceToNewton = 9.80665e-3;
    const double gramForceToKilonewton = 9.80665e-6;
    const double gramForceToMeganewton = 9.80665e-9;
    const double gramForceToPond = 1; // Gram-force is equivalent to Pond
    const double gramForceToKilopond = 1e-3;
    const double gramForceToMegapond = 1e-6;
    const double gramForceToKilogramForce = 1e-3;
    const double gramForceToTonneForce = 9.80665e-9;
    const double gramForceToPoundForce = 9.80665e-3 / 4.4482216152605;
    const double gramForceToLongTonForce = 9.80665e-3 / 9964.01641818352;
    const double gramForceToShortTonForce = 9.80665e-3 / 8896.443230521;
    const double gramForceToDyne = 9.80665e2;
    const double gramForceToPoundal = 9.80665e-3 / 0.138254954376;

// region Force Conversion Constants from Kilogram-force
    const double kilogramForceToMicronewton = 9.80665e6;
    const double kilogramForceToMillinewton = 9.80665e3;
    const double kilogramForceToNewton = 9.80665;
    const double kilogramForceToKilonewton = 9.80665e-3;
    const double kilogramForceToMeganewton = 9.80665e-6;
    const double kilogramForceToPond = 1e3;

    const double kilogramForceToMegapond = 1e-3;
    const double kilogramForceToGramForce = 1e3;
    const double kilogramForceToTonneForce = 9.80665e-3;
    const double kilogramForceToPoundForce = 9.80665 / 4.4482216152605;
    const double kilogramForceToLongTonForce = 9.80665 / 9964.01641818352;
    const double kilogramForceToShortTonForce = 9.80665 / 8896.443230521;
    const double kilogramForceToDyne = 9.80665e5;
    const double kilogramForceToPoundal = 9.80665 / 0.138254954376;

// region Force Conversion Constants from Tonne-force
    const double tonneForceToMicronewton = 1e9 * 9.80665;
    const double tonneForceToMillinewton = 1e6 * 9.80665;
    const double tonneForceToNewton = 1e3 * 9.80665;
    const double tonneForceToKilonewton = 9.80665;
    const double tonneForceToMeganewton = 9.80665e-3;
    const double tonneForceToPond = 1e3 * 1e3; // 1 tonne-force = 1000 kiloponds
    const double tonneForceToKilopond = 1e3; // 1 tonne-force = 1000 kiloponds
    const double tonneForceToMegapond = 1; // 1 tonne-force = 1 megapond
    const double tonneForceToGramForce = 1e3 * 1e3 * 1e3;
    const double tonneForceToKilogramForce = 1e3 * 9.80665;
    const double tonneForceToPoundForce = 1e3 * 9.80665 / 4.4482216152605;
    const double tonneForceToLongTonForce = 1e3 * 9.80665 / 9964.01641818352;
    const double tonneForceToShortTonForce = 1e3 * 9.80665 / 8896.443230521;
    const double tonneForceToDyne = 1e3 * 9.80665e5;
    const double tonneForceToPoundal = 1e3 * 9.80665 / 0.138254954376;

// region Force Conversion Constants from Pound-force
    const double poundForceToMicronewton = 4.4482216152605e6;
    const double poundForceToMillinewton = 4.4482216152605e3;
    const double poundForceToNewton = 4.4482216152605;
    const double poundForceToKilonewton = 4.4482216152605e-3;
    const double poundForceToMeganewton = 4.4482216152605e-6;
    const double poundForceToPond = 4.4482216152605 / 9.80665e-3;
    const double poundForceToKilopond = 4.4482216152605 / 9.80665;
    const double poundForceToMegapond = 4.4482216152605 / 9.80665e6;
    const double poundForceToGramForce = 4.4482216152605 / 9.80665e-3;
    const double poundForceToKilogramForce = 4.4482216152605 / 9.80665;
    const double poundForceToTonneForce = 4.4482216152605 / 9.80665e3;
    const double poundForceToLongTonForce = 4.4482216152605 / 9964.01641818352;
    const double poundForceToShortTonForce = 4.4482216152605 / 8896.443230521;
    const double poundForceToDyne = 4.4482216152605 * 1e5;
    const double poundForceToPoundal = 4.4482216152605 / 0.138254954376;

// region Force Conversion Constants from Long Ton-force (lmp)
    const double longTonForceToMicronewton = 9964.01641818352e6;
    const double longTonForceToMillinewton = 9964.01641818352e3;
    const double longTonForceToNewton = 9964.01641818352;
    const double longTonForceToKilonewton = 9964.01641818352e-3;
    const double longTonForceToMeganewton = 9964.01641818352e-6;
    const double longTonForceToPond = 9964.01641818352 / 9.80665e-3;
    const double longTonForceToKilopond = 9964.01641818352 / 9.80665;
    const double longTonForceToMegapond = 9964.01641818352 / 9.80665e6;
    const double longTonForceToGramForce = 9964.01641818352 / 9.80665e-3;
    const double longTonForceToKilogramForce = 9964.01641818352 / 9.80665;
    const double longTonForceToTonneForce = 9964.01641818352 / 9.80665e3;
    const double longTonForceToPoundForce = 9964.01641818352 / 4.4482216152605;
    const double longTonForceToShortTonForce =
        9964.01641818352 / 8896.443230521;
    const double longTonForceToDyne = 9964.01641818352 * 1e5;
    const double longTonForceToPoundal = 9964.01641818352 / 0.138254954376;

// region Force Conversion Constants from Short Ton-force (US)
    const double shortTonForceToMicronewton = 8896.443230521e6;
    const double shortTonForceToMillinewton = 8896.443230521e3;
    const double shortTonForceToNewton = 8896.443230521;
    const double shortTonForceToKilonewton = 8896.443230521e-3;
    const double shortTonForceToMeganewton = 8896.443230521e-6;
    const double shortTonForceToPond = 8896.443230521 / 9.80665e-3;
    const double shortTonForceToKilopond = 8896.443230521 / 9.80665;
    const double shortTonForceToMegapond = 8896.443230521 / 9.80665e6;
    const double shortTonForceToGramForce = 8896.443230521 / 9.80665e-3;
    const double shortTonForceToKilogramForce = 8896.443230521 / 9.80665;
    const double shortTonForceToTonneForce = 8896.443230521 / 9.80665e3;
    const double shortTonForceToPoundForce = 8896.443230521 / 4.4482216152605;
    const double shortTonForceToLongTonForce =
        8896.443230521 / 9964.01641818352;
    const double shortTonForceToDyne = 8896.443230521 * 1e5;
    const double shortTonForceToPoundal = 8896.443230521 / 0.138254954376;

// region Force Conversion Constants from Dyne
    const double dyneToMicronewton = 1e-3;
    const double dyneToMillinewton = 1e-6;
    const double dyneToNewton = 1e-5;
    const double dyneToKilonewton = 1e-8;
    const double dyneToMeganewton = 1e-11;
    const double dyneToPond = 1e-5 / 9.80665e-3;
    const double dyneToKilopond = 1e-5 / 9.80665;
    const double dyneToMegapond = 1e-5 / 9.80665e6;
    const double dyneToGramForce = 1e-5 / 9.80665e-3;
    const double dyneToKilogramForce = 1e-5 / 9.80665;
    const double dyneToTonneForce = 1e-5 / 9.80665e3;
    const double dyneToPoundForce = 1e-5 / 4.4482216152605;
    const double dyneToLongTonForce = 1e-5 / 9964.01641818352;
    const double dyneToShortTonForce = 1e-5 / 8896.443230521;

    const double dyneToPoundal = 1e-5 / 0.138254954376;

// region Force Conversion Constants from Poundal
    const double poundalToMicronewton = 138254.954376e3;
    const double poundalToMillinewton = 138254.954376;
    const double poundalToNewton = 0.138254954376;
    const double poundalToKilonewton = 0.138254954376e-3;
    const double poundalToMeganewton = 0.138254954376e-6;
    const double poundalToPond = 0.138254954376 / 9.80665e-3;
    const double poundalToKilopond = 0.138254954376 / 9.80665;
    const double poundalToMegapond = 0.138254954376 / 9.80665e6;
    const double poundalToGramForce = 0.138254954376 / 9.80665e-3;
    const double poundalToKilogramForce = 0.138254954376 / 9.80665;
    const double poundalToTonneForce = 0.138254954376 / 9.80665e3;
    const double poundalToPoundForce = 0.138254954376 / 4.4482216152605;
    const double poundalToLongTonForce = 0.138254954376 / 9964.01641818352;
    const double poundalToShortTonForce = 0.138254954376 / 8896.443230521;
    const double poundalToDyne = 0.138254954376e5;

    switch (fromUnit) {
      // MICRONEWTON UNIT CONVERSION
      case 'Micronewtons':
        switch (toUnit) {
          case 'Newtons':
            toValue = fromValue * micronewtonToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * micronewtonToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * micronewtonToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * micronewtonToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * micronewtonToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * micronewtonToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * micronewtonToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * micronewtonToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * micronewtonToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * micronewtonToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * micronewtonToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * micronewtonToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * micronewtonToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * micronewtonToPoundal;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      // MILLINEWTON UNIT CONVERSION
      case 'Millinewtons':
        switch (toUnit) {
          case 'Newtons':
            toValue = fromValue * millinewtonToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * millinewtonToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * millinewtonToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * millinewtonToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * millinewtonToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * millinewtonToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * millinewtonToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * millinewtonToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * millinewtonToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * millinewtonToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * millinewtonToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * millinewtonToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * millinewtonToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * millinewtonToPoundal;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Newtons':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * newtonToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * newtonToMillinewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * newtonToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * newtonToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * newtonToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * newtonToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * newtonToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * newtonToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * newtonToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * newtonToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * newtonToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * newtonToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * newtonToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * newtonToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * newtonToPoundal;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
      // Now for Kilonewton conversion
      case 'Kilonewtons':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * kilonewtonToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * kilonewtonToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * kilonewtonToNewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * kilonewtonToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * kilonewtonToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * kilonewtonToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * kilonewtonToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * kilonewtonToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * kilonewtonToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * kilonewtonToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * kilonewtonToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * kilonewtonToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * kilonewtonToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * kilonewtonToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * kilonewtonToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      // Starting with Meganewton conversion

      case 'Meganewtons':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * meganewtonToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * meganewtonToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * meganewtonToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * meganewtonToKilonewton;
            break;
          case 'Ponds':
            toValue = fromValue * meganewtonToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * meganewtonToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * meganewtonToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * meganewtonToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * meganewtonToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue;
            break;
          case 'Pound-force':
            toValue = fromValue * meganewtonToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * meganewtonToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * meganewtonToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * meganewtonToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * meganewtonToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      // Now for Pond conversion
      case 'Ponds':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * pondToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * pondToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * pondToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * pondToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * pondToMeganewton;
            break;
          case 'Kiloponds':
            toValue = fromValue * pondToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * pondToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue; // Pond and Gram-force are equivalent
            break;
          case 'Kilogram-force':
            toValue = fromValue * pondToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * pondToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * pondToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * pondToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * pondToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * pondToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * pondToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      case 'Kiloponds':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * kilopondToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * kilopondToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * kilopondToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * kilopondToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * kilopondToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * kilopondToPond;
            break;
          case 'Megaponds':
            toValue = fromValue * kilopondToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * kilopondToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue; // Kilopond and Kilogram-force are equivalent
            break;
          case 'Tonne-force':
            toValue = fromValue * kilopondToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * kilopondToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * kilopondToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * kilopondToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * kilopondToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * kilopondToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      // Now for Megapond conversion
      case 'Megaponds':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * megapondToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * megapondToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * megapondToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * megapondToKilonewton;
            break;
          case 'Meganewtons':
            toValue =
                fromValue; // Megapond to Meganewton is a direct conversion
            break;
          case 'Ponds':
            toValue = fromValue * megapondToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * megapondToKilopond;
            break;
          case 'Gram-force':
            toValue = fromValue * megapondToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * megapondToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * megapondToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * megapondToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * megapondToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * megapondToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * megapondToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * megapondToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      case 'Gram-force':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * gramForceToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * gramForceToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * gramForceToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * gramForceToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * gramForceToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * gramForceToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * gramForceToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * gramForceToMegapond;
            break;
          case 'Kilogram-force':
            toValue = fromValue * gramForceToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * gramForceToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * gramForceToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * gramForceToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * gramForceToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * gramForceToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * gramForceToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      // Conversion from Kilogram-force
      case 'Kilogram-force':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * kilogramForceToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * kilogramForceToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * kilogramForceToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * kilogramForceToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * kilogramForceToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * kilogramForceToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue; // Kilogram-force and Kilopond are equivalent
            break;
          case 'Megaponds':
            toValue = fromValue * kilogramForceToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * kilogramForceToGramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * kilogramForceToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * kilogramForceToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * kilogramForceToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * kilogramForceToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * kilogramForceToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * kilogramForceToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      case 'Tonne-force':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * tonneForceToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * tonneForceToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * tonneForceToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * tonneForceToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * tonneForceToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * tonneForceToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * tonneForceToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * tonneForceToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * tonneForceToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * tonneForceToKilogramForce;
            break;
          case 'Pound-force':
            toValue = fromValue * tonneForceToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * tonneForceToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * tonneForceToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * tonneForceToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * tonneForceToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      // Conversion from Pound-force
      case 'Pound-force':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * poundForceToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * poundForceToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * poundForceToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * poundForceToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * poundForceToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * poundForceToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * poundForceToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * poundForceToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * poundForceToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * poundForceToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * poundForceToTonneForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * poundForceToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * poundForceToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * poundForceToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * poundForceToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      case 'Long Ton-force (lmp)':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * longTonForceToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * longTonForceToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * longTonForceToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * longTonForceToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * longTonForceToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * longTonForceToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * longTonForceToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * longTonForceToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * longTonForceToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * longTonForceToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * longTonForceToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * longTonForceToPoundForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * longTonForceToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * longTonForceToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * longTonForceToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      // Conversion from Short Ton-force (US)
      case 'Short Ton-force (Us)':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * shortTonForceToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * shortTonForceToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * shortTonForceToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * shortTonForceToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * shortTonForceToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * shortTonForceToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * shortTonForceToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * shortTonForceToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * shortTonForceToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * shortTonForceToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * shortTonForceToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * shortTonForceToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * shortTonForceToLongTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * shortTonForceToDyne;
            break;
          case 'Poundal':
            toValue = fromValue * shortTonForceToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      case 'Dyne':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * dyneToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * dyneToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * dyneToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * dyneToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * dyneToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * dyneToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * dyneToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * dyneToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * dyneToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * dyneToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * dyneToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * dyneToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * dyneToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * dyneToShortTonForce;
            break;
          case 'Poundal':
            toValue = fromValue * dyneToPoundal;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
            break;
        }
        break;

      // Conversion from Poundal
      case 'Poundal':
        switch (toUnit) {
          case 'Micronewtons':
            toValue = fromValue * poundalToMicronewton;
            break;
          case 'Millinewtons':
            toValue = fromValue * poundalToMillinewton;
            break;
          case 'Newtons':
            toValue = fromValue * poundalToNewton;
            break;
          case 'Kilonewtons':
            toValue = fromValue * poundalToKilonewton;
            break;
          case 'Meganewtons':
            toValue = fromValue * poundalToMeganewton;
            break;
          case 'Ponds':
            toValue = fromValue * poundalToPond;
            break;
          case 'Kiloponds':
            toValue = fromValue * poundalToKilopond;
            break;
          case 'Megaponds':
            toValue = fromValue * poundalToMegapond;
            break;
          case 'Gram-force':
            toValue = fromValue * poundalToGramForce;
            break;
          case 'Kilogram-force':
            toValue = fromValue * poundalToKilogramForce;
            break;
          case 'Tonne-force':
            toValue = fromValue * poundalToTonneForce;
            break;
          case 'Pound-force':
            toValue = fromValue * poundalToPoundForce;
            break;
          case 'Long Ton-force (lmp)':
            toValue = fromValue * poundalToLongTonForce;
            break;
          case 'Short Ton-force (Us)':
            toValue = fromValue * poundalToShortTonForce;
            break;
          case 'Dyne':
            toValue = fromValue * poundalToDyne;
            break;
          // Add more cases as needed
          default:
            toValue = fromValue; // No conversion if the unit is unrecognized
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
      case 'Micronewton':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'The value remains unchanged';
            break;
          case 'Millinewton':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Newton':
            formula = 'Divide the force value by 1,000,000';
            break;
          case 'Kilonewton':
            formula = 'Divide the force value by 1,000,000,000';
            break;
          case 'Meganewton':
            formula = 'Divide the force value by 1,000,000,000,000';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 1.01972e-7';
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 1.01972e-4';
            break;
          case 'Megaponds':
            formula = 'Multiply the force value by 0.101972';
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 1.01972e-7';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 1.01972e-4';
            break;
          case 'Tonne-force':
            formula = 'Multiply the force value by 1.01972e-1';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 2.24809e-7';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Multiply the force value by 2.24066e-4';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Multiply the force value by 2.20462e-4';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 10';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 7.23301e-6';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Millinewton':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 1,000';
            break;
          case 'Millinewton':
            formula = 'The value remains unchanged';
            break;
          case 'Newton':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Kilonewton':
            formula = 'Divide the force value by 1,000,000';
            break;
          case 'Meganewton':
            formula = 'Divide the force value by 1,000,000,000';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 0.101972';
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 0.000101972';
            break;
          case 'Megaponds':
            formula = 'Multiply the force value by 1.01972e-7';
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 0.101972';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 0.000101972';
            break;
          case 'Tonne-force':
            formula = 'Multiply the force value by 1.01972e-7';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 0.000224809';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Multiply the force value by 2.24066e-7';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Multiply the force value by 2.20462e-7';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 10,000';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 0.00723301';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Newton':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 1,000,000';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 1,000';
            break;
          case 'Newton':
            formula = 'The value remains unchanged';
            break;
          case 'Kilonewton':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Meganewton':
            formula = 'Divide the force value by 1,000,000';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 101.972';
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 0.101972';
            break;
          case 'Megaponds':
            formula = 'Multiply the force value by 0.000101972';
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 101.972';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 0.101972';
            break;
          case 'Tonne-force':
            formula = 'Multiply the force value by 0.000101972';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 0.224809';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Multiply the force value by 0.00022466';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Multiply the force value by 0.000220462';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 100,000';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 7.23301';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kilonewton':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 1,000,000,000';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 1,000,000';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 1,000';
            break;
          case 'Kilonewton':
            formula = 'The value remains unchanged';
            break;
          case 'Meganewton':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 101,972';
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 101.972';
            break;
          case 'Megaponds':
            formula = 'Multiply the force value by 0.101972';
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 101,972';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 101.972';
            break;
          case 'Tonne-force':
            formula = 'Multiply the force value by 0.101972';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 224.809';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Multiply the force value by 0.22466';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Multiply the force value by 0.220462';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 100,000,000';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 7,233.01';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Meganewton':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 1,000,000,000,000';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 1,000,000,000';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 1,000,000';
            break;
          case 'Kilonewton':
            formula = 'Multiply the force value by 1,000';
            break;
          case 'Meganewton':
            formula = 'The value remains unchanged';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 101,972,000';
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 101,972';
            break;
          case 'Megaponds':
            formula = 'Multiply the force value by 101.972';
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 101,972,000';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 101,972';
            break;
          case 'Tonne-force':
            formula = 'Multiply the force value by 101.972';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 224,809';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Multiply the force value by 224.66';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Multiply the force value by 220.462';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 100,000,000,000';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 7,233,010';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Ponds':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 9.80665';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 0.00980665';
            break;
          case 'Newton':
            formula = 'Divide the force value by 101.971621';
            break;
          case 'Kilonewton':
            formula = 'Divide the force value by 101,971.621';
            break;
          case 'Meganewton':
            formula = 'Divide the force value by 101,971,621';
            break;
          case 'Ponds':
            formula = 'The value remains unchanged';
            break;
          case 'Kiloponds':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Megaponds':
            formula = 'Divide the force value by 1,000,000';
            break;
          case 'Gram-force':
            formula =
                'The value remains unchanged'; // Since Pond and Gram-force are equivalent
            break;
          case 'Kilogram-force':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Tonne-force':
            formula = 'Divide the force value by 1,000,000';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 0.00220462';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Divide the force value by 1,016,046.9088';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Divide the force value by 907,184.74';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 980.665';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 0.031081';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kiloponds':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 9,806,650';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 9,806.65';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 9.80665';
            break;
          case 'Kilonewton':
            formula = 'Multiply the force value by 0.00980665';
            break;
          case 'Meganewton':
            formula = 'Multiply the force value by 0.00000980665';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 1,000';
            break;
          case 'Kiloponds':
            formula = 'The value remains unchanged';
            break;
          case 'Megaponds':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Gram-force':
            formula =
                'Multiply the force value by 1,000'; // Since Kilopond and Kilogram-force are equivalent
            break;
          case 'Kilogram-force':
            formula =
                'The value remains unchanged'; // Since Kilopond and Kilogram-force are equivalent
            break;
          case 'Tonne-force':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 2.20462';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Divide the force value by 1,016.0469088';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Divide the force value by 907.18474';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 980,665';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 70.93164';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Megaponds':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 9,806,650,000';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 9,806,650';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 9,806.65';
            break;
          case 'Kilonewton':
            formula = 'Multiply the force value by 9.80665';
            break;
          case 'Meganewton':
            formula = 'Multiply the force value by 0.00980665';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 1,000,000';
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 1,000';
            break;
          case 'Megaponds':
            formula = 'The value remains unchanged';
            break;
          case 'Gram-force':
            formula =
                'Multiply the force value by 1,000,000'; // Since Megapond and Megagram-force are equivalent
            break;
          case 'Kilogram-force':
            formula =
                'Multiply the force value by 1,000'; // Since Megapond and Metric ton-force are equivalent
            break;
          case 'Tonne-force':
            formula =
                'The value remains unchanged'; // Since Megapond and Metric ton-force are equivalent
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 2,204.62262';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Multiply the force value by 0.9842065276';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Multiply the force value by 1.10231131';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 980,665,000';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 70,931.6353';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Gram-force':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 9.80665';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 0.00980665';
            break;
          case 'Newton':
            formula = 'Divide the force value by 101.971621';
            break;
          case 'Kilonewton':
            formula = 'Divide the force value by 101,971.621';
            break;
          case 'Meganewton':
            formula = 'Divide the force value by 101,971,621';
            break;
          case 'Ponds':
            formula =
                'The value remains unchanged'; // Since Pond and Gram-force are equivalent
            break;
          case 'Kiloponds':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Megaponds':
            formula = 'Divide the force value by 1,000,000';
            break;
          case 'Gram-force':
            formula = 'The value remains unchanged';
            break;
          case 'Kilogram-force':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Tonne-force':
            formula = 'Divide the force value by 1,000,000';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 0.00220462';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Divide the force value by 1,016,046.9088';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Divide the force value by 907,184.74';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 980.665';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 0.031081';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kilogram-force':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 9,806,650';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 9,806.65';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 9.80665';
            break;
          case 'Kilonewton':
            formula = 'Multiply the force value by 0.00980665';
            break;
          case 'Meganewton':
            formula = 'Multiply the force value by 0.00000980665';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 1,000';
            break;
          case 'Kiloponds':
            formula =
                'The value remains unchanged'; // Since Kilopond and Kilogram-force are equivalent
            break;
          case 'Megaponds':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Gram-force':
            formula =
                'Multiply the force value by 1,000'; // Since Kilogram-force and Kilopond are equivalent
            break;
          case 'Kilogram-force':
            formula = 'The value remains unchanged';
            break;
          case 'Tonne-force':
            formula = 'Divide the force value by 1,000';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 2.20462';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Divide the force value by 1,016.0469088';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Divide the force value by 907.18474';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 980,665';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 70.93164';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Tonne-force':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 9,806,650,000';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 9,806,650';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 9,806.65';
            break;
          case 'Kilonewton':
            formula = 'Multiply the force value by 9.80665';
            break;
          case 'Meganewton':
            formula = 'Multiply the force value by 0.00980665';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 1,000,000';
            break;
          case 'Kiloponds':
            formula =
                'Multiply the force value by 1,000'; // Since Kilopond and Kilogram-force are equivalent
            break;
          case 'Megaponds':
            formula =
                'The value remains unchanged'; // Since Megapond and Metric ton-force are equivalent
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 1,000,000';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 1,000';
            break;
          case 'Tonne-force':
            formula = 'The value remains unchanged';
            break;
          case 'Pound-force':
            formula = 'Multiply the force value by 2,204.62262';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Multiply the force value by 0.9842065276';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Multiply the force value by 1.10231131';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 980,665,000';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 70,931.6353';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Pound-force':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 4,448,221.6152605';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 4,448.2216152605';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 4.4482216152605';
            break;
          case 'Kilonewton':
            formula = 'Multiply the force value by 0.0044482216152605';
            break;
          case 'Meganewton':
            formula = 'Multiply the force value by 0.0000044482216152605';
            break;
          case 'Ponds':
            formula =
                'Multiply the force value by 453.59237'; // 1 pound-force is the force of gravity on a 1-pound mass
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 0.45359237';
            break;
          case 'Megaponds':
            formula = 'Multiply the force value by 0.00045359237';
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 453.59237';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 0.45359237';
            break;
          case 'Tonne-force':
            formula = 'Multiply the force value by 0.00045359237';
            break;
          case 'Pound-force':
            formula = 'The value remains unchanged';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Multiply the force value by 0.0004464285714285714';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Multiply the force value by 0.0005';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 444,822.16152605';
            break;
          case 'Poundal':
            formula = 'Multiply the force value by 32.1740485564304';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Long Ton-force (lmp)':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 9,964,016,418';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 9,964,016.418';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 9,964.016418';
            break;
          case 'Kilonewton':
            formula = 'Multiply the force value by 9.964016418';
            break;
          case 'Meganewton':
            formula = 'Multiply the force value by 0.009964016418';
            break;
          case 'Ponds':
            formula =
                'Multiply the force value by 2,240,000'; // 1 Long Ton-force is the force of gravity on a 1 long ton mass
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 2,240';
            break;
          case 'Megaponds':
            formula = 'Multiply the force value by 2.24';
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 2,240,000';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 2,240';
            break;
          case 'Tonne-force':
            formula = 'Multiply the force value by 2.24';
            break;
          case 'Pound-force':
            formula =
                'Multiply the force value by 2,240 * 2.2046226218488'; // Convert long ton to pounds and then to pound-force
            break;
          case 'Long Ton-force (lmp)':
            formula = 'The value remains unchanged';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Multiply the force value by 1.12';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 996,401,641,800';
            break;
          case 'Poundal':
            formula =
                'Multiply the force value by 2,240 * 32.1740485564304'; // Convert long ton to pounds and then to poundals
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Short Ton-force (Us)':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 8,896,443.230521';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 8,896,443.230521';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 8,896.443230521';
            break;
          case 'Kilonewton':
            formula = 'Multiply the force value by 8.896443230521';
            break;
          case 'Meganewton':
            formula = 'Multiply the force value by 0.008896443230521';
            break;
          case 'Ponds':
            formula =
                'Multiply the force value by 2,000,000'; // 1 Short Ton-force is the force of gravity on a 1 short ton mass
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 2,000';
            break;
          case 'Megaponds':
            formula = 'Multiply the force value by 2';
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 2,000,000';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 2,000';
            break;
          case 'Tonne-force':
            formula = 'Multiply the force value by 2';
            break;
          case 'Pound-force':
            formula =
                'Multiply the force value by 2,000 * 2.2046226218488'; // Convert short ton to pounds and then to pound-force
            break;
          case 'Long Ton-force (lmp)':
            formula =
                'Multiply the force value by 0.8928571428571429'; // Convert short ton to long ton and then to long ton-force
            break;
          case 'Short Ton-force (Us)':
            formula = 'The value remains unchanged';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 889,644,323,052.1';
            break;
          case 'Poundal':
            formula =
                'Multiply the force value by 2,000 * 32.1740485564304'; // Convert short ton to pounds and then to poundals
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Dyne':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Divide the force value by 10';
            break;
          case 'Millinewton':
            formula = 'Divide the force value by 10,000';
            break;
          case 'Newton':
            formula = 'Divide the force value by 100,000';
            break;
          case 'Kilonewton':
            formula = 'Divide the force value by 100,000,000';
            break;
          case 'Meganewton':
            formula = 'Divide the force value by 100,000,000,000';
            break;
          case 'Ponds':
            formula = 'Divide the force value by 980.665';
            break;
          case 'Kiloponds':
            formula = 'Divide the force value by 980,665';
            break;
          case 'Megaponds':
            formula = 'Divide the force value by 980,665,000';
            break;
          case 'Gram-force':
            formula = 'Divide the force value by 980.665';
            break;
          case 'Kilogram-force':
            formula = 'Divide the force value by 980,665';
            break;
          case 'Tonne-force':
            formula = 'Divide the force value by 980,665,000';
            break;
          case 'Pound-force':
            formula = 'Divide the force value by 444,822.16152605';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Divide the force value by 996,401,641,800';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Divide the force value by 889,644,323,052.1';
            break;
          case 'Dyne':
            formula = 'The value remains unchanged';
            break;
          case 'Poundal':
            formula = 'Divide the force value by 13,825.4954376';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Poundal':
        switch (toUnit) {
          case 'Micronewton':
            formula = 'Multiply the force value by 13,825.4954376';
            break;
          case 'Millinewton':
            formula = 'Multiply the force value by 13.8254954376';
            break;
          case 'Newton':
            formula = 'Multiply the force value by 0.138254954376';
            break;
          case 'Kilonewton':
            formula = 'Multiply the force value by 0.000138254954376';
            break;
          case 'Meganewton':
            formula = 'Multiply the force value by 0.000000138254954376';
            break;
          case 'Ponds':
            formula = 'Multiply the force value by 0.031080950172';
            break;
          case 'Kiloponds':
            formula = 'Multiply the force value by 0.000031080950172';
            break;
          case 'Megaponds':
            formula = 'Multiply the force value by 0.000000031080950172';
            break;
          case 'Gram-force':
            formula = 'Multiply the force value by 0.031080950172';
            break;
          case 'Kilogram-force':
            formula = 'Multiply the force value by 0.000031080950172';
            break;
          case 'Tonne-force':
            formula = 'Multiply the force value by 0.000000031080950172';
            break;
          case 'Pound-force':
            formula = 'Divide the force value by 32.1740485564304';
            break;
          case 'Long Ton-force (lmp)':
            formula = 'Divide the force value by 71,168.048770845';
            break;
          case 'Short Ton-force (Us)':
            formula = 'Divide the force value by 64,000';
            break;
          case 'Dyne':
            formula = 'Multiply the force value by 13,825.4954376';
            break;
          case 'Poundal':
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
// ... after the last specific unit case ...
      default:
        formula = 'Pick units to start';
        break;
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
                          child: AutoSizeText('Convert Force'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: chooseFontFamily(
                                    Localizations.localeOf(context)),
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
                      onPressed: () async {
                        // Call your swapUnits function.
                        swapUnits();

                        // Haptic feedback logic
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
      case 'Micronewton':
        return 'µN';
      case 'Millinewton':
        return 'mN';
      case 'Newton':
        return 'N';
      case 'Kilonewton':
        return 'kN';
      case 'Meganewton':
        return 'MN';
      case 'Ponds':
        return 'p';
      case 'Kiloponds':
        return 'kp';
      case 'Megaponds':
        return 'Mp';
      case 'Gram-force':
        return 'gf';
      case 'Kilogram-force':
        return 'kgf';
      case 'Tonne-force':
        return 'tf';
      case 'Pound-force':
        return 'lbf';
      case 'Long Ton-force (lmp)':
        return 'lmp tf';
      case 'Short Ton-force (Us)':
        return 'sh tf';
      case 'Dyne':
        return 'dyn';
      case 'Poundal':
        return 'pdl';
      default:
        return '';
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
                  onPressed: () async {
                    // Call your copyToClipboard function.
                    copyToClipboard(controller.text, context);

                    // Haptic feedback logic
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
    List<DropdownMenuItem<String>> items = <String>[
      'Micronewton',
      'Millinewton',
      'Newton',
      'Kilonewton',
      'Meganewton',
      'Ponds',
      'Kiloponds',
      'Megaponds',
      'Gram-force',
      'Kilogram-force',
      'Tonne-force',
      'Pound-force',
      'Long Ton-force (lmp)',
      'Short Ton-force (Us)',
      'Dyne',
      'Poundal',
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
    );
  }
}
