import 'package:flutter/material.dart';
import 'package:pku_online/page/doctor_detail.dart';
import 'package:pku_online/page/splash_page.dart';
import 'package:pku_online/page/user_paymentdetails_page.dart';
import 'package:pku_online/page/user_profile.dart'; // Import the UserProfile class

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => HomePage(),
  '/detail': (context) => SliverDoctorDetail(),
  '/paymentdetails': (BuildContext context) => UserPaymentDetailsPage(),
  '/userprofile': (BuildContext context) => UserProfile()
};
