// lib/features/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundEnabled = ref.watch(soundProvider);
    final speechRate = ref.watch(speechRateProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(title: 'Settings', showSettings: false),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            const _AppInfoCard()
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.1, curve: Curves.easeOutCubic),

            const SizedBox(height: 24),

            const _SectionTitle('Audio Settings'),
            const SizedBox(height: 12),

            _SettingsCard(
              animIndex: 0,
              child: Column(
                children: [
                  _SettingRow(
                    icon: soundEnabled
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                    iconColor:
                        soundEnabled ? AppColors.primary : AppColors.textLight,
                    title: 'Sound Effects',
                    subtitle: soundEnabled ? 'On — tap to hear!' : 'Off',
                    trailing: Switch.adaptive(
                      value: soundEnabled,
                      onChanged: (v) =>
                          ref.read(soundProvider.notifier).set(v),
                      activeColor: AppColors.primary,
                    ),
                  ),
                  const Divider(height: 1),

                  /// Voice Speed
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.speed_rounded,
                                color: AppColors.secondary, size: 22),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Voice Speed',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDark)),
                                  Text('Adjust how fast words are spoken',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textLight)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _speedLabel(speechRate),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('🐢', style: TextStyle(fontSize: 20)),
                            Expanded(
                              child: Slider(
                                value: speechRate,
                                min: 0.2,
                                max: 0.9,
                                divisions: 7,
                                activeColor: AppColors.secondary,
                                onChanged: (v) => ref
                                    .read(speechRateProvider.notifier)
                                    .set(v),
                              ),
                            ),
                            const Text('🐇', style: TextStyle(fontSize: 20)),
                          ],
                        ),

                        /// Presets
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _SpeedChip(
                              label: 'Slow',
                              value: AppConstants.slowVoiceSpeed,
                              current: speechRate,
                              onTap: () => ref
                                  .read(speechRateProvider.notifier)
                                  .set(AppConstants.slowVoiceSpeed),
                            ),
                            _SpeedChip(
                              label: 'Normal',
                              value: AppConstants.defaultVoiceSpeed,
                              current: speechRate,
                              onTap: () => ref
                                  .read(speechRateProvider.notifier)
                                  .set(AppConstants.defaultVoiceSpeed),
                            ),
                            _SpeedChip(
                              label: 'Fast',
                              value: AppConstants.fastVoiceSpeed,
                              current: speechRate,
                              onTap: () => ref
                                  .read(speechRateProvider.notifier)
                                  .set(AppConstants.fastVoiceSpeed),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const _SectionTitle('About'),
            const SizedBox(height: 12),

            _SettingsCard(
              animIndex: 1,
              child: Column(
                children: [
                  const _SettingRow(
                    icon: Icons.info_outline_rounded,
                    iconColor: AppColors.accent,
                    title: 'Version',
                    subtitle: '1.0.0',
                  ),
                  const Divider(height: 1),
                  const _SettingRow(
                    icon: Icons.business_rounded,
                    iconColor: AppColors.purple,
                    title: 'Made by',
                    subtitle: 'Vedica Labs',
                  ),
                  const Divider(height: 1),
                  const _SettingRow(
                    icon: Icons.child_care_rounded,
                    iconColor: AppColors.pink,
                    title: 'Designed for',
                    subtitle: 'Ages 2–6 years',
                  ),
                  const Divider(height: 1),

                  /// ✅ WORKING NAVIGATION
                  _SettingRow(
                    icon: Icons.privacy_tip_outlined,
                    iconColor: AppColors.cyan,
                    title: 'Privacy Policy',
                    subtitle: 'Tap to read our privacy policy',
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: Color(0xFF888AAA)),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppConstants.privacyPolicyRoute,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _speedLabel(double rate) {
    if (rate <= 0.35) return 'Slow';
    if (rate <= 0.55) return 'Normal';
    return 'Fast';
  }
}

// ================= COMPONENTS =================

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.pink, Color(0xFFFF80AB)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.pink.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Image(
                image: AssetImage('assets/images/tap_pico_app.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TapPico',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
              Text('Kids ABC & 123 Learning',
                  style: TextStyle(color: Colors.white70)),
              SizedBox(height: 4),
              Text('by Vedica Labs',
                  style: TextStyle(color: Colors.white60)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.textLight,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  final int animIndex;

  const _SettingsCard({required this.child, this.animIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: 400.ms, delay: (animIndex * 100).ms),
        SlideEffect(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
          duration: 400.ms,
          delay: (animIndex * 100).ms,
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: child,
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight)),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final String label;
  final double value;
  final double current;
  final VoidCallback onTap;

  const _SpeedChip({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = (current - value).abs() < 0.01;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary
                : AppColors.secondary.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.secondary,
          ),
        ),
      ),
    );
  }
}