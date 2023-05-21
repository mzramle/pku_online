class MedicalPrescriptionModel {
  String id;
  String medicineName;
  String dosage;
  String instructions;

  MedicalPrescriptionModel(
      {required this.id,
      required this.medicineName,
      required this.dosage,
      required this.instructions});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineName': medicineName,
      'dosage': dosage,
      'instructions': instructions,
    };
  }

  factory MedicalPrescriptionModel.fromMap(Map<String, dynamic> map) {
    return MedicalPrescriptionModel(
      id: map['id'],
      medicineName: map['medicineName'],
      dosage: map['dosage'],
      instructions: map['instructions'],
    );
  }
}
