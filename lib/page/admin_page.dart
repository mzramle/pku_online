import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/page/account_settings_page.dart';
import 'package:pku_online/page/login_page.dart';
import 'package:pku_online/page/managedoctors_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isEditing = false;
  TextEditingController _displayNameController = TextEditingController();
  String displayName = 'Guest';
  File? _imageFile;
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data from Firestore
  }

  void fetchUserData() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('User')
        .doc(currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          displayName = userData['name'] ?? 'Guest';
          _displayNameController.text = displayName;
          avatarUrl = userData['avatar'];
        });
      }
    }).catchError((error) {
      print("Error fetching user data: $error");
    });
  }

  void saveChanges() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('User')
        .doc(currentUser!.uid)
        .update({'name': _displayNameController.text}).then((value) {
      setState(() {
        displayName = _displayNameController.text;
        isEditing = false;
      });
    }).catchError((error) {
      print("Error updating user data: $error");
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });

      // Upload the image file to Firebase Storage
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('avatars')
          .child('${currentUser!.uid}.jpg');

      await storageRef.putFile(_imageFile!);
      final imageUrl = await storageRef.getDownloadURL();

      // Update the image URL in Firestore
      FirebaseFirestore.instance
          .collection('User')
          .doc(currentUser.uid)
          .update({'avatar': imageUrl});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueButton,
      appBar: AppBar(
        backgroundColor: blueButton,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(0),
            alignment: Alignment.center,
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Go back to previous page
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : avatarUrl != null
                          ? NetworkImage(avatarUrl!)
                          : AssetImage('assets/person.jpg')
                              as ImageProvider<Object>?,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isEditing
                      ? Expanded(
                          child: TextFormField(
                            controller: _displayNameController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              displayName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                  SizedBox(width: 10),
                  isEditing
                      ? ElevatedButton(
                          onPressed: saveChanges,
                          child: Text('Save'),
                        )
                      : IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              isEditing = true;
                            });
                          },
                        ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Faculty of Computing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.settings, color: Colors.black),
                  title: Text(
                    'Account Settings',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountSettingsPage(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.medical_services, color: Colors.black),
                  title: Text(
                    'Manage Doctors',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageDoctorsScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Spacer(),
              GestureDetector(
                onTap: () {
                  // Add log out logic here
                },
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        // Successful logout
                        print("User logged out");
                        // Add navigation to the desired screen after logout, e.g., the login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }).catchError((error) {
                        // Error occurred during logout
                        print("Error logging out: $error");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    icon: Icon(Icons.logout_outlined, color: Colors.black),
                    label: Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
