class ReportModel {
  int heartRateBpm;
  String bloodGroup;
  double weight;
  List<String> latestReports;

  ReportModel({
    required this.heartRateBpm,
    required this.bloodGroup,
    required this.weight,
    required this.latestReports,
  });
}
