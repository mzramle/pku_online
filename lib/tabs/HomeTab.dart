import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/core/text_style.dart';
import 'package:pku_online/page/admin_page.dart';
import 'package:pku_online/page/bmi_page.dart';
import 'package:pku_online/page/chatlist_page.dart';
import 'package:pku_online/page/doctorList_page.dart';
import 'package:pku_online/page/doctor_detail.dart';
import 'package:pku_online/page/medical_prescription_page.dart';
import 'package:pku_online/page/medicineshop_page.dart';
import 'package:pku_online/page/user_profile.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
final String? currentUserId = user?.uid;

List<Map> doctors = [
  {
    'img': 'assets/doctor02.png',
    'doctorName': 'Dr. Gardner Pearson',
    'doctorTitle': 'Heart Specialist'
  },
  {
    'img': 'assets/doctor03.jpeg',
    'doctorName': 'Dr. Rosa Williamson',
    'doctorTitle': 'Skin Specialist'
  },
  {
    'img': 'assets/doctor02.png',
    'doctorName': 'Dr. Gardner Pearson',
    'doctorTitle': 'Heart Specialist'
  },
  {
    'img': 'assets/doctor03.jpeg',
    'doctorName': 'Dr. Rosa Williamson',
    'doctorTitle': 'Skin Specialist'
  }
];

class HomeTab extends StatelessWidget {
  final void Function() onPressedScheduleCard;

