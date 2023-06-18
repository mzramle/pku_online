import 'package:flutter/material.dart';
import 'package:pku_online/models/paymentdetail_model.dart';

class PaymentDetailsController {
  PaymentDetailsModel paymentDetails = PaymentDetailsModel(
    name: '',
    cardNumber: 0,
    expiryDate: 0,
    cvv: 0,
  );

  void savePaymentDetails(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController cardNumberController,
    TextEditingController expiryDateController,
    TextEditingController cvvController,
  ) {
    paymentDetails = PaymentDetailsModel(
      name: nameController.text,
      cardNumber: int.parse(cardNumberController.text),
      expiryDate: int.parse(expiryDateController.text),
      cvv: int.parse(cvvController.text),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment details saved')),
    );
  }
}
