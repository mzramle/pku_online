import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/data/auth_repo.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController fullName;
  late TextEditingController phone;

  @override
  void onInit() {
    super.onInit();
    email = TextEditingController();
    password = TextEditingController();
    fullName = TextEditingController();
    phone = TextEditingController();
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    fullName.dispose();
    phone.dispose();
    super.onClose();
  }

  //Call this Function from Design & it will do the rest
  void registerUser(String email, String password) {
    String? error = AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password) as String?;
    if (error != null) {
      Get.showSnackbar(GetSnackBar(
        message: error.toString(),
      ));
    }
  }
}
