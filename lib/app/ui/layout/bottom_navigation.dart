import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/main/main_controller.dart';

class BottomNavigation extends StatelessWidget {
  final MainController mainController = Get.find(); // Get the existing controller

  final Function(int)? onTap; // Declare onTap as a parameter

  BottomNavigation({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CurvedNavigationBar(
        // key: _bottomNavigationKey,
        height: 160.h,
        index: 0,
        items:mainController.getNavItems().map((item) => item.icon).toList(),
        color: Colors.green,
        buttonBackgroundColor: Colors.green[400],
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          if (onTap != null) {
            onTap!(index);
          }
        },
        letIndexChange: (index) => true,
      );
    });
  }
}
