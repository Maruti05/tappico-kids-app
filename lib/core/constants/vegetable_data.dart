class VegetableItem {
  final String name;
  final String emoji;
  final String ttsPhrase;

  const VegetableItem({
    required this.name,
    required this.emoji,
    required this.ttsPhrase,
  });
}

const List<VegetableItem> vegetableData = [
  VegetableItem(name: 'Carrot', emoji: '🥕', ttsPhrase: 'Carrot'),
  VegetableItem(name: 'Broccoli', emoji: '🥦', ttsPhrase: 'Broccoli'),
  VegetableItem(name: 'Tomato', emoji: '🍅', ttsPhrase: 'Tomato'),
  VegetableItem(name: 'Potato', emoji: '🥔', ttsPhrase: 'Potato'),
  VegetableItem(name: 'Onion', emoji: '🧅', ttsPhrase: 'Onion'),
  VegetableItem(name: 'Cucumber', emoji: '🥒', ttsPhrase: 'Cucumber'),
  VegetableItem(name: 'Lettuce', emoji: '🥬', ttsPhrase: 'Lettuce'),
  VegetableItem(name: 'Corn', emoji: '🌽', ttsPhrase: 'Corn'),
  VegetableItem(name: 'Pepper', emoji: '🫑', ttsPhrase: 'Pepper'),
  VegetableItem(name: 'Mushroom', emoji: '🍄', ttsPhrase: 'Mushroom'),
  VegetableItem(name: 'Peas', emoji: '🟢', ttsPhrase: 'Peas'),
  VegetableItem(name: 'Eggplant', emoji: '🍆', ttsPhrase: 'Eggplant'),
  VegetableItem(name: 'Cabbage', emoji: '🥗', ttsPhrase: 'Cabbage'),
  VegetableItem(name: 'Spinach', emoji: '🌿', ttsPhrase: 'Spinach'),
  VegetableItem(name: 'Pumpkin', emoji: '🎃', ttsPhrase: 'Pumpkin'),
  VegetableItem(name: 'Radish', emoji: '🌶️', ttsPhrase: 'Radish'),
  VegetableItem(name: 'Beetroot', emoji: '🍠', ttsPhrase: 'Beetroot'),
  VegetableItem(name: 'Celery', emoji: '🌱', ttsPhrase: 'Celery'),
  VegetableItem(name: 'Garlic', emoji: '🧄', ttsPhrase: 'Garlic'),
  VegetableItem(name: 'Ginger', emoji: '🌰', ttsPhrase: 'Ginger'),
];
