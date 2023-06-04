import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/page/doctor_detail.dart';

class DoctorList extends StatefulWidget {
  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Doctors').get();
    doctors = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    filterDoctors(''); // Initialize filteredDoctors with all doctors
  }

  void filterDoctors([String searchTerm = '']) {
    filteredDoctors = doctors
        .where((doctor) =>
            doctor['doctorName']
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            doctor['specialty']
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .toList();
    setState(() {});
  }

  void viewDoctorDetail(Map<String, dynamic> doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SliverDoctorDetail(doctor: doctor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueButton,
        title: Text('Doctor List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: filterDoctors,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (BuildContext context, int index) {
                final doctor = filteredDoctors[index];
                final doctorName = doctor['doctorName'];
                final doctorTitle = doctor['specialty'];
                final review = doctor['review'];

                return Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: InkWell(
                    onTap: () {
                      viewDoctorDetail(doctor); // Pass the doctor object
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100, // Set the width and height here
                            color: Colors.white,
                            child: Image.network(
                              doctor['imageUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctorName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  doctorTitle,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '$review - $review Reviews',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
