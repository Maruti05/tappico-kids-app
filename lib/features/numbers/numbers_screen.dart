// lib/features/numbers/numbers_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/number_data.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';

class _TappedNumberNotifier extends Notifier<NumberItem?> {
  @override
  NumberItem? build() => null;
  void set(NumberItem? item) => state = item;
}

final _tappedNumberProvider =
    NotifierProvider<_TappedNumberNotifier, NumberItem?>(
      _TappedNumberNotifier.new,
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

class NumbersScreen extends ConsumerWidget {
  const NumbersScreen({super.key});

  static const List<List<Color>> _palette = [
    [Color(0xFFFF1744), Color(0xFFFF8A80)],
    [Color(0xFFFF6D00), Color(0xFFFFAB40)],
    [Color(0xFFFFD600), Color(0xFFFFFF8D)],
    [Color(0xFF00C853), Color(0xFFB9F6CA)],
    [Color(0xFF2979FF), Color(0xFF82B1FF)],
    [Color(0xFFAA00FF), Color(0xFFEA80FC)],
    [Color(0xFFFF4081), Color(0xFFFF80AB)],
    [Color(0xFF00BFA5), Color(0xFFA7FFEB)],
    [Color(0xFFFF6D00), Color(0xFFFFD180)],
    [Color(0xFF304FFE), Color(0xFF536DFE)],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numbers = numberData;
    final tapped = ref.watch(_tappedNumberProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: const TapPicoAppBar(title: 'Numbers'),
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
                        '1 to 20 — counting fun!',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Tap to count! 🎵',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
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
                          childAspectRatio: 0.75,
                        ),
                    itemCount: numbers.length,
                    itemBuilder: (context, index) {
                      final item = numbers[index];
                      final colors = _palette[index % _palette.length];
                      final isActive = tapped?.number == item.number;
                      return _NumberCard(
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
            _NumberOverlay(
              item: tapped,
              origin: ref.watch(_tappedPositionProvider),
            ),
        ],
      ),
    );
  }
}

class _NumberCard extends ConsumerStatefulWidget {
  final NumberItem item;
  final List<Color> colors;
  final bool isActive;
  final int animIndex;

  const _NumberCard({
    required this.item,
    required this.colors,
    required this.isActive,
    required this.animIndex,
  });

  @override
  ConsumerState<_NumberCard> createState() => _NumberCardState();
}

class _NumberCardState extends ConsumerState<_NumberCard> {
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
        FadeEffect(duration: 300.ms, delay: (widget.animIndex * 40).ms),
        ScaleEffect(
          begin: const Offset(0.6, 0.6),
          end: const Offset(1, 1),
          duration: 450.ms,
          delay: (widget.animIndex * 40).ms,
          curve: Curves.easeOutBack,
        ),
      ],
      child: GestureDetector(
        onTap: () async {
          ref.read(_tappedPositionProvider.notifier).set(position);
          ref.read(_tappedNumberProvider.notifier).set(widget.item);
          ref.read(ttsServiceProvider).speak(widget.item.ttsPhrase);
          await Future.delayed(const Duration(milliseconds: 2000));
          if (ref.read(_tappedNumberProvider)?.number == widget.item.number) {
            ref.read(_tappedNumberProvider.notifier).set(null);
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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.colors[0],
              width: widget.isActive ? 0 : 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.colors[0].withOpacity(
                  widget.isActive ? 0.45 : 0.2,
                ),
                blurRadius: widget.isActive ? 18 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dot visual for small numbers
              if (widget.item.number <= 5)
                _DotDisplay(
                  count: widget.item.number,
                  color: widget.isActive ? Colors.white : widget.colors[0],
                ),
              if (widget.item.number > 5)
                Text(widget.item.emoji, style: const TextStyle(fontSize: 42)),
              const SizedBox(height: 4),
              Text(
                '${widget.item.number}',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: widget.isActive ? Colors.white : widget.colors[0],
                  height: 1,
                ),
              ),
              Text(
                widget.item.word,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: widget.isActive ? Colors.white70 : AppColors.textLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DotDisplay extends StatelessWidget {
  final int count;
  final Color color;
  const _DotDisplay({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      runSpacing: 3,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
        (_) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _NumberOverlay extends ConsumerStatefulWidget {
  final NumberItem item;
  final Offset? origin;
  const _NumberOverlay({required this.item, this.origin});

  @override
  ConsumerState<_NumberOverlay> createState() => _NumberOverlayState();
}

class _NumberOverlayState extends ConsumerState<_NumberOverlay>
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
    final idx = numberData.indexWhere((n) => n.number == widget.item.number);
    final colors = NumbersScreen._palette[idx % NumbersScreen._palette.length];

    return GestureDetector(
      onTap: () => ref.read(_tappedNumberProvider.notifier).set(null),
      child: Container(
        color: Colors.black.withOpacity(0.45),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              width: 240,
              padding: const EdgeInsets.all(32),
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
                  Text(widget.item.emoji, style: const TextStyle(fontSize: 60)),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.item.number}',
                    style: const TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item.word,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
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
