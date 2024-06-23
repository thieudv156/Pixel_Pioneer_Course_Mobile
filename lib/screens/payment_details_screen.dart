import 'package:course_template/utils/PublicBaseURL.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/date_utils.dart';

class PaymentDetailScreen extends StatefulWidget {
  @override
  _PaymentDetailScreenState createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  List<dynamic> _enrollments = [];

  @override
  void initState() {
    super.initState();
    _fetchEnrollments();
  }

  Future<void> _fetchEnrollments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      final response =
          await http.get(Uri.parse('$baseUrl/api/enrollments/user/$userId'));
      if (response.statusCode == 200) {
        setState(() {
          _enrollments = jsonDecode(response.body);
        });
      } else {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      // Set background color to light purple
      appBar: AppBar(
        title: Text('Payment Detail'),
      ),
      body: ListView.builder(
        itemCount: _enrollments.length,
        itemBuilder: (context, index) {
          String? paymentDate = formatDate(_enrollments[index]['paymentDate']);
          String? paymentMethod = _enrollments[index]['paymentMethod'];
          String? subscriptionType = _enrollments[index]['subscriptionType'];
          String? subscriptionEndDate =
              formatDate(_enrollments[index]['subscriptionEndDate']);
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Date: ${paymentDate ?? 'Unknown'}'),
                  Text('Payment Method: ${paymentMethod ?? 'Unknown'}'),
                  Text('Subscription Type: ${subscriptionType ?? 'Unknown'}'),
                  Text(
                      'Subscription End Date: ${subscriptionEndDate ?? 'Unknown'}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
