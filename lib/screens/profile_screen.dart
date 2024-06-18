import 'dart:convert';
import 'dart:developer';

import 'package:course_template/screens/change_password_screen.dart';
import 'package:course_template/screens/favorite_course_screen.dart';
import 'package:course_template/screens/my_courses_screen.dart';
import 'package:course_template/screens/payment_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_profile_screen.dart';
import 'package:http/http.dart' as http;

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

  Future<void> _fetchSubscriptionDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");
    if (userId == null) {
      _showErrorDialog("User not authenticated");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/api/enrollments/get-subscription?userId=$userId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> subscriptionDetails = jsonDecode(response.body);
        _showSubscriptionDialog(subscriptionDetails);
      } else {
        _showErrorDialog("Failed to fetch subscription details");
      }
    } catch (e) {
      _showErrorDialog("Error fetching subscription details: $e");
    }
  }

  void _showSubscriptionDialog(List<dynamic> subscriptionDetails) {
    // Convert list to set and back to list to remove duplicates
    var uniqueDetails = subscriptionDetails.toSet().toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Subscription Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: uniqueDetails.map((detail) {
              Map<String, dynamic> detailMap = detail as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User: ${detailMap['user_name']}"),
                  Text(
                      "Subscription Status: ${detailMap['subscription_state']}"),
                  Text("Package: ${detailMap['subscription_package_name']}"),
                  Text("Validity: ${detailMap['validity']}"),
                  const Divider(), // Optional: Divider between items
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                onTap: _fetchSubscriptionDetails,
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
