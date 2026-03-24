class Lesson {
  final String id;
  final String trackId;
  final String title;
  final String description;
  final String content;
  final String contentType; // text, video, quiz, activity
  final int order;
  final int durationMinutes;
  final bool isCompleted;
  final bool isLocked;
  final String? videoUrl;
  final List<Question>? questions;

  Lesson({
    required this.id,
    required this.trackId,
    required this.title,
    required this.description,
    required this.content,
    required this.contentType,
    required this.order,
    this.durationMinutes = 5,
    this.isCompleted = false,
    this.isLocked = false,
    this.videoUrl,
    this.questions,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'].toString(),
      trackId: json['track_id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      contentType: json['content_type'] ?? 'text',
      order: json['order'] ?? 0,
      durationMinutes: json['duration_minutes'] ?? 5,
      isCompleted: json['is_completed'] ?? false,
      isLocked: json['is_locked'] ?? false,
      videoUrl: json['video_url'],
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((q) => Question.fromJson(q))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'track_id': trackId,
      'title': title,
      'description': description,
      'content': content,
      'content_type': contentType,
      'order': order,
      'duration_minutes': durationMinutes,
      'is_completed': isCompleted,
      'is_locked': isLocked,
      'video_url': videoUrl,
      'questions': questions?.map((q) => q.toJson()).toList(),
    };
  }

  Lesson copyWith({
    String? id,
    String? trackId,
    String? title,
    String? description,
    String? content,
    String? contentType,
    int? order,
    int? durationMinutes,
    bool? isCompleted,
    bool? isLocked,
    String? videoUrl,
    List<Question>? questions,
  }) {
    return Lesson(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      contentType: contentType ?? this.contentType,
      order: order ?? this.order,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      videoUrl: videoUrl ?? this.videoUrl,
      questions: questions ?? this.questions,
    );
  }
}

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'].toString(),
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
    };
  }
}
