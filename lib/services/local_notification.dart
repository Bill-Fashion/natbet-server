import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:natbet/models/notification.dart';
import 'package:natbet/screens/main_screens/room.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? roomDocId) async {
      if (roomDocId != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoomScreen(roomDocId: roomDocId)));
      }
    });
    // );
  }

  static void display(NotificationModel notificationContents) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "natbetnotification",
        "natbetnotification channel",
        importance: Importance.max,
        priority: Priority.high,
      ));

      await _notificationsPlugin.show(id, notificationContents.title,
          notificationContents.content, notificationDetails,
          payload: notificationContents.roomId);
    } on Exception catch (e) {
      print(e);
    }
  }
}
