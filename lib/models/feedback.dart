class FeedbackModel {
  final String id;
  final String userId;
  final String reviewId;
  final int score;
  final String? comment;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.reviewId,
    required this.score,
    this.comment,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
    id: json['id'],
    userId: json['userId'],
    reviewId: json['reviewId'],
    score: json['score'],
    comment: json['comment'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'reviewId': reviewId,
    'score': score,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
  };

  String get scoreText {
    if (score >= 9) return 'Excelente';
    if (score >= 7) return 'Bom';
    if (score >= 5) return 'Regular';
    if (score >= 3) return 'Ruim';
    return 'Péssimo';
  }
}
