import 'package:flutter/material.dart';
import 'package:pku_online/controller/medical_prescription_controller.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/models/medical_prescription_model.dart';

class MedicinePage extends StatefulWidget {
  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  MedicalPrescriptionController _medicalPrescriptionController =
      MedicalPrescriptionController();
  List<MedicalPrescriptionModel> _medicalPrescriptionModel = [];

  @override
  void initState() {
    super.initState();
    _loadMedicalPrescription();
  }

  void _loadMedicalPrescription() {
    setState(() {
      _medicalPrescriptionModel =
          _medicalPrescriptionController.getMedicalPrescriptions();
    });
  }

  void _deleteMedicalPrescription(String id) {
    setState(() {
      _medicalPrescriptionController.deleteMedicalPrescription(id);
      _loadMedicalPrescription();
    });
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
              onPressed: () {
                MedicalPrescriptionModel newMedicalPrescription =
                    MedicalPrescriptionModel(
                  id: id,
                  medicineName: medicineName,
                  dosage: dosage,
                  instructions: instructions,
                );
                _addMedicalPrescription(newMedicalPrescription);
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

  void _addMedicalPrescription(MedicalPrescriptionModel medicalPrescription) {
    setState(() {
      _medicalPrescriptionModel.add(medicalPrescription);
    });
  }

  void _showMedicalPrescriptionModelDetails(
      MedicalPrescriptionModel medicalPrescription) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Medical Prescription Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Medicine Name: ${medicalPrescription.medicineName}'),
              SizedBox(height: 8),
              Text('Dosage: ${medicalPrescription.dosage}'),
              SizedBox(height: 8),
              Text('Instructions: ${medicalPrescription.instructions}'),
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
      body: ListView.builder(
        itemCount: _medicalPrescriptionModel.length,
        itemBuilder: (context, index) {
          MedicalPrescriptionModel medicalPrescription =
              _medicalPrescriptionModel[index];
          return ListTile(
            title: Text(medicalPrescription.medicineName),
            subtitle: Text(medicalPrescription.dosage),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () =>
                  _deleteMedicalPrescription(medicalPrescription.id),
            ),
            onTap: () =>
                _showMedicalPrescriptionModelDetails(medicalPrescription),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueButton,
        child: Icon(Icons.add, color: white),
        onPressed: _addNewMedicalPrescription,
      ),
    );
  }
}
