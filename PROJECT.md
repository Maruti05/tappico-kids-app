# TapPico — Project Context

> **LLM INSTRUCTION:** After every coding session where you modify files, add files, or change project structure, you MUST update this document to keep it in sync. Append dated entries to the "Recent Changes" section.

## Overview

**TapPico** is a kids educational app (ages 2–6) for learning ABCs, numbers, shapes, animals, colors, and more. Built with Flutter. No backend, no authentication, no database.

- **Package:** `com.vedica.labs.ind.app.tappico`
- **Version:** `0.2.0+3`
- **Tagline:** Tap • Learn • Grow
- **Developer:** Vedica Labs (Karnataka, India)

## Platform Support

Android, iOS, Web, Linux, Windows, macOS.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (SDK) |
| State Management | flutter_riverpod ^3.3.1 |
| Text-to-Speech | flutter_tts ^4.0.2 |
| Animations | flutter_animate ^4.5.0 |
| Fonts | google_fonts ^8.1.0 (Nunito) |
| Persistence | shared_preferences ^2.2.3 |
| Ads | google_mobile_ads ^8.0.0 (AdMob banners) |
| Connectivity | connectivity_plus ^7.1.1 |
| App Info | package_info_plus ^9.0.1 |
| Markdown | flutter_markdown ^0.7.7+1 |
| Icons | flutter_launcher_icons ^0.14.4 |

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         Routes, SharedPreferences keys, TTS speeds, grid counts, animation durations
│   │   ├── alphabet_data.dart         26 A–Z items (AlphabetItem)
│   │   ├── number_data.dart           20 NumberItem + ShapeItem + ShapeType (enum, 9 shapes)
│   │   ├── fruit_data.dart            20 FruitItem
│   │   ├── bird_data.dart             14 BirdItem
│   │   ├── animal_data.dart           58 AnimalItem + AnimalCategory enum (domestic/wild/insect)
│   │   ├── color_data.dart            9 ColorItem
│   │   ├── vehicle_data.dart          20 VehicleItem
│   │   ├── body_part_data.dart        19 BodyPartItem
│   │   └── vegetable_data.dart        13 VegetableItem
│   ├── theme/
│   │   └── app_theme.dart             AppColors (15 gradients, 12 card palette colors), AppTheme (Material3, Nunito)
│   └── utils/
│       └── app_router.dart            18 named routes, fade+scale transitions
├── features/
│   ├── splash/splash_screen.dart              Animated 3s splash, TTS init, auto-navigate
│   ├── home/home_screen.dart                  2-column grid, time-based greeting, quick stats strip
│   ├── alphabets/alphabets_screen.dart        26 A–Z, 2-col grid, emoji+letter+word cards
│   ├── numbers/numbers_screen.dart            1–20, 2-col grid, dots (1–5) / emoji (6+)
│   ├── shapes/shapes_screen.dart              9 shapes, CustomPaint ShapePainter, 2-col grid
│   ├── fruits/fruits_screen.dart              20 fruits, row layout (emoji • name • volume icon)
│   ├── birds/birds_screen.dart                14 birds, row layout
│   ├── domestic_animals/domestic_animals_screen.dart   16 pets, row layout + section header
│   ├── wild_animals/wild_animals_screen.dart           31 wild animals, row layout
│   ├── insects/insects_screen.dart                    11 insects, row layout
│   ├── colors/colors_screen.dart              9 colors, row layout
│   ├── vehicles/vehicles_screen.dart          20 vehicles, row layout
│   ├── body_parts/body_parts_screen.dart      19 body parts, row layout
│   ├── vegetables/vegetables_screen.dart      13 vegetables, row layout
│   ├── animals/animals_screen.dart            LEGACY: combined domestic+wild (backward compat)
│   ├── practice/practice_screen.dart          Quiz engine (~1115 lines)
│   └── settings/
│       ├── settings_screen.dart               Audio/Visual settings, app info, privacy link
│       └── privacy_policy_screen.dart         11-section markdown privacy policy
├── services/
│   ├── providers.dart               7 global Riverpod providers
│   ├── tts_service.dart             TTS singleton with queue
│   └── admob_service.dart           AdMob singleton with retry logic
├── widgets/
│   ├── common/
│   │   ├── tappico_app_bar.dart     Shared gradient app bar (82px, rounded-bottom, glass buttons)
│   │   ├── tap_card.dart            Pressable card with scale animation + BouncingEmoji + SuccessBurst
│   │   ├── gradient_card.dart       Home screen category card with gradient
│   │   └── ad_banner_widget.dart    Lifecycle-aware AdMob adaptive banner
│   └── learn/
│       ├── tappable_card.dart       Generic animated card wrapper + TappableCardRow
│       ├── tap_overlay.dart         Fullscreen overlay with elastic-scale card
│       ├── section_header.dart      Emoji + title + count badge row
│       └── info_header.dart         Label + "Tap to hear!" badge row
└── main.dart                        Entry point, portrait lock, AdMob init, eye protector filter
```

## Routes (18 total)

| Route Constant | Path | Screen |
|----------------|------|--------|
| `splashRoute` | `/` | SplashScreen |
| `homeRoute` | `/home` | HomeScreen |
| `alphabetsRoute` | `/alphabets` | AlphabetsScreen |
| `numbersRoute` | `/numbers` | NumbersScreen |
| `shapesRoute` | `/shapes` | ShapesScreen |
| `fruitsRoute` | `/fruits` | FruitsScreen |
| `birdsRoute` | `/birds` | BirdsScreen |
| `animalsRoute` | `/animals` | AnimalsScreen (legacy combined) |
| `domesticAnimalsRoute` | `/domestic-animals` | DomesticAnimalsScreen |
| `wildAnimalsRoute` | `/wild-animals` | WildAnimalsScreen |
| `insectsRoute` | `/insects` | InsectsScreen |
| `colorsRoute` | `/colors` | ColorsScreen |
| `vehiclesRoute` | `/vehicles` | VehiclesScreen |
| `bodyPartsRoute` | `/body-parts` | BodyPartsScreen |
| `vegetablesRoute` | `/vegetables` | VegetablesScreen |
| `practiceRoute` | `/practice` | PracticeScreen |
| `settingsRoute` | `/settings` | SettingsScreen |
| `privacyPolicyRoute` | `/privacy-policy` | PrivacyPolicyScreen |

**Transition:** Fade + Scale (0.96→1.0, easeOutCubic, 280ms card / 200ms content)

## State Management (Riverpod)

### Global Providers (`lib/services/providers.dart`)

| Provider | Type | Persisted? | Purpose |
|----------|------|-----------|---------|
| `ttsServiceProvider` | `Provider<TtsService>` | — | Singleton TTS service |
| `soundProvider` | `NotifierProvider<bool>` | Yes | Sound on/off |
| `speechRateProvider` | `NotifierProvider<double>` | Yes | TTS speech rate (0.2–0.9) |
| `tappedItemProvider` | `NotifierProvider<String?>` | — | Currently tapped item key |
| `autoPlayProvider` | `NotifierProvider<bool>` | — | Auto-play toggle |
| `eyeProtectorProvider` | `NotifierProvider<bool>` | Yes | Blue light filter on/off |
| `appVersionProvider` | `FutureProvider<String>` | — | App version from package_info_plus |

### Per-Screen Providers

Each category screen defines two private `NotifierProvider`s:
- `_tappedXxxProvider` — tracks tapped item (shows overlay)
- `_tappedPositionProvider` — tracks tap position (overlay origin)

Practice screen has 6 private providers: `_categoryProvider`, `_questionProvider`, `_scoreProvider`, `_totalProvider`, `_answerStateProvider`, `_selectedAnswerProvider`.

## TTS Service (`lib/services/tts_service.dart`)

- **Pattern:** Singleton (factory constructor)
- **Voice:** en-US, prefers neural → female → child
- **Pitch:** 1.2, **Volume:** 1.0
- **Queue:** `Queue<String>` for sequential playback
- **Formatting:** Single chars get "..." suffix for clarity
- **Methods:** `speak()`, `speakLetterWithWord()`, `speakNumber()`, `speakSequence()`, `stop()`, `setSoundEnabled()`, `setSpeechRate()`, `dispose()`
- **Rate range:** ~0.2 to 0.9 (Slow=0.35, Normal=0.5, Fast=0.7)

## AdMob Service (`lib/services/admob_service.dart`)

- **Pattern:** Singleton (factory constructor)
- **Unit IDs:** Test IDs (both Android + iOS)
- **Ad format:** Adaptive banners via `AdSize.getLargeAnchoredAdaptiveBannerAdSize`
- **Pre-checks:** Internet connectivity via `connectivity_plus`
- **Retry:** 3 attempts with exponential backoff (2s, 4s, 6s)
- **Lifecycle:** WidgetsBindingObserver in `AdBannerWidget`
- **`shouldShowAds()`:** Placeholder for premium unlock

## Data Models (All in `lib/core/constants/`)

| File | Model | Fields | Count |
|------|-------|--------|-------|
| `alphabet_data.dart` | `AlphabetItem` | letter, word, emoji, ttsPhrase | 26 |
| `number_data.dart` | `NumberItem` | number, word, emoji, ttsPhrase | 20 |
| `number_data.dart` | `ShapeItem` + `ShapeType` enum | name, emoji, ttsPhrase, shapeType | 9 |
| `fruit_data.dart` | `FruitItem` | name, emoji, ttsPhrase | 20 |
| `bird_data.dart` | `BirdItem` | name, emoji, ttsPhrase | 14 |
| `animal_data.dart` | `AnimalItem` + `AnimalCategory` enum | name, emoji, ttsPhrase, category | 58 (16 domestic + 31 wild + 11 insect) |
| `color_data.dart` | `ColorItem` | name, emoji, ttsPhrase | 9 |
| `vehicle_data.dart` | `VehicleItem` | name, emoji, ttsPhrase | 20 |
| `body_part_data.dart` | `BodyPartItem` | name, emoji, ttsPhrase | 19 |
| `vegetable_data.dart` | `VegetableItem` | name, emoji, ttsPhrase | 13 |

**Total learning items: ~208**

## Learning Categories

| Category | Items | Screen Style |
|----------|-------|-------------|
| Alphabets | 26 | 2-col grid, emoji+letter+word |
| Numbers | 20 | 2-col grid, dots (1–5) / emoji (6+), word |
| Shapes | 9 | 2-col grid, CustomPaint ShapePainter |
| Fruits | 20 | Row layout (emoji • name • volume icon) |
| Birds | 14 | Row layout |
| Domestic Animals | 16 | Row layout with section header |
| Wild Animals | 31 | Row layout with section header |
| Insects | 11 | Row layout with section header |
| Colors | 9 | Row layout |
| Vehicles | 20 | Row layout |
| Body Parts | 19 | Row layout |
| Vegetables | 13 | Row layout |

Every category card shares the same interaction pattern: **Tap → TTS speaks → TapOverlay appears with emoji + name → auto-dismiss after 2.2s**

## Practice / Quiz Screen

- **Categories:** 13 (all of the above)
- **Format:** 4-option multiple choice
- **Scoring:** Score + total questions + percentage + progress bar
- **Feedback:** Animated background (blue=neutral, green=correct, red=wrong), option cards change color
- **Wrong answers:** Allow retry
- **TTS feedback:** "Correct! Great job!" / "Try again! You can do it!"
- **Category selection:** DraggableScrollableSheet with animated icons
- **Question generation:** `_generateXxxQuestion()` per category — random correct + 3 wrongs, shuffled

## Settings Screen

- **Audio Section:**
  - Sound Effects toggle (Switch)
  - Voice Speed slider (0.2–0.9, 7 steps) with Slow / Normal / Fast preset buttons
- **Visual Section:**
  - Eye Protector toggle — applies warm amber `ColorFilter` (`BlendMode.softLight`) across entire app
- **About Section:**
  - App version (from `package_info_plus`)
  - Developer: Vedica Labs
  - Target age: 2–6 years
  - Privacy Policy link → markdown-rendered screen with 11 sections
  - Share TapPico → system share sheet with app link
  - Rate TapPico → opens Play Store listing

## Theme (`lib/core/theme/app_theme.dart`)

- **Background:** `#F8F4FF` (warm lavender white)
- **Text:** `#1A1A2E` (dark), `#444466` (mid), `#888AAA` (light)
- **Material3** with `ColorScheme.fromSeed(Color(0xFF00C853))`
- **Font:** Google Fonts Nunito (Regular, Bold, ExtraBold, Black)
- **Card theme:** rounded (24), white, no elevation
- **Page transitions:** Zoom (Android), Cupertino (iOS)

