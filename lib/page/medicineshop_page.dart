import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pku_online/controller/medicine_controller.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/models/medical_prescription_model.dart';
import 'package:pku_online/page/add_medicine_page.dart';
import 'package:pku_online/page/cart_page.dart';
import 'package:pku_online/widget/medicine_card.dart';
import 'medicine_details_page.dart';

class MedicineShopPage extends StatefulWidget {
  @override
  _MedicineShopPageState createState() => _MedicineShopPageState();
}

class _MedicineShopPageState extends State<MedicineShopPage> {
  List<MedicalPrescriptionModel> medicines = [];
  final MedicineController _medicineController = MedicineController();
  List<MedicalPrescriptionModel> cartItems = [];
  String currentUserRole = '';
  Map<String, int> cartQuantities = {}; // Store medicine ID and quantity

  @override
  void initState() {
    super.initState();
    fetchMedicines();
    fetchCurrentUserRole();
  }

  // Fetch the current user's role
  Future<void> fetchCurrentUserRole() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final currentUserUID = currentUser.uid;
      final roleSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUserUID)
          .get();
      setState(() {
        currentUserRole = roleSnapshot['role'];
      });
    }
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
        final updatedMedicines = await _medicineController.fetchMedicines();
        setState(() {
          medicines = updatedMedicines;
        });
      }
    });
  }

  void addToCart(MedicalPrescriptionModel medicine) {
    setState(() {
      cartItems.add(medicine);

      // Increase quantity for the specific medicine in the cart
      if (cartQuantities.containsKey(medicine.id)) {
        cartQuantities[medicine.id] = cartQuantities[medicine.id]! + 1;
      } else {
        cartQuantities[medicine.id] = 1;
      }
    });
  }

  void removeFromCart(MedicalPrescriptionModel medicine) {
    setState(() {
      cartItems.remove(medicine);

      // Decrease quantity for the specific medicine in the cart
      if (cartQuantities.containsKey(medicine.id)) {
        cartQuantities[medicine.id] =
            (cartQuantities[medicine.id]! - 1).clamp(0, 9999);
        if (cartQuantities[medicine.id] == 0) {
          cartQuantities.remove(medicine.id);
        }
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
                      childAspectRatio: 0.8,
                    ),
                    itemCount: medicines.length,
                    itemBuilder: (context, index) {
                      MedicalPrescriptionModel medicine = medicines[index];
                      bool isInCart = cartItems.contains(medicine);
                      int medQuantity = cartQuantities[medicine.id] ??
                          0; // Get the quantity from cartQuantities

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
                                  currentUserRole: currentUserRole,
                                ),
                              ),
                            );
                          },
                          onAddToCart: () {
                            addToCart(medicine);
                          },
                          onRemoveFromCart: () {
                            if (isInCart) {
                              removeFromCart(medicine);
                            }
                          },

                          // Pass the quantity for the specific medicine to the MedicineCard widget
                          medCardQuantity:
                              medQuantity, // Pass the quantity to MedicineCard
                          currentUserRole: currentUserRole,
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
      floatingActionButton: currentUserRole == 'admin'
          ? FloatingActionButton(
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
            )
          : currentUserRole == 'user'
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      cartItems.clear();
                      cartQuantities.clear();
                    });
                  },
                  child: Icon(Icons.clear_all_rounded),
                  backgroundColor: Colors.red,
                )
              : null,
      bottomNavigationBar: currentUserRole == 'user'
          ? BottomAppBar(
              child: Container(
                height: 56.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CartPage(cartItems: cartItems),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueButton,
                      ),
                      child: Text('View Cart'),
                    ),
                    Text(
                      '${cartItems.length} Item(s)',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
