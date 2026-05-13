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
  bool _isLoading = false;
  double _adHeight = 0;
  double _adWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _bannerAd == null) {
      _initAd();
    }
  }

  Future<void> _initAd([double? availableWidth]) async {
    if (!_adService.shouldShowAds()) return;

    final width = availableWidth ?? MediaQuery.of(context).size.width;

    final ad = await _adService.loadBannerAd(
      width: width,
      onLoaded: () {
        if (!mounted) return;
        final loadedAd = _adService.bannerAd;
        if (loadedAd == null) return;
        setState(() {
          _bannerAd = loadedAd;
          _adHeight = loadedAd.size.height.toDouble();
          _adWidth = loadedAd.size.width.toDouble();
          _isLoading = false;
        });
      },
      onFailed: (error) {
        if (kDebugMode) {
          print('[AdWidget] Load failed: ${error.message}');
        }
        if (!mounted) return;
        setState(() { _isLoading = false; });
      },
    );

    if (ad != null && mounted) {
      setState(() {
        _bannerAd = ad;
        _adHeight = ad.size.height.toDouble();
        _adWidth = ad.size.width.toDouble();
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - widget.padding.horizontal;
        if (_bannerAd == null && !_isLoading) {
          if (availableWidth > 0) {
            _isLoading = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || _bannerAd != null) return;
              _initAd(availableWidth);
            });
          }
          return const SizedBox.shrink();
        }

        if (_adWidth > availableWidth) {
          return const SizedBox.shrink();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showDivider)
              Divider(
                height: 1,
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.2),
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
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.2),
              ),
          ],
        );
      },
    );
  }
}
