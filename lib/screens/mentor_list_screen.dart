import 'package:flutter/material.dart';
import 'mentor_details_screen.dart';

class MentorListScreen extends StatelessWidget {
  const MentorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentors'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
        itemCount: 15,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MentorDetailsScreen(mentorName: 'Pixel Mentor',)),
              );
            },
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mentor Name',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Mentor Job',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
