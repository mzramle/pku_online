import 'package:cloud_firestore/cloud_firestore.dart';

class AccountSettingsController {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('User');

  Future<Map<String, dynamic>?> fetchUserData(String currentUserId) async {
    final DocumentSnapshot userSnapshot =
        await _userCollection.doc(currentUserId).get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      return userData;
    }

    return null;
  }

  Future<void> updateUserData(
      String currentUserId, Map<String, dynamic> updatedData) async {
    await _userCollection.doc(currentUserId).update(updatedData);
  }
}
