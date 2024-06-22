import 'package:course_template/models/sublesson.dart';
import 'package:course_template/models/userinformation.dart';

class Progress {
  final int id;
  final bool isCompleted;
  final SubLesson subLesson;
  final UserInformation user;

  Progress(
      {required this.id,
      required this.isCompleted,
      required this.subLesson,
      required this.user});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'],
      isCompleted: json['isCompleted'],
      subLesson: SubLesson.fromJson(json['subLesson']),
      user: UserInformation.fromJson(json['user']),
    );
  }
}
