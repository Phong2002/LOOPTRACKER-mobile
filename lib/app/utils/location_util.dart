import 'package:location/location.dart';

class LocationUtil {
  static final Location _location = Location();

  // Hàm kiểm tra và yêu cầu quyền truy cập vị trí
  static Future<LocationData?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Kiểm tra xem dịch vụ vị trí có được bật không
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      // Nếu dịch vụ vị trí chưa được bật, yêu cầu người dùng bật lên
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    // Kiểm tra quyền truy cập vị trí
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }

    // Lấy thông tin vị trí
    return await _location.getLocation();
  }
}
