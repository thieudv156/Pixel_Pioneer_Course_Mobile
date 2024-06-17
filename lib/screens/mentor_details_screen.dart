import 'package:flutter/material.dart';

class MentorDetailsScreen extends StatelessWidget {
  const MentorDetailsScreen({super.key, required String mentorName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mentor Detail'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Courses'),
              Tab(text: 'Students'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MentorCoursesTab(),
            MentorStudentsTab(),
            MentorReviewsTab(),
          ],
        ),
      ),
    );
  }
}

class MentorCoursesTab extends StatelessWidget {
  const MentorCoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildCourseCard(
          title: 'Application Design For Beginner',
          mentor: 'Huberta Raj',
          rating: 5.0,
        ),
        _buildCourseCard(
          title: 'Software Developments IT Company',
          mentor: 'Huberta Raj',
          rating: 5.0,
        ),
        _buildCourseCard(
          title: 'Graphics Design in Advance',
          mentor: 'Huberta Raj',
          rating: 5.0,
        ),
        // Add more course cards here
      ],
    );
  }

  Widget _buildCourseCard({required String title, required String mentor, required double rating}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/course.jpg'), // Placeholder image
        ),
        title: Text(title),
        subtitle: Text(mentor),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.yellow),
            const SizedBox(width: 4),
            Text(rating.toString()),
          ],
        ),
      ),
    );
  }
}

class MentorStudentsTab extends StatelessWidget {
  const MentorStudentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildStudentCard(
          name: 'Tisha Smith',
          role: 'Market Analysis',
        ),
        _buildStudentCard(
          name: 'Milanssh Davish',
          role: 'UI Designer',
        ),
        _buildStudentCard(
          name: 'Atticus Luca',
          role: 'Software Development',
        ),
        // Add more student cards here
      ],
    );
  }

  Widget _buildStudentCard({required String name, required String role}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/student.jpg'), // Placeholder image
        ),
        title: Text(name),
        subtitle: Text(role),
        trailing: const Icon(Icons.message, color: Colors.purple),
      ),
    );
  }
}

class MentorReviewsTab extends StatelessWidget {
  const MentorReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildReviewCard(
          name: 'Ryan Horward',
          review: 'I feel like I have learned a lot, and I can discuss any process of UX Design, which I couldn’t before.',
          date: 'Today | 12:40 PM',
        ),
        _buildReviewCard(
          name: 'James Willianns',
          review: 'Figma is like having a prototype design assistant, right at my finger tips. My team has come to see Figma',
          date: 'December 28 2022',
        ),
        _buildReviewCard(
          name: 'Elijah Hearny',
          review: 'I feel like I have learned a lot, and I can discuss any process of UX Design, which I couldn’t before.',
          date: 'Today | 12:40 PM',
        ),
        // Add more review cards here
      ],
    );
  }

  Widget _buildReviewCard({required String name, required String review, required String date}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/reviewer.jpg'), // Placeholder image
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(review),
            const SizedBox(height: 8),
            Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
