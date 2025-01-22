import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:looptracker_mobile/app/routes/app_routes.dart';

class AuthenticationController extends GetxController {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  var userId = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var gender = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var avatarUrl = ''.obs; // Thêm avatarUrl
  var isLogin = false.obs;
  var role = ''.obs;
  var jwtToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() async {
    // Đọc dữ liệu từ storage
    userId.value = await storage.read(key: 'user_id') ?? '';
    firstName.value = await storage.read(key: 'first_name') ?? '';
    lastName.value = await storage.read(key: 'last_name') ?? '';
    gender.value = await storage.read(key: 'gender') ?? '';
    email.value = await storage.read(key: 'email') ?? '';
    phoneNumber.value = await storage.read(key: 'phone_number') ?? '';
    avatarUrl.value = await storage.read(key: 'avatar_url') ?? '';
    jwtToken.value = await storage.read(key: 'jwt_token') ?? '';
    role.value = await storage.read(key: 'user_role') ?? '';
    isLogin.value = jwtToken.value.isNotEmpty;
  }

  Future<void> updateData({
    String? newUserId,
    String? newFirstName,
    String? newLastName,
    String? newGender,
    String? newEmail,
    String? newPhoneNumber,
    String? newAvatarUrl,
    String? newRole,
    String? newToken,
  }) async {
    if (newUserId != null) {
      userId.value = newUserId;
      await storage.write(key: 'user_id', value: newUserId);
    }
    if (newFirstName != null) {
      firstName.value = newFirstName;
      await storage.write(key: 'first_name', value: newFirstName);
    }
    if (newLastName != null) {
      lastName.value = newLastName;
      await storage.write(key: 'last_name', value: newLastName);
    }
    if (newGender != null) {
      gender.value = newGender;
      await storage.write(key: 'gender', value: newGender);
    }
    if (newEmail != null) {
      email.value = newEmail;
      await storage.write(key: 'email', value: newEmail);
    }
    if (newPhoneNumber != null) {
      phoneNumber.value = newPhoneNumber;
      await storage.write(key: 'phone_number', value: newPhoneNumber);
    }
    if (newAvatarUrl != null) { // Cập nhật avatarUrl
      avatarUrl.value = newAvatarUrl;
      await storage.write(key: 'avatar_url', value: newAvatarUrl); // Lưu avatarUrl vào storage
    }
    if (newRole != null) {
      role.value = newRole;
      await storage.write(key: 'user_role', value: newRole);
    }
    if (newToken != null) {
      jwtToken.value = newToken;
      await storage.write(key: 'jwt_token', value: newToken);
    }
  }

  void login(String token, String userRole, String id, {String? avatar}) async {
    jwtToken.value = token;
    role.value = userRole;
    userId.value = id;
    isLogin.value = true;

    await storage.write(key: 'jwt_token', value: token);
    await storage.write(key: 'user_role', value: userRole);
    await storage.write(key: 'user_id', value: id);
    if (avatar != null) { // Lưu avatar nếu có
      avatarUrl.value = avatar;
      await storage.write(key: 'avatar_url', value: avatar);
    }
  }

  void logout() async {
    jwtToken.value = '';
    role.value = '';
    userId.value = '';
    avatarUrl.value = '';
    isLogin.value = false;
    firstName.value = '';
    lastName.value = '';
    gender.value = '';
    email.value = '';
    phoneNumber.value = '';

    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'user_role');
    await storage.delete(key: 'user_id');
    await storage.delete(key: 'first_name');
    await storage.delete(key: 'last_name');
    await storage.delete(key: 'gender');
    await storage.delete(key: 'email');
    await storage.delete(key: 'phone_number');
    await storage.delete(key: 'avatar_url');

    Get.offNamed(AppRoutes.LOGIN);
    // Xóa avatarUrl khỏi storage
  }
}
