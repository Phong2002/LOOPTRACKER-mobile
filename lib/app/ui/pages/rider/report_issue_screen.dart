import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../../controllers/rider/easy_rider/report_issue_controller.dart';
import '../../widgets/common/select_bottom_sheet_customer.dart';

class ReportIssueScreen extends StatelessWidget {
  final ReportIssueController controller = Get.put(ReportIssueController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo sự cố',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green[600], // Darker green
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Obx(
                    () => SelectBottomSheetCustomer(
                  options: const {
                    'VEHICLE_ISSUE': 'Phương tiện hư hỏng',
                    'ACCIDENT': 'Tai nạn',
                    'OTHER': 'Khác',
                  },
                  selectedValue: controller.selectedIssueType.value,
                  label: 'Chọn loại sự cố',
                  onChanged: (entry) {
                    controller.selectedIssueType.value = entry.key;
                  },
                ),
              ),
              SizedBox(height: 16),

              // Mô tả
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green[600]!), // Darker green border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.green[600]!), // Lighter green on focus
                  ),
                ),
                onChanged: (value) {
                  controller.description.value = value;
                },
              ),
              SizedBox(height: 16),

              // Select người liên quan
              Obx(
                    () => SelectBottomSheetCustomer(
                  options: controller.listUserInTour.value,  // Đảm bảo sử dụng Map<String, String> ở đây
                  selectedValue: controller.selectedPerson.value,
                  label: 'Chọn người liên quan',
                  onChanged: (entry) {
                    controller.selectedPerson.value = entry.key;
                  },
                ),
              ),

              SizedBox(height: 16),

              // Hiển thị danh sách ảnh và nút thêm ảnh
              Obx(
                    () => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: controller.images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.images.length) {
                      // Nút thêm ảnh
                      return GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green[600]!), // Darker green border
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.green[600]!.withOpacity(0.1), // Lighter background
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.green[600], // Darker green icon
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    }
                    // Hiển thị ảnh
                    return GestureDetector(
                      onTap: () => _viewFullImage(index),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          File(controller.images[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),

              // Nút gửi báo cáo
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    controller.sendRegistrationRequest();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600], // Darker green button
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: const Text('Gửi báo cáo',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewFullImage(int index) {
    Get.dialog (Stack(
    children: [
      // Nền mờ
      Container(
        color: Colors.black54,
      ),
      // Hiển thị ảnh
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PhotoViewGallery.builder(
                itemCount: controller.images.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: FileImage(File(controller.images[index].path)),
                  );
                },
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                pageController: PageController(initialPage: index),
              ),
            ),
            SizedBox(height: 16),

            // Nút chức năng
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    controller.removeImage(index);
                    Get.back();
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text('Xóa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.close, color: Colors.white),
                  label: Text('Đóng'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600], // Darker green for close button
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    ],
    ));
  }
}