import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:pku_online/core/colors.dart';

class UserCardDetailsPage extends StatefulWidget {
  @override
  _UserCardDetailsPageState createState() => _UserCardDetailsPageState();
}

class _UserCardDetailsPageState extends State<UserCardDetailsPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  bool _isNewPaymentDetails = false;
  bool isCvvFocused = false;

  OutlineInputBorder? border;

  @override
  void initState() {
    super.initState();
    _retrieveCardDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _saveCardDetails() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String cardNumber = _cardNumberController.text;
      String expiryDate = _expiryDateController.text;
      String cvv = _cvvController.text;

      try {
        await _firestore.collection('UserCardDetails').doc(_user!.uid).set({
          'name': name,
          'cardNumber': cardNumber,
          'expiryDate': expiryDate,
          'cvv': cvv,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment details saved successfully')),
        );

        setState(() {
          _isEditing = false;
          _isNewPaymentDetails = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save payment details')),
        );
      }
    }
  }

  void _updateCardDetails() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String cardNumber = _cardNumberController.text;
      String expiryDate = _expiryDateController.text;
      String cvv = _cvvController.text;

      try {
        await _firestore.collection('UserCardDetails').doc(_user!.uid).update({
          'name': name,
          'cardNumber': cardNumber,
          'expiryDate': expiryDate,
          'cvv': cvv,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment details updated successfully')),
        );

        setState(() {
          _isEditing = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update payment details')),
        );
      }
    }
  }

  void _retrieveCardDetails() async {
    if (_user == null) {
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('UserCardDetails')
          .doc(_user?.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        _cardNumberController.text = data['cardNumber'];
        _expiryDateController.text = data['expiryDate'];
        _nameController.text = data['name'];
        _cvvController.text = data['cvv'];

        setState(() {
          _isNewPaymentDetails = false;
        });
      } else {
        setState(() {
          _isNewPaymentDetails = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to retrieve payment details')),
      );
      print(e.toString()); // Print the error message for debugging purposes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text('User Profile'),
        actions: [
          if (!_isNewPaymentDetails)
            IconButton(
              icon: _isEditing ? Icon(Icons.save) : Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
                if (_isEditing) {
                  // Enable editing mode
                } else {
                  // Save changes
                  if (_user != null) {
                    _updateCardDetails();
                  }
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                CreditCardWidget(
                  cardNumber: _cardNumberController.text,
                  expiryDate: _expiryDateController.text,
                  cardHolderName: _nameController.text,
                  cvvCode: _cvvController.text,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  showBackView: isCvvFocused,
                  isHolderNameVisible: true,
                  cardBgColor: Colors.redAccent,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/cardIcon/mastercard-logo.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                    CustomCardTypeIcon(
                      cardType: CardType.visa,
                      cardImage: Image.asset(
                        'assets/cardIcon/visa-logo.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                CreditCardForm(
                  formKey: _formKey,
                  cardNumber: _cardNumberController.text,
                  expiryDate: _expiryDateController.text,
                  cardHolderName: _nameController.text,
                  cvvCode: _cvvController.text,
                  obscureCvv: true,
                  obscureNumber: false,
                  enableCvv: true,
                  themeColor: bgPrimary,
                  textColor: Colors.black,
                  cardNumberDecoration: InputDecoration(
                    labelText: 'Card Number',
                    hintText: 'XXXX XXXX XXXX XXXX',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                  expiryDateDecoration: InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'XX/XX',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                  cvvCodeDecoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: 'XXX',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  cardHolderDecoration: InputDecoration(
                    labelText: 'Card Holder',
                  ),
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: _onValidate,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          bgPrimary,
                          Colors.orangeAccent,
                          blueButton,
                        ],
                        begin: Alignment(-1, -4),
                        end: Alignment(1, 4),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Validate',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'halter',
                        fontSize: 14,
                        package: 'flutter_credit_card',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: blueButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isEditing ? null : _saveCardDetails,
                        child: Text(
                          'Save Payment Details',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onValidate() {
    if (_formKey.currentState!.validate()) {
      print('valid!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment details validated successfully')),
      );
    } else {
      print('invalid!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid payment details')),
      );
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      _cardNumberController.text = creditCardModel!.cardNumber;
      _expiryDateController.text = creditCardModel.expiryDate;
      _nameController.text = creditCardModel.cardHolderName;
      _cvvController.text = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
