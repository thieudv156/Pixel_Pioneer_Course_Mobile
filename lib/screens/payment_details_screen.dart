import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/PublicBaseURL.dart';
import '../utils/date_utils.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({super.key});

  @override
  _PaymentDetailScreenState createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  List<dynamic> _enrollments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEnrollments();
  }

  Future<void> _fetchEnrollments() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      final response = await http.get(Uri.parse(
          '$baseUrl/api/enrollments/get-user-enrollments?userId=$userId'));
      if (response.statusCode == 200) {
        setState(() {
          _enrollments = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch enrollments')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
      appBar: AppBar(
        title: const Text('Enrollment Detail'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _enrollments.isEmpty
              ? const Center(child: Text('No data'))
              : ListView.builder(
                  itemCount: _enrollments.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> enrollment = _enrollments[index];
                    String? paymentDate = formatDate(enrollment['paymentDate']);
                    String? paymentMethod = enrollment['paymentMethod'];
                    String? subscriptionType = enrollment['subscriptionType'];
                    String? subscriptionEndDate =
                        formatDate(enrollment['subscriptionEndDate']);
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const Icon(Icons.payment),
                        title:
                            Text('Payment Date: ${paymentDate ?? 'Unknown'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Payment Method: ${paymentMethod ?? 'Unknown'}'),
                            Text(
                                'Subscription Type: ${subscriptionType ?? 'Unknown'}'),
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
