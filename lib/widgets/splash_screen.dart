import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkLoginStatus(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? usernameOrEmail = prefs.getString('usernameOrEmail');
    String? password = prefs.getString('password');

    if (isLoggedIn && usernameOrEmail != null && password != null) {
      // Perform login
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'eu': usernameOrEmail,
          'password': password,
        }),
      );

      if (response.headers['content-type'] != null &&
          response.headers['content-type']!.contains('application/json')) {
        if (response.statusCode == 200) {
          final currentUser = jsonDecode(response.body);
          await prefs.setInt('userId', currentUser['id']);
          await prefs.setString(
              "userFullname", currentUser['fullName'].toString());
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        _showAlertDialog(context, 'Account may not exist');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}
