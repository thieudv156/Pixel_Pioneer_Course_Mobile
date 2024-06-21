import 'package:course_template/models/sublesson.dart';
import 'package:course_template/models/userinformation.dart';

class Discussion {
  final int id;
  final SubLesson subLesson;
  final UserInformation user;
  final int? parentId;
  String content;
  final DateTime createdAt;
  DateTime? editedAt;
  final List<Discussion> children;
  bool isEditing = false;
  String? editedContent;

  Discussion({
    required this.id,
    required this.subLesson,
    required this.user,
    this.parentId,
    required this.content,
    required this.createdAt,
    this.editedAt,
    required this.children,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      id: json['id'] ?? 0,
      subLesson: SubLesson.fromJson(json['subLesson']),
      user: UserInformation.fromJson(json['user']),
      parentId: json['parent'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      editedAt:
          json['editedAt'] != null ? DateTime.parse(json['editedAt']) : null,
      children: json['children'] != null
          ? (json['children'] as List)
              .where((i) => i is Map<String, dynamic>)
              .map((i) => Discussion.fromJson(i))
              .toList()
          : [],
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
      'editedAt': editedAt?.toIso8601String(),
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}
