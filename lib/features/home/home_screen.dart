// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/alphabet_data.dart';
import '../../core/constants/number_data.dart';
import '../../core/constants/fruit_data.dart';
import '../../core/constants/bird_data.dart';
import '../../core/constants/animal_data.dart';
import '../../core/constants/color_data.dart';
import '../../core/constants/vehicle_data.dart';
import '../../core/constants/body_part_data.dart';
import '../../core/constants/vegetable_data.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/gradient_card.dart';
import '../../widgets/common/tappico_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(
        title: 'TapPico',
        showSettings: true,
        gradientColors: AppColors.homeGradient,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner
              _WelcomeBanner()
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: -0.1, curve: Curves.easeOutCubic),

              const SizedBox(height: 24),

              // Section label
              Text(
                'What do you want to learn?',
                style: Theme.of(context).textTheme.headlineMedium,
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // 2-column grid of category cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.88,
                children: [
                  GradientCategoryCard(
                    title: 'Alphabets',
                    emoji: '🔤',
                    subtitle: 'A to Z • 26 letters',
                    gradient: AppColors.alphabetGradient,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.alphabetsRoute,
                    ),
                    animIndex: 0,
                  ),
                  GradientCategoryCard(
                    title: 'Numbers',
                    emoji: '🔢',
                    subtitle: '1 to 20 • counting',
                    gradient: AppColors.numberGradient,
                    onTap: () =>
                        Navigator.pushNamed(context, AppConstants.numbersRoute),
                    animIndex: 1,
                  ),
                  GradientCategoryCard(
                    title: 'Shapes',
                    emoji: '🔷',
                    subtitle: '8 shapes to learn',
                    gradient: AppColors.shapeGradient,
                    onTap: () =>
                        Navigator.pushNamed(context, AppConstants.shapesRoute),
                    animIndex: 2,
                  ),
                  GradientCategoryCard(
                    title: 'Fruits',
                    emoji: '🍎',
                    subtitle: 'Tasty & Healthy',
                    gradient: AppColors.fruitsGradient,
                    onTap: () =>
                        Navigator.pushNamed(context, AppConstants.fruitsRoute),
                    animIndex: 3,
                  ),
                  GradientCategoryCard(
                    title: 'Birds',
                    emoji: '🦜',
                    subtitle: 'Feathered Friends',
                    gradient: AppColors.birdsGradient,
                    onTap: () =>
                        Navigator.pushNamed(context, AppConstants.birdsRoute),
                    animIndex: 4,
                  ),
                  GradientCategoryCard(
                    title: 'Domestic',
                    emoji: '🏠',
                    subtitle: '16 friendly pets',
                    gradient: AppColors.domesticGradient,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.domesticAnimalsRoute,
                    ),
                    animIndex: 5,
                  ),
                  GradientCategoryCard(
                    title: 'Wild',
                    emoji: '🌿',
                    subtitle: '31 wild animals',
                    gradient: AppColors.wildGradient,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.wildAnimalsRoute,
                    ),
                    animIndex: 6,
                  ),
                  GradientCategoryCard(
                    title: 'Insects',
                    emoji: '🐛',
                    subtitle: 'Bugs & critters',
                    gradient: AppColors.insectGradient,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.insectsRoute,
                    ),
                    animIndex: 7,
                  ),
                  GradientCategoryCard(
                    title: 'Colors',
                    emoji: '🌈',
                    subtitle: '9 colors to learn',
                    gradient: AppColors.colorGradient,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.colorsRoute,
                    ),
                    animIndex: 8,
                  ),
                  GradientCategoryCard(
                    title: 'Vehicles',
                    emoji: '🚗',
                    subtitle: 'Vroom vroom!',
                    gradient: AppColors.vehicleGradient,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.vehiclesRoute,
                    ),
                    animIndex: 9,
                  ),
                  GradientCategoryCard(
                    title: 'Body Parts',
                    emoji: '🧍',
                    subtitle: 'Head to toe',
                    gradient: AppColors.bodyPartGradient,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.bodyPartsRoute,
                    ),
                    animIndex: 10,
                  ),
                  GradientCategoryCard(
                    title: 'Vegetables',
                    emoji: '🥦',
                    subtitle: '13 healthy eats',
                    gradient: AppColors.vegetableGradient,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.vegetablesRoute,
                    ),
                    animIndex: 11,
                  ),
                  GradientCategoryCard(
                    title: 'Practice',
                    emoji: '🏆',
                    subtitle: 'Quiz yourself!',
                    gradient: AppColors.practiceGradient,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppConstants.practiceRoute,
                    ),
                    animIndex: 12,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Fun facts strip
              _FunFactsStrip()
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 500.ms)
                  .slideY(begin: 0.1, curve: Curves.easeOutCubic),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    final emoji = hour < 12
        ? '🌅'
        : hour < 17
        ? '☀️'
        : '🌙';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD600), Color(0xFFFF6D00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6D00).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting! $emoji',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ready to\nlearn today?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Text('🚀', style: TextStyle(fontSize: 64)),
        ],
      ),
    );
  }
}

class _FunFactsStrip extends StatelessWidget {
  List<_FactItem> get facts => [
    _FactItem('🌟', '${alphabetData.length} Letters', 'A to Z alphabet'),
    _FactItem('🔢', '${numberData.length} Numbers', 'Count with fun'),
    _FactItem('🍎', '${fruitData.length} Fruits', 'Healthy & sweet'),
    _FactItem('🦜', '${birdData.length} Birds', 'Soaring high'),
    _FactItem('🏠', '${domesticAnimalData.length} Domestic', 'Friendly pets'),
    _FactItem('🌿', '${wildAnimalData.length} Wild', 'Safari animals'),
    _FactItem('🐛', '${insectAnimalData.length} Insects', 'Bugs & critters'),
    _FactItem('🔷', '${shapeData.length} Shapes', 'All around us'),
    _FactItem('🌈', '${colorData.length} Colors', 'Rainbow & bright'),
    _FactItem('🚗', '${vehicleData.length} Vehicles', 'Vroom vroom!'),
    _FactItem('🧍', '${bodyPartData.length} Body Parts', 'Head to toe'),
    _FactItem('🥦', '${vegetableData.length} Veggies', 'Healthy eats'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Stats', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const double spacing = 8;
            const double minItemWidth = 82;
            final maxWidth = constraints.maxWidth;
            final crossAxisCount = ((maxWidth + spacing) / (minItemWidth + spacing))
                .floor()
                .clamp(1, facts.length);
            final itemWidth = (maxWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: facts
                  .map(
                    (f) => Container(
                      width: itemWidth,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(f.emoji, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 4),
                          Text(
                            f.label,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _FactItem {
  final String emoji, label, sub;
  const _FactItem(this.emoji, this.label, this.sub);
}
