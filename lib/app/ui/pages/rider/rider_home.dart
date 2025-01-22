import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../controllers/rider/rider_infor_controller.dart';

class RiderHome extends StatelessWidget {
  final RiderInforController riderInforController =
  Get.put(RiderInforController());

  final List<String> imagePaths = [
    'assets/images/slider/hagiang_loop_1.jpg',
    'assets/images/slider/hagiang_loop_2.jpg',
    'assets/images/slider/hagiang_loop_3.jpg',
    'assets/images/slider/hagiang_loop_4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo/looptracker_logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            Obx(() => Text(
              'Xin chào, ${riderInforController.lastName.value.isEmpty ? "..." : riderInforController.lastName.value} ${riderInforController.firstName.value.isEmpty ? "..." : riderInforController.firstName.value}!',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            )),
            SizedBox(width: 8),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
              ),
              items: imagePaths.map((path) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        path,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Chào mừng đến với Hà Giang Loop!',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Là một Easy Rider, bạn sẽ đồng hành cùng khách trong hành trình khám phá Hà Giang. Mỗi chuyến đi là một cơ hội để tạo ra những kỷ niệm khó quên và mang đến những trải nghiệm đáng nhớ cho mọi người.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Obx(() => Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Text(
                  //         'Sẵn sàng đồng hành: ',
                  //         style: TextStyle(
                  //             fontSize: 18, color: Colors.green[900]),
                  //       ),
                  //       Switch(
                  //         value: riderInforController.riderStatus.value ==
                  //             "READY",
                  //         onChanged:
                  //         riderInforController.riderStatus.value !=
                  //             "ON_TRIP"
                  //             ? (bool newValue) {
                  //           riderInforController
                  //               .toggleAvailability(newValue);
                  //         }
                  //             : (bool newValue) {
                  //           Get.snackbar(
                  //             "Thông báo",
                  //             "Không thể thay đổi trạng thái vì đang tham gia tour",
                  //             snackPosition: SnackPosition.TOP,
                  //             backgroundColor: Colors.redAccent,
                  //             colorText: Colors.white,
                  //             duration: Duration(seconds: 2),
                  //           );
                  //         },
                  //         activeColor: Colors.green,
                  //       ),
                  //     ],
                  //   ),
                  // )),
                  Obx(() {
                    String currentStatus =
                        riderInforController.riderStatus.value;
                    String statusMessage;
                    IconData statusIcon;
                    Color iconColor;
                    Color bgColor;

                    switch (currentStatus) {
                      case "NOT_READY":
                        statusMessage =
                        "Chưa sẵn sàng! Nếu bạn đang trong giai đoạn hồi phục hoặc có chút trục trặc, hãy nhanh chóng lấy lại sức mạnh. Những cung đường tuyệt vời đang chờ đón bạn, và hành trình thú vị sắp tới sẽ không trọn vẹn nếu thiếu bạn!";
                        statusIcon = FontAwesomeIcons.exclamationTriangle;
                        iconColor = Colors.yellow;
                        bgColor = Colors.orange[300]!;
                        break;
                      case "READY":
                        statusMessage =
                        "Sẵn sàng! Bạn đã chuẩn bị cho một hành trình đầy màu sắc! Hãy để những chuyến đi của bạn trở thành những kỷ niệm khó quên cho khách hàng. Mong bạn sớm được đồng hành, chinh phục những cung đường tuyệt đẹp cùng nhau!";
                        statusIcon = FontAwesomeIcons.checkCircle;
                        iconColor = Colors.green[700]!;
                        bgColor = Colors.green[400]!;
                        break;
                      case "ON_TRIP":
                        statusMessage =
                        "Đang trong chuyến đi! Hãy thỏa sức khám phá những cảnh sắc tuyệt vời và mang đến niềm vui cho khách hàng. Chúc bạn và hành khách có những khoảnh khắc đầy ắp tiếng cười và trải nghiệm đáng nhớ trên mỗi chặng đường!";
                        statusIcon = FontAwesomeIcons.solidHeart;
                        iconColor = Colors.pink;
                        bgColor = Colors.blue[300]!;
                        break;
                      default:
                        statusMessage =
                        "Trạng thái không xác định. Đừng ngần ngại liên hệ để được hỗ trợ và chuẩn bị cho hành trình tiếp theo!";
                        statusIcon = Icons.help;
                        iconColor = Colors.white;
                        bgColor = Colors.grey[500]!;

                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                statusIcon,
                                size: 30,
                                color: iconColor,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Trạng thái hiện tại',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            statusMessage,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Obx(() {
                            final createAt = riderInforController.createAt.value;
                            return InfoCard(
                              icon: FontAwesomeIcons.calendarCheck,
                              title: 'Ngày đồng hành cùng chúng tôi',
                              value: createAt != null
                                  ? DateTime.now()
                                  .difference(createAt)
                                  .inDays
                                  .toString()
                                  : "0",
                              bgColor: Colors.lightBlue[50]!,
                              titleColor: Colors.blue[700]!,
                              valueColor: Colors.blue[900]!,
                            );
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Obx(() {
                            return InfoCard(
                              icon: FontAwesomeIcons.route,
                              title: 'Chuyến đi cùng với khách',
                              value: riderInforController.totalTrips.value
                                  ?.toString() ??
                                  "0",
                              bgColor: Colors.lightGreen[50]!,
                              titleColor: Colors.green[700]!,
                              valueColor: Colors.green[900]!,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color bgColor;
  final Color titleColor;
  final Color valueColor;

  InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.bgColor,
    required this.titleColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: titleColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: titleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
