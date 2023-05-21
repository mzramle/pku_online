import 'package:flutter/material.dart';
import 'package:pku_online/controller/report_controller.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.arrow_back_ios_outlined,
          color: Colors.black,
        ),
        elevation: 0,
        title: Text('Report',
            style: TextStyle(color: Colors.black, fontSize: 24.0),
            textAlign: TextAlign.left),
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
                      'Heart Rate',
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
                                text:
                                    '${_reportController.model.heartRateBpm}'),
                            TextSpan(
                              text: ' bpm',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  trailing: Icon(Icons.monitor_heart_outlined,
                      color: Color.fromARGB(255, 22, 111, 219), size: 120),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  onTap: () {
                    // Handle heart rate tap
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Color(0xFFF5E1E9),
                    child: ListTile(
                      leading: Icon(
                        Icons.bloodtype,
                        color: Color(0xFF9D4C6C),
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Blood Group',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      subtitle: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          _reportController.model.bloodGroup,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onTap: () {
                        // Handle blood group tap
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Card(
                    color: Color(0xFFFAF0DB),
                    child: ListTile(
                      leading: Icon(
                        Icons.monitor_weight_outlined,
                        color: Color(0xFFE09F1F),
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
                      onTap: () {
                        // Handle weight tap
                      },
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
