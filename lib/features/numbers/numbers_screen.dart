import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/number_data.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';
import '../../widgets/common/ad_banner_widget.dart';
import '../../widgets/learn/info_header.dart';
import '../../widgets/learn/tappable_card.dart';
import '../../widgets/learn/tap_overlay.dart';

class _TappedNumberNotifier extends Notifier<NumberItem?> {
  @override
  NumberItem? build() => null;
  void set(NumberItem? item) => state = item;
}

final _tappedNumberProvider =
    NotifierProvider<_TappedNumberNotifier, NumberItem?>(
      _TappedNumberNotifier.new,
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

const List<List<Color>> _numberPalette = [
  [Color(0xFFFF1744), Color(0xFFFF8A80)],
  [Color(0xFFFF6D00), Color(0xFFFFAB40)],
  [Color(0xFFFFD600), Color(0xFFFFFF8D)],
  [Color(0xFF00C853), Color(0xFFB9F6CA)],
  [Color(0xFF2979FF), Color(0xFF82B1FF)],
  [Color(0xFFAA00FF), Color(0xFFEA80FC)],
  [Color(0xFFFF4081), Color(0xFFFF80AB)],
  [Color(0xFF00BFA5), Color(0xFFA7FFEB)],
  [Color(0xFFFF6D00), Color(0xFFFFD180)],
  [Color(0xFF304FFE), Color(0xFF536DFE)],
];

class NumbersScreen extends ConsumerWidget {
  const NumbersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapped = ref.watch(_tappedNumberProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(
        title: 'Numbers',
        gradientColors: AppColors.numberGradient,
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                const AdBannerWidget(),
                const InfoHeader(
                  label: '1 to 20 — counting fun!',
                  badgeText: 'Tap to count! 🎵',
                  badgeColor: AppColors.secondary,
                ),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: numberData.length,
                    itemBuilder: (context, index) {
                      final item = numberData[index];
                      final colors = _numberPalette[index % _numberPalette.length];
                      final isActive = tapped?.number == item.number;
                      return RepaintBoundary(
                        child: TappableCard(
                          colorIndex: index,
                          isActive: isActive,
                          animIndex: index,
                          borderRadius: 20,
                          animDelayMs: 40,
                          beginScale: 0.6,
                          onTap: (position) async {
                            ref.read(_tappedPositionProvider.notifier).set(position);
                            ref.read(_tappedNumberProvider.notifier).set(item);
                            ref.read(ttsServiceProvider).speak(item.ttsPhrase);
                            await Future.delayed(AppConstants.itemPopupDuration);
                            if (ref.read(_tappedNumberProvider)?.number == item.number) {
                              ref.read(_tappedNumberProvider.notifier).set(null);
                            }
                          },
                          builder: (color, active) {
                            final c = colors[0];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (item.number <= 5)
                                  _DotDisplay(
                                    count: item.number,
                                    color: active ? Colors.white : c,
                                  )
                                else
                                  Text(item.emoji, style: const TextStyle(fontSize: 42)),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.number}',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: active ? Colors.white : c,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  item.word,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: active ? Colors.white70 : AppColors.textLight,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (tapped != null)
            TapOverlay(
              width: 240,
              color: _numberPalette[
                numberData.indexWhere((n) => n.number == tapped.number) %
                _numberPalette.length
              ][0],
              onDismiss: () => ref.read(_tappedNumberProvider.notifier).set(null),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(tapped.emoji, style: const TextStyle(fontSize: 60)),
                  const SizedBox(height: 8),
                  Text(
                    '${tapped.number}',
                    style: const TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tapped.word,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DotDisplay extends StatelessWidget {
  final int count;
  final Color color;
  const _DotDisplay({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 3,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
        (_) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
