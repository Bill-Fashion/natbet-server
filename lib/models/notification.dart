class NotificationModel {
  final String? roomId;
  final String? title;
  final String? content;
  final String? timestamp;

  NotificationModel({this.title, this.content, this.timestamp, this.roomId});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        roomId: json["roomId"],
        title: json["title"],
        content: json["content"],
        timestamp: json["timestamp"],
      );

  NotificationModel.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        roomId = map['roomId'],
        content = map['content'],
        timestamp = map['timestamp'];
}
