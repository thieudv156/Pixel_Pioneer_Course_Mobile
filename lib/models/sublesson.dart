import 'package:course_template/models/payment_method.dart';
import 'package:course_template/models/SubscriptionType.dart';
import 'package:course_template/models/lesson.dart';
import 'package:course_template/models/enrollment.dart';
import 'package:course_template/models/discussion.dart';
import 'package:course_template/models/userinformation.dart';

class SubLesson {
  final int id;
  final String title;
  final Lesson lesson;
  final Enrollment enrollment;
  final String content;
  final int orderNumber;
  final DateTime createdAt;
  final List<Discussion> discussions;

  SubLesson({
    required this.id,
    required this.title,
    required this.lesson,
    required this.enrollment,
    required this.content,
    required this.orderNumber,
    required this.createdAt,
    required this.discussions,
  });

  factory SubLesson.fromJson(Map<String, dynamic> json) {
    return SubLesson(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      lesson: json['lesson'] != null
          ? Lesson.fromJson(json['lesson'])
          : Lesson(
              id: 0,
              title: '',
              course: 0,
              createdAt: DateTime.now(),
              orderNumber: 0,
              subLessons: []),
      enrollment: json['enrollment'] != null
          ? Enrollment.fromJson(json['enrollment'])
          : Enrollment(
              id: 0,
              user: UserInformation(
                  id: 0, fullName: '', email: '', username: '', roles: []),
              enrolledAt: DateTime.now(),
              paymentDate: DateTime.now(),
              paymentMethod: PaymentMethod.PAYPAL,
              paymentStatus: false,
              subscriptionStatus: false,
              subscriptionType: SubscriptionType.MONTHLY,
              subscriptionEndDate: DateTime.now()),
      content: json['content'] ?? '',
      orderNumber: json['orderNumber'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      discussions: json['discussions'] != null
          ? (json['discussions'] as List)
              .where((element) => element is Map<String, dynamic>)
              .map((discussion) => Discussion.fromJson(discussion))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lesson': lesson.toJson(),
      'enrollment': enrollment.toJson(),
      'content': content,
      'orderNumber': orderNumber,
      'createdAt': createdAt.toIso8601String(),
      'discussions':
          discussions.map((discussion) => discussion.toJson()).toList(),
    };
  }
}
