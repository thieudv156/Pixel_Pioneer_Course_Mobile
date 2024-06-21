// providers/enrollment_provider.dart
import 'package:course_template/utils/PublicBaseURL.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/payment_request.dart';

class EnrollmentProvider with ChangeNotifier {
  Future<void> processPayment(PaymentRequest paymentRequest, int userId) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/enrollments/process-payment'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'userId': userId,
      'paymentRequest': paymentRequest.toJson(),
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to process payment');
  }
}
}
