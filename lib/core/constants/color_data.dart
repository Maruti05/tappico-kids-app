class ColorItem {
  final String name;
  final String emoji;
  final String ttsPhrase;

  const ColorItem({
    required this.name,
    required this.emoji,
    required this.ttsPhrase,
  });
}

const List<ColorItem> colorData = [
  ColorItem(name: 'Red', emoji: '🔴', ttsPhrase: 'Red'),
  ColorItem(name: 'Blue', emoji: '🔵', ttsPhrase: 'Blue'),
  ColorItem(name: 'Green', emoji: '🟢', ttsPhrase: 'Green'),
  ColorItem(name: 'Yellow', emoji: '🟡', ttsPhrase: 'Yellow'),
  ColorItem(name: 'Orange', emoji: '🟠', ttsPhrase: 'Orange'),
  ColorItem(name: 'Purple', emoji: '🟣', ttsPhrase: 'Purple'),
  ColorItem(name: 'Pink', emoji: '🩷', ttsPhrase: 'Pink'),
  ColorItem(name: 'Brown', emoji: '🟤', ttsPhrase: 'Brown'),
  ColorItem(name: 'Black', emoji: '⚫', ttsPhrase: 'Black'),
  ColorItem(name: 'White', emoji: '⚪', ttsPhrase: 'White'),
  ColorItem(name: 'Gray', emoji: '🩶', ttsPhrase: 'Gray'),
  ColorItem(name: 'Gold', emoji: '🌟', ttsPhrase: 'Gold'),
  ColorItem(name: 'Silver', emoji: '✨', ttsPhrase: 'Silver'),
  ColorItem(name: 'Rainbow', emoji: '🌈', ttsPhrase: 'Rainbow'),
];
