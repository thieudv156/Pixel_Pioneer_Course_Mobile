enum PaymentMethod {
  PAYPAL,
  CREDIT_CARD
}

extension PaymentMethodExtension on PaymentMethod {
  static PaymentMethod fromString(String value) {
    return PaymentMethod.values
        .firstWhere((e) => e.toString().split('.').last == value);
  }
}
