import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/alphabet_data.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';
import '../../widgets/common/ad_banner_widget.dart';
import '../../widgets/learn/info_header.dart';
import '../../widgets/learn/tappable_card.dart';
import '../../widgets/learn/tap_overlay.dart';

class _TappedLetterNotifier extends Notifier<AlphabetItem?> {
  @override
  AlphabetItem? build() => null;
  void set(AlphabetItem? item) => state = item;
}

final _tappedLetterProvider =
    NotifierProvider<_TappedLetterNotifier, AlphabetItem?>(
      _TappedLetterNotifier.new,
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

class AlphabetsScreen extends ConsumerWidget {
  const AlphabetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapped = ref.watch(_tappedLetterProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(
        title: 'Alphabets',
        gradientColors: AppColors.alphabetGradient,
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                const AdBannerWidget(),
                const InfoHeader(label: 'A to Z  —  26 letters'),
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
                    itemCount: alphabetData.length,
                    itemBuilder: (context, index) {
                      final item = alphabetData[index];
                      final isActive = tapped?.letter == item.letter;
                      return RepaintBoundary(
                        child: TappableCard(
                          colorIndex: index,
                          isActive: isActive,
                          animIndex: index,
                          borderRadius: 20,
                          onTap: (position) async {
                            ref.read(_tappedPositionProvider.notifier).set(position);
                            ref.read(_tappedLetterProvider.notifier).set(item);
                            ref.read(ttsServiceProvider).speak(item.ttsPhrase);
                            await Future.delayed(AppConstants.itemPopupDuration);
                            if (ref.read(_tappedLetterProvider)?.letter == item.letter) {
                              ref.read(_tappedLetterProvider.notifier).set(null);
                            }
                          },
                          builder: (color, active) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.emoji, style: const TextStyle(fontSize: 42)),
                              const SizedBox(height: 8),
                              Text(
                                item.letter,
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: active ? Colors.white : color,
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
                          ),
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
              width: 260,
              color: AppColors.letterColors[
                alphabetData.indexWhere((e) => e.letter == tapped.letter) %
                AppColors.letterColors.length
              ],
              onDismiss: () => ref.read(_tappedLetterProvider.notifier).set(null),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(tapped.emoji, style: const TextStyle(fontSize: 72)),
                  const SizedBox(height: 8),
                  Text(
                    tapped.letter,
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tapped.ttsPhrase,
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
        ],
      ),
    );
  }
}
