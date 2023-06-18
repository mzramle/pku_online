import 'package:flutter/material.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/models/medical_prescription_model.dart';

class CartPage extends StatelessWidget {
  final List<MedicalPrescriptionModel> cartItems;

  CartPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    // Create a map to store the medicines and their quantities
    Map<MedicalPrescriptionModel, int> medicineQuantities = {};

    // Calculate the quantities for each medicine
    for (var item in cartItems) {
      if (medicineQuantities.containsKey(item)) {
        medicineQuantities[item] = medicineQuantities[item]! + 1;
      } else {
        medicineQuantities[item] = 1;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: medicineQuantities.length,
        itemBuilder: (context, index) {
          MedicalPrescriptionModel medicine =
              medicineQuantities.keys.elementAt(index);
          int medQuantity = medicineQuantities[medicine]!;
          double medicineTotal =
              calculateMedicineTotal(medicine.price, medQuantity);

          return ListTile(
            leading: Image.network(
              medicine.imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            title: Text('${medicine.medicineName}'),
            subtitle: Text(medicine.category),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('\RM${medicine.price.toStringAsFixed(2)} '),
                    Text('x$medQuantity\t'),
                    SizedBox(width: 4.0),
                  ],
                ),
                Text(
                  'Subtotal: \RM${medicineTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: const Color.fromARGB(255, 148, 0, 0),
                  ),
                ),
              ],
            ),
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

  double calculateMedicineTotal(double price, int quantity) {
    return price * quantity;
  }

  double calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price;
    }
    return total;
  }
}


//'Total: \RM${medicineTotal.toStringAsFixed(2)}'