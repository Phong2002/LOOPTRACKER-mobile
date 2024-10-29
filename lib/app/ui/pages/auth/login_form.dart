import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/auth/login_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find();

    return Container(
        margin: EdgeInsets.all(100.h),
        padding: EdgeInsets.symmetric(vertical: 100.h, horizontal: 60.h),
        width: 400,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.3),
            borderRadius: BorderRadius.circular(100.h)),
        child: Form(
            child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tài khoản",
                    style: TextStyle(color: Colors.white, fontSize: 50.sp),
                  ),
                  TextFormField(
                    onChanged: (value) =>
                        loginController.username.value = value,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 0.8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60.h),
                            borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 30.h, horizontal: 30.h)),
                    style: TextStyle(fontSize: 50.sp),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mật khẩu",
                    style: TextStyle(color: Colors.white, fontSize: 50.sp),
                  ),
                  Obx(() => TextFormField(
                        onChanged: (value) =>
                            loginController.password.value = value,
                        obscureText: loginController.isPasswordView.value,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(255, 255, 255, 0.8),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginController.isPasswordView.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                loginController.togglePasswordView();
                              },
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60.h),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 30.h, horizontal: 30.h)),
                        style: TextStyle(fontSize: 50.sp),
                      ))
                ],
              ),
            ),
            Obx(()=>
                Container(
                  alignment: Alignment.center,
                  height: 120.h,
                  child: Text(loginController.message.value,style: TextStyle(color: Colors.red,fontSize: 50.h),),

            )),
            Obx(() => InkWell(
                  onTap: () {
                    if (!loginController.isLoading.value) {
                      loginController.login();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 600.h,
                    height: 130.h,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 251, 85, 0.7),
                        borderRadius: BorderRadius.circular(100.h)),
                    child: !loginController.isLoading.value
                        ? Text(
                            "Đăng nhập",
                            style:
                                TextStyle(fontSize: 50.sp, color: Colors.white),
                          )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Đang đăng nhập ",
                                  style: TextStyle(
                                      fontSize: 50.sp, color: Colors.white)),
                              SizedBox(
                                  height: 50.h,
                                  width: 50.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ))
                            ],
                          ),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 50.h),
              child: Column(
                children: [
                  Text("Bạn muốn trở thành Easy Rider ?",style: TextStyle(color: Colors.white,fontSize: 40.sp),),
                  InkWell(
                    onTap: (){
                      Get.toNamed("/register");
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20.h),
                      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 100.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(30.h)
                      ),
                      child: Text("Đăng ký ngay",style: TextStyle(color: Colors.white,fontSize: 40.sp)),
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }
}
