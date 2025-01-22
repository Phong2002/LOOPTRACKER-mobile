import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:looptracker_mobile/app/ui/pages/rider/track_current_itinerary.dart';
import 'package:looptracker_mobile/app/ui/layout/main_page.dart';
import 'package:looptracker_mobile/app/ui/pages/auth/account_locked_page.dart';
import 'package:looptracker_mobile/app/ui/pages/auth/otp_register_page.dart';
import 'package:looptracker_mobile/app/ui/pages/auth/photo_identification_verification.dart';
import 'package:looptracker_mobile/app/ui/pages/auth/register_page.dart';
import 'package:looptracker_mobile/app/ui/pages/auth/registration_successful.dart';
import 'package:looptracker_mobile/app/ui/pages/common/change_password.dart';
import '../ui/pages/auth/login_page.dart';
import '../ui/pages/rider/notification_page.dart';
import '../ui/pages/rider/rider_home.dart';
import '../ui/pages/rider/rider_infor.dart';
import '../ui/pages/rider/tour_instance_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.LOGIN, page: () => LoginPage(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.REGISTER, page: () => RegisterPage(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.OTP_REGISTER, page: () => OtpRegisterPage(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.PHOTO_IDENTIFICATION_VERIFICATION, page: () => PhotoIdentificationVerification(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.REGISTRATION_SUCCESSFUL, page: () => RegistrationSuccessful(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.ACCOUNT_LOCKED, page: () => AccountLockedPage(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.MAIN_PAGE, page: () => MainPage(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.RIDER_HOME, page: () => RiderHome(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.RIDER_INFO, page: () => RiderInfo(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.CHANGE_PASSWORD_PAGE, page: () => ChangePasswordPage(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.NOTIFICATION_PAGE, page: () => NotificationPage(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.TRACK_CURRENT_ITINERARY, page: () => TrackCurrentItinerary(),transition: Transition.rightToLeft),
    GetPage(name: AppRoutes.TOUR_INSTANCE_PAGE, page: () => TourInstancePage(),transition: Transition.rightToLeft),
  ];
}
