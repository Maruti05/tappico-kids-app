import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tappico/services/admob_service.dart';

class AdBannerWidget extends StatefulWidget {
  final EdgeInsets padding;
  final bool showDivider;

  const AdBannerWidget({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 0),
    this.showDivider = false,
  });

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget>
    with WidgetsBindingObserver {
  final AdMobService _adService = AdMobService();

  BannerAd? _bannerAd;
  bool _isVisible = false;
  double _adHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Delay load to avoid blocking UI frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAd();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ================= LIFECYCLE =================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _bannerAd == null) {
      _initAd(); // reload if needed
    }
  }

  // ================= INIT =================
  Future<void> _initAd() async {
    if (!_adService.shouldShowAds()) return;

    final width = MediaQuery.of(context).size.width;

    final ad = await _adService.loadBannerAd(
      width: width,
      onLoaded: () {
        if (!mounted) return;

        final loadedAd = _adService.bannerAd;

        if (loadedAd == null) return;

        setState(() {
          _bannerAd = loadedAd;
          _adHeight = loadedAd.size.height.toDouble();
          _isVisible = true;
        });
      },
      onFailed: (error) {
        if (kDebugMode) {
          print('[AdWidget] Load failed: ${error.message}');
        }

        // Silent fail → no UI shown
        if (!mounted) return;
        setState(() {
          _isVisible = false;
        });
      },
    );

    // If cached ad exists immediately
    if (ad != null && mounted) {
      setState(() {
        _bannerAd = ad;
        _adHeight = ad.size.height.toDouble();
        _isVisible = true;
      });
    }
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    // 🚫 No ad → no UI (important for kids UX)
    if (!_isVisible || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showDivider)
          Divider(
            height: 1,
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.2),
          ),

        Padding(
          padding: widget.padding,
          child: SizedBox(
            width: double.infinity,
            height: _adHeight,
            child: AdWidget(ad: _bannerAd!),
          ),
        ),

        if (widget.showDivider)
          Divider(
            height: 1,
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.2),
          ),
      ],
    );
  }
}
