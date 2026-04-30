// lib/widgets/common/tappico_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';

class TapPicoAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showSettings;
  final List<Widget>? actions;

  const TapPicoAppBar({
    super.key,
    required this.title,
    this.showSettings = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundEnabled = ref.watch(soundProvider);

    return AppBar(
      title: Text(title),
      actions: [
        if (showSettings) ...[
          IconButton(
            icon: Icon(
              soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: soundEnabled ? AppColors.primary : AppColors.textLight,
            ),
            onPressed: () => ref.read(soundProvider.notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: AppColors.textMid),
            onPressed: () => Navigator.pushNamed(context, AppConstants.settingsRoute),
          ),
        ],
        ...?actions,
        const SizedBox(width: 4),
      ],
    );
  }
}
