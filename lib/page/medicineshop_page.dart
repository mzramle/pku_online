import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pku_online/controller/medicine_controller.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/models/medical_prescription_model.dart';
import 'package:pku_online/page/add_medicine_page.dart';
import 'package:pku_online/widget/medicine_card.dart';
import 'medicine_details_page.dart';

class MedicineShopPage extends StatefulWidget {
  @override
  _MedicineShopPageState createState() => _MedicineShopPageState();
}

class _MedicineShopPageState extends State<MedicineShopPage> {
  List<MedicalPrescriptionModel> medicines = [];
  final MedicineController _medicineController = MedicineController();

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  void fetchMedicines() async {
    List<MedicalPrescriptionModel> fetchedMedicines =
        await _medicineController.fetchMedicines();
    setState(() {
      medicines = fetchedMedicines;
    });
  }

  void deleteMedicine(MedicalPrescriptionModel medicine) async {
    final removedIndex = medicines.indexOf(medicine);
    MedicalPrescriptionModel? deletedMedicine;

    setState(() {
      medicines.removeAt(removedIndex);
    });

    final completer = Completer<bool>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medicine deleted'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              medicines.insert(removedIndex, medicine);
            });
            deletedMedicine = null;
            completer.complete(false);
          },
        ),
      ),
    );

    try {
      await _medicineController.deleteMedicine(medicine.id);
      deletedMedicine = medicine;
      // Remove the deleted medicine from the local list immediately
      setState(() {
        medicines.remove(deletedMedicine);
      });
    } catch (error) {
      print('Error deleting medicine: $error');
    }

    completer.future.then((dismissed) async {
      if (dismissed) {
        if (deletedMedicine != null) {
          await _medicineController.deleteMedicine(deletedMedicine!.id);
        }
        // Fetch the updated list of medicines after deletion
        final updatedMedicines = await _medicineController.fetchMedicines();
        setState(() {
          medicines = updatedMedicines;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text('Medicine Shop'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width >= 600 ? 4 : 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio:
                          1, // Make the card longer (adjust the value as needed)
                    ),
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      MedicalPrescriptionModel medicine = medicines[index];
                      return Dismissible(
                        key: Key(medicine.id),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: blueButton,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: AlignmentDirectional.centerStart,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          deleteMedicine(medicine);
                        },
                        child: MedicineCard(
                          medicine: medicine,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicineDetailsPage(
                                  medicine: medicine,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicinePage(),
            ),
          ).then((_) {
            fetchMedicines();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: blueButton,
      ),
    );
  }
}
