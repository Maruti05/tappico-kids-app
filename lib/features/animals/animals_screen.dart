import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/animal_data.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';
import '../../widgets/common/ad_banner_widget.dart';
import '../../widgets/learn/info_header.dart';
import '../../widgets/learn/section_header.dart';
import '../../widgets/learn/tappable_card.dart';
import '../../widgets/learn/tap_overlay.dart';

class _TappedAnimalNotifier extends Notifier<AnimalItem?> {
  @override
  AnimalItem? build() => null;
  void set(AnimalItem? item) => state = item;
}

final _tappedAnimalProvider = NotifierProvider<_TappedAnimalNotifier, AnimalItem?>(
  _TappedAnimalNotifier.new,
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

class AnimalsScreen extends ConsumerWidget {
  const AnimalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapped = ref.watch(_tappedAnimalProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(
        title: 'Animals',
        gradientColors: AppColors.animalsGradient,
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                const AdBannerWidget(),
                const InfoHeader(label: 'Discover animals! 🐾'),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          emoji: '🏠',
                          title: 'Domestic Animals',
                          countLabel: '16 animals',
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: AppConstants.animalCrossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 2.5,
                              ),
                          itemCount: domesticAnimalData.length,
                          itemBuilder: (context, index) {
                            final item = domesticAnimalData[index];
                            final isActive = tapped?.name == item.name;
                            return RepaintBoundary(
                              child: TappableCard(
                                colorIndex: animalData.indexOf(item) % AppColors.letterColors.length,
                                isActive: isActive,
                                animIndex: index,
                                onTap: (position) async {
                                  ref.read(_tappedPositionProvider.notifier).set(position);
                                  ref.read(_tappedAnimalProvider.notifier).set(item);
                                  ref.read(ttsServiceProvider).speak(item.ttsPhrase);
                                  await Future.delayed(AppConstants.itemPopupDuration);
                                  if (ref.read(_tappedAnimalProvider)?.name == item.name) {
                                    ref.read(_tappedAnimalProvider.notifier).set(null);
                                  }
                                },
                                builder: (color, active) => TappableCardRow(
                                  emoji: item.emoji,
                                  name: item.name,
                                  color: color,
                                  isActive: active,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        const SectionHeader(
                          emoji: '🌿',
                          title: 'Wild Animals',
                          countLabel: '31 animals',
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: AppConstants.animalCrossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 2.5,
                              ),
                          itemCount: wildAnimalData.length,
                          itemBuilder: (context, index) {
                            final item = wildAnimalData[index];
                            final isActive = tapped?.name == item.name;
                            return RepaintBoundary(
                              child: TappableCard(
                                colorIndex: animalData.indexOf(item) % AppColors.letterColors.length,
                                isActive: isActive,
                                animIndex: domesticAnimalData.length + index,
                                onTap: (position) async {
                                  ref.read(_tappedPositionProvider.notifier).set(position);
                                  ref.read(_tappedAnimalProvider.notifier).set(item);
                                  ref.read(ttsServiceProvider).speak(item.ttsPhrase);
                                  await Future.delayed(AppConstants.itemPopupDuration);
                                  if (ref.read(_tappedAnimalProvider)?.name == item.name) {
                                    ref.read(_tappedAnimalProvider.notifier).set(null);
                                  }
                                },
                                builder: (color, active) => TappableCardRow(
                                  emoji: item.emoji,
                                  name: item.name,
                                  color: color,
                                  isActive: active,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (tapped != null)
            TapOverlay(
              color: AppColors.letterColors[
                animalData.indexWhere((e) => e.name == tapped.name) %
                AppColors.letterColors.length
              ],
              onDismiss: () => ref.read(_tappedAnimalProvider.notifier).set(null),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(tapped.emoji, style: const TextStyle(fontSize: 100)),
                  const SizedBox(height: 20),
                  Text(
                    tapped.name,
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
