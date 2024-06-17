import 'package:flutter/material.dart';

class AddNewCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Card'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCardPreview(),
            SizedBox(height: 16),
            _buildCardDetailForm(),
            Spacer(),
            _buildAddNewCardButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Card(
      color: Colors.purple,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '**** **** **** 1234',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              'Valid 01/22',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              'Abuzer Firdousi',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetailForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Card Holder Name'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Card Number'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Expiry Date'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'CVV'),
        ),
      ],
    );
  }

  Widget _buildAddNewCardButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Add New Card'),
      ),
    );
  }
}