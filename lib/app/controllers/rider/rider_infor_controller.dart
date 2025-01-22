import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:looptracker_mobile/app/controllers/rider/tour_instance_controller.dart';
import '../../exception/ErrorCode.dart';
import '../../services/api_service.dart';
import '../auth/authentication_controller.dart';
import 'package:dio/dio.dart' as dio; // Prefix dio import

class RiderInforController extends GetxController {
  var avatarUrl = ''.obs;
  var newAvatarFile = Rx<Uint8List?>(null);
  var firstName = ''.obs;
  var lastName = ''.obs;
  var gender = ''.obs;
  var address = ''.obs;
  var phoneNumber = ''.obs;
  var riderStatus = ''.obs;
  var email = ''.obs;
  var cccd = ''.obs;
  var gplx = ''.obs;
  var createAt = Rx<DateTime?>(null);
  var totalTrips = 0.obs;
  final AuthenticationController authController =
      Get.find<AuthenticationController>();
  var updateInforErrorMessage = ''.obs;
  var changePasswordErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  var isAvailable = true.obs; // Track availability status

  Future<bool> toggleAvailability(bool newValue) async {
    String newStatus = '';
    if (newValue) {
      newStatus = "READY";
    } else {
      newStatus = "NOT_READY";
    }
    try {
      String endpoint = 'rider-infor/update-rider-status';
      Map<String, String?> data = {
        "driverStatus": newStatus,
      };
      final response = await ApiService.putData(endpoint, data);
      if (response.statusCode == 200) {
        riderStatus.value = newStatus;
        return true;
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<void> getInforRider(String userId) async {
    try {
      String endpoint = 'rider-infor/get';
      Map<String, String?> data = {
        "riderId": userId,
      };
      final response = await ApiService.getData(endpoint, data);
      if (response.statusCode == 200) {
        cccd.value = response.data["citizenIdNumber"] ?? '';
        gplx.value = response.data["licenseNumber"] ?? '';
        address.value = response.data["address"] ?? '';
        riderStatus.value = response.data["riderStatus"] ?? '';
        createAt.value = DateTime.tryParse(response.data["createAt"]);
        totalTrips.value = response.data["totalTrips"] ?? 0;
        firstName.value = authController.firstName.value;
        lastName.value = authController.lastName.value;
        gender.value = authController.gender.value;
        phoneNumber.value = authController.phoneNumber.value;
        email.value = authController.email.value;
        avatarUrl.value = authController.avatarUrl.value;
        final TourInstanceController tourInstanceController = Get.find();
        tourInstanceController.initTourInstance();
      } else {
        print("Failed to get rider info, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in getInforRider: $e");
    }
  }

  Future<bool> updateInfor(
      String newAddress, String newEmail, String newPhoneNumber) async {
    updateInforErrorMessage.value = "";
    if (newAddress.isEmpty) {
      updateInforErrorMessage.value = "Địa chỉ không được để trống";
      return false;
    }
    if (newEmail.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(newEmail)) {
      updateInforErrorMessage.value = "Email không hợp lệ";
      return false;
    }
    if (newPhoneNumber.isEmpty || newPhoneNumber.length < 10) {
      updateInforErrorMessage.value = "Số điện thoại không hợp lệ";
      return false;
    }

    try {
      String endpoint = 'user/update-infor';
      Map<String, String?> data = {
        "address": newAddress,
        "email": newEmail,
        "phoneNumber": newPhoneNumber
      };

      final response = await ApiService.putData(endpoint, data);

      if (response.statusCode == 200) {
        this.address.value = newAddress;
        this.email.value = newEmail;
        this.phoneNumber.value = newPhoneNumber;
        return true;
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        updateInforErrorMessage.value =
            ErrorMessage.getErrorMessage(response.data["errorCode"]);
        return false;
      }
    } catch (e) {
      updateInforErrorMessage.value = "Có lỗi xảy ra. Vui lòng thử lại.";
      return false;
    }
    return false;
  }

  Future<bool> changePassword(
      String oldPassword, String newPassword, String confirmNewPassword) async {
    changePasswordErrorMessage.value = "";
    if (oldPassword.isEmpty) {
      changePasswordErrorMessage.value = "Mật khẩu cũ không được để trống.";
      return false;
    }
    if (newPassword.isEmpty) {
      changePasswordErrorMessage.value = "Mật khẩu mới không được để trống.";
      return false;
    }
    // if (newPassword.length < 8) {
    //   changePasswordErrorMessage.value = "Mật khẩu mới phải có ít nhất 8 ký tự.";
    //   return false;
    // }
    if (newPassword != confirmNewPassword) {
      changePasswordErrorMessage.value =
          "Mật khẩu mới và xác nhận mật khẩu không khớp";
      return false;
    }
    try {
      String endpoint = 'user/update-password';
      Map<String, String?> data = {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      };
      final response = await ApiService.putData(endpoint, data);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        changePasswordErrorMessage.value =
            ErrorMessage.getErrorMessage(response.data["errorCode"]);
        return false;
      }
    } catch (e) {
      changePasswordErrorMessage.value = "Có lỗi xảy ra. Vui lòng thử lại.";
      return false;
    }
    return false;
  }

  Future<bool> updateAvatar(Uint8List newAvatar) async {
    try {
      String endpoint = 'user/update-avatar';
      final formData = dio.FormData.fromMap({
        'avatar': dio.MultipartFile.fromBytes(newAvatar, filename: 'avatar'),
      });
      final response = await ApiService.putFormData(endpoint, formData);
      if (response.statusCode == 200) {
        avatarUrl.value = response.data;
        return true;
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        changePasswordErrorMessage.value =
            ErrorMessage.getErrorMessage(response.data["errorCode"]);
        return false;
      }
    } catch (e) {
      changePasswordErrorMessage.value = "Có lỗi xảy ra. Vui lòng thử lại.";
      return false;
    }
    return false;
  }

  void saveInfo() async {}
}
