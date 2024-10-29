import 'package:get/get.dart';
import 'package:looptracker_mobile/app/controllers/auth/register_controller.dart';
import '../controllers/auth/login_controller.dart';
import '../controllers/auth/otp_register_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(RegisterController());
    Get.put(OtpRegisterController());
  }
}