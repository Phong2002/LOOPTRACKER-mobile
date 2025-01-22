import 'package:get/get.dart';
import 'package:looptracker_mobile/app/controllers/auth/authentication_controller.dart';
import 'package:looptracker_mobile/app/controllers/main/main_controller.dart';
import 'package:looptracker_mobile/app/controllers/rider/notification_controller.dart';
import 'package:looptracker_mobile/app/controllers/rider/rider_infor_controller.dart';
import 'package:looptracker_mobile/app/services/api_service.dart';
import 'package:looptracker_mobile/main.dart';

import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthenticationController authenticationController = Get.find<AuthenticationController>();
  final MainController mainController = Get.find();
  final RiderInforController riderInfoController = Get.find();
  final NotificationController notificationController = Get.put(NotificationController());
  var username = ''.obs;
  var password = ''.obs;
  var message = ''.obs;
  var isLoading = false.obs;
  var isPasswordView = false.obs;


  void clearData(){
    username.value='';
    password.value='';
  }


  Future<bool> login() async {
    message.value = "";
    isLoading.value = true;
    if (username.value.isEmpty && password.value.isEmpty) {
      message.value = "Vui lòng nhập đủ thông tin !";
      isLoading.value = false;
      return false;
    }
    try {
      String endpoint = 'auth/login';
      Map<String, String?> data = {
        "username": username.value,
        "password": password.value
      };
      final response = await ApiService.postData(endpoint, data);
      print("Login response: ${response.data}");  // Debug response

      if (response.statusCode == 200) {
        await mainController.initAfterLogin(response.data["role"]);
       await authenticationController.updateData(
          newUserId: response.data["userId"],
          newFirstName: response.data["firstName"],
          newLastName: response.data["lastName"],
          newGender: response.data["gender"],
          newEmail: response.data["email"],
          newPhoneNumber: response.data["phoneNumber"],
          newRole: response.data["role"],
          newToken: response.data["token"],
          newAvatarUrl : response.data["avatarUrl"],
        );

        if (response.data["role"] == 'EASY_RIDER' || response.data["role"] == 'TOUR_GUIDE') {
          String userID = response.data["userId"];
          riderInfoController.getInforRider(userID);
          notificationController.connect(userID);
          print("====================================3333");
        }
        clearData();
        isLoading.value = false;
        Get.offNamed(AppRoutes.MAIN_PAGE);
        return true;
      } else if (response.statusCode == 401) {
        message.value = "Sai tài khoản hoặc mật khẩu";
        isLoading.value = false;
        return false;
      } else if (response.statusCode == 423) {
        clearData();
        Get.offNamed(AppRoutes.ACCOUNT_LOCKED);
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      print("Login error: $e");  // Debug error
      return false;
    }
    clearData();
    return false;
  }


  void togglePasswordView(){
    isPasswordView.value = !isPasswordView.value;
  }
}