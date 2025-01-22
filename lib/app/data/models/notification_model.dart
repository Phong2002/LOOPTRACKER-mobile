class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final String actionKey;
  final DateTime? createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.actionKey,
    this.createdAt,
    this.isRead = false,
  });

  // Phương thức đánh dấu thông báo là đã đọc
  void markAsRead() {
    isRead = true;
  }

  // Phương thức khởi tạo từ JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      actionKey: json['actionKey'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      isRead: json['isRead'] is bool ? json['isRead'] : json['isRead'] == 'true',
    );
  }
}
