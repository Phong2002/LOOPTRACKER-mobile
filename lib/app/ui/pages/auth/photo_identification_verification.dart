import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:looptracker_mobile/app/controllers/auth/register_controller.dart';
import 'package:looptracker_mobile/app/ui/widgets/common/camera_common.dart';

class PhotoIdentificationVerification extends StatelessWidget {
  final RegisterController registerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác minh CCCD & GPLX'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const Text(
              'Chụp ảnh xác minh:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(11, 150, 42, 0.8),
              ),
            ),
            const SizedBox(height: 16),
            _buildPhotoTile(
              'CCCD Mặt Trước',
              registerController.cccdFront,
              () => _openCamera(context, registerController.setCccdFrontImage),
            ),
            const SizedBox(height: 16),
            _buildPhotoTile(
              'CCCD Mặt Sau',
              registerController.cccdBack,
              () => _openCamera(context, registerController.setCccdBackImage),
            ),
            const SizedBox(height: 16),
            _buildPhotoTile(
              'GPLX Mặt Trước',
              registerController.gplxFront,
              () => _openCamera(context, registerController.setGplxFrontImage),
            ),
            const SizedBox(height: 16),
            _buildPhotoTile(
              'GPLX Mặt Sau',
              registerController.gplxBack,
              () => _openCamera(context, registerController.setGplxBackImage),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút gửi yêu cầu
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(11, 150, 42, 0.8),
                  // Mã màu RGB
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Gửi Yêu Cầu',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTile(
      String title, Rx<Uint8List?> file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Container(
              height: 200,
              width: 200 * 1.58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(11, 150, 42, 0.8)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: file.value != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        file.value!,
                        fit: BoxFit.cover,
                        width: 200 * 1.58,
                        height: 200,
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt,
                              color: Color.fromRGBO(11, 150, 42, 0.8),
                              size: 40),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style:
                                const TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCamera(BuildContext context, Function(Uint8List) onCapture) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraCommon(
          aspectRatio: 1.58,
          onCapture: onCapture,
        ),
      ),
    );
  }
}
