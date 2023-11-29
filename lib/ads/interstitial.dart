import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  static int _numRetryAttemptsForConnectivity = 0;
  static const int maxFailedLoadAttempts = 3;
  static const int maxRetryAttemptsForConnectivity = 3;
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final Connectivity _connectivity = Connectivity();
  static Timer? _connectivityRetryTimer;
  static DateTime? _lastAdShownTime;
  static const Duration _cooldownPeriod = Duration(minutes: 3);

  static void loadInterstitialAd() {
    var connectivityResult = _connectivity.checkConnectivity();
    connectivityResult.then((result) {
      if (result == ConnectivityResult.none) {
        _scheduleRetry();
        return;
      }

      InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _setAdCallbacks();
            _analytics.logEvent(name: 'interstitial_ad_loaded');
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts++;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _scheduleRetry(error: error);
            }
          },
        ),
      );
    });
  }

  static void _scheduleRetry({LoadAdError? error}) {
    if (error != null) {
      _analytics.logEvent(
        name: 'interstitial_retry_scheduled',
        parameters: {'error': error.toString()},
      );
    }

    // Calculate delay with a cap of 60 seconds
    int delayMillis = min((2 ^ _numRetryAttemptsForConnectivity) * 1000, 60000);
    _connectivityRetryTimer?.cancel();
    _connectivityRetryTimer = Timer(Duration(milliseconds: delayMillis), () {
      _numRetryAttemptsForConnectivity =
          0; // Reset retry attempts on successful connectivity and retry load
      loadInterstitialAd();
    });
  }

  static void _setAdCallbacks() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        _lastAdShownTime = DateTime.now();
        _analytics.logEvent(name: 'interstitial_ad_showed_full_screen');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        loadInterstitialAd();
        _analytics.logEvent(name: 'interstitial_ad_dismissed_full_screen');
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        loadInterstitialAd();
        _analytics.logEvent(
          name: 'interstitial_ad_failed_to_show_full_screen',
          parameters: {'error': error.toString()},
        );
      },
      onAdImpression: (InterstitialAd ad) {
        _analytics.logEvent(name: 'interstitial_ad_impression');
      },
      onAdWillDismissFullScreenContent: (InterstitialAd ad) {
        _analytics.logEvent(name: 'interstitial_ad_will_dismiss_full_screen');
      },
    );
  }

  static bool isAdReady() {
    return _interstitialAd != null && _isAdCooldownComplete();
  }

  static bool _isAdCooldownComplete() {
    if (_lastAdShownTime == null) return true;
    bool cooldownComplete =
        DateTime.now().difference(_lastAdShownTime!) > _cooldownPeriod;
    if (!cooldownComplete) {
      _analytics.logEvent(name: 'interstitial_ad_cooldown_active');
    }
    return cooldownComplete;
  }

  static void showInterstitialAd({required Function onAdClosed}) {
    if (isAdReady()) {
      _interstitialAd!.show();
      _interstitialAd = null; // Set to null to prepare for the next ad load.
    } else {
      _analytics.logEvent(name: 'interstitial_ad_not_ready');
      onAdClosed();
    }
  }

  // User segmentation for personalized ad experiences
  static void updateUserSegment(String segment) {
    // This would likely involve backend logic to segment users
    // Here we are just logging the segment for analytics
    _analytics.setUserProperty(name: 'ad_segment', value: segment);
  }

  // A/B testing for ad types, placements, and frequencies
  static void runABTest(String testName) {
    // This is typically managed by a backend or a specialized A/B testing service
    // For the mobile client, just log the test name for now
    _analytics.logEvent(
      name: 'ab_test_started',
      parameters: {'test_name': testName},
    );
  }

  // Quality of service monitoring for ads
  static bool checkAdQuality(Ad ad) {
    // This would involve real-time analysis and reporting
    // For demonstration, we assume all ads are of high quality
    bool isAdHighQuality = true;
    _analytics.logEvent(
      name: 'ad_quality_check',
      parameters: {'ad_quality': isAdHighQuality},
    );
    return isAdHighQuality;
  }

  // Network quality checks
  static void checkNetworkQuality() {
    // Actual network quality check would require more than just connectivity status
    // Here, we just log a placeholder event for network check
    _analytics.logEvent(name: 'network_quality_check');
  }
}
