import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountLockedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài khoản bị khóa'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 100,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'Tài khoản của bạn đã bị khóa!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Vui lòng liên hệ với bộ phận hỗ trợ để biết thêm thông tin.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Get.offNamed('/login'); // Thay đổi thành route tương ứng
                },
                child: Text('Quay lại trang đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
