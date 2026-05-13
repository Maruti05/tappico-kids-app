# TapPico — Project Context

> **LLM INSTRUCTION:** After every coding session where you modify files, add files, or change project structure, you MUST update this file to reflect the new state. Keep the "Recent Changes" section appended with a dated entry summarizing what was done. This ensures future sessions can read one file instead of re-exploring the entire codebase.

## Overview
Kids ABC & 123 Learning App. Package: `com.vedica.labs.ind.app.tappico` (v0.1.1+2).

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart      Routes, prefs keys, TTS speeds, grid counts
│   │   ├── alphabet_data.dart      26 A-Z items (AlphabetItem)
│   │   ├── number_data.dart        20 items (NumberItem)
│   │   ├── fruit_data.dart         15 fruits (FruitItem)
│   │   ├── bird_data.dart          14 birds (BirdItem)
│   │   └── animal_data.dart        AnimalItem model + domestic(24)/wild(70+)/insect(17) lists
│   ├── theme/
│   │   └── app_theme.dart          AppColors (gradients, palette), AppTheme (Material3, Nunito)
│   └── utils/
│       └── app_router.dart         Named routes with fade+scale transitions
├── features/
│   ├── splash/splash_screen.dart
│   ├── home/home_screen.dart       2-column grid of GradientCategoryCards
│   ├── alphabets/alphabets_screen.dart
│   ├── numbers/numbers_screen.dart
│   ├── shapes/shapes_screen.dart
│   ├── fruits/fruits_screen.dart
│   ├── birds/birds_screen.dart
│   ├── domestic_animals/domestic_animals_screen.dart
│   ├── wild_animals/wild_animals_screen.dart
│   ├── insects/insects_screen.dart
│   ├── practice/practice_screen.dart   Quiz engine (~998 lines)
│   └── settings/
│       ├── settings_screen.dart
│       └── privacy_policy_screen.dart
├── services/
│   ├── providers.dart              Global riverpod providers
│   ├── tts_service.dart            TTS singleton
│   └── admob_service.dart          AdMob singleton
├── widgets/common/
│   ├── tappico_app_bar.dart         Shared gradient app bar
│   ├── tap_card.dart                Pressable card with scale animation
│   ├── gradient_card.dart           Home screen category card
│   └── ad_banner_widget.dart        Lifecycle-aware AdMob banner
└── main.dart
```

## Routes

| Route | Screen |
|---|---|
| `/` → `splashRoute` | SplashScreen |
| `/home` → `homeRoute` | HomeScreen |
| `/alphabets` → `alphabetsRoute` | AlphabetsScreen |
| `/numbers` → `numbersRoute` | NumbersScreen |
| `/shapes` → `shapesRoute` | ShapesScreen |
| `/fruits` → `fruitsRoute` | FruitsScreen |
| `/birds` → `birdsRoute` | BirdsScreen |
| `/animals` → `animalsRoute` | AnimalsScreen (combined, kept for backward compat) |
| `/domestic-animals` → `domesticAnimalsRoute` | DomesticAnimalsScreen |
| `/wild-animals` → `wildAnimalsRoute` | WildAnimalsScreen |
| `/insects` → `insectsRoute` | InsectsScreen |
| `/practice` → `practiceRoute` | PracticeScreen |
| `/settings` → `settingsRoute` | SettingsScreen |
| `/privacy-policy` → `privacyPolicyRoute` | PrivacyPolicyScreen |

Transition: Fade + Scale (0.96→1.0, easeOutCubic, 280ms/200ms).

## State Management (Riverpod)

### Global providers (`lib/services/providers.dart`)
- `ttsServiceProvider` — `Provider<TtsService>`
- `soundProvider` — `NotifierProvider<bool>` (persisted)
- `speechRateProvider` — `NotifierProvider<double>` (persisted)
- `tappedItemProvider` — `NotifierProvider<String?>`
- `autoPlayProvider` — `NotifierProvider<bool>`

### Per-screen providers
Each category screen defines private `NotifierProvider`s for tap state + position.

## TTS Service (`lib/services/tts_service.dart`)
Singleton (factory pattern). Queues speech sequentially. Methods:
- `speak(String)`, `speakLetterWithWord(l, w)`, `speakNumber(int)`, `speakSequence(List<String>)`
- `stop()`, `setSoundEnabled(bool)`, `setSpeechRate(double)`, `dispose()`
- Voice: en-US, prefers neural/female/child. Pitch: 1.2. Formatting: single chars get ellipsis.

## AdMob Service (`lib/services/admob_service.dart`)
Singleton. Test ad unit IDs. Adaptive banners. Retry (3x, exponential backoff). Connectivity check.

## Shared App Bar (`TapPicoAppBar`)
Parameters: title, showSettings, actions, showBackButton, leading, gradientColors.
Height: 82px. Rounded-bottom gradient. Glass-style buttons. Sound toggle + settings gear built-in.

## Data Models (all in `lib/core/constants/`)
- `AlphabetItem`: letter, word, emoji, ttsPhrase
- `NumberItem`: number, word, emoji, ttsPhrase
- `FruitItem`: name, emoji, ttsPhrase
- `BirdItem`: name, emoji, ttsPhrase
- `AnimalItem`: name, emoji, ttsPhrase, category (enum: domestic/wild/insect)
  - `domesticAnimalData` — 24 items
  - `wildAnimalData` — 70+ items
  - `insectAnimalData` — 17 items
  - `animalData` — combined list of all three

## Practice Screen (`QuizCategory` enum)
Categories: alphabets, numbers, shapes, fruits, birds, animals, domesticAnimals, wildAnimals, insects.
Each generates questions via `_generateXxxQuestion()` — picks random correct + 3 wrongs, shuffles.

## Theme (`AppColors`)
Background: `#F8F4FF`. Text: `#1A1A2E` (dark), `#444466` (mid), `#888AAA` (light).
Category gradients: alphabetGradient, numberGradient, shapeGradient, fruitsGradient, birdsGradient, animalsGradient, domesticGradient, wildGradient, insectGradient, practiceGradient, settingsGradient, homeGradient.

