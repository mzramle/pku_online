import 'package:flutter/material.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/models/medical_prescription_model.dart';

class CartPage extends StatelessWidget {
  final List<MedicalPrescriptionModel> cartItems;

  const CartPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          MedicalPrescriptionModel item = cartItems[index];
          return ListTile(
            leading: Image.network(
              item.imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            title: Text(item.medicineName),
            subtitle: Text(item.category),
            trailing: Text('\RM${item.price.toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \RM${calculateTotal().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  // Implement the logic to proceed with the checkout
                },
                child: Text('Checkout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueButton,
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  double calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price;
    }
    return total;
  }
}
