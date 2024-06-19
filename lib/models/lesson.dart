import 'package:course_template/models/sublesson.dart';

class Lesson {
  final int id;
  final String title;
  final int course;
  final DateTime createdAt;
  final int orderNumber;
  final List<SubLesson> subLessons;

  Lesson({
    required this.id,
    required this.title,
    required this.course,
    required this.createdAt,
    required this.orderNumber,
    required this.subLessons,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      course: json['course'] is int ? json['course'] : json['course']['id'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      orderNumber: json['orderNumber'] ?? 0,
      subLessons: json['subLessons'] != null
          ? (json['subLessons'] as List)
              .where((element) => element is Map<String, dynamic>)
              .map((subLesson) => SubLesson.fromJson(subLesson))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'course': course,
      'createdAt': createdAt.toIso8601String(),
      'orderNumber': orderNumber,
      'subLessons': subLessons.map((subLesson) => subLesson.toJson()).toList(),
    };
  }
}
