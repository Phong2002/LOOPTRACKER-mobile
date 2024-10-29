import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:looptracker_mobile/app/ui/pages/auth/login_form.dart';

import '../../../controllers/auth/login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.find();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/login_background.jpg"),
                    alignment: Alignment.topLeft)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: SingleChildScrollView(
                child: Container(
                  padding:  EdgeInsets.only(top: 200.h),
                  child: Column(
                    children: [
                      _HeaderText(),
                       LoginForm(),

                    ],
                  ),
                ),
              ),
            )));
  }

  Widget _HeaderText() {
    return Container(
      child:  Text(
        "LOOP TRACKER",
        style: TextStyle(
          color: const Color.fromARGB(1000, 0, 120, 63),
          fontSize: 150.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 30.h,
          height: 3.h,
          shadows: const [
            Shadow(
              blurRadius: 8.0,
              color: Colors.white,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

}


