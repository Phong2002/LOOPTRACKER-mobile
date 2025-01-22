import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class MainController extends GetxController {
  var selectedIndex = 0.obs;
  var role = ''.obs;

  List<String> getNavRoutes() {
    switch (role.value) {
      case 'admin':
        return [
          AppRoutes.RIDER_INFO,
          AppRoutes.RIDER_HOME,
          AppRoutes.LOGIN,
          AppRoutes.ACCOUNT_LOCKED,
          // AppRoutes.userManagement,
          // AppRoutes.adminSettings,
        ];
      case 'EASY_RIDER':
        return [
          AppRoutes.RIDER_HOME,
          AppRoutes.ACCOUNT_LOCKED,
          AppRoutes.TRACK_CURRENT_ITINERARY,
          AppRoutes.NOTIFICATION_PAGE,
          AppRoutes.RIDER_INFO,
          // AppRoutes.riderTracking,
          // AppRoutes.riderNotifications,
        ];
      case 'TOUR_GUIDE':
        return [
          AppRoutes.RIDER_HOME,
          AppRoutes.RIDER_HOME,
          AppRoutes.TRACK_CURRENT_ITINERARY,
          AppRoutes.NOTIFICATION_PAGE,
          AppRoutes.RIDER_INFO,
          // AppRoutes.tourGuideReports,
          // AppRoutes.tourGuideSettings,
        ];
      default:
        return [AppRoutes.LOGIN];
    }
  }

  List<BottomNavigationBarItem> getNavItems() {
    switch (role.value) {
      case 'admin':
        return [
          const BottomNavigationBarItem(
              icon: Icon(color: Colors.white,size: 35,Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
            label: '123',
            icon: Container(
              padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: const FlutterLogo(
                size: 38.0,
              ),
            ),
          ),
          const BottomNavigationBarItem(
              icon: Icon(color: Colors.white,size: 35,Icons.settings), label: 'Settings'),
        ];
      case 'EASY_RIDER':
        return [
          const BottomNavigationBarItem(icon: Icon(color: Colors.white,size: 35,Icons.home), label: 'Trang chủ'),
          const BottomNavigationBarItem(icon: Icon(color: Colors.white,size: 35,Icons.history), label: 'Lịch sử'),
          const BottomNavigationBarItem(
              icon: Icon(color: Colors.white,size: 35,Icons.share_location,), label: 'chuyến đi' ),
          const BottomNavigationBarItem(
              icon: Icon(color: Colors.white,size: 35,Icons.notifications), label: 'Thông báo'),
          const BottomNavigationBarItem(icon: Icon(color: Colors.white,size: 35,Icons.person), label: 'Hồ sơ'),
        ];
      case 'TOUR_GUIDE':
        return [
          const BottomNavigationBarItem(icon: Icon(color: Colors.white,size: 35,Icons.home), label: 'Trang chủ'),
          const BottomNavigationBarItem(icon: Icon(color: Colors.white,size: 35,Icons.history), label: 'Lịch sử'),
          const BottomNavigationBarItem(
              icon: Icon(color: Colors.white,size: 35,Icons.share_location,), label: 'chuyến đi'),
          const BottomNavigationBarItem(
              icon: Icon(color: Colors.white,size: 35,Icons.notifications), label: 'Thông báo'),
          const BottomNavigationBarItem(icon: Icon(color: Colors.white,size: 35,Icons.person), label: 'Hồ sơ'),
        ];
      default:
        return [];
    }
  }

  Future<void> initAfterLogin(String userRole) async {
    this.role.value = userRole;
    this.selectedIndex.value = 0;
  }

  void changePage(int index) {
    selectedIndex.value = index;
    Get.offAllNamed(getNavRoutes()[index], id: 8386);
  }
}
