// ignore_for_file: library_private_types_in_public_api
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitapp/controllers/font_size_provider.dart';
import 'package:unitapp/controllers/navigation_utils.dart';
import 'package:unitapp/widgets/search_widget.dart';

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
  double gridImageSize = 90.0; // Default image size
  double gridLabelFontSize = 18.0; // Default label font size
  int?
      _tappedIndex; // Variable to keep track of the tapped grid item for the animation effect
// Add a method to determine if dark mode is enabled
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;
  bool _isSearchBarVisible = false;
  // Method to handle outside tap to close the search bar

  void _shareApp(BuildContext context) {
    String appLink =
        "https://play.google.com/store/apps/details?id=com.yourapp";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.white,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFF1B3A4B),
              width: 5.0,
            ),
          ),
          title: const Text(
            'Share the App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            // Wrap the content with SingleChildScrollView
            child: ListBody(
              // Use ListBody for better performance
              children: [
                const SizedBox(height: 25),
                Image.asset(
                  'assets/images/qrcode.png', // Update the path with forward slashes
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 25),
                SelectableText(
                  appLink,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: appLink)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Link copied to clipboard',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: const Color(0xFF1B3A4B),
                          duration: const Duration(seconds: 3),
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 6.0,
                        ),
                      );
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  child: const Text(
                    'Copy Link',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleOutsideTap() {
    if (_isSearchBarVisible) {
      setState(() {
        _isSearchBarVisible = false;
      });
    }
  }

  final List<Map<String, dynamic>> _gridItems = [
    {
      'imageDark': 'assets/images/distance.png',
      'imageLight': 'assets/images/distanceL.png',
      'label': 'Distance'
    },
    {
      'imageDark': 'assets/images/area.png',
      'imageLight': 'assets/images/areaL.png',
      'label': 'Area'
    },
    {
      'image': 'assets/images/volumen.png',
      'label': 'Volume'
    }, // IMAGE IS BOTH DARK AND LIGHT
    {
      'image': 'assets/images/power.png',
      'label': 'Power'
    }, // IMAGE IS BOTH DARK AND LIGHT
    {
      'image': 'assets/images/time.png',
      'label': 'Time'
    }, // IMAGE IS BOTH DARK AND LIGHT
    {
      'imageDark': 'assets/images/speed.png',
      'imageLight': 'assets/images/speedL.png',
      'label': 'Speed'
    },
    {
      'image': 'assets/images/masa.png',
      'label': 'Mass'
    }, // IMAGE IS BOTH DARK AND LIGHT
    {
      'imageDark': 'assets/images/fuerza.png',
      'imageLight': 'assets/images/fuerzaL.png',
      'label': 'Force'
    },
    {
      'imageDark': 'assets/images/torque.png',
      'imageLight': 'assets/images/torqueL.png',
      'label': 'Torque'
    },
    {
      'imageDark': 'assets/images/pressure.png',
      'imageLight': 'assets/images/pressureL.png',
      'label': 'Pressure'
    },
    {
      'imageDark': 'assets/images/energia.png',
      'imageLight': 'assets/images/energiaL.png',
      'label': 'Energy'
    },
    {
      'imageDark': 'assets/images/frecuencia.png',
      'imageLight': 'assets/images/frecuenciaL.png',
      'label': 'Frequency'
    },
    {
      'image': 'assets/images/temperature.png',
      'label': 'Temperature'
    }, // Assuming this image is used for both
    {
      'imageDark': 'assets/images/angle.png',
      'imageLight': 'assets/images/angleL.png',
      'label': 'Angle'
    },
    {
      'imageDark': 'assets/images/combustible.png',
      'imageLight': 'assets/images/combustibleL.png',
      'label': 'Fuel Consumption'
    },
    {
      'imageDark': 'assets/images/data.png',
      'imageLight': 'assets/images/dataL.png',
      'label': 'Data Sizes'
    },
    {
      'imageDark': 'assets/images/settings.png',
      'imageLight': 'assets/images/settingsL.png',
      'label': 'Settings'
    },
    {'image': 'assets/images/share.png', 'label': 'Share'},
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
      _selectedLocale = context.locale;
    });
    Provider.of<FontSizeProvider>(context, listen: false).fontSize = fontSize;
  }

  _saveFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
  }

  Widget _buildGridItem(
      {required String label, required int index, required Function onTap}) {
    bool isTapped = _tappedIndex == index;
    var scaledMatrix = Matrix4.identity()..scale(1.1);
    var theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    // Determine the correct image path based on the theme and label
    String imagePath;
    Map<String, dynamic> gridItem =
        _gridItems.firstWhere((item) => item['label'] == label);
    if (gridItem.containsKey('image')) {
      // If there's a single image for both themes
      imagePath = gridItem['image'];
    } else {
      // If there are different images for dark and light themes
      imagePath = isDarkMode ? gridItem['imageDark'] : gridItem['imageLight'];
    }
    Color tileColor = isDarkMode
        ? Colors.black
        : (index % 2 == 0 ? const Color(0xFFB4E4FF) : const Color(0xFFF7F5EB));
    Color textColor = isDarkMode ? Colors.white : const Color(0xFF101820);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTapDown: (_) => setState(() => _tappedIndex = index),
        onTapCancel: () => setState(() => _tappedIndex = null),
        onTap: () {
          setState(() => _tappedIndex = null);
          // Check if the tapped label is 'Share'
          if (label == 'Share') {
            _shareApp(context);
          } else {
            // For other labels, use a delayed navigation to allow the tap animation to be seen
            Future.delayed(const Duration(milliseconds: 100), () {
              switch (label) {
                case 'Distance':
                  context.navigateTo('/distance');
                  break;
                case 'Area':
                  context.navigateTo('/area');
                  break;
                case 'Volume':
                  context.navigateTo('/volume');
                  break;
                case 'Mass':
                  context.navigateTo('/mass');
                  break;
                case 'Time':
                  context.navigateTo('/time');
                  break;
                case 'Speed':
                  context.navigateTo('/speed');
                  break;
                case 'Frequency':
                  context.navigateTo('/frequency');
                  break;
                case 'Force':
                  context.navigateTo('/force');
                  break;
                case 'Torque':
                  context.navigateTo('/torque');
                  break;
                case 'Pressure':
                  context.navigateTo('/pressure');
                  break;
                case 'Energy':
                  context.navigateTo('/energy');
                  break;
                case 'Power':
                  context.navigateTo('/power');
                  break;
                case 'Temperature':
                  context.navigateTo('/temperature');
                  break;
                case 'Angle':
                  context.navigateTo('/angle');
                  break;
                case 'Fuel Consumption':
                  context.navigateTo('/fuel');
                  break;
                case 'Data Sizes':
                  context.navigateTo('/datas');
                  break;
                case 'Settings':
                  context.navigateTo('/settings');
                  break;
                case 'Share':
                  _shareApp(context);
                  break;
                default:
                  // Handle unknown label, if necessary
                  break;
              }
            });
          }
        },
        splashColor: Colors.grey.withOpacity(0.3), // Customizable splash color
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          transform: isTapped ? scaledMatrix : Matrix4.identity(),
          decoration: BoxDecoration(color: tileColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Image.asset(imagePath, width: gridImageSize),
              ),
              Text(label,
                  style:
                      TextStyle(fontSize: gridLabelFontSize, color: textColor),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use Theme.of(context) to determine the current theme's background color
    var backgroundColor = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFD2E0FB)
        : Colors.black;
    return GestureDetector(
        onTap: _handleOutsideTap,
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.10,
                // Ad content goes here
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isSearchBarVisible
                    ? 0
                    : MediaQuery.of(context).size.height * 0.07,
                color: const Color(0xFF00539C),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _isSearchBarVisible
                    ? null
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 23), // Placeholder
                          const Text(
                            'Pick an option',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearchBarVisible = true;
                              });
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
              ),
              if (_isSearchBarVisible)
                Expanded(
                  child: SearchWidget(
                    onClose: () {
                      setState(() {
                        _isSearchBarVisible = false;
                      });
                    },
                  ),
                ),
              const SizedBox(height: 5),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _gridItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildGridItem(
                      label: _gridItems[index]['label'],
                      index: index,
                      onTap: () {
                        // Provide the onTap callback here
                        if (_gridItems[index]['label'] == 'Share') {
                          _shareApp(context); // Call the share method here
                        } else {
                          // Handle other labels if necessary
                          // ... perform actions based on the label ...
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 2),
            ],
          ),
        ));
  }
}
