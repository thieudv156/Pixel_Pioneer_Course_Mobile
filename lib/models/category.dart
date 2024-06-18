class Category {
  final int id;
  final String name;
  final int courseCount;

  Category({required this.id, required this.name, required this.courseCount});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      courseCount: json['courseCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'courseCount': courseCount,
    };
  }
}
