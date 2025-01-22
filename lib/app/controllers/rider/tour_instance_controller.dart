import 'package:get/get.dart';
import 'package:looptracker_mobile/app/controllers/auth/authentication_controller.dart';
import 'package:looptracker_mobile/app/controllers/rider/rider_infor_controller.dart';
import 'package:stomp_dart_client/stomp.dart';
import '../../services/api_service.dart';
import './map_tracking_controller.dart';

class TourInstanceController extends GetxController {
  StompClient? stompClient;
  var tourInstanceId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    initTourInstance();
  }

  void initTourInstance() {
    RiderInforController riderInforController = Get.find();
    AuthenticationController authenticationController = Get.find();
    print("===================OKE0");
    if(riderInforController.riderStatus.value == "ON_TRIP"){
      print("===================OKE1");
      getTourInstanceId(authenticationController.userId.value);
    }
    else{
      tourInstanceId.value = '';
    }
  }

Future<void> getTourInstanceId(String userId) async {
  try {
    String endpoint = 'tour-instance/get-by-rider';
    Map<String, String?> data = {
      "rider": userId,
    };
    final response = await ApiService.getData(endpoint, data);

    if (response.statusCode == 200) {
      print("=============== userId ${response}");
      tourInstanceId.value = response.data;

      // Kiểm tra nếu chưa tồn tại controller thì khởi tạo
      if (!Get.isRegistered<MapControllerX>()) {
        Get.put(MapControllerX(), permanent: true); // Khởi tạo controller
      }
    } else {
      print("Failed to get tour instance id");
    }
  } catch (e) {
    print("Error in getTourInstanceId: $e");
  }
}

}
