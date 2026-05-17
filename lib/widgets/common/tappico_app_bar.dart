// lib/widgets/common/tappico_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';

class TapPicoAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showSettings;
  final List<Widget>? actions;

  /// Auto back button
  final bool showBackButton;

  /// Optional custom leading
  final Widget? leading;

  /// Gradient colors
  final List<Color>? gradientColors;

  const TapPicoAppBar({
    super.key,
    required this.title,
    this.showSettings = true,
    this.actions,
    this.showBackButton = true,
    this.leading,
    this.gradientColors,
  });

  @override
  Size get preferredSize => const Size.fromHeight(82);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundEnabled = ref.watch(soundProvider);

    final canPop = Navigator.canPop(context);

    final colors = gradientColors ?? AppColors.practiceGradient;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      toolbarHeight: 82,

      flexibleSpace: OverflowBox(
        maxHeight: 120,
        alignment: Alignment.topCenter,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),

            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.28),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
      ),

      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),

      leading:
          leading ??
          (showBackButton && canPop
              ? Padding(
                  padding: const EdgeInsets.only(left: 14, top: 10, bottom: 10),
                  child: GlassButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                )
              : null),

      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('✨', style: TextStyle(fontSize: 22)),

          const SizedBox(width: 8),

          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),

      actions: [
        if (showSettings) ...[
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 10, bottom: 10),
            child: GlassButton(
              icon: soundEnabled
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
              onTap: () {
                HapticFeedback.selectionClick();

                ref.read(soundProvider.notifier).toggle();
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 14, top: 10, bottom: 10),
            child: GlassButton(
              icon: Icons.settings_rounded,
              onTap: () {
                HapticFeedback.lightImpact();

                Navigator.pushNamed(context, AppConstants.settingsRoute);
              },
            ),
          ),
        ],

        ...?actions,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Glass Button
// ─────────────────────────────────────────────────────────────

class GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const GlassButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),

            borderRadius: BorderRadius.circular(18),

            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
