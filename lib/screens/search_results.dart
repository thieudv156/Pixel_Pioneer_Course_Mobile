import 'package:course_template/models/course.dart';
import 'package:course_template/screens/course_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchResultsScreen extends StatefulWidget {
  final List<Course> searchResults;

  const SearchResultsScreen({Key? key, required this.searchResults})
      : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Map<String, dynamic>> coursesWithInstructors = [];

  @override
  void initState() {
    super.initState();
    _fetchInstructorNames();
  }

  Future<void> _fetchInstructorNames() async {
    List<Map<String, dynamic>> updatedCourses = [];
    for (var course in widget.searchResults) {
      final instructorName = await _getInstructorName(course.title);
      updatedCourses.add({
        'course': course,
        'instructorName': instructorName,
      });
    }
    setState(() {
      coursesWithInstructors = updatedCourses;
    });
  }

  Future<String> _getInstructorName(String courseTitle) async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/api/course/search/instructor?title=$courseTitle'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as String;
    } else {
      return 'Anonymous';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: coursesWithInstructors.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: coursesWithInstructors.length,
              itemBuilder: (context, index) {
                final course =
                    coursesWithInstructors[index]['course'] as Course;
                final instructorName =
                    coursesWithInstructors[index]['instructorName'] as String;
                return ListTile(
                  leading: Image.network(
                    course.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(course.title),
                  subtitle: Text(instructorName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailsScreen(
                          courseName: course.title,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
