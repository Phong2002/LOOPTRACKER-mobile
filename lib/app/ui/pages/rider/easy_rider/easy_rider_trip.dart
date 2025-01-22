import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../report_issue_screen.dart';

class EasyRiderTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            // Navigate to CurrentJourneyScreen using GetX
            Get.to(CurrentJourneyScreen());
          },
          child: Text("Hành trình hiện tại", style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            iconColor: Colors.blueAccent,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to ReportIssueScreen using GetX
            Get.to(ReportIssueScreen());
          },
          child: Text("Báo cáo sự cố", style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            iconColor: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}

class CurrentJourneyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hành Trình Hiện Tại"),
      ),
      body: Center(
        child: Text(
          "Thông tin hành trình hiện tại sẽ hiển thị ở đây.",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
