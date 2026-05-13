import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class TappableCard extends StatefulWidget {
  final Widget Function(Color color, bool isActive) builder;
  final int colorIndex;
  final bool isActive;
  final int animIndex;
  final ValueChanged<Offset> onTap;
  final double borderRadius;
  final double animDelayMs;
  final double beginScale;
  final EdgeInsetsGeometry? padding;
  final List<Color>? gradientColors;
  final double borderWidth;

  const TappableCard({
    super.key,
    required this.builder,
    required this.colorIndex,
    required this.isActive,
    required this.animIndex,
    required this.onTap,
    this.borderRadius = 28,
    this.animDelayMs = 30,
    this.beginScale = 0.7,
    this.padding,
    this.gradientColors,
    this.borderWidth = 2.5,
  });

  @override
  State<TappableCard> createState() => _TappableCardState();
}

class _TappableCardState extends State<TappableCard> {
  final GlobalKey _key = GlobalKey();

  Offset? get position {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return Offset(offset.dx + size.width / 2, offset.dy + size.height / 2);
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.letterColors[
        widget.colorIndex % AppColors.letterColors.length];
    final activeGradient = widget.gradientColors;

    return Animate(
      effects: [
        FadeEffect(duration: 300.ms, delay: (widget.animIndex * widget.animDelayMs).ms),
        ScaleEffect(
          begin: Offset(widget.beginScale, widget.beginScale),
          end: const Offset(1, 1),
          duration: 400.ms,
          delay: (widget.animIndex * widget.animDelayMs).ms,
          curve: Curves.easeOutBack,
        ),
      ],
      child: GestureDetector(
        onTap: () {
          final pos = position;
          if (pos != null) widget.onTap(pos);
        },
        child: AnimatedContainer(
          key: _key,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: widget.isActive && activeGradient != null
                ? LinearGradient(
                    colors: activeGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !widget.isActive
                ? Colors.white
                : (activeGradient != null ? null : color),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: activeGradient != null
                  ? (widget.isActive ? Colors.transparent : activeGradient[0])
                  : color,
              width: widget.isActive ? 0 : widget.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: (activeGradient != null
                        ? activeGradient[0]
                        : color
                    ).withOpacity(widget.isActive ? 0.45 : 0.18),
                blurRadius: widget.isActive ? 18 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.builder(
            activeGradient != null ? activeGradient[0] : color,
            widget.isActive,
          ),
        ),
      ),
    );
  }
}

class TappableCardRow extends StatelessWidget {
  final String emoji;
  final String name;
  final Color color;
  final bool isActive;

  const TappableCardRow({
    super.key,
    required this.emoji,
    required this.name,
    required this.color,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: isActive ? Colors.white : color,
                height: 1,
              ),
            ),
          ),
          Icon(
            Icons.volume_up_rounded,
            color: isActive ? Colors.white70 : color.withOpacity(0.5),
            size: 28,
          ),
        ],
      ),
    );
  }
}
