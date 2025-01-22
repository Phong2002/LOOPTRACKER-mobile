import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/main/main_controller.dart';
import 'bottom_navigation.dart';
import '../../routes/app_pages.dart'; // Import your AppPages

class MainPage extends StatelessWidget {
  final MainController mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(8386),
        onGenerateRoute: (settings) {
          return GetPageRoute(
            page: () {
              return Obx(() {
                return AppPages.pages
                    .firstWhere((page) => page.name == mainController.getNavRoutes()[mainController.selectedIndex.value])
                    .page();
              });
            },
            settings: settings,
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (index) {
          mainController.changePage(index);
        },
      ),
    );
  }
}
