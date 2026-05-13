// lib/core/constants/bird_data.dart

class BirdItem {
  final String name;
  final String emoji;
  final String ttsPhrase;

  const BirdItem({
    required this.name,
    required this.emoji,
    required this.ttsPhrase,
  });
}

const List<BirdItem> birdData = [
  BirdItem(name: 'Owl', emoji: '🦉', ttsPhrase: 'Owl'),
  BirdItem(name: 'Parrot', emoji: '🦜', ttsPhrase: 'Parrot'),
  BirdItem(name: 'Penguin', emoji: '🐧', ttsPhrase: 'Penguin'),
  BirdItem(name: 'Duck', emoji: '🦆', ttsPhrase: 'Duck'),
  BirdItem(name: 'Chicken', emoji: '🐔', ttsPhrase: 'Chicken'),
  BirdItem(name: 'Rooster', emoji: '🐓', ttsPhrase: 'Rooster'),
  BirdItem(name: 'Eagle', emoji: '🦅', ttsPhrase: 'Eagle'),
  BirdItem(name: 'Swan', emoji: '🦢', ttsPhrase: 'Swan'),
  BirdItem(name: 'Flamingo', emoji: '🦩', ttsPhrase: 'Flamingo'),
  BirdItem(name: 'Peacock', emoji: '🦚', ttsPhrase: 'Peacock'),
  BirdItem(name: 'Dove', emoji: '🕊️', ttsPhrase: 'Dove'),
  BirdItem(name: 'Turkey', emoji: '🦃', ttsPhrase: 'Turkey'),
  BirdItem(name: 'Bird', emoji: '🐦', ttsPhrase: 'Bird'),
  BirdItem(name: 'Black Bird', emoji: '🐦‍⬛', ttsPhrase: 'Black Bird'),
];
