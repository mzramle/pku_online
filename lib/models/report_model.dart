class ReportModel {
  String bmi;
  String bmiResultText;
  double weight;
  double height;
  List<String> latestReports;

  ReportModel({
    required this.bmi,
    required this.bmiResultText,
    required this.weight,
    required this.height,
    required this.latestReports,
  });
}
