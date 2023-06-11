class MedicalPrescriptionModel {
  final String id;
  final String medicineName;
  final String category;
  final double price;
  final String dosages;
  final String instructions;
  final String description;
  final String imageUrl;

  MedicalPrescriptionModel({
    required this.id,
    required this.medicineName,
    required this.category,
    required this.price,
    required this.dosages,
    required this.instructions,
    required this.description,
    required this.imageUrl,
  });

  MedicalPrescriptionModel copyWith({
    String? id,
    String? medicineName,
    String? category,
    double? price,
    String? dosages,
    String? instructions,
    String? description,
    String? imageUrl,
  }) {
    return MedicalPrescriptionModel(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      category: category ?? this.category,
      price: price ?? this.price,
      dosages: dosages ?? this.dosages,
      instructions: instructions ?? this.instructions,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineName': medicineName,
      'category': category,
      'price': price,
      'dosage': dosages,
      'instructions': instructions,
      'description': description,
      'imageUrl': imageUrl, // Include the imageUrl in the map
    };
  }

  factory MedicalPrescriptionModel.fromMap(Map<String, dynamic> map) {
    return MedicalPrescriptionModel(
      id: map['id'],
      medicineName: map['medicineName'],
      category: map['category'],
      price: map['price'],
      dosages: map['dosage'],
      instructions: map['instructions'],
      description: map['description'],
      imageUrl: map['imageUrl'], // Assign the imageUrl property
    );
  }
}
