// lib/core/constants/alphabet_data.dart

class AlphabetItem {
  final String letter;
  final String word;
  final String emoji;
  final String ttsPhrase;

  const AlphabetItem({
    required this.letter,
    required this.word,
    required this.emoji,
    required this.ttsPhrase,
  });
}

const List<AlphabetItem> alphabetData = [
  AlphabetItem(letter: 'A', word: 'Apple',     emoji: '🍎', ttsPhrase: 'A for Apple'),
  AlphabetItem(letter: 'B', word: 'Ball',      emoji: '⚽', ttsPhrase: 'B for Ball'),
  AlphabetItem(letter: 'C', word: 'Cat',       emoji: '🐱', ttsPhrase: 'C for Cat'),
  AlphabetItem(letter: 'D', word: 'Dog',       emoji: '🐶', ttsPhrase: 'D for Dog'),
  AlphabetItem(letter: 'E', word: 'Elephant',  emoji: '🐘', ttsPhrase: 'E for Elephant'),
  AlphabetItem(letter: 'F', word: 'Fish',      emoji: '🐠', ttsPhrase: 'F for Fish'),
  AlphabetItem(letter: 'G', word: 'Grapes',    emoji: '🍇', ttsPhrase: 'G for Grapes'),
  AlphabetItem(letter: 'H', word: 'Hat',       emoji: '🎩', ttsPhrase: 'H for Hat'),
  AlphabetItem(letter: 'I', word: 'Ice Cream', emoji: '🍦', ttsPhrase: 'I for Ice Cream'),
  AlphabetItem(letter: 'J', word: 'Juice',     emoji: '🧃', ttsPhrase: 'J for Juice'),
  AlphabetItem(letter: 'K', word: 'Kite',      emoji: '🪁', ttsPhrase: 'K for Kite'),
  AlphabetItem(letter: 'L', word: 'Lion',      emoji: '🦁', ttsPhrase: 'L for Lion'),
  AlphabetItem(letter: 'M', word: 'Mango',     emoji: '🥭', ttsPhrase: 'M for Mango'),
  AlphabetItem(letter: 'N', word: 'Nest',      emoji: '🪹', ttsPhrase: 'N for Nest'),
  AlphabetItem(letter: 'O', word: 'Orange',    emoji: '🍊', ttsPhrase: 'O for Orange'),
  AlphabetItem(letter: 'P', word: 'Parrot',    emoji: '🦜', ttsPhrase: 'P for Parrot'),
  AlphabetItem(letter: 'Q', word: 'Queen',     emoji: '👸', ttsPhrase: 'Q for Queen'),
  AlphabetItem(letter: 'R', word: 'Rabbit',    emoji: '🐰', ttsPhrase: 'R for Rabbit'),
  AlphabetItem(letter: 'S', word: 'Sun',       emoji: '☀️', ttsPhrase: 'S for Sun'),
  AlphabetItem(letter: 'T', word: 'Tiger',     emoji: '🐯', ttsPhrase: 'T for Tiger'),
  AlphabetItem(letter: 'U', word: 'Umbrella',  emoji: '☂️', ttsPhrase: 'U for Umbrella'),
  AlphabetItem(letter: 'V', word: 'Van',       emoji: '🚐', ttsPhrase: 'V for Van'),
  AlphabetItem(letter: 'W', word: 'Whale',     emoji: '🐋', ttsPhrase: 'W for Whale'),
  AlphabetItem(letter: 'X', word: 'Xylophone', emoji: '🎵', ttsPhrase: 'X for Xylophone'),
  AlphabetItem(letter: 'Y', word: 'Yak',       emoji: '🐃', ttsPhrase: 'Y for Yak'),
  AlphabetItem(letter: 'Z', word: 'Zebra',     emoji: '🦓', ttsPhrase: 'Z for Zebra'),
];
