import 'package:course_template/screens/select_payment_method_screen.dart';
import 'package:flutter/material.dart';

class PaymentDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Detail'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCourseDetailCard(),
            SizedBox(height: 16),
            _buildPaymentMethodCard(context),
            SizedBox(height: 16),
            _buildDiscountCodeCard(),
            Spacer(),
            _buildTotalPaymentSection(),
            SizedBox(height: 16),
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseDetailCard() {
    return Card(
      child: ListTile(
        leading: Image.asset('assets/course1.jpg', width: 50, height: 50),
        title: Text('Learn UI - UX for Beginners'),
        subtitle: Text('\$250'),
      ),
    );
  }

  Widget _buildPaymentMethodCard(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Payment Method'),
        subtitle: Text('**** **** **** 5566'),
        trailing: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SelectPaymentMethodScreen()),
            );
          },
          child: Text('Change'),
        ),
      ),
    );
  }

  Widget _buildDiscountCodeCard() {
    return Card(
      child: ListTile(
        title: Text('Discount Code'),
        subtitle: TextField(
          decoration: InputDecoration(
            hintText: 'Enter discount code',
            border: InputBorder.none,
          ),
        ),
        trailing: TextButton(
          onPressed: () {},
          child: Text('Apply Code'),
        ),
      ),
    );
  }

  Widget _buildTotalPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subtotal: \$250'),
        Text('Discount: -\$2.32'),
        Divider(),
        Text(
          'Total Payment: \$200.23',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Payment'),
      ),
    );
  }
}






