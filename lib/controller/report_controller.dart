import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pku_online/models/report_model.dart';

class ReportController {
  late ReportModel _reportData;

  ReportController()
      : _reportData = ReportModel(
          bmi: '',
          bmiResultText: '',
          weight: 0,
          height: 0,
          latestReports: [],
        );

  ReportModel get model => _reportData;

  Future<void> fetchUserData() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Invoice')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      final latestReports =
          querySnapshot.docs.map((doc) => doc['report']).toList();
      _reportData.latestReports = latestReports.cast<String>();
    } catch (e) {
      print('Error fetching latest reports: $e');
    }
  }

  Future<void> fetchLatestReports(String currentUserId) async {
    try {
      final invoiceSnapshot = await FirebaseFirestore.instance
          .collection('Invoice')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      if (invoiceSnapshot.docs.isNotEmpty) {
        final latestInvoices = invoiceSnapshot.docs.map((doc) {
          final invoiceData = doc.data();
          return invoiceData['purchaseSummary'] as List<dynamic>;
        }).toList();

        latestInvoices.forEach((invoice) {
          final List<Map<String, dynamic>> invoiceItems =
              List<Map<String, dynamic>>.from(invoice);

          invoiceItems.forEach((item) {
            final String medicineName = item['medicineName'] as String;
            _reportData.latestReports.add(medicineName);
          });
        });
      }
    } catch (e) {
      print('Error fetching latest reports: $e');
    }
  }

  void updateWeight(double weight) {
    _reportData.weight = weight;
  }

  void addLatestReport(String report) {
    _reportData.latestReports.add(report);
  }
}
