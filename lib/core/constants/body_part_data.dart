class BodyPartItem {
  final String name;
  final String emoji;
  final String ttsPhrase;

  const BodyPartItem({
    required this.name,
    required this.emoji,
    required this.ttsPhrase,
  });
}

const List<BodyPartItem> bodyPartData = [
  BodyPartItem(name: 'Eyes', emoji: '👀', ttsPhrase: 'Eyes'),
  BodyPartItem(name: 'Nose', emoji: '👃', ttsPhrase: 'Nose'),
  BodyPartItem(name: 'Ears', emoji: '👂', ttsPhrase: 'Ears'),
  BodyPartItem(name: 'Mouth', emoji: '👄', ttsPhrase: 'Mouth'),
  BodyPartItem(name: 'Tongue', emoji: '👅', ttsPhrase: 'Tongue'),
  BodyPartItem(name: 'Teeth', emoji: '🦷', ttsPhrase: 'Teeth'),
  BodyPartItem(name: 'Hand', emoji: '✋', ttsPhrase: 'Hand'),
  BodyPartItem(name: 'Foot', emoji: '🦶', ttsPhrase: 'Foot'),
  BodyPartItem(name: 'Arm', emoji: '💪', ttsPhrase: 'Arm'),
  BodyPartItem(name: 'Leg', emoji: '🦵', ttsPhrase: 'Leg'),
  BodyPartItem(name: 'Head', emoji: '🧠', ttsPhrase: 'Head'),
  BodyPartItem(name: 'Heart', emoji: '❤️', ttsPhrase: 'Heart'),
  BodyPartItem(name: 'Hair', emoji: '💇', ttsPhrase: 'Hair'),
  BodyPartItem(name: 'Finger', emoji: '👆', ttsPhrase: 'Finger'),
  BodyPartItem(name: 'Toe', emoji: '🦶', ttsPhrase: 'Toe'),
  BodyPartItem(name: 'Knee', emoji: '🦵', ttsPhrase: 'Knee'),
  BodyPartItem(name: 'Elbow', emoji: '💪', ttsPhrase: 'Elbow'),
  BodyPartItem(name: 'Shoulder', emoji: '🦾', ttsPhrase: 'Shoulder'),
  BodyPartItem(name: 'Stomach', emoji: '🤰', ttsPhrase: 'Stomach'),
  BodyPartItem(name: 'Back', emoji: '🔙', ttsPhrase: 'Back'),
];
