import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:looptracker_mobile/app/routes/app_routes.dart';
import '../../../controllers/auth/authentication_controller.dart';
import '../../../controllers/rider/rider_infor_controller.dart';
import '../../../utils/render_enum.dart';

class RiderInfo extends StatelessWidget {
  final RiderInforController riderInforController = Get.find();
  final AuthenticationController authenticationController = Get.find();
  static final String baseUrlGetFile = "${dotenv.env['API_SERVER_URL']}:${dotenv.env['API_SERVER_PORT']}/${dotenv.env['API_PREFIX']}file/image/download/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông Tin Cá Nhân"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade300, // Start color
                      Colors.red.shade600, // End color
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: const Row(
                  mainAxisSize: MainAxisSize.min, // Prevents Row from taking unnecessary space
                  children: [
                    Icon(Icons.logout, color: Colors.white), // Change icon color to white for better contrast
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Đăng xuất",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Change text color to white for better visibility
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Section
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Obx(()=> Image.network(
                        baseUrlGetFile+riderInforController.avatarUrl.value,
                        width: 800.h,
                        height: 800.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 800.h,
                            height: 800.h,
                            color: Colors.grey[300],
                            child: Icon(Icons.person, color: Colors.grey, size: 800.h),
                          );
                        },
                      )) ,
                    )
                    ,
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _showImagePickerDialog(context);
                      },
                      child: Text("Cập Nhật Ảnh Đại Diện"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Information Card
              Card(
                elevation: 5,
                shadowColor: Colors.greenAccent,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        infoRow("Họ và Tên:", "${riderInforController.lastName.value} ${riderInforController.firstName.value}"),
                        infoRow("Giới Tính:",RenderEnum.renderGender(riderInforController.gender.value) ),
                        infoRow("Địa Chỉ:", riderInforController.address.value),
                        infoRow("Số Điện Thoại:", riderInforController.phoneNumber.value),
                        infoRow("Email:", riderInforController.email.value),
                        infoRow("Số CCCD:", riderInforController.cccd.value),
                        infoRow("Số GPLX:", riderInforController.gplx.value),
                        Center(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.green),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            onPressed: () {
                              _showEditDialog(context);
                            },
                            child: Text("Cập Nhật Thông Tin", style: TextStyle(color: Colors.green, fontSize: 16)),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              // Action Buttons
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                      onPressed: () {
                        Get.toNamed(AppRoutes.CHANGE_PASSWORD_PAGE);
                      },
                      child: Text("Đổi Mật Khẩu", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Convert the picked file to Uint8List
      final Uint8List imageData = await pickedFile.readAsBytes();
      _showPreviewImageDialog(context, imageData);
    }
  }

  void _showPreviewImageDialog(BuildContext context, Uint8List imageData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Ảnh đại diện mới",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(
                imageData,
                width: MediaQuery.of(context).size.width * 0.8, // Adjust width based on screen size
                height: MediaQuery.of(context).size.width * 0.8, // Maintain aspect ratio
                fit: BoxFit.cover,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Show loading indicator
                Get.dialog(
                  Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                bool isSuccess = false;
                try {
                  // Call updateAvatar
                  isSuccess = await riderInforController.updateAvatar(imageData);
                } catch (e) {
                  // Handle error if updateAvatar throws
                  print("Error updating avatar: $e");
                } finally {
                  // Remove loading indicator
                  Get.back();
                }

                if (isSuccess) {
                  Get.back(); // Close the preview dialog
                  Get.snackbar(
                    "Cập nhật thành công",
                    "Bạn đã cập nhật ảnh đại diện thành công!",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    "Cập nhật thất bại",
                    "Ảnh đại diện cập nhật không thành công!",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text(
                "Cập Nhật",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }


  void _showEditDialog(BuildContext context) {
    final TextEditingController addressController = TextEditingController(text: riderInforController.address.value);
    final TextEditingController emailController = TextEditingController(text: riderInforController.email.value);
    final TextEditingController phoneNumberController = TextEditingController(text: riderInforController.phoneNumber.value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Chỉnh Sửa Thông Tin"),
          content: Container(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: "Địa Chỉ"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(labelText: "Số Điện Thoại"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Obx(() {
                    return Text(
                      riderInforController.updateInforErrorMessage.value,
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Get.dialog(
                  Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                bool isSuccess = await riderInforController.updateInfor(
                  addressController.text,
                  emailController.text,
                  phoneNumberController.text,
                );

                Get.back(); // Close loading indicator

                if (isSuccess) {
                  Get.back(); // Close dialog
                  // Show success alert
                  Get.snackbar(
                    "Cập nhật thành công",
                    "Thông tin của bạn đã được cập nhật thành công!",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text("Cập nhật", style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                riderInforController.updateInforErrorMessage.value = "";
                Get.back(); // Close dialog
              },
              child: Text("Hủy", style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }



  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Xác nhận đăng xuất"),
          content: Text("Bạn có chắc chắn muốn đăng xuất?",style: TextStyle(fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text("Hủy",style: TextStyle(fontSize: 16),),
            ),
            TextButton(
              onPressed: () {
                authenticationController.logout();
                Get.back();
              },
              child: Text("Đăng Xuất", style: TextStyle(color: Colors.redAccent,fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}
