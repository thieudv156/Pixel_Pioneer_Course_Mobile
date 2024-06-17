import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:course_template/models/course.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  const CourseDetailsScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteCourseJsonList =
        prefs.getStringList('favoriteCourses') ?? [];
    setState(() {
      isFavorite = favoriteCourseJsonList.any((courseJson) {
        var storedCourse = jsonDecode(courseJson);
        return storedCourse['title'] == widget.course.title;
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
        return storedCourse['title'] == widget.course.title;
      });
    } else {
      var courseMap = {
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
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
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            title: Text(widget.course.instructorName),
            subtitle: Text('Senior UI - UX Designer'),
          ),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Lesson',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            title: const Text('1. Getting Started'),
            children: [
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('Introduction to Course'),
                trailing: const Text('10 Min'),
                onTap: () {},
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('2. Create UI Design in Figma'),
            children: [
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('Create Frame in Figma'),
                trailing: const Text('15 Min'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: const Text('Using Plugin in Figma'),
                trailing: const Text('20 Min'),
                onTap: () {},
              ),
            ],
          ),
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
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            title: Text('Ryan Horward'),
            subtitle: Text(
              'I feel like I have learned a lot, and I can discuss any process of UX Design...',
            ),
            trailing: Text('4.5'),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            title: Text('James Williams'),
            subtitle: Text(
              'Figma is like having a prototype design assistant, right at my finger tips...',
            ),
            trailing: Text('4.8'),
          ),
          const Divider(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
