import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/tabs/ScheduleTab.dart';

class PaymentPage extends StatefulWidget {
  final Booking booking;
  final double price;

  PaymentPage({required this.booking, required this.price});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _cardHolderNameController = TextEditingController();
  String doctorName = "";
  String specialty = "";
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderNameController.dispose();
    super.dispose();
  }

  void _fetchDoctorDetails() {
    FirebaseFirestore.instance
        .collection('Booking')
        .doc(widget.booking.id)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null) {
          var doctorData = data['doctor'];
          setState(() {
            doctorName = doctorData['doctorName'];
            specialty = doctorData['specialty'];
            imageUrl = doctorData['imageUrl'];
          });
        }
      }
    }).catchError((error) {
      // Handle error fetching doctor details
      print('Error fetching doctor details: $error');
    });
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // Payment processing logic here

      // Save payment data to Firebase collection
      FirebaseFirestore.instance.collection('Payments').add({
        'cardNumber': _cardNumberController.text,
        'expiryDate': _expiryDateController.text,
        'cvv': _cvvController.text,
        'cardHolderName': _cardHolderNameController.text,
        'booking': widget.booking.id,
        'price': widget.price,
        'timestamp': DateTime.now(),
      }).then((value) {
        // Payment successful
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Payment Successful'),
            content: Text('Your payment has been processed successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Navigate to the success page or perform any necessary actions
                },
              ),
            ],
          ),
        );
      }).catchError((error) {
        // Payment failed
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Payment Failed'),
            content: Text(
                'An error occurred while processing your payment. Please try again.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: blueButton,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Summary',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    // ignore: unnecessary_null_comparison
                    if (doctorName != null)
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                        title: Text(doctorName),
                        subtitle: Text(specialty),
                      ),
                    Divider(), // Divider line
                  ],
                ),
              ),
              // Payment Fields Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _cardNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                            CardNumberInputFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: blueButton),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the card number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _expiryDateController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  ExpiryDateInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Expiry Date',
                                  hintText: 'MM/YY',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: blueButton),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the expiry date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: TextFormField(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'CVV',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: blueButton),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the CVV';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _cardHolderNameController,
                          decoration: InputDecoration(
                            labelText: 'Cardholder Name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: blueButton),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the cardholder name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              // Payment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  child: Text('Pay \RM${widget.price.toStringAsFixed(2)}'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: blueButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom input formatter for card number input
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int maxLength = 16;
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');
    int selectionIndex = newValue.selection.end;

    if (text.length > maxLength) {
      text = text.substring(0, maxLength);
    }

    final formattedText = <String>[];
    for (int i = 0; i < text.length; i += 4) {
      final endIndex = i + 4;
      if (text.length < endIndex) {
        formattedText.add(text.substring(i));
      } else {
        formattedText.add(text.substring(i, endIndex));
      }
    }

    selectionIndex += formattedText.length - oldValue.text.length;

    final value = formattedText.join(' ');

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

// Custom input formatter for expiry date input
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int maxLength = 4;
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');
    int selectionIndex = newValue.selection.end;

    if (text.length > maxLength) {
      text = text.substring(0, maxLength);
    }

    final formattedText = <String>[];
    for (int i = 0; i < text.length; i += 2) {
      final endIndex = i + 2;
      if (text.length < endIndex) {
        formattedText.add(text.substring(i));
      } else {
        formattedText.add(text.substring(i, endIndex));
      }
    }

    selectionIndex += formattedText.length - oldValue.text.length;

    final value = formattedText.join('/');

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
