// lib/features/shapes/shapes_screen.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/number_data.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';

class _TappedShapeNotifier extends Notifier<ShapeItem?> {
  @override
  ShapeItem? build() => null;
  void set(ShapeItem? item) => state = item;
}

final _tappedShapeProvider = NotifierProvider<_TappedShapeNotifier, ShapeItem?>(
  _TappedShapeNotifier.new,
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

class ShapesScreen extends ConsumerWidget {
  const ShapesScreen({super.key});

  static const List<List<Color>> _palette = [
    [Color(0xFF2979FF), Color(0xFF82B1FF)],
    [Color(0xFF00C853), Color(0xFF69F0AE)],
    [Color(0xFFFF1744), Color(0xFFFF8A80)],
    [Color(0xFFFF6D00), Color(0xFFFFAB40)],
    [Color(0xFFFFD600), Color(0xFFFFFF8D)],
    [Color(0xFFAA00FF), Color(0xFFEA80FC)],
    [Color(0xFFFF4081), Color(0xFFFF80AB)],
    [Color(0xFF00BFA5), Color(0xFFA7FFEB)],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapped = ref.watch(_tappedShapeProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(title: 'Shapes'),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '8 shapes to discover!',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tap to learn! 🔍',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: shapeData.length,
                    itemBuilder: (context, index) {
                      final item = shapeData[index];
                      final colors = _palette[index % _palette.length];
                      final isActive = tapped?.name == item.name;
                      return _ShapeCard(
                        item: item,
                        colors: colors,
                        isActive: isActive,
                        animIndex: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (tapped != null)
            _ShapeOverlay(
              item: tapped,
              origin: ref.watch(_tappedPositionProvider),
            ),
        ],
      ),
    );
  }
}

class _ShapeCard extends ConsumerStatefulWidget {
  final ShapeItem item;
  final List<Color> colors;
  final bool isActive;
  final int animIndex;

  const _ShapeCard({
    required this.item,
    required this.colors,
    required this.isActive,
    required this.animIndex,
  });

  @override
  ConsumerState<_ShapeCard> createState() => _ShapeCardState();
}

class _ShapeCardState extends ConsumerState<_ShapeCard> {
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
    return Animate(
      effects: [
        FadeEffect(duration: 350.ms, delay: (widget.animIndex * 60).ms),
        ScaleEffect(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1, 1),
          duration: 500.ms,
          delay: (widget.animIndex * 60).ms,
          curve: Curves.easeOutBack,
        ),
      ],
      child: GestureDetector(
        onTap: () async {
          ref.read(_tappedPositionProvider.notifier).set(position);
          ref.read(_tappedShapeProvider.notifier).set(widget.item);
          ref.read(ttsServiceProvider).speak(widget.item.ttsPhrase);
          await Future.delayed(const Duration(milliseconds: 2400));
          if (ref.read(_tappedShapeProvider)?.name == widget.item.name) {
            ref.read(_tappedShapeProvider.notifier).set(null);
          }
        },
        child: AnimatedContainer(
          key: _key,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: widget.isActive
                ? LinearGradient(
                    colors: widget.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isActive ? null : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: widget.colors[0], width: widget.isActive ? 0 : 3),
            boxShadow: [
              BoxShadow(
                color: widget.colors[0].withOpacity(widget.isActive ? 0.5 : 0.18),
                blurRadius: widget.isActive ? 24 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CustomPaint(
                  painter: ShapePainter(
                    shapeType: widget.item.shapeType,
                    color: widget.isActive ? Colors.white : widget.colors[0],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.item.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: widget.isActive ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final ShapeType shapeType;
  final Color color;

  const ShapePainter({required this.shapeType, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) * 0.88;

    switch (shapeType) {
      case ShapeType.circle:
        canvas.drawCircle(Offset(cx, cy), r, paint);
        break;
      case ShapeType.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(cx, cy),
              width: r * 1.8,
              height: r * 1.8,
            ),
            const Radius.circular(8),
          ),
          paint,
        );
        break;
      case ShapeType.triangle:
        final path = Path()
          ..moveTo(cx, cy - r)
          ..lineTo(cx + r, cy + r)
          ..lineTo(cx - r, cy + r)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.rectangle:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(cx, cy),
              width: r * 2.2,
              height: r * 1.3,
            ),
            const Radius.circular(8),
          ),
          paint,
        );
        break;
      case ShapeType.star:
        _drawStar(canvas, Offset(cx, cy), r, 5, paint);
        break;
      case ShapeType.diamond:
        final path = Path()
          ..moveTo(cx, cy - r)
          ..lineTo(cx + r * 0.7, cy)
          ..lineTo(cx, cy + r)
          ..lineTo(cx - r * 0.7, cy)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.heart:
        _drawHeart(canvas, Offset(cx, cy), r, paint);
        break;
      case ShapeType.pentagon:
        _drawPolygon(canvas, Offset(cx, cy), r, 5, paint);
        break;
    }
  }

  void _drawStar(
    Canvas canvas,
    Offset center,
    double r,
    int points,
    Paint paint,
  ) {
    final path = Path();
    final inner = r * 0.45;
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final radius = i.isEven ? r : inner;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawPolygon(
    Canvas canvas,
    Offset center,
    double r,
    int sides,
    Paint paint,
  ) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = (2 * math.pi * i / sides) - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    final s = r * 0.9;
    path.moveTo(center.dx, center.dy + s * 0.4);
    path.cubicTo(
      center.dx - s * 1.4,
      center.dy - s * 0.4,
      center.dx - s * 1.4,
      center.dy - s * 1.2,
      center.dx,
      center.dy - s * 0.4,
    );
    path.cubicTo(
      center.dx + s * 1.4,
      center.dy - s * 1.2,
      center.dx + s * 1.4,
      center.dy - s * 0.4,
      center.dx,
      center.dy + s * 0.4,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ShapePainter old) =>
      old.shapeType != shapeType || old.color != color;
}

class _ShapeOverlay extends ConsumerStatefulWidget {
  final ShapeItem item;
  final Offset? origin;
  const _ShapeOverlay({required this.item, this.origin});

  @override
  ConsumerState<_ShapeOverlay> createState() => _ShapeOverlayState();
}

class _ShapeOverlayState extends ConsumerState<_ShapeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idx = shapeData.indexWhere((s) => s.name == widget.item.name);
    final colors = ShapesScreen._palette[idx % ShapesScreen._palette.length];

    return GestureDetector(
      onTap: () => ref.read(_tappedShapeProvider.notifier).set(null),
      child: Container(
        color: Colors.black.withOpacity(0.45),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: colors[0].withOpacity(0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CustomPaint(
                      painter: ShapePainter(
                        shapeType: widget.item.shapeType,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.ttsPhrase,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
