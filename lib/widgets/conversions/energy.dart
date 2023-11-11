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

class EnergyUnitConverter extends StatefulWidget {
  const EnergyUnitConverter({super.key});

  @override
  _EnergyUnitConverterState createState() => _EnergyUnitConverterState();
}

class _EnergyUnitConverterState extends State<EnergyUnitConverter> {
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Nanojoules';
  String toUnit = 'Microjoules';
  // Removed duplicate declarations of TextEditingController
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  bool _isExponentialFormat = false;
  // Flag to indicate if the change is due to user input
  bool _isUserInput = true;
  // Using string variables for prefixes
  String fromPrefix = 'nJ';
  String toPrefix = 'μJ';
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
          text: 'Check out my energy result!');
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

//NANOJOULES
    const double nanojoulesToMicrojoules = 1e-6;
    const double nanojoulesToMillijoules = 0.001;
    const double nanojoulesToJoules = 1.0;
    const double nanojoulesToKilojoules = 1e3;
    const double nanojoulesToMegajoules = 1e6;
    const double nanojoulesToNewtonMetres =
        1.0; // Newton-metres are equivalent to Joules.
    const double nanojoulesToWattHours = 2.77778e-7;
    const double nanojoulesToKilowattHours = 2.77778e-10;
    const double nanojoulesToMegawattHours = 2.77778e-13;
    const double nanojoulesToCalories = 0.239006;
    const double nanojoulesToKilocalories = 0.000239006;
    const double nanojoulesToFootPoundsForce = 0.737562;
    const double nanojoulesToBritishThermalUnitsISO = 0.000947817;
    const double nanojoulesToTherms = 9.47817e-9;
    const double nanojoulesToHorsepowerHours = 3.72506e-7;
    const double nanojoulesToBarrelsOfOilEquivalent = 1.63456e-10;
    const double nanojoulesToTonnesOfOilEquivalent = 2.38846e-11;
    const double nanojoulesToTonnesOfTNT = 2.39006e-10;
    const double nanojoulesToKilotonnesOfTNT = 2.39006e-13;
    const double nanojoulesToMegatonnesOfTNT = 2.39006e-16;
    const double nanojoulesToErgs = 1e-7;
    const double nanojoulesToElectronvolt = 6.24150;
    const double nanojoulesToKiloelectronvolt = 0.00624150;
    const double nanojoulesToMegaelectronvolt = 6.24150e-6;
    const double nanojoulesToGigaelectronvolt = 6.24150e-9;

//MICROJOULES

    const double microjoulesToNanojoules = 1000.0;
    const double microjoulesToMicrojoules = 1e-6;
    const double microjoulesToMillijoules = 0.001;
    const double microjoulesToJoules = 1.0;
    const double microjoulesToKilojoules = 1000.0;
    const double microjoulesToMegajoules = 1e6;
    const double microjoulesToNewtonMetres =
        1.0; // Newton-metres are equivalent to Joules.
    const double microjoulesToWattHours = 0.0002777777777777778;
    const double microjoulesToKilowattHours = 2.77778e-7;
    const double microjoulesToMegawattHours = 2.77778e-10;
    const double microjoulesToCalories = 0.239006;
    const double microjoulesToKilocalories = 0.000239006;
    const double microjoulesToFootPoundsForce = 0.737562;
    const double microjoulesToBritishThermalUnitsISO = 0.000947817;
    const double microjoulesToTherms = 9.47817e-9;
    const double microjoulesToHorsepowerHours = 3.72506e-7;
    const double microjoulesToBarrelsOfOilEquivalent = 1.63456e-10;
    const double microjoulesToTonnesOfOilEquivalent = 2.38846e-11;
    const double microjoulesToTonnesOfTNT = 2.39006e-10;
    const double microjoulesToKilotonnesOfTNT = 2.39006e-13;
    const double microjoulesToMegatonnesOfTNT = 2.39006e-16;
    const double microjoulesToErgs = 1e-5;
    const double microjoulesToElectronvolt = 6.2415e6;
    const double microjoulesToKiloelectronvolt = 6241.5;
    const double microjoulesToMegaelectronvolt = 6.2415;
    const double microjoulesToGigaelectronvolt = 0.0062415;

//MILLIJOULES
    const double millijoulesToNanojoules = 1000000.0;
    const double millijoulesToMicrojoules = 1000.0;
    const double millijoulesToMillijoules = 1.0;
    const double millijoulesToJoules = 0.001;
    const double millijoulesToKilojoules = 1e-6;
    const double millijoulesToMegajoules = 1e-9;
    const double millijoulesToNewtonMetres =
        0.001; // Newton-metres are equivalent to Joules.
    const double millijoulesToWattHours = 2.77778e-7;
    const double millijoulesToKilowattHours = 2.77778e-10;
    const double millijoulesToMegawattHours = 2.77778e-13;
    const double millijoulesToCalories = 0.000239006;
    const double millijoulesToKilocalories = 2.39006e-7;
    const double millijoulesToFootPoundsForce = 0.000737562;
    const double millijoulesToBritishThermalUnitsISO = 9.47817e-7;
    const double millijoulesToTherms = 9.47817e-12;
    const double millijoulesToHorsepowerHours = 3.72506e-10;
    const double millijoulesToBarrelsOfOilEquivalent = 1.63456e-13;
    const double millijoulesToTonnesOfOilEquivalent = 2.38846e-14;
    const double millijoulesToTonnesOfTNT = 2.39006e-13;
    const double millijoulesToKilotonnesOfTNT = 2.39006e-16;
    const double millijoulesToMegatonnesOfTNT = 2.39006e-19;
    const double millijoulesToErgs = 10000.0;
    const double millijoulesToElectronvolt = 6241500000000000.0;
    const double millijoulesToKiloelectronvolt = 6241500000000.0;
    const double millijoulesToMegaelectronvolt = 6241500000.0;
    const double millijoulesToGigaelectronvolt = 6241500.0;

//JOULES
    const double joulesToNanojoules = 1000000000.0;
    const double joulesToMicrojoules = 1000000.0;
    const double joulesToMillijoules = 1000.0;
    const double joulesToJoules = 1.0;
    const double joulesToKilojoules = 0.001;
    const double joulesToMegajoules = 1e-6;
    const double joulesToNewtonMetres =
        1.0; // Newton-metres are equivalent to Joules.
    const double joulesToWattHours = 0.000277778;
    const double joulesToKilowattHours = 2.77778e-7;
    const double joulesToMegawattHours = 2.77778e-10;
    const double joulesToCalories = 0.239006;
    const double joulesToKilocalories = 0.000239006;
    const double joulesToFootPoundsForce = 0.737562;
    const double joulesToBritishThermalUnitsISO = 0.000947817;
    const double joulesToTherms = 9.47817e-9;
    const double joulesToHorsepowerHours = 3.72506e-7;
    const double joulesToBarrelsOfOilEquivalent = 1.63456e-10;
    const double joulesToTonnesOfOilEquivalent = 2.38846e-11;
    const double joulesToTonnesOfTNT = 2.39006e-10;
    const double joulesToKilotonnesOfTNT = 2.39006e-13;
    const double joulesToMegatonnesOfTNT = 2.39006e-16;
    const double joulesToErgs = 10000000.0;
    const double joulesToElectronvolt = 6.2415e+18;
    const double joulesToKiloelectronvolt = 6241500000000000.0;
    const double joulesToMegaelectronvolt = 6241500000000.0;
    const double joulesToGigaelectronvolt = 6241500000.0;

//KILOJOULES
    const double kilojoulesToNanojoules = 1e12;
    const double kilojoulesToMicrojoules = 1e9;
    const double kilojoulesToMillijoules = 1e6;
    const double kilojoulesToJoules = 1e3;
    const double kilojoulesToKilojoules = 1.0; // Identity
    const double kilojoulesToMegajoules = 0.001;
    const double kilojoulesToNewtonMetres =
        1e3; // Newton-metres are equivalent to Joules.
    const double kilojoulesToWattHours = 0.277778;
    const double kilojoulesToKilowattHours = 0.000277778;
    const double kilojoulesToMegawattHours = 2.77778e-7;
    const double kilojoulesToCalories = 239.006;
    const double kilojoulesToKilocalories = 0.239006;
    const double kilojoulesToFootPoundsForce = 737.562;
    const double kilojoulesToBritishThermalUnitsISO = 0.947817;
    const double kilojoulesToTherms = 9.47817e-6;
    const double kilojoulesToHorsepowerHours = 0.000372506;
    const double kilojoulesToBarrelsOfOilEquivalent = 1.63456e-7;
    const double kilojoulesToTonnesOfOilEquivalent = 2.38846e-8;
    const double kilojoulesToTonnesOfTNT = 2.39006e-7;
    const double kilojoulesToKilotonnesOfTNT = 2.39006e-10;
    const double kilojoulesToMegatonnesOfTNT = 2.39006e-13;
    const double kilojoulesToErgs = 1e10;
    const double kilojoulesToElectronvolt = 6.2415e21;
    const double kilojoulesToKiloelectronvolt = 6.2415e18;
    const double kilojoulesToMegaelectronvolt = 6.2415e15;
    const double kilojoulesToGigaelectronvolt = 6.2415e12;

//MEGAJOULES
    const double megajoulesToNanojoules = 1e15;
    const double megajoulesToMicrojoules = 1e12;
    const double megajoulesToMillijoules = 1e9;
    const double megajoulesToJoules = 1e6;
    const double megajoulesToKilojoules = 1e3;

    const double megajoulesToNewtonMetres =
        1e6; // Newton-metres are equivalent to Joules.
    const double megajoulesToWattHours = 277.778;
    const double megajoulesToKilowattHours = 0.277778;
    const double megajoulesToMegawattHours = 0.000277778;
    const double megajoulesToCalories = 239006.0;
    const double megajoulesToKilocalories = 239.006;
    const double megajoulesToFootPoundsForce = 737562.0;
    const double megajoulesToBritishThermalUnitsISO = 947.817;
    const double megajoulesToTherms = 0.00947817;
    const double megajoulesToHorsepowerHours = 0.372506;
    const double megajoulesToBarrelsOfOilEquivalent = 0.000163456;
    const double megajoulesToTonnesOfOilEquivalent = 2.38846e-5;
    const double megajoulesToTonnesOfTNT = 0.000239006;
    const double megajoulesToKilotonnesOfTNT = 2.39006e-7;
    const double megajoulesToMegatonnesOfTNT = 2.39006e-10;
    const double megajoulesToErgs = 1e13;
    const double megajoulesToElectronvolt = 6.2415e24;
    const double megajoulesToKiloelectronvolt = 6.2415e21;
    const double megajoulesToMegaelectronvolt = 6.2415e18;
    const double megajoulesToGigaelectronvolt = 6.2415e15;

//NEWTON METRES
    const double newtonmetresToNanojoules = 1e9;
    const double newtonmetresToMicrojoules = 1e6;
    const double newtonmetresToMillijoules = 1e3;
    const double newtonmetresToJoules = 1.0; // Identity
    const double newtonmetresToKilojoules = 0.001;
    const double newtonmetresToMegajoules = 1e-6;
    const double newtonmetresToWattHours = 0.000277778;
    const double newtonmetresToKilowattHours = 2.77778e-7;
    const double newtonmetresToMegawattHours = 2.77778e-10;
    const double newtonmetresToCalories = 0.239006;
    const double newtonmetresToKilocalories = 0.000239006;
    const double newtonmetresToFootPoundsForce = 0.737562;
    const double newtonmetresToBritishThermalUnitsISO = 0.000947817;
    const double newtonmetresToTherms = 9.47817e-9;
    const double newtonmetresToHorsepowerHours = 3.72506e-7;
    const double newtonmetresToBarrelsOfOilEquivalent = 1.63456e-10;
    const double newtonmetresToTonnesOfOilEquivalent = 2.38846e-11;
    const double newtonmetresToTonnesOfTNT = 2.39006e-10;
    const double newtonmetresToKilotonnesOfTNT = 2.39006e-13;
    const double newtonmetresToMegatonnesOfTNT = 2.39006e-16;
    const double newtonmetresToErgs = 1e7;
    const double newtonmetresToElectronvolt = 6.2415e+18;
    const double newtonmetresToKiloelectronvolt = 6.2415e+15;
    const double newtonmetresToMegaelectronvolt = 6.2415e+12;
    const double newtonmetresToGigaelectronvolt = 6.2415e+9;

