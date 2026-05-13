// lib/core/constants/number_data.dart

class NumberItem {
  final int number;
  final String word;
  final String emoji;
  final String ttsPhrase;

  const NumberItem({
    required this.number,
    required this.word,
    required this.emoji,
    required this.ttsPhrase,
  });
}

const List<String> _numberEmojis = [
  '1️⃣',
  '2️⃣',
  '3️⃣',
  '4️⃣',
  '5️⃣',
  '6️⃣',
  '7️⃣',
  '8️⃣',
  '9️⃣',
  '🔟',
  '⑪',
  '⑫',
  '⑬',
  '⑭',
  '⑮',
  '⑯',
  '⑰',
  '⑱',
  '⑲',
  '⑳',
];

const List<String> _numberWords = [
  'One',
  'Two',
  'Three',
  'Four',
  'Five',
  'Six',
  'Seven',
  'Eight',
  'Nine',
  'Ten',
  'Eleven',
  'Twelve',
  'Thirteen',
  'Fourteen',
  'Fifteen',
  'Sixteen',
  'Seventeen',
  'Eighteen',
  'Nineteen',
  'Twenty',
];

List<NumberItem> get numberData => List.generate(
  20,
  (i) => NumberItem(
    number: i + 1,
    word: _numberWords[i],
    emoji: _numberEmojis[i],
    ttsPhrase: _numberWords[i],
  ),
);

// ─── Shapes ─────────────────────────────────────────────────────────────────

class ShapeItem {
  final String name;
  final String emoji;
  final String ttsPhrase;
  final ShapeType shapeType;

  const ShapeItem({
    required this.name,
    required this.emoji,
    required this.ttsPhrase,
    required this.shapeType,
  });
}

enum ShapeType {
  circle,
  square,
  triangle,
  rectangle,
  star,
  diamond,
  heart,
  pentagon,
  hexagon,
}

const List<ShapeItem> shapeData = [
  ShapeItem(
    name: 'Circle',
    emoji: '⭕',
    ttsPhrase: 'This is a Circle',
    shapeType: ShapeType.circle,
  ),
  ShapeItem(
    name: 'Square',
    emoji: '🟦',
    ttsPhrase: 'This is a Square',
    shapeType: ShapeType.square,
  ),
  ShapeItem(
    name: 'Triangle',
    emoji: '🔺',
    ttsPhrase: 'This is a Triangle',
    shapeType: ShapeType.triangle,
  ),
  ShapeItem(
    name: 'Rectangle',
    emoji: '▬',
    ttsPhrase: 'This is a Rectangle',
    shapeType: ShapeType.rectangle,
  ),
  ShapeItem(
    name: 'Star',
    emoji: '⭐',
    ttsPhrase: 'This is a Star',
    shapeType: ShapeType.star,
  ),
  ShapeItem(
    name: 'Diamond',
    emoji: '💎',
    ttsPhrase: 'This is a Diamond',
    shapeType: ShapeType.diamond,
  ),
  ShapeItem(
    name: 'Heart',
    emoji: '❤️',
    ttsPhrase: 'This is a Heart',
    shapeType: ShapeType.heart,
  ),
  ShapeItem(
    name: 'Pentagon',
    emoji: '⬠',
    ttsPhrase: 'This is a Pentagon',
    shapeType: ShapeType.pentagon,
  ),
  ShapeItem(
    name: 'Hexagon',
    emoji: '⬡',
    ttsPhrase: 'This is a Hexagon',
    shapeType: ShapeType.hexagon,
  ),
];
