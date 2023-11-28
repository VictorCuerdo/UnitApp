// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitapp/ads/banners.dart';
import 'package:unitapp/ads/interstitial.dart';
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
  double gridImageSize = 80.0; // Default image size
  double gridLabelFontSize = 16.0; // Default label font size
  int?
      _tappedIndex; // Variable to keep track of the tapped grid item for the animation effect
// Add a method to determine if dark mode is enabled
  bool get isDarkMode => Theme.of(context).brightness == Brightness.light;
  bool _isSearchBarVisible = false;
  // Method to handle outside tap to close the search bar

  void _shareApp(BuildContext context) {
    String androidAppLink =
        "https://play.google.com/store/apps/details?id=com.yourapp";
    String iosAppLink = "https://apps.apple.com/app/idyourappid";

    // Get the current MediaQuery data
    var mediaQuery = MediaQuery.of(context);

    // Calculate 30% of the available height
    double dialogHeight = mediaQuery.size.height * 0.3;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Increased rounding here
            side: const BorderSide(
              color: Color(0xFF1B3A4B),
              width: 5.0,
            ),
          ),
          title: Text(
            "Share the App".tr(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            // Set the height to be 30% larger than the calculated height
            height: dialogHeight * 1.6,
            child: DefaultTabController(
              length: 2,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TabBar(
                    splashBorderRadius: BorderRadius.circular(15),
                    dividerColor: Colors.transparent,
                    enableFeedback: true,
                    indicatorWeight: dialogHeight *
                        0.03, // Set indicator weight to 10% of the calculated height
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[800],
                    indicator: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                          Radius.circular(15)), // Rounded indicator
                    ), // Rounded indicator

                    tabs: [
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 10), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(
                                0.1), // Slight background color for tabs
                            borderRadius: BorderRadius.circular(
                                15), // Round the corners of the tabs
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center row contents horizontally
                            children: <Widget>[
                              Image.asset('assets/images/android.png',
                                  height: 18), // Android icon
                              const SizedBox(
                                  width: 8), // Space between icon and text
                              const Text("Android",
                                  style: TextStyle(fontSize: 15)), // Text label
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16), // Adjust padding as needed
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(
                                0.1), // Slight background color for tabs
                            borderRadius: BorderRadius.circular(
                                15), // Round the corners of the tabs
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center row contents horizontally
                            children: <Widget>[
                              Image.asset('assets/images/apple.png',
                                  height: 18), // iOS icon
                              const SizedBox(
                                  width: 8), // Space between icon and text
                              const Text("iOS",
                                  style: TextStyle(fontSize: 15)), // Text label
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    // Use Expanded to fill the available space
                    child: TabBarView(
                      children: [
                        _tabContent(androidAppLink), // Android tab content
                        _tabContent(iosAppLink), // iOS tab content
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close'.tr(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                context.navigateTo('/unit');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _tabContent(String appLink) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 35),
        Image.asset(
          'assets/images/qrcode.png', // Replace with your actual QR code asset path
          height: 170,
          width: 170,
        ),
        const SizedBox(height: 20),
        SelectableText(
          appLink,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: appLink)).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Link copied to clipboard'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF1B3A4B),
                  duration: const Duration(seconds: 3),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 6.0,
                ),
              );
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              // Reduce vertical padding to decrease the button's height
              const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
            ),
          ),
          child: Text(
            'Copy Link'.tr(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
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
      'image': 'assets/images/volumen.png',
      'label': 'Volume'
    }, // IMAGE IS BOTH DARK AND LIGHT
    {
      'imageDark': 'assets/images/area.png',
      'imageLight': 'assets/images/areaL.png',
      'label': 'Area'
    },

    {
      'image': 'assets/images/power.png',
      'label': 'Power'
    }, // IMAGE IS BOTH DARK AND LIGHT
    {
      'imageDark': 'assets/images/speed.png',
      'imageLight': 'assets/images/speedL.png',
      'label': 'Speed'
    },
    {
      'image': 'assets/images/time.png',
      'label': 'Time'
    }, // IMAGE IS BOTH DARK AND LIGHT

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

  void navigateOrShare(String label) {
    switch (label) {
      case 'Settings':
        context.navigateTo('/settings');
        break;
      case 'Share':
        _shareApp(context);
        break;

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

      default:
        // Handle unknown label, if necessary
        break;
    }
  }

  _saveFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
  }

  Widget _buildGridItem({
    required String label,
    required int index,
    required Function onTap,
  }) {
    bool isTapped = _tappedIndex == index;
    var scaledMatrix = Matrix4.identity()..scale(1.1);
    var theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    // Determine the correct image path based on the theme and label
    String imagePath;
    Map<String, dynamic> gridItem =
        _gridItems.firstWhere((item) => item['label'] == label);
    if (gridItem.containsKey('image')) {
      imagePath = gridItem['image'];
    } else {
      imagePath = isDarkMode ? gridItem['imageDark'] : gridItem['imageLight'];
    }
    Color tileColor = isDarkMode
        ? Colors.black
        // : (index % 2 == 0 ? Colors.white : const Color(0xFFF5F5F5));
        : (index % 2 == 0 ? const Color(0xFFFFF5E0) : const Color(0xFFFFF5E0));
    Color textColor = isDarkMode ? Colors.white : const Color(0xFF101820);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTapDown: (_) => setState(() => _tappedIndex = index),
        onTapCancel: () => setState(() => _tappedIndex = null),
        onTap: () async {
          // Retrieve the haptic feedback preference.
          final prefs = await SharedPreferences.getInstance();
          final hapticFeedbackEnabled =
              prefs.getBool('hapticFeedback') ?? false;

          // Trigger haptic feedback if enabled.
          if (hapticFeedbackEnabled) {
            // Check if the device can vibrate
            bool canVibrate = await Vibrate.canVibrate;
            if (canVibrate) {
              Vibrate.feedback(FeedbackType.medium);
            }
          }
          // Closure to handle what happens after the ad is closed or if no ad is loaded
          void onAdClosedOrNotLoaded() {
            setState(() => _tappedIndex = null); // Reset the tapped state
            onTap(); // Execute the provided onTap function
            navigateOrShare(label);
          }

          setState(() => _tappedIndex = index); // Set the tapped state

          // Check if the ad is ready and show it for 'Share' or 'Settings' grid
          if ((label == 'Share' || label == 'Settings') &&
              InterstitialAdManager.isAdReady()) {
            InterstitialAdManager.showInterstitialAd(
                onAdClosed: onAdClosedOrNotLoaded);
          } else {
            // If the ad is not ready, execute the onTap function directly
            onAdClosedOrNotLoaded();
            // Perform the usual navigation without showing an ad
            navigateOrShare(label);
          }
        },

        splashColor: Colors.grey.withOpacity(0.3), // Customizable splash color
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          transform: isTapped ? scaledMatrix : Matrix4.identity(),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(10), // Border radius
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Image.asset(imagePath, width: gridImageSize),
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: gridLabelFontSize,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ).tr(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF3E001F)
        : Colors.black;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.black,
        ),
        child: GestureDetector(
            onTap: _handleOutsideTap,
            behavior: HitTestBehavior.opaque,
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: Column(
                children: <Widget>[
                  SafeArea(
                    child: MyBannerAdWidget(
                      adUnitId: Platform.isAndroid
                          ? 'ca-app-pub-3940256099942544/6300978111'
                          : 'ca-app-pub-3940256099942544/2934735716',
                    ),
                  ),
                  Visibility(
                    visible: !_isSearchBarVisible,
                    child: Container(
                      color: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10), // Increased padding
                      height: MediaQuery.of(context).size.height *
                          0.07, // Increased height
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 23),
                          const Text(
                            'Tap an option',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w700,
                              fontSize: 25, // Increased font size
                              color: Colors.white,
                            ),
                          ).tr(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearchBarVisible = true;
                              });
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 32, // Slightly larger icon
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _isSearchBarVisible
                        ? SearchWidget(
                            onClose: () {
                              setState(() {
                                _isSearchBarVisible = false;
                              });
                            },
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 8.0, right: 8.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  if (_gridItems[index]['label'] == 'Share') {
                                    _shareApp(context);
                                  }
                                },
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            )));
  }
}
