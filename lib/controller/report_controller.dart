import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pku_online/models/report_model.dart';

class ReportController {
  late ReportModel _reportData;

  ReportController() {
    _reportData = ReportModel(
      bmi: '',
      bmiResultText: '',
      weight: 0,
      height: 0,
      latestReports: [],
    );
  }

  ReportModel get model => _reportData;

  Future<void> fetchUserData() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      final userData = await FirebaseFirestore.instance
          .collection('userBMIResult')
          .doc(currentUserId)
          .get();

      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;

        _reportData = ReportModel(
          bmi: data['bmi'] ?? '',
          bmiResultText: data['resultText'] ?? '',
          weight: data['weight']?.toDouble() ?? 0,
          height: data['height']?.toDouble() ?? 0,
          latestReports: List<String>.from(data['latestReports'] ?? []),
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void updateWeight(double weight) {
    _reportData.weight = weight;
  }

  void addLatestReport(String report) {
    _reportData.latestReports.add(report);
  }
}
