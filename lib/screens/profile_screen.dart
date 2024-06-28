import 'dart:convert';
import 'package:course_template/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:course_template/screens/change_password_screen.dart';
import 'package:course_template/screens/favorite_course_screen.dart';
import 'package:course_template/screens/my_courses_screen.dart';
import 'package:course_template/screens/payment_details_screen.dart';
import 'my_profile_screen.dart';
import 'package:course_template/utils/PublicBaseURL.dart'; // Import the base URL

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
        Uri.parse('$baseUrl/api/enrollments/get-subscription?userId=$userId'),
      );

      if (response.statusCode == 200) {
        List<dynamic> subscriptionDetails = jsonDecode(response.body);

        // Process the details to format validity and subscription state
        List<Map<String, dynamic>> processedDetails =
            subscriptionDetails.map((detail) {
          Map<String, dynamic> detailMap = detail as Map<String, dynamic>;
          return detailMap;
        }).toList();

        _showSubscriptionDialog(processedDetails);
      } else {
        _showSuccessDialog("You might have not purchased a plan.");
      }
    } catch (e) {
      _showErrorDialog("Error fetching subscription details: $e");
    }
  }

  void _showSubscriptionDialog(List<dynamic> subscriptionDetails) {
    var uniqueDetails = subscriptionDetails.toSet().toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Subscription Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: uniqueDetails
                  .map((detail) {
                    Map<String, dynamic> detailMap =
                        detail as Map<String, dynamic>;

                    // Filter out null details
                    List<Widget> detailsWidgets = [];
                    if (detailMap['user_name'] != null) {
                      detailsWidgets
                          .add(Text("User: ${detailMap['user_name']}"));
                    }
                    if (detailMap['subscription_state'] != null) {
                      bool isActive = detailMap['subscription_state'] == 'true';
                      detailsWidgets.add(Text(
                          "Subscription Status: ${isActive ? 'Activated' : 'Deactivated'}"));
                    }
                    if (detailMap['subscription_package_name'] != null) {
                      detailsWidgets.add(Text(
                          "Package: ${detailMap['subscription_package_name']}"));
                    }
                    if (detailMap['validity'] != null) {
                      try {
                        detailsWidgets.add(Text(
                            "Validity: ${detailMap['validity']} days left"));
                      } catch (e) {
                        detailsWidgets.add(Text("Validity: Invalid format"));
                      }
                    }
                    detailsWidgets.add(const Divider());

                    // Check if the detailsWidgets is empty after filtering
                    if (detailsWidgets.length <= 1) {
                      // Only Divider was added
                      return Container();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: detailsWidgets,
                    );
                  })
                  .where((widget) => widget is! Container)
                  .toList(), // Filter out empty containers
            ),
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
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

  Future<void> _handleGoogleSignOut() async {
    try {
      await _googleSignIn.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (error) {
      _showErrorDialog("Error signing out: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/9990/9990371.png'),
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
                text: 'My Enrollment',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentDetailScreen()),
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
                icon: Icons.subscriptions,
                text: 'Subscription Plan',
                onTap: _fetchSubscriptionDetails,
              ),
              ProfileOption(
                icon: Icons.logout,
                text: 'Logout',
                onTap: _handleGoogleSignOut,
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
