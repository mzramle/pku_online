import 'package:flutter/material.dart';
import 'package:pku_online/models/medical_prescription_model.dart';
import 'package:pku_online/page/update_medicine_page.dart';

class MedicineDetailsPage extends StatelessWidget {
  final MedicalPrescriptionModel medicine;

  const MedicineDetailsPage({required this.medicine});

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(fontSize: 18.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 137, 18, 9),
        title: Text(medicine.medicineName),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        UpdateMedicinePage(medicine: medicine)),
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 200.0, // Set the desired height
                child: Image.network(
                  medicine.imageUrl,
                  fit: BoxFit.cover, // Adjust the image to cover the container
                ),
              ),
            ),
            Text(
              'Category    : ${medicine.category}\n',
              style: textStyle,
            ),
            Text(
              'Price       : RM${medicine.price.toStringAsFixed(2)}\n',
              style: textStyle,
            ),
            Text(
              'Dosages     : ${medicine.dosages}\n',
              style: textStyle,
            ),
            Text(
              'Instructions: ${medicine.instructions}\n',
              style: textStyle,
            ),
            Text(
              'Description : ${medicine.description}\n',
              style: textStyle,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to payment page
              },
              child: Text(
                'Pay',
                style: textStyle,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 137, 18, 9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
