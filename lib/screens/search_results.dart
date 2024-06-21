import 'package:flutter/material.dart';
import 'package:course_template/models/course.dart';
import 'package:course_template/screens/course_details_screen.dart';
import 'package:course_template/utils/PublicBaseURL.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<Course> searchResults;

  const SearchResultsScreen({Key? key, required this.searchResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final course = searchResults[index];
          return ListTile(
            leading: Image.network(
              course.imageUrl, // Use baseUrl to construct the full URL
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(course.title),
            subtitle: Text(course.instructorName),
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
      ),
    );
  }
}