## Conventions
- **Async:** `async/await`, `Completer` for one-shot coordination, `Future.delayed` for delays
- **Widgets:** `ConsumerWidget` (stateless) or `ConsumerStatefulWidget` (stateful)
- **Navigation:** `Navigator.pushNamed()` / `pushReplacementNamed()`
- **Animations:** `flutter_animate` for entrance FX; `AnimationController` for custom loops
- **Haptics:** `HapticFeedback.lightImpact()` on tap, `selectionClick()` on toggle
- **Ads:** `AdBannerWidget` at bottom of category screens; gracefully hides on failure
- **State:** Riverpod exclusively. Private per-screen `NotifierProvider`s for local UI state.
- **Persistence:** `SharedPreferences` for sound toggle + speech rate
- **Data:** `const` lists of model classes with `const` constructors

## Categories
| Category | Items | Data File | Screen |
|---|---|---|---|
| Alphabets | 26 | `alphabet_data.dart` | `AlphabetsScreen` |
| Numbers | 20 | `number_data.dart` | `NumbersScreen` |
| Shapes | 9 | `number_data.dart` | `ShapesScreen` |
| Fruits | 15 | `fruit_data.dart` | `FruitsScreen` |
| Birds | 14 | `bird_data.dart` | `BirdsScreen` |
| Animals (combined) | — | `animal_data.dart` | `AnimalsScreen` |
| Domestic Animals | 16 | `animal_data.dart` (domesticAnimalData) | `DomesticAnimalsScreen` |
| Wild Animals | 31 | `animal_data.dart` (wildAnimalData) | `WildAnimalsScreen` |
| Insects | 11 | `animal_data.dart` (insectAnimalData) | `InsectsScreen` |
| Colors | 14 | `color_data.dart` | `ColorsScreen` |
| Vehicles | 20 | `vehicle_data.dart` | `VehiclesScreen` |
| Body Parts | 20 | `body_part_data.dart` | `BodyPartsScreen` |
| Vegetables | 13 | `vegetable_data.dart` | `VegetablesScreen` |

## Recent Changes (May 2026)
- **Extracted insects** from `wildAnimalData` into separate `insectAnimalData` list
- **Added 3 new screens:** DomesticAnimalsScreen, WildAnimalsScreen, InsectsScreen
- **Updated homepage:** Replaced single "Animals" card with 3 separate cards (Domestic, Wild, Insects)
- **Updated practice screen:** Added 3 new `QuizCategory` values with dedicated question generators
- **Added gradients:** `domesticGradient`, `wildGradient`, `insectGradient` in AppColors
- **Updated FunFactsStrip** with broken-down stats for each category
- **Fixed Quick Stats overflow:** Changed `Row` to `Wrap` with `LayoutBuilder` for responsive auto-wrapping with equal gaps
- **Unified app bar icons:** Made `GlassButton` public widget; practice screen now uses it for category/refresh icons
- **Fixed gradient clash:** Changed `domesticGradient` from orange → amber (`0xFFFFA000` → `0xFFFFD54F`) to distinguish from number gradient
- **Added 4 new categories:** Colors (14 items), Vehicles (20), Body Parts (20), Vegetables (20) with screens, data, routes, gradients, practice quizzes, and homepage cards

## Refactoring — Shared Widgets (`lib/widgets/learn/`)
- **`TappableCard`** — Generic animated card wrapper: entrance animation (fade+scale), GestureDetector with position tracking, AnimatedContainer decoration (color/gradient, border, shadow). Parameters: `builder`, `colorIndex`, `isActive`, `animIndex`, `onTap`, `borderRadius`, `gradientColors`, `borderWidth`, `animDelayMs`, `beginScale`.
- **`TappableCardRow`** — Pre-built row layout for cards with emoji • name • volume icon.
- **`TapOverlay`** — Reusable overlay with backdrop, elastic scale animation, gradient card. Takes `child`, `color`, `onDismiss`, `width`.
- **`InfoHeader`** — Header row with label + badge ("Tap to hear! 👂"). Customizable `badgeText`, `badgeColor`.
- **`SectionHeader`** — Section label with emoji, title, count badge.
- **`RepaintBoundary`** added around every grid item for performance.
- Removed ~2000+ lines of duplicated code across 9 screens.
