import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pku_online/models/medical_prescription_model.dart';
import 'package:uuid/uuid.dart';

class MedicineController {
  final CollectionReference _medicineCollection =
      FirebaseFirestore.instance.collection('medicineListShop');

  Future<void> addMedicine(MedicalPrescriptionModel medicine) async {
    try {
      String id = Uuid().v4(); // Generate a unique ID for the medicine
      medicine =
          medicine.copyWith(id: id); // Assign the generated ID to the medicine
      await _medicineCollection.doc(id).set(
          medicine.toMap()); // Use the generated ID when adding the medicine
    } catch (e) {
      print('Error adding medicine: $e');
    }
  }

  Future<List<MedicalPrescriptionModel>> fetchMedicines() async {
    try {
      QuerySnapshot snapshot = await _medicineCollection.get();
      List<MedicalPrescriptionModel> medicines = snapshot.docs
          .map((doc) => MedicalPrescriptionModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList();
      return medicines;
    } catch (e) {
      print('Error fetching medicines: $e');
      return [];
    }
  }

  Future<void> createCollection(CollectionReference collectionRef) async {
    await collectionRef.doc('tempDoc').set({});
    await collectionRef.doc('tempDoc').delete();
  }

  Future<void> updateMedicine(MedicalPrescriptionModel medicine) async {
    try {
      await _medicineCollection.doc(medicine.id).update(medicine.toMap());
    } catch (e) {
      print('Error updating medicine: $e');
    }
  }

  Future<void> deleteMedicine(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('medicineListShop')
          .doc(id)
          .delete();
    } catch (error) {
      print('Error deleting medicine: $error');
      throw error;
    }
  }

  Future<String> uploadImage(File image) async {
    String imageUrl = '';
    try {
      final String fileName = Uuid().v1();
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('medicineImages/$fileName');
      final UploadTask uploadTask = storageReference.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
    }
    return imageUrl;
  }
}
