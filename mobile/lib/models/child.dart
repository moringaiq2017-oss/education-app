class Child {
  final String id;
  final String name;
  final int age;
  final String deviceId;
  final String avatar;
  final bool isPremium;
  final DateTime createdAt;

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.deviceId,
    this.avatar = 'default',
    this.isPremium = false,
    required this.createdAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      deviceId: json['device_id'] ?? '',
      avatar: json['avatar'] ?? 'default',
      isPremium: json['is_premium'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'device_id': deviceId,
      'avatar': avatar,
      'is_premium': isPremium,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Child copyWith({
    String? id,
    String? name,
    int? age,
    String? deviceId,
    String? avatar,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      deviceId: deviceId ?? this.deviceId,
      avatar: avatar ?? this.avatar,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
