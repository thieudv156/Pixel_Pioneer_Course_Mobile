import 'package:flutter/material.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseName;

  const CourseDetailsScreen({Key? key, required this.courseName}) : super(key: key);

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
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
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
            courseName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '\$250',
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
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            title: Text('Huberta Raj'),
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
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            title: Text('Ryan Horward'),
            subtitle: Text(
              'I feel like I have learned a lot, and I can discuss any process of UX Design...',
            ),
            trailing: Text('4.5'),
          ),
          const ListTile(
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
          ElevatedButton(
            onPressed: () {},
            child: const Text('Enroll Course - \$250'),
          ),
        ],
      ),
    );
  }
}
