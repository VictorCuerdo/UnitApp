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

class TorqueUnitConverter extends StatefulWidget {
  const TorqueUnitConverter({super.key});

  @override
  _TorqueUnitConverterState createState() => _TorqueUnitConverterState();
}

class _TorqueUnitConverterState extends State<TorqueUnitConverter> {
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 17.0;
  static const double largeFontSize = 20.0;
  Locale _selectedLocale = const Locale('en', 'US');
  double fontSize = mediumFontSize;

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Micronewton Meter';
  String toUnit = 'Millinewton Meter';
  // Removed duplicate declarations of TextEditingController
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  bool _isExponentialFormat = false;
  // Flag to indicate if the change is due to user input
  bool _isUserInput = true;
  // Using string variables for prefixes
  String fromPrefix = 'µNm';
  String toPrefix = 'mNm';
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
          text: 'Check out my torque result!'.tr());
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here
// region myVariables
    const double micronewtonMeterToGramForceMeter =
        9.80665; // 1 gf·m = 9.80665 µN·m

    const double micronewtonMeterToMicronewtonMeter = 1;
    const double micronewtonMeterToMillinewtonMeter = 1e-3;
    const double micronewtonMeterToNewtonMeter = 1e-6;
    const double micronewtonMeterToKilonewtonMeter = 1e-9;
    const double micronewtonMeterToMeganewtonMeter = 1e-12;
    const double micronewtonMeterToNewtonCentimeter = 1e-4;
    const double micronewtonMeterToNewtonMillimeter = 1e-3;

    //const double micronewtonMeterToGramForceMeter = 1.019716212977928e-4; // 1 Nm = 101.9716212977928 gf·m
    const double micronewtonMeterToGramForceCentimeter =
        1.019716212977928e-2; // 1 Nm = 10197.16212977928 gf·cm
    const double micronewtonMeterToGramForceMillimeter =
        1.019716212977928e-1; // 1 Nm = 101971.6212977928 gf·mm
    //**** */
    const double micronewtonMeterToKilogramForceMeter =
        1.019716212977928e-7; // 1 Nm = 0.1019716212977928 kgf·m

    const double micronewtonMeterToDyneCentimeter = 10;
    const double micronewtonMeterToPoundForceInch =
        1.1298482904455898e-7; // 1 lb·in = 8.85074579 N·m = 8.85074579e6 µN·m

    const double newtonMeterToDyneCentimeter = 1e7; // 1 N·m = 10^7 dyn·cm

    const double kilogramForceMeterToMicronewtonMeter = 9.80665e9;

    const double kilogramForceCentimeterToDyneMeter =
        980665; // since 1 dyne·m = 1000 gf·cm

    const double kilogramForceMillimeterToDyneMeter =
        98066.5; // since 1 dyne·m = 1000 gf·mm

    const double micronewtonMeterToKilogramForceCentimeter =
        1.019716212977928e-5; // 1 Nm = 10.19716212977928 kgf·cm
    const double micronewtonMeterToKilogramForceMillimeter =
        1.019716212977928e-4; // 1 Nm = 101.9716212977928 kgf·mm
    const double micronewtonMeterToDyneMeter =
        10; // 1 Nm = 10^7 dyne·cm, 1 dyne·cm = 10^-7 Nm and 1 dyne·m = 10^-5 Nm
    const double micronewtonMeterToDyneMillimeter = 1e4; // 1 dyne·mm = 10^-6 Nm
    const double micronewtonMeterToPoundForceFoot =
        7.375621492772e-8; // 1 Nm = 0.7375621492772 lb·ft

    const double micronewtonMeterToOunceForceFoot =
        1.180094786104e-6; // 1 lb·ft = 16 oz·ft, hence 1 Nm = 0.7375621492772 * 16 oz·ft
    const double micronewtonMeterToOunceForceInch =
        1.416113747325e-5; // 1 lb·in = 16 oz·in, hence 1 Nm = 8.850745791327184 * 16 oz·in

    const double millinewtonMeterToMicronewtonMeter = 1000;
    const double millinewtonMeterToMillinewtonMeter = 1;
    const double millinewtonMeterToNewtonMeter = 0.001;
    const double millinewtonMeterToKilonewtonMeter = 1e-6;
    const double millinewtonMeterToMeganewtonMeter = 1e-9;
    const double millinewtonMeterToNewtonCentimeter = 0.1;
    const double millinewtonMeterToNewtonMillimeter = 1;
    const double millinewtonMeterToGramForceMeter = 0.101971621;
    const double millinewtonMeterToGramForceCentimeter = 10.1971621;
    const double millinewtonMeterToGramForceMillimeter = 101.971621;
    const double millinewtonMeterToKilogramForceMeter = 0.000101971621;
    const double millinewtonMeterToKilogramForceCentimeter = 0.0101971621;
    const double millinewtonMeterToKilogramForceMillimeter = 0.101971621;
    const double millinewtonMeterToDyneMeter = 10000;
    const double millinewtonMeterToDyneCentimeter = 1e6;
    const double millinewtonMeterToDyneMillimeter = 1e7;
    const double millinewtonMeterToPoundForceFoot = 0.000737562;
    const double millinewtonMeterToPoundForceInch = 0.008850746;
    const double millinewtonMeterToOunceForceFoot = 0.011800948;
    const double millinewtonMeterToOunceForceInch = 0.141611375;

    const double newtonMeterToMicronewtonMeter = 1e6;
    const double newtonMeterToMillinewtonMeter = 1000;
    const double newtonMeterToNewtonMeter = 1;
    const double newtonMeterToKilonewtonMeter = 0.001;
    const double newtonMeterToMeganewtonMeter = 1e-6;
    const double newtonMeterToNewtonCentimeter = 100;
    const double newtonMeterToNewtonMillimeter = 1000;
    const double newtonMeterToGramForceMeter =
        101.9716212978; // 1 Nm = 101.9716212978 gf·m
    const double newtonMeterToGramForceCentimeter =
        10197.16212978; // 1 Nm = 10197.16212978 gf·cm
    const double newtonMeterToGramForceMillimeter =
        101971.6212978; // 1 Nm = 101971.6212978 gf·mm
    const double newtonMeterToKilogramForceMeter =
        0.1019716212978; // 1 Nm = 0.1019716212978 kgf·m
    const double newtonMeterToKilogramForceCentimeter =
        10.19716212978; // 1 Nm = 10.19716212978 kgf·cm
    const double newtonMeterToKilogramForceMillimeter =
        101.9716212978; // 1 Nm = 101.9716212978 kgf·mm
    const double newtonMeterToDyneMeter = 1e7;

    const double newtonMeterToDyneMillimeter = 1e6;
    const double newtonMeterToPoundForceFoot =
        0.7375621492773; // 1 Nm = 0.7375621492773 lbf·ft
    const double newtonMeterToPoundForceInch =
        8.8507457673787; // 1 Nm = 8.8507457673787 lbf·in
    const double newtonMeterToOunceForceFoot =
        11.800943607046; // 1 lbf·ft = 16 ozf·ft, hence 1 Nm = 0.7375621492773 * 16 ozf·ft
    const double newtonMeterToOunceForceInch =
        141.61172488474; // 1 lbf·in = 16 ozf·in, hence 1 Nm = 8.8507457673787 * 16 ozf·in

    const double kilonewtonMeterToMicronewtonMeter = 1e9;
    const double kilonewtonMeterToMillinewtonMeter = 1e6;
    const double kilonewtonMeterToNewtonMeter = 1000;
    const double kilonewtonMeterToKilonewtonMeter = 1;
    const double kilonewtonMeterToMeganewtonMeter = 0.001;
    const double kilonewtonMeterToNewtonCentimeter = 100000;
    const double kilonewtonMeterToNewtonMillimeter = 1000000;
    const double kilonewtonMeterToGramForceMeter =
        101971.621298; // 1 kNm = 101971.621298 gf·m
    const double kilonewtonMeterToGramForceCentimeter =
        10197162.1298; // 1 kNm = 10197162.1298 gf·cm
    const double kilonewtonMeterToGramForceMillimeter =
        101971621.298; // 1 kNm = 101971621.298 gf·mm
    const double kilonewtonMeterToKilogramForceMeter =
        101.971621298; // 1 kNm = 101.971621298 kgf·m
    const double kilonewtonMeterToKilogramForceCentimeter =
        10197.1621298; // 1 kNm = 10197.1621298 kgf·cm
    const double kilonewtonMeterToKilogramForceMillimeter =
        101971.621298; // 1 kNm = 101971.621298 kgf·mm
    const double kilonewtonMeterToDyneMeter = 1e10;
    const double kilonewtonMeterToDyneCentimeter = 1e8;
    const double kilonewtonMeterToDyneMillimeter = 1e9;
    const double kilonewtonMeterToPoundForceFoot =
        737.5621492773; // 1 kNm = 737.5621492773 lbf·ft
    const double kilonewtonMeterToPoundForceInch =
        8850.7457673787; // 1 kNm = 8850.7457673787 lbf·in
    const double kilonewtonMeterToOunceForceFoot =
        11800.943607046; // 1 lbf·ft = 16 ozf·ft, hence 1 kNm = 737.5621492773 * 16 ozf·ft
    const double kilonewtonMeterToOunceForceInch =
        141611.72488474; // 1 lbf·in = 16 ozf·in, hence 1 kNm = 8850.7457673787 * 16 ozf·in

    const double meganewtonMeterToMicronewtonMeter = 1e12;
    const double meganewtonMeterToMillinewtonMeter = 1e9;
    const double meganewtonMeterToNewtonMeter = 1e6;
    const double meganewtonMeterToKilonewtonMeter = 1000;
    const double meganewtonMeterToMeganewtonMeter = 1;
    const double meganewtonMeterToNewtonCentimeter = 1e8;
    const double meganewtonMeterToNewtonMillimeter = 1e9;
    const double meganewtonMeterToGramForceMeter =
        1.019716212977928e8; // 1 MNm = 1.019716212977928e8 gf·m
    const double meganewtonMeterToGramForceCentimeter =
        1.019716212977928e10; // 1 MNm = 1.019716212977928e10 gf·cm
    const double meganewtonMeterToGramForceMillimeter =
        1.019716212977928e11; // 1 MNm = 1.019716212977928e11 gf·mm
    const double meganewtonMeterToKilogramForceMeter =
        1.019716212977928e5; // 1 MNm = 1.019716212977928e5 kgf·m
    const double meganewtonMeterToKilogramForceCentimeter =
        1.019716212977928e7; // 1 MNm = 1.019716212977928e7 kgf·cm
    const double meganewtonMeterToKilogramForceMillimeter =
        1.019716212977928e8; // 1 MNm = 1.019716212977928e8 kgf·mm
    const double meganewtonMeterToDyneMeter = 1e13;
    const double meganewtonMeterToDyneCentimeter = 1e11;
    const double meganewtonMeterToDyneMillimeter = 1e12;
    const double meganewtonMeterToPoundForceFoot =
        737562.1492773; // 1 MNm = 737562.1492773 lbf·ft
    const double meganewtonMeterToPoundForceInch =
        8850745.7673787; // 1 MNm = 8850745.7673787 lbf·in
    const double meganewtonMeterToOunceForceFoot =
        11800943.607046; // 1 MNm = 11800943.607046 ozf·ft
    const double meganewtonMeterToOunceForceInch =
        141611724.88474; // 1 MNm = 141611724.88474 ozf·in

    const double newtonCentimeterToMicronewtonMeter = 10000;
    const double newtonCentimeterToMillinewtonMeter = 10;
    const double newtonCentimeterToNewtonMeter = 0.01;
    const double newtonCentimeterToKilonewtonMeter = 1e-5;
    const double newtonCentimeterToMeganewtonMeter = 1e-8;
    const double newtonCentimeterToNewtonCentimeter = 1;
    const double newtonCentimeterToNewtonMillimeter = 10;
    const double newtonCentimeterToGramForceMeter =
        1.019716212977928; // 1 Ncm = 1.019716212977928 gf·m
    const double newtonCentimeterToGramForceCentimeter =
        101.9716212977928; // 1 Ncm = 101.9716212977928 gf·cm
    const double newtonCentimeterToGramForceMillimeter =
        1019.716212977928; // 1 Ncm = 1019.716212977928 gf·mm
    const double newtonCentimeterToKilogramForceMeter =
        0.001019716212977928; // 1 Ncm = 0.001019716212977928 kgf·m
    const double newtonCentimeterToKilogramForceCentimeter =
        0.1019716212977928; // 1 Ncm = 0.1019716212977928 kgf·cm
    const double newtonCentimeterToKilogramForceMillimeter =
        1.019716212977928; // 1 Ncm = 1.019716212977928 kgf·mm
    const double newtonCentimeterToDyneMeter = 100000;
    const double newtonCentimeterToDyneCentimeter = 1000000;
    const double newtonCentimeterToDyneMillimeter = 10000000;
    const double newtonCentimeterToPoundForceFoot =
        0.007375621492772; // 1 Ncm = 0.007375621492772 lbf·ft
    const double newtonCentimeterToPoundForceInch =
        0.088507457773787; // 1 Ncm = 0.088507457773787 lbf·in
    const double newtonCentimeterToOunceForceFoot =
        0.11800943607046; // 1 Ncm = 0.11800943607046 ozf·ft
    const double newtonCentimeterToOunceForceInch =
        1.41611372488474; // 1 Ncm = 1.41611372488474 ozf·in

    const double newtonMillimeterToMicronewtonMeter = 1000;
    const double newtonMillimeterToMillinewtonMeter = 1;
    const double newtonMillimeterToNewtonMeter = 0.001;
    const double newtonMillimeterToKilonewtonMeter = 1e-6;
    const double newtonMillimeterToMeganewtonMeter = 1e-9;
    const double newtonMillimeterToNewtonCentimeter = 0.1;
    const double newtonMillimeterToNewtonMillimeter = 1;
    const double newtonMillimeterToGramForceMeter =
        0.10197162129779283; // 1 Nmm = 0.10197162129779283 gf·m
    const double newtonMillimeterToGramForceCentimeter =
        10.197162129779283; // 1 Nmm = 10.197162129779283 gf·cm
    const double newtonMillimeterToGramForceMillimeter =
        101.97162129779283; // 1 Nmm = 101.97162129779283 gf·mm
    const double newtonMillimeterToKilogramForceMeter =
        0.00010197162129779283; // 1 Nmm = 0.00010197162129779283 kgf·m
    const double newtonMillimeterToKilogramForceCentimeter =
        0.010197162129779283; // 1 Nmm = 0.010197162129779283 kgf·cm
    const double newtonMillimeterToKilogramForceMillimeter =
        0.10197162129779283; // 1 Nmm = 0.10197162129779283 kgf·mm
    const double newtonMillimeterToDyneMeter = 100000;
    const double newtonMillimeterToDyneCentimeter = 10000;
    const double newtonMillimeterToDyneMillimeter = 100000;
    const double newtonMillimeterToPoundForceFoot =
        0.0007375621492773; // 1 Nmm = 0.0007375621492773 lbf·ft
    const double newtonMillimeterToPoundForceInch =
        0.0088507457673787; // 1 Nmm = 0.0088507457673787 lbf·in
    const double newtonMillimeterToOunceForceFoot =
        0.011800943607046; // 1 Nmm = 0.011800943607046 ozf·ft
    const double newtonMillimeterToOunceForceInch =
        0.14161172488474; // 1 Nmm = 0.14161172488474 ozf·in

    const double gramForceMeterToMicronewtonMeter = 9806.65;
    const double gramForceMeterToMillinewtonMeter = 9.80665;
    const double gramForceMeterToNewtonMeter = 0.00980665;
    const double gramForceMeterToKilonewtonMeter = 9.80665e-6;
    const double gramForceMeterToMeganewtonMeter = 9.80665e-9;
    const double gramForceMeterToNewtonCentimeter = 0.980665;
    const double gramForceMeterToNewtonMillimeter = 9.80665;
    const double gramForceMeterToGramForceMeter = 1;
    const double gramForceMeterToGramForceCentimeter = 100;
    const double gramForceMeterToGramForceMillimeter = 1000;
    const double gramForceMeterToKilogramForceMeter = 0.001;
    const double gramForceMeterToKilogramForceCentimeter = 0.1;
    const double gramForceMeterToKilogramForceMillimeter = 1;
    const double gramForceMeterToDyneMeter = 980665;
    const double gramForceMeterToDyneCentimeter = 98066500;
    const double gramForceMeterToDyneMillimeter = 980665000;
    const double gramForceMeterToPoundForceFoot =
        0.0723301374515; // Using the conversion 1 kgf·m = 7.23301374515 lbf·ft and 1 gf·m = 0.001 kgf·m
    const double gramForceMeterToPoundForceInch =
        0.867961649818; // Since there are 12 inches in a foot
    const double gramForceMeterToOunceForceFoot =
        1.15728161874; // Since there are 16 ounces in one pound
    const double gramForceMeterToOunceForceInch =
        13.88737942489; // Since there are 12 inches in a foot and 16 ounces in one pound

    const double gramForceCentimeterToMicronewtonMeter = 98.0665;
    const double gramForceCentimeterToMillinewtonMeter = 0.0980665;
    const double gramForceCentimeterToNewtonMeter = 0.000980665;
    const double gramForceCentimeterToKilonewtonMeter = 9.80665e-7;
    const double gramForceCentimeterToMeganewtonMeter = 9.80665e-10;
    const double gramForceCentimeterToNewtonCentimeter = 1; // by definition
    const double gramForceCentimeterToNewtonMillimeter =
        0.1; // since 1 cm = 10 mm
    const double gramForceCentimeterToGramForceMeter =
        0.01; // since 1 m = 100 cm
    const double gramForceCentimeterToGramForceCentimeter = 1; // by definition
    const double gramForceCentimeterToGramForceMillimeter =
        10; // since 1 cm = 10 mm
    const double gramForceCentimeterToKilogramForceMeter =
        1e-5; // since 1 kgf·m = 100 gf·cm
    const double gramForceCentimeterToKilogramForceCentimeter =
        0.001; // since 1 kgf·cm = 1000 gf·cm

    const double gramForceMillimeterToMicronewtonMeter = 9.80665;
    const double gramForceMillimeterToMillinewtonMeter = 0.00980665;
    const double gramForceMillimeterToNewtonMeter = 0.00000980665;
    const double gramForceMillimeterToKilonewtonMeter = 9.80665e-9;
    const double gramForceMillimeterToMeganewtonMeter = 9.80665e-12;
    const double gramForceMillimeterToNewtonCentimeter =
        0.1; // since 10 mm = 1 cm
    const double gramForceMillimeterToNewtonMillimeter = 1; // by definition
    const double gramForceMillimeterToGramForceMeter =
        0.001; // since 1000 mm = 1 m
    const double gramForceMillimeterToGramForceCentimeter =
        0.1; // since 10 mm = 1 cm
    const double gramForceMillimeterToGramForceMillimeter = 1; // by definition
    const double gramForceMillimeterToKilogramForceMeter =
        1e-6; // since 1 kgf·m = 1000 gf·mm
    const double gramForceMillimeterToKilogramForceCentimeter =
        0.0001; // since 1 kgf·cm = 100 gf·mm
    const double gramForceMillimeterToKilogramForceMillimeter =
        0.001; // since 1 kgf·mm = 1000 gf·mm
    const double gramForceMillimeterToDyneMeter =
        980.665; // since 1 dyne·m = 1000 gf·mm
    const double gramForceMillimeterToDyneCentimeter =
        98066.5; // since 1 dyne·cm = 1 gf·mm
    const double gramForceMillimeterToDyneMillimeter =
        980665; // since 1 dyne·mm = 10 gf·mm
    const double gramForceMillimeterToPoundForceFoot =
        0.0000723301374515; // using the conversion 1 gf·mm to lbf·ft
    const double gramForceMillimeterToPoundForceInch =
        0.000867961649818; // using the conversion 1 gf·mm to lbf·in
    const double gramForceMillimeterToOunceForceFoot =
        0.00115728161874; // using the conversion 1 gf·mm to ozf·ft
    const double gramForceMillimeterToOunceForceInch =
        0.01388737942489; // using the conversion 1 gf·mm to ozf·in

    const double kilogramForceMeterToMillinewtonMeter = 9.80665e3;
    const double kilogramForceMeterToNewtonMeter = 9.80665;
    const double kilogramForceMeterToKilonewtonMeter = 0.00980665;
    const double kilogramForceMeterToMeganewtonMeter = 9.80665e-6;
    const double kilogramForceMeterToNewtonCentimeter = 980.665;
    const double kilogramForceMeterToNewtonMillimeter = 9806.65;
    const double kilogramForceMeterToGramForceMeter = 1000; // by definition
    const double kilogramForceMeterToGramForceCentimeter =
        100000; // since 1 m = 100 cm
    const double kilogramForceMeterToGramForceMillimeter =
        1e6; // since 1 m = 1000 mm
    const double kilogramForceMeterToKilogramForceMeter = 1; // by definition
    const double kilogramForceMeterToKilogramForceCentimeter =
        100; // since 1 m = 100 cm
    const double kilogramForceMeterToKilogramForceMillimeter =
        1000; // since 1 m = 1000 mm
    const double kilogramForceMeterToDyneMeter = 9.80665e7;
    const double kilogramForceMeterToDyneCentimeter = 9.80665e9;
    const double kilogramForceMeterToDyneMillimeter = 9.80665e10;
    const double kilogramForceMeterToPoundForceFoot =
        7.23301374515; // using the conversion 1 kgf·m to lbf·ft
    const double kilogramForceMeterToPoundForceInch =
        86.7961649818; // since there are 12 inches in a foot
    const double kilogramForceMeterToOunceForceFoot =
        115.728161874; // since there are 16 ounces in one pound
    const double kilogramForceMeterToOunceForceInch =
        1388.737942489; // since there are 12 inches in a foot and 16 ounces in one pound

    const double kilogramForceCentimeterToMicronewtonMeter = 98066.5;
    const double kilogramForceCentimeterToMillinewtonMeter = 98.0665;
    const double kilogramForceCentimeterToNewtonMeter = 0.0980665;
    const double kilogramForceCentimeterToKilonewtonMeter = 0.0000980665;
    const double kilogramForceCentimeterToMeganewtonMeter = 9.80665e-8;
    const double kilogramForceCentimeterToNewtonCentimeter =
        10; // since 1 kgf·cm = 10 N·cm
    const double kilogramForceCentimeterToNewtonMillimeter =
        100; // since 1 kgf·cm = 100 N·mm
    const double kilogramForceCentimeterToGramForceMeter =
        10; // since 1 kgf·cm = 10 gf·m
    const double kilogramForceCentimeterToGramForceCentimeter =
        1000; // by definition
    const double kilogramForceCentimeterToGramForceMillimeter =
        10000; // since 1 cm = 10 mm
    const double kilogramForceCentimeterToKilogramForceMeter =
        0.01; // since 1 m = 100 cm
    const double kilogramForceCentimeterToKilogramForceCentimeter =
        1; // by definition
    const double kilogramForceCentimeterToKilogramForceMillimeter =
        10; // since 1 cm = 10 mm

    const double kilogramForceCentimeterToDyneCentimeter =
        98066500; // since 1 dyne·cm = 1 kgf·cm
    const double kilogramForceCentimeterToDyneMillimeter =
        980665000; // since 1 dyne·mm = 10 kgf·cm
    const double kilogramForceCentimeterToPoundForceFoot =
        0.0723301374515; // using the conversion 1 kgf·m to lbf·ft and 1 kgf·cm to kgf·m
    const double kilogramForceCentimeterToPoundForceInch =
        0.867961649818; // since there are 12 inches in a foot
    const double kilogramForceCentimeterToOunceForceFoot =
        1.15728161874; // since there are 16 ounces in one pound
    const double kilogramForceCentimeterToOunceForceInch =
        13.88737942489; // since there are 12 inches in a foot and 16 ounces in one pound

    const double kilogramForceMillimeterToMicronewtonMeter = 9806.65;
    const double kilogramForceMillimeterToMillinewtonMeter = 9.80665;
    const double kilogramForceMillimeterToNewtonMeter = 0.00980665;
    const double kilogramForceMillimeterToKilonewtonMeter = 0.00000980665;
    const double kilogramForceMillimeterToMeganewtonMeter = 9.80665e-9;
    const double kilogramForceMillimeterToNewtonCentimeter =
        1; // since 10 mm = 1 cm
    const double kilogramForceMillimeterToNewtonMillimeter =
        10; // by definition
    const double kilogramForceMillimeterToGramForceMeter =
        1; // since 1000 mm = 1 m
    const double kilogramForceMillimeterToGramForceCentimeter =
        100; // since 10 mm = 1 cm
    const double kilogramForceMillimeterToGramForceMillimeter =
        1000; // by definition
    const double kilogramForceMillimeterToKilogramForceMeter =
        0.001; // since 1000 mm = 1 m
    const double kilogramForceMillimeterToKilogramForceCentimeter =
        0.1; // since 10 mm = 1 cm
    const double kilogramForceMillimeterToKilogramForceMillimeter =
        1; // by definition

    const double kilogramForceMillimeterToDyneCentimeter =
        9806650; // since 1 dyne·cm = 10 gf·mm
    const double kilogramForceMillimeterToDyneMillimeter =
        98066500; // since 1 dyne·mm = 1 kgf·mm
    const double kilogramForceMillimeterToPoundForceFoot =
        0.00723301374515; // using the conversion 1 kgf·m to lbf·ft and 1 kgf·mm to kgf·m
    const double kilogramForceMillimeterToPoundForceInch =
        0.0867961649818; // since there are 12 inches in a foot
    const double kilogramForceMillimeterToOunceForceFoot =
        0.115728161874; // since there are 16 ounces in one pound
    const double kilogramForceMillimeterToOunceForceInch =
        1.388737942489; // since there are 12 inches in a foot and 16 ounces in one pound

    const double dyneMeterToMicronewtonMeter = 10;
    const double dyneMeterToMillinewtonMeter = 0.01;
    const double dyneMeterToNewtonMeter = 1e-5;
    const double dyneMeterToKilonewtonMeter = 1e-8;
    const double dyneMeterToMeganewtonMeter = 1e-11;
    const double dyneMeterToNewtonCentimeter =
        0.0001; // since 1 dyn·m = 1e5 dyn·cm and 1 dyn·cm = 1e-5 N·m
    const double dyneMeterToNewtonMillimeter =
        0.001; // since 1 dyn·m = 1e5 dyn·mm and 1 dyn·mm = 1e-3 N·m
    const double dyneMeterToGramForceMeter =
        0.001019716212977928; // since 1 gf = 980.665 dyn and 1 m = 100 cm
    const double dyneMeterToGramForceCentimeter =
        1.019716212977928; // since 1 gf = 980.665 dyn
    const double dyneMeterToGramForceMillimeter =
        10.19716212977928; // since 1 gf·mm = 10 dyn
    const double dyneMeterToKilogramForceMeter =
        1.019716212977928e-6; // since 1 kgf = 9.80665e5 dyn and 1 m = 100 cm
    const double dyneMeterToKilogramForceCentimeter =
        0.0001019716212977928; // since 1 kgf = 9.80665e5 dyn
    const double dyneMeterToKilogramForceMillimeter =
        0.001019716212977928; // since 1 kgf·mm = 10 kgf·cm
    const double dyneMeterToDyneMeter = 1; // by definition
    const double dyneMeterToDyneCentimeter = 100000; // by definition
    const double dyneMeterToDyneMillimeter =
        1000000; // since 1 dyn·mm = 1e-3 dyn·m
    const double dyneMeterToPoundForceFoot =
        7.23301374515e-8; // from dyn·m to lbf·ft
    const double dyneMeterToPoundForceInch =
        8.67961649818e-7; // from dyn·m to lbf·in
    const double dyneMeterToOunceForceFoot =
        1.15728161874e-6; // from dyn·m to ozf·ft
    const double dyneMeterToOunceForceInch =
        1.388737942489e-5; // from dyn·m to ozf·in

    const double dyneCentimeterToMicronewtonMeter = 1000;
    const double dyneCentimeterToMillinewtonMeter = 1;
    const double dyneCentimeterToNewtonMeter = 0.0001;
    const double dyneCentimeterToKilonewtonMeter = 1e-7;
    const double dyneCentimeterToMeganewtonMeter = 1e-10;
    const double dyneCentimeterToNewtonCentimeter =
        0.01; // since 1 dyn·cm = 0.01 N·cm
    const double dyneCentimeterToNewtonMillimeter =
        0.1; // since 10 dyn·cm = 1 N·mm
    const double dyneCentimeterToGramForceMeter =
        0.001019716212977928; // since 1 gf·cm = 980.665 dyn·cm
    const double dyneCentimeterToGramForceCentimeter =
        1.019716212977928; // since 1 gf = 980.665 dyn
    const double dyneCentimeterToGramForceMillimeter =
        10.19716212977928; // since 10 gf·cm = 1 gf·mm
    const double dyneCentimeterToKilogramForceMeter =
        1.019716212977928e-5; // since 1000 gf·cm = 1 kgf·m
    const double dyneCentimeterToKilogramForceCentimeter =
        0.0001019716212977928; // since 1 kgf = 98066.5 dyn·cm
    const double dyneCentimeterToKilogramForceMillimeter =
        0.001019716212977928; // since 10 kgf·cm = 1 kgf·mm
    const double dyneCentimeterToDyneMeter = 0.1; // since 1 dyn·m = 100 dyn·cm
    const double dyneCentimeterToDyneCentimeter = 1; // by definition
    const double dyneCentimeterToDyneMillimeter =
        10; // since 1 dyn·mm = 0.1 dyn·cm
    const double dyneCentimeterToPoundForceFoot =
        7.23301374515e-6; // from dyn·cm to lbf·ft
    const double dyneCentimeterToPoundForceInch =
        8.67961649818e-5; // from dyn·cm to lbf·in
    const double dyneCentimeterToOunceForceFoot =
        1.15728161874e-4; // from dyn·cm to ozf·ft
    const double dyneCentimeterToOunceForceInch =
        0.001388737942489; // from dyn·cm to ozf·in

    const double dyneMillimeterToMicronewtonMeter = 100;
    const double dyneMillimeterToMillinewtonMeter = 0.1;
    const double dyneMillimeterToNewtonMeter = 0.00001;
    const double dyneMillimeterToKilonewtonMeter = 1e-8;
    const double dyneMillimeterToMeganewtonMeter = 1e-11;
    const double dyneMillimeterToNewtonCentimeter =
        0.001; // since 1 dyn·mm = 0.001 N·cm
    const double dyneMillimeterToNewtonMillimeter =
        0.01; // since 1 dyn·mm = 0.01 N·mm
    const double dyneMillimeterToGramForceMeter =
        0.0001019716212977928; // since 1 gf·mm = 980.665 dyn·mm
    const double dyneMillimeterToGramForceCentimeter =
        0.1019716212977928; // since 1 gf = 980.665 dyn
    const double dyneMillimeterToGramForceMillimeter =
        1.019716212977928; // by definition
    const double dyneMillimeterToKilogramForceMeter =
        1.019716212977928e-6; // since 1000 gf·mm = 1 kgf·m
    const double dyneMillimeterToKilogramForceCentimeter =
        0.000010197162129779283; // since 100 gf·mm = 1 kgf·cm
    const double dyneMillimeterToKilogramForceMillimeter =
        0.00010197162129779283; // since 10 kgf·cm = 1 kgf·mm
    const double dyneMillimeterToDyneMeter =
        0.01; // since 1 dyn·m = 1000 dyn·mm
    const double dyneMillimeterToDyneCentimeter =
        0.1; // since 1 dyn·cm = 10 dyn·mm
    const double dyneMillimeterToDyneMillimeter = 1; // by definition
    const double dyneMillimeterToPoundForceFoot =
        7.23301374515e-7; // from dyn·mm to lbf·ft
    const double dyneMillimeterToPoundForceInch =
        8.67961649818e-6; // from dyn·mm to lbf·in
    const double dyneMillimeterToOunceForceFoot =
        1.15728161874e-5; // from dyn·mm to ozf·ft
    const double dyneMillimeterToOunceForceInch =
        0.0001388773942489; // from dyn·mm to ozf·in

    const double poundForceFootToMicronewtonMeter = 1.3558179483314004e6;
    const double poundForceFootToMillinewtonMeter = 1355.8179483314004;
    const double poundForceFootToNewtonMeter = 1.3558179483314004;
    const double poundForceFootToKilonewtonMeter = 0.0013558179483314004;
    const double poundForceFootToMeganewtonMeter = 1.3558179483314004e-6;
    const double poundForceFootToNewtonCentimeter = 135.58179483314004;
    const double poundForceFootToNewtonMillimeter = 1355.8179483314004;
    const double poundForceFootToGramForceMeter =
        138.25502798621186; // since 1 lbf·ft = 138.25502798621186 gf·m
    const double poundForceFootToGramForceCentimeter =
        13825.502798621186; // since 1 gf·cm = 0.001 lbf·ft
    const double poundForceFootToGramForceMillimeter =
        138255.02798621186; // since 1 gf·mm = 0.01 lbf·ft
    const double poundForceFootToKilogramForceMeter =
        0.13825502798621186; // since 1 kgf·m = 7.23301374515 lbf·ft
    const double poundForceFootToKilogramForceCentimeter =
        13.825502798621186; // since 1 kgf·cm = 0.0723301374515 lbf·ft
    const double poundForceFootToKilogramForceMillimeter =
        138.25502798621186; // since 1 kgf·mm = 0.723301374515 lbf·ft
    const double poundForceFootToDyneMeter =
        13825502.798621186; // since 1 dyn·m = 0.0000723301374515 lbf·ft
    const double poundForceFootToDyneCentimeter =
        1382550279.8621186; // since 1 dyn·cm = 0.000000723301374515 lbf·ft
    const double poundForceFootToDyneMillimeter =
        13825502798.621186; // since 1 dyn·mm = 0.00000723301374515 lbf·ft
    const double poundForceFootToPoundForceFoot = 1; // by definition
    const double poundForceFootToPoundForceInch = 12; // since 1 ft = 12 in
    const double poundForceFootToOunceForceFoot = 16; // since 1 lb = 16 oz
    const double poundForceFootToOunceForceInch =
        192; // since 1 ft = 12 in and 1 lb = 16 oz

    const double poundForceInchToMicronewtonMeter = 112984.8290276167;
    const double poundForceInchToMillinewtonMeter = 112.9848290276167;
    const double poundForceInchToNewtonMeter = 0.1129848290276167;
    const double poundForceInchToKilonewtonMeter = 0.0001129848290276167;
    const double poundForceInchToMeganewtonMeter = 1.129848290276167e-7;
    const double poundForceInchToNewtonCentimeter = 11.29848290276167;
    const double poundForceInchToNewtonMillimeter = 112.9848290276167;
    const double poundForceInchToGramForceMeter =
        11.52124692682998; // since 1 lbf·in = 11.52124692682998 gf·m
    const double poundForceInchToGramForceCentimeter =
        1152.124692682998; // since 1 gf·cm = 0.000868055555556 lbf·in
    const double poundForceInchToGramForceMillimeter =
        11521.24692682998; // since 1 gf·mm = 0.00868055555556 lbf·in
    const double poundForceInchToKilogramForceMeter =
        0.01152124692682998; // since 1 kgf·m = 86.7961649818 lbf·in
    const double poundForceInchToKilogramForceCentimeter =
        1.152124692682998; // since 1 kgf·cm = 0.867961649818 lbf·in
    const double poundForceInchToKilogramForceMillimeter =
        11.52124692682998; // since 1 kgf·mm = 8.67961649818 lbf·in
    const double poundForceInchToDyneMeter =
        1152124.692682998; // since 1 dyn·m = 0.0000723301374515 lbf·ft and 1 ft = 12 in
    const double poundForceInchToDyneCentimeter =
        115212469.2682998; // since 1 dyn·cm = 0.000000868055555556 lbf·in
    const double poundForceInchToDyneMillimeter =
        1152124692.682998; // since 1 dyn·mm = 0.00000868055555556 lbf·in
    const double poundForceInchToPoundForceFoot =
        0.08333333333333333; // since 1 ft = 12 in

    const double poundForceInchToOunceForceFoot =
        1.333333333333333; // since 1 lbf = 16 ozf
    const double poundForceInchToOunceForceInch = 16; // since 1 lbf = 16 ozf

    const double ounceForceFootToMicronewtonMeter = 8478.614583333333 * 1000;
    const double ounceForceFootToMillinewtonMeter = 8478.614583333333;
    const double ounceForceFootToNewtonMeter = 8.478614583333333;
    const double ounceForceFootToKilonewtonMeter = 0.008478614583333333;
    const double ounceForceFootToMeganewtonMeter = 8.478614583333333e-6;
    const double ounceForceFootToNewtonCentimeter = 847.8614583333333;
    const double ounceForceFootToNewtonMillimeter = 8478.614583333333;
    const double ounceForceFootToGramForceMeter =
        864.8310538375718; // since 1 ozf·ft = 864.8310538375718 gf·m
    const double ounceForceFootToGramForceCentimeter =
        86483.10538375718; // since 1 gf·cm = 0.000115740740741 ozf·ft
    const double ounceForceFootToGramForceMillimeter =
        864831.0538375718; // since 1 gf·mm = 0.00115740740741 ozf·ft
    const double ounceForceFootToKilogramForceMeter =
        0.8648310538375718; // since 1 kgf·m = 115.728161874 ozf·ft
    const double ounceForceFootToKilogramForceCentimeter =
        86.48310538375718; // since 1 kgf·cm = 1.15728161874 ozf·ft
    const double ounceForceFootToKilogramForceMillimeter =
        864.8310538375718; // since 1 kgf·mm = 11.5728161874 ozf·ft
    const double ounceForceFootToDyneMeter =
        86483105.38375718; // since 1 dyn·m = 0.0000115728161874 ozf·ft
    const double ounceForceFootToDyneCentimeter =
        8648310538.375718; // since 1 dyn·cm = 0.000000115740740741 ozf·ft
    const double ounceForceFootToDyneMillimeter =
        86483105383.75718; // since 1 dyn·mm = 0.00000115740740741 ozf·ft
    const double ounceForceFootToPoundForceFoot =
        0.0625; // since 1 lbf·ft = 16 ozf·ft
    const double ounceForceFootToPoundForceInch =
        0.75; // since 1 lbf·in = 16 ozf·in and 1 ft = 12 in

    const double ounceForceFootToOunceForceInch = 12; // since 1 ft = 12 in

    const double ounceForceInchToMicronewtonMeter = 706.5517858565288;
    const double ounceForceInchToMillinewtonMeter = 0.7065517858565288;
    const double ounceForceInchToNewtonMeter = 0.0007065517858565288;
    const double ounceForceInchToKilonewtonMeter = 7.065517858565288e-7;
    const double ounceForceInchToMeganewtonMeter = 7.065517858565288e-10;
    const double ounceForceInchToNewtonCentimeter = 0.07065517858565288;
    const double ounceForceInchToNewtonMillimeter = 0.7065517858565288;
    const double ounceForceInchToGramForceMeter =
        0.07206782221496957; // using the conversion 1 ozf·in to gf·m
    const double ounceForceInchToGramForceCentimeter =
        7.206782221496957; // since 1 gf·cm = 0.001 lbf·in
    const double ounceForceInchToGramForceMillimeter =
        72.06782221496957; // since 1 gf·mm = 0.01 lbf·in
    const double ounceForceInchToKilogramForceMeter =
        0.00007206782221496957; // using the conversion 1 ozf·in to kgf·m
    const double ounceForceInchToKilogramForceCentimeter =
        0.007206782221496957; // using the conversion 1 ozf·in to kgf·cm
    const double ounceForceInchToKilogramForceMillimeter =
        0.07206782221496957; // using the conversion 1 ozf·in to kgf·mm
    const double ounceForceInchToDyneMeter =
        7206.782221496957; // since 1 dyn·m = 0.0000723301374515 lbf·ft and 1 lbf·ft = 192 ozf·in
    const double ounceForceInchToDyneCentimeter =
        720678.2221496957; // since 1 dyn·cm = 0.000000723301374515 lbf·ft
    const double ounceForceInchToDyneMillimeter =
        7206782.221496957; // since 1 dyn·mm = 0.00000723301374515 lbf·ft
    const double ounceForceInchToPoundForceFoot =
        0.005208333333333333; // since 1 lbf·ft = 192 ozf·in
    const double ounceForceInchToPoundForceInch =
        0.0625; // since 1 lbf·in = 16 ozf·in
    const double ounceForceInchToOunceForceFoot =
        0.08333333333333333; // since 1 ft = 12 in

    // endregion

    switch (fromUnit) {
      case 'Micronewton Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * micronewtonMeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * micronewtonMeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * micronewtonMeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * micronewtonMeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * micronewtonMeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * micronewtonMeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * micronewtonMeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * micronewtonMeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * micronewtonMeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * micronewtonMeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * micronewtonMeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * micronewtonMeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * micronewtonMeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * micronewtonMeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * micronewtonMeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * micronewtonMeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * micronewtonMeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * micronewtonMeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * micronewtonMeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * micronewtonMeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Millinewton Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * millinewtonMeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * millinewtonMeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * millinewtonMeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * millinewtonMeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * millinewtonMeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * millinewtonMeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * millinewtonMeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * millinewtonMeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * millinewtonMeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * millinewtonMeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * millinewtonMeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * millinewtonMeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * millinewtonMeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * millinewtonMeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * millinewtonMeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * millinewtonMeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * millinewtonMeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * millinewtonMeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * millinewtonMeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * millinewtonMeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Newton Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * newtonMeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * newtonMeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * newtonMeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * newtonMeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * newtonMeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * newtonMeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * newtonMeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * newtonMeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * newtonMeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * newtonMeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * newtonMeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * newtonMeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * newtonMeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * newtonMeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * newtonMeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * newtonMeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * newtonMeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * newtonMeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * newtonMeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * newtonMeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilonewton Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * kilonewtonMeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * kilonewtonMeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * kilonewtonMeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * kilonewtonMeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * kilonewtonMeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * kilonewtonMeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * kilonewtonMeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * kilonewtonMeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * kilonewtonMeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * kilonewtonMeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * kilonewtonMeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * kilonewtonMeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * kilonewtonMeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * kilonewtonMeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * kilonewtonMeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * kilonewtonMeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * kilonewtonMeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * kilonewtonMeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * kilonewtonMeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * kilonewtonMeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Meganewton Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * meganewtonMeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * meganewtonMeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * meganewtonMeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * meganewtonMeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * meganewtonMeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * meganewtonMeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * meganewtonMeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * meganewtonMeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * meganewtonMeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * meganewtonMeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * meganewtonMeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * meganewtonMeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * meganewtonMeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * meganewtonMeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * meganewtonMeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * meganewtonMeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * meganewtonMeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * meganewtonMeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * meganewtonMeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * meganewtonMeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Newton Centimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * newtonCentimeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * newtonCentimeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * newtonCentimeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * newtonCentimeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * newtonCentimeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * newtonCentimeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * newtonCentimeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * newtonCentimeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * newtonCentimeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * newtonCentimeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * newtonCentimeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * newtonCentimeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * newtonCentimeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * newtonCentimeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * newtonCentimeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * newtonCentimeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * newtonCentimeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * newtonCentimeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * newtonCentimeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * newtonCentimeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Newton Millimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * newtonMillimeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * newtonMillimeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * newtonMillimeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * newtonMillimeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * newtonMillimeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * newtonMillimeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * newtonMillimeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * newtonMillimeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * newtonMillimeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * newtonMillimeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * newtonMillimeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * newtonMillimeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * newtonMillimeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * newtonMillimeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * newtonMillimeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * newtonMillimeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * newtonMillimeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * newtonMillimeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * newtonMillimeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * newtonMillimeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Gram-force Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * gramForceMeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * gramForceMeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * gramForceMeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * gramForceMeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * gramForceMeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * gramForceMeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * gramForceMeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * gramForceMeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * gramForceMeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * gramForceMeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * gramForceMeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * gramForceMeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * gramForceMeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * gramForceMeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * gramForceMeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * gramForceMeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * gramForceMeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * gramForceMeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * gramForceMeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * gramForceMeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Gram-force Centimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * gramForceCentimeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * gramForceCentimeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * gramForceCentimeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * gramForceCentimeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * gramForceCentimeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * gramForceCentimeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * gramForceCentimeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * gramForceCentimeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * gramForceCentimeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * gramForceCentimeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * gramForceCentimeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * gramForceCentimeterToKilogramForceCentimeter;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
      //fix missing ones

      case 'Gram-force Millimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * gramForceMillimeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * gramForceMillimeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * gramForceMillimeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * gramForceMillimeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * gramForceMillimeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * gramForceMillimeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * gramForceMillimeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * gramForceMillimeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * gramForceMillimeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * gramForceMillimeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * gramForceMillimeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * gramForceMillimeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * gramForceMillimeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * gramForceMillimeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * gramForceMillimeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * gramForceMillimeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * gramForceMillimeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * gramForceMillimeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * gramForceMillimeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * gramForceMillimeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilogram-force Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * kilogramForceMeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * kilogramForceMeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * kilogramForceMeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * kilogramForceMeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * kilogramForceMeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * kilogramForceMeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * kilogramForceMeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * kilogramForceMeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * kilogramForceMeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * kilogramForceMeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * kilogramForceMeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * kilogramForceMeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * kilogramForceMeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * kilogramForceMeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * kilogramForceMeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * kilogramForceMeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * kilogramForceMeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * kilogramForceMeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * kilogramForceMeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * kilogramForceMeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilogram-force Centimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * kilogramForceCentimeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * kilogramForceCentimeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * kilogramForceCentimeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * kilogramForceCentimeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * kilogramForceCentimeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * kilogramForceCentimeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * kilogramForceCentimeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * kilogramForceCentimeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * kilogramForceCentimeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * kilogramForceCentimeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * kilogramForceCentimeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue =
                fromValue * kilogramForceCentimeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue =
                fromValue * kilogramForceCentimeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * kilogramForceCentimeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * kilogramForceCentimeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * kilogramForceCentimeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * kilogramForceCentimeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * kilogramForceCentimeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * kilogramForceCentimeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * kilogramForceCentimeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilogram-force Millimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * kilogramForceMillimeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * kilogramForceMillimeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * kilogramForceMillimeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * kilogramForceMillimeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * kilogramForceMillimeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * kilogramForceMillimeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * kilogramForceMillimeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * kilogramForceMillimeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * kilogramForceMillimeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * kilogramForceMillimeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * kilogramForceMillimeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue =
                fromValue * kilogramForceMillimeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue =
                fromValue * kilogramForceMillimeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * kilogramForceMillimeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * kilogramForceMillimeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * kilogramForceMillimeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * kilogramForceMillimeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * kilogramForceMillimeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * kilogramForceMillimeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * kilogramForceMillimeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Dyne Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * dyneMeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * dyneMeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * dyneMeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * dyneMeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * dyneMeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * dyneMeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * dyneMeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * dyneMeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * dyneMeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * dyneMeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * dyneMeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * dyneMeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * dyneMeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * dyneMeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * dyneMeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * dyneMeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * dyneMeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * dyneMeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * dyneMeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * dyneMeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Dyne Centimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * dyneCentimeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * dyneCentimeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * dyneCentimeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * dyneCentimeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * dyneCentimeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * dyneCentimeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * dyneCentimeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * dyneCentimeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * dyneCentimeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * dyneCentimeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * dyneCentimeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * dyneCentimeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * dyneCentimeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * dyneCentimeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * dyneCentimeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * dyneCentimeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * dyneCentimeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * dyneCentimeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * dyneCentimeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * dyneCentimeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Dyne Millimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * dyneMillimeterToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * dyneMillimeterToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * dyneMillimeterToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * dyneMillimeterToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * dyneMillimeterToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * dyneMillimeterToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * dyneMillimeterToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * dyneMillimeterToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * dyneMillimeterToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * dyneMillimeterToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * dyneMillimeterToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * dyneMillimeterToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * dyneMillimeterToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * dyneMillimeterToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * dyneMillimeterToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * dyneMillimeterToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * dyneMillimeterToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * dyneMillimeterToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * dyneMillimeterToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * dyneMillimeterToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Pound-force Foot':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * poundForceFootToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * poundForceFootToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * poundForceFootToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * poundForceFootToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * poundForceFootToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * poundForceFootToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * poundForceFootToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * poundForceFootToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * poundForceFootToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * poundForceFootToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * poundForceFootToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * poundForceFootToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * poundForceFootToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * poundForceFootToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * poundForceFootToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * poundForceFootToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * poundForceFootToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * poundForceFootToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * poundForceFootToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * poundForceFootToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Pound-force Inch':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * poundForceInchToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * poundForceInchToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * poundForceInchToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * poundForceInchToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * poundForceInchToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * poundForceInchToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * poundForceInchToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * poundForceInchToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * poundForceInchToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * poundForceInchToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * poundForceInchToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * poundForceInchToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * poundForceInchToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * poundForceInchToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * poundForceInchToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * poundForceInchToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * poundForceInchToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue =
                fromValue; // No conversion needed if from and to units are the same
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * poundForceInchToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * poundForceInchToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Ounce-force Foot':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * ounceForceFootToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * ounceForceFootToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * ounceForceFootToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * ounceForceFootToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * ounceForceFootToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * ounceForceFootToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * ounceForceFootToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * ounceForceFootToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * ounceForceFootToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * ounceForceFootToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * ounceForceFootToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * ounceForceFootToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * ounceForceFootToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * ounceForceFootToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * ounceForceFootToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * ounceForceFootToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * ounceForceFootToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * ounceForceFootToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue =
                fromValue; // No conversion needed if from and to units are the same
            break;
          case 'Ounce-force Inch':
            toValue = fromValue * ounceForceFootToOunceForceInch;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Ounce-force Inch':
        switch (toUnit) {
          case 'Micronewton Meter':
            toValue = fromValue * ounceForceInchToMicronewtonMeter;
            break;
          case 'Millinewton Meter':
            toValue = fromValue * ounceForceInchToMillinewtonMeter;
            break;
          case 'Newton Meter':
            toValue = fromValue * ounceForceInchToNewtonMeter;
            break;
          case 'Kilonewton Meter':
            toValue = fromValue * ounceForceInchToKilonewtonMeter;
            break;
          case 'Meganewton Meter':
            toValue = fromValue * ounceForceInchToMeganewtonMeter;
            break;
          case 'Newton Centimeter':
            toValue = fromValue * ounceForceInchToNewtonCentimeter;
            break;
          case 'Newton Millimeter':
            toValue = fromValue * ounceForceInchToNewtonMillimeter;
            break;
          case 'Gram-force Meter':
            toValue = fromValue * ounceForceInchToGramForceMeter;
            break;
          case 'Gram-force Centimeter':
            toValue = fromValue * ounceForceInchToGramForceCentimeter;
            break;
          case 'Gram-force Millimeter':
            toValue = fromValue * ounceForceInchToGramForceMillimeter;
            break;
          case 'Kilogram-force Meter':
            toValue = fromValue * ounceForceInchToKilogramForceMeter;
            break;
          case 'Kilogram-force Centimeter':
            toValue = fromValue * ounceForceInchToKilogramForceCentimeter;
            break;
          case 'Kilogram-force Millimeter':
            toValue = fromValue * ounceForceInchToKilogramForceMillimeter;
            break;
          case 'Dyne Meter':
            toValue = fromValue * ounceForceInchToDyneMeter;
            break;
          case 'Dyne Centimeter':
            toValue = fromValue * ounceForceInchToDyneCentimeter;
            break;
          case 'Dyne Millimeter':
            toValue = fromValue * ounceForceInchToDyneMillimeter;
            break;
          case 'Pound-force Foot':
            toValue = fromValue * ounceForceInchToPoundForceFoot;
            break;
          case 'Pound-force Inch':
            toValue = fromValue * ounceForceInchToPoundForceInch;
            break;
          case 'Ounce-force Foot':
            toValue = fromValue * ounceForceInchToOunceForceFoot;
            break;
          case 'Ounce-force Inch':
            toValue =
                fromValue; // No conversion needed if from and to units are the same
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
      case 'Micronewton Meter':
        switch (toUnit) {
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 0.001';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 1e-6';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 1e-9';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1e-12';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 0.0001';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 0.001';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 1.0197e-7';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 1.0197e-5';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 0.00010197';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 1.0197e-10';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 1.0197e-8';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 1.0197e-7';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 1';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 0.1';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 7.37562e-9';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 8.85075e-8';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 1.18026e-7';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 1.41631e-6';
            break;
          case 'Micronewton Meter': // No conversion needed if from and to units are the same
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Millinewton Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 0.001';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 1e-6';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1e-9';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 0.1';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 1';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 0.10197';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 10.1971621';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 101.971621';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 0.00010197';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 0.0101971621';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 0.101971621';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 10,000';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 100';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 0.000737562';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 0.008851';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 0.0118';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 0.1416';
            break;
          case 'Millinewton Meter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Newton Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 1,000,000';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 0.001';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1e-6';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 100';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 101.971621';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 10,197.1621';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 101,971.621';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 0.101971621';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 10.1971621';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 101.971621';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 10,000,000';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 1,000,000';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 100,000';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 0.737562';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 8.851';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 11.8';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 141.6';
            break;
          case 'Newton Meter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kilonewton Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 1e9';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 1e6';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 1000';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 0.001';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 100000';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 1e6';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 101971.621';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 1.01971621e7';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 1.01971621e8';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 101.971621';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 10197.1621';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 101971.621';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 1e10';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 1e9';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 1e8';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 737.562';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 8850.74579';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 11809.1';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 141709.2';
            break;
          case 'Kilonewton Meter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Meganewton Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 1e12';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 1e9';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 1e6';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 1000';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 1e8';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 1e9';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 1.01971621e8';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 1.01971621e10';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 1.01971621e11';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 101971.621';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 1.01971621e7';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 1.01971621e8';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 1e13';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 1e12';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 1e11';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 737562';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 8850745.79';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 11809096';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 141709152';
            break;
          case 'Meganewton Meter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Newton Centimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 10000';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 0.01';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 1e-5';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1e-8';
            break;
          case 'Newton Centimeter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 0.1';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 0.101972';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 10.1972';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 1019.72';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 0.000101972';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 10.1972e-6';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 1019.72e-6';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 100000';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 10000';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 1000';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 0.00737562';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 0.0885074';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 0.118110';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 1.41732';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Newton Millimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 1,000,000';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 1';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 0.001';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1e-6';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 101.971621';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 10,197.1621';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 101,971.621';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 0.101971621';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 10.1971621';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 101.971621';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 10,000,000';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 1,000,000';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 100,000';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 0.737562';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 8.851';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 11.8';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 141.6';
            break;
          case 'Newton Millimeter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Gram-force Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 9,806,650';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 9,806.65';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 9.80665';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 0.00980665';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 9.80665e-6';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 980.665';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 9,806.65';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 100,000';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 1,000,000';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 1';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 100';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 980,665,000';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 98,066,500';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 9,806,650';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 7.23301';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 86.7962';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 115.722';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 1,388.67';
            break;
          case 'Gram-force Meter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Gram-force Centimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 98,066.5';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 98.0665';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 0.0980665';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 9.80665e-5';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 9.80665e-8';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 9.80665';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 98.0665';
            break;
          case 'Gram-force Meter':
            formula = 'Divide the torque value by 100';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 0.01';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'The value remains unchanged';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 9,806,650';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 980,665';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 98,066.5';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 0.0723301';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 0.867962';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 1.15722';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 13.8867';
            break;
          case 'Gram-force Centimeter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Gram-force Millimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 9,806.65';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 9.80665';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 0.00980665';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 9.80665e-6';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 9.80665e-9';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 0.980665';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 9.80665';
            break;
          case 'Gram-force Meter':
            formula = 'Divide the torque value by 1,000';
            break;
          case 'Gram-force Centimeter':
            formula = 'Divide the torque value by 10';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 0.00001';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 0.001';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'The value remains unchanged';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 980,665';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 98,066.5';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 9,806.65';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 0.00723301';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 0.0867962';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 0.115722';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 1.38867';
            break;
          case 'Gram-force Millimeter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Kilogram-force Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 9.80665e6';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 9.80665e3';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 9.80665';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 0.00980665';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 9.80665e-6';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 980.665';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 9,806.65';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 100,000';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 1,000,000';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 100';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 9.80665e8';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 9.80665e7';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 9.80665e6';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 7.23301';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 86.7962';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 115.722';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 1,388.67';
            break;
          case 'Kilogram-force Meter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Kilogram-force Centimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 9.80665e4';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 98.0665';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 0.0980665';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 9.80665e-5';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 9.80665e-8';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 9.80665';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 98.0665';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 10,000';
            break;
          case 'Kilogram-force Meter':
            formula = 'Divide the torque value by 100';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 9.80665e6';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 980,665';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 98,066.5';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 0.0723301';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 0.867962';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 1.15722';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 13.8867';
            break;
          case 'Kilogram-force Centimeter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Kilogram-force Millimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 9,806,650';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 9,806.65';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 9.80665';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 0.00980665';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 9.80665e-6';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 980.665';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 9,806.65';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 1,000';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 100,000';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 1,000,000';
            break;
          case 'Kilogram-force Meter':
            formula = 'Divide the torque value by 1,000';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Divide the torque value by 10';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 9.80665e7';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 9.80665e6';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 9.80665e5';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 0.0723301';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 0.867962';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 1.15722';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 13.8867';
            break;
          case 'Kilogram-force Millimeter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Dyne Meter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 100';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 0.1';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 1e-5';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 1e-8';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1e-11';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 1';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 1.01971621e-3';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 0.101971621';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 1.01971621';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 1.01971621e-6';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 1.01971621e-4';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 1.01971621e-3';
            break;
          case 'Dyne Centimeter':
            formula = 'Divide the torque value by 100';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 7.37562149e-6';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 8.85074579e-5';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 1.18009529e-4';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 1.41611435e-3';
            break;
          case 'Dyne Meter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Dyne Centimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 0.01';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 1e-7';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 1e-10';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1e-13';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 0.01';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 0.1';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 1.01971621e-5';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 1.01971621e-3';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 0.0101971621';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 1.01971621e-8';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 1.01971621e-6';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 1.01971621e-5';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 100';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 0.1';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 7.37562149e-8';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 8.85074579e-7';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 1.18009529e-6';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 1.41611435e-5';
            break;
          case 'Dyne Centimeter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Dyne Millimeter':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 1';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 0.001';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 1e-7';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 1e-10';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1e-13';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 0.001';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 0.01';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 1.01971621e-5';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 0.00101971621';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 0.0101971621';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 1.01971621e-8';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 1.01971621e-6';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 1.01971621e-5';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 0.1';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 10';
            break;
          case 'Pound-force Foot':
            formula = 'Multiply the torque value by 7.37562149e-8';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 8.85074579e-7';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 1.18009529e-6';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 1.41611435e-5';
            break;
          case 'Dyne Millimeter': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Pound-force Foot':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 1,355,817.95';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 1,355.81795';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 1.35581795';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 0.00135581795';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1.35581795e-6';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 135.581795';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 1,355.81795';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 138,255.027';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 13,825,502.7';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 138,255,027';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 138.255027';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 13,825.5027';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 138,255.027';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 13,558,179.5';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 1,355,817.95';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 135,581.795';
            break;
          case 'Pound-force Inch':
            formula = 'Multiply the torque value by 12';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 192';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 2,304';
            break;
          case 'Pound-force Foot': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Pound-force Inch':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 113,000.66295';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 113.00066295';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 0.112984829';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 0.000112984829';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 1.12984829e-7';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 11.2984829';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 112.984829';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 11,521.25225';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 1,152,125.225';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 11,521,252.25';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 11.52125225';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 1,152.125225';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 11,521.25225';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 1,130,006.6295';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 113,000.66295';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 11,300.066295';
            break;
          case 'Pound-force Foot':
            formula = 'Divide the torque value by 12';
            break;
          case 'Ounce-force Foot':
            formula = 'Multiply the torque value by 16';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 192';
            break;
          case 'Pound-force Inch': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;

      case 'Ounce-force Foot':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 7,061.67979';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 7.06167979';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 0.00706167979';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 7.06167979e-6';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 7.06167979e-9';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 0.706167979';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 7.06167979';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 720.079';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 72,007.9';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 720,079';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 0.720079';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 72.0079';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 720.079';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 7,061,679.79';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 706,167.979';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 70,616.7979';
            break;
          case 'Pound-force Foot':
            formula = 'Divide the torque value by 16';
            break;
          case 'Pound-force Inch':
            formula = 'Divide the torque value by 192';
            break;
          case 'Ounce-force Inch':
            formula = 'Multiply the torque value by 12';
            break;
          case 'Ounce-force Foot': // No conversion needed
            formula = 'The value remains unchanged';
            break;
          default:
            formula = 'Unknown conversion';
        }
        break;
      case 'Ounce-force Inch':
        switch (toUnit) {
          case 'Micronewton Meter':
            formula = 'Multiply the torque value by 588.473316';
            break;
          case 'Millinewton Meter':
            formula = 'Multiply the torque value by 0.588473316';
            break;
          case 'Newton Meter':
            formula = 'Multiply the torque value by 0.000588473316';
            break;
          case 'Kilonewton Meter':
            formula = 'Multiply the torque value by 5.88473316e-7';
            break;
          case 'Meganewton Meter':
            formula = 'Multiply the torque value by 5.88473316e-10';
            break;
          case 'Newton Centimeter':
            formula = 'Multiply the torque value by 0.0588473316';
            break;
          case 'Newton Millimeter':
            formula = 'Multiply the torque value by 0.588473316';
            break;
          case 'Gram-force Meter':
            formula = 'Multiply the torque value by 60.00658';
            break;
          case 'Gram-force Centimeter':
            formula = 'Multiply the torque value by 6,000.658';
            break;
          case 'Gram-force Millimeter':
            formula = 'Multiply the torque value by 60,006.58';
            break;
          case 'Kilogram-force Meter':
            formula = 'Multiply the torque value by 0.06000658';
            break;
          case 'Kilogram-force Centimeter':
            formula = 'Multiply the torque value by 6.000658';
            break;
          case 'Kilogram-force Millimeter':
            formula = 'Multiply the torque value by 60.00658';
            break;
          case 'Dyne Meter':
            formula = 'Multiply the torque value by 588,473.316';
            break;
          case 'Dyne Centimeter':
            formula = 'Multiply the torque value by 58,847.3316';
            break;
          case 'Dyne Millimeter':
            formula = 'Multiply the torque value by 5,884.73316';
            break;
          case 'Pound-force Foot':
            formula = 'Divide the torque value by 192';
            break;
          case 'Pound-force Inch':
            formula = 'Divide the torque value by 16';
            break;
          case 'Ounce-force Foot':
            formula = 'Divide the torque value by 12';
            break;
          case 'Ounce-force Inch': // No conversion needed
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
                        context.navigateTo('/');
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
                        'Convert Torque',
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

                        /*TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.grey
                              : const Color(0xFF2C3A47),
                        ), */
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
                        text: 'Formula:'.tr(),
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
      case 'Micronewton Meter':
        return 'µNm';
      case 'Millinewton Meter':
        return 'mNm';
      case 'Newton Meter':
        return 'Nm';
      case 'Kilonewton Meter':
        return 'kNm';
      case 'Meganewton Meter':
        return 'MNm';
      case 'Newton Centimeter':
        return 'Ncm';
      case 'Newton Millimeter':
        return 'Nmm';
      case 'Gram-force Meter':
        return 'gf·m';
      case 'Gram-force Centimeter':
        return 'gf·cm';
      case 'Gram-force Millimeter':
        return 'gf·mm';
      case 'Kilogram-force Meter':
        return 'kgf·m';
      case 'Kilogram-force Centimeter':
        return 'kgf·cm';
      case 'Kilogram-force Millimeter':
        return 'kgf·mm';
      case 'Dyne Meter':
        return 'dyn·m';
      case 'Dyne Centimeter':
        return 'dyn·cm';
      case 'Dyne Millimeter':
        return 'dyn·mm';
      case 'Pound-force Foot':
        return 'lbf·ft';
      case 'Pound-force Inch':
        return 'lbf·in';
      case 'Ounce-force Foot':
        return 'ozf·ft';
      case 'Ounce-force Inch':
        return 'ozf·in';
      default:
        return '';
    }
  }

  Widget _buildUnitColumn(String label, TextEditingController controller,
      String unit, String prefix, bool isFrom) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 0.125), // 12.5% padding from each side
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isFrom
              ? TextField(
                  // If it's the 'From' field, allow input
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: label,
                    filled: true,
                    fillColor: Colors.white,
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
                      onPressed: () =>
                          copyToClipboard(controller.text, context),
                    ),
                  ),
                )
              : TextFormField(
                  // If it's the 'To' field, make it read-only
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  enabled: true, // This disables the field
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: label.tr(),
                    filled: true,
                    fillColor: Colors
                        .grey[300], // A lighter color to indicate it's disabled
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
                      onPressed: () =>
                          copyToClipboard(controller.text, context),
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
      'Micronewton Meter',
      'Millinewton Meter',
      'Newton Meter',
      'Kilonewton Meter',
      'Meganewton Meter',
      'Newton Centimeter',
      'Newton Millimeter',
      'Gram-force Meter',
      'Gram-force Centimeter',
      'Gram-force Millimeter',
      'Kilogram-force Meter',
      'Kilogram-force Centimeter',
      'Kilogram-force Millimeter',
      'Dyne Meter',
      'Dyne Centimeter',
      'Dyne Millimeter',
      'Pound-force Foot',
      'Pound-force Inch',
      'Ounce-force Foot',
      'Ounce-force Inch',
    ].map<DropdownMenuItem<String>>((String value) {
      String translatedValue = value.tr();
      return DropdownMenuItem<String>(
          value: value,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${_getPrefix(value)}', // Prefix part
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
              color: isDarkMode ? Colors.white : Colors.black, fontSize: 23),
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
                fontSize: 23,
              ),
            ).tr(),
          );
        }).toList();
      },
    );
  }
}
