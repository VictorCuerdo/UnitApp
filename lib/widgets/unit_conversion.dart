// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitapp/controllers/font_size_provider.dart';
import 'package:unitapp/controllers/navigation_utils.dart';
// Assume other necessary imports are here

class UnitConversion extends StatefulWidget {
  const UnitConversion({Key? key}) : super(key: key);

  @override
  _UnitConversionState createState() => _UnitConversionState();
}

class _UnitConversionState extends State<UnitConversion> {
  static const double smallFontSize = 14.0;
  static const double mediumFontSize = 17.0;
  static const double largeFontSize = 20.0;
  Locale _selectedLocale =
      const Locale('en', 'US'); // Set default selected locale
  double fontSize = mediumFontSize;
  // For adjustable image and text sizes
  double gridImageSize = 80.0; // Default image size
  double gridLabelFontSize = 16.0; // Default label font size

  // Define the list of grid items for unit conversion options
  // Replace your _gridItems to include image paths instead of icons
  final List<Map<String, dynamic>> _gridItems = [
    {'image': 'assets/images/distance.png', 'label': 'Distance'},
    {'image': 'assets/images/area.png', 'label': 'Area'},
    {'image': 'assets/images/volumen.png', 'label': 'Volume'},
    {'image': 'assets/images/masa.png', 'label': 'Mass'},

    {'image': 'assets/images/time.png', 'label': 'Time'},
    {'image': 'assets/images/speed.png', 'label': 'Speed'},
    {'image': 'assets/images/frecuencia.png', 'label': 'Frequency'},
    {'image': 'assets/images/fuerza.png', 'label': 'Force'},

    {'image': 'assets/images/torque.png', 'label': 'Torque'},
    {'image': 'assets/images/pressure.png', 'label': 'Pressure'},
    {'image': 'assets/images/energia.png', 'label': 'Energy'},
    {'image': 'assets/images/power.png', 'label': 'Power'},

    {'image': 'assets/images/temperature.png', 'label': 'Temperature'},
    {'image': 'assets/images/angle.png', 'label': 'Angle'},
    {'image': 'assets/images/combustible.png', 'label': 'Fuel Consumption'},
    {'image': 'assets/images/data.png', 'label': 'Data Sizes'},
    {'image': 'assets/images/settings.png', 'label': 'Settings'},
    // ... other items ...
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getDouble('fontSize') ?? mediumFontSize;
      _selectedLocale = context.locale; // Update to use a localization context
    });

    // Update the provider value
    Provider.of<FontSizeProvider>(context, listen: false).fontSize = fontSize;
  }

  _saveFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
  }

  // Method to build grid items with images and labels
  Widget _buildGridItem({required String imagePath, required String label}) {
    return InkWell(
      onTap: () {
        // Checking if the label is 'Distance' and navigating accordingly
        if (label == 'Distance') {
          context.navigateTo('/distance');
        } else if (label == 'Area') {
          context.navigateTo('/area');
        } else if (label == 'Volume') {
          context.navigateTo('/volume');
        } else if (label == 'Mass') {
          context.navigateTo('/mass');
        } else if (label == 'Time') {
          context.navigateTo('/time');
        } else if (label == 'Speed') {
          context.navigateTo('/speed');
        } else if (label == 'Frequency') {
          context.navigateTo('/frequency');
        } else if (label == 'Force') {
          context.navigateTo('/force');
        } else if (label == 'Torque') {
          context.navigateTo('/torque');
        } else if (label == 'Pressure') {
          context.navigateTo('/pressure');
        } else if (label == 'Energy') {
          context.navigateTo('/energy');
        } else if (label == 'Power') {
          context.navigateTo('/power');
        } else if (label == 'Temperature') {
          context.navigateTo('/temperature');
        } else if (label == 'Angle') {
          context.navigateTo('/angle');
        } else if (label == 'Fuel Consumption') {
          context.navigateTo('/fuel');
        } else if (label == 'Data Sizes') {
          context.navigateTo('/datas');
        }
      },
      child: Container(
        // Use Container to fill the entire grid for splash effect
        decoration: const BoxDecoration(
          color: Colors
              .transparent, // This is necessary for the splash effect to be visible
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                width:
                    gridImageSize, // Uncomment and set width to your adjustable variable
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize:
                    18, // Uncomment and set font size to your adjustable variable
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.navigateTo('/'),
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.grey, size: 40),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Pick an option',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 25),
                    ),
                  ),
                  const SizedBox(
                      width: 48,
                      height:
                          50), // To balance the row out because of the back button
                ],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Adjust to fit your design
                  childAspectRatio: 1, // Adjust for square items
                  crossAxisSpacing: 10, // Horizontal space between items
                  mainAxisSpacing: 20, // Increased vertical space
                ),
                itemCount: _gridItems.length,
                itemBuilder: (context, index) {
                  final item = _gridItems[index];
                  return _buildGridItem(
                    imagePath: item['image'],
                    label: item['label'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
