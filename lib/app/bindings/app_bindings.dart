import 'package:get/get.dart';
import 'package:looptracker_mobile/app/controllers/auth/authentication_controller.dart';
import 'package:looptracker_mobile/app/controllers/auth/register_controller.dart';
import 'package:looptracker_mobile/app/controllers/rider/notification_controller.dart';
import '../controllers/auth/login_controller.dart';
import '../controllers/main/main_controller.dart';
import '../controllers/rider/rider_infor_controller.dart';
import '../controllers/rider/tour_instance_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(AuthenticationController());
    Get.put(RiderInforController());
    Get.put(LoginController());
    Get.put(RegisterController());
    Get.put(TourInstanceController());
  }
}