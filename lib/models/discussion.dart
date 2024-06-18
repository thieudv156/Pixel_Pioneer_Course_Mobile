import 'package:course_template/models/sublesson.dart';
import 'package:course_template/models/userinformation.dart';

class Discussion {
  final int id;
  final SubLesson subLesson;
  final UserInformation user;
  final int? parentId;
  final String content;
  final DateTime createdAt;
  final List<int> childrenIds;

  Discussion({
    required this.id,
    required this.subLesson,
    required this.user,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.childrenIds,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      id: json['id'] ?? 0,
      subLesson: SubLesson.fromJson(json['subLesson']),
      user: UserInformation.fromJson(json['user']),
      parentId: json['parent'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      childrenIds:
          json['children'] != null ? List<int>.from(json['children']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subLesson': subLesson.toJson(),
      'user': user.toJson(),
      'parent': parentId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'children': childrenIds,
    };
  }
}
