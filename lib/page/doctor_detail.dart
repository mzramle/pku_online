import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:pku_online/core/colors.dart';
import "package:latlong2/latlong.dart" as latLng;
import 'package:table_calendar/table_calendar.dart';

class SliverDoctorDetail extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const SliverDoctorDetail({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Doctor Detail'),
            backgroundColor: blueButton,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: AssetImage('assets/hospital.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailBody(doctor: doctor),
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DetailBody({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final about = doctor['about'];

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailDoctorCard(doctor: doctor),
          SizedBox(height: 15),
          DoctorInfo(doctor: doctor),
          SizedBox(height: 30),
          Text(
            'About Doctor',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 15),
          Text(
            about,
            style: TextStyle(
              color: grayText,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          SizedBox(height: 25),
          Text(
            'Location',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 25),
          DoctorLocation(),
          SizedBox(height: 25),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(blueButton),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(double.infinity, 50),
              ),
            ),
            child: Text('Book Appointment'),
            onPressed: () {
              _showDateSelectionModal(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDateSelectionModal(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 30)),
      onConfirm: (date) {
        _showTimeSelectionModal(context, date);
      },
    );
  }

  void _showTimeSelectionModal(BuildContext context, DateTime selectedDate) {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (time) {
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          time.hour,
          time.minute,
        );
        if (_isTimeWithinRange(selectedDateTime)) {
          _handleAppointmentBooking(context, selectedDateTime);
        } else {
          _showTimeSelectionErrorSnackbar(context);
        }
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en, // Set your desired locale
    );
  }

  bool _isTimeWithinRange(DateTime dateTime) {
    final TimeOfDay minTime = TimeOfDay(hour: 8, minute: 0);
    final TimeOfDay maxTime = TimeOfDay(hour: 17, minute: 0);
    final TimeOfDay selectedTime = TimeOfDay.fromDateTime(dateTime);
    final now = TimeOfDay.fromDateTime(DateTime.now());

    print('Selected time: $selectedTime');
    print('Now: $now');

    if (selectedTime.hour >= minTime.hour &&
        selectedTime.hour <= maxTime.hour) {
      if (dateTime.year == DateTime.now().year &&
          dateTime.month == DateTime.now().month &&
          dateTime.day == DateTime.now().day) {
        if (selectedTime.hour > now.hour ||
            (selectedTime.hour == now.hour &&
                selectedTime.minute >= now.minute)) {
          print('Time within range and not in the past');
          return true;
        } else {
          print('Time is in the past');
          return false;
        }
      } else {
        print('Time within range');
        return true;
      }
    } else {
      print('Time outside range');
      return false;
    }
  }

  void _showTimeSelectionErrorSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content:
          Text('The time you picked have passed or is out of the office hour.'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleAppointmentBooking(
      BuildContext context, DateTime selectedDateTime) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .get()
          .then((userSnapshot) {
        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data()!;
          FirebaseFirestore.instance.collection('Booking').add({
            'date': selectedDateTime
                .toIso8601String(), // Store selected date as string
            'doctor': {
              'doctorName': doctor['doctorName'],
              'specialty': doctor['specialty'],
              'email': doctor['email'],
              'imageUrl': doctor['imageUrl'],
            },
            'user': userData, // Save the entire user object
            'userUID': user.uid,
            'doctorUID': doctor['doctorId'],
            'status': 'Upcoming',
          }).then((value) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Booking created successfully.'),
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
            print('Booking saved to the database');
          }).catchError((error) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to save booking: $error'),
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
            print('Failed to save booking: $error');
          });
        } else {
          print('User does not exist');
        }
      }).catchError((error) {
        print('Failed to fetch user: $error');
      });
    }
  }
}

class CalendarWidget extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;

  const CalendarWidget({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDateSelected(selectedDay);
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2023, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
    );
  }
}

class DoctorLocation extends StatelessWidget {
  const DoctorLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          options: MapOptions(
            center: latLng.LatLng(1.5595119, 103.6260899),
            zoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorInfo({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final patient = doctor['patient'];
    final experience = doctor['experience'];
    return Row(
      children: [
        NumberCard(
          label: 'Patients',
          value: patient.toString(),
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Experiences',
          value: '$experience years',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Rating',
          value: '4.0',
        ),
      ],
    );
  }
}

class AboutDoctor extends StatelessWidget {
  final String title;
  final String desc;
  const AboutDoctor({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NumberCard extends StatelessWidget {
  final String label;
  final String value;

  const NumberCard({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(MyColors.bg),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(MyColors.grey02),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                color: Color(MyColors.header01),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailDoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DetailDoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = doctor['doctorName'];
    final specialty = doctor['specialty'];
    final imageUrl = doctor['imageUrl'];
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Color(MyColors.header01),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      specialty,
                      style: TextStyle(
                        color: Color(MyColors.grey02),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
