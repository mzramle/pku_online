import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pku_online/controller/cart_controller.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/models/cart_item_model.dart';
import 'package:pku_online/page/medicineshop_page.dart';
import 'package:pku_online/tabs/ScheduleTab.dart';

class PurchaseSummaryPage extends StatefulWidget {
  final Map<String, dynamic> doctor;
  PurchaseSummaryPage(
      {required this.doctor}); // Constructor with doctor parameter
  @override
  _PurchaseSummaryPageState createState() => _PurchaseSummaryPageState();
}

class _PurchaseSummaryPageState extends State<PurchaseSummaryPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  double subtotal = 0.0;
  double total = 0.0;

  late CartController _cartController;

  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _cartController = CartController(cartModel: CartModel());
    _fetchCartItems();
  }

  void _fetchCartItems() async {
    try {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('Cart')
          .doc(currentUserId)
          .get();

      if (cartSnapshot.exists) {
        var cartData = cartSnapshot.data();
        List<dynamic> items = cartData?['items'] ?? [];
        double tempTotal = 0.0;

        // Calculate the subtotal and total based on the cart items
        List<Map<String, dynamic>> tempCartItems = [];

        items.forEach((item) {
          String? medicineName = item['medicineName'];
          int quantity = item['quantity'];
          double price = item['price'];
          double subtotal = CartController(cartModel: CartModel())
              .calculateMedicineTotal(price, quantity);

          tempCartItems.add({
            'medicineName': medicineName,
            'quantity': quantity,
            'price': price,
            'subtotal': subtotal,
          });

          tempTotal += subtotal;
        });

        setState(() {
          cartItems = tempCartItems;
          subtotal = tempTotal;
          total = subtotal; // Assign subtotal to total
        });
      }
    } catch (error) {
      // Handle error fetching cart items
      print('Error fetching cart items: $error');
    }
  }

  void _processPayment() async {
    try {
      // Save invoice to Firestore
      await FirebaseFirestore.instance.collection('Invoice').add({
        'userId': currentUserId,
        'purchaseSummary': cartItems,
        'subtotal': subtotal,
        'total': total,
        'timestamp': DateTime.now(),
      });

      // Clear cart items
      await _clearCartItems();

      // Show success message
      Fluttertoast.showToast(
        msg: 'Payment is successful!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate back to MedicineShopPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicineShopPage(),
        ),
      );
    } catch (error) {
      print('Error processing payment: $error');
      // Show error message
      Fluttertoast.showToast(
        msg: 'Payment processing failed. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _clearCartItems() async {
    try {
      final cartRef = FirebaseFirestore.instance
          .collection('Cart')
          .doc(currentUserId)
          .collection('Items');

      final cartItems = await cartRef.get();

      for (final doc in cartItems.docs) {
        await doc.reference.delete();
      }
    } catch (error) {
      print('Error clearing cart items: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Summary'),
        backgroundColor: blueButton,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _clearCartItems(); // Call the method to clear cart items
            Navigator.pop(context);
          },
        ),
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Cart')
                        .doc(currentUserId)
                        .collection('Items')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error fetching cart items');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      List<Map<String, dynamic>> tempCartItems = [];
                      Map<String, dynamic> cartItemsMap = {};

                      snapshot.data?.docs.forEach((doc) {
                        if (doc.exists) {
                          var medicineData = doc.data();

                          String? medicineName = (medicineData
                                  as Map<String, dynamic>)['medicineName']
                              as String?;
                          int? quantity = (medicineData)['quantity'] as int?;
                          double? price = (medicineData)['price'] as double?;

                          if (medicineName != null &&
                              quantity != null &&
                              price != null) {
                            if (cartItemsMap.containsKey(medicineName)) {
                              // If the item already exists, update the quantity and subtotal
                              cartItemsMap[medicineName]['quantity'] +=
                                  quantity;
                              cartItemsMap[medicineName]['subtotal'] +=
                                  (price * quantity);
                            } else {
                              // If the item does not exist, add it to the map
                              cartItemsMap[medicineName] = {
                                'medicineName': medicineName,
                                'quantity': quantity,
                                'price': price,
                                'subtotal': price * quantity,
                              };
                            }
                          }
                        }
                      });

                      // Convert the map to a list
                      tempCartItems = cartItemsMap.values
                          .toList()
                          .cast<Map<String, dynamic>>();

                      return Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: tempCartItems.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> item = tempCartItems[index];

                            return ListTile(
                              title: Text(item['medicineName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity: ${item['quantity']}'),
                                  Text(
                                      'Price: RM${item['price'].toStringAsFixed(2)}'),
                                  Text(
                                      'Subtotal: RM${item['subtotal'].toStringAsFixed(2)}'),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
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
                Text('Total: RM${total.toStringAsFixed(2)}'),
              ],
            ),
            SizedBox(height: 32.0),
            // Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _processPayment, // Call the _processPayment method
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
