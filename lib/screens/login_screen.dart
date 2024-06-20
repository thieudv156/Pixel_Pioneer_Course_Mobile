import 'dart:convert';
import 'package:course_template/utils/PublicBaseURL.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _rememberMe = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    final String usernameOrEmail = _usernameOrEmailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'eu': usernameOrEmail,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Save login state in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      final responseBody = jsonDecode(response.body);
      final setCookieHeader = response.headers['set-cookie'];
      String? sessionId;

      if (setCookieHeader != null) {
        final cookies = setCookieHeader.split(';');
        for (var cookie in cookies) {
          if (cookie.trim().startsWith('JSESSIONID=')) {
            sessionId = cookie.split('=')[1];
            break;
          }
        }
      }

      if (_rememberMe) {
        prefs.setString('usernameOrEmail', usernameOrEmail);
        prefs.setString('password', password);
      } else {
        prefs.remove('usernameOrEmail');
        prefs.remove('password');
      }

      if (sessionId != null) {
        prefs.setString('sessionId', sessionId);
        prefs.setInt('userId', responseBody['id']);
        // If login is successful, navigate to home screen
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        _showAlertDialog(context, 'Failed to retrieve session ID');
      }
    } else {
      // If login fails, show an alert dialog
      _showAlertDialog(context, 'Account may not exist, or you have entered wrong information.');
    }
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Welcome to Pixel Pioneer Course👋'),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameOrEmailController,
              decoration: InputDecoration(
                hintText: 'Email or Username',
                prefixIcon: const Icon(Icons.email_sharp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text('Remember Me'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/change-password");
                  },
                  child: const Text('Not remember password? Reset it here.'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
