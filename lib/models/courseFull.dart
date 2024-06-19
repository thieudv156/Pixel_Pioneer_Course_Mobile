import 'package:course_template/models/category.dart';
import 'package:course_template/models/userinformation.dart';
import 'package:course_template/models/image.dart';
import 'package:course_template/models/review.dart';
import 'package:course_template/models/lesson.dart';

class Course {
  final int id;
  final String title;
  final Category category;
  final String description;
  final double price;
  final UserInformation instructor;
  final bool isPublished;
  final DateTime createdAt;
  final Image frontPageImage;
  final List<Review> reviews;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.instructor,
    required this.isPublished,
    required this.createdAt,
    required this.frontPageImage,
    required this.reviews,
    required this.lessons,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : Category.fromJson({}),
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      instructor: json['instructor'] != null
          ? UserInformation.fromJson(json['instructor'])
          : UserInformation.fromJson({}),
      isPublished: json['isPublished'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      frontPageImage: json['frontPageImage'] != null
          ? Image.fromJson(json['frontPageImage'])
          : Image.fromJson({}),
      reviews: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((review) => Review.fromJson(review))
              .toList()
          : [],
      lessons: json['lessons'] != null
          ? (json['lessons'] as List)
              .map((lesson) => Lesson.fromJson(lesson))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.toJson(),
      'description': description,
      'price': price,
      'instructor': instructor.toJson(),
      'isPublished': isPublished,
      'createdAt': createdAt.toIso8601String(),
      'frontPageImage': frontPageImage.toJson(),
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}
