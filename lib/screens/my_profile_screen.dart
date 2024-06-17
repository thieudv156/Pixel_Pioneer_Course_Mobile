import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isEditing = false;
  bool _emailChangePending = false;
  String _originalEmail = '';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _checkEmailChangePending();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId');

    if (_userId != null) {
      try {
        final response = await http
            .get(Uri.parse('http://10.0.2.2:8080/api/profile/$_userId'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            _usernameController.text = data['username'];
            _emailController.text = data['email'];
            _fullNameController.text = data['fullName'];
            _phoneController.text = data['phone'];
            _originalEmail = data['email'];
          });
        } else {
          _showErrorDialog('Failed to load user data');
        }
      } catch (e) {
        _showErrorDialog('An error occurred while fetching user data');
      }
    } else {
      _showErrorDialog('User ID not found');
    }
  }

  Future<void> _checkEmailChangePending() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool emailChangePending = prefs.getBool('emailChangePending') ?? false;
    setState(() {
      _emailChangePending = emailChangePending;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error Message'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Message'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'fullName': _fullNameController.text,
        'phone': _phoneController.text,
      };

      if (_emailController.text != _originalEmail) {
        // Handle email change verification
        try {
          final response = await http.put(
            Uri.parse(
                'http://10.0.2.2:8080/api/profile/changeInformation/$_userId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(updatedData),
          );

          if (response.statusCode == 200) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('emailChangePending', true);
            setState(() {
              _emailChangePending = true;
            });
            _showSuccessDialog(
                'Code has been sent to your new email, please check.');
          } else {
            _showErrorDialog('Failed to send verification code');
          }
        } catch (e) {
          _showErrorDialog('An error occurred while sending verification code');
        }
      } else {
        _updateProfile(updatedData);
      }
    }
  }

  Future<void> _updateProfile(Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:8080/api/profile/changeInformation/$_userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog('Profile updated successfully');
        setState(() {
          _isEditing = false;
        });
      } else {
        _showErrorDialog('Failed to update profile');
      }
    } catch (e) {
      _showErrorDialog('An error occurred while updating profile');
    }
  }

  Future<void> _verifyCode() async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:8080/api/profile/changeInformation/$_userId/${_codeController.text}'),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog('Profile updated successfully');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('emailChangePending', false);
        setState(() {
          _isEditing = false;
          _emailChangePending = false;
          _fetchUserData(); // Reload user data to reflect changes
        });
      } else {
        _showErrorDialog('Invalid code, please try again.');
        _fetchUserData();
      }
    } catch (e) {
      _showErrorDialog('An error occurred while verifying the code');
    }
  }

  void _cancelVerification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emailChangePending', false);
    setState(() {
      _emailChangePending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _startEditing,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _emailChangePending
            ? Column(
                children: [
                  TextField(
                    controller: _codeController,
                    decoration: InputDecoration(labelText: 'Verification Code'),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _verifyCode,
                        child: Text('Verify Code'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _cancelVerification,
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        if (value.length < 4 || value.length > 50) {
                          return 'Username must be between 4 and 50 characters';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        final emailRegex =
                            RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Email should be valid';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                    ),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(labelText: 'Full Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        if (value.length > 100) {
                          return 'Full name must be less than 100 characters';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        final phoneRegex =
                            RegExp(r'^\+?[0-9]{0,3}[0-9. ()-]{7,25}$');
                        if (!phoneRegex.hasMatch(value)) {
                          return 'Phone number is invalid';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                    ),
                    if (_isEditing)
                      ElevatedButton(
                        onPressed: _submitProfile,
                        child: Text('Save changes'),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
