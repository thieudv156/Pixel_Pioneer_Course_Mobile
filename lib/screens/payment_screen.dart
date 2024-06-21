// payment_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:course_template/utils/PublicBaseURL.dart';

class PaymentScreen extends StatelessWidget {
  final double amount;
  final String subscriptionType;

  PaymentScreen({required this.amount, required this.subscriptionType});

  Future<void> _processCreditCardPayment(BuildContext context, String cardNumber, String expiration, String cvv) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/enrollments/credit-card-payment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': userId,
          'cardNumber': cardNumber,
          'expiration': expiration,
          'cvv': cvv,
          'price': amount,
          'subscriptionType': subscriptionType,
          'paymentMethod': 'CREDIT_CARD',
        }),
      );

      if (response.statusCode == 200) {
        // Payment successful
        Navigator.pushNamed(context, '/payment_success');
      } else {
        // Payment failed
        _showErrorDialog(context, "Payment failed: ${response.body}");
      }
    } else {
      // User not authenticated
      _showErrorDialog(context, "User not authenticated");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
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
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Expiration Date (MM/YY)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'CVV',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call _processCreditCardPayment with card details
                _processCreditCardPayment(context, '4111111111111111', '12/23', '123');
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}