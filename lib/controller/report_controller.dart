import 'package:pku_online/models/report_model.dart';

class ReportController {
  late ReportModel _reportData;

  ReportController() {
    _reportData = ReportModel(
      heartRateBpm: 96,
      bloodGroup: 'A',
      weight: 80.0,
      latestReports: [],
    );
  }

  ReportModel get model => _reportData;

  void updateHeartRateBpm(int bpm) {
    _reportData.heartRateBpm = bpm;
  }

  void updateBloodGroup(String group) {
    _reportData.bloodGroup = group;
  }

  void updateWeight(double weight) {
    _reportData.weight = weight;
  }

  void addLatestReport(String report) {
    _reportData.latestReports.add(report);
  }
}
