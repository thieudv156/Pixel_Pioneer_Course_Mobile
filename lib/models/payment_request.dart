class PaymentRequest {
  final double price;
  final String paymentMethod;
  final String subscriptionType;
  final String cardNumber;
  final String expiration;
  final String cvv;

  PaymentRequest({
    required this.price,
    required this.paymentMethod,
    required this.subscriptionType,
    required this.cardNumber,
    required this.expiration,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'paymentMethod': paymentMethod,
      'subscriptionType': subscriptionType,
      'cardNumber': cardNumber,
      'expiration': expiration,
      'cvv': cvv,
    };
  }
}
