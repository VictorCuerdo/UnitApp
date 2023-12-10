// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({Key? key}) : super(key: key);

  @override
  NativeAdWidgetState createState() => NativeAdWidgetState();
}

class NativeAdWidgetState extends State<NativeAdWidget>
    with WidgetsBindingObserver {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  Timer? _retryTimer;
  int _retryAttempt = 0;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final Connectivity _connectivity = Connectivity();

  // Ad Unit IDs for different platforms
  final String _androidAdUnitId = 'ca-app-pub-1257505778072677/8288438571';
  final String _iosAdUnitId = 'ca-app-pub-1257505778072677/5610304347';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkConnectivityAndLoadAd();
  }

  void _checkConnectivityAndLoadAd() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No connectivity, you might want to inform the user
      // and not attempt to load the ad at this point.
      setState(() => _isAdLoaded = false);
    } else {
      _loadAd();
    }
  }

  String get _adUnitId => Platform.isAndroid ? _androidAdUnitId : _iosAdUnitId;

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      // Corrected use of the adUnitId field
      factoryId: 'listTile',
      // Your defined Factory ID for the ad layout
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
          analytics.logEvent(
              name: 'ad_loaded', parameters: {'ad_unit_id': ad.adUnitId});
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          analytics.logEvent(
              name: 'ad_load_failed',
              parameters: {'ad_unit_id': ad.adUnitId, 'error': error.message});
          FirebaseCrashlytics.instance.recordError(error, null);
          _retryLoadingAd(); // Call your retry method here
        },
        onAdClicked: (Ad ad) {
          analytics.logEvent(
              name: 'ad_clicked', parameters: {'ad_unit_id': ad.adUnitId});
        },
        onAdImpression: (Ad ad) {
          analytics.logEvent(
              name: 'ad_impression', parameters: {'ad_unit_id': ad.adUnitId});
        },
        onAdOpened: (Ad ad) {
          analytics.logEvent(
              name: 'ad_opened', parameters: {'ad_unit_id': ad.adUnitId});
        },
        onAdClosed: (Ad ad) {
          analytics.logEvent(
              name: 'ad_closed', parameters: {'ad_unit_id': ad.adUnitId});
        },
        onAdWillDismissScreen: (Ad ad) {
          // This event is specific to iOS
          analytics.logEvent(
              name: 'ad_will_dismiss_screen',
              parameters: {'ad_unit_id': ad.adUnitId});
        },
        onPaidEvent: (Ad ad, double valueMicros, PrecisionType precision,
            String currencyCode) {
          double revenue = valueMicros / 1e6;
          analytics.logEvent(
            name: 'ad_revenue',
            parameters: {
              'value': revenue,
              'currency': currencyCode,
              'precision': precision.toString(),
              'ad_unit_id': ad.adUnitId,
            },
          );
        },
      ),

      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.blueGrey,
        cornerRadius: 12.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.green,
          style: NativeTemplateFontStyle.bold,
          size: 14.0,
        ),
        // Define other text styles here...
      ),
    )..load();
  }

  void _retryLoadingAd() {
    // Exponential backoff formula for retry attempts
    final int delayMillis =
        min(pow(2, _retryAttempt) * 1000, 60000).toInt(); // Cap at 1 minute
    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(milliseconds: delayMillis), () {
      if (mounted) _loadAd();
    });
    _retryAttempt++;
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _retryTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? SizedBox(
            width: double.infinity,
            height: 300,
            child: AdWidget(ad: _nativeAd!),
          )
        : const SizedBox(); // Show an empty box if ad not loaded
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // No need to pause or resume NativeAd in Flutter.
  }
}
