import 'package:flutter/material.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

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
              Tab(text: 'Certificates'),
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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/course.jpg'),
          ),
          title: const Text('Learn UI - UX For Beginners'),
          subtitle: const Text('Huberta Raj'),
          trailing: const Text('75%'),
        ),
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/course.jpg'),
          ),
          title: const Text('Application Design For Beginner'),
          subtitle: const Text('Penelo Tucker'),
          trailing: const Text('50%'),
        ),
        // Add more ListTiles here
      ],
    );
  }

  Widget _buildCompletedTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/course.jpg'),
          ),
          title: const Text('Upwork Training'),
          subtitle: const Text('15 Min'),
          trailing: const Text('Add Reviews'),
        ),
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/course.jpg'),
          ),
          title: const Text('What Is Design Thinking?'),
          subtitle: const Text('20 Min'),
          trailing: const Text('Add Reviews'),
        ),
        // Add more ListTiles here
      ],
    );
  }

  Widget _buildCertificatesTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/certificate.jpg'),
          ),
          title: const Text('Certificate of Completion'),
          subtitle: const Text('Learn UI - UX For Beginners'),
        ),
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/certificate.jpg'),
          ),
          title: const Text('Certificate of Excellence'),
          subtitle: const Text('Application Design For Beginner'),
        ),
        // Add more ListTiles here
      ],
    );
  }
}
