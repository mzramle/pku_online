import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pku_online/controller/medicine_controller.dart';
import 'package:pku_online/models/medical_prescription_model.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dosagesController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final MedicineController _medicineController = MedicineController();

  File? _selectedImage;

  void addMedicine() async {
    if (_selectedImage != null) {
      String imageUrl = await _medicineController.uploadImage(_selectedImage!);

      String id = Uuid().v4(); // Generate a random ID using the Uuid package

      MedicalPrescriptionModel medicine = MedicalPrescriptionModel(
        id: id,
        medicineName: _nameController.text,
        category: _categoryController.text,
        price: double.parse(_priceController.text),
        dosages: _dosagesController.text,
        instructions: _instructionsController.text,
        description: _descriptionController.text,
        imageUrl: imageUrl,
      );

      await _medicineController.addMedicine(medicine);

      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Image not selected'),
            content: Text('Please select an image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _dosagesController.dispose();
    _instructionsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 137, 18, 9),
        title: Text('Add Medicine'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 1.0,
                  ),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!)
                    : Icon(Icons.camera_alt, size: 50.0),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Medicine Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _dosagesController,
              decoration: InputDecoration(labelText: 'Dosages'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _instructionsController,
              decoration: InputDecoration(labelText: 'Instructions'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: addMedicine,
              child: Text('Add Medicine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 137, 18, 9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
