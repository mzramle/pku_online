import 'package:flutter/material.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/controller/account_settings_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pku_online/page/change_password.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      final accountSettingsController = AccountSettingsController();
      final userData =
          await accountSettingsController.fetchUserData(currentUserId);

      if (userData != null) {
        emailController.text = userData['email'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        passwordController.text = userData['password'] ?? '';
      }
    }
  }

  Future<void> updateUserData() async {
    final updatedData = {
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
    };

    final accountSettingsController = AccountSettingsController();
    await accountSettingsController.updateUserData(currentUserId, updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User data updated successfully')),
    );
  }

  void navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text('Account Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter your phone number',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '********', // Placeholder for the obscured password
              ),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: navigateToChangePassword,
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: blueButton,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueButton,
              ),
              onPressed: updateUserData,
              child: Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
