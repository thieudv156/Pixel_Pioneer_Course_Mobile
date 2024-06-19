import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:course_template/models/course.dart';
import 'package:course_template/screens/course_details_screen.dart';
import 'package:course_template/utils/PublicBaseURL.dart'; // Import the PublicBaseURL file

class FavoriteCoursesScreen extends StatefulWidget {
  const FavoriteCoursesScreen({super.key});

  @override
  _FavoriteCoursesScreenState createState() => _FavoriteCoursesScreenState();
}

class _FavoriteCoursesScreenState extends State<FavoriteCoursesScreen> {
  List<Course> favoriteCourses = [];
  List<String> instructorNames = [];
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCourses();
  }

  Future<void> _loadFavoriteCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCourseJsonList =
        prefs.getStringList('favoriteCourses') ?? [];

    List<Course> courses = [];
    List<String> instructors = [];
    List<String> images = [];

    for (var courseJson in favoriteCourseJsonList) {
      var courseMap = jsonDecode(courseJson);
      log(courseMap['instructorName'].toString());
      courses.add(Course.fromJson(courseMap));
      instructors.add(courseMap['instructorName']);
      images.add(courseMap['imageUrl']);
    }

    setState(() {
      favoriteCourses = courses;
      instructorNames = instructors;
      imageUrls = images;
    });
  }

  Future<void> _removeFromFavorites(int courseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCourseJsonList =
        prefs.getStringList('favoriteCourses') ?? [];

    favoriteCourseJsonList.removeWhere((courseJson) {
      var courseMap = jsonDecode(courseJson);
      return courseMap['id'] == courseId;
    });

    await prefs.setStringList('favoriteCourses', favoriteCourseJsonList);
    _loadFavoriteCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Courses'),
      ),
      body: favoriteCourses.isEmpty
          ? const Center(
              child: Text(
                "You don't have any favorite course. Try adding some :)",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                final course = favoriteCourses[index];
                final instructorName = instructorNames[index];
                final imageUrl = imageUrls[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Instructor: $instructorName"),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _removeFromFavorites(course.id),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailsScreen(course: course),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
