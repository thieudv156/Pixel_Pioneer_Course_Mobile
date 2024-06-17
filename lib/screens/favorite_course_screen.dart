import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:course_template/models/course.dart';
import 'package:course_template/screens/course_details_screen.dart';

class FavoriteCoursesScreen extends StatefulWidget {
  const FavoriteCoursesScreen({super.key});

  @override
  _FavoriteCoursesScreenState createState() => _FavoriteCoursesScreenState();
}

class _FavoriteCoursesScreenState extends State<FavoriteCoursesScreen> {
  List<Course> favoriteCourses = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteCourses();
  }

  Future<void> _loadFavoriteCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCourseJsonList =
        prefs.getStringList('favoriteCourses') ?? [];

    List<Course> courses = favoriteCourseJsonList.map((courseJson) {
      var courseMap = jsonDecode(courseJson);
      return Course.fromJson(courseMap);
    }).toList();

    setState(() {
      favoriteCourses = courses;
    });
  }

  Future<void> _removeFromFavorites(String courseTitle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCourseJsonList =
        prefs.getStringList('favoriteCourses') ?? [];

    favoriteCourseJsonList.removeWhere((courseJson) {
      var courseMap = jsonDecode(courseJson);
      return courseMap['title'] == courseTitle;
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
                        course.imageUrl,
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Instructor: ${course.instructorName}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _removeFromFavorites(course.title),
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
