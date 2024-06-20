// screens/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_request.dart';
import '../providers/enrollment_provider.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String subscriptionType;
  final double price;

  const PaymentScreen({super.key,
    required this.subscriptionType,
    required this.price,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'CREDIT_CARD';
  final _cardNumberController = TextEditingController();
  final _expirationController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Subscription Type: ${widget.subscriptionType}'),
              Text('Price: \$${widget.price}'),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: ['CREDIT_CARD', 'PAYPAL'].map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Payment Method'),
              ),
              if (_paymentMethod == 'CREDIT_CARD') ...[
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the card number';
                    }
                    if (!RegExp(r'^[0-9]{16}$').hasMatch(value)) {
                      return 'Please enter a valid 16-digit card number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _expirationController,
                  decoration: const InputDecoration(labelText: 'Expiration Date (MM/YY)'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the expiration date';
                    }
                    if (!RegExp(r'^[0-1][0-9]/[0-9]{2}$').hasMatch(value)) {
                      return 'Please enter a valid expiration date (MM/YY)';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the CVV';
                    }
                    if (!RegExp(r'^[0-9]{3}$').hasMatch(value)) {
                      return 'Please enter a valid 3-digit CVV';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getInt('userId');
                    final sessionId = prefs.getString('sessionId');

                    if (userId != null && sessionId != null) {
                      final paymentRequest = PaymentRequest(
                        price: widget.price,
                        paymentMethod: _paymentMethod,
                        subscriptionType: widget.subscriptionType,
                        cardNumber: _cardNumberController.text,
                        expiration: _expirationController.text,
                        cvv: _cvvController.text,
                      );

                      final enrollmentProvider = Provider.of<EnrollmentProvider>(context, listen: false);
                      try {
                        await enrollmentProvider.processPayment(paymentRequest, sessionId);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentSuccessScreen(),
                          ),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to process payment: $error')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User not authenticated')),
                      );
                    }
                  }
                },
                child: const Text('Process Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
