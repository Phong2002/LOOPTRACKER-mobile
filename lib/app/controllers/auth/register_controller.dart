import 'dart:convert';
import 'dart:typed_data'; // Correct import for Uint8List
import 'package:dio/dio.dart' as dio; // Prefix dio import
import 'package:get/get.dart'; // GetX for state management
import '../../exception/ErrorCode.dart';
import '../../services/api_administrative_unit.dart'; // Your custom service
import '../../services/api_service.dart'; // Your custom service

class RegisterController extends GetxController {
  final ApiAdministrativeUnit apiAdministrativeUnit = ApiAdministrativeUnit();
  // Observable fields for data binding
  var firstName = ''.obs;
  var lastName = ''.obs;
  var gender = Rxn<String>(null);
  var province = ''.obs;
  var district = ''.obs;
  var ward = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var citizenIdentification = ''.obs;
  var licenseNumber = ''.obs;

  // Data lists for dropdowns
  var listProvinces = <String, String>{}.obs;
  var listDistricts = <String, String>{}.obs;
  var listWards = <String, String>{}.obs;

  // Messages for UI feedback
  var inforMessage = ''.obs;
  var photoIdMessage = ''.obs;
  var otpMessage = '';

  // Image files
  var cccdFront = Rx<Uint8List?>(null);
  var cccdBack = Rx<Uint8List?>(null);
  var gplxFront = Rx<Uint8List?>(null);
  var gplxBack = Rx<Uint8List?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProvinces();
  }

  // Fetch provinces from API
  void fetchProvinces() async {
    try {
      final response = await apiAdministrativeUnit.getAdministrativeUnit('/province', {});
      print("====================res   $response");
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        listProvinces.value = {
          for (var item in data)
            item['ProvinceID'].toString(): item['ProvinceName'].toString()
        };
      } else {
        print('Failed to fetch provinces `123  $response');
      }
    } catch (e) {
      print('Error fetching provinces: $e');
    }
  }

  void fetchDistricts() async {
    try {
      final response = await apiAdministrativeUnit.getAdministrativeUnit(
        '/district',
        {"province_id": province.value},
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        listDistricts.value = {
          for (var item in data)
            item['DistrictID'].toString(): item['DistrictName'].toString()
        };
      } else {
        print('Failed to fetch districts');
      }
    } catch (e) {
      print('Error fetching districts: $e');
    }
  }

  void fetchWard() async {
    try {
      final response = await apiAdministrativeUnit.getAdministrativeUnit(
        '/ward',
        {"district_id": district.value},
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        listWards.value = {
          for (var item in data)
            item['WardCode'].toString(): item['WardName'].toString()
        };
      } else {
        print('Failed to fetch wards');
      }
    } catch (e) {
      print('Error fetching wards: $e');
    }
  }

  void handleSelectProvince() {
    listDistricts.value = {};
    district.value = '';
    listWards.value = {};
    ward.value = '';
    fetchDistricts();
  }

  void handleSelectDistrict() {
    listWards.value = {};
    ward.value = '';
    fetchWard();
  }

  void setCccdFrontImage(Uint8List image) => cccdFront.value = image;
  void setCccdBackImage(Uint8List image) => cccdBack.value = image;
  void setGplxFrontImage(Uint8List image) => gplxFront.value = image;
  void setGplxBackImage(Uint8List image) => gplxBack.value = image;

  bool validateInfor() {
    if (firstName.value.isEmpty) {
      inforMessage.value = 'Họ không được để trống';
      return false;
    }
    if (lastName.value.isEmpty) {
      inforMessage.value = 'Tên đệm và tên không được để trống';
      return false;
    }
    if (gender.value == null) {
      inforMessage.value = 'Giới tính không được để trống';
      return false;
    }
    if (province.value.isEmpty) {
      inforMessage.value = 'Tỉnh không được để trống';
      return false;
    }
    if (district.value.isEmpty) {
      inforMessage.value = 'Huyện không được để trống';
      return false;
    }
    if (ward.value.isEmpty) {
      inforMessage.value = 'Xã không được để trống';
      return false;
    }
    if (phoneNumber.value.isEmpty) {
      inforMessage.value = 'Số điện thoại không được để trống';
      return false;
    }
    if (email.value.isEmpty) {
      inforMessage.value = 'Email không được để trống';
      return false;
    }
    if (citizenIdentification.value.isEmpty) {
      inforMessage.value = 'Số CCCD/CMND không được để trống';
      return false;
    }
    if (licenseNumber.value.isEmpty) {
      inforMessage.value = 'Số giấy phép lái xe không được để trống';
      return false;
    }
    inforMessage.value = '';
    return true;
  }

  bool validatePhotoId() {
    if (cccdFront.value == null) {
      photoIdMessage.value = 'CCCD mặt trước chưa được tải lên.';
      return false;
    }
    if (cccdBack.value == null) {
      photoIdMessage.value = 'CCCD mặt sau chưa được tải lên.';
      return false;
    }
    if (gplxFront.value == null) {
      photoIdMessage.value = 'GPLX mặt trước chưa được tải lên.';
      return false;
    }
    if (gplxBack.value == null) {
      photoIdMessage.value = 'GPLX mặt sau chưa được tải lên.';
      return false;
    }
    photoIdMessage.value = '';
    return true;
  }

  Future<bool> validateData() async {
    try {
      String endpoint = 'registration-request/validate-form';
      Map<String, String?> params = {
        "email": email.value,
        "phoneNumber": phoneNumber.value,
        "cccdNumber": citizenIdentification.value,
        "gplxNumber": licenseNumber.value,
      };

      final response = await ApiService.getData(endpoint, params);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        inforMessage.value = ErrorMessage.getErrorMessage(response.data["errorCode"]);
        return false;
      }
    } catch (e) {
      print('Error occurred during validation: $e');
      return false;
    }
    return false;
  }

  // Send registration request to the server
  Future<bool> sendRegistrationRequest() async {
    try {
      final data = {
        "firstName": firstName.value,
        "lastName": lastName.value,
        "gender": gender.value,
        "email": email.value,
        "phoneNumber": phoneNumber.value,
        "citizenIdNumber": citizenIdentification.value,
        "licenseNumber": licenseNumber.value,
        "address":
        "${listWards[ward.value]} - ${listDistricts[district.value]} - ${listProvinces[province.value]}"
      };

      final formData = dio.FormData.fromMap({
        'registrationRequestJson': jsonEncode(data),
        if (cccdFront.value != null)
          'fileCCCDInputFront': await dio.MultipartFile.fromBytes(cccdFront.value!, filename: 'cccd_front.png'),
        if (cccdBack.value != null)
          'fileCCCDInputBack': await dio.MultipartFile.fromBytes(cccdBack.value!, filename: 'cccd_back.png'),
        if (gplxFront.value != null)
          'fileGPLXInputFront': await dio.MultipartFile.fromBytes(gplxFront.value!, filename: 'gplx_front.png'),
        if (gplxBack.value != null)
          'fileGPLXInputBack': await dio.MultipartFile.fromBytes(gplxBack.value!, filename: 'gplx_back.png'),
      });

      final response = await ApiService.postFormData('registration-request/easy-rider', formData);

      if (response.statusCode == 200) {
        print('Đăng ký thành công: ${response.data}');
        return true;
      } else {
        photoIdMessage.value = ErrorMessage.getErrorMessage(response.data["errorCode"]);
        return false;
      }
    } catch (e) {
      print('Lỗi xảy ra khi gửi yêu cầu đăng ký: $e');
      return false;
    }
  }

  Future<bool> confirmOtp(String otp) async {
    try {
      String endpoint = 'otp/verify';
      Map<String, String?> data = {
        "email": email.value,
        "otp":otp
      };
      final response = await ApiService.putData(endpoint, data);
      if (response.statusCode == 200 && response.data["success"]) {
        return true;
      }
      else if(response.statusCode == 200 && !response.data["success"]){
        inforMessage.value = response.data["message"];
        return false;
      }
      else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        inforMessage.value = "Lỗi";
        return false;
      }
    } catch (e) {
      print('Error occurred during validation: $e');
      return false;
    }
    return false;
  }

  void clearOtpMessage (){
    inforMessage.value = "";
  }
}

