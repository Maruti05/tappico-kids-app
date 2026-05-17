import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/vegetable_data.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';
import '../../widgets/common/ad_banner_widget.dart';
import '../../widgets/learn/info_header.dart';
import '../../widgets/learn/tappable_card.dart';
import '../../widgets/learn/tap_overlay.dart';

class _TappedVegetableNotifier extends Notifier<VegetableItem?> {
  @override
  VegetableItem? build() => null;
  void set(VegetableItem? item) => state = item;
}

final _tappedVegetableProvider = NotifierProvider<_TappedVegetableNotifier, VegetableItem?>(
  _TappedVegetableNotifier.new,
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

class VegetablesScreen extends ConsumerWidget {
  const VegetablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapped = ref.watch(_tappedVegetableProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(
        title: 'Vegetables',
        gradientColors: AppColors.vegetableGradient,
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                const AdBannerWidget(),
                const InfoHeader(label: 'Eat your veggies! 🥦'),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: AppConstants.itemCrossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.5,
                        ),
                    itemCount: vegetableData.length,
                    itemBuilder: (context, index) {
                      final item = vegetableData[index];
                      final isActive = tapped?.name == item.name;
                      return RepaintBoundary(
                        child: TappableCard(
                          colorIndex: index,
                          isActive: isActive,
                          animIndex: index,
                          onTap: (position) async {
                            ref.read(_tappedPositionProvider.notifier).set(position);
                            ref.read(_tappedVegetableProvider.notifier).set(item);
                            ref.read(ttsServiceProvider).speak(item.ttsPhrase);
                            await Future.delayed(AppConstants.itemPopupDuration);
                            if (ref.read(_tappedVegetableProvider)?.name == item.name) {
                              ref.read(_tappedVegetableProvider.notifier).set(null);
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
                ),
              ],
            ),
          ),
          if (tapped != null)
            TapOverlay(
              color: AppColors.letterColors[
                vegetableData.indexWhere((e) => e.name == tapped.name) %
                AppColors.letterColors.length
              ],
              onDismiss: () => ref.read(_tappedVegetableProvider.notifier).set(null),
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