//WATTHOURS
    const double watthoursToNanojoules = 3.6e12;
    const double watthoursToMicrojoules = 3.6e9;
    const double watthoursToMillijoules = 3.6e6;
    const double watthoursToJoules = 3600.0;
    const double watthoursToKilojoules = 3.6;
    const double watthoursToMegajoules = 0.0036;
    const double watthoursToNewtonMetres =
        3600.0; // Newton-metres are equivalent to Joules.
    const double watthoursToKilowattHours = 0.001;
    const double watthoursToMegawattHours = 1e-6;
    const double watthoursToCalories = 860.4216;
    const double watthoursToKilocalories = 0.8604216;
    const double watthoursToFootPoundsForce = 2655.2232;
    const double watthoursToBritishThermalUnitsISO = 3.4121412;
    const double watthoursToTherms = 3.4121412e-5;
    const double watthoursToHorsepowerHours = 0.0013410216;
    const double watthoursToBarrelsOfOilEquivalent = 5.884416e-7;
    const double watthoursToTonnesOfOilEquivalent = 8.598456e-8;
    const double watthoursToTonnesOfTNT = 8.604216e-7;
    const double watthoursToKilotonnesOfTNT = 8.604216e-10;
    const double watthoursToMegatonnesOfTNT = 8.604216e-13;
    const double watthoursToErgs = 3.6e10;
    const double watthoursToElectronvolt = 2.24694e+22;
    const double watthoursToKiloelectronvolt = 2.24694e+19;
    const double watthoursToMegaelectronvolt = 2.24694e+16;
    const double watthoursToGigaelectronvolt = 2.24694e+13;

//KILOWATT HOURS
    const double kilowatthoursToNanojoules = 3.6e15;
    const double kilowatthoursToMicrojoules = 3.6e12;
    const double kilowatthoursToMillijoules = 3.6e9;
    const double kilowatthoursToJoules = 3.6e6;
    const double kilowatthoursToKilojoules = 3600.0;
    const double kilowatthoursToMegajoules = 3.6;
    const double kilowatthoursToNewtonMetres =
        3.6e6; // Newton-metres are equivalent to Joules.
    const double kilowatthoursToWattHours = 1000.0;
    const double kilowatthoursToMegawattHours = 0.001;
    const double kilowatthoursToCalories = 860421.6;
    const double kilowatthoursToKilocalories = 860.4216;
    const double kilowatthoursToFootPoundsForce = 2655223.2;
    const double kilowatthoursToBritishThermalUnitsISO = 3412.1412;
    const double kilowatthoursToTherms = 0.034121412;
    const double kilowatthoursToHorsepowerHours = 1.3410216;
    const double kilowatthoursToBarrelsOfOilEquivalent = 0.0005884416;
    const double kilowatthoursToTonnesOfOilEquivalent = 0.00008598456;
    const double kilowatthoursToTonnesOfTNT = 0.0008604216;
    const double kilowatthoursToKilotonnesOfTNT = 8.604216e-7;
    const double kilowatthoursToMegatonnesOfTNT = 8.604216e-10;
    const double kilowatthoursToErgs = 3.6e13;
    const double kilowatthoursToElectronvolt = 2.24694e+25;
    const double kilowatthoursToKiloelectronvolt = 2.24694e+22;
    const double kilowatthoursToMegaelectronvolt = 2.24694e+19;
    const double kilowatthoursToGigaelectronvolt = 2.24694e+16;

//MEGAWATT HOURS
    const double megawatthoursToNanojoules = 3.6e18;
    const double megawatthoursToMicrojoules = 3.6e15;
    const double megawatthoursToMillijoules = 3.6e12;
    const double megawatthoursToJoules = 3.6e9;
    const double megawatthoursToKilojoules = 3.6e6;
    const double megawatthoursToMegajoules = 3600.0;
    const double megawatthoursToNewtonMetres =
        3.6e9; // Newton-metres are equivalent to Joules.
    const double megawatthoursToWattHours = 1e6;
    const double megawatthoursToKilowattHours = 1000.0;
    const double megawatthoursToMegawattHours = 1.0; // Identity
    const double megawatthoursToCalories = 8.604216e8;
    const double megawatthoursToKilocalories = 860421.6;
    const double megawatthoursToFootPoundsForce = 2.6552232e9;
    const double megawatthoursToBritishThermalUnitsISO = 3.4121412e6;
    const double megawatthoursToTherms = 34121.412;
    const double megawatthoursToHorsepowerHours = 1341.0216;
    const double megawatthoursToBarrelsOfOilEquivalent = 0.5884416;
    const double megawatthoursToTonnesOfOilEquivalent = 0.08598456;
    const double megawatthoursToTonnesOfTNT = 0.8604216;
    const double megawatthoursToKilotonnesOfTNT = 0.0008604216;
    const double megawatthoursToMegatonnesOfTNT = 8.604216e-7;
    const double megawatthoursToErgs = 3.6e16;
    const double megawatthoursToElectronvolt = 2.24694e+28;
    const double megawatthoursToKiloelectronvolt = 2.24694e+25;
    const double megawatthoursToMegaelectronvolt = 2.24694e+22;
    const double megawatthoursToGigaelectronvolt = 2.24694e+19;

//CALORIES
    const double caloriesToNanojoules = 4.184e9;
    const double caloriesToMicrojoules = 4.184e6;
    const double caloriesToMillijoules = 4184.0;
    const double caloriesToJoules = 4.184;
    const double caloriesToKilojoules = 0.004184;
    const double caloriesToMegajoules = 4.184e-6;
    const double caloriesToNewtonMetres =
        4.184; // Newton-metres are equivalent to Joules.
    const double caloriesToWattHours = 0.001162223152;
    const double caloriesToKilowattHours = 1.162223152e-6;
    const double caloriesToMegawattHours = 1.162223152e-9;
    const double caloriesToKilocalories = 0.001;
    const double caloriesToFootPoundsForce = 3.085959408;
    const double caloriesToBritishThermalUnitsISO = 0.003965666328;
    const double caloriesToTherms = 3.965666328e-8;
    const double caloriesToHorsepowerHours = 1.558565104e-6;
    const double caloriesToBarrelsOfOilEquivalent = 6.83899904e-10;
    const double caloriesToTonnesOfOilEquivalent = 9.99331664e-11;
    const double caloriesToTonnesOfTNT = 1.000001104e-9;
    const double caloriesToKilotonnesOfTNT = 1.000001104e-12;
    const double caloriesToMegatonnesOfTNT = 1.000001104e-15;
    const double caloriesToErgs = 4.184e7;
    const double caloriesToElectronvolt = 2.6114436e+19;
    const double caloriesToKiloelectronvolt = 2.6114436e+16;
    const double caloriesToMegaelectronvolt = 2.6114436e+13;
    const double caloriesToGigaelectronvolt = 2.6114436e+10;

//KILOCALORIES
    const double kilocaloriesToNanojoules = 4.184e12;
    const double kilocaloriesToMicrojoules = 4.184e9;
    const double kilocaloriesToMillijoules = 4.184e6;
    const double kilocaloriesToJoules = 4184.0;
    const double kilocaloriesToKilojoules = 4.184;
    const double kilocaloriesToMegajoules = 0.004184;
    const double kilocaloriesToNewtonMetres =
        4184.0; // Newton-metres are equivalent to Joules.
    const double kilocaloriesToWattHours = 1.162223152;
    const double kilocaloriesToKilowattHours = 0.001162223152;
    const double kilocaloriesToMegawattHours = 1.162223152e-6;
    const double kilocaloriesToCalories = 1000.0;
    const double kilocaloriesToFootPoundsForce = 3085.959408;
    const double kilocaloriesToBritishThermalUnitsISO = 3.965666328;
    const double kilocaloriesToTherms = 3.965666328e-5;
    const double kilocaloriesToHorsepowerHours = 0.001558565104;
    const double kilocaloriesToBarrelsOfOilEquivalent = 6.83899904e-7;
    const double kilocaloriesToTonnesOfOilEquivalent = 9.99331664e-8;
    const double kilocaloriesToTonnesOfTNT = 1.000001104e-6;
    const double kilocaloriesToKilotonnesOfTNT = 1.000001104e-9;
    const double kilocaloriesToMegatonnesOfTNT = 1.000001104e-12;
    const double kilocaloriesToErgs = 4.184e10;
    const double kilocaloriesToElectronvolt = 2.6114436e+22;
    const double kilocaloriesToKiloelectronvolt = 2.6114436e+19;
    const double kilocaloriesToMegaelectronvolt = 2.6114436e+16;
    const double kilocaloriesToGigaelectronvolt = 2.6114436e+13;

//FOOTPOUNDS FORCE
    const double footpoundsforceToNanojoules = 1.3558179483314004e9;
    const double footpoundsforceToMicrojoules = 1.3558179483314004e6;
    const double footpoundsforceToMillijoules = 1355.8179483314004;
    const double footpoundsforceToJoules = 1.3558179483314004;
    const double footpoundsforceToKilojoules = 0.0013558179483314004;
    const double footpoundsforceToMegajoules = 1.3558179483314004e-6;
    const double footpoundsforceToNewtonMetres =
        1.3558179483314004; // Newton-metres are equivalent to Joules.
    const double footpoundsforceToWattHours = 0.00037661639805159974;
    const double footpoundsforceToKilowattHours = 3.7661639805159974e-7;
    const double footpoundsforceToMegawattHours = 3.7661639805159974e-10;
    const double footpoundsforceToCalories = 0.3240486245588947;
    const double footpoundsforceToKilocalories = 0.0003240486245588947;
    const double footpoundsforceToFootPoundsForce = 1.0; // Identity
    const double footpoundsforceToBritishThermalUnitsISO = 0.001285067300333623;
    const double footpoundsforceToTherms = 1.285067300333623e-8;
    const double footpoundsforceToHorsepowerHours = 5.050503206611366e-7;
    const double footpoundsforceToBarrelsOfOilEquivalent =
        2.2161657856245736e-10;
    const double footpoundsforceToTonnesOfOilEquivalent = 3.238316936871616e-11;
    const double footpoundsforceToTonnesOfTNT = 3.240486245588947e-10;
    const double footpoundsforceToKilotonnesOfTNT = 3.240486245588947e-13;
    const double footpoundsforceToMegatonnesOfTNT = 3.240486245588947e-16;
    const double footpoundsforceToErgs = 1.3558179483314004e7;
    const double footpoundsforceToElectronvolt = 8.462337724510435e+18;
    const double footpoundsforceToKiloelectronvolt = 8.462337724510435e+15;
    const double footpoundsforceToMegaelectronvolt = 8.462337724510435e+12;
    const double footpoundsforceToGigaelectronvolt = 8.462337724510435e+9;

//BRITISH THERMAL UNITS ISO
    const double britishthermalunitsISOTOnanojoules = 1.05505585262e12;
    const double britishthermalunitsISOTOmicrojoules = 1.05505585262e9;
    const double britishthermalunitsISOTOmillijoules = 1.05505585262e6;
    const double britishthermalunitsISOTOjoules = 1.05505585262e3;
    const double britishthermalunitsISOTOkilojoules = 1.05505585262;
    const double britishthermalunitsISOTONewtonMetres =
        1.05505585262e3; // Newton-metres are equivalent to Joules.
    const double britishthermalunitsISOTOWattHours = 0.2930713046290784;
    const double britishthermalunitsISOTOKilowattHours = 0.00029307130462907836;
    const double britishthermalunitsISOTOMegawattHours = 2.9307130462907833e-7;
    const double britishthermalunitsISOTOCalories = 252.16467911129573;
    const double britishthermalunitsISOTOKilocalories = 0.2521646791112957;
    const double britishthermalunitsISOTOFootPoundsForce = 778.1691047701125;
    const double britishthermalunitsISOTOtherms = 9.999998730627305e-6;
    const double britishthermalunitsISOTOHorsepowerHours =
        0.0003930146354360657;
    const double britishthermalunitsISOTOBarrelsOfOilEquivalent =
        1.724552094458547e-7;
    const double britishthermalunitsISOTOTonnesOfOilEquivalent =
        2.5199587017487652e-8;
    const double britishthermalunitsISOTOTonnesOfTNT = 2.521646791112957e-7;
    const double britishthermalunitsISOTOKilotonnesOfTNT =
        2.5216467911129576e-10;
    const double britishthermalunitsISOTOMegatonnesOfTNT =
        2.5216467911129573e-13;
    const double britishthermalunitsISOTOErgs = 1.05505585262e10;
    const double britishthermalunitsISOTOElectronvolt = 6.58513110412773e+21;
    const double britishthermalunitsISOTOKiloelectronvolt =
        6.58513110412773e+18;
    const double britishthermalunitsISOTOMegaelectronvolt =
        6.58513110412773e+15;
    const double britishthermalunitsISOTOGigaelectronvolt =
        6.58513110412773e+12;

