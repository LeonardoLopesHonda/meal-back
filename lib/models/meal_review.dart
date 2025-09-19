class MealReview {
  final String id;
  final String description;
  final DateTime dateOffered;
  final String period;
  final List<String> shifts;
  final DateTime closureDate;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final String createdBy;

  MealReview({
    required this.id,
    required this.description,
    required this.dateOffered,
    required this.period,
    required this.shifts,
    required this.closureDate,
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
    required this.createdBy,
  });

  factory MealReview.fromJson(Map<String, dynamic> json) => MealReview(
    id: json['id'],
    description: json['description'],
    dateOffered: DateTime.parse(json['dateOffered']),
    period: json['period'],
    shifts: List<String>.from(json['shifts']),
    closureDate: DateTime.parse(json['closureDate']),
    imageUrl: json['imageUrl'],
    isActive: json['isActive'] ?? true,
    createdAt: DateTime.parse(json['createdAt']),
    createdBy: json['createdBy'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'dateOffered': dateOffered.toIso8601String(),
    'period': period,
    'shifts': shifts,
    'closureDate': closureDate.toIso8601String(),
    'imageUrl': imageUrl,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'createdBy': createdBy,
  };

  bool get isOpen => isActive && DateTime.now().isBefore(closureDate);

  String get formattedPeriod {
    switch (period.toLowerCase()) {
      case 'morning':
        return 'Manhã';
      case 'afternoon':
        return 'Tarde';
      case 'evening':
        return 'Noite';
      default:
        return period;
    }
  }
}
