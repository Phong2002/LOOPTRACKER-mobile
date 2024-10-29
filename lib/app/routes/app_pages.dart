import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:looptracker_mobile/app/ui/pages/auth/otp_register_page.dart';
import 'package:looptracker_mobile/app/ui/pages/auth/photo_identification_verification.dart';
import 'package:looptracker_mobile/app/ui/pages/auth/register_page.dart';

import '../ui/pages/auth/login_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.LOGIN, page: () => LoginPage()),
    GetPage(name: AppRoutes.REGISTER, page: () => RegisterPage()),
    GetPage(name: AppRoutes.OTP_REGISTER, page: () => OtpRegisterPage()),
    GetPage(name: AppRoutes.PHOTO_IDENTIFICATION_VERIFICATION, page: () => PhotoIdentificationVerification()),
  ];
}
