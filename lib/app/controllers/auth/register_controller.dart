import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../../services/api_administrative_unit.dart';

class RegisterController extends GetxController {
  var firstName = ''.obs;
  var lastName = ''.obs;
  var gender = Rxn<String>(null);
  var dateOfBirth = Rxn<DateTime>(null);
  var province = ''.obs;
  var district = ''.obs;
  var email = ''.obs;
  var ward = ''.obs;
  var phoneNumber = ''.obs;
  var citizenIdentification = ''.obs;
  var licenseNumber = ''.obs;
  var listProvinces = <String, String>{}.obs;
  var listDistricts = <String, String>{}.obs;
  var listWards = <String, String>{}.obs;

  var cccdFront = Rx<Uint8List?>(null); // CCCD mặt trước
  var cccdBack = Rx<Uint8List?>(null); // CCCD mặt sau
  var gplxFront = Rx<Uint8List?>(null); // GPLX mặt trước
  var gplxBack = Rx<Uint8List?>(null); // GPLX mặt sau

  final apiAdministrativeUnit = ApiAdministrativeUnit();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProvinces();
  }

  void fetchProvinces() async {
    try {
      String endpoint = 'province';
      Map<String, dynamic> params = {};
      // Gọi API
      final response =
          await apiAdministrativeUnit.getAdministrativeUnit(endpoint, params);
      // Xử lý dữ liệu trả về
      if (response.statusCode == 200) {
        dynamic json = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> data = json['data'];
        listProvinces.value = {
          for (var item in data)
            item['ProvinceName'] as String: item['ProvinceID'].toString()
        };
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchDistricts() async {
    try {
      String endpoint = 'district';
      Map<String, dynamic> params = {"province_id": province.value};
      // Gọi API
      final response =
          await apiAdministrativeUnit.getAdministrativeUnit(endpoint, params);
      // Xử lý dữ liệu trả về
      if (response.statusCode == 200) {
        dynamic json = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> data = json['data'];
        listDistricts.value = {
          for (var item in data)
            item['DistrictName'] as String: item['DistrictID'].toString()
        };
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchWard() async {
    try {
      String endpoint = 'ward';
      Map<String, dynamic> params = {"district_id": district.value};
      // Gọi API
      final response =
          await apiAdministrativeUnit.getAdministrativeUnit(endpoint, params);
      // Xử lý dữ liệu trả về
      if (response.statusCode == 200) {
        dynamic json = jsonDecode(utf8.decode(response.bodyBytes));
        print("==================================wart ${json}");
        List<dynamic> data = json['data'];
        listWards.value = {
          for (var item in data)
            item['WardName'] as String: item['WardCode'].toString()
        };
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
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

  void setCccdFrontImage(Uint8List image) {
    cccdFront.value = image;
  }

  void setCccdBackImage(Uint8List image) {
    cccdBack.value = image;
  }

  void setGplxFrontImage(Uint8List image) {
    gplxFront.value = image;
  }

  void setGplxBackImage(Uint8List image) {
    gplxBack.value = image;
  }
}
