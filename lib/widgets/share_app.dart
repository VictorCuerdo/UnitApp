import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unitapp/controllers/navigation_utils.dart';

class ShareApp {
  void share(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.height < 630;
    String androidAppLink =
        "https://play.google.com/store/apps/details?id=com.appevolvelabs.unitapp";
    String iosAppLink = "COMING SOON";

    var mediaQuery = MediaQuery.of(context);
    double dialogHeight = isSmallScreen
        ? mediaQuery.size.height * 0.7
        : mediaQuery.size.height *
            0.5; // Increase the factor for a taller dialog

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(
              color: Color(0xFF1B3A4B),
              width: 5.0,
            ),
          ),
          title: const Text(
            "Share the App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ).tr(),
          content: SizedBox(
            width: double.maxFinite,
            height: dialogHeight * 1,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  TabBar(
                    splashBorderRadius: BorderRadius.circular(15),
                    dividerColor: Colors.transparent,
                    enableFeedback: true,
                    indicatorWeight: dialogHeight * 0.01,
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[800],
                    indicator: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    tabs: [
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/android.png',
                                  height: 18),
                              const SizedBox(width: 5),
                              Text("Android",
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 10 : 15)),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('assets/images/apple.png',
                                  height: 18),
                              const SizedBox(width: 5),
                              Text("iOS",
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 10 : 15)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _tabContent(androidAppLink),
                        _tabContent(iosAppLink),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).tr(),
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
    return Builder(
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 35),
            Image.asset(
              'assets/images/qr_code_android.png',
              height: 170,
              width: 170,
            ),
            const SizedBox(height: 20),
            AutoSizeText(
              appLink,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Maximum number of lines
              minFontSize: 8.0, // Minimum font size
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final hapticFeedbackEnabled =
                    prefs.getBool('hapticFeedback') ?? false;
                if (hapticFeedbackEnabled) {
                  bool canVibrate = await Vibrate.canVibrate;
                  if (canVibrate) {
                    Vibrate.feedback(FeedbackType.selection);
                  }
                }
                Clipboard.setData(ClipboardData(text: appLink)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: const Text(
                              'Link copied to clipboard',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ).tr(),
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
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
                ),
              ),
              child: const Text(
                'Copy Link',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ).tr(),
            ),
            const SizedBox(height: 5),
          ],
        );
      },
    );
  }
}