//THERMS
    const double thermsToNanojoules = 1.05506e+17;
    const double thermsToMicrojoules = 1.05506e+14;
    const double thermsToMillijoules = 1.05506e+11;
    const double thermsToJoules = 1.05506e+8;
    const double thermsToKilojoules = 1.05506e+5;
    const double thermsToMegajoules = 105.506;
    const double thermsToNewtonMetres =
        1.05506e+8; // Newton-metres are equivalent to Joules.
    const double thermsToWattHours = 29307.245668;
    const double thermsToKilowattHours = 29.307245668;
    const double thermsToMegawattHours = 0.029307245668;
    const double thermsToCalories = 2.5216567036e+7;
    const double thermsToKilocalories = 25216.567036;
    const double thermsToFootPoundsForce = 7.7817216372e+7;
    const double thermsToBritishThermalUnitsISO = 100000.380402;
    const double thermsToHorsepowerHours = 39.301618036;
    const double thermsToBarrelsOfOilEquivalent = 0.017245588736;
    const double thermsToTonnesOfOilEquivalent = 0.0025199686076;
    const double thermsToTonnesOfTNT = 0.025216567036;
    const double thermsToKilotonnesOfTNT = 2.5216567036e-5;
    const double thermsToMegatonnesOfTNT = 2.5216567036e-8;
    const double thermsToErgs = 1.05506e+15;
    const double thermsToElectronvolt = 6.58515699e+26;
    const double thermsToKiloelectronvolt = 6.58515699e+23;
    const double thermsToMegaelectronvolt = 6.58515699e+20;
    const double thermsToGigaelectronvolt = 6.58515699e+17;

//HORSEPOWER HOURS
    const double horsepowerhoursToNanojoules = 7.457e+11;
    const double horsepowerhoursToMicrojoules = 7.457e+8;
    const double horsepowerhoursToMillijoules = 7.457e+5;
    const double horsepowerhoursToJoules = 745.7;
    const double horsepowerhoursToKilojoules = 0.7457;
    const double horsepowerhoursToMegajoules = 0.0007457;
    const double horsepowerhoursToNewtonMetres =
        745.7; // Newton-metres are equivalent to Joules.
    const double horsepowerhoursToWattHours = 0.2071390546;
    const double horsepowerhoursToKilowattHours = 0.0002071390546;
    const double horsepowerhoursToMegawattHours = 2.071390546e-7;
    const double horsepowerhoursToCalories = 178.2267742;
    const double horsepowerhoursToKilocalories = 0.1782267742;
    const double horsepowerhoursToFootPoundsForce = 550.0; // approximately
    const double horsepowerhoursToBritishThermalUnitsISO = 0.7067871369;
    const double horsepowerhoursToTherms = 7.067871369e-6;
    const double horsepowerhoursToHorsepowerHours = 1.0; // Identity
    const double horsepowerhoursToBarrelsOfOilEquivalent = 1.218891392e-7;
    const double horsepowerhoursToTonnesOfOilEquivalent = 1.781074622e-8;
    const double horsepowerhoursToTonnesOfTNT = 1.782267742e-7;
    const double horsepowerhoursToKilotonnesOfTNT = 1.782267742e-10;
    const double horsepowerhoursToMegatonnesOfTNT = 1.782267742e-13;
    const double horsepowerhoursToErgs = 7.457e+9;
    const double horsepowerhoursToElectronvolt = 4.65428655e+21;
    const double horsepowerhoursToKiloelectronvolt = 4.65428655e+18;
    const double horsepowerhoursToMegaelectronvolt = 4.65428655e+15;
    const double horsepowerhoursToGigaelectronvolt = 4.65428655e+12;
//BARRELS OF OIL EQUIVALENT
    const double barrelsofoilequivalentToNanojoules = 6.1194e+18;
    const double barrelsofoilequivalentToMicrojoules = 6.1194e+15;
    const double barrelsofoilequivalentToMillijoules = 6.1194e+12;
    const double barrelsofoilequivalentToJoules = 6.1194e+9;
    const double barrelsofoilequivalentToKilojoules = 6.1194e+6;
    const double barrelsofoilequivalentToMegajoules = 6119.4;
    const double barrelsofoilequivalentToNewtonMetres =
        6.1194e+9; // Newton-metres are equivalent to Joules.
    const double barrelsofoilequivalentToWattHours = 1699834.6932;
    const double barrelsofoilequivalentToKilowattHours = 1699.8346932;
    const double barrelsofoilequivalentToMegawattHours = 1.6998346932;
    const double barrelsofoilequivalentToCalories = 1.4625733164e+9;
    const double barrelsofoilequivalentToKilocalories = 1462573.3164;
    const double barrelsofoilequivalentToFootPoundsForce = 4.5134369028e+9;
    const double barrelsofoilequivalentToBritishThermalUnitsISO = 5800071.3498;
    const double barrelsofoilequivalentToTherms = 58.000713498;
    const double barrelsofoilequivalentToHorsepowerHours = 2279.5132164;
    const double barrelsofoilequivalentToTonnesOfOilEquivalent = 0.14615942124;
    const double barrelsofoilequivalentToTonnesOfTNT = 1.4625733164;
    const double barrelsofoilequivalentToKilotonnesOfTNT = 0.0014625733164;
    const double barrelsofoilequivalentToMegatonnesOfTNT = 1.4625733164e-6;
    const double barrelsofoilequivalentToErgs = 6.1194e+16;
    const double barrelsofoilequivalentToElectronvolt = 3.81942351e+28;
    const double barrelsofoilequivalentToKiloelectronvolt = 3.81942351e+25;
    const double barrelsofoilequivalentToMegaelectronvolt = 3.81942351e+22;
    const double barrelsofoilequivalentToGigaelectronvolt = 3.81942351e+19;

//TONS OF OIL EQUIVALENT
    const double tonnesofoilequivalentToNanojoules = 4.1868e+19;
    const double tonnesofoilequivalentToMicrojoules = 4.1868e+16;
    const double tonnesofoilequivalentToMillijoules = 4.1868e+13;
    const double tonnesofoilequivalentToJoules = 4.1868e+10;
    const double tonnesofoilequivalentToKilojoules = 4.1868e+7;
    const double tonnesofoilequivalentToMegajoules = 41868.0;
    const double tonnesofoilequivalentToNewtonMetres =
        4.1868e+10; // Newton-metres are equivalent to Joules.
    const double tonnesofoilequivalentToWattHours = 11630009.304;
    const double tonnesofoilequivalentToKilowattHours = 11630.009304;
    const double tonnesofoilequivalentToMegawattHours = 11.630009304;
    const double tonnesofoilequivalentToCalories = 1.0006703208e+10;
    const double tonnesofoilequivalentToKilocalories = 10006703.208;
    const double tonnesofoilequivalentToFootPoundsForce = 3.0880245816e+10;
    const double tonnesofoilequivalentToBritishThermalUnitsISO = 39683202.156;
    const double tonnesofoilequivalentToTherms = 396.83202156;
    const double tonnesofoilequivalentToHorsepowerHours = 15596.081208;
    const double tonnesofoilequivalentToBarrelsOfOilEquivalent = 6.843575808;
    const double tonnesofoilequivalentToTonnesOfOilEquivalent = 1.0; // Identity
    const double tonnesofoilequivalentToTonnesOfTNT = 10.006703208;
    const double tonnesofoilequivalentToKilotonnesOfTNT = 0.010006703208;
    const double tonnesofoilequivalentToMegatonnesOfTNT = 1.0006703208e-5;
    const double tonnesofoilequivalentToErgs = 4.1868e+17;
    const double tonnesofoilequivalentToElectronvolt = 2.61319122e+29;
    const double tonnesofoilequivalentToKiloelectronvolt = 2.61319122e+26;
    const double tonnesofoilequivalentToMegaelectronvolt = 2.61319122e+23;
    const double tonnesofoilequivalentToGigaelectronvolt = 2.61319122e+20;

//TONNES OF TNT
    const double tonnesofTNTToNanojoules = 4.184e+18;
    const double tonnesofTNTToMicrojoules = 4.184e+15;
    const double tonnesofTNTToMillijoules = 4.184e+12;
    const double tonnesofTNTToJoules = 4.184e+9;
    const double tonnesofTNTToKilojoules = 4.184e+6;
    const double tonnesofTNTToMegajoules = 4184.0;
    const double tonnesofTNTToNewtonMetres =
        4.184e+9; // Newton-metres are equivalent to Joules.
    const double tonnesofTNTToWattHours = 1162223.152;
    const double tonnesofTNTToKilowattHours = 1162.223152;
    const double tonnesofTNTToMegawattHours = 1.162223152;
    const double tonnesofTNTToCalories = 1e+9; // approximately
    const double tonnesofTNTToKilocalories = 1e+6; // approximately
    const double tonnesofTNTToFootPoundsForce = 3.085959408e+9;
    const double tonnesofTNTToBritishThermalUnitsISO = 3965666.328;
    const double tonnesofTNTToTherms = 39.65666328;
    const double tonnesofTNTToHorsepowerHours = 1558.565104;
    const double tonnesofTNTToBarrelsOfOilEquivalent = 0.683899904;
    const double tonnesofTNTToTonnesOfOilEquivalent = 0.0999331664;
    const double tonnesofTNTToKilotonnesOfTNT = 0.001;
    const double tonnesofTNTToMegatonnesOfTNT = 1e-6;
    const double tonnesofTNTToErgs = 4.184e+16;
    const double tonnesofTNTToElectronvolt = 2.6114436e+28;
    const double tonnesofTNTToKiloelectronvolt = 2.6114436e+25;
    const double tonnesofTNTToMegaelectronvolt = 2.6114436e+22;
    const double tonnesofTNTToGigaelectronvolt = 2.6114436e+19;

//KILOTONNES
    const double kilotonnesofTNTToNanojoules = 4.184e+21;
    const double kilotonnesofTNTToMicrojoules = 4.184e+18;
    const double kilotonnesofTNTToMillijoules = 4.184e+15;
    const double kilotonnesofTNTToJoules = 4.184e+12;
    const double kilotonnesofTNTToKilojoules = 4.184e+9;
    const double kilotonnesofTNTToMegajoules = 4.184e+6;
    const double kilotonnesofTNTToNewtonMetres =
        4.184e+12; // Newton-metres are equivalent to Joules.
    const double kilotonnesofTNTToWattHours = 1.162223152e+9;
    const double kilotonnesofTNTToKilowattHours = 1.162223152e+6;
    const double kilotonnesofTNTToMegawattHours = 1162.223152;
    const double kilotonnesofTNTToCalories = 1e+12; // approximately
    const double kilotonnesofTNTToKilocalories = 1e+9; // approximately
    const double kilotonnesofTNTToFootPoundsForce = 3.085959408e+12;
    const double kilotonnesofTNTToBritishThermalUnitsISO = 3.965666328e+9;
    const double kilotonnesofTNTToTherms = 39656.66328;
    const double kilotonnesofTNTToHorsepowerHours = 1.558565104e+6;
    const double kilotonnesofTNTToBarrelsOfOilEquivalent = 683.899904;
    const double kilotonnesofTNTToTonnesOfOilEquivalent = 99.9331664;
    const double kilotonnesofTNTToTonnesOfTNT = 1000.0;
    const double kilotonnesofTNTToMegatonnesOfTNT = 0.001;
    const double kilotonnesofTNTToErgs = 4.184e+19;
    const double kilotonnesofTNTToElectronvolt = 2.6114436e+31;
    const double kilotonnesofTNTToKiloelectronvolt = 2.6114436e+28;
    const double kilotonnesofTNTToMegaelectronvolt = 2.6114436e+25;
    const double kilotonnesofTNTToGigaelectronvolt = 2.6114436e+22;

