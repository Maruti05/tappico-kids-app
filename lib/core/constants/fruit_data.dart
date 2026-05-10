// lib/core/constants/fruit_data.dart

class FruitItem {
  final String name;
  final String emoji;
  final String ttsPhrase;

  const FruitItem({
    required this.name,
    required this.emoji,
    required this.ttsPhrase,
  });
}

const List<FruitItem> fruitData = [
  FruitItem(name: 'Apple', emoji: '🍎', ttsPhrase: 'Apple'),
  FruitItem(name: 'Banana', emoji: '🍌', ttsPhrase: 'Banana'),
  FruitItem(name: 'Orange', emoji: '🍊', ttsPhrase: 'Orange'),
  FruitItem(name: 'Strawberry', emoji: '🍓', ttsPhrase: 'Strawberry'),
  FruitItem(name: 'Grapes', emoji: '🍇', ttsPhrase: 'Grapes'),
  FruitItem(name: 'Watermelon', emoji: '🍉', ttsPhrase: 'Watermelon'),
  FruitItem(name: 'Pineapple', emoji: '🍍', ttsPhrase: 'Pineapple'),
  FruitItem(name: 'Mango', emoji: '🥭', ttsPhrase: 'Mango'),
  FruitItem(name: 'Cherry', emoji: '🍒', ttsPhrase: 'Cherry'),
  FruitItem(name: 'Pear', emoji: '🍐', ttsPhrase: 'Pear'),
  FruitItem(name: 'Peach', emoji: '🍑', ttsPhrase: 'Peach'),
  FruitItem(name: 'Kiwi', emoji: '🥝', ttsPhrase: 'Kiwi'),
  FruitItem(name: 'Lemon', emoji: '🍋', ttsPhrase: 'Lemon'),
  FruitItem(name: 'Coconut', emoji: '🥥', ttsPhrase: 'Coconut'),
  FruitItem(name: 'Avocado', emoji: '🥑', ttsPhrase: 'Avocado'),
];
