import 'package:flutter/material.dart';
import 'package:pku_online/models/medical_prescription_model.dart';

class MedicineCard extends StatelessWidget {
  final MedicalPrescriptionModel medicine;
  final Function() onTap;
  final Function() onRemoveFromCart;
  final Function() onAddToCart;
  final int medCardQuantity; // Add medCardQuantity as a parameter

  final String currentUserRole;

  const MedicineCard({
    required this.medicine,
    required this.onTap,
    required this.onRemoveFromCart,
    required this.onAddToCart,
    required this.medCardQuantity,
    required this.currentUserRole,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Card(
          elevation: 0.0,
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      medicine.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 15,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                        SizedBox(height: 8.0),
                        if (currentUserRole ==
                            'user') // Show only for user role
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                child: IconButton(
                                  onPressed: onRemoveFromCart,
                                  icon: Icon(Icons.remove),
                                  color: Colors.black,
                                  padding: EdgeInsets.zero,
                                  iconSize: 16,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                medCardQuantity.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                child: IconButton(
                                  onPressed: onAddToCart,
                                  icon: Icon(Icons.add),
                                  color: Colors.black,
                                  padding: EdgeInsets.zero,
                                  iconSize: 16,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
