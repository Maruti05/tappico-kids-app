// lib/features/practice/practice_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tappico/widgets/common/ad_banner_widget.dart';

import '../../core/constants/alphabet_data.dart';
import '../../core/constants/fruit_data.dart';
import '../../core/constants/bird_data.dart';
import '../../core/constants/animal_data.dart';
import '../../core/constants/number_data.dart';
import '../../core/constants/color_data.dart';
import '../../core/constants/vehicle_data.dart';
import '../../core/constants/body_part_data.dart';
import '../../core/constants/vegetable_data.dart';
import '../../core/theme/app_theme.dart';
import '../../services/providers.dart';
import '../../widgets/common/tappico_app_bar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Quiz Models
// ─────────────────────────────────────────────────────────────────────────────

enum QuizCategory {
  alphabets,
  numbers,
  shapes,
  fruits,
  birds,
  animals,
  domesticAnimals,
  wildAnimals,
  insects,
  colors,
  vehicles,
  bodyParts,
  vegetables,
}

class QuizQuestion {
  final String prompt;
  final String correctAnswer;
  final List<String> options;
  final String emoji;

  const QuizQuestion({
    required this.prompt,
    required this.correctAnswer,
    required this.options,
    required this.emoji,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryNotifier extends Notifier<QuizCategory> {
  @override
  QuizCategory build() => QuizCategory.alphabets;

  void set(QuizCategory category) => state = category;
}

final _categoryProvider = NotifierProvider<_CategoryNotifier, QuizCategory>(
  _CategoryNotifier.new,
);

class _QuestionNotifier extends Notifier<QuizQuestion?> {
  @override
  QuizQuestion? build() => null;

  void set(QuizQuestion? question) => state = question;
}

final _questionProvider = NotifierProvider<_QuestionNotifier, QuizQuestion?>(
  _QuestionNotifier.new,
);

class _ScoreNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void set(int score) => state = score;

  void update(int Function(int) updater) => state = updater(state);
}

final _scoreProvider = NotifierProvider<_ScoreNotifier, int>(
  _ScoreNotifier.new,
);

class _TotalNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void set(int total) => state = total;

  void update(int Function(int) updater) => state = updater(state);
}

final _totalProvider = NotifierProvider<_TotalNotifier, int>(
  _TotalNotifier.new,
);

enum _AnswerState { none, correct, wrong }

class _AnswerStateNotifier extends Notifier<_AnswerState> {
  @override
  _AnswerState build() => _AnswerState.none;

  void set(_AnswerState answerState) => state = answerState;
}

final _answerStateProvider =
    NotifierProvider<_AnswerStateNotifier, _AnswerState>(
      _AnswerStateNotifier.new,
    );

class _SelectedAnswerNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? selectedAnswer) => state = selectedAnswer;
}

final _selectedAnswerProvider =
    NotifierProvider<_SelectedAnswerNotifier, String?>(
      _SelectedAnswerNotifier.new,
    );

// ─────────────────────────────────────────────────────────────────────────────
// Question Generators
// ─────────────────────────────────────────────────────────────────────────────

