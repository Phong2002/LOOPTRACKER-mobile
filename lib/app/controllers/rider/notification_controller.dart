import 'dart:convert';
import 'package:get/get.dart';
import 'package:looptracker_mobile/app/services/api_service.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:math';
import '../../data/models/notification_model.dart';
import '../../services/notification_service.dart';

class NotificationController extends GetxController {
  StompClient? stompClient;
  var notifications = <NotificationModel>[].obs;
  var tourInstanceId = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void connect(String userId) {
    getAllNotification(userId);
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'http://10.0.2.2:8080/ws',
        onConnect: (frame) => onConnect(frame, userId),
        onWebSocketError: (dynamic error) => print("WebSocket Error: $error"),
      ),
    );
    stompClient!.activate();
  }

  void onConnect(StompFrame frame, String userId) {
    if (userId.isEmpty) {
      print("User ID is empty");
      return;
    }
    print("User ID: $userId");
    stompClient!.subscribe(
      destination: '/queue/user.$userId',
      callback: (frame) {
        if (frame.body != null) {
          print(frame.body!);
          Map<String, dynamic> jsonData = jsonDecode(frame.body!);

          // Kiểm tra và trích xuất thông tin từ trường 'notification'
          if (jsonData.containsKey('notification')) {
            Map<String, dynamic> notificationJson = jsonData['notification'];

            // Thêm các trường 'id' và 'isRead' từ JSON gốc vào JSON của thông báo
            notificationJson['id'] = jsonData['id'];
            notificationJson['isRead'] = jsonData['isRead'];

            // Tạo đối tượng NotificationModel từ JSON
            NotificationModel notification = NotificationModel.fromJson(notificationJson);

            // Thêm thông báo vào danh sách
            notifications.add(notification);

            NotificationService().showNotification(
              id: notification.id,
              title: notification.title,
              body: notification.message,
            );
          }
        }
      },
    );
  }

  Future<void> getAllNotification(String userId) async {
    try {
      String endpoint = 'user-notifications/get-all';
      Map<String, String?> data = {
        "userId": userId,
        'size': '100',
        'sort': 'notification_id,desc',
      };
      final response = await ApiService.getData(endpoint, data);
      // Kiểm tra mã trả về
      if (response.statusCode == 200) {
        // response.data trong DIO thường đã được parse thành Map<String, dynamic> nếu content-type là JSON
        final jsonData = response.data;
        // Đảm bảo jsonData là một Map
        if (jsonData is Map<String, dynamic>) {
          final content = jsonData['content'];
          // Đảm bảo content là một List
          if (content is List) {
            notifications.clear(); // Xóa danh sách cũ nếu muốn
            for (var item in content) {
              if (item is Map<String, dynamic> && item.containsKey('notification')) {
                final notificationJson = item['notification'];
                if (notificationJson is Map<String, dynamic>) {
                  // Thêm id và isRead từ item bên ngoài
                  notificationJson['id'] = item['id'];
                  notificationJson['isRead'] = item['isRead'];
                  // Tạo NotificationModel
                  NotificationModel notification = NotificationModel.fromJson(notificationJson);

                  notifications.add(notification);
                  // Hiển thị thông báo nếu cần
                  NotificationService().showNotification(
                    id: notification.id,
                    title: notification.title,
                    body: notification.message,
                  );
                }
              }
            }
            print("Lấy được ${notifications.length} thông báo.");
          } else {
            print("`content` không phải là một danh sách.");
          }
        } else {
          print("Dữ liệu trả về không phải là Map<String, dynamic>.");
        }
      } else {
        print("Failed to get notification, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in notification: $e");
    }
  }


  void markNotificationAsRead(int index) {
    notifications[index].markAsRead();
    notifications.refresh();
  }

  void markNotificationAsUnread(int index) {
    notifications[index].isRead = false;
    notifications.refresh();
  }

  @override
  void onClose() {
    stompClient?.deactivate();
    super.onClose();
  }
}
