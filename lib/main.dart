import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:natbet/screens/auth_screens/login.dart';
import 'package:natbet/services/auth.dart';
import 'package:natbet/services/local_notification.dart';
import 'package:natbet/wrapper.dart';
import 'package:provider/provider.dart';
import 'models/notification.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;

  NotificationModel notificationContents =
      NotificationModel.fromMap(jsonDecode(data['notification']));

  LocalNotificationService.display(notificationContents);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          lazy: false,
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.red,
          primaryColorDark: Colors.red,
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          dividerColor: Colors.black12,
        ),
        home: Consumer<AuthService>(
          builder: (context, user, child) {
            if (user.isLoggedIn()) {
              return Wrapper();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