  const HomeTab({
    Key? key,
    required this.onPressedScheduleCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            UserIntro(),
            SizedBox(
              height: 10,
            ),
            SearchInput(),
            SizedBox(
              height: 20,
            ),
            CategoryIcons(),
            SizedBox(
              height: 20,
            ),
            Text(
              'Appointment Today',
              style: headline3,
            ),
            SizedBox(
              height: 20,
            ),
            AppointmentCard(
              onTap: onPressedScheduleCard,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Doctors',
                  style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: grayText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorList()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            for (var doctor in doctors)
              TopDoctorCard(
                img: doctor['img'],
                doctorName: doctor['doctorName'],
                doctorTitle: doctor['doctorTitle'],
              )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TopDoctorCard extends StatelessWidget {
  String img;
  String doctorName;
  String doctorTitle;

  TopDoctorCard({
    required this.img,
    required this.doctorName,
    required this.doctorTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SliverDoctorDetail(
                      doctor: {},
                    )),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 100,
                color: white,
                child: Image(
                  image: AssetImage(img),
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
                        color: black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      doctorTitle,
                      style: TextStyle(
                        color: grayText,
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
                          color: Color(MyColors.yellow02),
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '4.0 - 50 Reviews',
                          style: TextStyle(color: grayText),
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
  }
}

class AppointmentCard extends StatelessWidget {
  final void Function() onTap;

  const AppointmentCard({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: blueButton,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Booking')
                              .where('userUID', isEqualTo: currentUserId)
                              .where('status', isEqualTo: 'Upcoming')
                              .orderBy('dateTime')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final bookings = snapshot.data!.docs;
                              if (bookings.isNotEmpty) {
                                final upcomingBooking = bookings.first;
                                final doctorData = upcomingBooking['doctor']
                                    as Map<String, dynamic>?;
                                if (doctorData != null) {
                                  final imageUrl =
                                      doctorData['imageUrl'] as String?;
                                  final doctorName =
                                      doctorData['doctorName'] as String?;
                                  final specialty =
                                      doctorData['specialty'] as String?;

                                  return Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(imageUrl ?? ''),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctorName ?? '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            specialty ?? '',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              }
                            }

                            // Placeholder widget or loading indicator when data is not available
                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ScheduleCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.bg01),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.bg01).withOpacity(0.5),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

List<Map> categories = [
  {'icon': Icons.calculate_rounded, 'text': 'BMI'},
  {'icon': Icons.local_pharmacy, 'text': 'Medicine'},
  {'icon': Icons.shopping_bag_rounded, 'text': 'Shop'},
  {'icon': Icons.mark_unread_chat_alt_rounded, 'text': 'Chat'},
];

class CategoryIcons extends StatelessWidget {
  const CategoryIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var category in categories)
          CategoryIcon(
            icon: category['icon'],
            text: category['text'],
          ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg01),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Booking')
            .where('userUID', isEqualTo: currentUserId)
            .orderBy('dateTime')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final bookings = snapshot.data!.docs;
            if (bookings.isNotEmpty) {
              QueryDocumentSnapshot? bookingWithClosestDateTime;
              DateTime closestDateTime = DateTime.now()
                  .add(Duration(days: 365)); // Initialize with a future date

              // Find the booking with the closest dateTime to today
              for (var booking in bookings) {
                final bookingData = booking.data() as Map<String, dynamic>?;
                if (bookingData != null) {
                  final dateTime = bookingData['dateTime'] as Timestamp?;
                  if (dateTime != null) {
                    final bookingDateTime = dateTime.toDate();
                    final timeDifference = bookingDateTime
                        .difference(DateTime.now())
                        .inMilliseconds;
                    if (timeDifference >= 0 &&
                        timeDifference <
                            closestDateTime.millisecondsSinceEpoch) {
                      closestDateTime = bookingDateTime;
                      bookingWithClosestDateTime = booking;
                    }
                  }
                }
              }

              if (bookingWithClosestDateTime != null) {
                final dateTime =
                    bookingWithClosestDateTime['dateTime'] as Timestamp?;
                if (dateTime != null) {
                  final bookingDateTime = dateTime.toDate();
                  final formattedDate =
                      DateFormat('EEE, MMM d').format(bookingDateTime);
                  final formattedTime =
                      DateFormat('HH:mm').format(bookingDateTime);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: blueButton,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: TextStyle(color: blueButton),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.access_alarm,
                        color: blueButton,
                        size: 17,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          formattedTime,
                          style: TextStyle(color: blueButton),
                        ),
                      ),
                    ],
                  );
                }
              }
            }
          }

          // Placeholder widget or loading indicator when data is not available
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoryIcon extends StatelessWidget {
  IconData icon;
  String text;

  CategoryIcon({
    required this.icon,
    required this.text,
  });

  void navigateToPage(BuildContext context) async {
    if (text == 'BMI') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BMIPage()),
      );
    } else if (text == 'Medicine') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedicinePage()),
      );
    } else if (text == 'Shop') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedicineShopPage()),
      );
    } else if (text == 'Chat') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatListPage()),
        // final currentUser = FirebaseAuth.instance.currentUser;
        // final userId = currentUser?.uid;

        // if (userId == null) {
        //   // Handle the case where the user is not authenticated
        //   return;
        // }

        // final userSnapshot = await FirebaseFirestore.instance
        //     .collection('Booking')
        //     .where('doctorUID', isEqualTo: userId)
        //     .get();

        // final doctorSnapshot = await FirebaseFirestore.instance
        //     .collection('Booking')
        //     .where('userUID', isEqualTo: userId)
        //     .get();

        // final users = userSnapshot.docs.map((doc) => doc.data()['user']).toList();
        // final doctors =
        //     doctorSnapshot.docs.map((doc) => doc.data()['doctor']).toList();

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChatListScreen(
        //       doctors: doctors,
        //       users: users,
        //     ),
        //   ),
        // );
        // }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: blueButton,
      onTap: () => navigateToPage(context),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(MyColors.bg),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                color: blueButton,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: TextStyle(
                color: blueButton,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: blackTextFild,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.search,
              color: grayText,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search a doctor or health issue',
                hintStyle: TextStyle(
                    fontSize: 13, color: grayText, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserIntro extends StatelessWidget {
  const UserIntro({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('User')
          .doc(currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final String? avatarUrl = data != null ? data['avatar'] : null;
        final String displayName = data != null ? data['name'] : 'Guest';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  displayName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final userDoc = FirebaseFirestore.instance
                      .collection('User')
                      .doc(user.uid);
                  final userSnapshot = await userDoc.get();
                  final userRole = userSnapshot.data()?['role'];

                  if (userRole == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminPage()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfile()),
                    );
                  }
                }
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : AssetImage('assets/person.jpg') as ImageProvider<Object>?,
              ),
            ),
          ],
        );
      },
    );
  }
}
