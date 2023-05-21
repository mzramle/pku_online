import '../models/user_model.dart';

class AccountSettingsController {
  UserModel? currentUser;

  Future<void> getCurrentUser() async {
    await Future.delayed(Duration(seconds: 2));
    currentUser = UserModel(
      id: '1',
      fullName: 'Mary Jane',
      email: 'maryjane@example.com',
      phone: '+1234567890',
      password: 'password123',
    );
  }

  Future<void> updateFullName(String newFullName) async {
    await Future.delayed(Duration(seconds: 2));
    currentUser?.fullName = newFullName;
  }

  Future<void> updateEmail(String newEmail) async {
    await Future.delayed(Duration(seconds: 2));
    currentUser?.email = newEmail;
  }

  Future<void> updatePhone(String newPhone) async {
    await Future.delayed(Duration(seconds: 2));
    currentUser?.phone = newPhone;
  }

  Future<void> updatePassword(String newPassword) async {
    await Future.delayed(Duration(seconds: 2));
    currentUser?.password = newPassword;
  }
}
