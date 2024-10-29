import 'package:get/get.dart';

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var message = ''.obs;
  var isLoading = false.obs;
  var isPasswordView = false.obs;

  void login() async {
    message.value = "";
    if (username.value.isEmpty&&password.value.isEmpty){
      message.value = "Vui lòng nhập đủ thông tin !";
      return;
    }
    isLoading.value = true;

    await Future.delayed(Duration(seconds: 2));

    if (username.value == 'admin' && password.value == 'admin') {
      Get.snackbar('Success', 'Login successful!');
    } else {
      Get.snackbar('Error', 'Invalid username or password');
    }

    isLoading.value = false;
  }

  void togglePasswordView(){
    isPasswordView.value = !isPasswordView.value;
  }
}