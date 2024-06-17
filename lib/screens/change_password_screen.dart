import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _isEmailStep = true;
  bool _isCodeStep = false;
  bool _isPasswordStep = false;

  Future<void> _sendVerificationEmail() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/reset-password/mail'),
      body: {'email': _emailController.text},
    );

    if (response.statusCode == 200) {
      setState(() {
        _isEmailStep = false;
        _isCodeStep = true;
        _emailController.clear();
      });
    } else {
      _showAlertDialog('Error', response.body);
    }
  }

  Future<void> _verifyCode() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/reset-password/code'),
      body: {'code': _codeController.text},
    );

    if (response.statusCode == 200) {
      setState(() {
        _isCodeStep = false;
        _isPasswordStep = true;
        _codeController.clear();
      });
    } else {
      _showAlertDialog('Error', response.body);
    }
  }

  Future<void> _updatePassword() async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8080/api/reset-password/password'),
      body: {
        'newPassword': _newPasswordController.text,
        'renewPassword': _confirmNewPasswordController.text,
      },
    );

    if (response.statusCode == 200) {
      _showAlertDialog('Success', 'Password has been reset successfully.');
      Navigator.pushReplacementNamed(context, '/');
    } else {
      _showAlertDialog('Error', response.body);
    }
  }

  void _cancelRequest() {
    setState(() {
      _isEmailStep = true;
      _isCodeStep = false;
      _isPasswordStep = false;
      _emailController.clear();
      _codeController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
    });
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
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
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isEmailStep) ...[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendVerificationEmail,
                child: Text('Send Verification Code'),
              ),
            ],
            if (_isCodeStep) ...[
              TextField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Verification Code'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _verifyCode,
                child: Text('Verify Code'),
              ),
              TextButton(
                onPressed: _cancelRequest,
                child: Text('Cancel'),
              ),
            ],
            if (_isPasswordStep) ...[
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updatePassword,
                child: Text('Update Password'),
              ),
              TextButton(
                onPressed: _cancelRequest,
                child: Text('Cancel'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