//MEGATONNES OF TNT
    const double megatonnesofTNTToNanojoules = 4.184e+24;
    const double megatonnesofTNTToMicrojoules = 4.184e+21;
    const double megatonnesofTNTToMillijoules = 4.184e+18;
    const double megatonnesofTNTToJoules = 4.184e+15;
    const double megatonnesofTNTToKilojoules = 4.184e+12;
    const double megatonnesofTNTToMegajoules = 4.184e+9;
    const double megatonnesofTNTToNewtonMetres =
        4.184e+15; // Newton-metres are equivalent to Joules.
    const double megatonnesofTNTToWattHours = 1.162223152e+9;
    const double megatonnesofTNTToKilowattHours = 1.162223152e+6;
    const double megatonnesofTNTToMegawattHours = 1162.223152;
    const double megatonnesofTNTToCalories = 1e+15; // approximately
    const double megatonnesofTNTToKilocalories = 1e+12; // approximately
    const double megatonnesofTNTToFootPoundsForce = 3.085959408e+15;
    const double megatonnesofTNTToBritishThermalUnitsISO = 3.965666328e+12;
    const double megatonnesofTNTToTherms = 39656663.28;
    const double megatonnesofTNTToHorsepowerHours = 1.558565104e+9;
    const double megatonnesofTNTToBarrelsOfOilEquivalent = 683899.904;
    const double megatonnesofTNTToTonnesOfOilEquivalent = 99933.1664;
    const double megatonnesofTNTToTonnesOfTNT = 1e+6;
    const double megatonnesofTNTToKilotonnesOfTNT = 1000.0;
    const double megatonnesofTNTToErgs = 4.184e+22;
    const double megatonnesofTNTToElectronvolt = 2.6114436e+34;
    const double megatonnesofTNTToKiloelectronvolt = 2.6114436e+31;
    const double megatonnesofTNTToMegaelectronvolt = 2.6114436e+28;
    const double megatonnesofTNTToGigaelectronvolt = 2.6114436e+25;

//ERGS
    const double ergsToNanojoules = 100.0;
    const double ergsToMicrojoules = 0.1;
    const double ergsToMillijoules = 0.0001;
    const double ergsToJoules = 1e-7;
    const double ergsToKilojoules = 1e-10;
    const double ergsToMegajoules = 1e-13;
    const double ergsToNewtonMetres =
        1e-7; // Newton-metres are equivalent to Joules.
    const double ergsToWattHours = 2.77778e-11;
    const double ergsToKilowattHours = 2.77778e-14;
    const double ergsToMegawattHours = 2.77778e-17;
    const double ergsToCalories = 2.39006e-8;
    const double ergsToKilocalories = 2.39006e-11;
    const double ergsToFootPoundsForce = 7.37562e-8;
    const double ergsToBritishThermalUnitsISO = 9.47817e-11;
    const double ergsToTherms = 9.47817e-16;
    const double ergsToHorsepowerHours = 3.72506e-14;
    const double ergsToBarrelsOfOilEquivalent = 1.63456e-17;
    const double ergsToTonnesOfOilEquivalent = 2.38846e-18;
    const double ergsToTonnesOfTNT = 2.39006e-17;
    const double ergsToKilotonnesOfTNT = 2.39006e-20;
    const double ergsToMegatonnesOfTNT = 2.39006e-23;

    const double ergsToElectronvolt = 6.2415e+11;
    const double ergsToKiloelectronvolt = 6.2415e+8;
    const double ergsToMegaelectronvolt = 624150.0;
    const double ergsToGigaelectronvolt = 624.15;

//ELECTRONVOLT
    const double electronvoltToNanojoules = 1.60218e-10;
    const double electronvoltToMicrojoules = 1.60218e-13;
    const double electronvoltToMillijoules = 1.60218e-16;
    const double electronvoltToJoules = 1.60218e-19;
    const double electronvoltToKilojoules = 1.60218e-22;
    const double electronvoltToMegajoules = 1.60218e-25;
    const double electronvoltToNewtonMetres =
        1.60218e-19; // Newton-metres are equivalent to Joules.
    const double electronvoltToWattHours = 4.4505e-23;
    const double electronvoltToKilowattHours = 4.4505e-26;
    const double electronvoltToMegawattHours = 4.4505e-29;
    const double electronvoltToCalories = 3.8293e-20;
    const double electronvoltToKilocalories = 3.8293e-23;
    const double electronvoltToFootPoundsForce = 1.1817e-19;
    const double electronvoltToBritishThermalUnitsISO = 1.51857e-22;
    const double electronvoltToTherms = 1.51857e-27;
    const double electronvoltToHorsepowerHours = 5.9682e-26;
    const double electronvoltToBarrelsOfOilEquivalent = 2.6188e-29;
    const double electronvoltToTonnesOfOilEquivalent = 3.8267e-30;
    const double electronvoltToTonnesOfTNT = 3.8293e-29;
    const double electronvoltToKilotonnesOfTNT = 3.8293e-32;
    const double electronvoltToMegatonnesOfTNT = 3.8293e-35;
    const double electronvoltToErgs = 1.60218e-12;

//KILOELECTRONVOLT
    const double kiloelectronvoltToNanojoules = 1.60218e-7;
    const double kiloelectronvoltToMicrojoules = 1.60218e-10;
    const double kiloelectronvoltToMillijoules = 1.60218e-13;
    const double kiloelectronvoltToJoules = 1.60218e-16;
    const double kiloelectronvoltToKilojoules = 1.60218e-19;
    const double kiloelectronvoltToMegajoules = 1.60218e-22;
    const double kiloelectronvoltToNewtonMetres =
        1.60218e-16; // Newton-metres are equivalent to Joules.
    const double kiloelectronvoltToWattHours = 4.4505e-20;
    const double kiloelectronvoltToKilowattHours = 4.4505e-23;
    const double kiloelectronvoltToMegawattHours = 4.4505e-26;
    const double kiloelectronvoltToCalories = 3.8293e-17;
    const double kiloelectronvoltToKilocalories = 3.8293e-20;
    const double kiloelectronvoltToFootPoundsForce = 1.1817e-16;
    const double kiloelectronvoltToBritishThermalUnitsISO = 1.51857e-19;
    const double kiloelectronvoltToTherms = 1.51857e-24;
    const double kiloelectronvoltToHorsepowerHours = 5.9682e-23;
    const double kiloelectronvoltToBarrelsOfOilEquivalent = 2.6188e-26;
    const double kiloelectronvoltToTonnesOfOilEquivalent = 3.8267e-27;
    const double kiloelectronvoltToTonnesOfTNT = 3.8293e-26;
    const double kiloelectronvoltToKilotonnesOfTNT = 3.8293e-29;
    const double kiloelectronvoltToMegatonnesOfTNT = 3.8293e-32;
    const double kiloelectronvoltToErgs = 1.60218e-9;

//MEGAELECTRONVOLT
    const double megaelectronvoltToNanojoules = 0.000160218;
    const double megaelectronvoltToMicrojoules = 1.60218e-7;
    const double megaelectronvoltToMillijoules = 1.60218e-10;
    const double megaelectronvoltToJoules = 1.60218e-13;
    const double megaelectronvoltToKilojoules = 1.60218e-16;
    const double megaelectronvoltToMegajoules = 1.60218e-19;
    const double megaelectronvoltToNewtonMetres =
        1.60218e-13; // Newton-metres are equivalent to Joules.
    const double megaelectronvoltToWattHours = 4.4505e-17;
    const double megaelectronvoltToKilowattHours = 4.4505e-20;
    const double megaelectronvoltToMegawattHours = 4.4505e-23;
    const double megaelectronvoltToCalories = 3.8293e-14;
    const double megaelectronvoltToKilocalories = 3.8293e-17;
    const double megaelectronvoltToFootPoundsForce = 1.1817e-13;
    const double megaelectronvoltToBritishThermalUnitsISO = 1.51857e-16;
    const double megaelectronvoltToTherms = 1.51857e-21;
    const double megaelectronvoltToHorsepowerHours = 5.9682e-20;
    const double megaelectronvoltToBarrelsOfOilEquivalent = 2.6188e-23;
    const double megaelectronvoltToTonnesOfOilEquivalent = 3.8267e-24;
    const double megaelectronvoltToTonnesOfTNT = 3.8293e-23;
    const double megaelectronvoltToKilotonnesOfTNT = 3.8293e-26;
    const double megaelectronvoltToMegatonnesOfTNT = 3.8293e-29;
    const double megaelectronvoltToErgs = 1.60218e-6;

