import 'package:course_template/models/payment_method.dart';
import 'package:course_template/models/SubscriptionType.dart';
import 'package:course_template/models/userinformation.dart';

class Enrollment {
  final int id;
  final UserInformation user;
  final DateTime enrolledAt;
  final DateTime paymentDate;
  final PaymentMethod paymentMethod;
  final bool paymentStatus;
  final bool subscriptionStatus;
  final SubscriptionType subscriptionType;
  final DateTime subscriptionEndDate;

  Enrollment({
    required this.id,
    required this.user,
    required this.enrolledAt,
    required this.paymentDate,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subscriptionStatus,
    required this.subscriptionType,
    required this.subscriptionEndDate,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'] ?? 0,
      user: UserInformation.fromJson(json['user']),
      enrolledAt:
          DateTime.parse(json['enrolledAt'] ?? DateTime.now().toString()),
      paymentDate:
          DateTime.parse(json['paymentDate'] ?? DateTime.now().toString()),
      paymentMethod:
          PaymentMethodExtension.fromString(json['paymentMethod'] ?? 'PAYPAL'),
      paymentStatus: json['paymentStatus'] ?? false,
      subscriptionStatus: json['subscriptionStatus'] ?? false,
      subscriptionType: SubscriptionTypeExtension.fromString(
          json['subscriptionType'] ?? 'MONTHLY'),
      subscriptionEndDate: DateTime.parse(
          json['subscriptionEndDate'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'enrolledAt': enrolledAt.toIso8601String(),
      'paymentDate': paymentDate.toIso8601String(),
      'paymentMethod': paymentMethod.toString().split('.').last,
      'paymentStatus': paymentStatus,
      'subscriptionStatus': subscriptionStatus,
      'subscriptionType': subscriptionType.toString().split('.').last,
      'subscriptionEndDate': subscriptionEndDate.toIso8601String(),
    };
  }
}
