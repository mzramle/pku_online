import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pku_online/core/colors.dart';
import 'package:pku_online/core/text_style.dart';
import 'package:pku_online/page/chat_page.dart';
import 'package:pku_online/page/paymentpage.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

enum FilterStatus { Upcoming, Complete, Cancel }

class User {
  final String name;
  final String email;
  final String avatar;

  User({
    required this.name,
    required this.email,
    required this.avatar,
  });
}

class Booking {
  final String id;
  final DateTime dateTime;
  final Doctor doctor;
  final String status;
  final String userUID;
  final User user;

  Booking({
    required this.id,
    required this.dateTime,
    required this.doctor,
    required this.status,
    required this.userUID,
    required this.user,
  });
}

class Doctor {
  final String name;
  final String title;
  final String image;
  final String email;

  Doctor({
    required this.name,
    required this.title,
    required this.image,
    required this.email,
  });
}

class _ScheduleTabState extends State<ScheduleTab> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;
  late List<Booking> bookings = [];
  late String currentUserRole = ''; // Define currentUserRole variable

  @override
  void initState() {
    super.initState();
    // Fetch bookings from Firestore and initialize the `bookings` list
    fetchBookings();
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

  Future<void> fetchBookings() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final currentUserUID = currentUser.uid;
        final currentUserRole = await FirebaseFirestore.instance
            .collection('User')
            .doc(currentUserUID)
            .get()
            .then((snapshot) => snapshot['role']);

        List<Booking> fetchedBookings = [];

        if (currentUserRole == 'doctor') {
          final snapshot = await FirebaseFirestore.instance
              .collection('Booking')
              .where('doctorUID', isEqualTo: currentUserUID)
              .get();

          fetchedBookings = snapshot.docs.map((doc) {
            final data = doc.data();
            final dateTime = (data['dateTime'] as Timestamp).toDate();
            final doctorData = data['doctor'];
            final doctor = Doctor(
              name: doctorData['doctorName'],
              title: doctorData['specialty'],
              image: doctorData['imageUrl'],
              email: doctorData['email'],
            );

            final userData = data['user'];
            final user = User(
              name: userData['name'],
              email: userData['email'],
              avatar: userData['avatar'],
            );

            return Booking(
              id: doc.id,
              dateTime: dateTime,
              doctor: doctor,
              status: data['status'],
              user: user,
              userUID: data['userUID'],
            );
          }).toList();
        } else {
          final snapshot = await FirebaseFirestore.instance
              .collection('Booking')
              .where('userUID', isEqualTo: currentUserUID)
              .get();

          fetchedBookings = snapshot.docs.map((doc) {
            final data = doc.data();
            final dateTime = (data['dateTime'] as Timestamp).toDate();
            final doctorData = data['doctor'];
            final doctor = Doctor(
              name: doctorData['doctorName'],
              title: doctorData['specialty'],
              image: doctorData['imageUrl'],
              email: doctorData['email'],
            );

            final userData = data['user'];
            final user = User(
              name: userData['name'],
              email: userData['email'],
              avatar: userData['avatar'],
            );

            return Booking(
              id: doc.id,
              dateTime: dateTime,
              doctor: doctor,
              status: data['status'],
              user: user,
              userUID: data['userUID'],
            );
          }).toList();
        }

        setState(() {
          bookings = fetchedBookings;
        });
      }
    } catch (error) {
      print('Error fetching bookings: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Booking> filteredBookings = bookings.where((booking) {
      return booking.status == status.toString().split('.').last;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Schedule',
              textAlign: TextAlign.center,
              style: headline1.copyWith(fontSize: FontSizes.title),
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(MyColors.bg),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (filterStatus == FilterStatus.Upcoming) {
                                  status = FilterStatus.Upcoming;
                                  _alignment = Alignment.centerLeft;
                                } else if (filterStatus ==
                                    FilterStatus.Complete) {
                                  status = FilterStatus.Complete;
                                  _alignment = Alignment.center;
                                } else if (filterStatus ==
                                    FilterStatus.Cancel) {
                                  status = FilterStatus.Cancel;
                                  _alignment = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(
                                filterStatus.toString().split('.').last,
                                style: headline3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: _alignment,
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: blueButton,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status.toString().split('.').last,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  var booking = filteredBookings[index];
                  bool isLastElement = filteredBookings.length == index + 1;

                  // Check the user's role to determine whether to display user information
                  bool isDoctor = currentUserRole == 'doctor';

                  // Get today's date without time
                  DateTime today = DateTime.now().toLocal();
                  DateTime bookingDate = booking.dateTime.toLocal();

                  bool isToday = today.year == bookingDate.year &&
                      today.month == bookingDate.month &&
                      today.day == bookingDate.day;

                  return Card(
                    margin: !isLastElement
                        ? EdgeInsets.only(bottom: 20)
                        : EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  isDoctor
                                      ? booking.user.avatar
                                      : booking.doctor.image,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isDoctor
                                        ? booking.user.name
                                        : booking.doctor.name,
                                    style: TextStyle(
                                      color: Color(MyColors.header01),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    isDoctor
                                        ? booking.user.email
                                        : booking.doctor.title,
                                    style: TextStyle(
                                      color: Color(MyColors.grey02),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          DateTimeCard(dateTime: booking.dateTime),
                          SizedBox(height: 15),
                          if (booking.status == 'Upcoming')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        blueButton,
                                      ), // Text color
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                        BorderSide(
                                          color: blueButton,
                                        ),
                                      ), // Border color
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ), // Button shape
                                    ),
                                    child: Text(
                                      isToday ? 'Chat' : 'Cancel',
                                    ),
                                    onPressed: () {
                                      if (isToday) {
                                        // Redirect to chat page
                                        navigateToChatPage(booking);
                                      } else {
                                        // Change booking status to 'Cancel'
                                        cancelBooking(booking);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        blueButton,
                                      ), // Button background color
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.white,
                                      ), // Text color
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ), // Button shape
                                    ),
                                    child: Text('Reschedule'),
                                    onPressed: () {
                                      // Redirect to doctor's detail page
                                      navigateToDoctorDetail();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          if (booking.status == 'Complete')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        blueButton,
                                      ), // Button background color
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.white,
                                      ), // Text color
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ), // Button shape
                                    ),
                                    child: Text('Confirm and Pay'),
                                    onPressed: () {
                                      // Redirect to payment page
                                      navigateToPaymentPage(booking);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          if (booking.status == 'Cancel')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        blueButton,
                                      ), // Button background color
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.white,
                                      ), // Text color
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ), // Button shape
                                    ),
                                    child: Text('Reschedule'),
                                    onPressed: () {
                                      // Redirect to chat page
                                      navigateToDoctorDetail();
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void cancelBooking(Booking booking) {
    try {
      // Update booking status to 'Cancel' in Firestore
      FirebaseFirestore.instance.collection('Booking').doc(booking.id).update({
        'status': 'Cancel',
      }).then((_) {
        // Update the bookings list after successful Firestore update
        setState(() {
          bookings = bookings.map((b) {
            if (b.id == booking.id) {
              return Booking(
                id: b.id,
                dateTime: b.dateTime,
                doctor: b.doctor,
                status: 'Cancel',
                userUID: b.userUID,
                user: b.user,
              );
            }
            return b;
          }).toList();
        });
      }).catchError((error) {
        print('Error updating booking status: $error');
      });
    } catch (error) {
      print('Error updating booking status: $error');
    }
  }

  void navigateToDoctorDetail() {
    // TODO: Navigate to the doctor's detail page and pass the doctor object
  }

  void navigateToPaymentPage(Booking booking) {
    // Set the price to 5
    double price = 5.0;

    // Navigate to the payment page and pass the booking information and price
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(booking: booking, price: price),
      ),
    );
  }

  void navigateToChatPage(Booking booking) {
    FirebaseFirestore.instance
        .collection('Booking')
        .doc(booking.id)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data()!;

        print('Fetched data: $data');

        // Fetch doctor details
        var doctorData = data['doctor'];

        // Fetch user details
        var userData = data['user'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
                selectedDoctor: doctorData,
                selectedUser: userData,
                chatId: null,
                bookingId: booking.id),
          ),
        );
      }
    }).catchError((error) {
      print('Error fetching booking data: $error');
    });
  }
}

class DateTimeCard extends StatelessWidget {
  final DateTime dateTime;

  const DateTimeCard({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: blueButton,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                DateFormat('EEE, MMM d').format(dateTime),
                style: TextStyle(
                  fontSize: 12,
                  color: blueButton,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.access_alarm,
                color: blueButton,
                size: 17,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                DateFormat('HH:mm').format(dateTime),
                style: TextStyle(
                  color: blueButton,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
