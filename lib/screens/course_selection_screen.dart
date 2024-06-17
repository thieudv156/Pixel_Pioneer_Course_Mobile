import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:course_template/models/category.dart';
import 'package:course_template/models/course.dart';
import 'package:course_template/screens/course_details_screen.dart';

class CourseListScreen extends StatefulWidget {
  final Category category;

  const CourseListScreen({super.key, required this.category});

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  List<Course> courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/api/course/categoryDto/${widget.category.id}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Course> fetchedCourses =
            data.map((json) => Course.fromJson(json)).toList();
        setState(() {
          courses = fetchedCourses;
          _isLoading = false;
        });
      } else {
        // Handle error
        log('Failed to load courses. Status code: ${response.statusCode}');
        setState(() {
          courses = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        courses = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category.name} Courses'),
        backgroundColor: Colors.purple[100],
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Instructor: ${course.instructorName}"),
                          Text('Price: \$${course.price.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_right_alt_rounded,
                        color: Colors.green,
                      ),
                      onTap: () {
                        // Handle course card tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CourseDetailsScreen(courseName: course.title),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