//GIGAELECTRONVOLT
    const double gigaelectronvoltToNanojoules = 0.160218;
    const double gigaelectronvoltToMicrojoules = 0.000160218;
    const double gigaelectronvoltToMillijoules = 1.60218e-7;
    const double gigaelectronvoltToJoules = 1.60218e-10;
    const double gigaelectronvoltToKilojoules = 1.60218e-13;
    const double gigaelectronvoltToMegajoules = 1.60218e-16;
    const double gigaelectronvoltToNewtonMetres =
        1.60218e-10; // Newton-metres are equivalent to Joules.
    const double gigaelectronvoltToWattHours = 4.4505e-14;
    const double gigaelectronvoltToKilowattHours = 4.4505e-17;
    const double gigaelectronvoltToMegawattHours = 4.4505e-20;
    const double gigaelectronvoltToCalories = 3.8293e-11;
    const double gigaelectronvoltToKilocalories = 3.8293e-14;
    const double gigaelectronvoltToFootPoundsForce = 1.1817e-10;
    const double gigaelectronvoltToBritishThermalUnitsISO = 1.51857e-13;
    const double gigaelectronvoltToTherms = 1.51857e-18;
    const double gigaelectronvoltToHorsepowerHours = 5.9682e-17;
    const double gigaelectronvoltToBarrelsOfOilEquivalent = 2.6188e-20;
    const double gigaelectronvoltToTonnesOfOilEquivalent = 3.8267e-21;
    const double gigaelectronvoltToTonnesOfTNT = 3.8293e-20;
    const double gigaelectronvoltToKilotonnesOfTNT = 3.8293e-23;
    const double gigaelectronvoltToMegatonnesOfTNT = 3.8293e-26;
    const double gigaelectronvoltToErgs = 1.60218e-3;

    switch (fromUnit) {
//NANOJOULES
      case 'Nanojoules':
        switch (toUnit) {
          case 'Nanojoules':
            toValue = fromValue;
            break;
          case 'Microjoules':
            toValue = fromValue * nanojoulesToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * nanojoulesToMillijoules;
            break;
          case 'Joules':
            toValue = fromValue * nanojoulesToJoules;
            break;
          case 'Kilojoules':
            toValue = fromValue * nanojoulesToKilojoules;
            break;
          case 'Megajoules':
            toValue = fromValue * nanojoulesToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * nanojoulesToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * nanojoulesToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * nanojoulesToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * nanojoulesToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * nanojoulesToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * nanojoulesToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * nanojoulesToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * nanojoulesToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * nanojoulesToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * nanojoulesToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * nanojoulesToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * nanojoulesToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * nanojoulesToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * nanojoulesToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * nanojoulesToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * nanojoulesToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * nanojoulesToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * nanojoulesToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * nanojoulesToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * nanojoulesToGigaelectronvolt;
            break;
          default:
            throw 'Unknown unit: $toUnit';
        }
        break;

//MICROJOULES
      case 'Microjoules':
        switch (toUnit) {
          case 'Microjoules':
            toValue = fromValue;
            break;

          case 'Nanojoules':
            toValue = fromValue * microjoulesToNanojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * microjoulesToMillijoules;
            break;
          case 'Joules':
            toValue = fromValue * microjoulesToJoules;
            break;
          case 'Kilojoules':
            toValue = fromValue * microjoulesToKilojoules;
            break;
          case 'Megajoules':
            toValue = fromValue * microjoulesToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * microjoulesToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * microjoulesToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * microjoulesToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * microjoulesToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * microjoulesToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * microjoulesToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * microjoulesToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * microjoulesToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * microjoulesToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * microjoulesToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * microjoulesToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * microjoulesToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * microjoulesToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * microjoulesToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * microjoulesToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * microjoulesToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * microjoulesToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * microjoulesToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * microjoulesToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * microjoulesToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//MILLIJOULES
      case 'Millijoules':
        switch (toUnit) {
          case 'Millijoules':
            toValue = fromValue;
            break;

          case 'Nanojoules':
            toValue = fromValue * millijoulesToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * millijoulesToMicrojoules;
            break;
          case 'Joules':
            toValue = fromValue * millijoulesToJoules;
            break;
          case 'Kilojoules':
            toValue = fromValue * millijoulesToKilojoules;
            break;
          case 'Megajoules':
            toValue = fromValue * millijoulesToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * millijoulesToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * millijoulesToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * millijoulesToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * millijoulesToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * millijoulesToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * millijoulesToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * millijoulesToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * millijoulesToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * millijoulesToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * millijoulesToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * millijoulesToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * millijoulesToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * millijoulesToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * millijoulesToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * millijoulesToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * millijoulesToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * millijoulesToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * millijoulesToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * millijoulesToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * millijoulesToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//JOULES
      case 'Joules':
        switch (toUnit) {
          case 'Joules':
            toValue = fromValue;
            break;
          case 'Nanojoules':
            toValue = fromValue * joulesToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * joulesToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * joulesToMillijoules;
            break;
          case 'Joules':
            toValue = fromValue *
                joulesToJoules; // This is redundant but keeps the structure consistent
            break;
          case 'Kilojoules':
            toValue = fromValue * joulesToKilojoules;
            break;
          case 'Megajoules':
            toValue = fromValue * joulesToMegajoules;
            break;
          case 'Newton-metres':
            toValue =
                fromValue * joulesToNewtonMetres; // This is also redundant
            break;
          case 'Watt-hours':
            toValue = fromValue * joulesToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * joulesToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * joulesToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * joulesToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * joulesToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * joulesToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * joulesToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * joulesToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * joulesToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * joulesToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * joulesToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * joulesToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * joulesToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * joulesToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * joulesToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * joulesToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * joulesToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * joulesToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * joulesToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//KILOJOULES
      case 'Kilojoules':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue;
            break;

          case 'Joules':
            toValue = fromValue * kilojoulesToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * kilojoulesToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * kilojoulesToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * kilojoulesToMillijoules;
            break;
          case 'Joules':
            toValue = fromValue * kilojoulesToJoules;
            break;
          case 'Megajoules':
            toValue = fromValue * kilojoulesToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * kilojoulesToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * kilojoulesToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * kilojoulesToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * kilojoulesToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * kilojoulesToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * kilojoulesToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * kilojoulesToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * kilojoulesToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * kilojoulesToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * kilojoulesToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * kilojoulesToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * kilojoulesToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * kilojoulesToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * kilojoulesToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * kilojoulesToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * kilojoulesToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * kilojoulesToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * kilojoulesToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * kilojoulesToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * kilojoulesToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//MEGAJOULES
      case 'Megajoules':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * megajoulesToKilojoules;
            break;

          case 'Joules':
            toValue = fromValue * megajoulesToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * megajoulesToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * megajoulesToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * megajoulesToMillijoules;
            break;
          case 'Joules':
            toValue = fromValue * megajoulesToJoules;
            break;
          case 'Megajoules':
            toValue = fromValue;
            break;
          case 'Newton-metres':
            toValue = fromValue * megajoulesToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * megajoulesToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * megajoulesToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * megajoulesToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * megajoulesToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * megajoulesToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * megajoulesToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * megajoulesToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * megajoulesToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * megajoulesToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * megajoulesToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * megajoulesToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * megajoulesToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * megajoulesToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * megajoulesToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * megajoulesToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * megajoulesToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * megajoulesToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * megajoulesToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * megajoulesToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//NEWTON METRES
      case 'Newton-metres':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * newtonmetresToKilojoules;
            break;

          case 'Joules':
            toValue = fromValue * newtonmetresToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * newtonmetresToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * newtonmetresToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * newtonmetresToMillijoules;
            break;
          case 'Joules':
            toValue = fromValue * newtonmetresToJoules;
            break;
          case 'Megajoules':
            toValue = fromValue * newtonmetresToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue;
            break;
          case 'Watt-hours':
            toValue = fromValue * newtonmetresToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * newtonmetresToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * newtonmetresToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * newtonmetresToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * newtonmetresToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * newtonmetresToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * newtonmetresToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * newtonmetresToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * newtonmetresToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * newtonmetresToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * newtonmetresToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * newtonmetresToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * newtonmetresToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * newtonmetresToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * newtonmetresToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * newtonmetresToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * newtonmetresToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * newtonmetresToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * newtonmetresToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//WATTHOURS
      case 'Watt-hours':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * watthoursToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * watthoursToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * watthoursToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * watthoursToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * watthoursToMillijoules;
            break;
          case 'Joules':
            toValue = fromValue * watthoursToJoules;
            break;
          case 'Megajoules':
            toValue = fromValue * watthoursToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * watthoursToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * watthoursToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * watthoursToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * watthoursToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * watthoursToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * watthoursToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * watthoursToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * watthoursToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * watthoursToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * watthoursToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * watthoursToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * watthoursToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * watthoursToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * watthoursToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * watthoursToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * watthoursToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * watthoursToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * watthoursToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * watthoursToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//KILOWATT HOURS
      case 'Kilowatt-hours':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * kilowatthoursToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * kilowatthoursToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * kilowatthoursToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * kilowatthoursToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * kilowatthoursToMillijoules;
            break;
          case 'Joules':
            toValue = fromValue * kilowatthoursToJoules;
            break;
          case 'Megajoules':
            toValue = fromValue * kilowatthoursToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * kilowatthoursToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * kilowatthoursToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * kilowatthoursToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * kilowatthoursToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * kilowatthoursToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * kilowatthoursToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * kilowatthoursToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * kilowatthoursToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * kilowatthoursToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * kilowatthoursToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * kilowatthoursToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * kilowatthoursToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * kilowatthoursToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * kilowatthoursToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * kilowatthoursToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * kilowatthoursToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * kilowatthoursToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * kilowatthoursToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * kilowatthoursToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
//MEGAWATT HOURS
      case 'Megawatt-hours':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * megawatthoursToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * megawatthoursToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * megawatthoursToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * megawatthoursToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * megawatthoursToMillijoules;
            break;
          case 'Joules':
            toValue = fromValue * megawatthoursToJoules;
            break;
          case 'Megajoules':
            toValue = fromValue * megawatthoursToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * megawatthoursToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * megawatthoursToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * megawatthoursToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * megawatthoursToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * megawatthoursToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * megawatthoursToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * megawatthoursToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * megawatthoursToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * megawatthoursToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * megawatthoursToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * megawatthoursToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * megawatthoursToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * megawatthoursToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * megawatthoursToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * megawatthoursToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * megawatthoursToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * megawatthoursToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * megawatthoursToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * megawatthoursToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * megawatthoursToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//CALORIES
      case 'Calories':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * caloriesToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * caloriesToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * caloriesToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * caloriesToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * caloriesToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * caloriesToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * caloriesToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * caloriesToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * caloriesToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * caloriesToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue;
            break;
          case 'Kilocalories':
            toValue = fromValue * caloriesToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * caloriesToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * caloriesToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * caloriesToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * caloriesToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * caloriesToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * caloriesToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * caloriesToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * caloriesToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * caloriesToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * caloriesToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * caloriesToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * caloriesToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * caloriesToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * caloriesToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//KILOCALORIES
      case 'Kilocalories':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * kilocaloriesToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * kilocaloriesToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * kilocaloriesToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * kilocaloriesToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * kilocaloriesToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * kilocaloriesToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * kilocaloriesToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * kilocaloriesToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * kilocaloriesToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * kilocaloriesToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * kilocaloriesToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * kilocaloriesToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * kilocaloriesToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * kilocaloriesToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * kilocaloriesToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * kilocaloriesToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * kilocaloriesToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * kilocaloriesToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * kilocaloriesToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * kilocaloriesToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * kilocaloriesToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * kilocaloriesToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * kilocaloriesToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * kilocaloriesToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * kilocaloriesToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//FOOTPOUNDS FORCE
      case 'Foot-pounds Force':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * footpoundsforceToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * footpoundsforceToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * footpoundsforceToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * footpoundsforceToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * footpoundsforceToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * footpoundsforceToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * footpoundsforceToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * footpoundsforceToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * footpoundsforceToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * footpoundsforceToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * footpoundsforceToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * footpoundsforceToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * footpoundsforceToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * footpoundsforceToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * footpoundsforceToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * footpoundsforceToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * footpoundsforceToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * footpoundsforceToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * footpoundsforceToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * footpoundsforceToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * footpoundsforceToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * footpoundsforceToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * footpoundsforceToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * footpoundsforceToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * footpoundsforceToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * footpoundsforceToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//BRITISH THERMAL UNITS ISO
      case 'British Thermal Units (ISO)':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * britishthermalunitsISOTOkilojoules;
            break;
          case 'Joules':
            toValue = fromValue * britishthermalunitsISOTOjoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * britishthermalunitsISOTOnanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * britishthermalunitsISOTOmicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * britishthermalunitsISOTOmillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * footpoundsforceToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * britishthermalunitsISOTONewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * britishthermalunitsISOTOWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * britishthermalunitsISOTOKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * britishthermalunitsISOTOMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * britishthermalunitsISOTOCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * britishthermalunitsISOTOKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * britishthermalunitsISOTOFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue;
            break;
          case 'Therms':
            toValue = fromValue * britishthermalunitsISOTOtherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * britishthermalunitsISOTOHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue =
                fromValue * britishthermalunitsISOTOBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * britishthermalunitsISOTOTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * britishthermalunitsISOTOTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * britishthermalunitsISOTOKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * britishthermalunitsISOTOMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * britishthermalunitsISOTOErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * britishthermalunitsISOTOElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * britishthermalunitsISOTOKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * britishthermalunitsISOTOMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * britishthermalunitsISOTOGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//THERMS
      case 'Therms':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * thermsToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * thermsToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * thermsToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * thermsToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * thermsToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * thermsToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * thermsToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * thermsToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * thermsToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * thermsToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * thermsToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * thermsToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * thermsToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * thermsToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * thermsToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * thermsToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * thermsToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * thermsToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * thermsToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * thermsToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * thermsToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * thermsToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * thermsToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * thermsToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * thermsToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//HORSEPOWER HOURS
      case 'Horsepower Hours':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * horsepowerhoursToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * horsepowerhoursToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * horsepowerhoursToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * horsepowerhoursToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * horsepowerhoursToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * horsepowerhoursToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * horsepowerhoursToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * horsepowerhoursToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * horsepowerhoursToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * horsepowerhoursToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * horsepowerhoursToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * horsepowerhoursToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * horsepowerhoursToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * horsepowerhoursToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * horsepowerhoursToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * horsepowerhoursToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * horsepowerhoursToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * horsepowerhoursToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * horsepowerhoursToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * horsepowerhoursToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * horsepowerhoursToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * horsepowerhoursToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * horsepowerhoursToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * horsepowerhoursToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * horsepowerhoursToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * horsepowerhoursToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//BARRELS OF OIL EQUIVALENT
      case 'Barrels of Oil Equivalent':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * barrelsofoilequivalentToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * barrelsofoilequivalentToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * barrelsofoilequivalentToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * barrelsofoilequivalentToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * barrelsofoilequivalentToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * barrelsofoilequivalentToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * barrelsofoilequivalentToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * barrelsofoilequivalentToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * barrelsofoilequivalentToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * barrelsofoilequivalentToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * barrelsofoilequivalentToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * barrelsofoilequivalentToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * barrelsofoilequivalentToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue =
                fromValue * barrelsofoilequivalentToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * barrelsofoilequivalentToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * barrelsofoilequivalentToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * barrelsofoilequivalentToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * barrelsofoilequivalentToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * barrelsofoilequivalentToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * barrelsofoilequivalentToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * barrelsofoilequivalentToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * barrelsofoilequivalentToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * barrelsofoilequivalentToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * barrelsofoilequivalentToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * barrelsofoilequivalentToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//TONS OF OIL EQUIVALENT
      case 'Tonnes of Oil Equivalent':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * tonnesofoilequivalentToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * tonnesofoilequivalentToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * tonnesofoilequivalentToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * tonnesofoilequivalentToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * tonnesofoilequivalentToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * tonnesofoilequivalentToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * tonnesofoilequivalentToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * tonnesofoilequivalentToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * tonnesofoilequivalentToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * tonnesofoilequivalentToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * tonnesofoilequivalentToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * tonnesofoilequivalentToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * tonnesofoilequivalentToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * tonnesofoilequivalentToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * tonnesofoilequivalentToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * tonnesofoilequivalentToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * tonnesofoilequivalentToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * tonnesofoilequivalentToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * tonnesofoilequivalentToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * tonnesofoilequivalentToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * tonnesofoilequivalentToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * tonnesofoilequivalentToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * tonnesofoilequivalentToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * tonnesofoilequivalentToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * tonnesofoilequivalentToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * tonnesofoilequivalentToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//TONNES OF TNT
      case 'Tonnes of TNT':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * tonnesofTNTToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * tonnesofTNTToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * tonnesofTNTToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * tonnesofTNTToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * tonnesofTNTToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * tonnesofTNTToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * tonnesofTNTToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * tonnesofTNTToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * tonnesofTNTToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * tonnesofTNTToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * tonnesofTNTToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * tonnesofTNTToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * tonnesofTNTToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * tonnesofTNTToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * tonnesofTNTToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * tonnesofTNTToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * tonnesofTNTToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * tonnesofTNTToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * tonnesofTNTToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * tonnesofTNTToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * tonnesofTNTToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * tonnesofTNTToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * tonnesofTNTToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * tonnesofTNTToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * tonnesofTNTToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//KILOTONNES
      case 'Kilotonnes of TNT':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * kilotonnesofTNTToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * kilotonnesofTNTToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * kilotonnesofTNTToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * kilotonnesofTNTToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * kilotonnesofTNTToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * kilotonnesofTNTToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * kilotonnesofTNTToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * kilotonnesofTNTToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * kilotonnesofTNTToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * kilotonnesofTNTToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * kilotonnesofTNTToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * kilotonnesofTNTToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * kilotonnesofTNTToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * kilotonnesofTNTToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * kilotonnesofTNTToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * kilotonnesofTNTToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * kilotonnesofTNTToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * kilotonnesofTNTToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * kilotonnesofTNTToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * kilotonnesofTNTToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * kilotonnesofTNTToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * kilotonnesofTNTToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * kilotonnesofTNTToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * kilotonnesofTNTToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * kilotonnesofTNTToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//MEGATONNES OF TNT
      case 'Megatonnes of TNT':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * megatonnesofTNTToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * megatonnesofTNTToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * megatonnesofTNTToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * megatonnesofTNTToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * megatonnesofTNTToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * megatonnesofTNTToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * megatonnesofTNTToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * megatonnesofTNTToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * megatonnesofTNTToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * megatonnesofTNTToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * megatonnesofTNTToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * megatonnesofTNTToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * megatonnesofTNTToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * megatonnesofTNTToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * megatonnesofTNTToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * megatonnesofTNTToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * megatonnesofTNTToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * megatonnesofTNTToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * megatonnesofTNTToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * megatonnesofTNTToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue;
            break;
          case 'Ergs':
            toValue = fromValue * megatonnesofTNTToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * megatonnesofTNTToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * megatonnesofTNTToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * megatonnesofTNTToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * megatonnesofTNTToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//ERGS
      case 'Ergs':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * ergsToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * ergsToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * ergsToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * ergsToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * ergsToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * ergsToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * ergsToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * ergsToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * ergsToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * ergsToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * ergsToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * ergsToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * ergsToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * ergsToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * ergsToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * ergsToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * ergsToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * ergsToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * ergsToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * ergsToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * ergsToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue;
            break;
          case 'Electronvolt':
            toValue = fromValue * ergsToElectronvolt;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * ergsToKiloelectronvolt;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * ergsToMegaelectronvolt;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * ergsToGigaelectronvolt;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//ELECTRONVOLT
      case 'Electronvolt':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * electronvoltToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * electronvoltToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * electronvoltToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * electronvoltToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * electronvoltToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * electronvoltToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * electronvoltToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * electronvoltToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * electronvoltToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * electronvoltToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * electronvoltToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * electronvoltToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * electronvoltToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * electronvoltToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * electronvoltToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * electronvoltToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * electronvoltToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * electronvoltToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * electronvoltToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * electronvoltToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * electronvoltToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * electronvoltToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue / 1000;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * 0.000001;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue / 1000000000;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//KILOELECTRONVOLT
      case 'Kiloelectronvolt':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * kiloelectronvoltToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * kiloelectronvoltToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * kiloelectronvoltToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * kiloelectronvoltToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * kiloelectronvoltToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * kiloelectronvoltToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * kiloelectronvoltToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * kiloelectronvoltToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * kiloelectronvoltToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * kiloelectronvoltToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * kiloelectronvoltToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * kiloelectronvoltToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * kiloelectronvoltToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * kiloelectronvoltToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * kiloelectronvoltToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * kiloelectronvoltToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * kiloelectronvoltToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * kiloelectronvoltToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * kiloelectronvoltToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * kiloelectronvoltToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * kiloelectronvoltToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * kiloelectronvoltToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * 1000;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue / 1000;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * 0.000001;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
//MEGAELECTRONVOLT
      case 'Megaelectronvolt':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * megaelectronvoltToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * megaelectronvoltToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * megaelectronvoltToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * megaelectronvoltToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * megaelectronvoltToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * megaelectronvoltToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * megaelectronvoltToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * megaelectronvoltToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * megaelectronvoltToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * megaelectronvoltToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * megaelectronvoltToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * megaelectronvoltToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * megaelectronvoltToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * megaelectronvoltToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * megaelectronvoltToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * megaelectronvoltToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * megaelectronvoltToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * megaelectronvoltToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * megaelectronvoltToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * megaelectronvoltToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * megaelectronvoltToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * megaelectronvoltToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * 1000000;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * 1000;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue * 0.001;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }

//GIGAELECTRONVOLT
      case 'Gigaelectronvolt':
        switch (toUnit) {
          case 'Kilojoules':
            toValue = fromValue * gigaelectronvoltToKilojoules;
            break;
          case 'Joules':
            toValue = fromValue * gigaelectronvoltToJoules;
            break;
          case 'Nanojoules':
            toValue = fromValue * gigaelectronvoltToNanojoules;
            break;
          case 'Microjoules':
            toValue = fromValue * gigaelectronvoltToMicrojoules;
            break;
          case 'Millijoules':
            toValue = fromValue * gigaelectronvoltToMillijoules;
            break;
          case 'Megajoules':
            toValue = fromValue * gigaelectronvoltToMegajoules;
            break;
          case 'Newton-metres':
            toValue = fromValue * gigaelectronvoltToNewtonMetres;
            break;
          case 'Watt-hours':
            toValue = fromValue * gigaelectronvoltToWattHours;
            break;
          case 'Kilowatt-hours':
            toValue = fromValue * gigaelectronvoltToKilowattHours;
            break;
          case 'Megawatt-hours':
            toValue = fromValue * gigaelectronvoltToMegawattHours;
            break;
          case 'Calories':
            toValue = fromValue * gigaelectronvoltToCalories;
            break;
          case 'Kilocalories':
            toValue = fromValue * gigaelectronvoltToKilocalories;
            break;
          case 'Foot-pounds Force':
            toValue = fromValue * gigaelectronvoltToFootPoundsForce;
            break;
          case 'British Thermal Units (ISO)':
            toValue = fromValue * gigaelectronvoltToBritishThermalUnitsISO;
            break;
          case 'Therms':
            toValue = fromValue * gigaelectronvoltToTherms;
            break;
          case 'Horsepower Hours':
            toValue = fromValue * gigaelectronvoltToHorsepowerHours;
            break;
          case 'Barrels of Oil Equivalent':
            toValue = fromValue * gigaelectronvoltToBarrelsOfOilEquivalent;
            break;
          case 'Tonnes of Oil Equivalent':
            toValue = fromValue * gigaelectronvoltToTonnesOfOilEquivalent;
            break;
          case 'Tonnes of TNT':
            toValue = fromValue * gigaelectronvoltToTonnesOfTNT;
            break;
          case 'Kilotonnes of TNT':
            toValue = fromValue * gigaelectronvoltToKilotonnesOfTNT;
            break;
          case 'Megatonnes of TNT':
            toValue = fromValue * gigaelectronvoltToMegatonnesOfTNT;
            break;
          case 'Ergs':
            toValue = fromValue * gigaelectronvoltToErgs;
            break;
          case 'Electronvolt':
            toValue = fromValue * 1000000000;
            break;
          case 'Kiloelectronvolt':
            toValue = fromValue * 1000000;
            break;
          case 'Megaelectronvolt':
            toValue = fromValue * 1000;
            break;
          case 'Gigaelectronvolt':
            toValue = fromValue;
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
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
//NANOJOULES
      case 'Nanojoules':
        switch (toUnit) {
          case 'Nanojoules':
            formula = 'The value remains unchanged';
            break;
          case 'Microjoules':
            formula = 'Divide the energy value by 1e-3';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1e-6';
            break;
          case 'Joules':
            formula = 'Divide the energy value by 1e-9';
            break;
          case 'Kilojoules':
            formula = 'Divide the energy value by 1e-12';
            break;
          case 'Megajoules':
            formula = 'Divide the energy value by 1e-15';
            break;
          case 'Newton-metres':
            formula = 'Divide the energy value by 1e-9';
            break;
          case 'Watt-hours':
            formula = 'Divide the energy value by 3.6e+12';
            break;
          case 'Kilowatt-hours':
            formula = 'Divide the energy value by 3.6e+15';
            break;
          case 'Megawatt-hours':
            formula = 'Divide the energy value by 3.6e+18';
            break;
          case 'Calories':
            formula = 'Divide the energy value by 4.184e+9';
            break;
          case 'Kilocalories':
            formula = 'Divide the energy value by 4.184e+12';
            break;
          case 'Foot-pounds Force':
            formula = 'Divide the energy value by 1.356e+6';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Divide the energy value by 1.055e+9';
            break;
          case 'Therms':
            formula = 'Divide the energy value by 1.055e+14';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 3.7250614122937e-16';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Divide the energy value by 6.118e+18';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Divide the energy value by 4.187e+19';
            break;
          case 'Tonnes of TNT':
            formula = 'Divide the energy value by 4.184e+18';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Divide the energy value by 4.184e+21';
            break;
          case 'Megatonnes of TNT':
            formula = 'Divide the energy value by 4.184e+24';
            break;
          case 'Ergs':
            formula = 'Divide the energy value by 100';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+9';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.241509074461e+6';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+6';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.24151e+6';
            break;
          default:
            throw 'Unknown formula: $toUnit';
        }
        break;
      // Add cases for other units here.

      case 'Microjoules':
        switch (toUnit) {
          case 'Microjoules':
            formula = 'The value remains unchanged';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Millijoules':
            formula = 'Divide the energy value by 1000';
            break;
          case 'Joules':
            formula = 'Divide the energy value by 1e-6';
            break;
          case 'Kilojoules':
            formula = 'Divide the energy value by 1e-9';
            break;
          case 'Megajoules':
            formula = 'Divide the energy value by 1e-12';
            break;
          case 'Newton-metres':
            formula = 'Divide the energy value by 1e-6';
            break;
          case 'Watt-hours':
            formula = 'Divide the energy value by 3.6e+9';
            break;
          case 'Kilowatt-hours':
            formula = 'Divide the energy value by 3.6e+12';
            break;
          case 'Megawatt-hours':
            formula = 'Divide the energy value by 3.6e+15';
            break;
          case 'Calories':
            formula = 'Divide the energy value by 4.184e+6';
            break;
          case 'Kilocalories':
            formula = 'Divide the energy value by 4.184e+9';
            break;
          case 'Foot-pounds Force':
            formula = 'Divide the energy value by 1.356e+3';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Divide the energy value by 1.055e+6';
            break;
          case 'Therms':
            formula = 'Divide the energy value by 1.055e+11';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 3.7250614122937e-10';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Divide the energy value by 6.118e+15';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Divide the energy value by 4.187e+16';
            break;
          case 'Tonnes of TNT':
            formula = 'Divide the energy value by 4.184e+15';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Divide the energy value by 4.184e+18';
            break;
          case 'Megatonnes of TNT':
            formula = 'Divide the energy value by 4.184e+21';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 10^7';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+12';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+9';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+6';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+3';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// MILLIJOULES
      case 'Millijoules':
        switch (toUnit) {
          case 'Millijoules':
            formula = 'The value remains unchanged';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Joules':
            formula = 'Divide the energy value by 1000';
            break;
          case 'Kilojoules':
            formula = 'Divide the energy value by 1e+6';
            break;
          case 'Megajoules':
            formula = 'Divide the energy value by 1e+9';
            break;
          case 'Newton-metres':
            formula = 'Divide the energy value by 1000';
            break;
          case 'Watt-hours':
            formula = 'Divide the energy value by 3.6e+6';
            break;
          case 'Kilowatt-hours':
            formula = 'Divide the energy value by 3.6e+9';
            break;
          case 'Megawatt-hours':
            formula = 'Divide the energy value by 3.6e+12';
            break;
          case 'Calories':
            formula = 'Divide the energy value by 4184';
            break;
          case 'Kilocalories':
            formula = 'Divide the energy value by 4.184e+6';
            break;
          case 'Foot-pounds Force':
            formula = 'Divide the energy value by 1356';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Divide the energy value by 1055';
            break;
          case 'Therms':
            formula = 'Divide the energy value by 1.055e+8';
            break;
          case 'Horsepower Hours':
            formula = 'Divide the energy value by 2.68452e+9';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Divide the energy value by 6.118e+12';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Divide the energy value by 4.187e+13';
            break;
          case 'Tonnes of TNT':
            formula = 'Divide the energy value by 4.184e+12';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Divide the energy value by 4.184e+15';
            break;
          case 'Megatonnes of TNT':
            formula = 'Divide the energy value by 4.184e+18';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 10^10';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+15';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+12';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+9';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+6';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// JOULES
      case 'Joules':
        switch (toUnit) {
          case 'Joules':
            formula = 'The value remains unchanged';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1e+9';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Kilojoules':
            formula = 'Divide the energy value by 1000';
            break;
          case 'Megajoules':
            formula = 'Divide the energy value by 1e+6';
            break;
          case 'Newton-metres':
            formula = 'The value remains unchanged';
            break;
          case 'Watt-hours':
            formula = 'Divide the energy value by 3600';
            break;
          case 'Kilowatt-hours':
            formula = 'Divide the energy value by 3.6e+6';
            break;
          case 'Megawatt-hours':
            formula = 'Divide the energy value by 3.6e+9';
            break;
          case 'Calories':
            formula = 'Divide the energy value by 4184';
            break;
          case 'Kilocalories':
            formula = 'Divide the energy value by 4.184e+6';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 0.737562149277';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Divide the energy value by 1055.06';
            break;
          case 'Therms':
            formula = 'Divide the energy value by 105506000';
            break;
          case 'Horsepower Hours':
            formula = 'Divide the energy value by 2.685e+6';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Divide the energy value by 6.12e+9';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Divide the energy value by 4.187e+10';
            break;
          case 'Tonnes of TNT':
            formula = 'Divide the energy value by 4.184e+9';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Divide the energy value by 4.184e+12';
            break;
          case 'Megatonnes of TNT':
            formula = 'Divide the energy value by 4.184e+15';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 10^7';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+12';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+9';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+6';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+3';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOJOULES
      case 'Kilojoules':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'The value remains unchanged';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1e+3';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Megajoules':
            formula = 'Divide the energy value by 1000';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Watt-hours':
            formula = 'Divide the energy value by 3.6e+6';
            break;
          case 'Kilowatt-hours':
            formula = 'Divide the energy value by 3.6e+9';
            break;
          case 'Megawatt-hours':
            formula = 'Divide the energy value by 3.6e+12';
            break;
          case 'Calories':
            formula = 'Divide the energy value by 4184';
            break;
          case 'Kilocalories':
            formula = 'Divide the energy value by 4.184e+6';
            break;
          case 'Foot-pounds Force':
            formula = 'Divide the energy value by 1356';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Divide the energy value by 1055';
            break;
          case 'Therms':
            formula = 'Divide the energy value by 1.055e+8';
            break;
          case 'Horsepower Hours':
            formula = 'Divide the energy value by 2.68452e+9';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Divide the energy value by 6.118e+12';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Divide the energy value by 4.187e+13';
            break;
          case 'Tonnes of TNT':
            formula = 'Divide the energy value by 4.184e+12';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Divide the energy value by 4.184e+15';
            break;
          case 'Megatonnes of TNT':
            formula = 'Divide the energy value by 4.184e+18';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 10^10';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+15';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+12';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+9';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+6';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// MEGAJOULES
      case 'Megajoules':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1e+9';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1e+12';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1e+9';
            break;
          case 'Kilowatt-hours':
            formula = 'Divide the energy value by 3.6e+6';
            break;
          case 'Megawatt-hours':
            formula = 'Divide the energy value by 3.6e+9';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Watt-hours':
            formula = 'Divide the energy value by 3.6e+3';
            break;
          case 'Calories':
            formula = 'Divide the energy value by 4184e+6';
            break;
          case 'Kilocalories':
            formula = 'Divide the energy value by 4.184e+12';
            break;
          case 'Foot-pounds Force':
            formula = 'Divide the energy value by 1356e+3';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Divide the energy value by 1055e+6';
            break;
          case 'Therms':
            formula = 'Divide the energy value by 1.055e+11';
            break;
          case 'Horsepower Hours':
            formula = 'Divide the energy value by 2.68452e+12';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Divide the energy value by 6.118e+15';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Divide the energy value by 4.187e+16';
            break;
          case 'Tonnes of TNT':
            formula = 'Divide the energy value by 4.184e+15';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Divide the energy value by 4.184e+18';
            break;
          case 'Megatonnes of TNT':
            formula = 'Divide the energy value by 4.184e+21';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 10^13';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+18';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+15';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+12';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+9';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// NEWTON METRES
      case 'Newton-metres':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Divide the energy value by 1000';
            break;
          case 'Joules':
            formula = 'The value remains unchanged';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1e+9';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Megajoules':
            formula = 'Divide the energy value by 1000';
            break;
          case 'Newton-metres':
            formula = 'The value remains unchanged';
            break;
          case 'Watt-hours':
            formula = 'Divide the energy value by 3600';
            break;
          case 'Kilowatt-hours':
            formula = 'Divide the energy value by 3.6e+6';
            break;
          case 'Megawatt-hours':
            formula = 'Divide the energy value by 3.6e+9';
            break;
          case 'Calories':
            formula = 'Divide the energy value by 4184';
            break;
          case 'Kilocalories':
            formula = 'Divide the energy value by 4.184e+6';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 0.737562149277';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Divide the energy value by 1055.06';
            break;
          case 'Therms':
            formula = 'Divide the energy value by 1.055e+8';
            break;
          case 'Horsepower Hours':
            formula = 'Divide the energy value by 2.685e+6';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Divide the energy value by 6.118e+9';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Divide the energy value by 4.187e+10';
            break;
          case 'Tonnes of TNT':
            formula = 'Divide the energy value by 4.184e+9';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Divide the energy value by 4.184e+12';
            break;
          case 'Megatonnes of TNT':
            formula = 'Divide the energy value by 4.184e+15';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 10^7';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+12';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+9';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+6';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+3';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// WATT-HOURS
      case 'Watt-hours':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 3.6';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 3600';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 3.6e+12';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 3.6e+9';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 3.6e+6';
            break;
          case 'Megajoules':
            formula = 'Divide the energy value by 3600';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 3600';
            break;
          case 'Watt-hours':
            formula = 'The value remains unchanged';
            break;
          case 'Kilowatt-hours':
            formula = 'Divide the energy value by 1000';
            break;
          case 'Megawatt-hours':
            formula = 'Divide the energy value by 1e+6';
            break;
          case 'Calories':
            formula = 'Divide the energy value by 860';
            break;
          case 'Kilocalories':
            formula = 'Divide the energy value by 860000';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 2655.22';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Divide the energy value by 3.412';
            break;
          case 'Therms':
            formula = 'Divide the energy value by 341214';
            break;
          case 'Horsepower Hours':
            formula = 'Divide the energy value by 745.7';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Divide the energy value by 1.591e+6';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Divide the energy value by 1.085e+7';
            break;
          case 'Tonnes of TNT':
            formula = 'Divide the energy value by 860000';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Divide the energy value by 8.6e+8';
            break;
          case 'Megatonnes of TNT':
            formula = 'Divide the energy value by 8.6e+11';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 10^10';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+18';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+15';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+12';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+9';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOWATT HOURS
      case 'Kilowatt-hours':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 3.6e+6';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 3.6e+9';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 3.6e+15';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 3.6e+12';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 3.6e+9';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 0.0036';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 3600';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Kilowatt-hours':
            formula = 'The value remains unchanged';
            break;
          case 'Megawatt-hours':
            formula = 'Divide the energy value by 1000';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 860421';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 860.421';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 2655223.73741';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 3412.142';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 34.1214';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 745.7';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 1591120';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 10850000';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 860421';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 8.60421e+8';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 8.60421e+11';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 10^12';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+18';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+15';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+12';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+9';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// MEGAWATT HOURS
      case 'Megawatt-hours':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 3.6e+9';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 3.6e+12';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 3.6e+18';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 3.6e+15';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 3.6e+12';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 3600';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 3.6e+9';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Megawatt-hours':
            formula = 'The value remains unchanged';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 860421000';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 860421';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 2655223737.41';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 3412142';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 34121.42';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 745700';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 1591120000';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 10850000000';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 860421000';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 8.60421e+11';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 8.60421e+14';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 10^15';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+21';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+18';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+15';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+12';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// CALORIES
      case 'Calories':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 4.184';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 4184';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 4.184e+12';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 4.184e+9';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 4.184e+6';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 0.004184';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 4184';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 1.163';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 0.001163';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 1.163e-6';
            break;
          case 'Calories':
            formula = 'The value remains unchanged';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 0.001';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 3.088';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 0.003968';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 9.478e-6';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 3.930e-7';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 2.519e-8';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 1.706e-7';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 0.000001163';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 1.163e-9';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 1.163e-12';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 4.184e+10';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 2.611e+19';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 2.611e+16';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 2.611e+13';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 2.611e+10';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOCALORIES
      case 'Kilocalories':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 4.184';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 4184';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 4.184e+12';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 4.184e+9';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 4.184e+6';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 0.004184';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 4184';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 1.163';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 0.001163';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 1.163e-6';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Kilocalories':
            formula = 'The value remains unchanged';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 3088';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 3.968';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 9.478e-3';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 3.93e-4';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 2.519e-5';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 1.706e-4';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 0.001163';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 1.163e-6';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 1.163e-9';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 4.184e+13';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 2.611e+22';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 2.611e+19';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 2.611e+16';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 2.611e+13';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// FOOT-POUNDS FORCE
      case 'Foot-pounds Force':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 0.00135582';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 1.35582';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1.35582e+9';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1.35582e+6';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1355.82';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 0.00000135582';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 1.35582';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 0.000376616';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 3.76616e-7';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 3.76616e-10';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 0.000323831';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 3.23831e-7';
            break;
          case 'Foot-pounds Force':
            formula = 'The value remains unchanged';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 3.23831e-7';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 7.7782e-10';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 3.93072e-12';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 2.50304e-13';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 1.696e-12';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 3.76616e-10';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 3.76616e-13';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 3.76616e-16';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 1.35582e+10';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 8.46235e+18';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 8.46235e+15';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 8.46235e+12';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 8.46235e+9';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// BRITISH THERMAL UNITS (ISO)
      case 'British Thermal Units (ISO)':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 1.05506';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 1055.06';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1.05506e+9';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1.05506e+6';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1055060';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 0.00105506';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 1055.06';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 0.293071';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 2.93071e-4';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 2.93071e-7';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 0.251997';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 0.000251997';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 777.82';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'The value remains unchanged';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 2.38846e-6';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 9.76841e-8';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 6.23012e-9';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 4.22064e-8';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 2.93071e-7';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 2.93071e-10';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 2.93071e-13';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 1.05506e+13';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.585e+21';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.585e+18';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.585e+15';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.585e+12';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// THERMS
      case 'Therms':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 105505.6';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 105505600';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1.05506e+14';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1.05506e+11';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1.05506e+8';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 105.506';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 105505.6';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 29.3071';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 0.0293071';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 2.93071e-5';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 25199.7';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 25.1997';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 77782000';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 2388.46';
            break;
          case 'Therms':
            formula = 'The value remains unchanged';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 0.000372506';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 2.37258e-6';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 1.60934e-5';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 2.93071e-5';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 2.93071e-8';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 2.93071e-11';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 1.05506e+17';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.585e+27';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.585e+24';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.585e+21';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 6.585e+18';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// HORSEPOWER HOURS
      case 'Horsepower Hours':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 2.68452';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 2684520';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 2.68452e+15';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 2.68452e+12';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 2.68452e+9';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 2684.52';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 2684520';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 746.572';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 0.746572';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 7.46572e-4';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 641.186';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 0.641186';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 1980000';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 60';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 3725.76';
            break;
          case 'Horsepower Hours':
            formula = 'The value remains unchanged';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 6.35514e-6';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 4.30755e-5';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 7.46572e-4';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 7.46572e-7';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 7.46572e-10';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 2.68452e+17';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 1.67772e+28';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 1.67772e+25';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 1.67772e+22';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 1.67772e+19';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// BARRELS OF OIL EQUIVALENT
      case 'Barrels of Oil Equivalent':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 62331.5';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 6.23315e+7';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 6.23315e+16';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 6.23315e+13';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 6.23315e+10';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 62.3315';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 6.23315e+7';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 17,328';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 17.328';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 0.017328';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 14849.1';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 14.8491';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 4.60614e+7';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 1392.92';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 0.188552';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 0.000284343';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'The value remains unchanged';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 0.13636';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 0.017328';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 1.7328e-5';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 1.7328e-8';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 6.23315e+13';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 3.8988e+23';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 3.8988e+20';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 3.8988e+17';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 3.8988e+14';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// TONNES OF OIL EQUIVALENT
      case 'Tonnes of Oil Equivalent':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 45656.4';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 4.5664e+7';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 4.5664e+16';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 4.5664e+13';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 4.5664e+10';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 45.6564';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 4.5664e+7';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 12,682.5';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 12.6825';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 0.0126825';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 10849.6';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 10.8496';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 3.36463e+7';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 1016.12';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 0.137952';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 0.000208036';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 7.3293';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'The value remains unchanged';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 0.0126825';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 1.26825e-5';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 1.26825e-8';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 4.5664e+13';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 2.85612e+23';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 2.85612e+20';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 2.85612e+17';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 2.85612e+14';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// TONNES OF TNT
      case 'Tonnes of TNT':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 4184';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 4.184e+6';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 4.184e+15';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 4.184e+12';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 4.184e+9';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 4.184';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 4.184e+6';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 1.1626';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 0.0011626';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 1.1626e-6';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 1';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 2.9891e+6';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 0.94782';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 0.00010039';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 1.5184e-7';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 0.00023885';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 0.00010039';
            break;
          case 'Tonnes of TNT':
            formula = 'The value remains unchanged';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 0.001';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 1e-6';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 4.184e+12';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 2.621e+22';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 2.621e+19';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 2.621e+16';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 2.621e+13';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOTONNES OF TNT
      case 'Kilotonnes of TNT':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 4.184e+9';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 4.184e+12';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 4.184e+21';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 4.184e+18';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 4.184e+15';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 4.184e+6';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 4.184e+12';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 1162620';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 1162.62';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 1.16262';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 2.989e+9';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 947.82';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 0.10039';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 0.00015184';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 0.023885';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 0.010039';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Kilotonnes of TNT':
            formula = 'The value remains unchanged';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 0.001';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 4.184e+18';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 2.621e+28';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 2.621e+25';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 2.621e+22';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 2.621e+19';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// MEGATONNES OF TNT
      case 'Megatonnes of TNT':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 4.184e+12';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 4.184e+15';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 4.184e+24';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 4.184e+21';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 4.184e+18';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 4.184e+9';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 4.184e+15';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 1.16262e+12';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 1.16262e+9';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 1.16262e+6';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 1e+12';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 1e+9';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 2.989e+12';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 9.4782e+11';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 1.0039e+10';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 1.5184e+6';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 238850';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 100390';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Megatonnes of TNT':
            formula = 'The value remains unchanged';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 4.184e+21';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 2.621e+31';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 2.621e+28';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 2.621e+25';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 2.621e+22';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// ERGS
      case 'Ergs':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 1e-7';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 1e-10';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1e-19';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1e-16';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1e-13';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 1e-16';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 1e-10';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 2.7778e-14';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 2.7778e-17';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 2.7778e-20';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 2.3885e-14';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 2.3885e-17';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 7.3756e-11';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 2.326e-14';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 2.4877e-15';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 3.725e-20';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 5.869e-18';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 2.4877e-15';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 2.5e-13';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 2.5e-7';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 2.5e-10';
            break;
          case 'Ergs':
            formula = 'The value remains unchanged';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 6.242e+11';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 6.242e+8';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 6.242e+5';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 624.2';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// ELECTRONVOLT
      case 'Electronvolt':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 1.60219e-16';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 1.60219e-19';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1.60219e-10';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1.60219e-13';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1.60219e-16';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 1.60219e-25';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 1.60219e-19';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 4.4505e-23';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 4.4505e-26';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 4.4505e-29';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 3.8267e-20';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 3.8267e-23';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 1.1817e-19';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 3.725e-23';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 3.9877e-24';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 5.9814e-30';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 9.417e-28';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 3.9877e-24';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-22';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-16';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-19';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 1e+8';
            break;
          case 'Electronvolt':
            formula = 'The value remains unchanged';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 0.001';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 1e-6';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 1e-9';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOELECTRONVOLT
      case 'Kiloelectronvolt':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 1.60219e-13';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 1.60219e-16';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1.60219e-7';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1.60219e-10';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1.60219e-13';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 1.60219e-22';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 1.60219e-16';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 4.4505e-20';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 4.4505e-23';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 4.4505e-26';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 3.8267e-17';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 3.8267e-20';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 1.1817e-16';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 3.725e-20';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 3.9877e-21';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 5.9814e-27';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 9.417e-25';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 3.9877e-21';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-19';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-13';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-16';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 1e+5';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Kiloelectronvolt':
            formula = 'The value remains unchanged';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 0.001';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 1e-6';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// MEGAELECTRONVOLT
      case 'Megaelectronvolt':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 1.60219e-10';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 1.60219e-13';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1.60219e-4';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1.60219e-7';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1.60219e-10';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 1.60219e-19';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 1.60219e-13';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 4.4505e-17';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 4.4505e-20';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 4.4505e-23';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 3.8267e-14';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 3.8267e-17';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 1.1817e-13';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 3.725e-17';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 3.9877e-18';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 5.9814e-24';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 9.417e-22';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 3.9877e-18';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-16';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-10';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-13';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 1e+5';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 1e+6';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Megaelectronvolt':
            formula = 'The value remains unchanged';
            break;
          case 'Gigaelectronvolt':
            formula = 'Multiply the energy value by 0.001';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// GIGAELECTRONVOLT
      case 'Gigaelectronvolt':
        switch (toUnit) {
          case 'Kilojoules':
            formula = 'Multiply the energy value by 1.60219e-7';
            break;
          case 'Joules':
            formula = 'Multiply the energy value by 1.60219e-10';
            break;
          case 'Nanojoules':
            formula = 'Multiply the energy value by 1.60219e-1';
            break;
          case 'Microjoules':
            formula = 'Multiply the energy value by 1.60219e-4';
            break;
          case 'Millijoules':
            formula = 'Multiply the energy value by 1.60219e-7';
            break;
          case 'Megajoules':
            formula = 'Multiply the energy value by 1.60219e-16';
            break;
          case 'Newton-metres':
            formula = 'Multiply the energy value by 1.60219e-10';
            break;
          case 'Watt-hours':
            formula = 'Multiply the energy value by 4.4505e-14';
            break;
          case 'Kilowatt-hours':
            formula = 'Multiply the energy value by 4.4505e-17';
            break;
          case 'Megawatt-hours':
            formula = 'Multiply the energy value by 4.4505e-20';
            break;
          case 'Calories':
            formula = 'Multiply the energy value by 3.8267e-11';
            break;
          case 'Kilocalories':
            formula = 'Multiply the energy value by 3.8267e-14';
            break;
          case 'Foot-pounds Force':
            formula = 'Multiply the energy value by 1.1817e-10';
            break;
          case 'British Thermal Units (ISO)':
            formula = 'Multiply the energy value by 3.725e-14';
            break;
          case 'Therms':
            formula = 'Multiply the energy value by 3.9877e-15';
            break;
          case 'Horsepower Hours':
            formula = 'Multiply the energy value by 5.9814e-21';
            break;
          case 'Barrels of Oil Equivalent':
            formula = 'Multiply the energy value by 9.417e-19';
            break;
          case 'Tonnes of Oil Equivalent':
            formula = 'Multiply the energy value by 3.9877e-15';
            break;
          case 'Tonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-13';
            break;
          case 'Kilotonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-7';
            break;
          case 'Megatonnes of TNT':
            formula = 'Multiply the energy value by 4.0181e-10';
            break;
          case 'Ergs':
            formula = 'Multiply the energy value by 1e+8';
            break;
          case 'Electronvolt':
            formula = 'Multiply the energy value by 1e+3';
            break;
          case 'Kiloelectronvolt':
            formula = 'Multiply the energy value by 1e-3';
            break;
          case 'Megaelectronvolt':
            formula = 'Multiply the energy value by 1000';
            break;
          case 'Gigaelectronvolt':
            formula = 'The value remains unchanged';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
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
                        'Convert Volume',
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
      case 'Nanojoules':
        return 'nJ';
      case 'Microjoules':
        return 'µJ';
      case 'Millijoules':
        return 'mJ';
      case 'Joules':
        return 'J';
      case 'Kilojoules':
        return 'kJ';
      case 'Megajoules':
        return 'MJ';
      case 'Newton-metres':
        return 'N⋅m';
      case 'Watt-hours':
        return 'Wh';
      case 'Kilowatt-hours':
        return 'kW⋅h';
      case 'Megawatt-hours':
        return 'MWh';
      case 'Calories':
        return 'cal';
      case 'Kilocalories':
        return 'kcal';
      case 'Foot-pounds Force':
        return 'ft⋅lbf';
      case 'British Thermal Units (ISO)':
        return 'BTU';
      case 'Therms':
        return 'thm';
      case 'Horsepower Hours':
        return 'hp⋅h';
      case 'Barrels of Oil Equivalent':
        return 'BOE';
      case 'Tonnes of Oil Equivalent':
        return 'toe';
      case 'Tonnes of TNT':
        return 'ton of TNT';
      case 'Kilotonnes of TNT':
        return 'KT TNT';
      case 'Megatonnes of TNT':
        return 'MT TNT';
      case 'Ergs':
        return 'erg';
      case 'Electronvolt':
        return 'eV';
      case 'Kiloelectronvolt':
        return 'keV';
      case 'Megaelectronvolt':
        return 'MeV';
      case 'Gigaelectronvolt':
        return 'GeV';
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
      'Nanojoules',
      'Microjoules',
      'Millijoules',
      'Joules',
      'Kilojoules',
      'Megajoules',
      'Newton-metres',
      'Watt-hours',
      'Kilowatt-hours',
      'Megawatt-hours',
      'Calories',
      'Kilocalories',
      'Foot-pounds Force',
      'British Thermal Units (ISO)',
      'Therms',
      'Horsepower Hours',
      'Barrels of Oil Equivalent',
      'Tonnes of Oil Equivalent',
      'Tonnes of TNT',
      'Kilotonnes of TNT',
      'Megatonnes of TNT',
      'Ergs',
      'Electronvolt',
      'Kiloelectronvolt',
      'Megaelectronvolt',
      'Gigaelectronvolt',
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
