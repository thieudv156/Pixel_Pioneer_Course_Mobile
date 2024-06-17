import 'package:course_template/screens/change_password_screen.dart';
import 'package:course_template/screens/favorite_course_screen.dart';
import 'package:course_template/screens/my_courses_screen.dart';
import 'package:course_template/screens/payment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userFullname = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserFullname();
  }

  Future<void> _loadUserFullname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userFullname = prefs.getString("userFullname") ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(height: 8),
              Text(
                _userFullname,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ProfileOption(
                icon: Icons.person,
                text: 'My Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfileScreen()),
                  );
                },
              ),
              ProfileOption(
                icon: Icons.library_books,
                text: 'My Courses',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyCoursesScreen()),
                  );
                },
              ),
              ProfileOption(
                icon: Icons.payment,
                text: 'My Payment',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentDetailScreen()),
                  );
                },
              ),
              ProfileOption(
                icon: Icons.favorite,
                text: 'My Favorite Courses',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoriteCoursesScreen()),
                  );
                },
              ),
              ProfileOption(
                icon: Icons.lock,
                text: 'Change Password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()),
                  );
                },
              ),
              ProfileOption(
                icon: Icons.live_tv,
                text: 'Live Sessions',
                onTap: () {
                  // Navigate to Live Sessions screen
                },
              ),
              ProfileOption(
                icon: Icons.subscriptions,
                text: 'Subscription Plan',
                onTap: () {
                  // Navigate to Subscription Plan screen
                },
              ),
              ProfileOption(
                icon: Icons.logout,
                text: 'Logout',
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
