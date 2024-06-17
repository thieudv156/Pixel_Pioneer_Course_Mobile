import 'package:flutter/material.dart';

import 'add_new_card_screen.dart';

class SelectCreditDebitCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit / Debit Card'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCardList(),
          SizedBox(height: 16),
          _buildAddNewCardButton(context),
        ],
      ),
    );
  }

  Widget _buildCardList() {
    return Column(
      children: [
        _buildCardItem('Master Card', 'assets/mastercard.png', '**** **** **** 5566'),
        _buildCardItem('Visa', 'assets/visa.png', '**** **** **** 5566'),
        _buildCardItem('American Express', 'assets/amex.png', '**** **** **** 5566'),
        _buildCardItem('Discover', 'assets/discover.png', '**** **** **** 5566'),
      ],
    );
  }

  Widget _buildCardItem(String cardName, String cardImage, String cardNumber) {
    return Card(
      child: ListTile(
        leading: Image.asset(cardImage, width: 50, height: 50),
        title: Text(cardName),
        subtitle: Text(cardNumber),
        trailing: Radio(value: false, groupValue: true, onChanged: (value) {}),
      ),
    );
  }

  Widget _buildAddNewCardButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddNewCardScreen()),
        );
      },
      child: Text('Add New Card'),
    );
  }
}