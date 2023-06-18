import 'package:flutter/material.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/models/medical_prescription_model.dart';
import 'package:pku_online/page/update_medicine_page.dart';

class MedicineDetailsPage extends StatelessWidget {
  final MedicalPrescriptionModel medicine;
  final String currentUserRole;

  const MedicineDetailsPage({
    required this.medicine,
    required this.currentUserRole,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(fontSize: 18.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text(medicine.medicineName),
        actions: currentUserRole == 'doctor'
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateMedicinePage(medicine: medicine),
                      ),
                    ).then((_) {
                      // Handle the update or refresh logic here
                      // For example, you can fetch the updated medicine details
                      // from the server and update the UI accordingly
                    });
                  },
                  icon: Icon(Icons.edit),
                ),
              ]
            : [],
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
          ],
        ),
      ),
    );
  }
}
