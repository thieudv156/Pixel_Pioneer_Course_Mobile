// screens/enrollment_screen.dart
import 'package:flutter/material.dart';
import 'payment_screen.dart';

class EnrollmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Subscription'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Monthly Subscription'),
            subtitle: Text('\$9 per month'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    subscriptionType: 'MONTHLY',
                    amount: 9.0,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Yearly Subscription'),
            subtitle: Text('\$99 per year'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    subscriptionType: 'YEARLY',
                    amount: 99.0,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Unlimited Subscription'),
            subtitle: Text('\$999 one time'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    subscriptionType: 'UNLIMITED',
                    amount: 999.0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
