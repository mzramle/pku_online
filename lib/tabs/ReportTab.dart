// ReportTab.dart

import 'package:flutter/material.dart';
import 'package:pku_online/controller/report_controller.dart';
import 'package:pku_online/core/Icon_Content.dart';
import 'package:pku_online/core/colors.dart';

class ReportTab extends StatefulWidget {
  @override
  _ReportTabState createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  late ReportController _reportController;

  @override
  void initState() {
    super.initState();
    _reportController = ReportController();
    _fetchUserData(); // Fetch user data when the widget is initialized
  }

  void _fetchUserData() async {
    await _reportController.fetchUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        title: Text(
          'Report',
          style: TextStyle(color: Colors.black, fontSize: 24.0),
          textAlign: TextAlign.left,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 160,
              child: Card(
                color: Color.fromARGB(255, 203, 231, 255),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'BMI',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '${_reportController.model.bmi}',
                            ),
                            TextSpan(
                              text:
                                  '\n${_reportController.model.bmiResultText}',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  trailing: Icon(
                    Icons.accessibility_new_outlined,
                    color: Color.fromARGB(255, 22, 111, 219),
                    size: 120,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  onTap: () {
                    // Handle BMI tap
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Color(0xFFF5E1E9),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 0.0,
                      ),
                      leading: Icon(
                        Icons.monitor_weight_outlined,
                        color: Color(0xFFE2093B),
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Weight',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      subtitle: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${_reportController.model.weight} kg',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Card(
                    color: Color(0xFFFAF0DB),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 0.0,
                      ),
                      leading: Icon(
                        Icons.height_outlined,
                        color: Color(0xFFE09F1F),
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Height',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      subtitle: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${_reportController.model.height} cm',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Latest Reports',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8.0),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _reportController.model.latestReports.length,
            itemBuilder: (context, index) {
              final report = _reportController.model.latestReports[index];
              return ListTile(
                title: Text(report),
                onTap: () {
                  // Handle report tap
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
