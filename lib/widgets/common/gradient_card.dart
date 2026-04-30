// lib/widgets/common/gradient_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'tap_card.dart';

class GradientCategoryCard extends StatelessWidget {
  final String title;
  final String emoji;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;
  final int animIndex;

  const GradientCategoryCard({
    super.key,
    required this.title,
    required this.emoji,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    this.animIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(duration: 400.ms, delay: (animIndex * 80).ms),
        SlideEffect(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
          duration: 500.ms,
          delay: (animIndex * 80).ms,
          curve: Curves.easeOutCubic,
        ),
      ],
      child: TapCard(
        color: gradient.first,
        onTap: onTap,
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji bubble
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.28),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 30)),
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
