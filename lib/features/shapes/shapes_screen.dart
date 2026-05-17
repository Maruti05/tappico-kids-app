import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/number_data.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';
import '../../widgets/common/ad_banner_widget.dart';
import '../../widgets/learn/info_header.dart';
import '../../widgets/learn/tappable_card.dart';
import '../../widgets/learn/tap_overlay.dart';

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

const List<List<Color>> _shapePalette = [
  [Color(0xFF2979FF), Color(0xFF82B1FF)],
  [Color(0xFF00C853), Color(0xFF69F0AE)],
  [Color(0xFFFF1744), Color(0xFFFF8A80)],
  [Color(0xFFFF6D00), Color(0xFFFFAB40)],
  [Color(0xFFFFD600), Color(0xFFFFFF8D)],
  [Color(0xFFAA00FF), Color(0xFFEA80FC)],
  [Color(0xFFFF4081), Color(0xFFFF80AB)],
  [Color(0xFF00BFA5), Color(0xFFA7FFEB)],
];

class ShapesScreen extends ConsumerWidget {
  const ShapesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapped = ref.watch(_tappedShapeProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(
        title: 'Shapes',
        gradientColors: AppColors.shapeGradient,
      ),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                const AdBannerWidget(),
                const InfoHeader(
                  label: '8 shapes to discover!',
                  badgeText: 'Tap to learn! 🔍',
                  badgeColor: AppColors.accent,
                ),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                      final colors = _shapePalette[index % _shapePalette.length];
                      final isActive = tapped?.name == item.name;
                      return RepaintBoundary(
                        child: TappableCard(
                          colorIndex: index,
                          isActive: isActive,
                          animIndex: index,
                          borderRadius: 28,
                          animDelayMs: 60,
                          beginScale: 0.7,
                          gradientColors: colors,
                          borderWidth: 3,
                          onTap: (position) async {
                            ref.read(_tappedPositionProvider.notifier).set(position);
                            ref.read(_tappedShapeProvider.notifier).set(item);
                            ref.read(ttsServiceProvider).speak(item.ttsPhrase);
                            await Future.delayed(AppConstants.itemPopupDuration);
                            if (ref.read(_tappedShapeProvider)?.name == item.name) {
                              ref.read(_tappedShapeProvider.notifier).set(null);
                            }
                          },
                          builder: (color, active) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CustomPaint(
                                  painter: ShapePainter(
                                    shapeType: item.shapeType,
                                    color: active ? Colors.white : color,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: active ? Colors.white : AppColors.textDark,
                                  ),
                                ),
                              ),
                            ],
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
              width: 260,
              color: _shapePalette[
                shapeData.indexWhere((s) => s.name == tapped.name) %
                _shapePalette.length
              ][0],
              onDismiss: () => ref.read(_tappedShapeProvider.notifier).set(null),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CustomPaint(
                      painter: ShapePainter(
                        shapeType: tapped.shapeType,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tapped.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tapped.ttsPhrase,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.85),
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
      case ShapeType.hexagon:
        _drawPolygon(canvas, Offset(cx, cy), r, 6, paint);
        break;
    }
  }

  void _drawStar(Canvas canvas, Offset center, double r, int points, Paint paint) {
    final path = Path();
    final inner = r * 0.45;
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final radius = i.isEven ? r : inner;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawPolygon(Canvas canvas, Offset center, double r, int sides, Paint paint) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = (2 * math.pi * i / sides) - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    final s = r * 0.9;
    path.moveTo(center.dx, center.dy + s * 0.4);
    path.cubicTo(center.dx - s * 1.4, center.dy - s * 0.4, center.dx - s * 1.4, center.dy - s * 1.2, center.dx, center.dy - s * 0.4);
    path.cubicTo(center.dx + s * 1.4, center.dy - s * 1.2, center.dx + s * 1.4, center.dy - s * 0.4, center.dx, center.dy + s * 0.4);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ShapePainter old) =>
      old.shapeType != shapeType || old.color != color;
}
