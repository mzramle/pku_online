import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:pku_online/core/colors.dart';

class ManageDoctorsScreen extends StatefulWidget {
  @override
  _ManageDoctorsScreenState createState() => _ManageDoctorsScreenState();
}

class _ManageDoctorsScreenState extends State<ManageDoctorsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  File? _imageFile;
  TextEditingController _doctorNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _specialtyController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _doctorNameController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    _aboutController.dispose();
    _experienceController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImageToStorage(String doctorId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('doctors').child(doctorId);
      final uploadTask = storageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return null;
    }
  }

  Future<void> _addDoctor() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Create a temporary Firebase app instance
      FirebaseApp tempApp = await Firebase.initializeApp(
          name: "flutter", options: Firebase.app().options);

      // Create the doctor's account in Firebase Auth using the temporary app instance
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final newUser = await FirebaseAuth.instanceFor(app: tempApp)
          .createUserWithEmailAndPassword(email: email, password: password);

      final doctorId = newUser.user!.uid;

      // Upload the doctor's image to Firebase Storage
      final imageUrl = await _uploadImageToStorage(doctorId);

      // Save the doctor's data to Firestore
      await FirebaseFirestore.instance.collection('Doctors').doc(doctorId).set({
        'doctorName': _doctorNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'specialty': _specialtyController.text.trim(),
        'about': _aboutController.text.trim(),
        'experience': _experienceController.text.trim(),
        'email': email,
        'password': password,
        'imageUrl': imageUrl,
        'review': 0,
        'patient': 0,
      });

      // Clear the text fields
      setState(() {
        _imageFile = null;
      });
      _doctorNameController.clear();
      _phoneController.clear();
      _specialtyController.clear();
      _aboutController.clear();
      _experienceController.clear();
      _emailController.clear();
      _passwordController.clear();

      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Doctor added successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _deleteDoctor(String doctorId) async {
    try {
      final doctorRef =
          FirebaseFirestore.instance.collection('Doctors').doc(doctorId);
      final doctorSnapshot = await doctorRef.get();
      final doctorData = doctorSnapshot.data() as Map<String, dynamic>;

      // Move doctor attributes to user document
      await FirebaseFirestore.instance.collection('User').doc(doctorId).set({
        'avatar': doctorData['imageUrl'],
        'name': doctorData['doctorName'],
        'email': doctorData['email'],
        'password': doctorData['password'],
        'phone': doctorData['phone'],
        'role': 'user',
      });

      // Delete the doctor document
      await doctorRef.delete();
      return true;
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text('Manage Doctors'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Add Doctor'),
            Tab(text: 'View Doctor'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Choose an option'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _pickImage(ImageSource.gallery);
                                },
                                child: Text('Gallery'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _pickImage(ImageSource.camera);
                                },
                                child: Text('Camera'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: blueButton, // Set background color
                        child: _imageFile != null
                            ? ClipOval(
                                child: Image.file(
                                  _imageFile!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.camera_alt,
                                size: 30.0,
                                color: Colors.white, // Set icon color to white
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _doctorNameController,
                    decoration: InputDecoration(
                      labelText: 'Doctor Name',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _specialtyController,
                    decoration: InputDecoration(
                      labelText: 'Specialty',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _aboutController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'About',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _experienceController,
                    decoration: InputDecoration(
                      labelText: 'Experience',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _addDoctor,
                      child: Text('Add Doctor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueButton,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Doctors').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final doctors = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: doctors.length,
                  itemBuilder: (BuildContext context, int index) {
                    final doctor =
                        doctors[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doctor['imageUrl']),
                      ),
                      title: Text(doctor['doctorName']),
                      subtitle: Text(doctor['specialty']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm'),
                                content: Text(
                                    'Are you sure you want to delete this doctor?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      bool success = await _deleteDoctor(
                                          doctors[index].id);
                                      if (success) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Success'),
                                              content: Text(
                                                  'Doctor deleted successfully.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
