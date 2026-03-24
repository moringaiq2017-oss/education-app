class Child {
  final String id;
  final String name;
  final int age;
  final String deviceId;
  final DateTime createdAt;

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.deviceId,
    required this.createdAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      deviceId: json['device_id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'device_id': deviceId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Child copyWith({
    String? id,
    String? name,
    int? age,
    String? deviceId,
    DateTime? createdAt,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
