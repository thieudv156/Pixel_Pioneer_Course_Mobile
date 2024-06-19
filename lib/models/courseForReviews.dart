import 'package:course_template/models/userinformation.dart';

class Review {
  final int id;
  final String content;
  final DateTime createdAt;
  final int rating;
  final int courseId; // Only courseId instead of Course object
  final UserInformation user;

  Review({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.rating,
    required this.courseId,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      rating: json['rating'] ?? 0,
      courseId: json['course']['id'] ?? 0, // Only get courseId
      user: UserInformation.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'rating': rating,
      'courseId': courseId, // Only courseId
      'user': user.toJson(),
    };
  }
}
