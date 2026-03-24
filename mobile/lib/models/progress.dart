class Progress {
  final String id;
  final String childId;
  final String lessonId;
  final bool isCompleted;
  final int timeSpentSeconds;
  final int? score;
  final DateTime? completedAt;
  final DateTime updatedAt;

  Progress({
    required this.id,
    required this.childId,
    required this.lessonId,
    this.isCompleted = false,
    this.timeSpentSeconds = 0,
    this.score,
    this.completedAt,
    required this.updatedAt,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'].toString(),
      childId: json['child_id'].toString(),
      lessonId: json['lesson_id'].toString(),
      isCompleted: json['is_completed'] ?? false,
      timeSpentSeconds: json['time_spent_seconds'] ?? 0,
      score: json['score'],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child_id': childId,
      'lesson_id': lessonId,
      'is_completed': isCompleted,
      'time_spent_seconds': timeSpentSeconds,
      'score': score,
      'completed_at': completedAt?.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get timeSpentFormatted {
    final minutes = timeSpentSeconds ~/ 60;
    final seconds = timeSpentSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Progress copyWith({
    String? id,
    String? childId,
    String? lessonId,
    bool? isCompleted,
    int? timeSpentSeconds,
    int? score,
    DateTime? completedAt,
    DateTime? updatedAt,
  }) {
    return Progress(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      lessonId: lessonId ?? this.lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
      score: score ?? this.score,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
