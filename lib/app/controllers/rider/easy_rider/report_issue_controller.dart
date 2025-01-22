import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:looptracker_mobile/app/controllers/rider/tour_instance_controller.dart';
import '../../../services/api_service.dart';
import 'package:dio/dio.dart' as dio;

import '../../../utils/location_util.dart';

class ReportIssueController extends GetxController {
  var selectedIssueType = Rxn<String>();
  var description = ''.obs;
  var damageCost = 0.obs;
  var selectedPerson = Rxn<String>();
  var images = <XFile>[].obs;
  var listUserInTour = <String, String>{}.obs;
  final ImagePicker _picker = ImagePicker();
  final TourInstanceController tourInstanceController = Get.find();

  @override
  void onInit() async {
    super.onInit();
    print("=====================okê1");
    getListUserInTour();
  }

  /// Lấy danh sách người dùng trong tour
  Future<void> getListUserInTour() async {
    print("=====================okê2");

    try {
      String endpoint = 'tour-assignment/get-by-tour-instance';
      Map<String, String?> data = {"tourInstanceId": tourInstanceController.tourInstanceId.value};
      final response = await ApiService.getData(endpoint, data);
      if (response.statusCode == 200 && response.data != null) {
        processTourData(response.data['content'] as List);
      } else {
        print("Failed to fetch list of users, Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in getListUserInTour: $e");
    }
  }

  /// Chọn hình ảnh từ máy ảnh
  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        images.add(pickedFile);
        print("Image picked: ${pickedFile.path}");
      }
    } catch (e) {
      print("Error in pickImage: $e");
    }
  }

  /// Xóa hình ảnh khỏi danh sách
  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      print("Image removed at index $index");
    } else {
      print("Invalid index for image removal: $index");
    }
  }

  Future<bool> sendRegistrationRequest() async {
    var locationData = await LocationUtil.getCurrentLocation();

    try {
      final data = {
        "incidentType": selectedIssueType.value,
        "description": description.value,
        "damageCost": damageCost.value,
        "latitude": locationData?.latitude.toString(),
        "longitude": locationData?.longitude.toString(),
        "tourAssignments": selectedPerson.value,
        "involvedRole": "EasyRider"
      };

      final formData = dio.FormData.fromMap({
        'incident': jsonEncode(data),
        for (var image in images)
          'images': await dio.MultipartFile.fromBytes(await image.readAsBytes(), filename: 'image.png')
      });

      final response = await ApiService.postFormData('incident/create', formData);

      if (response.statusCode == 200) {
        print('Gửi thành công: ${response.data}');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Lỗi xảy ra khi gửi yêu cầu đăng ký: $e');
      return false;
    }
  }



void processTourData(List jsonString) {
    for (var item in jsonString) {

      String key = item['id'];
      String value;

      // Check if rider exists and assign appropriate value
      if (item['rider'] != null) {
        value = item['rider']['lastName'] + ' ' +  item['rider']['firstName'];
      } else {
        value = item['passenger']['firstName'] + ' ' +  item['passenger']['lastName'];
      }

      listUserInTour[key] = value;
      print("=============key - "+key);
      print("=============value - "+value);
    }
  }



  /// Danh sách người được chọn giả lập
  List<String> get persons => ['Người 1', 'Người 2', 'Người 3'];
}