import 'package:pku_online/models/medical_prescription_model.dart';

class MedicalPrescriptionController {
  List<MedicalPrescriptionModel> _medicalPrescriptions = [
    MedicalPrescriptionModel(
      id: '1',
      medicineName: 'Medicine 1',
      dosage: '2 tablets',
      instructions: 'Take with water',
    ),
    MedicalPrescriptionModel(
      id: '2',
      medicineName: 'Medicine 2',
      dosage: '1 capsule',
      instructions: 'Take after meal',
    ),
    MedicalPrescriptionModel(
      id: '3',
      medicineName: 'Medicine 3',
      dosage: '3 times a day',
      instructions: 'Take with food',
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
