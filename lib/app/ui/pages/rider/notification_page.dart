import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/rider/notification_controller.dart';
import '../../../data/models/notification_model.dart';
import 'notification_detail_page.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController notificationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông báo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[600],
        elevation: 2,
        centerTitle: true,
      ),
      body: Obx(() {
        if (notificationController.notifications.isEmpty) {
          return Center(
            child: Text(
              "Không có thông báo",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
                _showMarkAsUnreadDialog(context, index);
              },
              onTap: () {
                notificationController.markNotificationAsRead(index);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => NotificationDetailPage(notification: notificationController.notifications[index]),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: _buildNotificationTile(notificationController.notifications[index]),
            );
          },
        );
      }),
    );
  }

  void _showMarkAsUnreadDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Đánh dấu là chưa xem"),
          content: Text("Bạn có chắc chắn muốn đánh dấu thông báo này là chưa xem không?"),
          actions: [
            TextButton(
              onPressed: () {
                notificationController.markNotificationAsUnread(index);
                Get.back();
              },
              child: Text("Đánh dấu"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Hủy"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    String formattedTime = _formatDate(notification.createdAt!);

    // Màu nền
    Color backgroundColor = notification.isRead ? Colors.green[100]! : Colors.green[50]!;
    Color titleColor = notification.isRead ? Colors.green[800]! : Colors.black;
    Color subtitleColor = notification.isRead ? Colors.green[600]! : Colors.grey[600]!;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: notification.isRead ? Colors.green[200]! : Colors.green[400]!,
            child: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          subtitle: Text(
            'Lúc: $formattedTime',
            style: TextStyle(
              fontSize: 12,
              color: subtitleColor,
            ),
          ),
          trailing: Icon(
            notification.isRead ? Icons.check_circle : Icons.circle,
            color: notification.isRead ? Colors.green[400]! : Colors.green[600]!,
          ),
        ),
      ),
    );
  }
  String _formatDate(DateTime date) {
    return "${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year} ";
  }
}
