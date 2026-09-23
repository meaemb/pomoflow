class SavedStep {
  final String id;
  final String title;
  final String description;
  final int durationInMinutes;
  final int quantity;

  SavedStep({
    required this.id,
    required this.title,
    required this.description,
    required this.durationInMinutes,
    required this.quantity,
  });

  double get totalMinutes => (durationInMinutes * quantity).toDouble();  // ← исправлено
}