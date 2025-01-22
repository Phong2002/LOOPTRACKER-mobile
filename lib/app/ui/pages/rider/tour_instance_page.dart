import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../controllers/rider/tour_instance_controller.dart';
import 'track_current_itinerary.dart';

class TourInstancePage extends StatelessWidget {
  final TourInstanceController tourInstanceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => tourInstanceController.tourInstanceId.value.isEmpty
            ? noTour()
            : TrackCurrentItinerary(), // Trả về TrackCurrentItinerary khi có tour
      ),
    );
  }
}

// Widget cho màn hình khi không có tour
Widget noTour() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/animations/tracking.json', // File JSON từ LottieFiles
          height: 250,
          repeat: true,
        ),
        SizedBox(height: 20),
        // Tiêu đề
        Text(
          "Xin lỗi, hiện tại bạn đang không tham gia chuyến đi nào !",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        // Mô tả chi tiết
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            "Hiện tại bạn không tham gia chuyến đi nào. Vui lòng chờ quản lý phân công hoặc kiểm tra lại sau.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    ),
  );
}
