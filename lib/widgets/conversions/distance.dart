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

class DistanceUnitConverter extends StatefulWidget {
  const DistanceUnitConverter({super.key});

  @override
  _DistanceUnitConverterState createState() => _DistanceUnitConverterState();
}

class _DistanceUnitConverterState extends State<DistanceUnitConverter> {
  static const double mediumFontSize = 17.0;

  double fontSize = mediumFontSize;
  GlobalKey tooltipKey = GlobalKey();
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Meters';
  String toUnit = 'Centimeters';
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
          text: 'Check out my distance result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here
// region myVariables
    const double meterToCentimeter = 100;
    const double meterToPicometer = 1e12;
    const double meterToNanometer = 1e9;
    const double meterToMicrometer = 1e6;
    const double meterToMillimeter = 1e3;
    const double meterToKilometer = 1e-3;
    const double meterToAngstrom = 1e10;
    const double meterToThou = 39370.0787;
    const double meterToInch = 39.3700787;
    const double meterToFoot = 3.2808399;
    const double meterToYard = 1.0936133;
    const double meterToChain = 0.0497097;
    const double meterToFurlong = 0.00497097;
    const double meterToMile = 0.000621371;
    const double meterToFathom = 0.546806649;
    const double meterToCable = 0.005399568;
    const double meterToNauticalMile = 0.000539957;
    const double meterToAstronomicalUnit = 6.68458712e-12;
    const double meterToParsec = 3.24077929e-17;
    const double meterToLightYear = 1 / (299792458 * 31557600);

    // Conversion constants for Picometers to other units
    const double picometerToCentimeter = 1e10;
    const double picometerToNanometer = 1e3;
    const double picometerToMicrometer = 1e6;
    const double picometerToMillimeter = 1e9;
    const double picometerToKilometer = 1e15;
    const double picometerToAngstrom = 1e2;
    const double picometerToThou = 1e12 / meterToThou;
    const double picometerToInch = 1e12 / meterToInch;
    const double picometerToFoot = 1e12 / meterToFoot;
    const double picometerToYard = 1e12 / meterToYard;
    const double picometerToChain = 1e12 / meterToChain;
    const double picometerToFurlong = 1e12 / meterToFurlong;
    const double picometerToMile = 1e12 / meterToMile;
    const double picometerToFathom = 1e12 / meterToFathom;
    const double picometerToCable = 1e12 / meterToCable;
    const double picometerToNauticalMile = 1e12 / meterToNauticalMile;
    const double picometerToAstronomicalUnit = 1e12 / meterToAstronomicalUnit;
    const double picometerToLightYear = 1e-12 / (9.461e15);
    const double picometerToParsec = 1e-12 / (3.086e16);

    // Conversion constants from Nanometers to other units
    const double nanometerToPicometer = 1e3;
    const double nanometerToMicrometer = 1e-3;
    const double nanometerToMillimeter = 1e-6;
    const double nanometerToCentimeter = 1e-7;
    const double nanometerToMeter = 1e-9;
    const double nanometerToKilometer = 1e-12;
    const double nanometerToAngstrom = 10;
    const double nanometerToThou = nanometerToMeter * meterToThou;
    const double nanometerToInch = nanometerToMeter * meterToInch;
    const double nanometerToFoot = nanometerToMeter * meterToFoot;
    const double nanometerToYard = nanometerToMeter * meterToYard;
    const double nanometerToChain = nanometerToMeter * meterToChain;
    const double nanometerToFurlong = nanometerToMeter * meterToFurlong;
    const double nanometerToMile = nanometerToMeter * meterToMile;
    const double nanometerToFathom = nanometerToMeter * meterToFathom;
    const double nanometerToCable = nanometerToMeter * meterToCable;
    const double nanometerToNauticalMile =
        nanometerToMeter * meterToNauticalMile;
    const double nanometerToAstronomicalUnit =
        nanometerToMeter * meterToAstronomicalUnit;
    const double nanometerToLightYear = nanometerToMeter * meterToLightYear;
    const double nanometerToParsec = nanometerToMeter * meterToParsec;
// Conversion constants from Centimeters to other units
    const double centimeterToMeter = 1e-2;
    const double centimeterToPicometer = 1e10;
    const double centimeterToNanometer = 1e7;
    const double centimeterToMicrometer = 1e4;
    const double centimeterToMillimeter = 10;
    const double centimeterToKilometer = 1e-5;
    const double centimeterToAngstrom = 1e8;
    const double centimeterToThou = centimeterToMeter * meterToThou;
    const double centimeterToInch = centimeterToMeter * meterToInch;
    const double centimeterToFoot = centimeterToMeter * meterToFoot;
    const double centimeterToYard = centimeterToMeter * meterToYard;
    const double centimeterToChain = centimeterToMeter * meterToChain;
    const double centimeterToFurlong = centimeterToMeter * meterToFurlong;
    const double centimeterToMile = centimeterToMeter * meterToMile;
    const double centimeterToFathom = centimeterToMeter * meterToFathom;
    const double centimeterToCable = centimeterToMeter * meterToCable;
    const double centimeterToNauticalMile =
        centimeterToMeter * meterToNauticalMile;
    const double centimeterToAstronomicalUnit =
        centimeterToMeter * meterToAstronomicalUnit;
    const double centimeterToLightYear = centimeterToMeter * meterToLightYear;
    const double centimeterToParsec = centimeterToMeter * meterToParsec;

    // Conversion constants from Millimeters to other units
    const double millimeterToMeter = 1e-3;
    const double millimeterToPicometer = 1e9;
    const double millimeterToNanometer = 1e6;
    const double millimeterToMicrometer = 1e3;
    const double millimeterToCentimeter = 1e-1;
    const double millimeterToKilometer = 1e-6;
    const double millimeterToAngstrom = 1e7;
    const double millimeterToThou = millimeterToMeter * meterToThou;
    const double millimeterToInch = millimeterToMeter * meterToInch;
    const double millimeterToFoot = millimeterToMeter * meterToFoot;
    const double millimeterToYard = millimeterToMeter * meterToYard;
    const double millimeterToChain = millimeterToMeter * meterToChain;
    const double millimeterToFurlong = millimeterToMeter * meterToFurlong;
    const double millimeterToMile = millimeterToMeter * meterToMile;
    const double millimeterToFathom = millimeterToMeter * meterToFathom;
    const double millimeterToCable = millimeterToMeter * meterToCable;
    const double millimeterToNauticalMile =
        millimeterToMeter * meterToNauticalMile;
    const double millimeterToAstronomicalUnit =
        millimeterToMeter * meterToAstronomicalUnit;
    const double millimeterToLightYear = millimeterToMeter * meterToLightYear;
    const double millimeterToParsec = millimeterToMeter * meterToParsec;

    // Conversion constants from Micrometers to other units
    const double micrometerToCentimeter = 1e-4;
    const double micrometerToMeter = 1e-6;
    const double micrometerToPicometer = 1e6;
    const double micrometerToNanometer = 1e3;
    const double micrometerToMillimeter = 1e-3;
    const double micrometerToKilometer = 1e-9;
    const double micrometerToAngstrom = 1e4;
    const double micrometerToThou = micrometerToMeter * meterToThou;
    const double micrometerToInch = micrometerToMeter * meterToInch;
    const double micrometerToFoot = micrometerToMeter * meterToFoot;
    const double micrometerToYard = micrometerToMeter * meterToYard;
    const double micrometerToChain = micrometerToMeter * meterToChain;
    const double micrometerToFurlong = micrometerToMeter * meterToFurlong;
    const double micrometerToMile = micrometerToMeter * meterToMile;
    const double micrometerToFathom = micrometerToMeter * meterToFathom;
    const double micrometerToCable = micrometerToMeter * meterToCable;
    const double micrometerToNauticalMile =
        micrometerToMeter * meterToNauticalMile;
    const double micrometerToAstronomicalUnit =
        micrometerToMeter * meterToAstronomicalUnit;
    const double micrometerToLightYear = micrometerToMeter * meterToLightYear;
    const double micrometerToParsec = micrometerToMeter * meterToParsec;
// Conversion constants from Kilometers to other units
    const double kilometerToMicrometer = 1e9;
    const double kilometerToCentimeter = 1e5;
    const double kilometerToMeter = 1e3;
    const double kilometerToPicometer = 1e12;
    const double kilometerToNanometer = 1e12;
    const double kilometerToMillimeter = 1e6;
    const double kilometerToAngstrom = 1e13;
    const double kilometerToThou = kilometerToMeter * meterToThou;
    const double kilometerToInch = kilometerToMeter * meterToInch;
    const double kilometerToFoot = kilometerToMeter * meterToFoot;
    const double kilometerToYard = kilometerToMeter * meterToYard;
    const double kilometerToChain = kilometerToMeter * meterToChain;
    const double kilometerToFurlong = kilometerToMeter * meterToFurlong;
    const double kilometerToMile = kilometerToMeter * meterToMile;
    const double kilometerToFathom = kilometerToMeter * meterToFathom;
    const double kilometerToCable = kilometerToMeter * meterToCable;
    const double kilometerToNauticalMile =
        kilometerToMeter * meterToNauticalMile;
    const double kilometerToAstronomicalUnit =
        kilometerToMeter * meterToAstronomicalUnit;
    const double kilometerToLightYear = kilometerToMeter * meterToLightYear;
    const double kilometerToParsec = kilometerToMeter * meterToParsec;

