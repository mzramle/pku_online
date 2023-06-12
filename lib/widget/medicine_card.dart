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
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey
                  .withOpacity(0.5), // Set the desired color for the outline
              width: 0.5, // Set the desired width for the outline
            ),
            borderRadius:
                BorderRadius.circular(4.0), // Set the desired border radius
          ),
          child: Card(
            elevation:
                0.0, // Set elevation to 0 to remove the default shadow of Card
            child: AspectRatio(
              aspectRatio: 1, // Make the card square
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        medicine.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      medicine.medicineName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      medicine.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '\RM${medicine.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
