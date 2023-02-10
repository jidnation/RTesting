class NotificationsModel {
  final String id;
  final String authId;
  final String data;
  final bool isRead;
  final String title;
  final String message;

  NotificationsModel({
    required this.id,
    required this.authId,
    required this.data,
    required this.isRead,
    required this.title,
    required this.message,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
      id: json['id'],
      authId: json['authId'],
      data: json['data'],
      isRead: json['isRead'],
      title: json['title'],
      message: json['message']);
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['authId'] = authId;
    data['data'] = this.data;
    data['isRead'] = isRead;
    data['title'] = title;
    data['message'] = message;
    return data;
  }
}
