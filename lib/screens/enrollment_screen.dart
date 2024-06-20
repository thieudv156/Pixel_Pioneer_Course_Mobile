// screens/enrollment_screen.dart
import 'package:flutter/material.dart';

class EnrollmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Subscription Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SubscriptionOption(
              title: 'Monthly Plan',
              description: 'Subscribe for one month',
              price: 9.0,
              subscriptionType: 'MONTHLY',
              onSelected: () => navigateToPaymentScreen(context, 'MONTHLY', 10.0),
            ),
            SizedBox(height: 20),
            SubscriptionOption(
              title: 'Yearly Plan',
              description: 'Subscribe for one year',
              price: 99.0,
              subscriptionType: 'YEARLY',
              onSelected: () => navigateToPaymentScreen(context, 'YEARLY', 100.0),
            ),
            SizedBox(height: 20),
            SubscriptionOption(
              title: 'Unlimited Plan',
              description: 'Unlimited access',
              price: 999.0,
              subscriptionType: 'UNLIMITED',
              onSelected: () => navigateToPaymentScreen(context, 'UNLIMITED', 200.0),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToPaymentScreen(BuildContext context, String subscriptionType, double price) {
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'subscriptionType': subscriptionType,
        'price': price,
      },
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String subscriptionType;
  final VoidCallback onSelected;

  SubscriptionOption({
    required this.title,
    required this.description,
    required this.price,
    required this.subscriptionType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Text('\$$price'),
        onTap: onSelected,
      ),
    );
  }
}
