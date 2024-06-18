import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:course_template/models/courseFull.dart';
import 'package:course_template/models/course.dart' as course_models;
import 'package:http/http.dart' as http;
import 'package:course_template/screens/sublesson_content_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  final course_models.Course course;

  const CourseDetailsScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool isFavorite = false;
  Course? fullCourse;

  @override
  void initState() {
    super.initState();
    _fetchFullCourseDetails();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCourseJsonList =
        prefs.getStringList('favoriteCourses') ?? [];
    setState(() {
      isFavorite = favoriteCourseJsonList.any((courseJson) {
        var storedCourse = jsonDecode(courseJson);
        return storedCourse['id'] == widget.course.id;
      });
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCourseJsonList =
        prefs.getStringList('favoriteCourses') ?? [];

    if (isFavorite) {
      favoriteCourseJsonList.removeWhere((courseJson) {
        var storedCourse = jsonDecode(courseJson);
        return storedCourse['id'] == widget.course.id;
      });
    } else {
      var courseMap = {
        'id': widget.course.id,
        'title': widget.course.title,
        'instructorName': widget.course.instructorName,
        'imageUrl': widget.course.imageUrl,
        'price': widget.course.price,
      };
      favoriteCourseJsonList.add(jsonEncode(courseMap));
    }

    await prefs.setStringList('favoriteCourses', favoriteCourseJsonList);

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _fetchFullCourseDetails() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/course/${widget.course.id}'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        fullCourse = Course.fromJson(jsonResponse);
      });
    } else {
      log('Failed to load full course details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: fullCourse == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Image.network(widget.course.imageUrl),
                const SizedBox(height: 16),
                Text(
                  widget.course.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${widget.course.price.toString()}',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'About Mentor',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://your-image-url.com/${widget.course.id}'),
                  ),
                  title: Text(widget.course.instructorName),
                  subtitle: Text(widget.course.id.toString()),
                ),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Lessons',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...fullCourse!.lessons
                    .map((lesson) => ExpansionTile(
                          title: Text('${lesson.orderNumber}. ${lesson.title}'),
                          children: lesson.subLessons
                              .map((subLesson) => ListTile(
                                    leading:
                                        const Icon(Icons.play_circle_outline),
                                    title: Text(subLesson.title),
                                    trailing:
                                        Text('${subLesson.orderNumber} Min'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubLessonContentScreen(
                                                  subLesson: subLesson),
                                        ),
                                      );
                                    },
                                  ))
                              .toList(),
                        ))
                    .toList(),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...fullCourse!.reviews
                    .map((review) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://your-image-url.com/${review.id}'),
                          ),
                          title: Text(review.content),
                          subtitle: Text('User review'),
                          trailing: Text('4.5'),
                        ))
                    .toList(),
                const Divider(),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
