import 'package:pku_online/models/medical_prescription_model.dart';

class MedicalPrescriptionController {
  List<MedicalPrescriptionModel> _medicalPrescriptions = [
    MedicalPrescriptionModel(
      id: '1',
      medicineName: 'Panadol',
      dosage: '500mg',
      instructions:
          'Take 2 tablets orally every 4-6 hours as needed. Do not exceed 8 tablets in 24 hours.',
    ),
    MedicalPrescriptionModel(
      id: '2',
      medicineName: 'Antibiotics',
      dosage: '250mg',
      instructions:
          'Take 1 capsule orally twice daily after meals for 7-10 days. Follow the full course of treatment.',
    ),
    MedicalPrescriptionModel(
      id: '3',
      medicineName: 'Ibuprofen',
      dosage: '200mg',
      instructions:
          'Take 1-2 tablets orally every 6-8 hours as needed for pain or fever. Do not exceed 6 tablets in 24 hours. Take with food or milk to reduce stomach upset.',
    ),
  ];

  List<MedicalPrescriptionModel> getMedicalPrescriptions() {
    // Logic to fetch prescriptions from a data source
    // Return a list of Prescription objects
    return _medicalPrescriptions;
  }

  void addNewMedicalPrescription(MedicalPrescriptionModel medicalPrescription) {
    // Logic to add a new medicalPrescriptionModel
    _medicalPrescriptions.add(medicalPrescription);
  }

  void deleteMedicalPrescription(String id) {
    // Logic to delete a prescription from a data source using the given ID
    _medicalPrescriptions
        .removeWhere((medicalPrescription) => medicalPrescription.id == id);
  }

  void deletePrescriptionByMedicineName(String medicineName) {
    // Logic to delete a prescription from a data source using the given ID
    _medicalPrescriptions.removeWhere((medicalPrescription) =>
        medicalPrescription.medicineName == medicineName);
  }
}
