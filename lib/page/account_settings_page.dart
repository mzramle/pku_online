import 'package:flutter/material.dart';
import '../controller/account_settings_controller.dart';

class AccountSettingsPage extends StatefulWidget {
  final AccountSettingsController accountSettingsController =
      AccountSettingsController();

  @override
  _AccountSettingsPageState createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load the current user when the page is initialized
    widget.accountSettingsController.getCurrentUser().then((_) {
      setState(() {
        fullNameController.text =
            widget.accountSettingsController.currentUser?.fullName ?? '';
        emailController.text =
            widget.accountSettingsController.currentUser?.email ?? '';
        phoneController.text =
            widget.accountSettingsController.currentUser?.phone ?? '';
        passwordController.text =
            widget.accountSettingsController.currentUser?.password ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 137, 18, 9),
        title: Text('Account Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 137, 18, 9)),
              ),
              onPressed: () {
                widget.accountSettingsController
                    .updateFullName(fullNameController.text);
              },
              child:
                  Text('Save Changes', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
