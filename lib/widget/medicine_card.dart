import 'package:flutter/material.dart';
import 'package:pku_online/models/medical_prescription_model.dart';

class MedicineCard extends StatelessWidget {
  final MedicalPrescriptionModel medicine;
  final Function() onTap;

  const MedicineCard({required this.medicine, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 20.0), // Add the desired vertical padding
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150, // Set the desired height for the image
                width: double.infinity, // Make the image occupy the full width
                child: Image.network(
                  medicine.imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
              ListTile(
                title: Text(medicine.medicineName),
                subtitle: Text(medicine.category),
                trailing: Text('\RM${medicine.price.toStringAsFixed(2)}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