### Category Gradients (15 total)
`alphabetGradient`, `numberGradient`, `shapeGradient`, `fruitsGradient`, `practiceGradient`, `settingsGradient`, `birdsGradient`, `animalsGradient`, `domesticGradient`, `wildGradient`, `insectGradient`, `colorGradient`, `vehicleGradient`, `bodyPartGradient`, `vegetableGradient`, `homeGradient`

## Features (Complete Inventory)

1. **Animated Splash Screen** — gradient background loop, floating emoji bubbles, bouncing logo, loading dots, TTS init
2. **Home Screen** — time-based greeting, 13 category cards (2-col grid), quick stats fun facts strip, staggered animations
3. **Alphabets Learning** (26 A–Z)
4. **Numbers Learning** (1–20 with dot display)
5. **Shapes Learning** (9 shapes with CustomPaint)
6. **Fruits Learning** (20 items)
7. **Birds Learning** (14 birds)
8. **Domestic Animals Learning** (16 pets)
9. **Wild Animals Learning** (31 animals)
10. **Insects Learning** (11 bugs)
11. **Colors Learning** (9 colors)
12. **Vehicles Learning** (20 vehicles)
13. **Body Parts Learning** (19 body parts)
14. **Vegetables Learning** (13 vegetables)
15. **Quiz / Practice Engine** — 13 categories, 4-choice MCQs, score tracking, animated feedback, retry on wrong
16. **Settings** — sound toggle, voice speed (slider + presets), eye protector, version info, privacy policy
17. **Privacy Policy** — markdown-rendered, 11 sections
18. **AdMob Adaptive Banners** — on all category screens, with connectivity check, retry, graceful failure
19. **Eye Protector Mode** — amber color filter across entire app (blue light reduction)
20. **TTS with Queue** — sequential speech, single-char formatting, configurable rate
21. **Animated Route Transitions** — fade + scale (280ms)
22. **Gradient App Bar** — 82px, rounded-bottom, glass-style buttons, sound/settings built-in
23. **Haptic Feedback** — lightImpact on taps, selectionClick on toggles
24. **Portrait Lock** — app locked to portrait orientation
25. **Tap Overlay** — fullscreen, elastic-scale animated card with emoji + name on every tap
26. **Performance** — RepaintBoundary around every grid item
27. **Persistence** — SharedPreferences for sound, speech rate, eye protector settings

