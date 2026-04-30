import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  // ================= CONFIG =================
  static const String _androidBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerId = 'ca-app-pub-3940256099942544/2934735716';

  static String get bannerAdUnitId {
    if (Platform.isAndroid) return _androidBannerId;
    if (Platform.isIOS) return _iosBannerId;
    throw UnsupportedError('Unsupported platform');
  }

  // ================= STATE =================
  BannerAd? _cachedBanner;
  bool _isLoading = false;
  bool _isInitialized = false;

  int _retryCount = 0;
  static const int _maxRetries = 3;

  final Connectivity _connectivity = Connectivity();

  // ================= INIT =================
  Future<void> initializeAds() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;

      if (kDebugMode) {
        print('[AdMob] SDK initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[AdMob] Init error: $e');
      }
    }
  }

  // ================= INTERNET CHECK =================
  Future<bool> _hasInternet() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // ================= LOAD BANNER =================
  Future<BannerAd?> loadBannerAd({
    required double width,
    required VoidCallback onLoaded,
    required Function(LoadAdError error) onFailed,
  }) async {
    // 🚫 No ads if no internet
    final hasInternet = await _hasInternet();
    if (!hasInternet) {
      if (kDebugMode) {
        print('[AdMob] No internet → skipping ad load');
      }
      return null;
    }

    // ♻️ Return cached ad if available
    if (_cachedBanner != null) {
      return _cachedBanner;
    }

    // 🚫 Prevent duplicate loads
    if (_isLoading) return null;

    _isLoading = true;

    final adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width.toInt(),
    );

    if (adSize == null) {
      _isLoading = false;
      return null;
    }

    final banner = BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _cachedBanner = ad as BannerAd;
          _isLoading = false;
          _retryCount = 0;

          if (kDebugMode) {
            print('[AdMob] Banner loaded');
          }

          onLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isLoading = false;

          if (kDebugMode) {
            print('[AdMob] Load failed: $error');
          }

          // 🔁 Retry logic (exponential backoff)
          if (_retryCount < _maxRetries) {
            _retryCount++;
            final delay = Duration(seconds: 2 * _retryCount);

            Future.delayed(delay, () {
              loadBannerAd(
                width: width,
                onLoaded: onLoaded,
                onFailed: onFailed,
              );
            });
          }

          onFailed(error);
        },
      ),
    );

    await banner.load();
    return banner;
  }

  // ================= GET CACHED =================
  BannerAd? get bannerAd => _cachedBanner;

  // ================= DISPOSE =================
  Future<void> disposeBannerAd() async {
    try {
      await _cachedBanner?.dispose();
      _cachedBanner = null;

      if (kDebugMode) {
        print('[AdMob] Banner disposed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[AdMob] Dispose error: $e');
      }
    }
  }

  // ================= CONTROL =================
  bool shouldShowAds() {
    // Extend for premium users later
    return true;
  }
}