    // Conversion constants from Angstroms to other units
    const double angstromToMicrometer = 1e-4;
    const double angstromToCentimeter = 1e-8;
    const double angstromToMeter = 1e-10;
    const double angstromToPicometer = 100;
    const double angstromToNanometer = 0.1;
    const double angstromToMillimeter = 1e-7;
    const double angstromToKilometer = 1e-13;
    const double angstromToThou = angstromToMeter * meterToThou;
    const double angstromToInch = angstromToMeter * meterToInch;
    const double angstromToFoot = angstromToMeter * meterToFoot;
    const double angstromToYard = angstromToMeter * meterToYard;
    const double angstromToChain = angstromToMeter * meterToChain;
    const double angstromToFurlong = angstromToMeter * meterToFurlong;
    const double angstromToMile = angstromToMeter * meterToMile;
    const double angstromToFathom = angstromToMeter * meterToFathom;
    const double angstromToCable = angstromToMeter * meterToCable;
    const double angstromToNauticalMile = angstromToMeter * meterToNauticalMile;
    const double angstromToAstronomicalUnit =
        angstromToMeter * meterToAstronomicalUnit;
    const double angstromToLightYear = angstromToMeter * meterToLightYear;
    const double angstromToParsec = angstromToMeter * meterToParsec;
// Conversion constants from Thou (thousandths of an inch) to other units
    const double thouToMicrometer = 25.4;
    const double thouToCentimeter = 0.0254;
    const double thouToMeter = 0.0000254;
    const double thouToPicometer = 25.4e9;
    const double thouToNanometer = 25.4e6;
    const double thouToMillimeter = 0.0254;
    const double thouToKilometer = 2.54e-8;
    const double thouToAngstrom = 254e7;
    const double thouToInch = 0.001;
    const double thouToFoot = thouToInch / 12;
    const double thouToYard = thouToFoot / 3;
    const double thouToChain = thouToYard / 22;
    const double thouToFurlong = thouToChain / 10;
    const double thouToMile = thouToYard / 1760;
    const double thouToFathom = thouToYard / 2;
    const double thouToCable = thouToYard / 202.5;
    const double thouToNauticalMile = thouToYard / 2025;
    const double thouToAstronomicalUnit = thouToMeter / 149597870700;
    const double thouToLightYear = thouToMeter / (9.461e15);
    const double thouToParsec = thouToMeter / (3.086e16);
// Conversion constants from Inches to other units
    const double inchToMicrometer = 25400;
    const double inchToCentimeter = 2.54;
    const double inchToMeter = 0.0254;
    const double inchToPicometer = 2.54e10;
    const double inchToNanometer = 2.54e7;
    const double inchToMillimeter = 25.4;
    const double inchToKilometer = 2.54e-5;
    const double inchToAngstrom = 2.54e8;
    const double inchToThou = 1000;
    const double inchToFoot = 1 / 12.0;
    const double inchToYard = 1 / 36.0;
    const double inchToChain = inchToMeter / 20.1168;
    const double inchToFurlong = inchToMeter / 201.168;
    const double inchToMile = inchToMeter / 1609.344;
    const double inchToFathom = inchToMeter / 1.8288;
    const double inchToCable = inchToMeter / 185.2;
    const double inchToNauticalMile = inchToMeter / 1852;
    const double inchToAstronomicalUnit = inchToMeter / 149597870700;
    const double inchToLightYear = inchToMeter / (9.461e15);
    const double inchToParsec = inchToMeter / (3.086e16);
// Conversion constants from Feet to other units
    const double footToMicrometer = 304800;
    const double footToCentimeter = 30.48;
    const double footToMeter = 0.3048;
    const double footToPicometer = 3.048e11;
    const double footToNanometer = 3.048e8;
    const double footToMillimeter = 304.8;
    const double footToKilometer = 3.048e-4;
    const double footToAngstrom = 3.048e9;
    const double footToThou = 12000;
    const double footToInch = 12;
    const double footToYard = 1 / 3.0;
    const double footToChain = footToMeter / 20.1168;
    const double footToFurlong = footToMeter / 201.168;
    const double footToMile = footToMeter / 1609.344;
    const double footToFathom = footToMeter / 1.8288;
    const double footToCable = footToMeter / 185.2;
    const double footToNauticalMile = footToMeter / 1852;
    const double footToAstronomicalUnit = footToMeter / 149597870700;
    const double footToLightYear = footToMeter / (9.461e15);
    const double footToParsec = footToMeter / (3.086e16);
    // Conversion constants from Yards to other units
    const double yardToMicrometer = 914400;
    const double yardToCentimeter = 91.44;
    const double yardToMeter = 0.9144;
    const double yardToPicometer = 9.144e11;
    const double yardToNanometer = 9.144e8;
    const double yardToMillimeter = 914.4;
    const double yardToKilometer = 9.144e-4;
    const double yardToAngstrom = 9.144e9;
    const double yardToThou = 36000;
    const double yardToInch = 36;
    const double yardToFoot = 3;
    const double yardToChain = yardToMeter / 20.1168;
    const double yardToFurlong = yardToMeter / 201.168;
    const double yardToMile = yardToMeter / 1609.344;
    const double yardToFathom = yardToMeter / 1.8288;
    const double yardToCable = yardToMeter / 185.2;
    const double yardToNauticalMile = yardToMeter / 1852;
    const double yardToAstronomicalUnit = yardToMeter / 149597870700;
    const double yardToLightYear = yardToMeter / (9.461e15);
    const double yardToParsec = yardToMeter / (3.086e16);
    // Conversion constants from Chains to other units
    const double chainToMicrometer = 2.01168e7;
    const double chainToCentimeter = 2011.68;
    const double chainToMeter = 20.1168;
    const double chainToPicometer = 2.01168e13;
    const double chainToNanometer = 2.01168e10;
    const double chainToMillimeter = 20116.8;
    const double chainToKilometer = 0.0201168;
    const double chainToAngstrom = 2.01168e11;
    const double chainToThou = 20116800;
    const double chainToInch = 792;
    const double chainToFoot = 66;
    const double chainToYard = 22;
    const double chainToFurlong = 0.1;
    const double chainToMile = 0.0125;
    const double chainToFathom = 11;
    const double chainToCable = chainToMeter / 185.2;
    const double chainToNauticalMile = chainToMeter / 1852;
    const double chainToAstronomicalUnit = chainToMeter / 149597870700;
    const double chainToLightYear = chainToMeter / (9.461e15);
    const double chainToParsec = chainToMeter / (3.086e16);
    // Conversion constants from Furlongs to other units
    const double furlongToMicrometer = 2.01168e8;
    const double furlongToCentimeter = 20116.8;
    const double furlongToMeter = 201.168;
    const double furlongToPicometer = 2.01168e14;
    const double furlongToNanometer = 2.01168e11;
    const double furlongToMillimeter = 201168;
    const double furlongToKilometer = 0.201168;
    const double furlongToAngstrom = 2.01168e12;
    const double furlongToThou = 2.01168e9;
    const double furlongToInch = 7920;
    const double furlongToFoot = 660;
    const double furlongToYard = 220;
    const double furlongToChain = 10;
    const double furlongToMile = 0.125;
    const double furlongToFathom = 110;
    const double furlongToCable = furlongToMeter / 185.2;
    const double furlongToNauticalMile = furlongToMeter / 1852;
    const double furlongToAstronomicalUnit = furlongToMeter / 149597870700;
    const double furlongToLightYear = furlongToMeter / (9.461e15);
    const double furlongToParsec = furlongToMeter / (3.086e16);
    // Conversion constants from Miles to other units
    const double mileToMicrometer = 1.609344e9;
    const double mileToCentimeter = 1.609344e5;
    const double mileToMeter = 1609.344;
    const double mileToPicometer = 1.609344e15;
    const double mileToNanometer = 1.609344e12;
    const double mileToMillimeter = 1.609344e6;
    const double mileToKilometer = 1.609344;
    const double mileToAngstrom = 1.609344e13;
    const double mileToThou = 1.609344e7;
    const double mileToInch = 63360;
    const double mileToFoot = 5280;
    const double mileToYard = 1760;
    const double mileToChain = mileToMeter / 20.1168;
    const double mileToFurlong = 8;
    const double mileToFathom = mileToYard * 2;
    const double mileToCable = mileToMeter / 185.2;
    const double mileToNauticalMile = mileToMeter / 1852;
    const double mileToAstronomicalUnit = mileToMeter / 149597870700;
    const double mileToLightYear = mileToMeter / (9.461e15);
    const double mileToParsec = mileToMeter / (3.086e16);
    // Conversion constants from Fathoms to other units
    const double fathomToMicrometer = 1828800;
    const double fathomToCentimeter = 182.88;
    const double fathomToMeter = 1.8288;
    const double fathomToPicometer = 1.8288e12;
    const double fathomToNanometer = 1.8288e9;
    const double fathomToMillimeter = 1828.8;
    const double fathomToKilometer = 0.0018288;
    const double fathomToAngstrom = 1.8288e10;
    const double fathomToThou = 72000;
    const double fathomToInch = 72;
    const double fathomToFoot = 6;
    const double fathomToYard = 2;
    const double fathomToChain = fathomToMeter / 20.1168;
    const double fathomToFurlong = fathomToMeter / 201.168;
    const double fathomToMile = fathomToMeter / 1609.344;
    const double fathomToCable = fathomToMeter / 185.2;
    const double fathomToNauticalMile = fathomToMeter / 1852;
    const double fathomToAstronomicalUnit = fathomToMeter / 149597870700;
    const double fathomToLightYear = fathomToMeter / (9.461e15);
    const double fathomToParsec = fathomToMeter / (3.086e16);
    // Conversion constants from Cables to other units
    const double cableToMicrometer = 185200000;
    const double cableToCentimeter = 185200;
    const double cableToMeter = 185.2;
    const double cableToPicometer = 1.852e14;
    const double cableToNanometer = 1.852e11;
    const double cableToMillimeter = 185200;
    const double cableToKilometer = 0.1852;
    const double cableToAngstrom = 1.852e12;
    const double cableToThou = 7.28346457e6;
    const double cableToInch = 7283.46457;
    const double cableToFoot = 607.788714;
    const double cableToYard = 202.596238;
    const double cableToChain =
        9.1; // Approximate value, since one cable is roughly 1/10 of a chain
    const double cableToFurlong = cableToMeter / 201.168;
    const double cableToMile = cableToMeter / 1609.344;
    const double cableToFathom = cableToMeter / 1.8288;
    const double cableToNauticalMile =
        1 / 10.0; // There are approximately 10 cables in a nautical mile
    const double cableToAstronomicalUnit = cableToMeter / 149597870700;
    const double cableToLightYear = cableToMeter / (9.461e15);
    const double cableToParsec = cableToMeter / (3.086e16);
    // Conversion constants from Nautical Miles to other units
    const double nauticalMileToMicrometer = 1.852e9;
    const double nauticalMileToCentimeter = 1.852e5;
    const double nauticalMileToMeter = 1852;
    const double nauticalMileToPicometer = 1.852e15;
    const double nauticalMileToNanometer = 1.852e12;
    const double nauticalMileToMillimeter = 1.852e6;
    const double nauticalMileToKilometer = 1.852;
    const double nauticalMileToAngstrom = 1.852e13;
    const double nauticalMileToThou = 1.852e8;
    const double nauticalMileToInch = 72913.3858;
    const double nauticalMileToFoot = 6076.11549;
    const double nauticalMileToYard = 2025.37183;
    const double nauticalMileToChain = nauticalMileToMeter / 20.1168;
    const double nauticalMileToFurlong = nauticalMileToMeter / 201.168;
    const double nauticalMileToMile = nauticalMileToMeter / 1609.344;
    const double nauticalMileToFathom = nauticalMileToMeter / 1.8288;
    const double nauticalMileToCable =
        10; // Nautical miles to cables is a defined conversion
    const double nauticalMileToAstronomicalUnit =
        nauticalMileToMeter / 149597870700;
    const double nauticalMileToLightYear = nauticalMileToMeter / (9.461e15);
    const double nauticalMileToParsec = nauticalMileToMeter / (3.086e16);
    // Conversion constants from Astronomical Units to other units
    const double auToMicrometer = 1.496e14;
    const double auToCentimeter = 1.496e12;
    const double auToMeter = 1.496e11;
    const double auToPicometer = 1.496e23;
    const double auToNanometer = 1.496e17;
    const double auToMillimeter = 1.496e14;
    const double auToKilometer = 1.496e8;
    const double auToAngstrom = 1.496e21;
    const double auToThou = 5.889e12;
    const double auToInch = 5.889e10;
    const double auToFoot = 4.908e9;
    const double auToYard = 1.636e9;
    const double auToChain = 7.472e7;
    const double auToFurlong = 9.340e6;
    const double auToMile = 9.296e7;
    const double auToFathom = 8.172e8;
    const double auToCable = 7.728e7;
    const double auToNauticalMile = 8.05e7;
    const double auToLightYear = auToMeter / (9.461e15);
    const double auToParsec = auToMeter / (3.086e16);
    // Conversion constants from Light Years to other units
    const double lightYearToMicrometer = 9.461e21;
    const double lightYearToCentimeter = 9.461e17;
    const double lightYearToMeter = 9.461e15;
    const double lightYearToPicometer = 9.461e27;
    const double lightYearToNanometer = 9.461e24;
    const double lightYearToMillimeter = 9.461e18;
    const double lightYearToKilometer = 9.461e12;
    const double lightYearToAngstrom = 9.461e25;
    const double lightYearToThou = 3.724e20;
    const double lightYearToInch = 3.724e19;
    const double lightYearToFoot = 3.103e18;
    const double lightYearToYard = 1.034e18;
    const double lightYearToChain = 4.708e16;
    const double lightYearToFurlong = 5.885e15;
    const double lightYearToMile = 5.879e12;
    const double lightYearToFathom = 5.182e17;
    const double lightYearToCable = 4.845e14;
    const double lightYearToNauticalMile = 5.108e12;
    const double lightYearToAstronomicalUnit = lightYearToMeter / 149597870700;
    const double lightYearToParsec = lightYearToMeter / 3.086e16;
    // Conversion constants from Parsecs to other units
    const double parsecToMicrometer = 3.086e22;
    const double parsecToCentimeter = 3.086e18;
    const double parsecToMeter = 3.086e16;
    const double parsecToPicometer = 3.086e28;
    const double parsecToNanometer = 3.086e25;
    const double parsecToMillimeter = 3.086e19;
    const double parsecToKilometer = 3.086e13;
    const double parsecToAngstrom = 3.086e27;
    const double parsecToThou = 1.21483369e21;
    const double parsecToInch = 1.21483369e20;
    const double parsecToFoot = 1.01236141e19;
    const double parsecToYard = 3.37453804e18;
    const double parsecToChain = 1.53824524e17;
    const double parsecToFurlong = 1.92280655e16;
    const double parsecToMile = 1.91735122e13;
    const double parsecToFathom = 1.68626902e18;
    const double parsecToCable = 1.56974849e15;
    const double parsecToNauticalMile = 1.67219021e13;
    const double parsecToAstronomicalUnit = parsecToMeter / 149597870700;
    const double parsecToLightYear = parsecToMeter / 9.461e15;
    // endregion
    switch (fromUnit) {
      // METERS UNIT CONVERSION
      case 'Meters':
        switch (toUnit) {
          case 'Picometers':
            toValue = fromValue * meterToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * meterToNanometer;
            break;
          case 'Micrometers':
            toValue = fromValue * meterToMicrometer;
            break;
          case 'Millimeters':
            toValue = fromValue * meterToMillimeter;
            break;
          case 'Centimeters':
            toValue = fromValue * meterToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue;
            break;
          case 'Kilometers':
            toValue = fromValue * meterToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * meterToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * meterToThou;
            break;
          case 'Inches':
            toValue = fromValue * meterToInch;
            break;
          case 'Feet':
            toValue = fromValue * meterToFoot;
            break;
          case 'Yards':
            toValue = fromValue * meterToYard;
            break;
          case 'Chains':
            toValue = fromValue * meterToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * meterToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * meterToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * meterToFathom;
            break;
          case 'Cables':
            toValue = fromValue * meterToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * meterToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * meterToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * meterToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * meterToParsec;
            break;
        }
        break;
// PICOMETERS UNIT CONVERSION
      case 'Picometers':
        switch (toUnit) {
          case 'Picometers':
            toValue = fromValue;
            break;
          case 'Nanometers':
            toValue = fromValue / picometerToNanometer;
            break;
          case 'Micrometers':
            toValue = fromValue / picometerToMicrometer;
            break;
          case 'Millimeters':
            toValue = fromValue / picometerToMillimeter;
            break;
          case 'Centimeters':
            toValue = fromValue / picometerToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue / meterToPicometer;
            break;
          case 'Kilometers':
            toValue = fromValue / picometerToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue / picometerToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue / picometerToThou;
            break;
          case 'Inches':
            toValue = fromValue / picometerToInch;
            break;
          case 'Feet':
            toValue = fromValue / picometerToFoot;
            break;
          case 'Yards':
            toValue = fromValue / picometerToYard;
            break;
          case 'Chains':
            toValue = fromValue / picometerToChain;
            break;
          case 'Furlongs':
            toValue = fromValue / picometerToFurlong;
            break;
          case 'Miles':
            toValue = fromValue / picometerToMile;
            break;
          case 'Fathoms':
            toValue = fromValue / picometerToFathom;
            break;
          case 'Cables':
            toValue = fromValue / picometerToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue / picometerToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue / picometerToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * picometerToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * picometerToParsec;
            break;
          // Add cases for any additional units here
        }
        break;
// NANOMETERS UNIT CONVERSION
      case 'Nanometers':
        switch (toUnit) {
          case 'Nanometers':
            toValue = fromValue;
            break;
          case 'Picometers':
            toValue = fromValue * nanometerToPicometer;
            break;
          case 'Micrometers':
            toValue = fromValue * nanometerToMicrometer;
            break;
          case 'Millimeters':
            toValue = fromValue * nanometerToMillimeter;
            break;
          case 'Centimeters':
            toValue = fromValue * nanometerToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * nanometerToMeter;
            break;
          case 'Kilometers':
            toValue = fromValue * nanometerToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * nanometerToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * nanometerToThou;
            break;
          case 'Inches':
            toValue = fromValue * nanometerToInch;
            break;
          case 'Feet':
            toValue = fromValue * nanometerToFoot;
            break;
          case 'Yards':
            toValue = fromValue * nanometerToYard;
            break;
          case 'Chains':
            toValue = fromValue * nanometerToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * nanometerToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * nanometerToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * nanometerToFathom;
            break;
          case 'Cables':
            toValue = fromValue * nanometerToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * nanometerToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * nanometerToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * nanometerToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * nanometerToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;

      // ... repeat similar structure for Micrometers, Millimeters, etc. ...
// CENTIMETERS UNIT CONVERSION
      case 'Centimeters':
        switch (toUnit) {
          case 'Centimeters':
            toValue = fromValue;
            break;
          case 'Meters':
            toValue = fromValue * centimeterToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * centimeterToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * centimeterToNanometer;
            break;
          case 'Micrometers':
            toValue = fromValue * centimeterToMicrometer;
            break;
          case 'Millimeters':
            toValue = fromValue * centimeterToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * centimeterToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * centimeterToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * centimeterToThou;
            break;
          case 'Inches':
            toValue = fromValue * centimeterToInch;
            break;
          case 'Feet':
            toValue = fromValue * centimeterToFoot;
            break;
          case 'Yards':
            toValue = fromValue * centimeterToYard;
            break;
          case 'Chains':
            toValue = fromValue * centimeterToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * centimeterToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * centimeterToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * centimeterToFathom;
            break;
          case 'Cables':
            toValue = fromValue * centimeterToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * centimeterToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * centimeterToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * centimeterToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * centimeterToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;

// MILLIMETERS UNIT CONVERSION
      case 'Millimeters':
        switch (toUnit) {
          case 'Millimeters':
            toValue = fromValue;
            break;
          case 'Centimeters':
            toValue = fromValue * millimeterToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * millimeterToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * millimeterToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * millimeterToNanometer;
            break;
          case 'Micrometers':
            toValue = fromValue * millimeterToMicrometer;
            break;
          case 'Kilometers':
            toValue = fromValue * millimeterToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * millimeterToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * millimeterToThou;
            break;
          case 'Inches':
            toValue = fromValue * millimeterToInch;
            break;
          case 'Feet':
            toValue = fromValue * millimeterToFoot;
            break;
          case 'Yards':
            toValue = fromValue * millimeterToYard;
            break;
          case 'Chains':
            toValue = fromValue * millimeterToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * millimeterToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * millimeterToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * millimeterToFathom;
            break;
          case 'Cables':
            toValue = fromValue * millimeterToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * millimeterToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * millimeterToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * millimeterToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * millimeterToParsec;
            break;
        }

        break;

// MICROMETERS UNIT CONVERSION
      case 'Micrometers':
        switch (toUnit) {
          case 'Micrometers':
            toValue = fromValue;
            break;
          case 'Centimeters':
            toValue = fromValue * micrometerToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * micrometerToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * micrometerToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * micrometerToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * micrometerToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * micrometerToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * micrometerToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * micrometerToThou;
            break;
          case 'Inches':
            toValue = fromValue * micrometerToInch;
            break;
          case 'Feet':
            toValue = fromValue * micrometerToFoot;
            break;
          case 'Yards':
            toValue = fromValue * micrometerToYard;
            break;
          case 'Chains':
            toValue = fromValue * micrometerToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * micrometerToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * micrometerToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * micrometerToFathom;
            break;
          case 'Cables':
            toValue = fromValue * micrometerToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * micrometerToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * micrometerToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * micrometerToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * micrometerToParsec;
            break;
        }

        break;

      // KILOMETERS UNIT CONVERSION
      case 'Kilometers':
        switch (toUnit) {
          case 'Kilometers':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * kilometerToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * kilometerToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * kilometerToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * kilometerToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * kilometerToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * kilometerToMillimeter;
            break;
          case 'Angstrom':
            toValue = fromValue * kilometerToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * kilometerToThou;
            break;
          case 'Inches':
            toValue = fromValue * kilometerToInch;
            break;
          case 'Feet':
            toValue = fromValue * kilometerToFoot;
            break;
          case 'Yards':
            toValue = fromValue * kilometerToYard;
            break;
          case 'Chains':
            toValue = fromValue * kilometerToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * kilometerToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * kilometerToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * kilometerToFathom;
            break;
          case 'Cables':
            toValue = fromValue * kilometerToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * kilometerToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * kilometerToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * kilometerToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * kilometerToParsec;
            break;
        }

        break;

      // ANGSTROM UNIT CONVERSION
      case 'Angstrom':
        switch (toUnit) {
          case 'Angstrom':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * angstromToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * angstromToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * angstromToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * angstromToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * angstromToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * angstromToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * angstromToKilometer;
            break;
          case 'Thou':
            toValue = fromValue * angstromToThou;
            break;
          case 'Inches':
            toValue = fromValue * angstromToInch;
            break;
          case 'Feet':
            toValue = fromValue * angstromToFoot;
            break;
          case 'Yards':
            toValue = fromValue * angstromToYard;
            break;
          case 'Chains':
            toValue = fromValue * angstromToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * angstromToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * angstromToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * angstromToFathom;
            break;
          case 'Cables':
            toValue = fromValue * angstromToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * angstromToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * angstromToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * angstromToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * angstromToParsec;
            break;
        }

        break;
// THOU UNIT CONVERSION
      case 'Thou':
        switch (toUnit) {
          case 'Thou':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * thouToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * thouToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * thouToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * thouToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * thouToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * thouToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * thouToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * thouToAngstrom;
            break;
          case 'Inches':
            toValue = fromValue * thouToInch;
            break;
          case 'Feet':
            toValue = fromValue * thouToFoot;
            break;
          case 'Yards':
            toValue = fromValue * thouToYard;
            break;
          case 'Chains':
            toValue = fromValue * thouToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * thouToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * thouToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * thouToFathom;
            break;
          case 'Cables':
            toValue = fromValue * thouToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * thouToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * thouToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * thouToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * thouToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;
      // ... and so on for each unit ...
      case 'Inches':
        switch (toUnit) {
          case 'Inches':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * inchToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * inchToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * inchToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * inchToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * inchToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * inchToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * inchToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * inchToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * inchToThou;
            break;
          case 'Feet':
            toValue = fromValue * inchToFoot;
            break;
          case 'Yards':
            toValue = fromValue * inchToYard;
            break;
          case 'Chains':
            toValue = fromValue * inchToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * inchToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * inchToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * inchToFathom;
            break;
          case 'Cables':
            toValue = fromValue * inchToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * inchToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * inchToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * inchToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * inchToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;

      case 'Feet':
        switch (toUnit) {
          case 'Feet':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * footToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * footToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * footToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * footToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * footToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * footToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * footToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * footToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * footToThou;
            break;
          case 'Inches':
            toValue = fromValue * footToInch;
            break;
          case 'Yards':
            toValue = fromValue * footToYard;
            break;
          case 'Chains':
            toValue = fromValue * footToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * footToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * footToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * footToFathom;
            break;
          case 'Cables':
            toValue = fromValue * footToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * footToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * footToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * footToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * footToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;
      case 'Yards':
        switch (toUnit) {
          case 'Yards':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * yardToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * yardToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * yardToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * yardToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * yardToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * yardToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * yardToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * yardToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * yardToThou;
            break;
          case 'Inches':
            toValue = fromValue * yardToInch;
            break;
          case 'Feet':
            toValue = fromValue * yardToFoot;
            break;
          case 'Chains':
            toValue = fromValue * yardToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * yardToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * yardToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * yardToFathom;
            break;
          case 'Cables':
            toValue = fromValue * yardToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * yardToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * yardToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * yardToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * yardToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;
      case 'Chains':
        switch (toUnit) {
          case 'Chains':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * chainToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * chainToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * chainToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * chainToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * chainToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * chainToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * chainToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * chainToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * chainToThou;
            break;
          case 'Inches':
            toValue = fromValue * chainToInch;
            break;
          case 'Feet':
            toValue = fromValue * chainToFoot;
            break;
          case 'Yards':
            toValue = fromValue * chainToYard;
            break;
          case 'Furlongs':
            toValue = fromValue * chainToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * chainToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * chainToFathom;
            break;
          case 'Cables':
            toValue = fromValue * chainToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * chainToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * chainToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * chainToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * chainToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;
      case 'Furlongs':
        switch (toUnit) {
          case 'Furlongs':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * furlongToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * furlongToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * furlongToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * furlongToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * furlongToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * furlongToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * furlongToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * furlongToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * furlongToThou;
            break;
          case 'Inches':
            toValue = fromValue * furlongToInch;
            break;
          case 'Feet':
            toValue = fromValue * furlongToFoot;
            break;
          case 'Yards':
            toValue = fromValue * furlongToYard;
            break;
          case 'Chains':
            toValue = fromValue * furlongToChain;
            break;
          case 'Miles':
            toValue = fromValue * furlongToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * furlongToFathom;
            break;
          case 'Cables':
            toValue = fromValue * furlongToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * furlongToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * furlongToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * furlongToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * furlongToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;

      case 'Miles':
        switch (toUnit) {
          case 'Miles':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * mileToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * mileToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * mileToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * mileToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * mileToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * mileToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * mileToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * mileToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * mileToThou;
            break;
          case 'Inches':
            toValue = fromValue * mileToInch;
            break;
          case 'Feet':
            toValue = fromValue * mileToFoot;
            break;
          case 'Yards':
            toValue = fromValue * mileToYard;
            break;
          case 'Chains':
            toValue = fromValue * mileToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * mileToFurlong;
            break;
          case 'Fathoms':
            toValue = fromValue * mileToFathom;
            break;
          case 'Cables':
            toValue = fromValue * mileToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * mileToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * mileToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * mileToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * mileToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;

      case 'Fathoms':
        switch (toUnit) {
          case 'Fathoms':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * fathomToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * fathomToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * fathomToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * fathomToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * fathomToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * fathomToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * fathomToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * fathomToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * fathomToThou;
            break;
          case 'Inches':
            toValue = fromValue * fathomToInch;
            break;
          case 'Feet':
            toValue = fromValue * fathomToFoot;
            break;
          case 'Yards':
            toValue = fromValue * fathomToYard;
            break;
          case 'Chains':
            toValue = fromValue * fathomToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * fathomToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * fathomToMile;
            break;
          case 'Cables':
            toValue = fromValue * fathomToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * fathomToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * fathomToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * fathomToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * fathomToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;
      case 'Cables':
        switch (toUnit) {
          case 'Cables':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * cableToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * cableToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * cableToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * cableToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * cableToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * cableToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * cableToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * cableToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * cableToThou;
            break;
          case 'Inches':
            toValue = fromValue * cableToInch;
            break;
          case 'Feet':
            toValue = fromValue * cableToFoot;
            break;
          case 'Yards':
            toValue = fromValue * cableToYard;
            break;
          case 'Chains':
            toValue = fromValue * cableToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * cableToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * cableToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * cableToFathom;
            break;
          case 'Nautical miles':
            toValue = fromValue * cableToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * cableToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * cableToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * cableToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;
      //CASE FOR NAUTICAL MILES
      case 'Nautical miles':
        switch (toUnit) {
          case 'Nautical miles':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * nauticalMileToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * nauticalMileToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * nauticalMileToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * nauticalMileToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * nauticalMileToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * nauticalMileToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * nauticalMileToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * nauticalMileToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * nauticalMileToThou;
            break;
          case 'Inches':
            toValue = fromValue * nauticalMileToInch;
            break;
          case 'Feet':
            toValue = fromValue * nauticalMileToFoot;
            break;
          case 'Yards':
            toValue = fromValue * nauticalMileToYard;
            break;
          case 'Chains':
            toValue = fromValue * nauticalMileToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * nauticalMileToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * nauticalMileToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * nauticalMileToFathom;
            break;
          case 'Cables':
            toValue = fromValue * nauticalMileToCable;
            break;
          case 'Astronomical units':
            toValue = fromValue * nauticalMileToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * nauticalMileToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * nauticalMileToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;

      case 'Astronomical units':
        switch (toUnit) {
          case 'Astronomical units':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * auToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * auToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * auToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * auToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * auToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * auToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * auToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * auToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * auToThou;
            break;
          case 'Inches':
            toValue = fromValue * auToInch;
            break;
          case 'Feet':
            toValue = fromValue * auToFoot;
            break;
          case 'Yards':
            toValue = fromValue * auToYard;
            break;
          case 'Chains':
            toValue = fromValue * auToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * auToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * auToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * auToFathom;
            break;
          case 'Cables':
            toValue = fromValue * auToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * auToNauticalMile;
            break;
          case 'Light years':
            toValue = fromValue * auToLightYear;
            break;
          case 'Parsecs':
            toValue = fromValue * auToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;

      case 'Light years':
        switch (toUnit) {
          case 'Light years':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * lightYearToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * lightYearToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * lightYearToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * lightYearToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * lightYearToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * lightYearToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * lightYearToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * lightYearToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * lightYearToThou;
            break;
          case 'Inches':
            toValue = fromValue * lightYearToInch;
            break;
          case 'Feet':
            toValue = fromValue * lightYearToFoot;
            break;
          case 'Yards':
            toValue = fromValue * lightYearToYard;
            break;
          case 'Chains':
            toValue = fromValue * lightYearToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * lightYearToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * lightYearToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * lightYearToFathom;
            break;
          case 'Cables':
            toValue = fromValue * lightYearToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * lightYearToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * lightYearToAstronomicalUnit;
            break;
          case 'Parsecs':
            toValue = fromValue * lightYearToParsec;
            break;
          // ... repeat for each unit ...
        }
        break;

      case 'Parsecs':
        switch (toUnit) {
          case 'Parsecs':
            toValue = fromValue;
            break;
          case 'Micrometers':
            toValue = fromValue * parsecToMicrometer;
            break;
          case 'Centimeters':
            toValue = fromValue * parsecToCentimeter;
            break;
          case 'Meters':
            toValue = fromValue * parsecToMeter;
            break;
          case 'Picometers':
            toValue = fromValue * parsecToPicometer;
            break;
          case 'Nanometers':
            toValue = fromValue * parsecToNanometer;
            break;
          case 'Millimeters':
            toValue = fromValue * parsecToMillimeter;
            break;
          case 'Kilometers':
            toValue = fromValue * parsecToKilometer;
            break;
          case 'Angstrom':
            toValue = fromValue * parsecToAngstrom;
            break;
          case 'Thou':
            toValue = fromValue * parsecToThou;
            break;
          case 'Inches':
            toValue = fromValue * parsecToInch;
            break;
          case 'Feet':
            toValue = fromValue * parsecToFoot;
            break;
          case 'Yards':
            toValue = fromValue * parsecToYard;
            break;
          case 'Chains':
            toValue = fromValue * parsecToChain;
            break;
          case 'Furlongs':
            toValue = fromValue * parsecToFurlong;
            break;
          case 'Miles':
            toValue = fromValue * parsecToMile;
            break;
          case 'Fathoms':
            toValue = fromValue * parsecToFathom;
            break;
          case 'Cables':
            toValue = fromValue * parsecToCable;
            break;
          case 'Nautical miles':
            toValue = fromValue * parsecToNauticalMile;
            break;
          case 'Astronomical units':
            toValue = fromValue * parsecToAstronomicalUnit;
            break;
          case 'Light years':
            toValue = fromValue * parsecToLightYear;
            break;
          // ... repeat for each unit ...
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
      case 'Meters':
        switch (toUnit) {
          case 'Picometers':
            formula = 'Multiply the length value by 1,000,000,000,000';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 1,000,000,000';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 1,000,000';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 1,000';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 100';
            break;
          case 'Meters':
            formula = 'The value remains unchanged';
            break;
          case 'Kilometers':
            formula = 'Divide the length value by 1,000';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 10,000,000,000';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 39,370.0787';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 39.3701';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 3.28084';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 1.09361';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 0.0497097';
            break;
          case 'Furlongs':
            formula = 'Multiply the length value by 0.00497097';
            break;
          case 'Miles':
            formula = 'Multiply the length value by 0.000621371';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 0.546807';
            break;
          case 'Cables':
            formula = 'Multiply the length value by 0.00539957';
            break;
          case 'Nautical miles':
            formula = 'Multiply the length value by 0.000539957';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 149,597,870,700';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+15';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+16';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      // PICOMETERS UNIT CONVERSION
      case 'Picometers':
        switch (toUnit) {
          case 'Picometers':
            formula = 'The value remains unchanged';
            break;
          case 'Nanometers':
            formula = 'Divide the length value by 1,000';
            break;
          case 'Micrometers':
            formula = 'Divide the length value by 1,000,000';
            break;
          case 'Millimeters':
            formula = 'Divide the length value by 1,000,000,000';
            break;
          case 'Centimeters':
            formula = 'Divide the length value by 10,000,000,000';
            break;
          case 'Meters':
            formula = 'Divide the length value by 1,000,000,000,000';
            break;
          case 'Kilometers':
            formula = 'Divide the length value by 1,000,000,000,000,000';
            break;
          case 'Angstrom':
            formula = 'Divide the length value by 100';
            break;
          case 'Thou':
            formula = 'Divide the length value by 25,400,000,000';
            break;
          case 'Inches':
            formula = 'Divide the length value by 25,400,000,000,000';
            break;
          case 'Feet':
            formula = 'Divide the length value by 304,800,000,000,000';
            break;
          case 'Yards':
            formula = 'Divide the length value by 914,400,000,000,000';
            break;
          case 'Chains':
            formula = 'Divide the length value by 20,116,800,000,000,000';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 201,168,000,000,000,000';
            break;
          case 'Miles':
            formula = 'Divide the length value by 1,609,344,000,000,000,000';
            break;
          case 'Fathoms':
            formula = 'Divide the length value by 1,828,800,000,000,000';
            break;
          case 'Cables':
            formula = 'Divide the length value by 185,200,000,000,000';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 1,852,000,000,000,000,000';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.496e+23';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+28';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+28';
            break;
// Add cases for any additional units here
          default:
            formula = 'Unknown conversion';
            break;
        }
        break; // This breaks out of the 'Picometers' case

      // NANOMETERS UNIT CONVERSION
      case 'Nanometers':
        switch (toUnit) {
          case 'Nanometers':
            formula = 'The value remains unchanged';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 1,000';
            break;
          case 'Micrometers':
            formula = 'Divide the length value by 1,000';
            break;
          case 'Millimeters':
            formula = 'Divide the length value by 1,000,000';
            break;
          case 'Centimeters':
            formula = 'Divide the length value by 10,000,000';
            break;
          case 'Meters':
            formula = 'Divide the length value by 1,000,000,000';
            break;
          case 'Kilometers':
            formula = 'Divide the length value by 1,000,000,000,000';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 10';
            break;
          case 'Thou':
            formula = 'Divide the length value by 25,400,000';
            break;
          case 'Inches':
            formula = 'Divide the length value by 25,400,000,000';
            break;
          case 'Feet':
            formula = 'Divide the length value by 304,800,000,000';
            break;
          case 'Yards':
            formula = 'Divide the length value by 914,400,000,000';
            break;
          case 'Chains':
            formula = 'Divide the length value by 20,116,800,000,000';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 201,168,000,000,000';
            break;
          case 'Miles':
            formula = 'Divide the length value by 1,609,344,000,000,000';
            break;
          case 'Fathoms':
            formula = 'Divide the length value by 1,828,800,000,000';
            break;
          case 'Cables':
            formula = 'Divide the length value by 185,200,000,000,000';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 1,852,000,000,000,000';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.496e+23';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+28';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+28';
            break;

          // ... and so on for the rest of the units ...

          default:
            formula = 'Unknown conversion';
            break;
        }

      case 'Centimeters':
        switch (toUnit) {
          case 'Centimeters':
            formula = 'The value remains unchanged';
            break;
          case 'Meters':
            formula = 'Divide the length value by 100';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 10,000,000,000';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 10,000,000';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 10,000';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 10';
            break;
          case 'Kilometers':
            formula = 'Divide the length value by 100,000';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 100,000,000';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 393.700787';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 0.393700787';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 0.032808399';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 0.010936133';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 0.0049709695';
            break;
          case 'Furlongs':
            formula = 'Multiply the length value by 0.00049709695';
            break;
          case 'Miles':
            formula = 'Multiply the length value by 0.000006213712';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 0.054680665';
            break;
          case 'Cables':
            formula = 'Multiply the length value by 0.0053961182';
            break;
          case 'Nautical miles':
            formula = 'Multiply the length value by 0.000005399568';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 14959787070000';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+17';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+18';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
      case 'Millimeters':
        switch (toUnit) {
          case 'Millimeters':
            formula = 'The value remains unchanged';
            break;
          case 'Centimeters':
            formula = 'Divide the length value by 10';
            break;
          case 'Meters':
            formula = 'Divide the length value by 1,000';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 1,000,000,000';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 1,000,000';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 1,000';
            break;
          case 'Kilometers':
            formula = 'Divide the length value by 1,000,000';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 10,000,000';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 39.3700787';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 0.0393700787';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 0.0032808399';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 0.0010936133';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 0.0000497097';
            break;
          case 'Furlongs':
            formula = 'Multiply the length value by 0.00000497097';
            break;
          case 'Miles':
            formula = 'Multiply the length value by 0.000000621371192';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 0.000546806649';
            break;
          case 'Cables':
            formula = 'Multiply the length value by 0.0000539956803';
            break;
          case 'Nautical miles':
            formula = 'Multiply the length value by 0.000000539956803';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.495978707e+14';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+18';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+19';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Micrometers':
        switch (toUnit) {
          case 'Micrometers':
            formula = 'The value remains unchanged';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 1,000';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 1,000';
            break;
          case 'Millimeters':
            formula = 'Divide the length value by 1,000';
            break;
          case 'Centimeters':
            formula = 'Divide the length value by 10,000';
            break;
          case 'Meters':
            formula = 'Divide the length value by 1,000,000';
            break;
          case 'Kilometers':
            formula = 'Divide the length value by 1,000,000,000';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 10,000';
            break;
          case 'Thou':
            formula = 'Divide the length value by 25.4';
            break;
          case 'Inches':
            formula = 'Divide the length value by 25,400';
            break;
          case 'Feet':
            formula = 'Divide the length value by 304,800';
            break;
          case 'Yards':
            formula = 'Divide the length value by 914,400';
            break;
          case 'Chains':
            formula = 'Divide the length value by 20,116,800';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 201,168,000';
            break;
          case 'Miles':
            formula = 'Divide the length value by 1,609,344,000';
            break;
          case 'Fathoms':
            formula = 'Divide the length value by 1,828,800';
            break;
          case 'Cables':
            formula = 'Divide the length value by 185,200';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 1,852,000,000';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.496e+17';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+21';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+22';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Kilometers':
        switch (toUnit) {
          case 'Kilometers':
            formula = 'The value remains unchanged';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 1,000';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 100,000';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 1,000,000';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 1,000,000,000';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 1,000,000,000,000';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 1,000,000,000,000,000';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 1e+13';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 39,370,078.7';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 39,370.0787';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 3,280.8399';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 1,093.6133';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 49.7096954';
            break;
          case 'Furlongs':
            formula = 'Multiply the length value by 4.97096954';
            break;
          case 'Miles':
            formula = 'Multiply the length value by 0.621371192';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 546.806649';
            break;
          case 'Cables':
            formula = 'Multiply the length value by 5.39956803';
            break;
          case 'Nautical miles':
            formula = 'Multiply the length value by 0.539956803';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 149.5978707';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+12';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+13';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Angstrom':
        switch (toUnit) {
          case 'Angstrom':
            formula = 'The value remains unchanged';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 100';
            break;
          case 'Nanometers':
            formula = 'Divide the length value by 10';
            break;
          case 'Micrometers':
            formula = 'Divide the length value by 10,000';
            break;
          case 'Millimeters':
            formula = 'Divide the length value by 10,000,000';
            break;
          case 'Centimeters':
            formula = 'Divide the length value by 100,000,000';
            break;
          case 'Meters':
            formula = 'Divide the length value by 1,000,000,000';
            break;
          case 'Kilometers':
            formula = 'Divide the length value by 1,000,000,000,000';
            break;
          case 'Thou':
            formula = 'Divide the length value by 254,000';
            break;
          case 'Inches':
            formula = 'Divide the length value by 25,400,000';
            break;
          case 'Feet':
            formula = 'Divide the length value by 304,800,000';
            break;
          case 'Yards':
            formula = 'Divide the length value by 914,400,000';
            break;
          case 'Chains':
            formula = 'Divide the length value by 20,116,800,000';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 201,168,000,000';
            break;
          case 'Miles':
            formula = 'Divide the length value by 1,609,344,000,000';
            break;
          case 'Fathoms':
            formula = 'Divide the length value by 1,828,800,000';
            break;
          case 'Cables':
            formula = 'Divide the length value by 185,200,000';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 1,852,000,000,000';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.496e+20';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+25';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+26';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Thou':
        switch (toUnit) {
          case 'Thou':
            formula = 'The value remains unchanged';
            break;
          case 'Inches':
            formula = 'Divide the length value by 1,000';
            break;
          case 'Feet':
            formula = 'Divide the length value by 12,000';
            break;
          case 'Yards':
            formula = 'Divide the length value by 36,000';
            break;
          case 'Miles':
            formula = 'Divide the length value by 63,360,000';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 0.0254';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 0.00254';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 0.0000254';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 2.54e-8';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 2.54e+7';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 2.54e+4';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 25.4';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 2.54e+5';
            break;
          case 'Chains':
            formula = 'Divide the length value by 792,000';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 7,920,000';
            break;
          case 'Fathoms':
            formula = 'Divide the length value by 72,000';
            break;
          case 'Cables':
            formula = 'Divide the length value by 729,000';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 7,290,000';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 2.54e+12';
            break;
          case 'Light years':
            formula = 'Divide the length value by 2.399e+20';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 7.823e+20';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Inches':
        switch (toUnit) {
          case 'Inches':
            formula = 'The value remains unchanged';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 1,000';
            break;
          case 'Feet':
            formula = 'Divide the length value by 12';
            break;
          case 'Yards':
            formula = 'Divide the length value by 36';
            break;
          case 'Miles':
            formula = 'Divide the length value by 63,360';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 25.4';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 2.54';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 0.0254';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 0.0000254';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 25.4e+9';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 25.4e+6';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 25,400';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 254,000,000';
            break;
          case 'Chains':
            formula = 'Divide the length value by 792';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 7,920';
            break;
          case 'Fathoms':
            formula = 'Divide the length value by 72';
            break;
          case 'Cables':
            formula = 'Divide the length value by 729.13';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 72,913.4';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 9.461e+12';
            break;
          case 'Light years':
            formula = 'Divide the length value by 5.879e+17';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 1.917e+18';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Feet':
        switch (toUnit) {
          case 'Feet':
            formula = 'The value remains unchanged';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 12';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 12,000';
            break;
          case 'Yards':
            formula = 'Divide the length value by 3';
            break;
          case 'Miles':
            formula = 'Divide the length value by 5,280';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 304.8';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 30.48';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 0.3048';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 0.0003048';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 304.8e+9';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 304.8e+6';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 304,800';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 3.048e+9';
            break;
          case 'Chains':
            formula = 'Divide the length value by 66';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 660';
            break;
          case 'Fathoms':
            formula = 'Divide the length value by 6';
            break;
          case 'Cables':
            formula = 'Divide the length value by 607.611';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 6,076.115';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 9.461e+11';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+16';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+17';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Yards':
        switch (toUnit) {
          case 'Yards':
            formula = 'The value remains unchanged';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 3';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 36';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 36,000';
            break;
          case 'Miles':
            formula = 'Divide the length value by 1,760';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 914.4';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 91.44';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 0.9144';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 0.0009144';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 914.4e+9';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 914.4e+6';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 914,400';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 9.144e+9';
            break;
          case 'Chains':
            formula = 'Divide the length value by 22';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 220';
            break;
          case 'Fathoms':
            formula = 'Divide the length value by 2';
            break;
          case 'Cables':
            formula = 'Divide the length value by 202.533';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 2,025.371';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 9.665e+11';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.665e+16';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.118e+17';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Chains':
        switch (toUnit) {
          case 'Chains':
            formula = 'The value remains unchanged';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 22';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 66';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 792';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 792,000';
            break;
          case 'Miles':
            formula = 'Divide the length value by 80';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 20,116.8';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 2,011.68';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 20.1168';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 0.0201168';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 20.1168e+12';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 20.1168e+9';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 20,116,800';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 201,168,000,000';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 10';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 11';
            break;
          case 'Cables':
            formula = 'Divide the length value by 9.225';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 92.25';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.341e+13';
            break;
          case 'Light years':
            formula = 'Divide the length value by 1.341e+18';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 4.134e+18';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Furlongs':
        switch (toUnit) {
          case 'Furlongs':
            formula = 'The value remains unchanged';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 10';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 220';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 660';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 7,920';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 7,920,000';
            break;
          case 'Miles':
            formula = 'Divide the length value by 8';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 201,168';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 20,116.8';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 201.168';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 0.201168';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 201.168e+12';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 201.168e+9';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 201,168,000';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 2.01168e+12';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 110';
            break;
          case 'Cables':
            formula = 'Divide the length value by 1.012';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 10.12';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.342e+12';
            break;
          case 'Light years':
            formula = 'Divide the length value by 1.342e+17';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 4.135e+17';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Miles':
        switch (toUnit) {
          case 'Miles':
            formula = 'The value remains unchanged';
            break;
          case 'Furlongs':
            formula = 'Multiply the length value by 8';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 80';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 1,760';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 5,280';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 63,360';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 63,360,000';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 1.609344';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 1,609.344';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 160,934.4';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 1,609,344';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 1,609,344,000';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 1.609344e+12';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 1.609344e+15';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 1.609344e+17';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 880';
            break;
          case 'Cables':
            formula = 'Multiply the length value by 88.781';
            break;
          case 'Nautical miles':
            formula = 'Multiply the length value by 0.868976';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 9.296e+7';
            break;
          case 'Light years':
            formula = 'Divide the length value by 5.879e+12';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 1.917e+13';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Fathoms':
        switch (toUnit) {
          case 'Fathoms':
            formula = 'The value remains unchanged';
            break;
          case 'Miles':
            formula = 'Divide the length value by 880';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 110';
            break;
          case 'Chains':
            formula = 'Divide the length value by 11';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 2';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 6';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 72';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 72,000';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 0.0018288';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 1.8288';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 182.88';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 1,828.8';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 1,828,800';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 1.8288e+9';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 1.8288e+12';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 1.8288e+13';
            break;
          case 'Cables':
            formula = 'Divide the length value by 101.2';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 1,012';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.22e+11';
            break;
          case 'Light years':
            formula = 'Divide the length value by 1.22e+16';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.77e+16';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Cables':
        switch (toUnit) {
          case 'Cables':
            formula = 'The value remains unchanged';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 101.2';
            break;
          case 'Miles':
            formula = 'Divide the length value by 10.012';
            break;
          case 'Furlongs':
            formula = 'Divide the length value by 1.2515';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 8';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 202.53';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 607.61';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 7,291.34';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 7,291,339';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 0.1852';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 185.2';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 18,520';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 185,200';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 185,200,000';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 185.2e+9';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 185.2e+12';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 1.852e+13';
            break;
          case 'Nautical miles':
            formula = 'Divide the length value by 10';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.238e+12';
            break;
          case 'Light years':
            formula = 'Divide the length value by 1.238e+17';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.819e+17';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Nautical miles':
        switch (toUnit) {
          case 'Nautical miles':
            formula = 'The value remains unchanged';
            break;
          case 'Cables':
            formula = 'Multiply the length value by 10';
            break;
          case 'Miles':
            formula = 'Multiply the length value by 1.15078';
            break;
          case 'Furlongs':
            formula = 'Multiply the length value by 9.20624';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 92.0624';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 2,025.37';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 6,076.12';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 72,913.4';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 72,913,386';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 1,012.68591';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 1.852';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 1,852';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 185,200';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 1,852,000';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 1,852,000,000';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 1.852e+12';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 1.852e+15';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 1.852e+16';
            break;
          case 'Astronomical units':
            formula = 'Divide the length value by 1.496e+8';
            break;
          case 'Light years':
            formula = 'Divide the length value by 9.461e+12';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.086e+13';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Astronomical units':
        switch (toUnit) {
          case 'Astronomical units':
            formula = 'The value remains unchanged';
            break;
          case 'Nautical miles':
            formula = 'Multiply the length value by 1.496e+8';
            break;
          case 'Miles':
            formula = 'Multiply the length value by 9.296e+7';
            break;
          case 'Furlongs':
            formula = 'Multiply the length value by 7.456e+6';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 7.456e+5';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 1.09361e+8';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 3.28084e+8';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 3.93701e+9';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 3.93701e+12';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 5.46807e+7';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 1.496e+5';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 1.496e+8';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 1.496e+10';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 1.496e+11';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 1.496e+14';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 1.496e+17';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 1.496e+20';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 1.496e+21';
            break;
          case 'Light years':
            formula = 'Divide the length value by 63.241';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 206,265';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Light years':
        switch (toUnit) {
          case 'Light years':
            formula = 'The value remains unchanged';
            break;
          case 'Astronomical units':
            formula = 'Multiply the length value by 63,241';
            break;
          case 'Nautical miles':
            formula = 'Multiply the length value by 3.724e+12';
            break;
          case 'Miles':
            formula = 'Multiply the length value by 5.879e+12';
            break;
          case 'Furlongs':
            formula = 'Multiply the length value by 4.703e+13';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 4.703e+14';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 1.057e+13';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 3.172e+13';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 3.807e+14';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 3.807e+17';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 5.286e+12';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 9.461e+12';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 9.461e+15';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 9.461e+17';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 9.461e+18';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 9.461e+21';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 9.461e+24';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 9.461e+27';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 9.461e+28';
            break;
          case 'Parsecs':
            formula = 'Divide the length value by 3.262';
            break;

          default:
            formula = 'Unknown conversion';
            break;
        }
        break;
      case 'Parsecs':
        switch (toUnit) {
          case 'Parsecs':
            formula = 'The value remains unchanged';
            break;
          case 'Light years':
            formula = 'Multiply the length value by 3.262';
            break;
          case 'Astronomical units':
            formula = 'Multiply the length value by 206,265';
            break;
          case 'Nautical miles':
            formula = 'Multiply the length value by 1.917e+13';
            break;
          case 'Miles':
            formula = 'Multiply the length value by 1.917e+13';
            break;
          case 'Furlongs':
            formula = 'Multiply the length value by 1.534e+14';
            break;
          case 'Chains':
            formula = 'Multiply the length value by 1.534e+15';
            break;
          case 'Yards':
            formula = 'Multiply the length value by 3.447e+14';
            break;
          case 'Feet':
            formula = 'Multiply the length value by 1.034e+15';
            break;
          case 'Inches':
            formula = 'Multiply the length value by 1.240e+16';
            break;
          case 'Thou':
            formula = 'Multiply the length value by 1.240e+19';
            break;
          case 'Fathoms':
            formula = 'Multiply the length value by 1.724e+14';
            break;
          case 'Kilometers':
            formula = 'Multiply the length value by 3.086e+13';
            break;
          case 'Meters':
            formula = 'Multiply the length value by 3.086e+16';
            break;
          case 'Centimeters':
            formula = 'Multiply the length value by 3.086e+18';
            break;
          case 'Millimeters':
            formula = 'Multiply the length value by 3.086e+19';
            break;
          case 'Micrometers':
            formula = 'Multiply the length value by 3.086e+22';
            break;
          case 'Nanometers':
            formula = 'Multiply the length value by 3.086e+25';
            break;
          case 'Picometers':
            formula = 'Multiply the length value by 3.086e+28';
            break;
          case 'Angstrom':
            formula = 'Multiply the length value by 3.086e+29';
            break;
          case 'Cables':
            formula = 'Multiply the length value by 1.666e+14';
            break;

          default:
            formula = 'Unknown conversion';
            break;
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
                          child: AutoSizeText('Convert Distance'.tr(),
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
      case 'Picometers':
        return 'pm';
      case 'Nanometers':
        return 'nm'; // Example text
      case 'Micrometers':
        return 'µm'; // Just an example icon
      case 'Millimeters':
        return 'mm';
      case 'Centimeters':
        return 'cm'; // Just an example icon
      case 'Meters':
        return 'm';
      case 'Kilometers':
        return 'km'; // Just an example icon
      case 'Angstrom':
        return 'Å';
      case 'Thou':
        return 'thou';
      case 'Inches':
        return 'in'; // Just an example icon
      case 'Feet':
        return 'ft';
      case 'Yards':
        return 'yd'; // Just an example icon
      case 'Chains':
        return 'ch';
      case 'Furlongs':
        return 'fur';
      case 'Miles':
        return 'mi'; // Just an example icon
      case 'Fathoms':
        return 'fth';
      case 'Cables':
        return 'cable'; // Just an example icon
      case 'Nautical miles':
        return 'NM';
      case 'Astronomical units':
        return 'au';
      case 'Light years':
        return 'ly'; // Just an example icon
      case 'Parsecs':
        return 'pc';

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
      'Picometers',
      'Nanometers',
      'Micrometers',
      'Millimeters',
      'Centimeters',
      'Meters',
      'Kilometers',
      'Angstrom',
      'Thou',
      'Inches',
      'Feet',
      'Yards',
      'Chains',
      'Furlongs',
      'Miles',
      'Fathoms',
      'Cables',
      'Nautical miles',
      'Astronomical units',
      'Light years',
      'Parsecs',
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
