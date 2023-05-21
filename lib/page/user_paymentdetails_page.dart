import 'package:flutter/material.dart';
import 'package:pku_online/controller/paymentdetail_controller.dart';

class UserPaymentDetailsPage extends StatefulWidget {
  @override
  _UserPaymentDetailsPageState createState() => _UserPaymentDetailsPageState();
}

class _UserPaymentDetailsPageState extends State<UserPaymentDetailsPage> {
  PaymentDetailsController _paymentDetailsController =
      PaymentDetailsController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _savePaymentDetails() {
    _paymentDetailsController.savePaymentDetails(
      context,
      _nameController,
      _cardNumberController,
      _expiryDateController,
      _cvvController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 137, 18, 9),
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name on Card',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Card Number',
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _expiryDateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePaymentDetails,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
