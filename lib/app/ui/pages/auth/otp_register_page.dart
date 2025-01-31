import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:looptracker_mobile/app/controllers/auth/otp_register_controller.dart';

import '../../../controllers/auth/register_controller.dart';

class OtpRegisterPage extends StatelessWidget {
  final RegisterController registerController = Get.find();
final OtpRegisterController otpRegisterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            height: 680.h,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage("assets/images/otp/otp.png"),
                    alignment: Alignment.center)),
          ),
          Obx(()=>

            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 50.h,horizontal: 100.h),
                child: Text("Bạn vui lòng nhập mã xác thực chúng tôi vừa gửi về địa chỉ email : ${registerController.email.value}",textAlign: TextAlign.center,
                style: TextStyle(fontSize: 45.sp,fontWeight: FontWeight.w500),
                )
            ),
          ),

          OtpTextField(
            numberOfFields: 5,
            borderColor: Color(0xFF512DA8),
            showFieldAsBox: true,
            fieldWidth: 150.h,
            textStyle: TextStyle(fontSize: 60.sp,fontWeight: FontWeight.bold,color: Colors.blue),
            onCodeChanged: (String code) {
              print(code);
            },
            onSubmit: (String verificationCode) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Verification Code"),
                      content: Text('Code entered is $verificationCode'),
                    );
                  });
            }, // end onSubmit
          ),
        ]),
      ),
    );
  }
}
