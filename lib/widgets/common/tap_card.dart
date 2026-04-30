// lib/widgets/common/tap_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TapCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color color;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double elevation;

  const TapCard({
    super.key,
    required this.child,
    required this.onTap,
    required this.color,
    this.borderRadius,
    this.padding,
    this.elevation = 6,
  });

  @override
  State<TapCard> createState() => _TapCardState();
}

class _TapCardState extends State<TapCard> with SingleTickerProviderStateMixin {
  bool _pressed = false;

  void _onTapDown(_) {
    HapticFeedback.lightImpact();
    setState(() => _pressed = true);
  }

  void _onTapUp(_) {
    setState(() => _pressed = false);
    widget.onTap();
  }

  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(24);
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: radius,
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: widget.color.withOpacity(0.45),
                      blurRadius: widget.elevation * 2,
                      offset: Offset(0, widget.elevation * 0.6),
                    ),
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}


// ─── Bouncing emoji widget ────────────────────────────────────────────────────

class BouncingEmoji extends StatefulWidget {
  final String emoji;
  final double size;

  const BouncingEmoji({super.key, required this.emoji, required this.size});

  @override
  State<BouncingEmoji> createState() => _BouncingEmojiState();
}

class _BouncingEmojiState extends State<BouncingEmoji>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: child,
      ),
      child: Text(widget.emoji, style: TextStyle(fontSize: widget.size)),
    );
  }
}


// ─── Confetti burst (particle) ────────────────────────────────────────────────

class SuccessBurst extends StatelessWidget {
  const SuccessBurst({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('🎉', style: TextStyle(fontSize: 64))
        .animate(onPlay: (c) => c.forward())
        .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 400.ms, curve: Curves.elasticOut)
        .fadeOut(delay: 800.ms, duration: 400.ms);
  }
}
