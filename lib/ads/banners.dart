// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAdWidget extends StatefulWidget {
  final String adUnitId;

  const MyBannerAdWidget({super.key, required this.adUnitId});

  @override
  _MyBannerAdWidgetState createState() => _MyBannerAdWidgetState();
}

class _MyBannerAdWidgetState extends State<MyBannerAdWidget> {
  BannerAd? _bannerAd;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  Timer? _retryTimer;
  AdSize? _adSize;
  final String adUnitId = Platform.isAndroid
      ? 'ca-app-pub-1257505778072677/5857662459' // Replace with your Android ad unit ID
      : 'ca-app-pub-1257505778072677/2078253449'; // Replace with your iOS ad unit ID
  int _retryAttempt = 0; // Add this to track the number of retries
  void _createBannerAd() {
    AdSize.getAnchoredAdaptiveBannerAdSize(
            Orientation.portrait, MediaQuery.of(context).size.width.toInt())
        .then((size) {
      _adSize = size;
      if (_adSize == null) return;

      _bannerAd = BannerAd(
        size: _adSize!,
        adUnitId: widget.adUnitId,
        listener: BannerAdListener(
            onAdLoaded: (Ad ad) {
              setState(() {
                _adSize = (ad as BannerAd).size;
              });
              analytics.logEvent(name: 'ad_loaded', parameters: {
                'type': 'banner',
                'size': '${_adSize?.width}x${_adSize?.height}',
              });
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
              analytics.logEvent(name: 'ad_failed_to_load', parameters: {
                'type': 'banner',
                'error': error.toString(),
              });
              FirebaseCrashlytics.instance.recordError(error, null);
              // Implement exponential backoff by doubling the wait time after each failure, up to a limit
              int backoffMillis = (500 * pow(2, _retryAttempt))
                  .toInt()
                  .clamp(500, 32000); // Clamp between 500ms and 32 seconds
              if (_retryTimer?.isActive ?? false) {
                _retryTimer!.cancel();
              }
              _retryTimer = Timer(Duration(milliseconds: backoffMillis), () {
                if (mounted) {
                  _createBannerAd();
                }
              });
              _retryAttempt++; // Increase the retry attempt counter
            },
            onAdOpened: (Ad ad) => analytics.logEvent(name: 'ad_opened'),
            onAdClosed: (Ad ad) => analytics.logEvent(name: 'ad_closed'),
            onAdImpression: (Ad ad) =>
                analytics.logEvent(name: 'ad_impression'),
            onAdWillDismissScreen: (Ad ad) =>
                analytics.logEvent(name: 'ad_will_dismiss_screen'),
            onAdClicked: (Ad ad) => analytics.logEvent(name: 'ad_clicked'),
            onPaidEvent: (Ad ad, double value, PrecisionType precision,
                String currencyCode) {
              analytics.logEvent(name: 'ad_paid_event', parameters: {
                'value': value,
                'precision': precision.toString(),
                'currency': currencyCode,
              });
            }),
        request: const AdRequest(),
      )..load();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _createBannerAd());
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: _adSize?.width.toDouble(),
      height: _adSize?.height.toDouble(),
      child: _adSize != null && _bannerAd != null
          ? AdWidget(ad: _bannerAd!)
          : const SizedBox(),
    );
  }
}
