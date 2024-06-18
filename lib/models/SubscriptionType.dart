enum SubscriptionType { MONTHLY, YEARLY, UNLIMITED }

extension SubscriptionTypeExtension on SubscriptionType {
  static SubscriptionType fromString(String value) {
    return SubscriptionType.values
        .firstWhere((e) => e.toString().split('.').last == value);
  }
}
