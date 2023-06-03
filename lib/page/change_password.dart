import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pku_online/core/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  Future<void> changePassword() async {
    // Get the current password and new password from the text fields
    final currentPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;

    // Perform password validation and update the password in the database
    if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
      final success = await changeUserPassword(currentPassword, newPassword);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change password')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  Future<bool> changeUserPassword(
      String currentPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Reauthenticate the user with the current password
        final email = user.email;
        if (email != null) {
          final credential = EmailAuthProvider.credential(
            email: email,
            password: currentPassword,
          );
          await user.reauthenticateWithCredential(credential);

          // Update the password
          await user.updatePassword(newPassword);

          // Update the password field in the 'User' collection
          await FirebaseFirestore.instance
              .collection('User')
              .doc(user.uid)
              .update({'password': newPassword});

          return true; // Password changed successfully
        } else {
          return false; // User email is null
        }
      }

      return false; // User is not authenticated
    } catch (error) {
      print('Error changing password: $error');
      return false; // Failed to change password
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                hintText: 'Enter your current password',
              ),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter your new password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: blueButton,
              ),
              onPressed: changePassword,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
