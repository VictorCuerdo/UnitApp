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

class PowerUnitConverter extends StatefulWidget {
  const PowerUnitConverter({super.key});

  @override
  _PowerUnitConverterState createState() => _PowerUnitConverterState();
}

class _PowerUnitConverterState extends State<PowerUnitConverter> {
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  String fromUnit = 'Watts';
  String toUnit = 'Kilowatts';
  // Removed duplicate declarations of TextEditingController
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  bool _isExponentialFormat = false;
  // Flag to indicate if the change is due to user input
  bool _isUserInput = true;
  // Using string variables for prefixes
  String fromPrefix = 'W';
  String toPrefix = 'kW';
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
          text: 'Check out my power result!');
    }
  }

  void convert(String text) {
    String normalizedText = text.replaceAll(',', '.');
    if (normalizedText.isEmpty) return;
    var fromValue = double.tryParse(normalizedText);
    if (fromValue == null) return;
    double toValue = 0; // Your conversion logic here

    switch (fromUnit) {
      case 'Watts':
        switch (toUnit) {
          case 'Kilowatts':
            toValue = fromValue / 1000.0;
            break;
          case 'Megawatts':
            toValue = fromValue / 1000000.0;
            break;
          case 'Gigawatts':
            toValue = fromValue / 1000000000.0;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600.0;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3.6;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.23884589663; // Calories per second
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859.84522785899; // Calories per hour
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.00023884590; // Kilocalories per second
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 0.85984522786; // Kilocalories per hour
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.00134102209; // Mechanical horsepower
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.00135962162; // Metric horsepower
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3.412142;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737.5621;
            break;
          case 'Watts': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilowatts':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1000.0;
            break;
          case 'Megawatts':
            toValue = fromValue / 1000.0;
            break;
          case 'Gigawatts':
            toValue = fromValue / 1000000.0;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000.0;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600.0;
            break;
          case 'Calories per Second':
            toValue = fromValue * 238.84589663; // Calories per second
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859845.22785899; // Calories per hour
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.23884590; // Kilocalories per second
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 859.84522786; // Kilocalories per hour
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 1.34102209; // Mechanical horsepower
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 1.35962162; // Metric horsepower
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3412.142;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737562.1;
            break;
          case 'Kilowatts': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Megawatts':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1000000;
            break;
          case 'Kilowatts':
            toValue = fromValue * 1000;
            break;
          case 'Gigawatts':
            toValue = fromValue / 1000;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000000;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600000;
            break;
          case 'Calories per Second':
            toValue = fromValue * 239005.7361377;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859845227.2961;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 239.0057361;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 859845.2272961;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 1341.0220896;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 1359.6216173;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3412142;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737562149.277;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Gigawatts':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1000000000;
            break;
          case 'Kilowatts':
            toValue = fromValue * 1000000;
            break;
          case 'Megawatts':
            toValue = fromValue * 1000;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000000000;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600000000;
            break;
          case 'Calories per Second':
            toValue = fromValue * 239005736137.7;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859845227296.1;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 239005736.1377;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 859845227.2961;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 1341022.0896;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 1359621.6173;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3412142000;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737562149277;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Joules per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue / 3600;
            break;
          case 'Kilowatts':
            toValue = fromValue / 3.6;
            break;
          case 'Megawatts':
            toValue = fromValue / 3.6e6;
            break;
          case 'Gigawatts':
            toValue = fromValue / 3.6e9;
            break;
          case 'Joules per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue / 1000;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.000239006;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 0.859845227;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 2.39006e-7;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 0.859845227;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 3.725062e-4;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 3.776726e-4;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 0.947817;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 0.737562;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilojoules per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 3600;
            break;
          case 'Kilowatts':
            toValue = fromValue * 3.6;
            break;
          case 'Megawatts':
            toValue = fromValue / 3.6e3;
            break;
          case 'Gigawatts':
            toValue = fromValue / 3.6e6;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 1000;
            break;
          case 'Kilojoules per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.239006;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 859.845227;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 2.39006e-4;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 0.859845227;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.3725062e-3;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.3776726e-3;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 947.817;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 737.562;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Calories per Second':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 4186.8;
            break;
          case 'Kilowatts':
            toValue = fromValue * 4.1868;
            break;
          case 'Megawatts':
            toValue = fromValue * 4.1868e-3;
            break;
          case 'Gigawatts':
            toValue = fromValue * 4.1868e-6;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600;
            break;
          case 'Calories per Second': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 3600;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.001;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 3.6;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.002650286;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.002684519;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3.96832;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 3088.025206;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Calories per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1.163;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.001163;
            break;
          case 'Megawatts':
            toValue = fromValue * 1.163e-6;
            break;
          case 'Gigawatts':
            toValue = fromValue * 1.163e-9;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 4186800;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 4186.8;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.000277778;
            break;
          case 'Calories per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.000000277778;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 0.001;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.0000007457;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.00000075302;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 0.001;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 0.737562;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilocalories per Second':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 4186.8;
            break;
          case 'Kilowatts':
            toValue = fromValue * 4.1868;
            break;
          case 'Megawatts':
            toValue = fromValue * 4.1868e-3;
            break;
          case 'Gigawatts':
            toValue = fromValue * 4.1868e-6;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 3600000;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 3600;
            break;
          case 'Calories per Second':
            toValue = fromValue * 1000;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 3600000;
            break;
          case 'Kilocalories per Second': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 3600;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.002650286;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.002684519;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 3.96832;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 3088.025206;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Kilocalories per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 1.163;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.001163;
            break;
          case 'Megawatts':
            toValue = fromValue * 1.163e-6;
            break;
          case 'Gigawatts':
            toValue = fromValue * 1.163e-9;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 4186800;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 4186.8;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.000277778;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 1000;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.000000277778;
            break;
          case 'Kilocalories per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.0000007457;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.00000075302;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 0.001;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 0.737562;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;
      case 'Horsepowers (Mechanical)':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 745.7;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.7457;
            break;
          case 'Megawatts':
            toValue = fromValue * 7.457e-4;
            break;
          case 'Gigawatts':
            toValue = fromValue * 7.457e-7;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 2684519.52;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 2684.51952;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.17787814;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 640.361304;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.00017787814;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 640.361304;
            break;
          case 'Horsepowers (Mechanical)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.9863201;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 2544.433588;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 550.98416;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Horsepowers (Metric)':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 735.49875;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.73549875;
            break;
          case 'Megawatts':
            toValue = fromValue * 7.3549875e-4;
            break;
          case 'Gigawatts':
            toValue = fromValue * 7.3549875e-7;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 2655223.7374;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 2655.2237374;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.17657312;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 636.8628136;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 0.00017657312;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 636.8628136;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 1.014;
            break;
          case 'Horsepowers (Metric)': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 2604.277961;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 560.98709;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'British Thermal Units per Hour':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 0.29307107;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.00029307107;
            break;
          case 'Megawatts':
            toValue = fromValue * 2.9307107e-7;
            break;
          case 'Gigawatts':
            toValue = fromValue * 2.9307107e-10;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 1055.05585262;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 1.05505585262;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.00027777778;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 1000.0;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 2.7777778e-7;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 1000.0;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.00039301477;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.00039849016;
            break;
          case 'British Thermal Units per Hour': // No conversion needed if from and to units are the same
            toValue = fromValue;
            break;
          case 'Foot-pounds Force Per Second':
            toValue = fromValue * 2.6552237;
            break;
          default:
            // Handle the default case or throw an error
            break;
        }
        break;

      case 'Foot-pounds Force Per Second':
        switch (toUnit) {
          case 'Watts':
            toValue = fromValue * 0.73756215;
            break;
          case 'Kilowatts':
            toValue = fromValue * 0.00073756215;
            break;
          case 'Megawatts':
            toValue = fromValue * 7.3756215e-7;
            break;
          case 'Gigawatts':
            toValue = fromValue * 7.3756215e-10;
            break;
          case 'Joules per Hour':
            toValue = fromValue * 2655.2237374;
            break;
          case 'Kilojoules per Hour':
            toValue = fromValue * 2.6552237374;
            break;
          case 'Calories per Second':
            toValue = fromValue * 0.000698075;
            break;
          case 'Calories per Hour':
            toValue = fromValue * 2513.47;
            break;
          case 'Kilocalories per Second':
            toValue = fromValue * 6.98075e-7;
            break;
          case 'Kilocalories per Hour':
            toValue = fromValue * 2513.47;
            break;
          case 'Horsepowers (Mechanical)':
            toValue = fromValue * 0.0009863201;
            break;
          case 'Horsepowers (Metric)':
            toValue = fromValue * 0.001;
            break;
          case 'British Thermal Units per Hour':
            toValue = fromValue * 0.37792981;
            break;
          case 'Foot-pounds Force Per Second': // No conversion needed if from and to units are the same
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
// WATTS
      case 'Watts':
        switch (toUnit) {
          case 'Watts':
            formula = 'The value remains unchanged';
            break;
          case 'Kilowatts':
            formula = 'Divide the power value by 1000';
            break;
          case 'Megawatts':
            formula = 'Divide the power value by 1e+6';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 1e+9';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 0.239';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 860.421';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.000239';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 0.860421';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.001341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.001359';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412142';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 737.5621';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOWATTS
      case 'Kilowatts':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1000';
            break;
          case 'Kilowatts':
            formula = 'The value remains unchanged';
            break;
          case 'Megawatts':
            formula = 'Divide the power value by 1000';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 1e+6';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3.6e+6';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 239';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 860421';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.239';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 860421';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 1.341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1.359';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3412.142';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 737562.1';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// MEGAWATTS
      case 'Megawatts':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1e+6';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 1000';
            break;
          case 'Megawatts':
            formula = 'The value remains unchanged';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 1000';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3.6e+9';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6e+6';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 2.39e+5';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 8.604e+8';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 239';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 8.604e+5';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 1341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1359';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412e+6';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 7.376e+8';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// GIGAWATTS
      case 'Gigawatts':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1e+9';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 1e+6';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 1000';
            break;
          case 'Gigawatts':
            formula = 'The value remains unchanged';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3.6e+12';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6e+9';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 2.39e+8';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 8.604e+11';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 2.39e+5';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 8.604e+8';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 1.341e+6';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1.359e+6';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412e+9';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 7.376e+11';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// JOULES PER HOUR
      case 'Joules per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Divide the power value by 3600';
            break;
          case 'Kilowatts':
            formula = 'Divide the power value by 3.6e+6';
            break;
          case 'Megawatts':
            formula = 'Divide the power value by 3.6e+9';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 3.6e+12';
            break;
          case 'Joules per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Kilojoules per Hour':
            formula = 'Divide the power value by 3600';
            break;
          case 'Calories per Second':
            formula = 'Divide the power value by 860420.65';
            break;
          case 'Calories per Hour':
            formula = 'Divide the power value by 3.096e+9';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 860.42';
            break;
          case 'Kilocalories per Hour':
            formula = 'Divide the power value by 3.096e+6';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Divide the power value by 745699.87';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Divide the power value by 735498.75';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Divide the power value by 1055.06';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Divide the power value by 2260000';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOJOULES PER HOUR
      case 'Kilojoules per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 3600000';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Gigawatts':
            formula = 'Divide the power value by 1000';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilojoules per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 239.005736';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 860.42185';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 3600';
            break;
          case 'Kilocalories per Hour':
            formula = 'Divide the power value by 3.6';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Divide the power value by 745.699872';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Divide the power value by 735.49875';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Divide the power value by 1.055056';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 737.562149';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// CALORIES PER SECOND
      case 'Calories per Second':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 4184';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 4.184';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 4.184e-6';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 4.184e-9';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600000';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Calories per Second':
            formula = 'The value remains unchanged';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 1000';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.001';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.00101387';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412142';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3088.025207';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// CALORIES PER HOUR
      case 'Calories per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1.162222';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.001162222';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 1.162222e-9';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 1.162222e-12';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Calories per Second':
            formula = 'Divide the power value by 3600';
            break;
          case 'Calories per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 3.6e+6';
            break;
          case 'Kilocalories per Hour':
            formula = 'Divide the power value by 3600';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.000001341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.0000013596';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 0.00396832';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3.0841';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// KILOCALORIES PER SECOND
      case 'Kilocalories per Second':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 4184';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 4.184';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 4.184e-6';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 4.184e-9';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600000';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 1000';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 3600000';
            break;
          case 'Kilocalories per Second':
            formula = 'The value remains unchanged';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 1.341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1.359621617';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 3.412142';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3088.025207';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// KILOCALORIES PER HOUR
      case 'Kilocalories per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1.162222';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.001162222';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 1.162222e-9';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 1.162222e-12';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 3600';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 3.6';
            break;
          case 'Calories per Second':
            formula = 'Divide the power value by 3600';
            break;
          case 'Calories per Hour':
            formula = 'Divide the power value by 3600';
            break;
          case 'Kilocalories per Second':
            formula = 'Divide the power value by 3600';
            break;
          case 'Kilocalories per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.000001341';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.0000013596';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 0.00396832';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3.0841';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// HORSEPOWERS (MECHANICAL)
      case 'Horsepowers (Mechanical)':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 745.7';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.7457';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 0.0007457';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 7.457e-7';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 2684519.5';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 2684.5195';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 178.097245';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 641.149682';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.178097245';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 641.149682';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'The value remains unchanged';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 1.0139';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 2544.433595';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 550.547868';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// HORSEPOWERS (METRIC)
      case 'Horsepowers (Metric)':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 735.5';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.7355';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 0.0007355';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 7.355e-7';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 2655223.7';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 2655.2237';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 176.726789';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 636.216441';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.176726789';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 636.216441';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.9863';
            break;
          case 'Horsepowers (Metric)':
            formula = 'The value remains unchanged';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 2519.92893';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 542.476045';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;
// BRITISH THERMAL UNITS PER HOUR
      case 'British Thermal Units per Hour':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 0.29307107';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.00029307107';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 2.9307107e-7';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 2.9307107e-10';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 1055.0559';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 1.0550559';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 0.06996026';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 251.05694';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.00006996026';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 251.05694';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.00039301478';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.00037712213';
            break;
          case 'British Thermal Units per Hour':
            formula = 'The value remains unchanged';
            break;
          case 'Foot-pounds Force Per Second':
            formula = 'Multiply the power value by 3600';
            break;
          default:
            throw Exception('Unknown unit: $toUnit');
        }
        break;

// FOOT-POUNDS FORCE PER SECOND
      case 'Foot-pounds Force Per Second':
        switch (toUnit) {
          case 'Watts':
            formula = 'Multiply the power value by 1.35581795';
            break;
          case 'Kilowatts':
            formula = 'Multiply the power value by 0.00135581795';
            break;
          case 'Megawatts':
            formula = 'Multiply the power value by 1.35581795e-6';
            break;
          case 'Gigawatts':
            formula = 'Multiply the power value by 1.35581795e-9';
            break;
          case 'Joules per Hour':
            formula = 'Multiply the power value by 4882.434';
            break;
          case 'Kilojoules per Hour':
            formula = 'Multiply the power value by 4.882434';
            break;
          case 'Calories per Second':
            formula = 'Multiply the power value by 0.32404842';
            break;
          case 'Calories per Hour':
            formula = 'Multiply the power value by 1166.5747';
            break;
          case 'Kilocalories per Second':
            formula = 'Multiply the power value by 0.00032404842';
            break;
          case 'Kilocalories per Hour':
            formula = 'Multiply the power value by 1166.5747';
            break;
          case 'Horsepowers (Mechanical)':
            formula = 'Multiply the power value by 0.00018181818';
            break;
          case 'Horsepowers (Metric)':
            formula = 'Multiply the power value by 0.00017461921';
            break;
          case 'British Thermal Units per Hour':
            formula = 'Multiply the power value by 0.00027777778';
            break;
          case 'Foot-pounds Force Per Second':
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
                        'Convert Time',
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
      'Watts',
      'Kilowatts',
      'Megawatts',
      'Gigawatts',
      'Joules per Hour',
      'Kilojoules per Hour',
      'Calories per Second',
      'Calories per Hour',
      'Kilocalories per Second',
      'Kilocalories per Hour',
      'Horsepowers (Mechanical)',
      'Horsepowers (Metric)',
      'British Thermal Units per Hour',
      'Foot-pounds Force Per Second',
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
