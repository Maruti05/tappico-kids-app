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
  static const String _androidBannerId =
      'ca-app-pub-3940256099942544/6300978111';
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
  Completer<void>? _initCompleter;

  int _retryCount = 0;
  static const int _maxRetries = 3;

  final Connectivity _connectivity = Connectivity();

  // ================= INIT =================
  Future<void> initializeAds() async {
    if (_isInitialized) return;
    if (_initCompleter != null) return _initCompleter!.future;

    _initCompleter = Completer<void>();

    try {
      if (kDebugMode) {
        print('[AdMob] Starting SDK initialization...');
      }
      final status = await MobileAds.instance.initialize();
      _isInitialized = true;
      _initCompleter?.complete();

      if (kDebugMode) {
        print('[AdMob] SDK initialized: ${status.adapterStatuses}');
      }
    } catch (e) {
      _isInitialized = false;
      // Complete without error so we don't crash main()
      _initCompleter?.complete();
      if (kDebugMode) {
        print('[AdMob] Init error: $e');
      }
    } finally {
      _initCompleter = null;
    }
  }

  bool get isInitialized => _isInitialized;

  // ================= INTERNET CHECK =================
  Future<bool> _hasInternet() async {
    try {
      final results = await _connectivity.checkConnectivity();
      // In connectivity_plus v6+, checkConnectivity returns List<ConnectivityResult>
      if (results.isEmpty) return false;
      return !results.contains(ConnectivityResult.none);
    } catch (e) {
      if (kDebugMode) print('[AdMob] Connectivity check failed: $e');
      return false;
    }
  }

  // ================= LOAD BANNER =================
  Future<BannerAd?> loadBannerAd({
    required double width,
    required VoidCallback onLoaded,
    required Function(LoadAdError error) onFailed,
  }) async {
    // 🛠️ Ensure initialized
    if (!_isInitialized) {
      try {
        await initializeAds();
      } catch (e) {
        if (kDebugMode) print('[AdMob] Initialization failed during load: $e');
        return null;
      }
      
      if (!_isInitialized) {
        if (kDebugMode) {
          print('[AdMob] Still not initialized → skipping ad load');
        }
        return null;
      }
    }

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

    try {
      final adSize = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
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
              print('[AdMob] Banner loaded successfully');
            }

            onLoaded();
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            _isLoading = false;

            if (kDebugMode) {
              print('[AdMob] Load failed with error: $error');
            }

            // 🔁 Retry logic (exponential backoff)
            if (_retryCount < _maxRetries) {
              _retryCount++;
              final delay = Duration(seconds: 2 * _retryCount);

              if (kDebugMode) {
                print('[AdMob] Retrying in ${delay.inSeconds}s (Attempt $_retryCount/$_maxRetries)');
              }

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

      // 🛡️ Wrap load in try-catch to handle platform-level engine errors
      await banner.load();
      return banner;
    } catch (e) {
      _isLoading = false;
      if (kDebugMode) {
        print('[AdMob] Critical error during banner load: $e');
      }
      return null;
    }
  }

  // ================= GET CACHED =================
  BannerAd? get bannerAd => _cachedBanner;

  // ================= DISPOSE =================
  Future<void> disposeBannerAd() async {
    try {
      await _cachedBanner?.dispose();
      _cachedBanner = null;
      _isLoading = false;

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

