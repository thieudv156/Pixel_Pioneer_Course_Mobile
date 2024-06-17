import 'package:course_template/screens/select_credit_card_screen.dart';
import 'package:flutter/material.dart';

class SelectPaymentMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment Method'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildUPISection(),
          SizedBox(height: 16),
          _buildCreditDebitCardSection(context),
          SizedBox(height: 16),
          _buildNetbankingSection(),
          SizedBox(height: 16),
          _buildPaymentButton(),
        ],
      ),
    );
  }

  Widget _buildUPISection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('UPI Apps', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/gpay.png', width: 50, height: 50),
            Image.asset('assets/paytm.png', width: 50, height: 50),
            Image.asset('assets/phonepe.png', width: 50, height: 50),
            Image.asset('assets/amazonpay.png', width: 50, height: 50),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text('Add New UPI'),
        ),
      ],
    );
  }

  Widget _buildCreditDebitCardSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Credit / Debit Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            title: Text('Pay via Card'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectCreditDebitCardScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNetbankingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Netbanking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            title: Text('View All'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {},
          ),
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