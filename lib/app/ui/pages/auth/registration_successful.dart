import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RegistrationSuccessful extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Biểu tượng thành công với hiệu ứng nhấp nháy
              Center(
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                    CurvedAnimation(
                      parent: AnimationController(
                        vsync: TestVSync(),
                        duration: const Duration(milliseconds: 300),
                      )..repeat(reverse: true),
                      curve: Curves.elasticInOut,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 120,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                alignment: Alignment.center,
                child: Text(
                  "Gửi đơn đăng ký thành công!",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign:TextAlign.center
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints(maxWidth: 680),
                child: Text(
                  "Chúng tôi rất vui mừng thông báo rằng đơn đăng ký của bạn đã được nhận. Chúng tôi sẽ xem xét và phản hồi lại kết quả trong thời gian sớm nhất thông qua email mà bạn đã đăng ký.\n\n"
                      "Nếu bạn có bất kỳ câu hỏi nào, xin vui lòng liên hệ với chúng tôi.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Trân trọng,\nĐội ngũ LoopTracker",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              // Nút thoát
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/login");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Màu nền của nút
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    "Thoát",
                    style: TextStyle(fontSize: 18,color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tạo một lớp TestVSync để sử dụng cho AnimationController
class TestVSync extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
