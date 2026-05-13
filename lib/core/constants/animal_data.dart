enum AnimalCategory { domestic, wild, insect }

class AnimalItem {
  final String name;
  final String emoji;
  final String ttsPhrase;
  final AnimalCategory category;

  const AnimalItem({
    required this.name,
    required this.emoji,
    required this.ttsPhrase,
    required this.category,
  });
}

const List<AnimalItem> domesticAnimalData = [
  AnimalItem(name: 'Dog', emoji: '🐕', ttsPhrase: 'Dog', category: AnimalCategory.domestic),
  AnimalItem(name: 'Cat', emoji: '🐈', ttsPhrase: 'Cat', category: AnimalCategory.domestic),
  AnimalItem(name: 'Cow', emoji: '🐄', ttsPhrase: 'Cow', category: AnimalCategory.domestic),
  AnimalItem(name: 'Horse', emoji: '🐎', ttsPhrase: 'Horse', category: AnimalCategory.domestic),
  AnimalItem(name: 'Pig', emoji: '🐖', ttsPhrase: 'Pig', category: AnimalCategory.domestic),
  AnimalItem(name: 'Sheep', emoji: '🐑', ttsPhrase: 'Sheep', category: AnimalCategory.domestic),
  AnimalItem(name: 'Goat', emoji: '🐐', ttsPhrase: 'Goat', category: AnimalCategory.domestic),
  AnimalItem(name: 'Rabbit', emoji: '🐇', ttsPhrase: 'Rabbit', category: AnimalCategory.domestic),
  AnimalItem(name: 'Hamster', emoji: '🐹', ttsPhrase: 'Hamster', category: AnimalCategory.domestic),
  AnimalItem(name: 'Mouse', emoji: '🐁', ttsPhrase: 'Mouse', category: AnimalCategory.domestic),
  AnimalItem(name: 'Goldfish', emoji: '🐟', ttsPhrase: 'Goldfish', category: AnimalCategory.domestic),
  AnimalItem(name: 'Turtle', emoji: '🐢', ttsPhrase: 'Turtle', category: AnimalCategory.domestic),
  AnimalItem(name: 'Camel', emoji: '🐪', ttsPhrase: 'Camel', category: AnimalCategory.domestic),
  AnimalItem(name: 'Frog', emoji: '🐸', ttsPhrase: 'Frog', category: AnimalCategory.domestic),
  AnimalItem(name: 'Lizard', emoji: '🦎', ttsPhrase: 'Lizard', category: AnimalCategory.domestic),
  AnimalItem(name: 'Hedgehog', emoji: '🦔', ttsPhrase: 'Hedgehog', category: AnimalCategory.domestic),
];

