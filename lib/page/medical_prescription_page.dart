import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pku_online/core/colors.dart';

class MedicinePage extends StatefulWidget {
  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final CollectionReference _medicalPrescriptionsRef =
      FirebaseFirestore.instance.collection('medical_prescriptions');

  @override
  void initState() {
    super.initState();
  }

  void _deleteMedicalPrescription(String id) async {
    await _medicalPrescriptionsRef.doc(id).delete();
  }

  void _addNewMedicalPrescription() {
    showDialog(
      context: context,
      builder: (context) {
        String id = '';
        String medicineName = '';
        String dosage = '';
        String instructions = '';

        return AlertDialog(
          title: Text('Add Medical Prescription'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ID'),
                onChanged: (value) => id = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Medicine Name'),
                onChanged: (value) => medicineName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dosage'),
                onChanged: (value) => dosage = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Instructions'),
                onChanged: (value) => instructions = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                await _addMedicalPrescription(
                  id: id,
                  medicineName: medicineName,
                  dosage: dosage,
                  instructions: instructions,
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addMedicalPrescription({
    required String id,
    required String medicineName,
    required String dosage,
    required String instructions,
  }) async {
    await _medicalPrescriptionsRef.doc(id).set({
      'id': id,
      'medicineName': medicineName,
      'dosage': dosage,
      'instructions': instructions,
    });
  }

  void _showMedicalPrescriptionDetails(
      String medicineName, String dosage, String instructions) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Medical Prescription Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Medicine Name: $medicineName'),
              SizedBox(height: 8),
              Text('Dosage: $dosage'),
              SizedBox(height: 8),
              Text('Instructions: $instructions'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text('Medicine Reminder'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _medicalPrescriptionsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot document = documents[index];
              String id = document['id'] as String;
              String medicineName = document['medicineName'] as String;
              String dosage = document['dosage'] as String;
              String instructions = document['instructions'] as String;

              return ListTile(
                title: Text(medicineName),
                subtitle: Text(dosage),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteMedicalPrescription(id),
                ),
                onTap: () => _showMedicalPrescriptionDetails(
                  medicineName,
                  dosage,
                  instructions,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueButton,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: _addNewMedicalPrescription,
      ),
    );
  }
}
