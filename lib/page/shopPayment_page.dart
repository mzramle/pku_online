import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pku_online/core/colors.dart';

class PurchaseSummaryPage extends StatefulWidget {
  @override
  _PurchaseSummaryPageState createState() => _PurchaseSummaryPageState();
}

class _PurchaseSummaryPageState extends State<PurchaseSummaryPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  double subtotal = 0.0;
  double total = 0.0;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  void _fetchCartItems() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Cart')
          .doc(currentUserId)
          .collection('Items')
          .get();

      List<String> medicineIds =
          querySnapshot.docs.map((doc) => doc.id).toList();

      print('Medicine IDs: $medicineIds');

      List<Map<String, dynamic>> tempCartItems = [];
      double tempSubtotal = 0.0;

      for (String medicineId in medicineIds) {
        final medicineSnapshot = await FirebaseFirestore.instance
            .collection('Cart')
            .doc(currentUserId)
            .collection('Items')
            .doc(medicineId)
            .get();

        if (medicineSnapshot.exists) {
          var medicineData = medicineSnapshot.data();

          String? imageUrl = medicineData?['imageUrl'] as String?;
          String? medicineName = medicineData?['medicineName'] as String?;
          int? quantity = medicineData?['quantity'] as int?;
          double? price = medicineData?['price'] as double?;

          if (imageUrl != null &&
              medicineName != null &&
              quantity != null &&
              price != null) {
            tempSubtotal += price * quantity;

            tempCartItems.add({
              'imageUrl': imageUrl,
              'medicineName': medicineName,
              'quantity': quantity,
              'price': price,
            });
          }

          print('Medicine ID: $medicineId');
          print('Medicine Information: $medicineData');
        }
      }

      setState(() {
        cartItems = tempCartItems;
        subtotal = tempSubtotal;
        total = tempSubtotal; // Assuming no additional charges for now
      });
    } catch (error) {
      // Handle error fetching cart items
      print('Error fetching cart items: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Summary'),
        backgroundColor: blueButton,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Purchase Summary Section
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Purchase Summary',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 200,
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> item = cartItems[index];
                        double subtotalPerItem =
                            item['price'] * item['quantity'];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(item['imageUrl']),
                          ),
                          title: Text(item['medicineName']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: ${item['quantity']}'),
                              Text(
                                  'Price: RM${item['price'].toStringAsFixed(2)}'),
                              Text(
                                  'Subtotal: RM${subtotalPerItem.toStringAsFixed(2)}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Subtotal and Total Section
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
                Text('Subtotal: RM${subtotal.toStringAsFixed(2)}'),
                Text('Total: RM${total.toStringAsFixed(2)}'),
              ],
            ),
            SizedBox(height: 32.0),
            // Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add payment processing logic here
                },
                child: Text('Pay RM${total.toStringAsFixed(2)}'),
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
    );
  }
}
