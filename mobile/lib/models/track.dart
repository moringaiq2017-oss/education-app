class Track {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String color;
  final int order;
  final int totalLessons;
  final int completedLessons;

  Track({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.order,
    this.totalLessons = 0,
    this.completedLessons = 0,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'].toString(),
      title: json['name_ar'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '📚',
      color: json['color'] ?? '#6C63FF',
      order: json['display_order'] ?? json['order'] ?? 0,
      totalLessons: json['total_lessons'] ?? 0,
      completedLessons: json['completed_lessons'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'color': color,
      'order': order,
      'total_lessons': totalLessons,
      'completed_lessons': completedLessons,
    };
  }

  double get progress {
    if (totalLessons == 0) return 0.0;
    return completedLessons / totalLessons;
  }

  bool get isCompleted => completedLessons >= totalLessons && totalLessons > 0;
}
