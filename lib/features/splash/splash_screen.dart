// lib/features/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../services/tts_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat(reverse: true);

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _init();
  }

  Future<void> _init() async {
    await TtsService().init();
    await Future.delayed(AppConstants.splashDuration);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppConstants.homeRoute);
    }
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (_, _) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF00C853),
                    const Color(0xFF2979FF),
                    _bgCtrl.value,
                  )!,
                  Color.lerp(
                    const Color(0xFFFF6D00),
                    const Color(0xFFAA00FF),
                    _bgCtrl.value,
                  )!,
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Floating bubbles bg
                ..._buildBubbles(size),

                // Main content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo bounce
                    AnimatedBuilder(
                      animation: _floatCtrl,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(0, -8 * _floatCtrl.value),
                        child: child,
                      ),
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/tap_pico_app.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // App name
                    const Text(
                          'TapPico',
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            height: 1,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .slideY(begin: 0.2, curve: Curves.easeOutCubic),

                    const SizedBox(height: 10),

                    // Tagline
                    Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            'Tap  •  Learn  •  Grow',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideY(begin: 0.2, curve: Curves.easeOutCubic),

                    const SizedBox(height: 60),

                    // Loading dots
                    _LoadingDots().animate().fadeIn(
                      delay: 900.ms,
                      duration: 400.ms,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildBubbles(Size size) {
    final bubbles = [
      const _BubbleData('🍎', 0.12, 0.15, 40),
      const _BubbleData('⭐', 0.85, 0.12, 36),
      const _BubbleData('🐱', 0.08, 0.75, 44),
      const _BubbleData('🎈', 0.88, 0.72, 38),
      const _BubbleData('🦋', 0.5, 0.08, 34),
      const _BubbleData('🌈', 0.5, 0.88, 40),
      const _BubbleData('🐶', 0.22, 0.5, 32),
      const _BubbleData('🎵', 0.78, 0.45, 36),
    ];

    return bubbles
        .map(
          (b) => Positioned(
            left: size.width * b.xFrac - b.size / 2,
            top: size.height * b.yFrac - b.size / 2,
            child: AnimatedBuilder(
              animation: _floatCtrl,
              builder: (_, child) => Transform.translate(
                offset: Offset(
                  0,
                  b.size *
                      0.15 *
                      (_floatCtrl.value * 2 - 1) *
                      (b.xFrac > 0.5 ? 1 : -1),
                ),
                child: Opacity(opacity: 0.5, child: child),
              ),
              child: Text(b.emoji, style: TextStyle(fontSize: b.size)),
            ),
          ),
        )
        .toList();
  }
}

class _BubbleData {
  final String emoji;
  final double xFrac, yFrac, size;
  const _BubbleData(this.emoji, this.xFrac, this.yFrac, this.size);
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final progress = (_ctrl.value * 3 - i).clamp(0.0, 1.0);
            final bounce = progress < 0.5 ? progress * 2 : (1 - progress) * 2;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.translate(
                offset: Offset(0, -12 * bounce),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