## Conventions

- **Async:** `async/await`, `Completer` for one-shot coordination, `Future.delayed` for delays
- **Widgets:** `ConsumerWidget` (stateless) or `ConsumerStatefulWidget` (stateful)
- **Navigation:** `Navigator.pushNamed()` / `pushReplacementNamed()`
- **Animations:** `flutter_animate` for entrance FX; `AnimationController` for custom loops
- **Haptics:** `HapticFeedback.lightImpact()` on tap, `selectionClick()` on toggle
- **Ads:** `AdBannerWidget` at bottom; gracefully hides on failure
- **State:** Riverpod exclusively. Private per-screen `NotifierProvider`s for local UI state.
- **Persistence:** `SharedPreferences` for sound toggle, speech rate, eye protector
- **Data:** `const` lists of model classes with `const` constructors

## Recent Changes

### May 2026
- **Version bumped** to `0.2.0+3`
- **Extracted insects** from wild data → separate `insectAnimalData` list
- **Added 3 screens:** DomesticAnimalsScreen, WildAnimalsScreen, InsectsScreen
- **Updated homepage:** Replaced single "Animals" card with 3 cards
- **Updated practice:** 3 new `QuizCategory` values with dedicated question generators
- **New gradients:** `domesticGradient`, `wildGradient`, `insectGradient`
- **Fixed Quick Stats overflow:** `Row` → `Wrap` with `LayoutBuilder`
- **Unified app bar icons:** `GlassButton` made public; reused in practice screen
- **Fixed gradient clash:** `domesticGradient` orange→amber (`0xFFFFA000`→`0xFFFFD54F`)
- **Added 4 categories:** Colors (9), Vehicles (20), Body Parts (19), Vegetables (13) — with screens, data, routes, gradients, practice quizzes, and homepage cards
- **Refactored shared widgets:** `TappableCard`, `TappableCardRow`, `TapOverlay`, `InfoHeader`, `SectionHeader` — removed ~2000+ duplicated lines across screens
- **Fixed all deprecation warnings:** `withOpacity` → `withValues(alpha:)` (15 files), `activeColor` → `activeTrackColor`, removed unused variables (`curved`, `colorScheme`, `textTheme`), fixed unnecessary underscores
- **Updated packages:** connectivity_plus 6.1.5→7.1.1, google_fonts 8.0.2→8.1.0, package_info_plus 8.3.1→9.0.1, share_plus 10.1.4 (kept — 13.x had Kotlin incompatibility)
- **Added share+rate features:** Share TapPico and Rate TapPico rows in Settings → About section
- **Enabled Impeller rendering:** Added `EnableImpeller=true` to AndroidManifest.xml
- **Fixed native splash color:** Android green→white (light) / black (dark) via night colors.xml; iOS green→white