QuizQuestion _generateAlphabetQuestion() {
  final rng = Random();

  final correct = alphabetData[rng.nextInt(alphabetData.length)];

  final wrongs = (alphabetData.toList()..shuffle())
      .where((e) => e.letter != correct.letter)
      .take(3)
      .map((e) => e.letter)
      .toList();

  final opts = [...wrongs, correct.letter]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the letter 👇',
    correctAnswer: correct.letter,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateNumberQuestion() {
  final rng = Random();

  final correct = numberData[rng.nextInt(numberData.length)];

  final wrongs = (numberData.toList()..shuffle())
      .where((e) => e.number != correct.number)
      .take(3)
      .map((e) => '${e.number}')
      .toList();

  final opts = [...wrongs, '${correct.number}']..shuffle();

  return QuizQuestion(
    prompt: 'Tap ${correct.word} 👇',
    correctAnswer: '${correct.number}',
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateShapeQuestion() {
  final rng = Random();

  final correct = shapeData[rng.nextInt(shapeData.length)];

  final wrongs = (shapeData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the shape 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateFruitQuestion() {
  final rng = Random();

  final correct = fruitData[rng.nextInt(fruitData.length)];

  final wrongs = (fruitData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the fruit 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateBirdQuestion() {
  final rng = Random();

  final correct = birdData[rng.nextInt(birdData.length)];

  final wrongs = (birdData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the bird 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateAnimalQuestion() {
  final rng = Random();

  final correct = animalData[rng.nextInt(animalData.length)];

  final wrongs = (animalData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the animal 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateDomesticAnimalQuestion() {
  final rng = Random();

  final correct = domesticAnimalData[rng.nextInt(domesticAnimalData.length)];

  final wrongs = (domesticAnimalData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the domestic animal 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateWildAnimalQuestion() {
  final rng = Random();

  final correct = wildAnimalData[rng.nextInt(wildAnimalData.length)];

  final wrongs = (wildAnimalData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the wild animal 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateInsectQuestion() {
  final rng = Random();

  final correct = insectAnimalData[rng.nextInt(insectAnimalData.length)];

  final wrongs = (insectAnimalData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the insect 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateColorQuestion() {
  final rng = Random();

  final correct = colorData[rng.nextInt(colorData.length)];

  final wrongs = (colorData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the color 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateVehicleQuestion() {
  final rng = Random();

  final correct = vehicleData[rng.nextInt(vehicleData.length)];

  final wrongs = (vehicleData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the vehicle 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateBodyPartQuestion() {
  final rng = Random();

  final correct = bodyPartData[rng.nextInt(bodyPartData.length)];

  final wrongs = (bodyPartData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the body part 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

QuizQuestion _generateVegetableQuestion() {
  final rng = Random();

  final correct = vegetableData[rng.nextInt(vegetableData.length)];

  final wrongs = (vegetableData.toList()..shuffle())
      .where((e) => e.name != correct.name)
      .take(3)
      .map((e) => e.name)
      .toList();

  final opts = [...wrongs, correct.name]..shuffle();

  return QuizQuestion(
    prompt: 'Tap the vegetable 👇',
    correctAnswer: correct.name,
    options: opts,
    emoji: correct.emoji,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Practice Screen
// ─────────────────────────────────────────────────────────────────────────────

class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nextQuestion();
    });
  }

  void _showCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _CategoryBottomSheet(
        selected: ref.read(_categoryProvider),
        onSelect: (cat) {
          ref.read(_categoryProvider.notifier).set(cat);

          ref.read(_scoreProvider.notifier).set(0);
          ref.read(_totalProvider.notifier).set(0);

          _nextQuestion();

          Navigator.pop(context);
        },
      ),
    );
  }

  void _nextQuestion() {
    final cat = ref.read(_categoryProvider);

    QuizQuestion q;

    switch (cat) {
      case QuizCategory.alphabets:
        q = _generateAlphabetQuestion();
        break;

      case QuizCategory.numbers:
        q = _generateNumberQuestion();
        break;

      case QuizCategory.shapes:
        q = _generateShapeQuestion();
        break;

      case QuizCategory.fruits:
        q = _generateFruitQuestion();
        break;

      case QuizCategory.birds:
        q = _generateBirdQuestion();
        break;

      case QuizCategory.animals:
        q = _generateAnimalQuestion();
        break;

      case QuizCategory.domesticAnimals:
        q = _generateDomesticAnimalQuestion();
        break;

      case QuizCategory.wildAnimals:
        q = _generateWildAnimalQuestion();
        break;

      case QuizCategory.insects:
        q = _generateInsectQuestion();
        break;

      case QuizCategory.colors:
        q = _generateColorQuestion();
        break;

      case QuizCategory.vehicles:
        q = _generateVehicleQuestion();
        break;

      case QuizCategory.bodyParts:
        q = _generateBodyPartQuestion();
        break;

      case QuizCategory.vegetables:
        q = _generateVegetableQuestion();
        break;
    }

    ref.read(_questionProvider.notifier).set(q);

    ref.read(_answerStateProvider.notifier).set(_AnswerState.none);

    ref.read(_selectedAnswerProvider.notifier).set(null);
  }

  Future<void> _onAnswer(String answer) async {
    final q = ref.read(_questionProvider);

    if (q == null) return;

    if (ref.read(_answerStateProvider) != _AnswerState.none) {
      return;
    }

    ref.read(_selectedAnswerProvider.notifier).set(answer);

    ref.read(_totalProvider.notifier).update((s) => s + 1);

    final isCorrect = answer == q.correctAnswer;

    ref
        .read(_answerStateProvider.notifier)
        .set(isCorrect ? _AnswerState.correct : _AnswerState.wrong);

    if (isCorrect) {
      ref.read(_scoreProvider.notifier).update((s) => s + 1);

      ref.read(ttsServiceProvider).speak('Correct! Great job!');
    } else {
      ref.read(ttsServiceProvider).speak('Try again! You can do it!');
    }

    await Future.delayed(const Duration(milliseconds: 1600));

    if (isCorrect) {
      _nextQuestion();
    } else {
      ref.read(_answerStateProvider.notifier).set(_AnswerState.none);

      ref.read(_selectedAnswerProvider.notifier).set(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = ref.watch(_questionProvider);

    final score = ref.watch(_scoreProvider);

    final total = ref.watch(_totalProvider);

    final answerState = ref.watch(_answerStateProvider);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: TapPicoAppBar(
        title: 'Practice',
        showSettings: false,
        gradientColors: AppColors.practiceGradient,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GlassButton(
              icon: Icons.category_rounded,
              onTap: () => _showCategorySheet(context),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GlassButton(
              icon: Icons.refresh_rounded,
              onTap: () {
                ref.read(_scoreProvider.notifier).set(0);

                ref.read(_totalProvider.notifier).set(0);

                _nextQuestion();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                const AdBannerWidget(),
                const SizedBox(height: 8),
                _ScoreBar(score: score, total: total),
                const SizedBox(height: 20),
                if (question != null) ...[
                  _QuestionCard(
                    question: question,
                    answerState: answerState,
                  ),

                  const SizedBox(height: 24),

                  GridView.count(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: question.options.map((opt) {
                      return _OptionCard(
                        option: opt,
                        correct: question.correctAnswer,
                        answerState: answerState,
                        selected: ref.watch(_selectedAnswerProvider),
                        onTap: () => _onAnswer(opt),
                      );
                    }).toList(),
                  ),
                ] else
                  const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Category Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryBottomSheet extends StatelessWidget {
  final QuizCategory selected;
  final ValueChanged<QuizCategory> onSelect;

  const _CategoryBottomSheet({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cats = [
      (QuizCategory.alphabets, '🔤', 'Alphabets', 'A to Z • 26 letters'),
      (QuizCategory.numbers, '🔢', 'Numbers', '1 to 20 • counting'),
      (QuizCategory.shapes, '🔷', 'Shapes', '8 shapes to learn'),
      (QuizCategory.fruits, '🍎', 'Fruits', '14 fruits to learn'),
      (QuizCategory.birds, '🦜', 'Birds', '14 birds to learn'),
      (QuizCategory.animals, '🐾', 'Animals', '58 animals to learn'),
      (QuizCategory.domesticAnimals, '🏠', 'Domestic', '16 pets to learn'),
      (QuizCategory.wildAnimals, '🌿', 'Wild', '31 wild animals'),
      (QuizCategory.insects, '🐛', 'Insects', '11 bugs & critters'),
      (QuizCategory.colors, '🌈', 'Colors', '14 colors to learn'),
      (QuizCategory.vehicles, '🚗', 'Vehicles', '20 vehicles to learn'),
      (QuizCategory.bodyParts, '🧍', 'Body Parts', '20 body parts'),
      (QuizCategory.vegetables, '🥦', 'Vegetables', '20 veggies to learn'),
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Choose Category',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 32,
                      ),
                      itemCount: cats.length,
                      itemBuilder: (context, index) {
                        final c = cats[index];

                        final isSelected = selected == c.$1;

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();

                            onSelect(c.$1);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [
                                        AppColors.purple,
                                        Color(0xFFEA80FC),
                                      ],
                                    )
                                  : null,
                              color: isSelected ? null : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : Colors.grey.shade200,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? AppColors.purple.withOpacity(0.25)
                                      : Colors.black.withOpacity(0.04),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.2)
                                        : AppColors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Center(
                                    child: Text(
                                      c.$2,
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.$3,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.textDark,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        c.$4,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white70
                                              : AppColors.textMid,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                AnimatedScale(
                                  scale: isSelected ? 1 : 0,
                                  duration: const Duration(milliseconds: 250),
                                  child: const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 28,
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
            )
            .animate()
            .slideY(
              begin: 0.2,
              end: 0,
              duration: 350.ms,
              curve: Curves.easeOutCubic,
            )
            .fadeIn();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Score Bar
// ─────────────────────────────────────────────────────────────────────────────

class _ScoreBar extends StatelessWidget {
  final int score;
  final int total;

  const _ScoreBar({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : score / total;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 20)),

              const SizedBox(width: 8),

              Text(
                '$score / $total correct',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  total == 0 ? '—' : '${(pct * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Question Card
// ─────────────────────────────────────────────────────────────────────────────

class _QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final _AnswerState answerState;

  const _QuestionCard({required this.question, required this.answerState});

  @override
  Widget build(BuildContext context) {
    Color bgColor;

    if (answerState == _AnswerState.correct) {
      bgColor = AppColors.primary;
    } else if (answerState == _AnswerState.wrong) {
      bgColor = AppColors.red;
    } else {
      bgColor = AppColors.accent;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, bgColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (answerState == _AnswerState.correct) ...[
            const Text('🎉', style: TextStyle(fontSize: 52)).animate().scale(
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              curve: Curves.elasticOut,
              duration: 400.ms,
            ),

            const SizedBox(height: 8),

            const Text(
              'Correct! 🌟',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ] else if (answerState == _AnswerState.wrong) ...[
            const Text('😅', style: TextStyle(fontSize: 52)),

            const SizedBox(height: 8),

            const Text(
              'Try again!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ] else ...[
            Text(question.emoji, style: const TextStyle(fontSize: 52)),

            const SizedBox(height: 8),

            Text(
              question.prompt,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Option Card
// ─────────────────────────────────────────────────────────────────────────────

class _OptionCard extends StatelessWidget {
  final String option;
  final String correct;
  final _AnswerState answerState;
  final String? selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.option,
    required this.correct,
    required this.answerState,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = Colors.white;
    Color textColor = AppColors.textDark;
    Color borderColor = AppColors.purple.withOpacity(0.25);

    if (answerState != _AnswerState.none) {
      if (option == correct) {
        cardColor = AppColors.primary;
        textColor = Colors.white;
        borderColor = AppColors.primary;
      } else if (option == selected && option != correct) {
        cardColor = AppColors.red;
        textColor = Colors.white;
        borderColor = AppColors.red;
      }
    }

    final fontSize = option.length > 8
        ? 22.0
        : (option.length > 5 ? 26.0 : 36.0);

    return GestureDetector(
      onTap: answerState == _AnswerState.none ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: cardColor == Colors.white
                  ? Colors.black.withOpacity(0.07)
                  : cardColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                option,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
