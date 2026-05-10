// lib/features/birds/birds_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/bird_data.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';
import '../../widgets/common/ad_banner_widget.dart';

class _TappedBirdNotifier extends Notifier<BirdItem?> {
  @override
  BirdItem? build() => null;
  void set(BirdItem? item) => state = item;
}

final _tappedBirdProvider = NotifierProvider<_TappedBirdNotifier, BirdItem?>(
  _TappedBirdNotifier.new,
);

class _TappedPositionNotifier extends Notifier<Offset?> {
  @override
  Offset? build() => null;
  void set(Offset? position) => state = position;
}

final _tappedPositionProvider =
    NotifierProvider<_TappedPositionNotifier, Offset?>(
      _TappedPositionNotifier.new,
    );

class BirdsScreen extends ConsumerWidget {
  const BirdsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapped = ref.watch(_tappedBirdProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(
        title: 'Birds',
        gradientColors: AppColors.birdsGradient,
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                const AdBannerWidget(),
                // Info header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Row(
                    children: [
                      Text(
                        'Learn your birds! 🦉',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tap to hear! 👂',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Grid
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: AppConstants.birdCrossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.5,
                        ),
                    itemCount: birdData.length,
                    itemBuilder: (context, index) {
                      final item = birdData[index];
                      final isActive = tapped?.name == item.name;
                      return _BirdCard(
                        item: item,
                        colorIndex: index % AppColors.letterColors.length,
                        isActive: isActive,
                        animIndex: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tap overlay popup
          if (tapped != null)
            _TapOverlay(
              item: tapped,
              origin: ref.watch(_tappedPositionProvider),
            ),
        ],
      ),
    );
  }
}

class _BirdCard extends ConsumerStatefulWidget {
  final BirdItem item;
  final int colorIndex;
  final bool isActive;
  final int animIndex;

  const _BirdCard({
    required this.item,
    required this.colorIndex,
    required this.isActive,
    required this.animIndex,
  });

  @override
  ConsumerState<_BirdCard> createState() => _BirdCardState();
}

class _BirdCardState extends ConsumerState<_BirdCard> {
  final GlobalKey _key = GlobalKey();

  Offset? get position {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return Offset(offset.dx + size.width / 2, offset.dy + size.height / 2);
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.letterColors[widget.colorIndex];

    return Animate(
      effects: [
        FadeEffect(duration: 300.ms, delay: (widget.animIndex * 30).ms),
        ScaleEffect(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1, 1),
          duration: 400.ms,
          delay: (widget.animIndex * 30).ms,
          curve: Curves.easeOutBack,
        ),
      ],
      child: GestureDetector(
        onTap: () async {
          ref.read(_tappedPositionProvider.notifier).set(position);
          ref.read(_tappedBirdProvider.notifier).set(widget.item);
          ref.read(ttsServiceProvider).speak(widget.item.ttsPhrase);
          await Future.delayed(const Duration(milliseconds: 2200));
          if (ref.read(_tappedBirdProvider)?.name == widget.item.name) {
            ref.read(_tappedBirdProvider.notifier).set(null);
          }
        },
        child: AnimatedContainer(
          key: _key,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.isActive ? color : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: color, width: widget.isActive ? 0 : 2.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(widget.isActive ? 0.45 : 0.18),
                blurRadius: widget.isActive ? 18 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // Emoji
                Text(widget.item.emoji, style: const TextStyle(fontSize: 56)),
                const SizedBox(width: 24),
                // Name
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: widget.isActive ? Colors.white : color,
                      height: 1,
                    ),
                  ),
                ),
                // Speaker icon
                Icon(
                  Icons.volume_up_rounded,
                  color: widget.isActive
                      ? Colors.white70
                      : color.withOpacity(0.5),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TapOverlay extends ConsumerStatefulWidget {
  final BirdItem item;
  final Offset? origin;
  const _TapOverlay({required this.item, this.origin});

  @override
  ConsumerState<_TapOverlay> createState() => _TapOverlayState();
}

class _TapOverlayState extends ConsumerState<_TapOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        AppColors.letterColors[birdData.indexWhere(
              (e) => e.name == widget.item.name,
            ) %
            AppColors.letterColors.length];

    return GestureDetector(
      onTap: () => ref.read(_tappedBirdProvider.notifier).set(null),
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.item.emoji,
                    style: const TextStyle(fontSize: 100),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.item.ttsPhrase,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
