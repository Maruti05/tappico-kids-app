class VehicleItem {
  final String name;
  final String emoji;
  final String ttsPhrase;

  const VehicleItem({
    required this.name,
    required this.emoji,
    required this.ttsPhrase,
  });
}

const List<VehicleItem> vehicleData = [
  VehicleItem(name: 'Car', emoji: '🚗', ttsPhrase: 'Car'),
  VehicleItem(name: 'Bus', emoji: '🚌', ttsPhrase: 'Bus'),
  VehicleItem(name: 'Truck', emoji: '🚛', ttsPhrase: 'Truck'),
  VehicleItem(name: 'Bicycle', emoji: '🚲', ttsPhrase: 'Bicycle'),
  VehicleItem(name: 'Motorcycle', emoji: '🏍️', ttsPhrase: 'Motorcycle'),
  VehicleItem(name: 'Train', emoji: '🚂', ttsPhrase: 'Train'),
  VehicleItem(name: 'Airplane', emoji: '✈️', ttsPhrase: 'Airplane'),
  VehicleItem(name: 'Helicopter', emoji: '🚁', ttsPhrase: 'Helicopter'),
  VehicleItem(name: 'Boat', emoji: '⛵', ttsPhrase: 'Boat'),
  VehicleItem(name: 'Ship', emoji: '🚢', ttsPhrase: 'Ship'),
  VehicleItem(name: 'Submarine', emoji: '🛳️', ttsPhrase: 'Submarine'),
  VehicleItem(name: 'Rocket', emoji: '🚀', ttsPhrase: 'Rocket'),
  VehicleItem(name: 'Tractor', emoji: '🚜', ttsPhrase: 'Tractor'),
  VehicleItem(name: 'Ambulance', emoji: '🚑', ttsPhrase: 'Ambulance'),
  VehicleItem(name: 'Fire Truck', emoji: '🚒', ttsPhrase: 'Fire Truck'),
  VehicleItem(name: 'Police Car', emoji: '🚓', ttsPhrase: 'Police Car'),
  VehicleItem(name: 'Taxi', emoji: '🚕', ttsPhrase: 'Taxi'),
  VehicleItem(name: 'Scooter', emoji: '🛴', ttsPhrase: 'Scooter'),
  VehicleItem(name: 'Bulldozer', emoji: '🚜', ttsPhrase: 'Bulldozer'),
  VehicleItem(name: 'Hot Air Balloon', emoji: '🎈', ttsPhrase: 'Hot Air Balloon'),
];