const List<AnimalItem> wildAnimalData = [
  AnimalItem(name: 'Lion', emoji: '🦁', ttsPhrase: 'Lion', category: AnimalCategory.wild),
  AnimalItem(name: 'Tiger', emoji: '🐅', ttsPhrase: 'Tiger', category: AnimalCategory.wild),
  AnimalItem(name: 'Elephant', emoji: '🐘', ttsPhrase: 'Elephant', category: AnimalCategory.wild),
  AnimalItem(name: 'Giraffe', emoji: '🦒', ttsPhrase: 'Giraffe', category: AnimalCategory.wild),
  AnimalItem(name: 'Zebra', emoji: '🦓', ttsPhrase: 'Zebra', category: AnimalCategory.wild),
  AnimalItem(name: 'Bear', emoji: '🐻', ttsPhrase: 'Bear', category: AnimalCategory.wild),
  AnimalItem(name: 'Wolf', emoji: '🐺', ttsPhrase: 'Wolf', category: AnimalCategory.wild),
  AnimalItem(name: 'Fox', emoji: '🦊', ttsPhrase: 'Fox', category: AnimalCategory.wild),
  AnimalItem(name: 'Deer', emoji: '🦌', ttsPhrase: 'Deer', category: AnimalCategory.wild),
  AnimalItem(name: 'Monkey', emoji: '🐒', ttsPhrase: 'Monkey', category: AnimalCategory.wild),
  AnimalItem(name: 'Gorilla', emoji: '🦍', ttsPhrase: 'Gorilla', category: AnimalCategory.wild),
  AnimalItem(name: 'Hippopotamus', emoji: '🦛', ttsPhrase: 'Hippopotamus', category: AnimalCategory.wild),
  AnimalItem(name: 'Rhinoceros', emoji: '🦏', ttsPhrase: 'Rhinoceros', category: AnimalCategory.wild),
  AnimalItem(name: 'Kangaroo', emoji: '🦘', ttsPhrase: 'Kangaroo', category: AnimalCategory.wild),
  AnimalItem(name: 'Koala', emoji: '🐨', ttsPhrase: 'Koala', category: AnimalCategory.wild),
  AnimalItem(name: 'Panda', emoji: '🐼', ttsPhrase: 'Panda', category: AnimalCategory.wild),
  AnimalItem(name: 'Leopard', emoji: '🐆', ttsPhrase: 'Leopard', category: AnimalCategory.wild),
  AnimalItem(name: 'Crocodile', emoji: '🐊', ttsPhrase: 'Crocodile', category: AnimalCategory.wild),
  AnimalItem(name: 'Snake', emoji: '🐍', ttsPhrase: 'Snake', category: AnimalCategory.wild),
  AnimalItem(name: 'Whale', emoji: '🐋', ttsPhrase: 'Whale', category: AnimalCategory.wild),
  AnimalItem(name: 'Dolphin', emoji: '🐬', ttsPhrase: 'Dolphin', category: AnimalCategory.wild),
  AnimalItem(name: 'Shark', emoji: '🦈', ttsPhrase: 'Shark', category: AnimalCategory.wild),
  AnimalItem(name: 'Octopus', emoji: '🐙', ttsPhrase: 'Octopus', category: AnimalCategory.wild),
  AnimalItem(name: 'Crab', emoji: '🦀', ttsPhrase: 'Crab', category: AnimalCategory.wild),
  AnimalItem(name: 'Bat', emoji: '🦇', ttsPhrase: 'Bat', category: AnimalCategory.wild),
  AnimalItem(name: 'Raccoon', emoji: '🦝', ttsPhrase: 'Raccoon', category: AnimalCategory.wild),
  AnimalItem(name: 'Squirrel', emoji: '🐿️', ttsPhrase: 'Squirrel', category: AnimalCategory.wild),
  AnimalItem(name: 'Sloth', emoji: '🦥', ttsPhrase: 'Sloth', category: AnimalCategory.wild),
  AnimalItem(name: 'Polar Bear', emoji: '🐻‍❄️', ttsPhrase: 'Polar Bear', category: AnimalCategory.wild),
  AnimalItem(name: 'Chameleon', emoji: '🦎', ttsPhrase: 'Chameleon', category: AnimalCategory.wild),
  AnimalItem(name: 'Jellyfish', emoji: '🪼', ttsPhrase: 'Jellyfish', category: AnimalCategory.wild),
];

const List<AnimalItem> insectAnimalData = [
  AnimalItem(name: 'Butterfly', emoji: '🦋', ttsPhrase: 'Butterfly', category: AnimalCategory.insect),
  AnimalItem(name: 'Bee', emoji: '🐝', ttsPhrase: 'Bee', category: AnimalCategory.insect),
  AnimalItem(name: 'Ant', emoji: '🐜', ttsPhrase: 'Ant', category: AnimalCategory.insect),
  AnimalItem(name: 'Spider', emoji: '🕷️', ttsPhrase: 'Spider', category: AnimalCategory.insect),
  AnimalItem(name: 'Scorpion', emoji: '🦂', ttsPhrase: 'Scorpion', category: AnimalCategory.insect),
  AnimalItem(name: 'Grasshopper', emoji: '🦗', ttsPhrase: 'Grasshopper', category: AnimalCategory.insect),
  AnimalItem(name: 'Ladybug', emoji: '🐞', ttsPhrase: 'Ladybug', category: AnimalCategory.insect),
  AnimalItem(name: 'Mosquito', emoji: '🦟', ttsPhrase: 'Mosquito', category: AnimalCategory.insect),
  AnimalItem(name: 'Dragonfly', emoji: '🪰', ttsPhrase: 'Dragonfly', category: AnimalCategory.insect),
  AnimalItem(name: 'Caterpillar', emoji: '🐛', ttsPhrase: 'Caterpillar', category: AnimalCategory.insect),
  AnimalItem(name: 'Cockroach', emoji: '🪳', ttsPhrase: 'Cockroach', category: AnimalCategory.insect),
];

const List<AnimalItem> animalData = [
  ...domesticAnimalData,
  ...wildAnimalData,
  ...insectAnimalData,
];
