import 'dart:convert';
import 'package:course_template/models/course.dart';
import 'package:course_template/utils/PublicBaseURL.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'course_details_screen.dart'; // Import your CourseDetailsScreen here

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  _MyCoursesScreenState createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  List<Course> ongoingCourses = [];
  List<Course> completedCourses = [];
  Map<int, double> courseCompletionPercentages = {};

  @override
  void initState() {
    super.initState();
    _fetchEnrolledCourses();
  }

  Future<void> _fetchEnrolledCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;

    try {
      // Fetch enrolled courses
      final response = await http
          .get(Uri.parse('$baseUrl/api/course/enrolled?userId=$userId'));

      if (response.statusCode == 200) {
        List<dynamic> coursesJson = jsonDecode(response.body);

        List<Course> allCourses =
            coursesJson.map((json) => Course.fromJson(json)).toList();

        for (Course course in allCourses) {
          // Fetch completion percentage for each course
          final percentResponse = await http.get(Uri.parse(
              '$baseUrl/api/progress/percent-progress-done?courseId=${course.id}&userId=$userId'));

          if (percentResponse.statusCode == 200) {
            double completionPercentage =
                double.tryParse(percentResponse.body) ?? 0.0;
            courseCompletionPercentages[course.id] = completionPercentage;

            if (completionPercentage < 100) {
              ongoingCourses.add(course);
            } else {
              completedCourses.add(course);
            }
          }
        }

        setState(() {});
      }
    } catch (e) {
      print('Error fetching enrolled courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Courses'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
              Tab(text: 'Badges'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOngoingTab(),
            _buildCompletedTab(),
            _buildCertificatesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: ongoingCourses.length,
      itemBuilder: (context, index) {
        Course course = ongoingCourses[index];
        double completionPercentage =
            courseCompletionPercentages[course.id] ?? 0.0;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(course.imageUrl),
          ),
          title: Text(course.title),
          subtitle: Text(course.instructorName),
          trailing: Text('${completionPercentage.toStringAsFixed(0)}%'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailsScreen(course: course),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCompletedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: completedCourses.length,
      itemBuilder: (context, index) {
        Course course = completedCourses[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(course.imageUrl),
          ),
          title: Text(course.title),
          subtitle: Text(course.instructorName),
          trailing: const Text('Add Reviews'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailsScreen(course: course),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCertificatesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: completedCourses.length,
      itemBuilder: (context, index) {
        Course course = completedCourses[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://th.bing.com/th/id/OIP.QVjRojMON6pQA1TROYGv3AHaHa?w=512&h=512&rs=1&pid=ImgDetMain'),
          ),
          title: const Text('Completion Badge'),
          subtitle: Text(course.title),
          onTap: () {
            // Handle certificate viewing or download here
          },
        );
      },
    );
  }
}
