import 'package:course_template/utils/PublicBaseURL.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/constants.dart';
import '../models/payment_request.dart';

class EnrollmentProvider with ChangeNotifier {
  Future<String> processPayment(PaymentRequest paymentRequest, String sessionId) async {
    try {
      // Gửi yêu cầu thanh toán tới backend và truyền sessionId trong tiêu đề
      final response = await http.post(
        Uri.parse('$baseUrl/api/enrollments/process-payment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': 'JSESSIONID=$sessionId',
        },
        body: jsonEncode(paymentRequest.toJson()),
      );

      if (response.statusCode == 200) {
        return "Payment successful";
      } else {
        throw Exception('Failed to process payment');
      }
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }
}
