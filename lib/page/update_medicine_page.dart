import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pku_online/controller/medicine_controller.dart';
import 'package:pku_online/models/medical_prescription_model.dart';

class UpdateMedicinePage extends StatefulWidget {
  final MedicalPrescriptionModel medicine;

  UpdateMedicinePage({required this.medicine});

  @override
  _UpdateMedicinePageState createState() => _UpdateMedicinePageState();
}

class _UpdateMedicinePageState extends State<UpdateMedicinePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dosagesController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final MedicineController _medicineController = MedicineController();

  File? _selectedImage;
  MedicalPrescriptionModel? _medicine;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.medicine.medicineName;
    _categoryController.text = widget.medicine.category;
    _priceController.text = widget.medicine.price.toString();
    _dosagesController.text = widget.medicine.dosages;
    _instructionsController.text = widget.medicine.instructions;
    _descriptionController.text = widget.medicine.description;
  }

  void updateMedicine() async {
    MedicalPrescriptionModel updatedMedicine = MedicalPrescriptionModel(
      id: widget.medicine.id,
      medicineName: _nameController.text,
      category: _categoryController.text,
      price: double.parse(_priceController.text),
      dosages: _dosagesController.text,
      instructions: _instructionsController.text,
      description: _descriptionController.text,
      imageUrl: widget.medicine.imageUrl,
    );

    await _medicineController.updateMedicine(updatedMedicine);

    Navigator.pop(context);
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
        title: Text('Update Medicine'),
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
                    : _medicine != null && _medicine!.imageUrl.isNotEmpty
                        ? Image.network(_medicine!.imageUrl)
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
              onPressed: updateMedicine,
              child: Text('Update Medicine'),
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
