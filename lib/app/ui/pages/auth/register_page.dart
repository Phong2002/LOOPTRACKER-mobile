import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:looptracker_mobile/app/controllers/auth/register_controller.dart';
import '../../widgets/common/DatePickerFieldCustomer.dart';
import '../../widgets/common/SelectBottomSheetCustomer.dart';
import '../../widgets/common/SelectCustomer.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController registerController = Get.find();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: Colors.white, // Dark green accent
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 50.h),
          child: Form(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextFormField(
                        label: "Họ",
                        onChanged: (value) =>
                        registerController.firstName.value = value,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 3,
                      child: CustomTextFormField(
                        label: "Tên đệm và tên",
                        onChanged: (value) =>
                        registerController.lastName.value = value,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Obx(() =>
                          SelectBottomSheetCustomer(
                            label: "Giới tính",
                            options: const {
                              'Nam': 'MAN',
                              'Nữ': 'WOMAN',
                              'Khác': 'OTHER',
                            },
                            selectedValue: registerController.gender.value,
                            onChanged: (entry) {
                              registerController.gender.value = entry.value;
                            },
                          ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 3,
                      child: Obx(() =>
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 30.h),
                            child: DatePickerField(
                              selectedDate: registerController.dateOfBirth.value,
                              onDateChanged: (DateTime? newDate) {
                                registerController.dateOfBirth.value = newDate;
                              },
                              label: 'Ngày sinh',
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Obx(() =>
                    SelectBottomSheetCustomer(
                      label: "Tỉnh",
                      options: registerController.listProvinces,
                      selectedValue: registerController.province.value,
                      onChanged: (entry) {
                        registerController.province.value = entry.value;
                        registerController.handleSelectProvince();
                      },
                    ),
                ),
                SizedBox(height: 20.h),
                Obx(() =>
                    SelectBottomSheetCustomer(
                      label: "Huyện",
                      options: registerController.listDistricts,
                      selectedValue: registerController.district.value,
                      onChanged: (entry) {
                        registerController.district.value = entry.value;
                        registerController.handleSelectDistrict();
                      },
                    ),
                ),
                SizedBox(height: 20.h),
                Obx(() =>
                    SelectBottomSheetCustomer(
                      label: "Xã",
                      options: registerController.listWards,
                      selectedValue: registerController.ward.value,
                      onChanged: (entry) {
                        registerController.ward.value = entry.value;
                      },
                    ),
                ),
                SizedBox(height: 20.h),
                CustomTextFormField(
                  label: "Số điện thoại",
                  onChanged: (value) =>
                  registerController.phoneNumber.value = value,
                ),
                SizedBox(height: 20.h),
                CustomTextFormField(
                  label: "Email",
                  onChanged: (value) =>
                  registerController.email.value = value,
                ),
                SizedBox(height: 20.h),
                CustomTextFormField(
                  label: "Số CCCD/CMND",
                  onChanged: (value) =>
                  registerController.citizenIdentification.value = value,
                ),
                SizedBox(height: 20.h),
                CustomTextFormField(
                  label: "Số giấy phép lái xe",
                  onChanged: (value) =>
                  registerController.licenseNumber.value = value,
                ),
                SizedBox(height: 30.h),
                InkWell(
                  onTap: () {
                    Get.toNamed("/photo_identification_verification");
                  },
                  child: Container(
                    height: 120.h,
                    width: 600.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green[800], // Dark green accent
                      borderRadius: BorderRadius.circular(20.h),
                    ),
                    child: Text(
                      "Tiếp tục",
                      style: TextStyle(color: Colors.white, fontSize: 50.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 30.h),
      child: TextFormField(
        onChanged: onChanged,
        style: TextStyle(fontSize: 45.sp),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: TextStyle(
            fontSize: 22,
            color: Colors.green[800], // Dark green accent
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
